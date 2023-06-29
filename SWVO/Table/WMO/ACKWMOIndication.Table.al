/// <summary>
/// Table ACKWMOIndication.
/// </summary>
table 50009 ACKWMOIndication
{
    Caption = 'Wmo Indication';
    DataClassification = CustomerContent;
    LookupPageId = ACKWMOIndicationList;
    DrillDownPageId = ACKWMOIndicationList;

    fields
    {
        field(10; ID; BigInteger)
        {
            AutoIncrement = true;
        }
        field(20; ClientNo; Code[20])
        {
            Caption = 'Client No.';
            TableRelation = ACKClient.ClientNo;
            NotBlank = true;
        }
        field(30; MunicipalityNo; Code[20])
        {
            Caption = 'Municipality No.';
            TableRelation = Customer."No.";
            NotBlank = true;

            trigger OnValidate()
            begin
                ACKHelper.ValidateMunicipalityRelation(Rec.MunicipalityNo, true, true);
            end;

            trigger OnLookup()
            var
                Customer: Record Customer;
            begin
                if ACKHelper.CustomerLookup(Customer, true) = Action::LookupOK then
                    Rec.MunicipalityNo := Customer."No.";
            end;
        }
        field(40; HealthcareProviderNo; Code[20])
        {
            Caption = 'Healthcare provider No.';
            TableRelation = Vendor."No.";
            NotBlank = true;

            trigger OnValidate()
            begin
                ACKHelper.ValidateHealthcareProviderRelation(Rec.HealthcareProviderNo, true, true);
            end;

            trigger OnLookup()
            var
                Vendor: Record Vendor;
            begin
                if ACKHelper.VendorLookup(Vendor, true) = Action::LookupOK then
                    Rec.HealthcareProviderNo := Vendor."No.";
            end;
        }
        field(50; AssignmentNo; Integer)
        {
            Caption = 'Assignment No.';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.AssignmentNo);
            end;
        }
        field(60; ProductCategoryId; Code[2])
        {
            Caption = 'Category Id';
            Editable = false;
            TableRelation = ACKWMOProductCode.CategoryID where(ProductCode = field(ProductCode));
        }
        field(70; ProductCode; Code[5])
        {
            Caption = 'Product code';
            TableRelation = ACKWMOProductCode.ProductCode;

            trigger OnValidate()
            var
                ACKWMOProductCode: Record ACKWMOProductCode;
            begin
                if ACKWMOProductCode.Get(Rec.ProductCode) then
                    Validate(Rec.ProductCategoryId, ACKWMOProductCode.CategoryID);
            end;
        }
        field(80; StartDate; Date)
        {
            Caption = 'Startdatum', Locked = true;

            trigger OnValidate()
            begin
                if (Rec.StartDate > Rec.EndDate) and (Rec.EndDate <> 0D) then
                    Error(StartDateAfterEndDateErr, FieldCaption(StartDate), FieldCaption(EndDate));
            end;
        }
        field(90; EndDate; Date)
        {
            Caption = 'Einddatum', Locked = true;

            trigger OnValidate()
            begin
                Rec.Validate(StartDate);
            end;
        }
        field(100; EffectiveStartDate; Date)
        {
            Caption = 'Effectieve startdatum', Locked = true;

            trigger OnValidate()
            begin
                //ToDo doesnt work when clearing enddate
                // if (Rec.EffectiveStartDate > Rec.EffectiveEndDate) and (Rec.EndDate <> 0D) then
                //     Error(StartDateAfterEndDateErr, FieldCaption(EffectiveStartDate), FieldCaption(EffectiveEndDate));
            end;
        }
        field(110; EffectiveEndDate; Date)
        {
            Caption = 'Effectieve einddatum', Locked = true;

            trigger OnValidate()
            begin
                Rec.Validate(EffectiveStartDate);
            end;
        }
        field(120; AssignedDateTime; DateTime)
        {
            Caption = 'Toewijzingsdatum', Locked = true;
        }
        field(130; ProductVolume; Integer)
        {
            NotBlank = true;
            MinValue = 0;
            MaxValue = 99999999;
            Caption = 'Volume', Locked = true;
        }
        field(140; ProductUnit; enum ACKWMOEenheid)
        {
            NotBlank = true;
            Caption = 'Eenheid', Locked = true;
        }
        field(150; ProductFrequency; enum ACKWMOFrequentie)
        {
            Caption = 'Frequentie', Locked = true;
        }
        field(160; Budget; Integer)
        {
            MinValue = 0;
            MaxValue = 99999999;
            Caption = 'Budget', Locked = true;
        }
        field(170; RedenBeeindiging; Text[255])
        {
            Caption = 'Reden beëindiging', Locked = true;
            InitValue = Empty;
        }
        field(180; RedenWijziging; Enum ACKWMORedenWijziging)
        {
            Caption = 'Reden wijziging', Locked = true;
            InitValue = Empty;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(Key2; MunicipalityNo, AssignmentNo)
        {
            Unique = true;
        }
        key(SortOrder; ClientNo, MunicipalityNo, HealthcareProviderNo, ProductCode, StartDate)
        {
        }
    }

    /// <summary>
    /// TempStopActive.
    /// </summary>
    /// <param name="_Date">Date.</param>
    /// <returns>Return variable Active of type Boolean.</returns>
    procedure TempStopActive(_Date: Date) Active: Boolean
    var
        IndicationTempStop: Record ACKIndicationTempStop;
    begin
        IndicationTempStop.SetCurrentKey(StartDate);
        IndicationTempStop.SetAscending(StartDate, false);

        IndicationTempStop.SetRange(IndicationSystemID, Rec.SystemId);
        IndicationTempStop.SetFilter(StartDate, '<=%1', _date);
        IndicationTempStop.SetFilter(EndDate, '>=%1|%2', _date, 0D);

        Active := not IndicationTempStop.IsEmpty();
    end;

    /// <summary>
    /// SetFilterTempStop.
    /// </summary>
    /// <param name="IndicationTempStop">VAR Record ACKIndicationTempStop.</param>
    /// <param name="_Date">Date. Optional parameter, if provided will set additional filters.</param>
    local procedure SetFilterTempStop(var IndicationTempStop: Record ACKIndicationTempStop; _Date: Date)
    begin
        IndicationTempStop.SetCurrentKey(StartDate);
        IndicationTempStop.SetAscending(StartDate, false);
        IndicationTempStop.SetRange(IndicationSystemID, Rec.SystemId);

        if _Date <> 0D then begin
            IndicationTempStop.SetFilter(StartDate, '<=%1', _Date);
            IndicationTempStop.SetFilter(EndDate, '>=%1|%2', _Date, 0D);
        end;
    end;

    /// <summary>
    /// IsTempStopActive.
    /// </summary>
    /// <param name="_Date">Date.</param>
    /// <returns>Return variable Active of type Boolean.</returns>
    procedure IsTempStopActive(_Date: Date) Active: Boolean
    var
        IndicationTempStop: Record ACKIndicationTempStop;
    begin
        SetFilterTempStop(IndicationTempStop, _Date);
        Active := not IndicationTempStop.IsEmpty();
    end;

    /// <summary>
    /// GetTempStop.
    /// </summary>
    /// <param name="_date">Date.</param>
    /// <param name="IndicationTempStop">VAR Record ACKIndicationTempStop.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetTempStop(var IndicationTempStop: Record ACKIndicationTempStop; _date: Date) Found: Boolean
    var
        InvalidDateParamErr: Label '_Date parameter cannot be 0D.', Locked = true;
    begin
        if _date = 0D then
            error(InvalidDateParamErr);

        SetFilterTempStop(IndicationTempStop, _Date);
        Found := IndicationTempStop.FindFirst();
    end;

    /// <summary>
    /// GetLastTempStop.
    /// </summary>
    /// <param name="IndicationTempStop">VAR Record ACKIndicationTempStop.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetLastTempStop(var IndicationTempStop: Record ACKIndicationTempStop) Found: Boolean
    begin
        SetFilterTempStop(IndicationTempStop, 0D);
        Found := IndicationTempStop.FindFirst();
    end;

    /// <summary>
    /// GetRealEndDate.
    /// </summary>
    /// <returns>Return value of type Date.</returns>
    procedure GetRealEndDate(): Date
    begin
        if (Rec.EffectiveEndDate = 0D) or ((Rec.EndDate <> 0D) and (Rec.EndDate < Rec.EffectiveEndDate)) then
            exit(Rec.EndDate);
        exit(Rec.EffectiveEndDate);
    end;

    /// <summary>
    /// GetRealStartDate.
    /// </summary>
    /// <returns>Return value of type Date.</returns>
    procedure GetRealStartDate(): Date
    begin
        if Rec.EffectiveStartDate = 0D then
            exit(Rec.StartDate);
        exit(Rec.EffectiveStartDate);
    end;

    var
        ACKHelper: Codeunit ACKHelper;
        StartDateAfterEndDateErr: Label '%1 cannot be after %2', Comment = '%1 = Start date; %2 = End Date', MaxLength = 50;
}
