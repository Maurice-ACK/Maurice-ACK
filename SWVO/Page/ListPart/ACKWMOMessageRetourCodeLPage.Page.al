/// <summary>
/// Page ACKWMOMessageRetourCodeLPage (ID 50026).
/// </summary>
page 50026 ACKWMOMessageRetourCodeLPage
{
    Caption = 'Retour codes';
    PageType = ListPart;
    SourceTable = ACKWMOMessageRetourCode;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(RelationTableCaption; Rec.RelationTableCaption)
                {
                    Caption = 'Related table', Locked = true;
                }
                field(RefId; Rec.RefID)
                {
                }
                field(RetourCodeId; Rec.RetourCodeID)
                {
                }

            }
        }
    }
}
