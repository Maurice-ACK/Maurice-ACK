/// <summary>
/// Table ACKStudentTransportCustomer
/// </summary>
table 50030 ACKStudentTransportCustomer
{
    Caption = 'Leerling', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; customerId; Code[10])
        {
            Caption = 'Leerling ID', Locked = true;
        }
        field(30; customerStatus; Text[20])
        {
            Caption = 'Status', Locked = true;
        }
        field(40; initials; Text[30])
        {
            Caption = 'Initialen', Locked = true;
        }
        field(50; infix; Text[20])
        {
            Caption = 'Tussenvoegsel', Locked = true;
        }
        field(60; lastName; Text[50])
        {
            Caption = 'Achternaam', Locked = true;
        }
        field(70; firstName; Text[20])
        {
            Caption = 'Voornaam', Locked = true;
        }
        field(80; gender; Text[10])
        {
            Caption = 'Geslacht', Locked = true;
        }
        field(90; dateOfBirth; Date)
        {
            Caption = 'Geboortedatum', Locked = true;
        }
        field(100; SSN; Code[15])
        {
            Caption = 'BSN', Locked = true;
        }
        field(110; streetName; Text[24])
        {
            Caption = 'Straatnaam', Locked = true;
        }
        field(120; streetNr; Text[20])
        {
            Caption = 'Huisnummer', Locked = true;
        }
        field(130; streetNrAddition; Text[4])
        {
            Caption = 'Huisnummer toevoeging', Locked = true;
        }
        field(140; zipCode; Text[10])
        {
            Caption = 'Postcode', Locked = true;
        }
        field(150; municipalityNo; Text[20])
        {
            Caption = 'Gemeente Nr.', Locked = true;
        }
        field(160; state; Text[20])
        {
            Caption = 'Staat', Locked = true;
        }
        field(170; countryId; Code[20])
        {
            Caption = 'Landnummer', Locked = true;
        }
        field(180; telephoneNumber; Text[15])
        {
            ExtendedDatatype = PhoneNo;
            Caption = 'Telefoonnummer', Locked = true;
        }
        field(190; mobileNumber; Text[15])
        {
            ExtendedDatatype = PhoneNo;
            Caption = 'Mobiel', Locked = true;
        }
        field(200; emailAddress; Text[50])
        {
            ExtendedDatatype = EMail;
            Caption = 'E-mailadres', Locked = true;
        }
        field(210; iban; Text[30])
        {
            Caption = 'IBAN', Locked = true;
        }
        field(220; "processed"; Boolean)
        {
            Caption = 'Verwerkt', Locked = true;
            InitValue = false;
        }
    }
    keys
    {
        key(CustomerId_PK; CustomerId, custRecordId)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        schedule: Record ACKStudentTransportSchedule;
        custIndication: record ACKStudentTransportCustIndicat;
        card: Record ACKStudentTransportCard;
        client: Record ACKStudentTransportClientData;
    begin
        //remove schedule from customer
        schedule.SetCurrentKey(CustomerId);
        schedule.SetRange(CustomerId, Rec.CustomerId);
        schedule.DeleteAll(true);

        custIndication.SetCurrentKey(CustomerId);
        custIndication.SetRange(CustomerId, rec.CustomerId);
        custIndication.DeleteAll(true);

        card.SetCurrentKey(CustomerId);
        card.SetRange(CustomerId, Rec.CustomerId);
        card.DeleteAll(true);

        client.SetRange(CustomerID, rec.CustomerId);
        if client.FindFirst() then
            onRecordRemove(client.ClientNo);
    end;

    procedure onRecordRemove(clientN: Code[20])
    var
        address: record ACKClientAddress;

    begin
        address.SetFilter(ClientNo, '=%1', clientN);
        address.SetFilter(Purpose, '=%1', ACKWMOAdresSoort::Mybility);
        address.setfilter(ValidTo, '<=%1', 0D);


        if address.FindSet() then
            repeat
                address.ValidTo := Today;
                address.Modify();

            until address.Next() = 0




    end;
}
