/// <summary>
/// Table ACKStudentTransportRoute (ID 50014).
/// </summary>
table 50014 ACKStudentTransportRoute
{
    Caption = 'Route', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; scheduleId; Code[20])
        {
            Caption = 'Rooster ID', Locked = true;

            TableRelation = ACKStudentTransportSchedule.routelist;
            ValidateTableRelation = false;
        }
        field(30; routeId; Code[20])
        {
            Caption = 'Route ID', Locked = true;
        }
        field(40; sortId; Code[20])
        {
            Caption = 'Volgorde', Locked = true;
        }
        field(50; weekId; Code[20])
        {
            Caption = 'Weeknummer', Locked = true;
        }
        field(60; dayOfWeek; Enum ACKDayOfWeek)
        {
            Caption = 'Weekdag', Locked = true;
        }
        field(70; checkInTime; Time)
        {
            Caption = 'Check in tijd', Locked = true;
        }
        field(80; checkOutTime; Time)
        {
            Caption = 'Check uit tijd', Locked = true;
        }
        field(90; startDate; Date)
        {
            Caption = 'Startdatum', Locked = true;
        }
        field(100; endDate; Date)
        {
            Caption = 'Einddatum', Locked = true;
        }
        field(110; exceptionDate; Date)
        {
            Caption = 'Uitzonderingsdatum', Locked = true;
        }
        field(120; deleted; Date)
        {
            Caption = 'Verwijderingsdatum', Locked = true;
        }
        field(130; deletedBy; Text[20])
        {
            Caption = 'Verwijderd door', Locked = true;
        }
        field(140; checkInNode; code[10])
        {
            Caption = 'Check in node', Locked = true;
        }
        field(150; checkOutNode; code[10])
        {
            Caption = 'Check uit node', Locked = true;
        }
        field(160; routeType; code[10])
        {
            TableRelation = ACKStudentTransportRouteType.RouteTypeId;
            ValidateTableRelation = false;
        }
    }
    keys
    {
        key(RouteId_PK; RouteId)
        {
            Clustered = true;
        }
        key(Sch_key; scheduleId)
        {
        }
    }

    trigger OnInsert()
    var
        dataCheckSchedule: Record ACKStudentTransportSchedule;
        dataCheckRouteType: Record ACKStudentTransportRouteType;
    begin
        /*
        dataCheckSchedule.scheduleId := Rec.ScheduleId;
        dataCheckRouteType.RouteTypeId := Rec.RouteTypeId;
        TestField(Rec.ScheduleId);

        if not dataCheckSchedule.Find('=') then
            Error('Error on insert scheduleId not found in the schedule table');


        if not dataCheckRouteType.Find('=') then
            Error('Error on insert routeTypeId not found in the routeType table');
        */
    end;





}
