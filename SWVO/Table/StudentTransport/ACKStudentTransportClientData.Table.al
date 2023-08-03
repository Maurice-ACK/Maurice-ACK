/// <summary>
/// Table ACKStudentTransportClientData
/// </summary>
table 50045 ACKStudentTransportClientData
{
    Caption = 'Leerling', Locked = true;

    DataClassification = CustomerContent;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling GUID', Locked = true;
        }
        field(20; CustomerID; Code[20])
        {
            Caption = 'Leerling ID', Locked = true;
        }
        field(30; ClientNo; Code[20])
        {
            Caption = 'Leerling Nr.', Locked = true;
            TableRelation = ACKClient.ClientNo;
        }
        field(40; Attendant; Guid)
        {
            Caption = 'Begeleider', Locked = true;
            TableRelation = User."User Security ID";
        }
        field(50; Caterogy; Enum ACKStudentTransportCatergory)
        {
            Caption = 'Categorie', Locked = true;
        }
        field(60; EmailLayoutCode; Code[20])
        {
            Caption = 'E-mail layout', Locked = true;
            TableRelation = "Custom Report Layout".Code;
        }
        field(70; compensation; Boolean)
        {
            Caption = 'Compensatie', Locked = true;
        }
        field(80; contribution; Boolean)
        {
            Caption = 'Contributie', Locked = true;
        }
    }
    keys
    {
        key(PK; ClientNo)
        {
            Clustered = true;
        }
        key(subKey; CustomerID)
        {
            Unique = true;
        }
    }
}
