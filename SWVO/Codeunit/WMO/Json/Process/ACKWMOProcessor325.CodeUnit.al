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
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader325, ACKVektisCode::wmo325) then
            exit(false);

        WMOHeader325.GetToHeader(WMOHeader323, true);

        WMOClient.SetRange(HeaderId, WMOHeader325.SystemId);
        if WMOClient.FindSet() then
            repeat
                WMOProcessor.TR304_ExistingClient(WMOClient, WMOHeader325, ACKClient);
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

                    //Gets the declaration header from the 323 message.
                    WMODeclaration.Get(WMOHeader323.SystemId);
                    HealthcareMonth.GetFromDate(WMODeclaration.Begindatum);
                    ValidatePrestaties();
                end;

            WMOProcessor.Send(WMOHeader325);
        end;

        WMOHeader325.Modify(true);
    end;

    local procedure ValidatePrestaties()
    var
        WMOClient: Record ACKWMOClient;
        WMOPrestatie325: Record ACKWMOPrestatie;
    begin
        Clear(InvalidPrestaties);

        if not WMOProcessor.HasRetourCode(WMOHeader325, ACKRetourCode::"0200") then
            exit;

        WMODeclaratieAntwoord.Get(WMOHeader325.SystemId);

        //If the declaration answer does not contain 0200 or 8001 then nothing to process.
        if WMOProcessor.HasInvalidRetourCode(WMOHeader325.SystemId, Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId) or (WMODeclaratieAntwoord.ToegekendTotaalBedrag = 0) then begin
            SetStatusDeclaration(true);
            exit;
        end;

        WMOClient.SetRange(HeaderId, WMOHeader325.SystemId);
        if WMOClient.FindSet() then
            repeat
                WMOPrestatie325.SetRange(ClientID, WMOClient.SystemId);
                if WMOPrestatie325.FindSet() then
                    repeat
                        ValidateReferencePrestatie(WMOClient.SSN, WMOPrestatie325);
                        InvalidPrestaties.Add(WMOPrestatie325.ReferentieNummer);
                    until WMOPrestatie325.Next() = 0;
            until WMOClient.Next() = 0;

        SetStatusDeclaration(false);
    end;

    local procedure SetStatusDeclaration(CancelAll: Boolean)
    var
        WMODeclarationHeader: Record ACKWMODeclarationHeader;
        WMODeclarationLine: Record ACKWMODeclarationLine;
        TotalAmountApproved: Integer;
        LineIsApproved: Boolean;
    begin
        LineIsApproved := false;

        //Todo this should not be executed while validating but only from the process.

        WMODeclarationHeader.SetRange(HeaderId, WMOHeader323.SystemId);
        WMODeclarationHeader.SetFilter(Status, '<=%1', ACKWMODeclarationStatus::Approved);
        WMODeclarationHeader.FindFirst();

        WMODeclarationLine.SetRange(DeclarationHeaderNo, WMODeclarationHeader.DeclarationHeaderNo);

        if WMODeclarationLine.FindSet(true) then
            repeat
                if CancelAll = true then
                    WMODeclarationLine.Status := ACKWMODeclarationStatus::Canceled
                else
                    if InvalidPrestaties.Contains(WMODeclarationLine.Reference) then
                        WMODeclarationLine.status := ACKWMODeclarationStatus::Canceled
                    else begin
                        WMODeclarationLine.status := ACKWMODeclarationStatus::Approved;
                        TotalAmountApproved += WMODeclarationLine.Amount;
                        LineIsApproved := true;
                    end;

                WMODeclarationLine.Modify(true);

            until WMODeclarationLine.Next() = 0;

        if (TotalAmountApproved < 0) and (WMODeclaratieAntwoord.ToegekendDebitCredit = ACKDebitCredit::D) then
            MessageRetourCode.InsertRetourCode(Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, WMOHeader325.SystemId, ACKWMORule::TR367);

        if Abs(TotalAmountApproved) <> WMODeclaratieAntwoord.ToegekendTotaalBedrag then
            MessageRetourCode.InsertRetourCode(Database::ACKWMODeclaratieAntwoord, WMODeclaratieAntwoord.SystemId, WMOHeader325.SystemId, ACKWMORule::TR367);

        //Todo redefine status header and lines.
        if (CancelAll = true) or (LineIsApproved = false) then
            WMODeclarationHeader.Status := ACKWMODeclarationStatus::Canceled
        else
            WMODeclarationHeader.Status := ACKWMODeclarationStatus::Approved;

        WMODeclarationHeader.Modify(true);
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
}
