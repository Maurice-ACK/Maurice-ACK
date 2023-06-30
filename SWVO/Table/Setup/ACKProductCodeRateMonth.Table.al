/// <summary>
/// Table ACKProductCodeRateMonth.
/// </summary>
table 50028 ACKProductCodeRateMonth
{
    Caption = 'Product code rate - month';
    DataClassification = SystemMetadata;
    DataCaptionFields = Year, Month;
    LookupPageId = ACKProductCodeRateList;
    DrillDownPageId = ACKProductCodeRateList;

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
        ProductCodeRate.SetRange(ProductCodeRateMonthID, Rec.ID);
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
        TotalDays := ACKHelper.NoOfDaysInMonth(Rec.Year, Rec.Month.AsInteger());
    end;

    /// <summary>
    /// Copy.
    /// </summary>
    /// <returns>Return variable ProductCodeRateMonth of type Record ACKProductCodeRateMonth.</returns>
    procedure Copy() ProductCodeRateMonth: Record ACKProductCodeRateMonth
    var
        ACKProductCodeRateFrom, ACKProductCodeRateNew : Record ACKProductCodeRate;
        ACKGenerateProductCodeRates: Page ACKGenerateProductCodeRates;
        ResponseAction: Action;
        ProductCodeRateMonthCreatedLbl: Label '%1: %2, %3 created.', Comment = '%1 = Table caption, %2 = Year, %3 = Month';
    begin
        ACKGenerateProductCodeRates.Setup(Rec);
        ResponseAction := ACKGenerateProductCodeRates.RunModal();
        case ResponseAction of
            Action::OK:
                begin
                    ProductCodeRateMonth := CreateNewMonth(ACKGenerateProductCodeRates.GetYear(), ACKGenerateProductCodeRates.GetMonth(), ACKGenerateProductCodeRates.GetIsActive());
                    ACKProductCodeRateFrom.SetRange(ProductCodeRateMonthID, Rec.ID);
                    if ACKProductCodeRateFrom.FindSet(true) then
                        repeat
                            ACKProductCodeRateNew.Init();
                            ACKProductCodeRateNew.TransferFields(ACKProductCodeRateFrom);
                            ACKProductCodeRateNew.ProductCodeRateMonthID := ProductCodeRateMonth.ID;
                            ACKProductCodeRateNew.Insert(true);
                        until ACKProductCodeRateFrom.Next() = 0;

                    Message(ProductCodeRateMonthCreatedLbl, ProductCodeRateMonth.TableCaption(), ProductCodeRateMonth.Year, ProductCodeRateMonth.Month);
                end;
        end;
    end;

    /// <summary>
    /// CreateNewMonth.
    /// </summary>
    /// <param name="_Year">Integer.</param>
    /// <param name="_Month">Enum ACKMonthOfYear.</param>
    /// <param name="_IsActive">Boolean.</param>
    /// <returns>Return variable ProductCodeRateMonthNew of type Record ACKProductCodeRateMonth.</returns>
    procedure CreateNewMonth(_Year: Integer; _Month: Enum ACKMonthOfYear; _IsActive: Boolean) ProductCodeRateMonthNew: Record ACKProductCodeRateMonth
    var
        ProductCodeRateMonthDuplicateErr: Label '%1: %2, %3 already exists.', Comment = '%1 = Table caption, %2 = Year, %3 = Month';
    begin
        ProductCodeRateMonthNew.SetCurrentKey(Year, Month);
        ProductCodeRateMonthNew.SetRange(Year, _Year);
        ProductCodeRateMonthNew.SetRange(Month, _Month);

        if not ProductCodeRateMonthNew.IsEmpty() then
            Error(ProductCodeRateMonthDuplicateErr, ProductCodeRateMonthNew.TableCaption(), _Year, _Month);

        ProductCodeRateMonthNew.Init();
        ProductCodeRateMonthNew.Year := _Year;
        ProductCodeRateMonthNew.Month := _Month;
        ProductCodeRateMonthNew.IsActive := _IsActive;
        ProductCodeRateMonthNew.Insert(true);
    end;

    var
        ACKHelper: Codeunit ACKHelper;
    //NrFormatLbl: Label '%1-%2', Comment = '%1 = Year, %2 = Month', MaxLength = 7, Locked = true;
}

