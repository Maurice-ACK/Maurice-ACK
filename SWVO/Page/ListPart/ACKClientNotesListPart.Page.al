page 50081 ACKClientNotesListPage
{
    Caption = 'Client notes';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = ACKClientNotes;
    Editable = true;
    InsertAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Note; Rec.Note)
                {
                    trigger OnDrillDown()
                    var
                        NoteFilter: record ACKClientNotes;
                        notes: Page ACKCLientNotesList;
                    begin
                        NoteFilter.SetRange(ClientNo, Rec.ClientNo);
                        notes.SetTableView(NoteFilter);
                        notes.RunModal();

                    end;
                }

            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(New)
            {
                Caption = 'New';
                RunObject = Page ACKCLientNotesList;
                RunPageLink = ClientNo = field(ClientNo);
            }
        }
    }



}