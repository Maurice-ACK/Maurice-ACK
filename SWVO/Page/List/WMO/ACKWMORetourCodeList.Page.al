/// <summary>
/// Page ACKRetourCodeList (ID 50000).
/// </summary>
page 50000 ACKWMORetourCodeList
{
    ApplicationArea = All;
    Caption = 'Retour code';
    PageType = List;
    SourceTable = ACKWMORetourCode;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.ID)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(IsActive; Rec.IsActive)
                {
                }
                field(MessageInvalid; Rec.MessageInvalid)
                {
                }
            }
        }
    }
}