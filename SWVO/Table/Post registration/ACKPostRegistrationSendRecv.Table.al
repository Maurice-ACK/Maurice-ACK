table 50055 ACKPostRegistrationSendRecv
{
    DataClassification = CustomerContent;

    fields
    {
        field(10; id; Integer)
        {
            AutoIncrement = true;
        }
        field(20; Name; Text[100])
        {
            Caption = 'Name sender/receive/department';
        }
        field(30; SenderReceiverId; Text[50])
        {
            Caption = 'Sender/receive/department';
        }
        field(40; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50; Type; Enum ACKPostregistrationSenRecvType)
        {
            Caption = 'Type';
        }
    }

    keys
    {
        key(Rec_id; id)
        {
            Clustered = true;
        }
    }
}