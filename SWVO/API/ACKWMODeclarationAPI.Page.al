/// <summary>
/// Page ACKWMODeclarationAPI (ID 50139).
/// </summary>
page 50110 ACKWMODeclarationAPI
{
    APIGroup = 'sharepoint';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Wmo Declarations', Locked = true;
    Editable = false;
    EntityName = 'declaration';
    EntitySetName = 'declarations';
    PageType = API;
    SourceTable = ACKWMODeclarationLine;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(declarationHeaderNo; Rec.DeclarationHeaderNo)
                {
                }
                field(municipalityNo; Rec.MunicipalityNo)
                {
                }
                field(municipality; Municipality)
                {
                }
                field(healthcareProviderNo; Rec.HealthcareProviderNo)
                {
                }
                field(healthcareProviderName; HealthcareProviderName)
                {
                }
                field(assignmentNo; Rec.AssignmentNo)
                {
                }
                field(declarationNo; WMODeclarationHeader.DeclarationNo)
                {
                }
                field(reference; Rec.Reference)
                {
                }
                field(previousReference; Rec.PreviousReference)
                {
                }
                field(amount; Rec.Amount)
                {
                }
                field(productCategory; Rec.ProductCategoryId)
                {
                }
                field(productCode; Rec.ProductCode)
                {
                }
                field(startDate; Rec.StartDate)
                {
                }
                field(endDate; Rec.EndDate)
                {
                }
                field(volume; Rec.Volume)
                {
                }
                field(unit; Rec.Unit)
                {
                }
                field(productRate; Rec.ProductRate)
                {
                }
                field(status; WMODeclarationHeader.Status)
                {
                }
                field(healthcareProvider; WMODeclarationHeader.HealthcareProviderNo)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        WMODeclarationHeader.Get(Rec.DeclarationHeaderNo);

        Vendor.Get(Rec.HealthcareProviderNo);
        HealthcareProviderName := Vendor.Name;

        Customer.Get(Rec.MunicipalityNo);
        Municipality := Customer.Name;
    end;

    var
        WMODeclarationHeader: Record ACKWMODeclarationHeader;
        HealthcareProviderName, Municipality : Text[100];
}