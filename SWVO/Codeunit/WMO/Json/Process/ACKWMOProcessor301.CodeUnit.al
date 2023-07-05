/// <summary>
/// Codeunit ACKWMOProcessor301 (ID 50012).
/// </summary>
codeunit 50013 ACKWMOProcessor301 implements ACKWMOIProcessor
{
    var
        WMOHeader301: Record ACKWMOHeader;
        WMOClient: Record ACKWMOClient;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOProcessor: codeunit ACKWMOProcessor;
        ACKHelper: Codeunit ACKHelper;
        PreviousAssignedProducts: Dictionary of [Guid, Integer];

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader301 := WMOHeader;
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader301.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader301.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    var
        WMOToegewezenProduct: Record ACKWMOToegewezenProduct;
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader301, ACKVektisCode::wmo301) then
            exit(false);

        WMOClient.SetRange(HeaderId, WMOHeader301.SystemId);
        WMOClient.FindFirst();

        //Assigned products
        WMOToegewezenProduct.SetRange(ClientID, WMOClient.SystemId);
        if WMOToegewezenProduct.FindSet() then
            repeat
                ValidateToegewezenProduct(WMOToegewezenProduct);
                PreviousAssignedProducts.Add(WMOToegewezenProduct.SystemId, WMOToegewezenProduct.ToewijzingNummer);
            until WMOToegewezenProduct.Next() = 0;

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader301) then
            exit(false);

        exit(true);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader301);

        if Validate() then
            WMOProcessor.Send(WMOHeader301)
        else
            WMOHeader301.SetStatus(ACKWMOHeaderStatus::InvalidRetourCreated);

        WMOHeader301.Modify(true);

        //Commit();
        //WMOProcessor.CreateRetour(WMOHeader301);
    end;

    local procedure ValidateToegewezenProduct(WMOToegewezenProduct: Record ACKWMOToegewezenProduct): Boolean
    var
        ProductCodeFrequency: Record ACKProductCodeFrequency;
        HealthcareProviderProductCode: Record ACKHCProductCode;
        IndicationQuery: Query ACKWMOIndicationQuery;
        ProductCodeMonthRateQuery: Query ACKProductCodeMonthRateQuery;
        WMODeclarationQuery: Query ACKWMODeclarationQuery;
    begin
        //TR379
        if WMOToegewezenProduct.ReferentieAanbieder <> '' then
            if not ReferenceVOTVOWExists(WMOToegewezenProduct) then
                exit(false);

        //SW003
        ProductCodeFrequency.SetRange(ProductCode, WMOToegewezenProduct.ProductCode);
        ProductCodeFrequency.SetRange(ProductFrequency, WMOToegewezenProduct.Frequentie);

        if ProductCodeFrequency.IsEmpty() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW003);
            exit(false);
        end;

        //SW010
        if not HealthcareProviderProductCode.Get(WMOHeader301.Ontvanger, WMOToegewezenProduct.ProductCode) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW010);
            exit(false);
        end;

        //SW013
        if (WMOToegewezenProduct.Einddatum = 0D) and (WMOToegewezenProduct.Frequentie = ACKWMOFrequentie::TotaalInToewijzing) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW013);
            exit(false);
        end;

        //TR381
        if not WMOProcessor.TR081Check(WMOToegewezenProduct.ProductCode, WMOToegewezenProduct.ProductCategorie, WMOHeader301.SystemId, Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId) then
            exit(false);

        IndicationQuery.SetRange(IndicationQuery.MunicipalityNo, WMOHeader301.Afzender);
        IndicationQuery.SetRange(IndicationQuery.AssignmentNo, WMOToegewezenProduct.ToewijzingNummer);

        if IndicationQuery.Open() and IndicationQuery.Read() then begin
            //OP033X1 and IV066
            if (IndicationQuery.SSN <> WMOClient.SSN) or
                (IndicationQuery.ProductCategoryId <> WMOToegewezenProduct.ProductCategorie) or
                (IndicationQuery.ProductCode <> WMOToegewezenProduct.ProductCode) or
                (IndicationQuery.HealthcareProviderNo <> WMOHeader301.Ontvanger) then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::TR332);
                exit(false);
            end;

            if WMOToegewezenProduct.Frequentie = ACKWMOFrequentie::TotaalInToewijzing then
                if (IndicationQuery.ProductFrequency <> WMOToegewezenProduct.Frequentie) or
                    (IndicationQuery.ProductUnit <> WMOToegewezenProduct.Eenheid) or
                    (IndicationQuery.Budget <> WMOToegewezenProduct.Budget) then begin
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW012);
                    exit(false);
                end;

            if WMOToegewezenProduct.Frequentie <> ACKWMOFrequentie::TotaalInToewijzing then
                //SW012
                if (IndicationQuery.ProductVolume <> WMOToegewezenProduct.Volume) or
                    (IndicationQuery.ProductFrequency <> WMOToegewezenProduct.Frequentie) or
                    (IndicationQuery.ProductUnit <> WMOToegewezenProduct.Eenheid) or
                    (IndicationQuery.Budget <> WMOToegewezenProduct.Budget) then begin
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW012);
                    exit(false);
                end;

            if WMOToegewezenProduct.RedenWijziging = ACKWMORedenWijziging::Empty then begin
                if IndicationQuery.StartDate <> WMOToegewezenProduct.Ingangsdatum then begin
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW011);
                    exit(false);
                end;

                if IndicationQuery.EndDate <> WMOToegewezenProduct.Einddatum then begin
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::TR332);
                    exit(false);
                end;
            end
            else
                if WMOToegewezenProduct.RedenWijziging = ACKWMORedenWijziging::Verwijderd then begin
                    //TR385
                    WMODeclarationQuery.SetRange(WMODeclarationQuery.LineClientNo, IndicationQuery.ClientNo);
                    WMODeclarationQuery.SetRange(WMODeclarationQuery.LineAssignmentNo, WMOToegewezenProduct.ToewijzingNummer);
                    if WMODeclarationQuery.Open() and WMODeclarationQuery.Read() then
                        if WMODeclarationQuery.TotalAmount > 0 then begin
                            MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::TR385);
                            exit(false);
                        end;
                end;

            IndicationQuery.Close();
            Clear(IndicationQuery);
        end;

        //SW002
        if HasInvalidProductCombination(WMOToegewezenProduct) then
            exit(false);

        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.Year, Date2DMY(WMOToegewezenProduct.Ingangsdatum, 3));
        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.Month, ACKHelper.GetMonthByDate(WMOToegewezenProduct.Ingangsdatum));
        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.ProductCode, WMOToegewezenProduct.ProductCode);
        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.IndicationUnitid, WMOToegewezenProduct.Eenheid);

        //SW004
        if ProductCodeMonthRateQuery.Open() and not ProductCodeMonthRateQuery.Read() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW004);
            exit(false);
        end;

        //SW006
        if ProductCodeMonthRateQuery.IsPredefined then
            if WMOToegewezenProduct.Volume <> 1 then
                MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW006);

        ProductCodeMonthRateQuery.Close();
        exit(true);
    end;

    local procedure HasInvalidProductCombination(var WMOToegewezenProduct: Record ACKWMOToegewezenProduct): Boolean
    var
        InvalidPCCombinationQuery: Query ACKInvalidPCCombinationQuery;
    begin
        if not IsValidCombinationWithPreviousLocalProducts(WMOToegewezenProduct) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW002);
            exit(true);
        end;

        InvalidPCCombinationQuery.SetRange(InvalidPCCombinationQuery.SSN, WMOClient.SSN);
        InvalidPCCombinationQuery.SetFilter(InvalidPCCombinationQuery.AssignmentNo, '<>%1', WMOToegewezenProduct.ToewijzingNummer);
        InvalidPCCombinationQuery.SetRange(InvalidPCCombinationQuery.ProductCodeInvalid, WMOToegewezenProduct.ProductCode);

        //Einddatum van huidige indicatie(s) mogen niet na het toegewezen product ingangsdatum liggen, mits het gehele toegewezen product ervoor zit.
        InvalidPCCombinationQuery.SetFilter(InvalidPCCombinationQuery.EndDate, '=%1|>%2', 0D, WMOToegewezenProduct.Ingangsdatum);
        InvalidPCCombinationQuery.SetFilter(InvalidPCCombinationQuery.EffectiveEndDate, '=%1|>%2', 0D, WMOToegewezenProduct.Ingangsdatum);

        if WMOToegewezenProduct.Einddatum <> 0D then
            //Startdatum van huidige indicatie mag niet voor einddatum van de nieuwe indicatie liggen.
            InvalidPCCombinationQuery.SetFilter(InvalidPCCombinationQuery.StartDate, '<%1', WMOToegewezenProduct.Einddatum);

        if InvalidPCCombinationQuery.Open() and InvalidPCCombinationQuery.Read() then
            if not IsValidCombinationWithPrevious(InvalidPCCombinationQuery) then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::SW002);
                exit(true);
            end;

        InvalidPCCombinationQuery.Close();
        exit(false);
    end;

    local procedure IsValidCombinationWithPrevious(var InvalidPCCombinationQuery: Query ACKInvalidPCCombinationQuery): Boolean;
    var
        AssignmentNo: Integer;
    begin
        //Als het toegewezen product ongeldig is op basis van de huidige indicaties dan kan het nog steeds geldig zijn indien het toegewezen product in hetzelfde bericht is aangepast.
        foreach AssignmentNo in PreviousAssignedProducts.Values() do
            if AssignmentNo = InvalidPCCombinationQuery.AssignmentNo then
                exit(true);
        exit(false);
    end;

    local procedure IsValidCombinationWithPreviousLocalProducts(var WMOToegewezenProduct: Record ACKWMOToegewezenProduct): Boolean
    var
        VorigToegewezenProduct: Record ACKWMOToegewezenProduct;
        ACKInvalidPCCombination: Record ACKInvalidPCCombination;
        VorigToegewezenProductSystemId: Guid;
        CurrentAssignedProductEndDate, PreviousAssignedProductEndDate : Date;
    begin
        //Check if combination is valid with previous processed products
        foreach VorigToegewezenProductSystemId in PreviousAssignedProducts.Keys() do begin
            Clear(VorigToegewezenProduct);
            if VorigToegewezenProduct.GetBySystemId(VorigToegewezenProductSystemId) then
                if not (VorigToegewezenProduct.RedenWijziging = ACKWMORedenWijziging::Verwijderd) then begin
                    ACKInvalidPCCombination.SetRange(ProductCode, WMOToegewezenProduct.ProductCode);
                    ACKInvalidPCCombination.SetRange(ProductCodeInvalid, VorigToegewezenProduct.ProductCode);
                    if not ACKInvalidPCCombination.IsEmpty() then begin
                        if WMOToegewezenProduct.Einddatum = 0D then
                            CurrentAssignedProductEndDate := ACKHelper.MaxDate()
                        else
                            CurrentAssignedProductEndDate := WMOToegewezenProduct.Einddatum;

                        if VorigToegewezenProduct.Einddatum = 0D then
                            PreviousAssignedProductEndDate := ACKHelper.MaxDate()
                        else
                            PreviousAssignedProductEndDate := VorigToegewezenProduct.Einddatum;

                        if (WMOToegewezenProduct.Ingangsdatum <= PreviousAssignedProductEndDate) and (CurrentAssignedProductEndDate >= VorigToegewezenProduct.Ingangsdatum) then
                            exit(false);
                    end;
                end;
        end;
        exit(true);
    end;

    local procedure ReferenceVOTVOWExists(var WMOToegewezenProduct: Record ACKWMOToegewezenProduct): Boolean;
    var
        NewChangedUnchangedProductQ: Query ACKNewChangedUnchangedProductQ;
    begin
        NewChangedUnchangedProductQ.SetRange(NewChangedUnchangedProductQ.Status, ACKWMOHeaderStatus::Send);
        NewChangedUnchangedProductQ.SetRange(NewChangedUnchangedProductQ.SSN, WMOClient.SSN);
        NewChangedUnchangedProductQ.SetRange(NewChangedUnchangedProductQ.ReferentieAanbieder, WMOToegewezenProduct.ReferentieAanbieder);

        if NewChangedUnchangedProductQ.Open() and NewChangedUnchangedProductQ.Read() then
            exit(true)
        else begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId, WMOHeader301.SystemId, ACKWMORule::TR379);
            exit(false);
        end;

        exit(true);
    end;
}