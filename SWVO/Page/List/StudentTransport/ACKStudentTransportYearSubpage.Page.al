/// <summary>
/// Page ACKStudentTransportYearSubpage
/// </summary>
page 50067 ACKStudentTransportYearSubpage
{
    ApplicationArea = All;
    Caption = 'Leerlingenvervoer schooljaar', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportYearsLookup;
    SourceTableTemporary = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(prefix; rec."Years") { }
                field(start; Rec."startDate")
                {
                    Visible = true;
                }
                field(endY; Rec."endDate")
                {
                    Visible = true;
                }

            }
        }
    }
    trigger OnOpenPage()
    var
        year: Query ACKStudentTransportYears;
        startY: Integer;
        endY: Integer;
        i: Integer;
    begin

        if year.Open() then begin

            while year.Read() do begin
                startY := year.StartYear;
                endY := year.endYear;

                if year.startMonth < 8 then
                    startY -= 1;

                if year.EndMonth > 8 then
                    endY += 1;

                for i := 1 to (endY - startY) do
                    storeRec(startY, startY + 1, Format(startY) + '-' + Format(endY));


            end;

            storeRec(0, 0, 'All');

            year.Close();
        end;


    end;


    procedure storeRec(startY: Integer; endY: Integer; prefix: Text)
    var
    begin
        Rec."startDate" := startY;
        rec."endDate" := endY;
        Rec."Years" := prefix;
        if not rec.Find() then
            Rec.Insert(true);



    end;
}
