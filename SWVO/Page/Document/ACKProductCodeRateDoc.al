/// <summary>
/// Page ACKProductCodeRateDocument
/// </summary>
page 50011 ACKProductCodeRateDoc
{
    ApplicationArea = All;
    Caption = 'Product code rates';
    PageType = Document;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    DelayedInsert = false;
    SourceTable = ACKProductCodeRateMonth;
    RefreshOnActivate = true;
    DataCaptionFields = Year, Month;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Period';
                field(Year; Rec.Year)
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(IsActive; Rec.IsActive)
                {
                }
            }
            part(ProductCodeRates; ACKProductCodeRateListPart)
            {
                Caption = 'Rates';
                Editable = true;
                SubPageLink = ProductCodeRateMonthID = FIELD(ID);
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Generate)
            {
                Image = CopyBOM;
                Caption = 'Copy';
                trigger OnAction()
                var
                    ProductCodeRateMonthNew: Record ACKProductCodeRateMonth;
                begin
                    ProductCodeRateMonthNew := Rec.Copy();
                    if not ProductCodeRateMonthNew.IsEmpty() then
                        CurrPage.SetRecord(ProductCodeRateMonthNew);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Year := Date2DMY(Today(), 3);
        Rec.Month := ACKMonthOfYear.FromInteger(Date2DMY(Today(), 2));
    end;
}
