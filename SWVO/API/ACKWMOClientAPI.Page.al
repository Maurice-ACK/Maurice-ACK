/// <summary>
/// Page ACKWMOClientAPI
/// </summary>
page 50113 ACKWMOClientAPI
{
    PageType = API;

    APIPublisher = 'swvo';
    APIGroup = 'sharepoint';
    APIVersion = 'v1.0';
    EntityName = 'client';
    EntitySetName = 'clients';
    DelayedInsert = true;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = ACKClient;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ssn; Rec.SSN) { }
                field(clientNo; Rec.ClientNo) { }
                field(firstName; Rec."First Name") { }
                field(initials; Rec.Initials) { }
                field(surname; Rec.Surname) { }
                field(birthdate; Rec.Birthdate) { }

                part(ACKWMOClientAddressAPI; ACKWMOClientAddressAPI)
                {
                    Multiplicity = ZeroOrOne;
                    SubPageLink = ClientNo = field(ClientNo);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.GetFilter(SSN) = '' then
            Error('Filter on %1 must be specified.', Rec.FieldCaption(SSN));
    end;
}