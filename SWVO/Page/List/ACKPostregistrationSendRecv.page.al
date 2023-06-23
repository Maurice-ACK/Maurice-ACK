page 50076 ACKPostregistrationSendRecv
{
    Caption = 'Sender/Receiver';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ACKPostRegistrationSendRecv;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(name; Rec.Name)
                {
                }
                field(SenderReceiverId; Rec.SenderReceiverId)
                {
                }
                field(Active; Rec.Active)
                {
                }
                field(Type; Rec.Type)
                {
                }
            }
        }

    }

}