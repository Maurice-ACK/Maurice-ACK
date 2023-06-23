/// <summary>
/// Page ACKHomelessCard (ID 50006).
/// </summary>
page 50006 ACKHomelessCard
{
    ApplicationArea = All;
    Caption = 'ACKHomelessCard';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Navigate';
    RefreshOnActivate = true;
    SourceTable = ACKHomeless;
    UsageCategory = None;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    Editable = false;

    layout
    {
        area(content)
        {
            group(Persoonsgegevens)
            {
                field(ClientNo; Rec.ClientNo)
                {

                }
                field(SSN_Available; Rec.SSN_Available)
                {

                }
                field("First Name"; Rec."First Name")
                {

                }
                field("Middle Name"; Rec."Middle Name")
                {

                }
                field(surname; Rec.Surname)
                {

                }
                field(Initials; Rec.Initials)
                {

                }
                field(Gender; Rec.Gender)
                {

                }
                field(Birthyear; Rec.Birthyear)
                {

                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {

                }
            }
            group(Dakloosheidsgegevens)
            {
                field(Appropiate; Rec.Appropiate)
                {

                }
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {

                }
                field(ImportDate; Rec.ImportDate)
                {

                }
                field(IndividualStartDate; Rec.IndividualStartDate)
                {

                }
                field(IndividualEndDate; Rec.IndividualEndDate)
                {

                }
                field(LongCareStartDate; Rec.LongCareStartDate)
                {

                }
                field(LongCareEndDate; Rec.LongCareEndDate)
                {

                }
                field(NextPlace; Rec.NextPlace)
                {

                }
                field(PersonalCharacter; Rec.PersonalCharacter)
                {

                }
                field(ProcessStatus; Rec.ProcessStatus)
                {

                }
                field(ReasonEnd; Rec.ReasonEnd)
                {

                }
                field(Relapse; Rec.Relapse)
                {

                }
                field(Source; Rec.Source)
                {

                }
                field(CauseIn; Rec.CauseIn)
                {

                }
                field(MunicipalityNoEntry; Rec.MunicipalityNoEntry)
                {

                }
                field(DateEntry; Rec.DateEntry)
                {

                }
                field(Daycaredeployed; Rec.Daycaredeployed)
                {

                }
                field(DirectCareStartDate; Rec.DirectCareStartDate)
                {

                }
                field(DirectCareEndDate; Rec.DirectCareEndDate)
                {

                }
            }
        }
    }
}
