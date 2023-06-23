/// <summary>
/// Page ACKSubcontractorListPart (ID 50078).
/// </summary>
page 50078 ACKSubcontractorListPart
{
    ApplicationArea = All;
    Caption = 'Subcontractors';
    PageType = ListPart;
    SourceTable = ACKSubcontractor;
    UsageCategory = None;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec.SubcontractorNo)
                {
                    Caption = 'No';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
            }
        }
    }
}
