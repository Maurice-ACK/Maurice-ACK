/// <summary>
/// Page ACKStudentTransportUserLookup (ID 50091).
/// </summary>
page 50091 ACKStudentTransportUserLookup
{
    ApplicationArea = All;
    Caption = 'Leerlingenvervoer gebruikers lookup', Locked = true;
    PageType = List;
    SourceTable = ACKStudenTransportUserLookup;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(username; Rec.Name)
                {
                }
                field(userGuid; Rec.userGuid)
                {
                    Visible = true;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        userQ: Query ACKStudentTransportUser;

    begin
        userQ.open();

        while userQ.Read() do begin

            rec.Name := userQ.UserName;
            rec.userGuid := userQ.UserSecurityID;
            if not rec.Find() then
                Rec.Insert(true);

        end;
    end;
}
