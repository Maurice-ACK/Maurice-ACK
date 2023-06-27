/// <summary>
/// Codeunit ACKWMOProcessor323.
/// </summary>
codeunit 50035 ACKWMOProcessor323 implements ACKWMOIProcessor
{
    var
        WMOHeader323: Record ACKWMOHeader;
        WMODeclaratie: Record ACKWMODeclaratie;
        HealthcareMonth: Record ACKHealthcareMonth;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        HealthcareProvider: Record Vendor;
        WMODeclarationHeader: Record ACKWMODeclarationHeader;
        WMOProcessor: codeunit ACKWMOProcessor;
        WMODeclarationHelper: Codeunit ACKWMODeclarationHelper;
        ACKHelper: Codeunit ACKHelper;
        WMOHelper: Codeunit ACKWMOHelper;
        ValidPrestaties: List of [Text[20]];
        LocalPrestatieAmount: Dictionary of [Integer, Integer];

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader323 := WMOHeader;
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader323.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader323.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    var
        WMOClient: Record ACKWMOClient;
        WMOPrestatie: Record ACKWMOPrestatie;
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader323, ACKVektisCode::wmo323) then
            exit(false);

        HealthcareProvider.Get(WMOHeader323.Afzender);

        WMODeclaratie.SetRange(HeaderId, WMOHeader323.SystemId);
        WMODeclaratie.FindFirst();

        if not ValidateDeclaration() then
            exit(false);

        WMOClient.SetRange(HeaderId, WMOHeader323.SystemId);
        if WMOClient.FindSet() then
            repeat
                //OP366 Credit first
                WMOPrestatie.SetCurrentKey(DebitCredit);
                WMOPrestatie.SetAscending(DebitCredit, true);
                WMOPrestatie.SetRange(ClientID, WMOClient.SystemId);

                if WMOPrestatie.FindSet() then
                    repeat
                        if ValidatePrestatie(WMOClient, WMOPrestatie) then
                            ValidPrestaties.Add(WMOPrestatie.ReferentieNummer);
                    until WMOPrestatie.Next() = 0;
            until WMOClient.Next() = 0;
        exit(true);
    end;

    local procedure ValidateDeclaration(): Boolean
    begin
        if not HealthcareMonth.GetFromDate(WMODeclaratie.Begindatum) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMODeclaratie, WMODeclaratie.SystemId, WMOHeader323.SystemId, ACKWMORule::SW017);
            exit(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        //OP366: Omdat een prestatieregel eerst volledig gecrediteerd moet worden alvorens er een correctie op deze prestatieregel ingediend kan worden, is het noodzakelijk dat bij de verwerking van de declaratieberichten eerst de creditregels verwerkt worden, en pas daarna de debetregels. 
        WMOProcessor.ValidateProcessStatus(WMOHeader323);

        if Validate() then begin
            CreateDeclarationHeader();
            CreateDeclarationLines();

            WMOProcessor.Send(WMOHeader323);
        end
        else
            WMOHeader323.SetStatus(ACKWMOHeaderStatus::InvalidRetourCreated);

        WMOHeader323.Modify(true);
    end;

    local procedure ValidatePrestatie(WMOClient: Record ACKWMOClient; WMOPrestatie: Record ACKWMOPrestatie): Boolean
    var
        ACKClient: Record ACKClient;
        IndicationQuery: Query ACKWMOIndicationQuery;
        WMOPrestatieQuery: Query ACKWMOPrestatieQuery;
        HealthcareMonthPCRateQuery: Query ACKHealthcareMonthPCRateQuery;
        IndicatieStartdatum, IndicatieEinddatum : Date;
    begin
        //TR304
        WMOProcessor.TR304_ExistingClient(WMOClient, WMOHeader323, ACKClient);

        IndicationQuery.SetRange(IndicationQuery.AssignmentNo, WMOPrestatie.ToewijzingNummer);
        IndicationQuery.SetRange(IndicationQuery.MunicipalityNo, WMOHeader323.Ontvanger);

        IndicationQuery.Open();

        if not IndicationQuery.Read() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR304);
            exit(false);
        end;

        WMOHelper.GetIndicationRealStartAndEndDate(IndicationQuery, IndicatieStartdatum, IndicatieEinddatum);

        if (IndicationQuery.SSN <> WMOClient.SSN) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR304);
            exit(false);
        end;

        //TR307
        if WMOPrestatie.Begindatum < IndicatieStartdatum then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR307);
            exit(false);
        end;

        //TR308
        if IndicatieEinddatum <> 0D then
            if WMOPrestatie.Einddatum > IndicatieEinddatum then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR308);
                exit(false);
            end;

        //TR314
        Clear(WMOPrestatieQuery);
        WMOPrestatieQuery.SetRange(WMOPrestatieQuery.Afzender, WMOHeader323.Afzender);
        WMOPrestatieQuery.SetFilter(WMOPrestatieQuery.PrestatieSystemId, '<>%1', WMOPrestatie.SystemId);
        WMOPrestatieQuery.SetRange(WMOPrestatieQuery.ReferentieNummer, WMOPrestatie.ReferentieNummer);
        WMOPrestatieQuery.Open();
        if WMOPrestatieQuery.Read() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR314);
            WMOPrestatieQuery.Close();
            exit(false);
        end;

        //TR319 
        if WMOPrestatie.Einddatum > WMODeclaratie.Einddatum then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR319);

        //Credit check first OP366 and TR323
        if not ValidateReferencePrestatie(ACKClient, WMOPrestatie) then
            exit(false);

        Clear(HealthcareMonthPCRateQuery);
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.IsActive, true);
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.Year, Date2DMY(WMOPrestatie.Begindatum, 3));
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.Month, ACKHelper.GetMonthByDate(WMOPrestatie.Begindatum));
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.ProductCode, WMOPrestatie.ProductCode);
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.DeclarationUnitId, WMOPrestatie.Eenheid);

        if HealthcareMonthPCRateQuery.Open() and HealthcareMonthPCRateQuery.Read() then begin
            if HealthcareProvider.ACKStartEndMonthDeclaration then
                if not CheckIndicationStartEndMonth(IndicationQuery, WMOPrestatie, HealthcareMonthPCRateQuery) then
                    exit(false);

            if not CheckDeclarationAmount(IndicationQuery, WMOPrestatie, HealthcareMonthPCRateQuery) then
                exit(false);

            SetLocalPrestatieAmount(WMOPrestatie.ToewijzingNummer, WMOPrestatie.Bedrag);
        end
        else begin
            HealthcareMonthPCRateQuery.Close();
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR418);
            exit(false);
        end;

        IndicationQuery.Close();
        Clear(IndicationQuery);
        exit(true);
    end;

    local procedure CheckIndicationStartEndMonth(IndicationQuery: Query ACKWMOIndicationQuery; WMOPrestatie: Record ACKWMOPrestatie;
                                                                      HealthcareMonthPCRateQuery: Query ACKHealthcareMonthPCRateQuery): Boolean
    var
        IndicatieStartdatum, IndicatieEinddatum : Date;
        AantalDagenGestopt, AantalDagenGedeclareerd,
        PrestatieJaar, PrestatieMaand,
        IndicatieStartJaar, IndicatieStartMaand, IndicatieStartDag,
        IndicatieEindJaar, IndicatieEindMaand, IndicatieEindDag : Integer;
        StartMonthErr: Label 'Zorg gestart op: %1 en eindigt op: %2. Startmaand wordt niet uitbetaald.', Locked = true, Comment = '%1 = Start dag, %2 = Eind dag.';
        EndMonthErr: Label 'Zorg eindigt op: %1 en is gestart op: %2. Eindmaand wordt niet uitbetaald.', Locked = true, Comment = '%1 = Eind dag, %2 = Start dag.';
    begin
        WMOHelper.GetIndicationRealStartAndEndDate(IndicationQuery, IndicatieStartdatum, IndicatieEinddatum);

        PrestatieJaar := DATE2DMY(WMOPrestatie.Begindatum, 3);
        PrestatieMaand := DATE2DMY(WMOPrestatie.Begindatum, 2);

        IndicatieStartJaar := DATE2DMY(IndicatieStartdatum, 3);
        IndicatieStartMaand := DATE2DMY(IndicatieStartdatum, 2);
        IndicatieStartDag := DATE2DMY(IndicatieStartdatum, 1);

        AantalDagenGestopt := WMOHelper.GetDaysStopped(IndicationQuery.IndicationSystemId, WMOPrestatie.Begindatum, WMOPrestatie.Einddatum);
        AantalDagenGedeclareerd := (WMOPrestatie.Einddatum - WMOPrestatie.Begindatum + 1);

        if AantalDagenGedeclareerd = AantalDagenGestopt then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::SW023);
            exit(false);
        end;

        if (IndicatieStartJaar = PrestatieJaar) and (IndicatieStartMaand = PrestatieMaand) then begin
            //Start maand
            if IndicatieStartDag < 15 then
                exit(true) else
                if IndicatieEindDag >= 15 then
                    exit(true);

            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::SW016);
            ACKHelper.AddWmoEventLog(WMOPrestatie, Severity::Error, StrSubstNo(StartMonthErr, IndicatieStartDag, IndicatieEindDag));
            exit(false);
        end;

        if IndicatieEinddatum <> 0D then begin
            IndicatieEindJaar := DATE2DMY(IndicatieEinddatum, 3);
            IndicatieEindMaand := DATE2DMY(IndicatieEinddatum, 2);
            IndicatieEindDag := DATE2DMY(IndicatieEinddatum, 1);

            if (IndicatieEindJaar = PrestatieJaar) and (IndicatieEindMaand = PrestatieMaand) then begin
                //Eind maand
                if IndicatieEindDag >= 15 then
                    exit(true) else
                    if IndicatieStartDag >= 15 then
                        exit(true);

                MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::SW024);
                ACKHelper.AddWmoEventLog(WMOPrestatie, Severity::Error, StrSubstNo(EndMonthErr, IndicatieEindDag, IndicatieStartDag));
                exit(false);
            end;
        end;

        //Tussen start en eind maand mag gedeclareerd worden.
        exit(true);
    end;

    local procedure CheckDeclarationAmount(IndicationQuery: Query ACKWMOIndicationQuery; WMOPrestatie: Record ACKWMOPrestatie;
                                                                HealthcareMonthPCRateQuery: Query ACKHealthcareMonthPCRateQuery) IsValid: Boolean
    var
        MaxDeclarationDays, DeclaredAmount : integer;
        MaxAllowedVolumeInteger, MaxAllowedAmountInteger, StoppedDays, PrestatieJaar, PrestatieMaand, DaysInMonth : Integer;
        MaxAllowedVolumeDecimal, MaxAllowedAmountDecimal : Decimal;
    begin
        IsValid := true;
        PrestatieJaar := DATE2DMY(WMOPrestatie.Begindatum, 3);
        PrestatieMaand := DATE2DMY(WMOPrestatie.Begindatum, 2);

        StoppedDays := WMOHelper.GetDaysStopped(IndicationQuery.IndicationSystemId, WMOPrestatie.Begindatum, WMOPrestatie.Einddatum);
        DaysInMonth := ACKHelper.NoOfDaysInMonth(PrestatieJaar, PrestatieMaand);

        MaxDeclarationDays := (WMOPrestatie.Einddatum - WMOPrestatie.Begindatum + 1) - StoppedDays;

        if MaxDeclarationDays <= 0 then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR319);
            IsValid := false;
            exit;
        end;

        MaxAllowedVolumeDecimal := IndicationQuery.ProductVolume;

        //1. Make sure the volumes are calculated in the same unit of measure.
        case WMOPrestatie.Eenheid of
            ACKWMOEenheid::Minuut:
                if IndicationQuery.ProductUnit = ACKWMOEenheid::Uur then
                    MaxAllowedVolumeDecimal := IndicationQuery.ProductVolume * 60;
            ACKWMOEenheid::Uur:
                if IndicationQuery.ProductUnit = ACKWMOEenheid::Minuut then
                    MaxAllowedVolumeDecimal := IndicationQuery.ProductVolume / 60;
            ACKWMOEenheid::Euro:
                if IndicationQuery.ProductUnit = ACKWMOEenheid::StuksOutput then
                    MaxAllowedVolumeDecimal := IndicationQuery.ProductVolume * HealthcareMonthPCRateQuery.Rate;
        end;

        //2. Determine the maximum allowed volume based on the frequency
        case IndicationQuery.ProductFrequency of
            ACKWMOFrequentie::Dag:
                MaxAllowedVolumeDecimal := MaxAllowedVolumeDecimal * MaxDeclarationDays;
            ACKWMOFrequentie::Week:
                MaxAllowedVolumeDecimal := MaxAllowedVolumeDecimal * NoOfWeeks(MaxDeclarationDays);
            ACKWMOFrequentie::Maand,
            ACKWMOFrequentie::TotaalInToewijzing:
                MaxAllowedVolumeDecimal := (MaxAllowedVolumeDecimal / DaysInMonth) * MaxDeclarationDays;
        end;

        if WMOPrestatie.Eenheid = ACKWMOEenheid::Euro then
            MaxAllowedAmountDecimal := MaxAllowedVolumeDecimal
        else
            MaxAllowedAmountDecimal := MaxAllowedVolumeDecimal * HealthcareMonthPCRateQuery.Rate;

        MaxAllowedAmountInteger := Round(MaxAllowedAmountDecimal, 1, '>');
        MaxAllowedVolumeInteger := Round(MaxAllowedVolumeDecimal, 1, '>');

        DeclaredAmount := WMODeclarationHelper.GetTotalAmountDeclaredInPeriodByAssignment(IndicationQuery.MunicipalityNo, IndicationQuery.HealthcareProviderNo, IndicationQuery.ClientNo, IndicationQuery.AssignmentNo, HealthcareMonth.Year, HealthcareMonth.Month.AsInteger());
        DeclaredAmount += GetLocalPrestatieAmount(WMOPrestatie.ToewijzingNummer);

        //Tarief wordt niet meegegeven bij eenheid euro's.
        if (WMOPrestatie.Eenheid <> ACKWmoEenheid::Euro) and (WMOPrestatie.ProductTarief <> HealthcareMonthPCRateQuery.Rate) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR418);
            IsValid := false;
        end;

        if WMOPrestatie.GeleverdVolume > MaxAllowedVolumeInteger then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR321);
            IsValid := false;
        end else
            if WMOPrestatie.Bedrag > MaxAllowedAmountInteger then begin
                MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR321);
                IsValid := false;
            end;

        if WMOPrestatie.Bedrag > (MaxAllowedAmountInteger - DeclaredAmount) then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR322);
            IsValid := false;
        end;
    end;

    local procedure NoOfWeeks(NoOfDays: Integer) Weeks: Integer
    begin
        weeks := NoOfDays div 7;
        if Weeks = 0 then
            Weeks := 1;
    end;

    local procedure CreateDeclarationHeader()
    begin
        WMODeclarationHeader.SetRange(HeaderId, WMOHeader323.SystemId);

        if not WMODeclarationHeader.FindFirst() then begin
            WMODeclarationHeader.Init();
            WMODeclarationHeader.HeaderId := WMOHeader323.SystemId;
            WMODeclarationHeader.MunicipalityNo := WMOHeader323.Ontvanger;
            WMODeclarationHeader.HealthcareProviderNo := WMOHeader323.Afzender;
            WMODeclarationHeader.DeclarationNo := WMODeclaratie.DeclaratieNummer;
            WMODeclarationHeader.DeclarationDate := WMODeclaratie.DeclaratieDagtekening;
            WMODeclarationHeader.Year := HealthcareMonth.Year;
            WMODeclarationHeader.Month := HealthcareMonth.Month.AsInteger();
            WMODeclarationHeader.Status := ACKWMODeclarationStatus::New;
            WMODeclarationHeader.Insert(true);
        end;
    end;

    local procedure CreateDeclarationLines()
    var
        WMOClient: Record ACKWMOClient;
        WMOPrestatie: Record ACKWMOPrestatie;
        WMODeclarationLine: Record ACKWMODeclarationLine;
        WMOIndication: Record ACKWMOIndication;
        Rate: Integer;
    begin
        WMOClient.SetRange(HeaderId, WMOHeader323.SystemId);
        if WMOClient.FindSet() then
            repeat
                WMOPrestatie.SetRange(ClientID, WMOClient.SystemId);
                if WMOPrestatie.FindSet() then
                    repeat
                        if ValidPrestaties.Contains(WMOPrestatie.ReferentieNummer) then begin

                            WMOIndication.SetRange(MunicipalityNo, WMOHeader323.Ontvanger);
                            WMOIndication.SetRange(AssignmentNo, WMOPrestatie.ToewijzingNummer);
                            WMOIndication.FindFirst();

                            Rate := WMODeclarationHelper.GetHealthcareMonthRate(WMOPrestatie.ProductCode, WMOPrestatie.Eenheid, HealthcareMonth.Year, HealthcareMonth.Month.AsInteger());

                            Clear(WMODeclarationLine);
                            WMODeclarationLine.Init();
                            WMODeclarationLine.DeclarationHeaderNo := WMODeclarationHeader.DeclarationHeaderNo;
                            WMODeclarationLine.IndicationID := WMOIndication.ID;
                            WMODeclarationLine.ClientNo := WMOIndication.ClientNo;
                            WMODeclarationLine.AssignmentNo := WMOPrestatie.ToewijzingNummer;
                            WMODeclarationLine.MunicipalityNo := WMOHeader323.Ontvanger;
                            WMODeclarationLine.HealthcareProviderNo := WMOHeader323.Afzender;
                            WMODeclarationLine.Reference := WMOPrestatie.ReferentieNummer;
                            WMODeclarationLine.PreviousReference := WMOPrestatie.VorigReferentieNummer;
                            WMODeclarationLine.ProductCategoryId := WMOPrestatie.ProductCategorie;
                            WMODeclarationLine.ProductCode := WMOPrestatie.ProductCode;
                            WMODeclarationLine.StartDate := WMOPrestatie.Begindatum;
                            WMODeclarationLine.EndDate := WMOPrestatie.Einddatum;
                            WMODeclarationLine.Unit := WMOPrestatie.Eenheid;
                            WMODeclarationLine.Volume := WMOPrestatie.GeleverdVolume;

                            if WMOPrestatie.DebitCredit = ACKDebitCredit::D then
                                WMODeclarationLine.Amount := WMOPrestatie.Bedrag
                            else
                                WMODeclarationLine.Amount := -WMOPrestatie.Bedrag;

                            WMODeclarationLine.ProductRate := Rate;
                            WMODeclarationLine.Insert(true);
                        end;
                    until WMOPrestatie.Next() = 0;
            until WMOClient.Next() = 0;
    end;

    local procedure SetLocalPrestatieAmount(ProductAssignedId: Integer; Amount: Integer)
    begin
        if LocalPrestatieAmount.ContainsKey(ProductAssignedId) then begin
            Amount += LocalPrestatieAmount.Get(ProductAssignedId);
            LocalPrestatieAmount.Set(ProductAssignedId, Amount);
        end
        else
            LocalPrestatieAmount.Add(ProductAssignedId, Amount);
    end;

    local procedure GetLocalPrestatieAmount(ProductAssignedId: Integer) Amount: Integer
    begin
        if LocalPrestatieAmount.ContainsKey(ProductAssignedId) then
            Amount := LocalPrestatieAmount.Get(ProductAssignedId);
    end;

    local procedure ValidateReferencePrestatie(ACKClient: Record ACKClient; WMOPrestatie: Record ACKWMOPrestatie): Boolean
    var
        RelatedPrestatieQuery: Query ACKWMOPrestatieQuery;
        DeclaredAmount: integer;
    begin
        if WMOPrestatie.VorigReferentieNummer = '' then
            case WMOPrestatie.DebitCredit of
                ACKDebitCredit::C:
                    begin
                        MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR323);
                        exit(false);
                    end;
                ACKDebitCredit::D:
                    exit(true);
            end;

        //This is a xsd/xslt validation but added for extra check.
        if WMOPrestatie.DebitCredit = ACKDebitCredit::D then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR316);
            exit(false);
        end;

        //This cannot be enabled when migrating from AX2012 to Business Central because we won't migrate the old message data.

        // RelatedPrestatieQuery.SetFilter(RelatedPrestatieQuery.PrestatieSystemId, '<>%1', WMOPrestatie.SystemId);
        // RelatedPrestatieQuery.SetRange(RelatedPrestatieQuery.Afzender, WMOHeader323.Afzender);
        // RelatedPrestatieQuery.SetRange(RelatedPrestatieQuery.SSN, ACKClient.SSN);
        // RelatedPrestatieQuery.SetRange(RelatedPrestatieQuery.DebitCredit, ACKDebitCredit::D);
        // RelatedPrestatieQuery.SetRange(RelatedPrestatieQuery.ReferentieNummer, WMOPrestatie.VorigReferentieNummer);

        // if RelatedPrestatieQuery.Open() and RelatedPrestatieQuery.Read() then begin
        //     //TR323
        //     if (RelatedPrestatieQuery.ProductCategorie <> WMOPrestatie.ProductCategorie) or
        //         (RelatedPrestatieQuery.ProductCode <> WMOPrestatie.ProductCode) or
        //         (RelatedPrestatieQuery.ToewijzingNummer <> WMOPrestatie.ToewijzingNummer) or
        //         (RelatedPrestatieQuery.Begindatum <> WMOPrestatie.Begindatum) or
        //         (RelatedPrestatieQuery.Einddatum <> WMOPrestatie.Einddatum) or
        //         (RelatedPrestatieQuery.GeleverdVolume <> WMOPrestatie.GeleverdVolume) or
        //         (RelatedPrestatieQuery.Eenheid <> WMOPrestatie.Eenheid) or
        //         (RelatedPrestatieQuery.Bedrag <> WMOPrestatie.Bedrag) then begin
        //         MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR323);
        //         exit(false);
        //     end;
        // end else begin
        //     MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR323);
        //     exit(false);
        // end;

        //Double check because it can't be done with previous message data.
        DeclaredAmount := WMODeclarationHelper.GetTotalApprovedAmountDeclaredInPeriodByAssignment(WMOHeader323.Ontvanger, WMOHeader323.Afzender, ACKClient.ClientNo, WMOPrestatie.ToewijzingNummer, HealthcareMonth.Year, HealthcareMonth.Month.AsInteger());

        //Check if credit amount is not more than the total approved amount already declared.
        if DeclaredAmount < WMOPrestatie.Bedrag then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR323);
            exit(false);
        end;

        exit(true);
    end;
}
