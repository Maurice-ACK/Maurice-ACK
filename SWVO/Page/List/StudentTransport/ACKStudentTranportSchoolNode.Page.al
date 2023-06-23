/// <summary>
/// Page ACKStudentTranportSchoolNode (ID 50096).
/// </summary>
page 50096 ACKStudentTranportSchoolNode
{
    ApplicationArea = All;
    Caption = 'School', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportSchoolNode;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                { }
                field(School; Rec.School)
                { }
                field(nodeTypeId; Rec.nodeTypeId)
                { }
            }
        }
    }


}
