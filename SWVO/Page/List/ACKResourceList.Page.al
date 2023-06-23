/// <summary>
/// Page ACKResourceList (ID 50066).
/// </summary>
page 50066 ACKResourceList
{
    ApplicationArea = All;
    Caption = 'Hulpmiddelen', Locked = true;
    CardPageID = ACKResourceCard;
    DataCaptionFields = type;
    PageType = List;
    SourceTable = ACKResource;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    Editable = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; rec.Id)
                {
                }
                field(ClientNo; rec.ClientNo)
                {
                }
                field(HealthcareProviderName; rec.HealthcareProviderName)
                {
                }
                field(Initials; rec.Initials)
                {
                }
                field(Surname; Rec.Surname)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("type"; Rec."type")
                {
                }
                field(SSN; Rec.SSN)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(ProductDesc; rec.ProductDesc)
                {
                }
                field(StartDate; Rec.StartDate)
                {
                }
                field(EndDate; Rec.EndDate)
                {
                }
                field(Insured; Rec.Insured)
                {
                }
                field(ReasonEnd; Rec.ReasonEnd)
                {
                }
                field(Birthdate; Rec.Birthdate)
                {
                }
                field(DeceasedDate; Rec.DeceasedDate)
                {
                }
                field("Place of residence"; Rec."Place of residence")
                {
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                }
                field(Street; Rec.Street)
                {
                }
                field(HouseNumber; Rec.HouseNumber + Rec.Letter)
                {
                    Caption = 'Huisnummer', Locked = true;
                }
                field(PostCode; Rec.PostCode)
                {
                }
                field(ImportDate; Rec.ImportDate)
                {
                }
            }

        }
    }
}
