page 50080 ACKSTTApiCalls
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ACKSTTApiCalls;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID; Rec.ID) { }

                field(berichtCode; Rec.berichtCode)
                {
                    ApplicationArea = All;

                }

                field(Body; Rec.Body)
                {

                }
                field(test; bodyField)
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
            action("View message")
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    Ins: InStream;
                    ApiBody: Text;
                begin
                    rec.Body.CreateInStream(Ins);
                    Ins.ReadText(ApiBody);
                    Message(ApiBody);
                end;
            }
        }
    }
    trigger OnAfterGetRecord();
    var
        Ins: InStream;
        ApiBody: Text;
    begin
        rec.Body.CreateInStream(Ins);
        Ins.ReadText(bodyField);

    end;

    var
        bodyField: Text;


}