page 50058 ACKSTTCreateClient
{
    PageType = API;
    Caption = 'CreateClient';
    APIPublisher = 'swvo';
    APIGroup = 'studentTransport';
    APIVersion = 'v1.0';
    EntityName = 'createClient';
    EntitySetName = 'createClient';
    SourceTable = ACKClient;
    DelayedInsert = true;



    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID; AzureID) { }
                field(firstName; rec."First Name") { }
                field(middleName; rec."Middle Name") { }
                field(surname; rec.Surname) { }
            }
        }
    }

    trigger OnInit()
    var
        I: Integer;

    begin
        I := 0;

    end;

    trigger OnOpenPage()
    var
    begin
        if AzureID = '' then begin
            rec.SetRange(ClientNo, '');
            exit;
        end;

        // rec.SetFilter();
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        I: Integer;
        Client: Record ACKClient;
    begin



        i := 0;

    end;




    var
        AzureID: text[30];


}