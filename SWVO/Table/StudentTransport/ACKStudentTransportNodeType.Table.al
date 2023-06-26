/// <summary>
/// Table ACKStudentTransportNodeType
/// </summary>
table 50016 ACKStudentTransportNodeType
{
    Caption = 'Node type', Locked = true;
    DataClassification = SystemMetadata;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; nodeTypeId; Code[20])
        {
            TableRelation = ACKStudentTransportSchoolNode.nodeTypeId;
            ValidateTableRelation = false;
            Caption = 'Node type', Locked = true;
        }
        field(30; name; Text[40])
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
        key(PK; nodeTypeId, custRecordId, id)
        {
            Clustered = true;
        }
    }
}
