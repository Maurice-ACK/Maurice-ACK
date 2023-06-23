page 50080 ACKStudentTransportSchoolQ
{
    ApplicationArea = All;
    Caption = 'School', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportSchoolQ;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ClientNo; Rec.ClientNo)
                { }
                field(routeId; Rec.routeId)
                { }
                field(id; Rec.id)
                { }
                field(name; Rec.name)
                { }
                field(nodeType; Rec.nodeType)
                { }

            }
        }
    }



    trigger OnOpenPage()
    var
        schoolQ: Query ACKSTTFilterSchool;
    begin


        schoolQ.Open();


        while schoolQ.Read() do begin
            rec.Init();
            rec.name := schoolQ.schoolName;


            if (not Rec.Find()) then begin
                rec.ClientNo := schoolQ.ClientNo;
                rec.name := schoolQ.schoolName;
                rec.nodeType := schoolQ.nodeTypeId;
                rec.routeId := schoolQ.routeId;
                rec.Insert()

            end;


        end


    end;

}
