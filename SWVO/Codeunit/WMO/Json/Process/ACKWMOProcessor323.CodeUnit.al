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
        WMOProcessor: codeunit ACKWMOProcessor;
        WMODeclarationHelper: Codeunit ACKWMODeclarationHelper;
        ACKHelper: Codeunit ACKHelper;
        WMOHelper: Codeunit ACKWMOHelper;

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

        WMODeclaratie.SetRange(HeaderId, WMOHeader323.SystemId);
        WMODeclaratie.FindFirst();

        if not ValidateDeclaration() then
            exit(false);

        WMOClient.SetRange(HeaderId, WMOHeader323.SystemId);
        if WMOClient.FindSet() then
            repeat
                if ValidateClient(WMOClient) then begin
                    WMOPrestatie.SetRange(ClientID, WMOClient.SystemId);

                    if WMOPrestatie.FindSet() then
                        repeat
                            ValidatePrestatie(WMOClient, WMOPrestatie);
                        until WMOPrestatie.Next() = 0;
                end;
            until WMOClient.Next() = 0;


        // if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader323) then
        //     exit(false);

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
        WMOProcessor.ValidateProcessStatus(WMOHeader323);

        if Validate() then
            WMOProcessor.Send(WMOHeader323)
        else
            WMOHeader323.SetStatus(ACKWMOHeaderStatus::InvalidRetourCreated);

        WMOHeader323.Modify(true);

        Commit();
        // WMOProcessor.CreateRetour(WMOHeader323); //Not ready yet.
    end;

    local procedure ValidateClient(WMOClient: Record ACKWMOClient): Boolean
    begin
        exit(WMOProcessor.TR304_ExistingClient(WMOClient, WMOHeader323));
    end;


    local procedure ValidatePrestatie(WMOClient: Record ACKWMOClient; WMOPrestatie: Record ACKWMOPrestatie): Boolean
    var
        HealthcareProvider: Record Vendor;
        IndicationQuery: Query ACKWMOIndicationQuery;
        WMOPrestatieQuery: Query ACKWMOPrestatieQuery;
        HealthcareMonthPCRateQuery: Query ACKHealthcareMonthPCRateQuery;
        IndicatieStartdatum, IndicatieEinddatum : Date;
    begin
        // Technische regels

        // TR318: Indien iedere DeclaratiePeriode zorg is geleverd, moet DeclaratiePeriode de kalendermaand volgend op voorgaande DeclaratiePeriode zijn.
        // TR319: Een declaratiebericht bevat alleen prestaties waarvan de ProductPeriode valt binnen de huidige, of een voorgaande declaratieperiode.
        // TR321: Indien in het ToegewezenProduct een Omvang is meegegeven moet GeleverdVolume in de Prestatie passen binnen Volume in het ToegewezenProduct.
        // TR322: Indien in het ToegewezenProduct een Omvang is meegegeven, moet de som van GeleverdVolume in alle ingediende Prestaties die betrekking hebben op dat ToegewezenProduct passen binnen de toegewezen Omvang.
        // TR323: Een credit Prestatie moet gerelateerd zijn aan een eerder verzonden (goedgekeurde) debet Prestatie op basis van sleutelvelden.
        // TR333: DeclaratieNummer van de Declaratie moet uniek zijn voor de aanbieder binnen het wettelijk domein waarop de Declaratie betrekking heeft.
        // TR338: De Prestatie is gerelateerd aan een ToegewezenProduct op basis van het Toewijzingnummer.
        // TR339: ProductCategorie in Prestatie moet gelijk zijn aan ProductCategorie in het ToegewezenProduct indien deze opgenomen is.
        // TR340: ProductCode in Prestatie moet gelijk zijn aan ProductCode in het ToegewezenProduct, indien deze opgenomen is.
        // TR341: Eenheid in Prestatie moet passen bij Eenheid in het ToegewezenProduct.
        // TR346: Indien Eenheid ongelijk is aan waarde 83 (Euro’s), moet IngediendBedrag gelijk zijn aan GeleverdVolume vermenigvuldigd met ProductTarief
        // TR369: Indien in het ToegewezenProduct een Budget is meegegeven, moet de som van GeleverdVolume in alle ingediende Prestaties die betrekking hebben op dat ToegewezenProduct passen binnen het toegewezen Budget.
        // TR378: Vullen met een bestaande gemeentecode uit het overzicht van CBS dat actueel is op Ingangsdatum of ToewijzingIngangsdatum.
        // TR381: ProductCode vullen met een code die, volgens de gehanteerde productcodelijst, past bij de ProductCategorie.
        // TR384: Het is niet toegestaan te declareren op een toewijzing met RedenWijziging waarde "13" (Verwijderd)
        // TR387: De Begindatum van een ProductPeriode is altijd de eerste dag van de kalendermaand waarop de ProductPeriode betrekking heeft tenzij de Ingangsdatum van de toewijzing later in de betreffende maand ligt
        // TR388: De Einddatum van een ProductPeriode is altijd de laatste dag van de kalendermaand waarop de ProductPeriode betrekking heeft tenzij de Einddatum van de toewijzing eerder in de betreffende maand ligt
        // TR389: Prestatie met DebetCredit in IngediendBedrag waarde Debet mag alleen ingezonden worden voor dezelfde ProductPeriode, ProductCategorie en ProductCode met gelijk ToewijzingNummer als er niet al eerder een debetprestatie is verzonden.
        // TR390: DebetCredit mag alleen waarde Credit hebben indien voor Prestatie met gelijk ProductReferentie niet een Prestatie met Credit bestaat
        // TR418: ProductTarief in Prestatie dient overeen te komen met het contractuele tarief van ProductCode.

        HealthcareProvider.Get(WMOHeader323.Afzender);

        //#1 Assigned product No. must be unique for the municipality.
        IndicationQuery.SetRange(IndicationQuery.AssignmentNo, WMOPrestatie.ToewijzingNummer);
        IndicationQuery.SetRange(IndicationQuery.MunicipalityNo, WMOHeader323.Ontvanger);

        IndicationQuery.Open();

        //TR304
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

            CheckDeclarationAmount(IndicationQuery, WMOPrestatie, HealthcareMonthPCRateQuery)
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
                                                                HealthcareMonthPCRateQuery: Query ACKHealthcareMonthPCRateQuery)
    var
        MaxDeclarationDays, DeclaredAmount : integer;
        MaxAllowedVolumeInteger, MaxAllowedAmountInteger, StoppedDays, PrestatieJaar, PrestatieMaand, DaysInMonth : Integer;
        MaxAllowedVolumeDecimal, MaxAllowedAmountDecimal : Decimal;
    begin
        PrestatieJaar := DATE2DMY(WMOPrestatie.Begindatum, 3);
        PrestatieMaand := DATE2DMY(WMOPrestatie.Begindatum, 2);

        StoppedDays := WMOHelper.GetDaysStopped(IndicationQuery.IndicationSystemId, WMOPrestatie.Begindatum, WMOPrestatie.Einddatum);
        DaysInMonth := ACKHelper.NoOfDaysInMonth(PrestatieJaar, PrestatieMaand);

        MaxDeclarationDays := (WMOPrestatie.Einddatum - WMOPrestatie.Begindatum + 1) - StoppedDays;

        if MaxDeclarationDays <= 0 then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR319);
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

        //Tarief wordt niet meegegeven bij eenheid euro's.
        if (WMOPrestatie.Eenheid <> ACKWmoEenheid::Euro) and (WMOPrestatie.ProductTarief <> HealthcareMonthPCRateQuery.Rate) then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR418);

        if WMOPrestatie.GeleverdVolume > MaxAllowedVolumeInteger then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR321);

        if WMOPrestatie.Bedrag > MaxAllowedAmountInteger then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR321);

        if WMOPrestatie.Bedrag > (MaxAllowedAmountInteger - DeclaredAmount) then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId, WMOHeader323.SystemId, ACKWMORule::TR322);
    end;

    local procedure NoOfWeeks(NoOfDays: Integer) Weeks: Integer
    begin
        weeks := NoOfDays div 7;
        if Weeks = 0 then
            Weeks := 1;
    end;

}
