/// <summary>
/// Table ACKStudentTransportCard (ID 50020).
/// </summary>
table 50020 ACKStudentTransportCard
{
    Caption = 'Kaart', Locked = true;
    DataClassification = SystemMetadata;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; cardId; Enum ACKStudentTransportCardType)
        {
            Caption = 'Kaart ID', Locked = true;
        }
        field(30; cardTypeId; Enum ACKStudentTransportCardType)
        {
            Caption = 'Type', Locked = true;
        }
        field(40; cardStatusId; Enum ACKStudentTransportCardStatus)
        {
            Caption = 'Status', Locked = true;
        }
        field(50; contractId; Code[20])
        {
            Caption = 'Contract', Locked = true;
        }
        field(60; cardNumber; Code[20])
        {
            Caption = 'Pasnummer', Locked = true;
        }
        field(70; replacedCard; Code[20])
        {
            Caption = 'Vervangend pasnummer', Locked = true;
        }
        field(80; mutationDate; Date)
        {
            Caption = 'Mutatiedatum', Locked = true;
        }
        field(90; approveDate; Date)
        {
            Caption = 'Goedkeuringsdatum', Locked = true;
        }
        field(100; serviceId; Code[20])
        {
            Caption = 'Service', Locked = true;
        }
        field(110; locationId; Code[20])
        {
            Caption = 'Locatie', Locked = true;
        }
        field(120; category; Text[20])
        {
            Caption = 'Categorie', Locked = true;
        }
        field(130; customerId; code[20])
        {
            Caption = 'Leerling ID', Locked = true;
            TableRelation = ACKStudentTransportCustomer.CustomerId;
        }
    }
    keys
    {
        key(CardID_PK; CardNumber)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        dataCheckCustomer: Record ACKStudentTransportCustomer;
    begin
        dataCheckCustomer.CustomerId := Rec.CustomerId;
        TestField(Rec.CustomerId);

        if not dataCheckCustomer.Find('=') then
            Error('Error on insert CustmerId not found in the Customer table');

    end;
}
