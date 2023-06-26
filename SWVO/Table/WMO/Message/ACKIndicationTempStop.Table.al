/// <summary>
/// Table ACKIndicationTempStop
/// </summary>
table 50052 ACKIndicationTempStop
{
    Caption = 'Indication temporary stop';
    DataClassification = SystemMetadata;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
        field(20; IndicationSystemID; Guid)
        {
            Caption = 'Indication system ID', locked = true;
            TableRelation = ACKWMOIndication.SystemId;
        }
        field(30; StartDate; Date)
        {
            Caption = 'Start date';
        }
        field(40; EndDate; Date)
        {
            Caption = 'End date';
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(StartDate; StartDate)
        {
            Unique = false;
        }
    }
}
