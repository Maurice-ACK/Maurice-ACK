table 50044 ACKStudentTransportClientTemp
{
    Caption = 'Leerling', Locked = true;
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; "ClientNo"; Code[20])
        {
            Editable = false;
            Caption = 'Leerling Nr.', Locked = true;
        }
        field(20; CustomerID; Code[20])
        {
            Editable = false;
            Caption = 'Leerling ID', Locked = true;
        }
        field(30; "First Name"; Text[30])
        {
            Editable = false;
            Caption = 'Voornaam', Locked = true;
        }
        field(40; "Middle Name"; Text[30])
        {
            Editable = false;
            Caption = 'Tussenvoegsel', Locked = true;
        }
        field(50; Surname; Text[30])
        {
            Editable = false;
            Caption = 'Achternaam', Locked = true;
        }
        field(100; Initials; Text[30])
        {
            Caption = 'Initialen', Locked = true;
        }
        field(60; User_Name; Text[50])
        {
            Caption = 'Gebruikersnaam', Locked = true;
            TableRelation = user."User Name";
        }
        field(70; User_Security_ID; Guid)
        {
            Caption = 'Gebruikers ID', Locked = true;
            TableRelation = user."User Security ID";
        }
        field(80; EmailAddress; Text[80])
        {
            Caption = 'E-mailadres', Locked = true;
        }
        field(90; CustRec; GUID)
        {
            Caption = 'Leerling GUID', Locked = true;
        }
        field(110; emailLayout; text[50])
        {
            Caption = 'E-mail layout', Locked = true;
        }
        field(120; emailCode; code[20])
        {
            Caption = 'E-mail code', Locked = true;
        }
        field(130; compensation; Boolean)
        {
            Caption = 'Compensatie', Locked = true;
        }
        field(140; contribution; Boolean)
        {
            Caption = 'Contributie', Locked = true;
        }
        field(150; phone; Text[20])
        {
            Caption = 'Telefoon', Locked = true;
        }
        field(160; "mobile phone"; Text[20])
        {
            Caption = 'Mobiel', Locked = true;
        }
        field(170; Birthdate; Date)
        {
            Caption = 'Geboortedatum', Locked = true;
        }
        field(180; Gender; Enum ACKWMOGeslacht)
        {
            Caption = 'Geslacht', Locked = true;
        }
        field(190; scheduleId; code[10])
        {
            Caption = 'Rooster', Locked = true;
            TableRelation = user."User Security ID";
        }
        field(200; schoolName; Text[50])
        {
            Caption = 'School', Locked = true;
        }
        field(210; routelistId; code[10])
        {
            Caption = 'Route', Locked = true;
        }
    }
    keys
    {
        key(PK; "ClientNo", scheduleId)
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    var
        clientData: Record ACKSTTClientData;

    begin
        clientData.SetFilter(ClientNo, '=%1', Rec.ClientNo);

        if clientData.FindFirst() then begin
            clientData.Attendant := Rec.User_Security_ID;
            clientData.Modify();
        end;
    end;
}
