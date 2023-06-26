/// <summary>
/// Page ACKHomelessAPI
/// </summary>
page 50070 ACKHomelessAPI
{
    APIGroup = 'sharepoint';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Homeless API', Locked = true;
    DelayedInsert = true;
    EntityName = 'homeless';
    EntitySetName = 'homeless';
    PageType = API;
    SourceTable = ACKHomeless;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(importDate; Rec.ImportDate)
                {
                }
                field(appropiate; Rec.Appropiate)
                {
                }
                field(birthdate; Rec.Birthyear)
                {
                }
                field(ssn; Rec.SSN_Available)
                {
                }
                field(causeIn; Rec.CauseIn)
                {
                }
                field(municipalityNo; Rec.MunicipalityNo)
                {
                }
                field(municipalityNoEntry; Rec.MunicipalityNoEntry)
                {
                }
                field(clientNo; Rec.ClientNo)
                {
                }
                field(dateEntry; Rec.DateEntry)
                {
                }
                field(daycaredeployed; Rec.Daycaredeployed)
                {
                }
                field(directCareEndDate; Rec.DirectCareEndDate)
                {
                }
                field(directCareStartDate; Rec.DirectCareStartDate)
                {
                }
                field(gender; Rec.Gender)
                {
                }
                field(healthcareproviderNo; Rec.HealthcareproviderNo)
                {
                }
                field(individualEndDate; Rec.IndividualEndDate)
                {
                }
                field(individualStartDate; Rec.IndividualStartDate)
                {
                }
                field(longCareEndDate; Rec.LongCareEndDate)
                {
                }
                field(longCareStartDate; Rec.LongCareStartDate)
                {
                }
                field(nextPlace; Rec.NextPlace)
                {
                }
                field(personalCharacter; Rec.PersonalCharacter)
                {
                }
                field(reasonEnd; Rec.ReasonEnd)
                {
                }
                field(relapse; Rec.Relapse)
                {
                }
                field(source; Rec.Source)
                {
                }
            }
        }
    }
}
