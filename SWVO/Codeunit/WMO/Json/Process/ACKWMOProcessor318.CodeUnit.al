/// <summary>
/// Codeunit ACKWMOProcessor318.
/// </summary>
codeunit 50025 ACKWMOProcessor318 implements ACKWMOIProcessor
{
    var
        WMOHeader318, WMOHeader317 : Record ACKWMOHeader;
        WMOProcessor: codeunit ACKWMOProcessor;

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader318 := WMOHeader;
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader318);

        if Validate() then
            ProcessNewChangedUnchangedProduct();

        WMOProcessor.Send(WMOHeader318);
        WMOHeader318.Modify(true);
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure Validate(): Boolean
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader318, ACKVektisCode::wmo318) then
            exit(false);

        WMOHeader318.GetToHeader(WMOHeader317, true);

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader318) then
            exit(false);

        exit(true);
    end;

    local procedure ProcessNewChangedUnchangedProduct()
    var
        WMOClient: Record ACKWMOClient;
        NewChangedUnchangedProduct: Record ACKNewChangedUnchangedProduct;
        WMOIndication: Record ACKWMOIndication;
    begin
        WMOClient.SetRange(HeaderId, WMOHeader317.SystemId);

        if not WMOClient.FindFirst() then
            Error('Cliënt not found.');

        //Start products
        NewChangedUnchangedProduct.SetRange(ClientID, WMOClient.SystemId);

        // if NewChangedUnchangedProduct.FindSet() then
        //     repeat
        //         UpdateIndication(WMOStopProduct);
        //     until NewChangedUnchangedProduct.Next() = 0;
    end;

}
