/// <summary>
/// Codeunit ACKReadBase64ToJson (ID 50025).
/// </summary>
codeunit 50026 ACKReadBase64ToJson
{
    TableNo = ACKStUF;

    // trigger OnRun()
    // var
    //     Base64Convert: codeunit "Base64 Convert";
    //     Base64String: Text;
    //     InStream: InStream;

    //     HttpClient: HttpClient;
    //     HttpContent: HttpContent;
    //     HttpHeaders: HttpHeaders;
    //     HttpRequestMessage: HttpRequestMessage;
    //     HttpResponseMessage: HttpResponseMessage;
    //     JsonObject: JsonObject;
    //     JsonText: Text;
    //     ResponseText: Text;
    // begin
    //     if Rec.Bericht.HasValue() then begin
    //         Rec.CalcFields(Bericht);
    //         Rec.Bericht.CreateInStream(InStream, TextEncoding::UTF8);
    //         Base64String := Base64Convert.ToBase64(InStream);

    //         // if not HttpClient.Get('https://172.16.28.130:5001/Wmo/Ping', HttpResponseMessage) then
    //         //     Error('ping failed');

    //         JsonObject.Add('validate', false);
    //         JsonObject.Add('base64String', Base64String);
    //         JsonObject.WriteTo(JsonText);

    //         // Add the payload to the content
    //         HttpContent.WriteFrom(JsonText);

    //         HttpContent.GetHeaders(HttpHeaders);
    //         HttpHeaders.Clear();
    //         HttpHeaders.Add('Content-Type', 'application/JSON');

    //         HttpRequestMessage.Content := HttpContent;

    //         HttpRequestMessage.SetRequestUri('https://172.16.28.130:5001/Wmo/Base64Convert');
    //         HttpRequestMessage.Method := 'POST';

    //         HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

    //         if not HttpResponseMessage.IsSuccessStatusCode() then
    //             Error('not success');

    //         // Read the response content as JSON.
    //         HttpResponseMessage.Content().ReadAs(ResponseText);

    //         JsonObject.ReadFrom(ResponseText);





    //     end;
    // end;

}
