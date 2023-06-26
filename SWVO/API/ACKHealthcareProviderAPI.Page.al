/// <summary>
/// Page ACKHealthcareProviderAPI
/// </summary>
page 50077 ACKHealthcareProviderAPI
{
    APIGroup = 'sharepoint';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Healthcare providers', Locked = true;
    Editable = false;
    EntityName = 'healthcareprovider';
    EntitySetName = 'healthcareproviders';
    PageType = API;
    SourceTable = Vendor;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                }
                field(name; Rec.Name)
                {
                }
                field(email; Rec."E-Mail")
                {
                }
                part(ACKVendPermissionsCardPart; ACKVendPermissionsCardPart)
                {
                    Multiplicity = ZeroOrOne;

                    EntityName = 'permissions';
                    EntitySetName = 'permissions';
                    SubPageLink = "No." = field("No.");
                }
                part(ACKSubcontractorListPart; ACKSubcontractorListPart)
                {
                    Multiplicity = Many;

                    EntityName = 'subcontractor';
                    EntitySetName = 'subcontractors';
                    SubPageLink = HealthcareProviderNo = field("No.");
                }
                part(ACKHCProductCodeListPart; ACKHCProductCodeListPart)
                {
                    Multiplicity = Many;

                    EntityName = 'productCode';
                    EntitySetName = 'productCodes';
                    SubPageLink = HealthcareProviderNo = field("No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        SWVOGeneralSetup: Record ACKSWVOGeneralSetup;
    begin
        SWVOGeneralSetup.Get();
        Rec.SetRange("Vendor Posting Group", SWVOGeneralSetup.HealthcareProviderPostingGroup);
    end;
}