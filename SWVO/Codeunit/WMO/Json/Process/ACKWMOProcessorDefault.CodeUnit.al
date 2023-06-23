/// <summary>
/// Codeunit ACKWMOProcessorDefault (ID 50006).
/// </summary>
codeunit 50010 ACKWMOProcessorDefault implements ACKWMOIProcessor
{
    var
        WMOHeaderNotImplemented: Record ACKWMOHeader;
        NotImplementedErr: Label 'No Wmo processor is implemented for vektis code: %1', Comment = '%1 = ACKVektisCode';
    /// <summary>
    /// Init.
    /// /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeaderNotImplemented := WMOHeader;
        Error(NotImplementedErr, WMOHeader.BerichtCode);
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure Validate(): Boolean
    begin
        Error(NotImplementedErr, WMOHeaderNotImplemented.BerichtCode);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        Error(NotImplementedErr, WMOHeaderNotImplemented.BerichtCode);
    end;
}