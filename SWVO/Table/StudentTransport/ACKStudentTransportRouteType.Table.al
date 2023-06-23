/// <summary>
/// Table ACKStudentTransportRouteType (ID 50019).
/// </summary>
table 50019 ACKStudentTransportRouteType
{
    Caption = 'Route type', Locked = true;
    DataClassification = SystemMetadata;
    LookupPageId = ACKStudentTransportRouteLookup;
    DrillDownPageId = ACKStudentTransportRouteLookup;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; routeTypeId; Code[20])
        {
            Caption = 'Route type ID', Locked = true;
        }
        field(30; name; Text[20])
        {
            Caption = 'Naam', Locked = true;
        }
        field(40; isPublic; Boolean)
        {
            Caption = 'Publiek', Locked = true;
        }
        field(50; id; Integer)
        {
            Caption = 'ID', Locked = true;
        }
    }

    keys
    {
        key(PK; custRecordId, id)
        {
            Clustered = true;
        }
    }
}
