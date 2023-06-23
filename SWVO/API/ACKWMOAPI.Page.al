/// <summary>
/// Page ACKWMOAPI (ID 50102).
/// </summary>
page 50101 ACKWMOAPI
{
    PageType = API;
    APIGroup = 'wmo';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    Caption = 'Wmo API', Locked = true;
    EntityCaption = 'wmo', Locked = true;
    EntitySetCaption = 'wmo', Locked = true;
    EntityName = 'wmo';
    EntitySetName = 'wmo';
    DelayedInsert = true;
    SourceTable = ACKWMOHeader;
    Permissions = tabledata ACKWMOHeader = RIMD;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(berichtCode; Rec.BerichtCode)
                {
                }
                field(base64StringJson; Base64StringJson)
                {
                }
            }
        }
    }

    var
        Base64StringJson: Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ImportBase64Messages();
        exit(false);
    end;

    trigger OnAfterGetCurrRecord()
    begin
    end;

    local procedure ImportBase64Messages()
    var
        JsonImportProcessorV2: Codeunit ACKJsonImport;
        Base64Convert: codeunit "Base64 Convert";
        MessageJsonObject: JsonObject;
        JsonToken: JsonToken;
        Versie, Subversie : Integer;
        Message: Text;
    begin
        if Text.StrLen(Base64StringJson) <= 0 then
            error('berichtJson cannot be empty');

        Message := Base64Convert.FromBase64(Base64StringJson, TextEncoding::UTF8);

        if not MessageJsonObject.ReadFrom(Message) then
            Error('Cannot parse json %1 to json object.', Message);

        MessageJsonObject.SelectToken('header.berichtVersie', JsonToken);
        Versie := JsonToken.AsValue().AsInteger();

        MessageJsonObject.SelectToken('header.berichtSubversie', JsonToken);
        Subversie := JsonToken.AsValue().AsInteger();

        JsonImportProcessorV2.Init(MessageJsonObject, Rec.BerichtCode, Versie, Subversie);
        JsonImportProcessorV2.Run();
    end;
}
