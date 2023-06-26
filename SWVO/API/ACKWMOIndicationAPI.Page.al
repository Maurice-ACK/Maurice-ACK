/// <summary>
/// Page ACKWMOIndicationAPI
/// </summary>
page 50114 ACKWMOIndicationAPI
{
    APIGroup = 'sharepoint';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Wmo Indications', Locked = true;
    Editable = false;
    EntityName = 'indication';
    EntitySetName = 'indications';
    PageType = API;
    SourceTable = ACKWMOIndication;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(clientNo; Rec.ClientNo)
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
                field(productCategoryId; Rec.ProductCategoryId)
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
                field(effectiveStartDate; Rec.EffectiveStartDate)
                {
                }
                field(effectiveEndDate; Rec.EffectiveEndDate)
                {
                }
                field(assignedDateTime; Rec.AssignedDateTime)
                {
                }
                field(productVolume; Rec.ProductVolume)
                {
                }
                field(productUnit; Rec.ProductUnit)
                {
                }
                field(productFrequency; Rec.ProductFrequency)
                {
                }
                field(budget; Rec.Budget)
                {
                }
                field(redenBeeindiging; Rec.RedenBeeindiging)
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
        Vendor.Get(Rec.HealthcareProviderNo);
        HealthcareProviderName := Vendor.Name;

        Customer.Get(Rec.MunicipalityNo);
        Municipality := Customer.Name;
    end;

    var
        HealthcareProviderName, Municipality : Text[100];
}
