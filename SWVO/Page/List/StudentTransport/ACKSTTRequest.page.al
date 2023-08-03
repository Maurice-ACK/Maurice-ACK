page 50121 ACKSTTRequest
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ACKSTTRequest;
    Caption = 'Reqeust';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                }
                field(clientID; Rec.clientID)
                {

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}