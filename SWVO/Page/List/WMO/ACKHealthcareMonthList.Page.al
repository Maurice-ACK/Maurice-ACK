/// <summary>
/// Page ACKHealthcareMonthList
/// </summary>
page 50014 ACKHealthcareMonthList
{
    Caption = 'Healthcare months - product rates';
    PageType = List;
    SourceTable = ACKHealthcareMonth;
    CardPageId = ACKProductCodeRateDoc;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Year; Rec.Year)
                {
                    Enabled = false;
                }
                field(Month; Rec.Month)
                {
                    Enabled = false;
                }
                field(IsActive; Rec.IsActive)
                {
                    Enabled = false;
                }
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
                begin
                    Rec.Copy();
                    CurrPage.Update();
                end;
            }
        }
    }
}
