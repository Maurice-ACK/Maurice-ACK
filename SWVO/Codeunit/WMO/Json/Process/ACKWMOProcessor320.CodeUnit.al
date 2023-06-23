/// <summary>
/// Codeunit ACKWMOProcessor320.
/// </summary>
codeunit 50030 ACKWMOProcessor320 implements ACKWMOIProcessor
{
    var
        WMOHeader320, WMOHeader319 : Record ACKWMOHeader;
        WMOProcessor: codeunit ACKWMOProcessor;

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader320 := WMOHeader;
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader320);

        if Validate() then
            WMOProcessor.Send(WMOHeader320);

        WMOHeader320.Modify(true);
    end;
    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure Validate(): Boolean
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader320, ACKVektisCode::wmo320) then
            exit(false);

        WMOHeader320.GetToHeader(WMOHeader319, false);

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader320) then
            exit(false);

        exit(true);
    end;
}
