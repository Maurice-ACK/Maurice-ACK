/// <summary>
/// Page ACKStudentTransportRoute
/// </summary>
page 50038 ACKStudentTransportRoute
{
    ApplicationArea = All;
    Caption = 'Routes', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportRoute;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CheckInTime; Rec.CheckInTime)
                {
                }
                field(CheckOutTime; Rec.CheckOutTime)
                {
                }
                field(DayOfWeek; Rec.DayOfWeek)
                {
                }
                field(Deleted; Rec.Deleted)
                {
                }
                field(DeletedBy; Rec.DeletedBy)
                {
                }
                field(EndDate; Rec.EndDate)
                {
                }
                field(ExceptionDate; Rec.ExceptionDate)
                {
                }
                field(RouteId; Rec.RouteId)
                {
                }
                field(ScheduleId; Rec.scheduleId)
                {
                }
                field(SortId; Rec.SortId)
                {
                }
                field(StartDate; Rec.StartDate)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
                field(WeekId; Rec.WeekId)
                {
                }
                field(RouteTypeId; Rec.routeType)
                {
                }
            }
        }
    }
}
