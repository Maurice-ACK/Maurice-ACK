/// <summary>
/// Page ACKProductCodeRateDocument
/// </summary>
page 50011 ACKProductCodeRateDoc
{
    ApplicationArea = All;
    Caption = 'Healthcare month - product code rates';
    PageType = Document;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    DelayedInsert = false;
    SourceTable = ACKHealthcareMonth;
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
                SubPageLink = HealthcareMonthID = FIELD(ID);
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
                    ACKHealthcareMonthNew: Record ACKHealthcareMonth;
                begin
                    ACKHealthcareMonthNew := Rec.Copy();
                    if not ACKHealthcareMonthNew.IsEmpty() then
                        CurrPage.SetRecord(ACKHealthcareMonthNew);
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
