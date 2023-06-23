/// <summary>
/// Table ACKStudentTransportInsertError (ID 50050).
/// </summary>
table 50050 "ACKStudentTransportInsertError"
{
    Caption = 'Leerlingenvervoer fouten', Locked = true;
    DataClassification = SystemMetadata;

    fields
    {
        field(10; custId; Guid)
        {
            Caption = 'Leerling GUID', Locked = true;
        }
        field(20; customerId; Code[20])
        {
            Caption = 'Leerling ID', Locked = true;
        }
        field(30; Json; blob)
        {
            Caption = 'Json';
        }
    }
    keys
    {
        key(PK; custId)
        {
            Clustered = true;
        }
    }
}
