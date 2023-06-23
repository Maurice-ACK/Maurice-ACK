/// <summary>
/// Codeunit ACKWMOProcessor307 (ID 50034).
/// </summary>
codeunit 50033 ACKWMOProcessor307 implements ACKWMOIProcessor
{
    var
        WMOHeader307: Record ACKWMOHeader;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOProcessor: codeunit ACKWMOProcessor;

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader307 := WMOHeader;
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader307.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader307.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    var
        WMOClient: Record ACKWMOClient;
        WMOStopProduct: Record ACKWMOStartStopProduct;
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader307, ACKVektisCode::wmo307) then
            exit(false);

        WMOClient.SetRange(HeaderId, WMOHeader307.SystemId);

        if not WMOClient.FindFirst() then
            exit(false);

        //Stop producten
        WMOStopProduct.SetRange(ClientId, WMOClient.SystemId);
        if WMOStopProduct.FindSet() then
            repeat
                ValidateStopProduct(WMOClient, WMOStopProduct);
            until WMOStopProduct.Next() = 0;

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader307) then
            exit(false);

        exit(true);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader307);

        if Validate() then begin
            WMOProcessor.CreateRetour(WMOHeader307);
            WMOHeader307.Status := ACKWMOHeaderStatus::Send;
        end
        else begin
            WMOHeader307.Status := ACKWMOHeaderStatus::InvalidRetourCreated;
            WMOProcessor.CreateRetour(WMOHeader307);
        end;

        WMOHeader307.Modify(true);
    end;

    local procedure DuplicateEntries(WMOStopProduct: Record ACKWMOStartStopProduct) IsValid: Boolean
    var
        ACKStartStopProductQ: Query ACKStartStopProductQ;
    begin
        IsValid := true;
        ACKStartStopProductQ.SetFilter(ACKStartStopProductQ.Id, '<>%1', WMOStopProduct.Id);
        ACKStartStopProductQ.SetFilter(ACKStartStopProductQ.RedenBeeindiging, '<>%1', 0);
        ACKStartStopProductQ.SetRange(ACKStartStopProductQ.ToewijzingNummer, WMOStopProduct.ToewijzingNummer);
        ACKStartStopProductQ.SetRange(ACKStartStopProductQ.ClientSystemId, WMOStopProduct.ClientId);

        if ACKStartStopProductQ.Open() then
            if ACKStartStopProductQ.Read() then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR101);
                IsValid := false;
            end;
        ACKStartStopProductQ.Close();
    end;

    /// <summary>
    /// ValidateStopProduct.
    /// </summary>
    /// <param name="WMOClient">Record ACKWMOClient.</param>
    /// <param name="WMOStopProduct">Record ACKWMOStartStopProduct.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ValidateStopProduct(WMOClient: Record ACKWMOClient; WMOStopProduct: Record ACKWMOStartStopProduct)
    var
        WMOIndication: Record ACKWMOIndication;
        IndicationTempStop: Record ACKIndicationTempStop;
        IndicationQuery: Query ACKWMOIndicationQuery;
    begin
        //TR019
        if WMOStopProduct.ToewijzingNummer = 0 then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR019);
            exit;
        end;

        IndicationQuery.SetRange(MunicipalityNo, WMOHeader307.Ontvanger);
        IndicationQuery.SetRange(SSN, WMOClient.SSN);
        IndicationQuery.SetRange(AssignmentNo, WMOStopProduct.ToewijzingNummer);
        IndicationQuery.Open();

        if not IndicationQuery.Read() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR019);
            exit;
        end;

        WMOIndication.Get(IndicationQuery.IndicationID);

        //TR101
        if not DuplicateEntries(WMOStopProduct) then
            exit;

        //TR018
        if WMOStopProduct.Einddatum < WMOStopProduct.Begindatum then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR018);

        //TR134
        if WMOStopProduct.Einddatum > WMOHeader307.Dagtekening then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR134);

        if (IndicationQuery.EffectiveStartDate <> WMOStopProduct.Begindatum) then
            if (IndicationQuery.StartDate <> WMOStopProduct.Begindatum) then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR019);
                exit;
            end;

        if WMOStopProduct.ToewijzingIngangsdatum <> 0D then
            //ToewijzingsIngangsdatum moet gelijk zijn aan de Ingangsdatum van het toegewezen product in het Toewijzingbericht. 
            if WMOStopProduct.ToewijzingIngangsdatum <> IndicationQuery.StartDate then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::SW021);
                exit;
            end;

        //TR081
        WMOProcessor.TR081Check(IndicationQuery.ProductCode, WMOStopProduct.ProductCode, WMOStopProduct.ProductCategorie, WMOHeader307.SystemId, Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId);

        // Als er 1 actief dan mag je niet nog 1 inschieten.
        //Als er 1 afgesloten is, dan mag er geen nieuwe tijdelijke stop ingeschoten worden voordien.

        if WMOIndication.GetLastTempStop(IndicationTempStop) then
            if IndicationTempStop.StartDate > WMOStopProduct.Einddatum then
                MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR414);

        case WMOStopProduct.StatusAanlevering
        of
            ACKWMOStatusAanlevering::First:
                begin
                    //Tijdelijke stop mag niet actief zijn indien ...
                    if WMOStopProduct.RedenBeeindiging = ACKWMORedenBeeindiging::TijdelijkBeeindigd then
                        if WMOIndication.IsTempStopActive(WMOStopProduct.Einddatum) then
                            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR414);

                    //SWVO verplicht 305
                    if WMOIndication.EffectiveStartDate = 0D then
                        MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::SW022);

                    //TR308: Einddatum in ProductPeriode in Prestatie moet kleiner dan of gelijk zijn aan Einddatum in ToegewezenProduct, indien die gevuld is.
                    if WMOIndication.EndDate <> 0D then
                        if WMOStopProduct.Einddatum > WMOIndication.EndDate then
                            MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR308);

                end;
            ACKWMOStatusAanlevering::Deleted:
                //TR071
                if WMOIndication.EffectiveEndDate <> 0D then
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId, WMOHeader307.SystemId, ACKWMORule::TR071)
        end;
    end;
}