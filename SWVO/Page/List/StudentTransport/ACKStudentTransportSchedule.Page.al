/// <summary>
/// Page ACKStudentTransportSchedule
/// </summary>
page 50053 ACKStudentTransportSchedule
{
    ApplicationArea = All;
    Caption = 'Rooster', Locked = true;
    PageType = Worksheet;
    SourceTable = ACKStudentTransportSchedule;
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(content)
        {
            group(header)
            {
                field(SchoolYear; tex1)
                {
                    Editable = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        pageSchedule: Page ACKStudentTransportYearSubpage;

                    begin
                        Clear(pageSchedule);
                        pageSchedule.LookupMode := true;
                        pageSchedule.Editable := true;
                        pageSchedule.SetTableView(Year);
                        pageSchedule.SetRecord(Year);

                        if pageSchedule.RunModal() = Action::LookupOK then
                            pageSchedule.GetRecord(Year);


                        updatePage(Year."startDate", Year."endDate");
                        tex1 := format(Year."startDate") + ' - ' + format(Year."endDate");
                        if Year."startDate" = 0 then
                            tex1 := 'All'
                        else
                            tex1 := format(Year."startDate") + ' - ' + format(Year."endDate");
                    end;
                }
            }
            repeater(General)
            {
                field(scheduleId; Rec.routelist)
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    Editable = false;
                }
                field(StartDate; Rec.StartDate)
                {
                    Editable = false;
                }
                field(EndDate; Rec.EndDate)
                {
                    Editable = false;
                }
                field(StartDateTransport; Rec.StartDateTransport)
                {
                    Editable = false;
                }
                field(Deleted; Rec.Deleted)
                {
                    Editable = false;
                }
                field(DeletedBy; Rec.DeletedBy)
                {
                    Editable = false;
                }
            }
        }
    }

    /// <summary>
    /// updatePage.
    /// </summary>
    /// <param name="startY">Integer.</param>
    /// <param name="endY">Integer.</param>
    procedure updatePage(startY: Integer; endY: Integer)
    var
        yearDateS: date;
        yearDateE: date;
    begin
        if not (startY = 0) then begin
            yearDateS := DMY2DATE(1, 1, startY);
            yearDateE := DMY2DATE(31, 12, endY);
            Rec.SetFilter(startDate, '>=%1', yearDateS);
            Rec.SetFilter(endDate, '<=%1', yearDateE);
        end
        else
            Rec.Reset();

        CurrPage.Update(false);
    end;

    var
        yearIndex: Record ACKStudentTransportYearsLookup;
        Year: Record ACKStudentTransportYearsLookup;
        tex: text[20];
        tex1: text[20];
}
