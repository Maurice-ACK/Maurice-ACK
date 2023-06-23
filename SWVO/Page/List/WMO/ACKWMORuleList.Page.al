/// <summary>
/// Page ACKWMORuleList (ID 50149).
/// </summary>
page 50118 ACKWMORuleList
{
    ApplicationArea = All;
    Caption = 'Wmo rules';
    PageType = List;
    SourceTable = ACKWMORule;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Rule; Rec.Rule)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(RetourCodeId; Rec.RetourCodeID)
                {
                }
                field(IsActive; Rec.IsActive)
                {
                }
            }
        }
    }
}