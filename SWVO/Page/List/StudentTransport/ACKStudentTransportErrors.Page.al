/// <summary>
/// Page ACKStudentTransportErrors
/// </summary>
page 50088 ACKStudentTransportErrors
{
    ApplicationArea = All;
    Caption = 'Leerlingenvervoer fouten', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportInsertError;
    UsageCategory = none;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(custId; Rec.custId)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(test)
            {
                action("Download Json")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = "Category7";
                    PromotedOnly = true;
                    Image = Document;

                    trigger OnAction()
                    var
                        iStream: InStream;
                        outStr: OutStream;
                        output: text;
                        fileoutput: File;
                        tmpblob: Codeunit "Temp Blob";
                        filename: text;
                    begin
                        rec.Json.CreateInStream(iStream);
                        iStream.read(output, 100);

                        filename := 'Json' + format(rec.SystemCreatedAt) + '.txt';

                        DownloadFromStream(iStream, 'Export', '', 'All Files (*.*)|*.*', filename);



                    end;

                }
            }
        }

    }
}
