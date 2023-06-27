/// <summary>
/// Codeunit ACKWMOProcessor317 (ID 50016).
/// </summary>
codeunit 50017 ACKWMOProcessor317 implements ACKWMOIProcessor
{
    var
        WMOHeader317: Record ACKWMOHeader;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOProcessor: codeunit ACKWMOProcessor;

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader317 := WMOHeader;
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader317.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader317.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    var
        WMOClient: Record ACKWMOClient;
        ACKClient: Record ACKClient;
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader317, ACKVektisCode::wmo317) then
            exit(false);

        WMOClient.SetRange(HeaderId, WMOHeader317.SystemId);
        WMOClient.FindFirst();

        if not WMOProcessor.TR304_ExistingClient(WMOClient, WMOHeader317, ACKClient) then
            exit(false);

        //Gewenste ingangsdatum checken.

        //Bestaat de toewijzing?
        //Datums zijn logisch?
        //omvang wijzingingen?

        exit(true);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader317);

        if Validate() then begin
            WMOProcessor.CreateRetour(WMOHeader317);
            WMOHeader317.Status := ACKWMOHeaderStatus::Send;
        end
        else begin
            WMOHeader317.Status := ACKWMOHeaderStatus::Invalid;
            WMOProcessor.CreateRetour(WMOHeader317);
        end;

        WMOHeader317.Modify(true);
    end;
}