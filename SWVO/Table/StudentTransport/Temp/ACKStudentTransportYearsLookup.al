/// <summary>
/// Table ACKStudentTransportYearsLookup (ID 50046).
/// </summary>
table 50046 ACKStudentTransportYearsLookup
{
    Caption = 'Leerlingenvervoer schooljaar', Locked = true;
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(10; "startDate"; Integer)
        {
            Caption = 'Startdatum', Locked = true;
        }
        field(20; "endDate"; Integer)
        {
            Caption = 'Einddatum', Locked = true;
        }
        field(30; "Years"; Text[20])
        {
            Caption = 'Jaren', Locked = true;
        }
    }
    keys
    {
        key(PK; "startDate", "endDate")
        {
            Clustered = true;
        }
    }

}
