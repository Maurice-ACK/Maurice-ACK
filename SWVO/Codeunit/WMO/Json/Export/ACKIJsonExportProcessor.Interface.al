/// <summary>
/// Interface ACKIJsonExportProcessor.
/// </summary>
interface ACKIJsonExportProcessor
{
    /// <summary>
    /// Export.
    /// </summary>
    /// <param name="ACKWMOHeader">Record ACKWMOHeader.</param>
    /// <returns>Return variable JsonObjectMessage of type JsonObject.</returns>
    procedure Export(ACKWMOHeader: Record ACKWMOHeader) JsonObjectMessage: JsonObject;
}
