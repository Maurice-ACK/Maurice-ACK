/// <summary>
/// Page ACKWMODeclarationLineList
/// </summary>
page 50112 ACKWMODeclarationLineList
{
    ApplicationArea = All;
    Caption = 'Declaration lines';
    PageType = List;
    SourceTable = ACKWMODeclarationLine;
    PopulateAllFields = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(ClientNo; Rec.ClientNo)
                {
                }
                field(IndicationID; Rec.IndicationID)
                {
                }
                field(Reference; Rec.Reference)
                {
                }
                field(PreviousReference; Rec.PreviousReference)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(StartDate; Rec.StartDate)
                {
                }
                field(EndDate; Rec.EndDate)
                {
                }
                field(Volume; Rec.Volume)
                {
                }
                field(Unit; Rec.Unit)
                {
                }
                field(ProductRate; Rec.ProductRate)
                {
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                    Visible = true;
                }
                field(HealthcareProviderNo; Rec.HealthcareProviderNo)
                {
                }
                field(AssignmentNo; Rec.AssignmentNo)
                {
                }
                field(ProductCategory; Rec.ProductCategoryId)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }
}
