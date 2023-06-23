page 50104 ACKOtherDocuments
{
    PageType = API;
    APIGroup = 'sharepoint';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    Caption = 'Overige documenten API', Locked = true;
    EntityName = 'otherdocuments';
    EntitySetName = 'otherdocuments';
    SourceTable = ACKOtherDocuments;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(healthcareproviderNo; rec.healthcareproviderNo)
                {
                }
                field(url; rec.url)
                {
                }
                field(importDate; Rec.importDate)
                {
                }
                field(title; Rec.title)
                {
                }
                field(description; Rec.Description)
                {
                }
            }
        }
    }
}