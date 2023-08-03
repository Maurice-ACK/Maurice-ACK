page 50120 ACKSTTScheduleList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ACKSTTTransportSchedule;
    Caption = 'Schedule';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(request; Rec.request) { }
                field(Day; Rec.Day) { }
                field(pickUpTime; Rec.pickUpTime) { }
                field(dropOffTime; Rec.dropOffTime) { }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
    }
}