/// <summary>
/// Table ACKStudentTransportIndication (ID 50022).
/// </summary>
table 50022 ACKStudentTransportIndication
{
    Caption = 'Indicatie', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; indicationId; Code[20])
        {
            Caption = 'Indicatie ID', Locked = true;
        }
        field(30; description; Text[20])
        {
            Caption = 'Beschrijving', Locked = true;
        }
        field(40; mutationDate; Date)
        {
            Caption = 'Mutatiedatum', Locked = true;
        }
    }
    keys
    {
        key(PK; IndicationId)
        {
            Clustered = true;
        }
    }
}
