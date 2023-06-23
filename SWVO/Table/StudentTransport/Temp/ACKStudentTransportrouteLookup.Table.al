/// <summary>
/// Table ACKStudentTransportrouteLookup (ID 50049).
/// </summary>
table 50049 ACKStudentTransportrouteLookup
{
    Caption = 'Leerlingenvervoer route', Locked = true;
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(10; "ScheduleId"; code[20])
        {
            Caption = 'Rooster', Locked = true;
        }

        field(20; CheckInName; text[60])
        {
            Caption = 'Check in naam', Locked = true;
        }
        field(30; CheckIntype; text[60])
        {
            Caption = 'Check in type', Locked = true;
        }
        field(40; CheckOutName; text[60])
        {
            Caption = 'Check out', Locked = true;
        }
        field(50; CheckOuttype; text[60])
        {
            Caption = 'Check out type', Locked = true;
        }
        field(60; id; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
        field(70; customerId; Code[10])
        {
            Caption = 'Leerling ID', Locked = true;
        }
        field(80; year; text[20])
        {
            Caption = 'Jaren', Locked = true;
        }
        field(90; routelListId; Code[10])
        {
            Caption = 'Routes', Locked = true;
        }
        field(100; Municipality; text[30])
        {
            Caption = 'Gemeente', Locked = true;
        }
    }
    keys
    {
        key(PK; "id")
        {
            Clustered = true;
        }
    }
}
