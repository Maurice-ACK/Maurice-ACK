table 50059 ACKClientNotes
{
    Caption = 'Client notes';
    DataClassification = CustomerContent;

    fields
    {
        field(10; ClientNo; Code[10])
        {
            TableRelation = ACKClient.ClientNo;
            Caption = 'No.';
        }
        field(20; "NoteId"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Note id';
        }
        field(30; Note; Text[200])
        {
            Caption = 'Note';
        }
    }
    keys
    {
        key(NodeId; ClientNo, "NoteId")
        {
            Clustered = true;
        }
    }
}
