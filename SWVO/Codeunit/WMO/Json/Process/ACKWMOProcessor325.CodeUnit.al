/// <summary>
/// Codeunit ACKWMOProcessor323.
/// </summary>
codeunit 50029 ACKWMOProcessor325 implements ACKWMOIProcessor
{
    var
        WMOHeader325, WMOHeader323 : Record ACKWMOHeader;
        WMODeclaratieAntwoord: Record ACKWMODeclaratieAntwoord;
        WMODeclaration: Record ACKWMODeclaratie;
        HealthcareMonth: Record ACKHealthcareMonth;
        WMOProcessor: codeunit ACKWMOProcessor;
        WMODeclarationHelper: Codeunit ACKWMODeclarationHelper;
        InvalidPrestaties: List of [Text[20]];


    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader325 := WMOHeader;
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader325.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader325.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    var
        WMOClient: Record ACKWMOClient;
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader325, ACKVektisCode::wmo325) then
            exit(false);

        WMOHeader325.GetToHeader(WMOHeader323, true);

        WMOClient.SetRange(HeaderId, WMOHeader325.SystemId);
        if WMOClient.FindSet() then
            repeat
                WMOProcessor.TR304_ExistingClient(WMOClient, WMOHeader325);
            until WMOClient.Next() = 0;

        exit(true);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    var
        WMOClient: Record ACKWMOClient;
        WMOPrestatie: Record ACKWMOPrestatie;
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader325);

        if Validate() then begin
            if not WMOProcessor.HeaderContainsRetourCodeInvalid(WMOHeader325) then
                if WMODeclaratieAntwoord.Get(WMOHeader325.SystemId) then begin
                    if WMOProcessor.HasInvalidRetourCode(WMOHeader325.SystemId, Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId) then begin
                        WMOProcessor.Send(WMOHeader325);
                        exit;
                    end;

                    GetInvalidPrestaties();
                    WMODeclaration.Get(WMOHeader323.SystemId);
                    HealthcareMonth.GetFromDate(WMODeclaration.Begindatum);
                    CreateDeclaration();
                end;
            // if WMOProcessor.HasRetourCode(WMOHeader325.SystemId, Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, '8001') then begin

            //    
            // end;

            // else
            //     if WMOClient.FindSet() then
            //         repeat
            //             WMOPrestatie.SetRange(ClientId, WMOClient.SystemId);

            //             if WMOPrestatie.FindSet() then
            //                 repeat
            //                     if not WMOProcessor.HasInvalidRetourCode(WMOHeader325.SystemId, Database::ACKWMOPrestatie, WMOPrestatie.SystemId) then
            //                         CreateDeclaration();
            //                 until WMOPrestatie.Next() = 0;
            //         until WMOClient.Next() = 0;

            WMOProcessor.Send(WMOHeader325);
        end;

        WMOHeader325.Modify(true);
    end;

    local procedure GetInvalidPrestaties()
    var
        WMOClient: Record ACKWMOClient;
        WMOPrestatie: Record ACKWMOPrestatie;
    begin
        //1. XSD validation
        //2. Declaratie identificatie = bericht identificatie 323
        //3. Indien afkeur op XSD / XSLT = retourcode 0001 op header
        //4. Check if header contains invalid retour code.
        //5. Als het declaratie antwoord 8001 bevat is het gehele declaratie bericht goedgekeurd.
        //7. Als het declaratie antwoord bericht 0200 bevat is de declaratie deels goedgekeurd. 

        //If the header does not contain retourcode 0200 then nothing to process.

        Clear(InvalidPrestaties);

        if not WMOProcessor.HasRetourCode(WMOHeader325, '0200') then
            exit;

        WMODeclaratieAntwoord.Get(WMOHeader325.SystemId);

        //If the declaration answer does not contain 0200 or 8001 then nothing to process.
        if WMOProcessor.HasInvalidRetourCode(WMOHeader325.SystemId, Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId) then
            exit;

        WMOClient.SetRange(HeaderId, WMOHeader325.SystemId);
        if WMOClient.FindSet() then
            repeat
                WMOPrestatie.SetRange(ClientID, WMOClient.SystemId);
                if WMOPrestatie.FindSet() then
                    repeat
                        InvalidPrestaties.Add(WMOPrestatie.ReferentieNummer);
                    until WMOPrestatie.Next() = 0;
            until WMOClient.Next() = 0;
    end;

    local procedure CreateDeclaration()
    var
        WMODeclarationHeader: Record ACKWMODeclarationHeader;
        WMODeclarationLine: Record ACKWMODeclarationLine;
        WMOClient: Record ACKWMOClient;
        WMOPrestatie: Record ACKWMOPrestatie;
        WMOIndication: Record ACKWMOIndication;
        Rate: Integer;
    begin
        WMODeclarationHeader.SetRange(HeaderId, WMOHeader323.SystemId);
        if WMODeclarationHeader.FindFirst() then
            exit;

        WMODeclarationHeader.Init();
        WMODeclarationHeader.HeaderId := WMOHeader323.SystemId;
        WMODeclarationHeader.MunicipalityNo := WMOHeader323.Ontvanger;
        WMODeclarationHeader.HealthcareProviderNo := WMOHeader323.Afzender;
        WMODeclarationHeader.DeclarationNo := WMODeclaration.DeclaratieNummer;
        WMODeclarationHeader.DeclarationDate := WMODeclaration.DeclaratieDagtekening;
        WMODeclarationHeader.Year := HealthcareMonth.Year;
        WMODeclarationHeader.Month := HealthcareMonth.Month.AsInteger();
        WMODeclarationHeader.Status := ACKWMODeclarationStatus::New;
        WMODeclarationHeader.Insert(true);

        WMOClient.SetRange(HeaderId, WMOHeader323.SystemId);
        if WMOClient.FindSet() then
            repeat
                WMOPrestatie.SetRange(ClientID, WMOClient.SystemId);
                if WMOPrestatie.FindSet() then
                    repeat
                        if not InvalidPrestaties.Contains(WMOPrestatie.ReferentieNummer) then begin
                            WMOIndication.SetRange(MunicipalityNo, WMOHeader323.Ontvanger);
                            WMOIndication.SetRange(AssignmentNo, WMOPrestatie.ToewijzingNummer);
                            WMOIndication.FindFirst();

                            Rate := WMODeclarationHelper.GetHealthcareMonthRate(WMOPrestatie.ProductCode, WMOPrestatie.Eenheid, HealthcareMonth.Year, HealthcareMonth.Month.AsInteger());

                            Clear(WMODeclarationLine);
                            WMODeclarationLine.Init();
                            WMODeclarationLine.DeclarationHeaderNo := WMODeclarationHeader.DeclarationHeaderNo;
                            WMODeclarationLine.IndicationID := WMOIndication.ID;
                            WMODeclarationLine.ClientNo := WMOIndication.ClientNo;
                            WMODeclarationLine.AssignmentNo := WMOPrestatie.ToewijzingNummer;
                            WMODeclarationLine.MunicipalityNo := WMOHeader323.Ontvanger;
                            WMODeclarationLine.HealthcareProviderNo := WMOHeader323.Afzender;
                            WMODeclarationLine.Reference := WMOPrestatie.ReferentieNummer;
                            WMODeclarationLine.PreviousReference := WMOPrestatie.VorigReferentieNummer;
                            WMODeclarationLine.ProductCategoryId := WMOPrestatie.ProductCategorie;
                            WMODeclarationLine.ProductCode := WMOPrestatie.ProductCode;
                            WMODeclarationLine.StartDate := WMOPrestatie.Begindatum;
                            WMODeclarationLine.EndDate := WMOPrestatie.Einddatum;
                            WMODeclarationLine.Unit := WMOPrestatie.Eenheid;
                            WMODeclarationLine.Volume := WMOPrestatie.GeleverdVolume;

                            if WMOPrestatie.DebetCredit = ACKDebitCredit::D then
                                WMODeclarationLine.Amount := WMOPrestatie.Bedrag
                            else
                                WMODeclarationLine.Amount := -WMOPrestatie.Bedrag;

                            WMODeclarationLine.ProductRate := Rate;
                            WMODeclarationLine.Insert(true);
                        end;
                    until WMOPrestatie.Next() = 0;
            until WMOClient.Next() = 0;
    end;
}
