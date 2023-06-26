/// <summary>
/// Table ACKStudenTransportUserLookup
/// </summary>
table 50047 ACKStudenTransportUserLookup
{
    Caption = 'Leerlingenvervoer gebruikers lookup', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; userGuid; Guid)
        {
            Caption = 'Gebruikers GUID', Locked = true;
        }
        field(20; Name; text[50])
        {
            Caption = 'Naam', Locked = true;
        }
    }
    keys
    {
        key(PK; userGuid, Name)
        {
            Clustered = true;
        }
    }
}
