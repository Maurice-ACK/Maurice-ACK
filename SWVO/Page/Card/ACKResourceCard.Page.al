/// <summary>
/// Page ACKResourceCard (ID 50065).
/// </summary>
page 50065 ACKResourceCard
{
    Caption = 'Resource';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Navigate';
    RefreshOnActivate = true;
    SourceTable = ACKResource;
    UsageCategory = None;
    DelayedInsert = true;
    ApplicationArea = All;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;


    layout
    {
        area(content)
        {
            group(Resource)
            {
                Caption = 'Hulpmiddel', Locked = true;

                field(ImportDate; Rec.ImportDate)
                {
                }
                field("Type"; Rec."Type")
                {
                }
                field(HealthcareproviderNo; Rec.HealthcareproviderNo)
                {
                }
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(ProductDesc; Rec.ProductDesc)
                {
                }
                field(Insured; Rec.Insured)
                {
                }
                field(StartDate; Rec.StartDate)
                {
                }
                field(EndDate; Rec.EndDate)
                {
                }
                field(ReasonEnd; Rec.ReasonEnd)
                {
                }
                field(LogField; Rec.LogField)
                {
                }
            }
            group(Personal)
            {
                Caption = 'Persoonsgegevens', Locked = true;

                field(ClientNo; Rec.ClientNo)
                {
                    Editable = false;
                }
                field(SSN; Rec.SSN)
                {
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field(Surname; Rec.Surname)
                {
                }
                field(Initials; Rec.Initials)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Birthdate; Rec.Birthdate)
                {
                    Editable = true;
                }
                field(DeceasedDate; Rec.DeceasedDate)
                {
                    Editable = true;
                }

                group(Address)
                {
                    Caption = 'Adres', Locked = true;

                    field(PostCode; Rec.PostCode)
                    {
                    }
                    field(HouseNumber; Rec.HouseNumber)
                    {
                    }
                    field(Letter; Rec.Letter)
                    {
                    }
                    field(Street; Rec.Street)
                    {
                    }
                    field("Place of residence"; Rec."Place of residence")
                    {
                    }
                    field(MunicipalityNo; Rec.MunicipalityNo)
                    {
                    }
                    field(MunicipalityName; Rec.MunicipalityName)
                    {
                    }
                }
            }
        }
    }
}