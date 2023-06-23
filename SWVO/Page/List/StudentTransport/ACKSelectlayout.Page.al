/// <summary>
/// Page ACKSelectLayout (ID 50086).
/// </summary>
page 50086 "ACKSelectLayout"
{
    ApplicationArea = All;
    Caption = 'Select layout';
    PageType = List;
    SourceTable = "Custom Report Layout";
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
}
