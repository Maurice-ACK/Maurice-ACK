/// <summary>
/// Page ACKWMOMessageRetourCodeLPart
/// </summary>
page 50074 ACKWMOMessageRetourCodeLPart
{
    ApplicationArea = All;
    Caption = 'Retour codes';
    PageType = ListPart;
    SourceTable = ACKWMOMessageRetourCode;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

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
                field(RetourCodeId; Rec.RetourCodeID)
                {
                }
                field(Description; Rec.RetourCodeDescription)
                {
                    Caption = 'Retourcode description';
                }
                field(RuleDescription; Rec.RuleDescription)
                {
                    Caption = 'Rule description';
                }
            }
        }
    }
}