/// <summary>
/// Page ACKHeadlinePart (ID 50061).
/// </summary>
page 50061 ACKHeadlinePart
{
    Caption = '', Locked = true;
    PageType = HeadLinePart;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(UserWelcome; StrSubstNo(UserWelcomeLbl, CurrUser."Full Name"))
            {
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrUser.Get(UserSecurityId());
    end;

    var
        CurrUser: Record User;
        UserWelcomeLbl: Label 'Welcome %1', Comment = '%1 = user full name';
}