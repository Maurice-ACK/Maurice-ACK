/// <summary>
/// Table ACKStudentTransportIndiQ (ID 50043).
/// </summary>
table 50043 ACKStudentTransportIndiQ
{
    Caption = 'StudentTransportIndiQ', Locked = true;
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; ClientNo; code[20])
        {
            Caption = 'Cliënt Nr.', Locked = true;
        }
        field(20; CustomerId; Code[20])
        {
            Caption = 'Leerling ID', Locked = true;
        }
        field(30; MutationDate; Date)
        {
            Caption = 'Mutatiedatum', Locked = true;
        }
        field(40; Indication; Code[20])
        {
            Caption = 'Indicatie', Locked = true;
        }
        field(50; AdditionalValue; Text[20])
        {
            Caption = 'Aanvullende waarde', Locked = true;
        }
        field(60; User; Text[40])
        {
            Caption = 'Gebruiker', Locked = true;
        }
        field(70; Caterogy; text[20])
        {
            Caption = 'Categorie', Locked = true;
        }
        field(80; Description; Text[20])
        {
            Caption = 'Beschrijving', Locked = true;
        }
        field(90; CardId; Enum ACKStudentTransportCardType)
        {
            Caption = 'Kaart type', Locked = true;
        }
        field(100; CardStatusId; Enum ACKStudentTransportCardStatus)
        {
            Caption = 'Kaart status', Locked = true;
        }
        field(110; CardNumber; Code[20])
        {
            Caption = 'Kaartnummer', Locked = true;
        }
        field(120; scheduleCount; Integer)
        {
            Caption = 'Rooster Nr.', Locked = true;
        }
        field(130; status; text[20])
        {
            Caption = 'Status', Locked = true;
        }
        field(140; creationDate; Date)
        {
            Caption = 'Aanmaakdatum', Locked = true;
        }
        field(150; indicationId; Code[20])
        {
            Caption = 'Indicatie', Locked = true;
        }
        field(160; descriptionInd; Text[20])
        {
            Caption = 'Beschrijving', Locked = true;
        }
        field(170; mutationDateIndication; date)
        {
            Caption = 'Mutatiedatum';
        }
        field(180; serviceId; code[10])
        {
            Caption = 'Service', Locked = true;
        }
        field(190; locationId; code[10])
        {
            Caption = 'Locatie', Locked = true;
        }
        field(200; contractId; code[10])
        {
            Caption = 'Contract', Locked = true;
        }
    }
    keys
    {
        key(PK; "ClientNo")
        {
            Clustered = true;
        }
    }
}
