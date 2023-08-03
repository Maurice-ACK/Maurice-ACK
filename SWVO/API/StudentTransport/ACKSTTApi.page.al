page 50044 ACKSTTApi
{
    PageType = API;
    Caption = 'TestApi';
    APIPublisher = 'swvo';
    APIGroup = 'studentTransport';
    APIVersion = 'v1.0';
    EntityName = 'api';
    EntitySetName = 'api';
    SourceTable = ACKSTTApiCalls;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(berichtCode; Rec.berichtCode)
                {
                    Caption = 'fieldCaption';

                }
                field(base64StringJson; base64StringJson)
                {

                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        OutS: OutStream;
        BodyText: Text;
    begin

        BodyText := ImportBase64Messages();

        rec.Body.CreateOutStream(OutS, TextEncoding::UTF8);
        OutS.WriteText(BodyText);
    end;


    local procedure ImportBase64Messages(): Text
    var
        WMOHeader: Record ACKWMOHeader;
        ACKJsonImport: Codeunit ACKJsonImport;
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
            Error('Cannot parse JSON %1 to JSON object.', Message);

        MessageJsonObject.SelectToken('header.berichtVersie', JsonToken);
        Versie := JsonToken.AsValue().AsInteger();

        MessageJsonObject.SelectToken('header.berichtSubversie', JsonToken);
        Subversie := JsonToken.AsValue().AsInteger();

        ACKJsonImport.Init(MessageJsonObject, Rec.BerichtCode, Versie, Subversie, false);
        ACKJsonImport.Run();
        // ACKJsonImport.GetWMOHeader(Rec);
        MessageJsonObject.WriteTo(Message);
        exit(Message);
    end;


    var
        base64StringJson: text;
}