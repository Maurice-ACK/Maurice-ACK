/// <summary>
/// Codeunit ACKWMOProcessor308.
/// </summary>
codeunit 50024 ACKWMOProcessor308 implements ACKWMOIProcessor
{
    var
        WMOHeader307, WMOHeader308 : Record ACKWMOHeader;
        WMOProcessor: codeunit ACKWMOProcessor;

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader308 := WMOHeader;
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader308);

        if Validate() then
            ProcessStopProducten();

        WMOProcessor.Send(WMOHeader308);
        WMOHeader308.Modify(true);
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader308.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader308.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader308, ACKVektisCode::wmo308) then
            exit(false);

        WMOHeader308.GetToHeader(WMOHeader307, true);

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader308) then
            exit(false);

        exit(true);
    end;

    /// <summary>
    /// ValidateRetourCodes.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure ValidateRetourCodes(): Boolean
    var
        WMOClient: Record ACKWMOClient;
        WMOStopProduct: Record ACKWMOStartStopProduct;
    begin
        //Client
        WMOClient.SetRange(HeaderId, WMOHeader308.SystemId);

        //If no client record is found then the 302 is valid.
        if not WMOClient.FindFirst() then
            exit(true);

        //If the client is found, check all the records for possible retourcodes.
        if WMOProcessor.HasInvalidRetourCode(WMOHeader308.SystemId, Database::ACKWMOClient, WMOClient.SystemId) then
            exit(false);

        //Start products
        WMOStopProduct.SetRange(ClientId, WMOClient.SystemId);

        if WMOStopProduct.FindSet() then
            repeat
                if WMOProcessor.HasInvalidRetourCode(WMOHeader308.SystemId, Database::ACKWMOStartStopProduct, WMOStopProduct.SystemId) then
                    exit(false);
            until WMOStopProduct.Next() = 0;

        exit(true);
    end;

    local procedure ProcessStopProducten()
    var
        WMOClient: Record ACKWMOClient;
        WMOStopProduct: Record ACKWMOStartStopProduct;
    begin
        WMOClient.SetRange(HeaderId, WMOHeader307.SystemId);

        if not WMOClient.FindFirst() then
            Error('Cliënt not found.');

        //Start products
        WMOStopProduct.SetRange(ClientId, WMOClient.SystemId);

        if WMOStopProduct.FindSet() then
            repeat
                UpdateIndication(WMOStopProduct);
            until WMOStopProduct.Next() = 0;
    end;

    local procedure UpdateIndication(WMOStopProduct: Record ACKWMOStartStopProduct)
    var
        WMOIndication: Record ACKWMOIndication;
        IndicationTempStop, IndicationTempStopNew : Record ACKIndicationTempStop;
    begin
        WMOIndication.SetRange(AssignmentNo, WMOStopProduct.ToewijzingNummer);
        WMOIndication.SetRange(MunicipalityNo, WMOHeader307.Ontvanger);

        if not WMOIndication.FindFirst() then
            exit;

        //Check declarations
        case WMOStopProduct.StatusAanlevering of
            ACKWMOStatusAanlevering::Deleted:
                begin
                    WMOIndication.EffectiveEndDate := 0D;
                    WMOIndication.RedenBeeindiging := '';
                    WMOIndication.Modify(true);
                    exit;
                end;
        end;

        case WMOStopProduct.RedenBeeindiging
        of
            ACKWMORedenBeeindiging::TijdelijkBeeindigd:
                begin
                    IndicationTempStopNew.Init();
                    IndicationTempStopNew.IndicationSystemID := WMOIndication.SystemId;
                    IndicationTempStopNew.StartDate := WMOStopProduct.Einddatum;
                    IndicationTempStopNew.Insert(true);

                    WMOIndication.EffectiveEndDate := WMOStopProduct.Einddatum;
                    WMOIndication.RedenBeeindiging := Format(WMOStopProduct.RedenBeeindiging);
                end
            else begin
                if WMOIndication.GetLastTempStop(IndicationTempStop) then begin
                    IndicationTempStop.EndDate := WMOStopProduct.Einddatum;

                    WMOIndication.EffectiveEndDate := WMOStopProduct.Einddatum;
                    WMOIndication.RedenBeeindiging := Format(WMOStopProduct.RedenBeeindiging);
                    IndicationTempStop.Modify(true);
                end;

                WMOIndication.RedenBeeindiging := Format(WMOStopProduct.RedenBeeindiging);
                WMOIndication.EffectiveEndDate := WMOStopProduct.Einddatum;
            end;
        end;

        WMOIndication.Modify(true);
    end;
}
