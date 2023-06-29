/// <summary>
/// Page ACKGenerateProductCodeRates
/// </summary>
page 50013 ACKGenerateProductCodeRates
{
    Caption = 'Copy product rates';
    PageType = StandardDialog;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            field(Year; Year)
            {
                Caption = 'Year';
            }
            field(Month; Month)
            {
                Caption = 'Month';
            }
            field(IsActive; IsActive)
            {
                Caption = 'Active';
            }
        }
    }

    /// <summary>
    /// Setup.
    /// </summary>
    /// <param name="_Year">Integer.</param>
    /// <param name="_Month">Enum ACKMonthOfYear.</param>
    /// <param name="_IsActive">Boolean.</param>
    procedure Setup(_Year: Integer; _Month: Enum ACKMonthOfYear; _IsActive: Boolean)
    begin
        Year := _Year;
        Month := _Month;
        IsActive := _IsActive;
    end;

    /// <summary>
    /// Setup.
    /// </summary>
    /// <param name="ProductCodeRateMonth">Record ACKProductCodeRateMonth.</param>
    procedure Setup(ProductCodeRateMonth: Record ACKProductCodeRateMonth)
    begin
        Year := ProductCodeRateMonth.Year;
        Month := ProductCodeRateMonth.Month;
        IsActive := ProductCodeRateMonth.IsActive;
    end;

    /// <summary>
    /// GetYear.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure GetYear(): Integer
    begin
        exit(Year);
    end;

    /// <summary>
    /// GetMonth.
    /// </summary>
    /// <returns>Return value of type Enum ACKMonthOfYear.</returns>
    procedure GetMonth(): Enum ACKMonthOfYear
    begin
        exit(Month);
    end;

    /// <summary>
    /// GetIsActive.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetIsActive(): Boolean
    begin
        exit(IsActive);
    end;

    var
        Year: Integer;
        Month: Enum ACKMonthOfYear;
        IsActive: Boolean;
}
