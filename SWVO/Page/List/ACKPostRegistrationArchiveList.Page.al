page 50087 ACKPostRegistrationArchiveList
{
    ApplicationArea = All;
    Caption = 'Post Archive';
    PageType = List;
    SourceTable = ACKPostRegistrationArchive;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.id)
                {
                    Visible = false;
                }
                field(Name; Rec.Name)
                {
                }
                field(Active; Rec.Active)
                {
                }
            }
        }
    }
}
