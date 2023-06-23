/// <summary>
/// Table ACKWMORule (ID 50079).
/// </summary>
table 50066 ACKWMORule
{
    Caption = 'Wmo rules';
    DataClassification = SystemMetadata;
    DrillDownPageId = ACKWMORuleList;
    LookupPageId = ACKWMORuleList;

    fields
    {
        field(10; Rule; Enum ACKWMORule)
        {
            Caption = 'Rule';
        }
        field(20; Description; Text[1024])
        {
            Caption = 'Description';
        }
        field(30; RetourCodeID; Code[4])
        {
            Caption = 'Retour code';
            TableRelation = ACKWMORetourCode.ID;
        }
        field(40; IsActive; Boolean)
        {
            Caption = 'Active';
        }
    }
    keys
    {
        key(PK; Rule)
        {
            Clustered = true;
        }
        key(Key2; RetourCodeID)
        {
        }
    }
}
