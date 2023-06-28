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
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOProcessor: codeunit ACKWMOProcessor;
        WMODeclarationHelper: Codeunit ACKWMODeclarationHelper;
        ACKHelper: Codeunit ACKHelper;
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
        ACKClient: Record ACKClient;
        TotalAmountDeclarationHeader: Integer;
        AmountCheckErr: Label 'Totaal toegekend bedrag 325 komt niet overeen met declaratie.';
    begin
        Clear(InvalidPrestaties);

        if not WMOProcessor.ValidateHeader(WMOHeader325, ACKVektisCode::wmo325) then
            exit(false);

        //Get header of the 323
        if not WMOHeader325.GetToHeader(WMOHeader323, true) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, WMOHeader325.SystemId, WMOHeader325.SystemId, ACKWMORule::TR337);
            exit(false);
        end;

        //Get the declaratie record from the 323
        WMODeclaration.Get(WMOHeader323.SystemId);

        //Get the declaratie antwoord record of the 325
        WMODeclaratieAntwoord.Get(WMOHeader325.SystemId);

        //TR376
        if WMODeclaratieAntwoord.DeclaratieNummer <> WMODeclaration.DeclaratieNummer then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, WMOHeader325.SystemId, ACKWMORule::TR376);
            exit(false);
        end;

        //8001 means fully approved.
        if WMOProcessor.HasRetourCode(WMOHeader325.SystemId, Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, ACKRetourCode::"8001") then begin
            //Double check the amounts of the 323 and the 325
            if (WMODeclaration.DebitCredit <> WMODeclaratieAntwoord.ToegekendDebitCredit) or (WMODeclaration.TotaalBedrag <> WMODeclaratieAntwoord.ToegekendTotaalBedrag) then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, WMOHeader325.SystemId, ACKWMORule::SW026);
                exit(false);
            end;

            TotalAmountDeclarationHeader := WMODeclarationHelper.GetTotalAmountDeclaredByDeclarationNo(WMOHeader325.Ontvanger, WMODeclaratieAntwoord.DeclaratieNummer);

            if Abs(TotalAmountDeclarationHeader) <> WMODeclaratieAntwoord.ToegekendTotaalBedrag then begin
                //Check total amount saved in the declaration header, this is more likely to be a problem in BC then a fault from the providers.
                ACKHelper.AddWmoEventLog(WMODeclaratieAntwoord, Severity::Error, AmountCheckErr);
                exit(false);
            end;

            exit(true);
        end;

        WMOClient.SetRange(HeaderId, WMOHeader325.SystemId);
        if WMOClient.FindSet() then
            repeat
                if WMOProcessor.TR304_ExistingClient(WMOClient, WMOHeader325, ACKClient) then
                    ValidatePrestatie(WMOClient);
            until WMOClient.Next() = 0;

        exit(true);
    end;

    local procedure ValidatePrestatie(var WMOClient: Record ACKWMOClient)
    var
        WMOPrestatie: Record ACKWMOPrestatie;
    begin
        WMOPrestatie.SetRange(ClientID, WMOClient.SystemId);
        if WMOPrestatie.FindSet() then
            repeat
                ValidateReferencePrestatie(WMOClient.SSN, WMOPrestatie);
                InvalidPrestaties.Add(WMOPrestatie.ReferentieNummer);
            until WMOPrestatie.Next() = 0;
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader325);

        if Validate() then begin
            HealthcareMonth.GetFromDate(WMODeclaration.Begindatum);
            SetStatusDeclaration();
        end;

        WMOProcessor.Send(WMOHeader325);
        WMOHeader325.Modify(true);
    end;

    local procedure ValidateReferencePrestatie(SSN: Code[9]; WMOPrestatie: Record ACKWMOPrestatie): Boolean
    var
        RelatedPrestatieQuery: Query ACKWMOPrestatieQuery;
    begin
        if WMOPrestatie.VorigReferentieNummer = '' then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader325.SystemId, ACKWMORule::TR366);
            exit(false);
        end;

        RelatedPrestatieQuery.SetFilter(RelatedPrestatieQuery.PrestatieSystemId, '<>%1', WMOPrestatie.SystemId);
        RelatedPrestatieQuery.SetRange(RelatedPrestatieQuery.Afzender, WMOHeader325.Ontvanger);
        RelatedPrestatieQuery.SetRange(RelatedPrestatieQuery.SSN, SSN);
        RelatedPrestatieQuery.SetRange(RelatedPrestatieQuery.ReferentieNummer, WMOPrestatie.VorigReferentieNummer);

        if RelatedPrestatieQuery.Open() and RelatedPrestatieQuery.Read() then begin
            //TR366 and TR367
            if (RelatedPrestatieQuery.SSN <> SSN) or
                (RelatedPrestatieQuery.ProductCategorie <> WMOPrestatie.ProductCategorie) or
                (RelatedPrestatieQuery.ProductCode <> WMOPrestatie.ProductCode) or
                (RelatedPrestatieQuery.ToewijzingNummer <> WMOPrestatie.ToewijzingNummer) or
                (RelatedPrestatieQuery.Begindatum <> WMOPrestatie.Begindatum) or
                (RelatedPrestatieQuery.Einddatum <> WMOPrestatie.Einddatum) or
                (RelatedPrestatieQuery.GeleverdVolume <> WMOPrestatie.GeleverdVolume) or
                (RelatedPrestatieQuery.Eenheid <> WMOPrestatie.Eenheid) or
                (RelatedPrestatieQuery.DebitCredit <> WMOPrestatie.DebitCredit) or
                (RelatedPrestatieQuery.Bedrag <> WMOPrestatie.Bedrag) then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader325.SystemId, ACKWMORule::TR367);
                exit(false);
            end else
                exit(true);
        end else begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader325.SystemId, ACKWMORule::TR366);
            exit(false);
        end;

        exit(true);
    end;

    local procedure SetStatusDeclaration()
    var
        WMODeclarationHeader: Record ACKWMODeclarationHeader;
        WMODeclarationLine: Record ACKWMODeclarationLine;
        TotalAmountApproved: Integer;
        NoHeaderFoundMsg: Label 'No declaration found.';
    begin
        WMODeclarationHeader.SetRange(HeaderId, WMOHeader323.SystemId);
        WMODeclarationHeader.SetFilter(Status, '<=%1', ACKWMODeclarationStatus::Approved);

        //If the header is not found then there should be no declaration lines to approve either. Also totaal toegekend bedrag should be 0?
        //However totaal toegekend bedrag could also be 0 if there are credit and debit records that sum up to 0.
        if not WMODeclarationHeader.FindFirst() then begin
            ACKHelper.AddWmoEventLog(WMOHeader325, Severity::Warning, NoHeaderFoundMsg);
            exit;
        end;

        WMODeclarationLine.SetRange(DeclarationHeaderNo, WMODeclarationHeader.DeclarationHeaderNo);

        if WMODeclarationLine.FindSet(true) then
            repeat
                if InvalidPrestaties.Contains(WMODeclarationLine.Reference) then
                    WMODeclarationLine.status := ACKWMODeclarationStatus::Rejected
                else begin
                    WMODeclarationLine.status := ACKWMODeclarationStatus::Approved;
                    TotalAmountApproved += WMODeclarationLine.Amount;
                end;

                WMODeclarationLine.Modify(true);

            until WMODeclarationLine.Next() = 0;

        if (TotalAmountApproved < 0) and (WMODeclaratieAntwoord.ToegekendDebitCredit = ACKDebitCredit::D) then
            MessageRetourCode.InsertRetourCode(Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, WMOHeader325.SystemId, ACKWMORule::TR367);

        if Abs(TotalAmountApproved) <> WMODeclaratieAntwoord.ToegekendTotaalBedrag then
            MessageRetourCode.InsertRetourCode(Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, WMOHeader325.SystemId, ACKWMORule::TR367);

        WMODeclarationHeader.Status := ACKWMODeclarationStatus::Approved;
        WMODeclarationHeader.Modify(true);
    end;
}
