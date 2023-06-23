/// <summary>
/// Table ACKHealthcareMonth.
/// </summary>
table 50028 ACKHealthcareMonth
{
    Caption = 'Healthcare month';
    DataClassification = SystemMetadata;
    DataCaptionFields = Year, Month;
    LookupPageId = ACKHealthcareMonthList;
    DrillDownPageId = ACKHealthcareMonthList;

    fields
    {
        field(10; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID', Locked = true;
            Editable = false;
        }
        field(20; Year; Integer)
        {
            Caption = 'Year';
            MaxValue = 3000;
            MinValue = 2000;
        }
        field(30; Month; Enum ACKMonthOfYear)
        {
            Caption = 'Month';
        }
        field(40; IsActive; Boolean)
        {
            Caption = 'Active';
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(YearMonth; Year, Month)
        {
            Unique = true;
        }
    }

    trigger OnDelete()
    var
        ProductCodeRate: Record ACKProductCodeRate;
    begin
        ProductCodeRate.SetRange(HealthcareMonthID, Rec.ID);
        ProductCodeRate.DeleteAll(true);
    end;


    /// <summary>
    /// GetFromDate.
    /// </summary>
    /// <param name="_Date">Date.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetFromDate(_Date: Date) Found: Boolean
    var
        YearFilter: Integer;
        MonthFilter: Enum ACKMonthOfYear;
    begin
        Clear(Rec);
        YearFilter := Date2DMY(_Date, 3);
        MonthFilter := ACKHelper.GetMonthByDate(_Date);

        Rec.SetRange(Year, YearFilter);
        Rec.SetRange(Month, MonthFilter);
        Rec.SetRange(IsActive, true);
        Found := Rec.FindFirst();
    end;

    /// <summary>
    /// NoOfDaysInMonth.
    /// </summary>
    /// <returns>Return variable TotalDays of type Integer.</returns>
    procedure NoOfDaysInMonth() TotalDays: Integer
    begin
        TotalDays := ACKHelper.NoOfDaysInMonth(Rec.Year, Rec.Month);
    end;

    /// <summary>
    /// Copy.
    /// </summary>
    /// <returns>Return variable ACKHealthcareMonthNew of type Record ACKHealthcareMonth.</returns>
    procedure Copy() ACKHealthcareMonthNew: Record ACKHealthcareMonth
    var
        ACKProductCodeRateFrom, ACKProductCodeRateNew : Record ACKProductCodeRate;
        ACKGenerateProductCodeRates: Page ACKGenerateProductCodeRates;
        ResponseAction: Action;
        HealthcareMonthCreatedLbl: Label '%1: %2, %3 created.', Comment = '%1 = Table caption, %2 = Year, %3 = Month';
    begin
        ACKGenerateProductCodeRates.Setup(Rec);
        ResponseAction := ACKGenerateProductCodeRates.RunModal();
        case ResponseAction of
            Action::OK:
                begin
                    ACKHealthcareMonthNew := CreateNewMonth(ACKGenerateProductCodeRates.GetYear(), ACKGenerateProductCodeRates.GetMonth(), ACKGenerateProductCodeRates.GetIsActive());
                    ACKProductCodeRateFrom.SetRange(HealthcareMonthID, Rec.ID);
                    if ACKProductCodeRateFrom.FindSet(true) then
                        repeat
                            ACKProductCodeRateNew.Init();
                            ACKProductCodeRateNew.TransferFields(ACKProductCodeRateFrom);
                            ACKProductCodeRateNew.HealthcareMonthID := ACKHealthcareMonthNew.ID;
                            ACKProductCodeRateNew.Insert(true);
                        until ACKProductCodeRateFrom.Next() = 0;

                    Message(HealthcareMonthCreatedLbl, ACKHealthcareMonthNew.TableCaption(), ACKHealthcareMonthNew.Year, ACKHealthcareMonthNew.Month);
                end;
        end;
    end;

    /// <summary>
    /// CreateNewMonth.
    /// </summary>
    /// <param name="_Year">Integer.</param>
    /// <param name="_Month">Enum ACKMonthOfYear.</param>
    /// <param name="_IsActive">Boolean.</param>
    /// <returns>Return variable ACKHealthcareMonthNew of type Record ACKHealthcareMonth.</returns>
    procedure CreateNewMonth(_Year: Integer; _Month: Enum ACKMonthOfYear; _IsActive: Boolean) ACKHealthcareMonthNew: Record ACKHealthcareMonth
    var
        HealthCareMonthDuplicateErr: Label '%1: %2, %3 already exists.', Comment = '%1 = Table caption, %2 = Year, %3 = Month';
    begin
        ACKHealthcareMonthNew.SetCurrentKey(Year, Month);
        ACKHealthcareMonthNew.SetRange(Year, _Year);
        ACKHealthcareMonthNew.SetRange(Month, _Month);

        if not ACKHealthcareMonthNew.IsEmpty() then
            Error(HealthCareMonthDuplicateErr, ACKHealthcareMonthNew.TableCaption(), _Year, _Month);

        ACKHealthcareMonthNew.Init();
        ACKHealthcareMonthNew.Year := _Year;
        ACKHealthcareMonthNew.Month := _Month;
        ACKHealthcareMonthNew.IsActive := _IsActive;
        ACKHealthcareMonthNew.Insert(true);
    end;

    var
        ACKHelper: Codeunit ACKHelper;
        NrFormatLbl: Label '%1-%2', Comment = '%1 = Year, %2 = Month', MaxLength = 7, Locked = true;
}

