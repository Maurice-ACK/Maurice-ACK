page 50068 ACKStudentTransportInfoPage
{
    ApplicationArea = All;
    Caption = 'Roosters', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportSchedule;
    UsageCategory = None;
    QueryCategory = 'StudentTransport Query';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CustomerId; Rec.CustomerId)
                { }
                field(Deleted; Rec.Deleted)
                { }
                field(DeletedBy; Rec.DeletedBy)
                { }
                field(EndDate; Rec.EndDate)
                { }
                field(IsEditable; Rec.IsEditable)
                { }
                field(Modified; Rec.Modified)
                { }
                field(ModifiedBy; Rec.ModifiedBy)
                { }
                field(Name; Rec.Name)
                { }
                field(Remarks; Rec.Remarks)
                { }
                field(ScheduleId; Rec.routelist)
                { }
                field(StartDate; Rec.StartDate)
                { }
                field(StartDateTransport; Rec.StartDateTransport)
                { }
            }
        }
    }
}
