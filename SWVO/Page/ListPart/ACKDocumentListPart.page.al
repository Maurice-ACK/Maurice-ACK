page 50098 ACKDocumentListPart
{
    PageType = listpart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Document Attachment";
    Caption = 'Documents';

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("No."; Rec."No.")
                {
                    Visible = false;
                }
                field("File Name"; Rec."File Name")
                {
                    Caption = 'File Name';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        openDocAttachment();
                    end;
                }
                field("Attached Date"; Rec."Attached Date") { }
                field("File Type"; Rec."File Type") { }
            }
        }
    }

    procedure openDocAttachment()
    var
        DocumentAttachmentDetails: Page "Document Attachment Details";
        RecRef: RecordRef;
        ACKClient: Record ACKClient;

    begin
        RecRef.Open(DATABASE::"ACKClient");
        if ACKClient.Get(rec."No.") then
            RecRef.GetTable(ACKClient);

        DocumentAttachmentDetails.OpenForRecRef(RecRef);
        DocumentAttachmentDetails.RunModal();

    end;

}









