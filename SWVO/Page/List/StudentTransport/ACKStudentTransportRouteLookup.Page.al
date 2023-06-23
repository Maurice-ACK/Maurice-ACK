/// <summary>
/// Page ACKStudentTransportRouteLookup (ID 50083).
/// </summary>
page 50083 ACKStudentTransportRouteLookup
{
    ApplicationArea = All;
    Caption = 'Leerlingenvervoer route', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportrouteLookup;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CheckInName; Rec.CheckInName)
                { }

                field(CheckOutName; Rec.CheckOutName)
                { }

                field(ScheduleId; Rec.ScheduleId)
                {
                    Visible = false;

                }
                field(id; rec.id)
                {
                    Visible = false;
                }
                field(customerId; rec.customerId)
                {
                    Visible = false;
                }
                field(year; rec.year)
                {
                    Visible = false;
                }
                field(routelListId; rec.routelListId)
                {
                    Visible = false;
                }

                field(Municipality; rec.Municipality)
                {

                }
            }
        }
    }

    trigger OnOpenPage()
    var
        schedule: Record ACKStudentTransportSchedule;
        route: Record ACKStudentTransportRoute;
        node: record ACKStudentTransportNode;
        id: Integer;
        formatter: Codeunit ACKStudentApiFormatter;

    begin
        if not (routelListIdFilter = '') then
            schedule.SetFilter(routelist, '=%1', routelListIdFilter);

        if schedule.FindSet() then
            repeat






                route.SetRange(scheduleId, schedule.routelist);
                if (route.FindSet()) then
                    repeat
                        node.SetRange(nodeId, route.checkInNode);
                        //node.SetFilter(nodeType, '=%1', '33');
                        if node.FindFirst() then
                            rec.CheckInName := node.name;

                        node.SetRange(nodeId, route.checkOutNode);

                        //must be change is temp fix. filtering on school node: nodeid=33
                        //node.SetFilter(nodeType, '=%1', '33');
                        if node.FindFirst() then begin
                            rec.CheckOutName := node.name;
                            rec.Municipality := node.municipality;
                        end;


                        rec.id := id;
                        id += 1;
                        rec.year := formatter.yearToText(schedule.startDate, schedule.endDate);
                        rec.routelListId := schedule.routelist;

                        rec.Insert()





                    until route.Next() = 0;



            until schedule.Next() = 0;




    end;

    procedure setfilter(routeidFilter: code[10])
    begin
        routelListIdFilter := routeidFilter;
    end;

    var
        routelListIdFilter: code[10];




}
