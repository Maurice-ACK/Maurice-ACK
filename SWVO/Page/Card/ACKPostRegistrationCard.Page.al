/// <summary>
/// Page ACKPostRegistrationCard
/// </summary>
page 50069 ACKPostRegistrationCard
{
    Caption = 'Post registration';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = ACKPostRegistration;
    UsageCategory = None;
    ApplicationArea = all;
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field(MailReceiverName; RecieveName)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        filterRec: Record ACKPostRegistrationSendRecv;
                    begin
                        filterRec.SetRange(Type, ACKPostregistrationSenRecvType::Receiver);
                        filterRec.SetRange(Active, true);

                        if page.RunModal(Page::ACKPostregistrationSendRecv, filterRec) = Action::LookupOk then
                            rec.MailReceiverId := filterRec.id;
                        rec.Modify();
                        CurrPage.Update();

                        RecieveName := filterRec.Name;

                    end;
                }
                field(MailSenderName; SenderName)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        filterRec: Record ACKPostRegistrationSendRecv;
                    begin
                        filterRec.SetRange(Type, ACKPostregistrationSenRecvType::Sender);
                        filterRec.SetRange(Active, true);

                        if page.RunModal(Page::ACKPostregistrationSendRecv, filterRec) = Action::LookupOk then
                            rec.MailSenderId := filterRec.id;
                        rec.Modify();

                        SenderName := filterRec.Name;

                    end;
                }
                field(Archive; Archive)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        recRef: Record ACKPostRegistrationArchive;
                    begin

                        if page.RunModal(Page::ACKPostRegistrationArchiveList, recRef) = Action::LookupOk then
                            rec.ArchiveId := recRef.id;
                        rec.Modify();

                        Archive := recRef.Name;

                    end;
                }
                field(MailConfidential; Rec.MailConfidential)
                {
                }
                field(MailDepartmentId; Rec.MailDepartmentId)
                {
                }
                field(MailCopy; Rec.MailCopy)
                {
                }

            }
        }
    }


    trigger OnOpenPage()
    var
        recRefSR: Record ACKPostRegistrationSendRecv;
        recRefA: Record ACKPostRegistrationArchive;

    begin
        recRefSR.setRange(id, rec.MailSenderId);
        if recRefSR.FindFirst() then
            SenderName := recRefSR.Name;

        recRefSR.setRange(id, rec.MailReceiverId);
        if recRefSR.FindFirst() then
            RecieveName := recRefSR.Name;

        recRefA.setRange(id, rec.ArchiveId);
        if recRefA.FindFirst() then
            Archive := recRefA.Name;
    end;


    var
        SenderName: Text;
        RecieveName: Text;
        Archive: Text;
}
