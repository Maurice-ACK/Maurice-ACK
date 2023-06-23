/// <summary>
/// Codeunit DocumentAttachment (ID 50006).
/// </summary>
codeunit 50007 DocumentAttachment
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        ACKClient: Record ACKClient;
        ACKPostRegistration: Record "ACKPostRegistration";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"ACKClient":
                begin
                    RecRef.Open(DATABASE::"ACKClient");
                    if ACKClient.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ACKClient);
                end;
            DATABASE::"ACKPostRegistration":
                begin
                    RecRef.Open(DATABASE::"ACKPostRegistration");
                    if ACKPostRegistration.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(ACKPostRegistration);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        ACKPostRegistration: Record "ACKPostRegistration";
        ACKClient: Record ACKClient;
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"ACKClient":
                begin
                    FieldRef := RecRef.Field(ACKClient.FieldNo(ClientNo));
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"ACKPostRegistration":
                begin
                    FieldRef := RecRef.Field(ACKPostRegistration.FieldNo(MailRegistration));
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::ACKClient:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"ACKPostRegistration":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
}