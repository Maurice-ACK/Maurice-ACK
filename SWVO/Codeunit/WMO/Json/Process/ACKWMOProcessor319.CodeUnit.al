/// <summary>
/// Codeunit ACKWMOProcessor319 (ID 50017).
/// </summary>
codeunit 50018 ACKWMOProcessor319 implements ACKWMOIProcessor
{
    var
        WMOHeader319: Record ACKWMOHeader;
        WMOAntwoord: Record ACKWMOAntwoord;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOProcessor: codeunit ACKWMOProcessor;
    //TR355Err: Label 'TR355: ReferentieAanbieder in het antwoordbericht komt voor in een eerder verzoek om toewijzing of verzoek om wijziging';

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader319 := WMOHeader;
    end;

    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader319.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader319.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader319, ACKVektisCode::wmo319) then
            exit(false);

        WMOAntwoord.Get(WMOHeader319.SystemId);

        if not ReferenceVOTVOWExists() then
            exit(false);

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader319) then
            exit(false);

        exit(true);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader319);

        if Validate() then begin
            WMOProcessor.CreateRetour(WMOHeader319);
            WMOHeader319.Status := ACKWMOHeaderStatus::Send;
        end
        else begin
            WMOProcessor.CreateRetour(WMOHeader319);
            WMOHeader319.Status := ACKWMOHeaderStatus::InvalidRetourCreated;
        end;

        WMOHeader319.Modify(true);
    end;

    local procedure ReferenceVOTVOWExists(): Boolean;
    var
        NewChangedUnchangedProductQ: Query ACKNewChangedUnchangedProductQ;
    begin
        //ToDo add municipality and healthcareprovider to range
        NewChangedUnchangedProductQ.SetRange(NewChangedUnchangedProductQ.Status, ACKWMOHeaderStatus::Send);
        NewChangedUnchangedProductQ.SetRange(NewChangedUnchangedProductQ.ReferentieAanbieder, WMOAntwoord.ReferentieAanbieder);

        if NewChangedUnchangedProductQ.Open() and NewChangedUnchangedProductQ.Read() then
            exit(true)
        else begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOAntwoord, WMOAntwoord.SystemId, WMOHeader319.SystemId, ACKWMORule::TR355);
            exit(false);
        end;

        exit(true);
    end;
}