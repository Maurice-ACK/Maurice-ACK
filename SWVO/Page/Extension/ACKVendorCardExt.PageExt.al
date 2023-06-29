/// <summary>
/// PageExtension ACKVendorCardExtextends Record Vendor Card.
/// </summary>
pageextension 50000 ACKVendorCardExt extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            group(SWVO)
            {
                field(ACKStartEndMonthDeclaration; Rec.ACKStartEndMonthDeclaration)
                {
                    ApplicationArea = All;
                }

                group(Permissions)
                {
                    Caption = 'Permissions';

                    field(PermiWMO; Rec.ACKPermiWMO)
                    {
                        ApplicationArea = All;
                    }
                    field(PermHomeless; Rec.ACKPermHomeless)
                    {
                        ApplicationArea = All;
                    }
                    field(PermResources; Rec.ACKPermResources)
                    {
                        ApplicationArea = All;
                    }
                    field(PermWMOTransport; Rec.ACKPermWMOTransport)
                    {
                        ApplicationArea = All;
                    }
                    field(PermOtherDocuments; Rec.ACKPermOtherDocuments)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    actions
    {
        addlast("Ven&dor")
        {
            action(Productcodes)
            {
                ApplicationArea = All;
                Caption = 'Productcodes';
                Image = SetupList;
                RunObject = Page ACKHCProductcodeList;
                RunPageLink = HealthcareProviderNo = FIELD("No.");
                ToolTip = 'View or set up product codes.';
            }
            action(Subcontractors)
            {
                ApplicationArea = All;
                Caption = 'Subcontractors';
                Image = ContactPerson;
                RunObject = Page ACKSubcontractorList;
                RunPageLink = HealthcareProviderNo = FIELD("No.");
                ToolTip = 'View or set up subcontractors.';
            }
        }
    }
}