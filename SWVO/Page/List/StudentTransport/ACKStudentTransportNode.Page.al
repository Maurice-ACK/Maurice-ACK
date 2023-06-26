/// <summary>
/// Page ACKStudentTransportNode
/// </summary>
page 50040 ACKStudentTransportNode
{
    ApplicationArea = All;
    Caption = 'Vervoer node', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportNode;
    UsageCategory = Administration;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Active; Rec.Active)
                {
                }
                field(Municipality; Rec.Municipality)
                {
                }
                field(Contact; Rec.Contact)
                {
                }
                field(EmailAddress; Rec.EmailAddress)
                {
                }
                field(ExternalId; Rec.ExternalId)
                {
                }
                field(MobileNumber; Rec.MobileNumber)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(NodeId; Rec.NodeId)
                {
                }
                field(PhoneNumber; Rec.PhoneNumber)
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field(StreetName; Rec.StreetName)
                {
                }
                field(StreetNumber; Rec.StreetNumber)
                {
                }
                field(StreetNumberAddition; Rec.StreetNumberAddition)
                {
                }
                field(ZipCode; Rec.ZipCode)
                {
                }
                field(nodeTypeID; Rec.nodeType)
                {
                }
                field(routeID; Rec.routeID)
                {
                }
            }
        }
    }
}
