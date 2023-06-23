page 50039 ACKVendPermissionsCardPart
{
    ApplicationArea = All;
    Caption = 'Permissions';
    PageType = CardPart;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(PermiWMO; Rec.ACKPermiWMO)
                {
                }
                field(PermHomeless; Rec.ACKPermHomeless)
                {
                }
                field(PermResources; Rec.ACKPermResources)
                {
                }
                field(PermWMOTransport; Rec.ACKPermWMOTransport)
                {
                }
                field(PermOtherDocuments; Rec.ACKPermOtherDocuments)
                {
                }
            }
        }
    }
}
