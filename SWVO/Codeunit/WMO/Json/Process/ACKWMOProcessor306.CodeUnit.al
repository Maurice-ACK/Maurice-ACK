/// <summary>
/// Codeunit ACKWMOProcessor302.
/// </summary>
codeunit 50032 ACKWMOProcessor306 implements ACKWMOIProcessor
{
    var
        WMOHeader306, WMOHeader305 : Record ACKWMOHeader;
        WMOProcessor: codeunit ACKWMOProcessor;

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader306 := WMOHeader;
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader306);

        if Validate() then
            ProcessStartProduct();

        WMOProcessor.Send(WMOHeader306);
        WMOHeader306.Modify(true);
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader306.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader306.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader306, ACKVektisCode::wmo306) then
            exit(false);

        WMOHeader306.GetToHeader(WMOHeader305, true);

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader306) then
            exit(false);

        exit(true);
    end;

    local procedure ProcessStartProduct()
    var
        WMOClient: Record ACKWMOClient;
        WMOStartProduct: Record ACKWMOStartStopProduct;
        WMOIndication: Record ACKWMOIndication;
    begin
        WMOClient.SetRange(HeaderId, WMOHeader305.SystemId);

        if not WMOClient.FindFirst() then
            Error('Cliënt not found.');

        //Start products
        WMOStartProduct.SetRange(ClientId, WMOClient.SystemId);

        if WMOStartProduct.FindSet() then
            repeat
                UpdateIndication(WMOStartProduct);
            until WMOStartProduct.Next() = 0;
    end;

    local procedure UpdateIndication(WMOStartProduct: Record ACKWMOStartStopProduct)
    var
        WMOIndication: Record ACKWMOIndication;
        ACKIndicationTempStop: Record ACKIndicationTempStop;
    begin
        WMOIndication.SetRange(AssignmentNo, WMOStartProduct.ToewijzingNummer);
        WMOIndication.SetRange(MunicipalityNo, WMOHeader305.Ontvanger);

        if not WMOIndication.FindFirst() then
            exit;

        case WMOStartProduct.StatusAanlevering
       of
            ACKWMOStatusAanlevering::First:
                begin
                    WMOIndication.GetTempStop(ACKIndicationTempStop, WMOStartProduct.Begindatum);

                    if IsNullGuid(ACKIndicationTempStop.SystemId) then
                        WMOIndication.EffectiveStartDate := WMOStartProduct.Begindatum
                    else begin
                        ACKIndicationTempStop.EndDate := WMOStartProduct.Begindatum;
                        WMOIndication.EffectiveEndDate := 0D;
                        ACKIndicationTempStop.Modify(true);
                    end;
                end;
            ACKWMOStatusAanlevering::Deleted:
                WMOIndication.EffectiveStartDate := 0D;
        end;
        WMOIndication.Modify(true);

    end;
}
