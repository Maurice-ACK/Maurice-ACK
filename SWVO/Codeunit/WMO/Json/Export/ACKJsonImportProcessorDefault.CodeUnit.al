/// <summary>
/// Codeunit ACKJsonExportProcessorDefault.
/// </summary>
codeunit 50037 ACKJsonExportProcessorDefault implements ACKIJsonExportProcessor
{
    var
        NotImplementedVektisErr: Label 'No json export processor is implemented for vektis code: %1', Comment = '%1 = ACKVektisCode';

    /// <summary>
    /// Export.
    /// </summary>
    /// <param name="ACKWMOHeader">Record ACKWMOHeader.</param>
    /// <returns>Return variable JsonObjectMessage of type JsonObject.</returns>
    procedure Export(ACKWMOHeader: Record ACKWMOHeader) JsonObjectMessage: JsonObject;
    begin
        Error(NotImplementedVektisErr, ACKWMOHeader.BerichtCode);
    end;
}
