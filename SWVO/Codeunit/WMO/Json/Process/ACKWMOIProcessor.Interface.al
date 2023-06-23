/// <summary>
/// Interface ACKWMOIProcessor.
/// </summary>
interface ACKWMOIProcessor
{
    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
}
