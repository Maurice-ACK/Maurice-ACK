/// <summary>
/// Page ACKResourceAPI
/// </summary>
page 50033 ACKResourceAPI
{
    APIGroup = 'sharepoint';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Hulpmiddelen API', Locked = true;
    DelayedInsert = true;
    EntityName = 'resource';
    EntitySetName = 'resources';
    PageType = API;
    SourceTable = ACKResource;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("type"; Rec."Type")
                {
                }
                field(ssn; Rec.SSN)
                {
                }
                field(initials; Rec.Initials)
                {
                }
                field(surname; Rec.Surname)
                {
                }
                field(gender; Rec.Gender)
                {
                }
                field(birthdate; Rec.Birthdate)
                {
                }
                field(postCode; Rec.PostCode)
                {
                }
                field(placeOfResidence; Rec."Place of residence")
                {
                }
                field(street; Rec.Street)
                {
                }
                field(houseNumber; Rec.HouseNumber)
                {
                }
                field(letter; Rec.Letter)
                {
                }
                field(municipalityNo; Rec.MunicipalityNo)
                {
                }
                field(healthcareproviderNo; Rec.HealthcareproviderNo)
                {
                }
                field(productCode; Rec.ProductCode)
                {
                }
                field(deliveryDate; Rec.StartDate)
                {
                }
                field(endDate; Rec.EndDate)
                {
                }
                field(reasonEnd; Rec.ReasonEnd)
                {
                }
                field(insured; Rec.Insured)
                {
                }
                field(importDate; Rec.ImportDate)
                {
                }
            }
        }
    }
}
