/// <summary>
/// Table ACKStudentTransportTempClient
/// </summary>
table 50000 ACKStudentTransportTempClient
{
    Caption = 'Leerling', Locked = true;
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; ClientNo; Code[20])
        {
            Caption = 'Leerling Nr.', Locked = true;
        }
        field(20; "First Name"; Text[30])
        {
            Caption = 'Voornaam', Locked = true;
        }
        field(30; Surname; Text[30])
        {
            Caption = 'Achternaam', Locked = true;
        }
        field(40; CustomerID; Code[20])
        {
        }
    }

    keys
    {
        key(PK; ClientNo)
        {
            Clustered = true;
        }
    }
}
