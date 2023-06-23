table 50053 ACKStudentTransportSchoolQ
{
    Caption = 'School Table';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
        }
        field(20; ClientNo; Code[10])
        {
            Caption = 'No.';
        }
        field(30; name; text[60])
        {
            Caption = 'Name';
        }
        field(40; nodeType; code[10])
        {
            Caption = 'Nodetype';
        }
        field(50; routeId; code[10])
        {
            Caption = 'Route id';
        }
    }
    keys
    {
        key(PK; "name")
        {
            Clustered = true;
        }
    }
}
