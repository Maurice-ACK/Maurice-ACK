page 50119 ACKCLientNotesList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ACKClientNotes;
    Caption = 'Client notes';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(ClientNo; Rec.ClientNo)
                {
                    Visible = false;
                }
                field(NoteId; Rec.NoteId)
                {
                    Visible = false;
                }
                field(Note; rec.Note)
                {
                }
            }
        }
    }



}