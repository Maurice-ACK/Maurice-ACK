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
            group(Gegevens)
            {
                field(Id; Rec.Id)
                {
                    Editable = true;
                }
                field("Type"; Rec."Type")
                {
                    Editable = true;
                }
                field(ClientNo; Rec.ClientNo)
                {
                    Editable = true;
                }
                field(Gender; Rec.Gender)
                {
                    Editable = true;
                }
                field(Birthdate; Rec.Birthdate)
                {
                    Editable = true;
                }
                field(PostCode; Rec.PostCode)
                {
                    Editable = true;
                }
                field("Place of residence"; Rec."Place of residence")
                {
                    Editable = true;
                }
                field(Street; Rec.Street)
                {
                    Editable = true;
                }
                field(HouseNumber; Rec.HouseNumber)
                {
                    Editable = true;
                }
                field(Letter; Rec.Letter)
                {
                    Editable = true;
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                    Editable = true;
                }
                field(ProductCode; Rec.ProductCode)
                {
                    Editable = true;
                }
                field(EndDate; Rec.EndDate)
                {
                    Editable = true;
                }
                field(ReasonEnd; Rec.ReasonEnd)
                {
                    Editable = true;
                }
                field(Insured; Rec.Insured)
                {
                    Editable = true;
                }
                field(LogField; Rec.LogField)
                {
                    Editable = true;
                }
                field(ProcessStatus; Rec.ProcessStatus)
                {
                    Editable = true;
                }
                field(StartDate; Rec.StartDate)
                {
                    Editable = true;
                }
                field(SSN; Rec.SSN)
                {
                    Editable = true;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = true;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Editable = true;
                }
                field(Surname; Rec.Surname)
                {
                    Editable = true;
                }
                field(Initials; Rec.Initials)
                {
                    Editable = true;
                }
                field(ProductDesc; Rec.ProductDesc)
                {
                    Editable = true;
                }
                field(DeceasedDate; Rec.DeceasedDate)
                {
                    Editable = true;
                }
                field(ImportDate; Rec.ImportDate)
                {
                    Editable = true;
                }
                field(HealthcareproviderNo; Rec.HealthcareproviderNo)
                {
                    Editable = true;
                }
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {
                    Editable = true;
                }
            }
        }
    }
}