/// <summary>
/// Table ACKStudentTransportSchoolNode (ID 50048).
/// </summary>
table 50048 ACKStudentTransportSchoolNode
{
    Caption = 'School', Locked = true;
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(10; nodeTypeId; Code[10])
        {
            Caption = 'ID', Locked = true;
        }
        field(20; Name; Text[30])
        {
            Caption = 'Naam', Locked = true;
        }
        field(30; School; Boolean)
        {
            Caption = 'School', Locked = true;
        }
    }
    keys
    {
        key(PK; nodeTypeId)
        {
            Clustered = true;
        }
    }
}
