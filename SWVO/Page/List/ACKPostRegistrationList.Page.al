/// <summary>
/// Page ACKPostRegistrationList
/// </summary>
page 50071 ACKPostRegistrationList
{
    Caption = 'Post registrations';
    CardPageID = ACKPostRegistrationCard;
    DataCaptionFields = MailDate;
    Editable = false;
    PageType = List;
    SourceTable = ACKPostRegistration;
    UsageCategory = Documents;
    ApplicationArea = All;
    QueryCategory = 'File import List';
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(MailRegistration; Rec.MailRegistration)
                {
                }
                field(InOut; Rec.InOut)
                {
                }
                field(MailComment; Rec.MailComment)
                {
                }
                field(MailDate; Rec.MailDate)
                {
                }
                field(MailDescription; Rec.MailDescription)
                {
                }
                field(Archive; Rec.ArchiveId)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50036),
                              "No." = FIELD(MailRegistration);
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action("Sender/Receiver")
            {
                Image = PersonInCharge;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Process";
                PromotedOnly = true;

                RunObject = Page ACKPostregistrationSendRecv;
            }
            action("ArchiveButton")
            {
                Caption = 'Archive';
                Image = Archive;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = "Process";
                PromotedOnly = true;

                RunObject = Page ACKPostRegistrationArchiveList;
            }
        }
    }

    trigger OnOpenPage()
    var
        pageFilter: Record ACKPostRegistration;
    begin
        pageFilter.SetRange(ArchiveActive, true);
        CurrPage.SetTableView(pageFilter);
        CurrPage.Update();
    end;
}