/// <summary>
/// Codeunit ACKWMOProcessor305 (ID 50032).
/// </summary>
codeunit 50031 ACKWMOProcessor305 implements ACKWMOIProcessor
{
    var
        WMOHeader305: Record ACKWMOHeader;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOProcessor: codeunit ACKWMOProcessor;
        WMODeclarationHelper: Codeunit ACKWMODeclarationHelper;
        AssignmentMarkedDeleted: Dictionary of [Integer, Boolean];
    //SW007Err: Label 'SW007: Start/Stop berichten moet niet de waarde status aanlevering: 3 bevatten indien al een declaratie verwerkt is voor de toewijzing. (Som van de debet declaraties > 0) ';
    //SW008Err: Label 'SW008: Start/Stop berichten mogen niet gewijzigd worden met status aanlevering: 2 indien al een declaratie verwerkt is binnen de periode waarvoor de datum gewijzigd wordt. (Som van de debet declaraties > 0) ';
    //SW014Err: Label 'SW014: Begindatum startzorg bericht mag niet voor de ingangsdatum van de toewijzing liggen.';
    //SW019Err: Label 'SW019: Indien StatusAanlevering de waarde 1 bevat en een tijdelijke stop is actief dan mag de begindatum niet voor de ingangsdatum van de tijdelijke stop zijn.';
    //SW020Err: Label 'SW020: Bij Start/Stop bericht, als product gegevens worden meegegeven dan moeten deze gelijk zijn aan product in toegewezen product.';
    //SW021Err: Label 'SW021: Bij Start/Stop bericht, als toewijzingsingangsdatum wordt gevuld dan moet deze gelijk zijn aan de ingangsdatum van het toegewezen product.';
    //TR019Err: Label 'TR019: Bij een output- of inspanningsgerichte werkwijze moet de melding van de start of de stop van de ondersteuning gerelateerd zijn aan een toewijzing op basis van het ToewijzingNummer';
    //TR063Err: Label 'TR063: Indien StatusAanlevering de waarde 3 (aanlevering verwijderen) bevat, dan moet voor de betreffende Client een eerdere aanlevering met dezelfde logische sleutel verstuurd zijn.';
    //TR071Err: Label 'TR071: StatusAanlevering mag niet de waarde ''3'' bevatten als er voor de betreffende melding start zorg al een stop zorg is verstuurd.';
    //TR074Err: Label 'TR074: Indien StatusAanlevering de waarde ''1'' bevat, dan moet de sleutel van de betreffende aanlevering niet alleen uniek zijn binnen het bericht zelf, maar ook in combinatie met alle reeds ontvangen berichten.';
    //TR326Err: Label 'TR326: Een Startbericht mag pas verstuurd worden als er géén actueel Startbericht bij ToegewezenProduct is.';
    //TR381Err: Label 'TR381: ProductCode vullen met een code die, volgens de gehanteerde productcodelijst, past bij de ProductCategorie.';


    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader305 := WMOHeader;
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader305.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader305.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    var
        WMOClient: Record ACKWMOClient;
        WMOStartProduct: Record ACKWMOStartStopProduct;
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader305, ACKVektisCode::wmo305) then
            exit(false);

        WMOClient.SetRange(HeaderId, WMOHeader305.SystemId);

        if not WMOClient.FindFirst() then
            exit(false);

        //Start product
        WMOStartProduct.SetRange(ClientId, WMOClient.SystemId);
        if WMOStartProduct.FindSet() then
            repeat
                if ValidateStartProduct(WMOClient, WMOStartProduct) then
                    exit(false);
            until WMOStartProduct.Next() = 0;

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader305) then
            exit(false);

        exit(true);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader305);

        if Validate() then
            WMOProcessor.Send(WMOHeader305)
        else
            WMOHeader305.SetStatus(ACKWMOHeaderStatus::InvalidRetourCreated);

        WMOHeader305.Modify(true);

        Commit();
        WMOProcessor.CreateRetour(WMOHeader305);
    end;

    /// <summary>
    /// ValidateStartProduct.
    /// </summary>
    /// <param name="WMOClient">Record ACKWMOClient.</param>
    /// <param name="WMOStartProduct">Record ACKWMOStartStopProduct.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ValidateStartProduct(WMOClient: Record ACKWMOClient; WMOStartProduct: Record ACKWMOStartStopProduct): Boolean
    var
        WMOIndication: Record ACKWMOIndication;
        IndicationTempStop: Record ACKIndicationTempStop;
        IndicationQuery: Query ACKWMOIndicationQuery;
        CurrentEffectiveStartDate: Date;
    begin
        IndicationQuery.SetRange(MunicipalityNo, WMOHeader305.Ontvanger);
        IndicationQuery.SetRange(SSN, WMOClient.SSN);
        IndicationQuery.SetRange(AssignmentNo, WMOStartProduct.ToewijzingNummer);
        IndicationQuery.Open();

        if not IndicationQuery.Read() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::TR019);
            exit(false);
        end;

        WMOIndication.Get(IndicationQuery.IndicationID);

        //Use the current effective startdate to determine the effective startdate of the indication because it can be marked as deleted within the same xml with statusaanlevering 3.
        if AssignmentMarkedDeleted.ContainsKey(IndicationQuery.AssignmentNo) then
            CurrentEffectiveStartDate := 0D
        else
            CurrentEffectiveStartDate := IndicationQuery.EffectiveStartDate;

        //TR019
        if WMOStartProduct.ToewijzingNummer = 0 then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::TR019);
            exit(false);
        end;

        //TR081
        WMOProcessor.TR081Check(WMOIndication.ProductCode, WMOStartProduct.ProductCode, WMOStartProduct.ProductCategorie, WMOHeader305.SystemId, Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId);

        if WMOStartProduct.ToewijzingIngangsdatum <> 0D then
            //ToewijzingsIngangsdatum moet gelijk zijn aan de Ingangsdatum van het toegewezen product in het Toewijzingbericht. 
            if WMOStartProduct.ToewijzingIngangsdatum <> WMOIndication.StartDate then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::SW021);
                exit(false);
            end;

        WMOIndication.GetTempStop(IndicationTempStop, WMOStartProduct.Begindatum);

        //Start product begindatum mag niet voor de ingangsdatum van de indicatie liggen.
        if WMOStartProduct.Begindatum < WMOIndication.StartDate then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::SW014);
            exit(false);
        end;

        //Status aanlevering
        //TR063: Indien StatusAanlevering de waarde 3 (aanlevering verwijderen) bevat, dan moet voor de betreffende Client een eerdere aanlevering met dezelfde logische sleutel verstuurd zijn.
        //TR071: StatusAanlevering mag niet de waarde '3' bevatten als er voor de betreffende melding start zorg al een stop zorg is verstuurd.
        //TR074: Indien StatusAanlevering de waarde '1' bevat, dan moet de sleutel van de betreffende aanlevering niet alleen uniek zijn binnen het bericht zelf, maar ook in combinatie met alle reeds ontvangen berichten.
        //TR326: Een Startbericht mag pas verstuurd worden als er géén actueel Startbericht bij ToegewezenProduct is.
        case WMOStartProduct.StatusAanlevering
        of
            ACKWMOStatusAanlevering::First:
                begin
                    //TR326
                    if CurrentEffectiveStartDate <> 0D then
                        MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::TR326);

                    if IndicationTempStop.IsEmpty() then begin
                        if CurrentEffectiveStartDate <> 0D then begin
                            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::TR074);
                            exit(false);
                        end;
                    end else
                        //SW019
                        if WMOStartProduct.Begindatum < IndicationTempStop.StartDate then
                            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::SW019);
                end;
            ACKWMOStatusAanlevering::Deleted:
                begin
                    //Here we don't need to use the variable CurrentEffectiveStartDate.

                    //TR063
                    if WMOStartProduct.Begindatum <> WMOIndication.EffectiveStartDate then begin
                        MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::TR063);
                        exit(false);
                    end;

                    //TR071 
                    if WMOIndication.EffectiveEndDate <> 0D then
                        MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::TR071);

                    //SW007
                    if WMODeclarationHelper.GetTotalAmountDeclaredAssignment(WMOHeader305.Ontvanger, WMOHeader305.Afzender, WMOIndication.ClientNo, WMOIndication.AssignmentNo) > 0 then
                        MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStartProduct.SystemId, WMOHeader305.SystemId, ACKWMORule::SW007);

                    AssignmentMarkedDeleted.Add(WMOStartProduct.ToewijzingNummer, true);
                end;
        end;
    end;
}