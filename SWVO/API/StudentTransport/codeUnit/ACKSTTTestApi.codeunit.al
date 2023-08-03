codeunit 50100 ACKSTTTestApi
{
    procedure Ping(): Text
    begin
        exit('Pong');
    end;

    var
        Base64Convert: codeunit "Base64 Convert";
        Filters: Dictionary of [Text, Text];
        Base64StringJson: Text;



    procedure client(Base64StringJson: text; typeRequest: Integer): Text
    var
        Cust: Record Customer;
        Message: text;
        Base64Convert: codeunit "Base64 Convert";
        MessageJsonObject: JsonObject;
        RequestType: Enum ACKAPIRequestType;
        JSONExport: Codeunit ACKJsonExport;

        I: Integer;



    begin



        if (ACKAPIRequestType.FromInteger(typeRequest) = ACKAPIRequestType::POST) then begin
            Message := Base64Convert.FromBase64(Base64StringJson, TextEncoding::UTF8);
            MessageJsonObject.ReadFrom(Message);

            //Cust.FindFirst();
            MessageJsonObject.WriteTo(Message);
            exit(Message);
        end
        else
            if (ACKAPIRequestType.FromInteger(typeRequest) = ACKAPIRequestType::GET) then begin
                exit(getRequest(Base64StringJson))



            end;
    end;





    local procedure getRequest(Base64StringJson: text): Text
    var
        JSONExport: Codeunit ACKJsonExport;
        JsonToken: JsonToken;
        Header: JsonObject;
        Versie, Subversie : Integer;
        MessageJsonObject: JsonObject;
        Model: Text;
        Message: text;
    begin
        if Text.StrLen(Base64StringJson) <= 0 then
            error('berichtJson cannot be empty');

        Message := Base64Convert.FromBase64(Base64StringJson, TextEncoding::UTF8);

        if not MessageJsonObject.ReadFrom(Message) then
            Error('Cannot parse JSON %1 to JSON object.', Message);

        MessageJsonObject.get('header', JsonToken);
        Header := JsonToken.AsObject();

        Header.SelectToken('berichtVersie', JsonToken);
        Versie := JsonToken.AsValue().AsInteger();

        Header.SelectToken('berichtSubversie', JsonToken);
        Subversie := JsonToken.AsValue().AsInteger();

        Header.SelectToken('model', JsonToken);
        Model := JsonToken.AsValue().AsText();

        if (Header.Contains('filters')) then begin
            Header.SelectToken('filters', JsonToken);
            formatFilters(JsonToken.AsObject());
        end;

        MessageJsonObject := JSONExport.Export(Model, ACKVektisCode::StudentTransport, Versie, Subversie, Filters);

        MessageJsonObject.WriteTo(Message);
        exit(Message);
    end;

    local procedure FormatFilters(JsonObjectFilters: JsonObject)
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonKey: text;
        help: text;
        I: Integer;
    begin
        foreach JsonKey in JsonObjectFilters.Keys do begin
            JsonObjectFilters.Get(JsonKey, JsonToken);
            Filters.add(JsonKey, JsonToken.AsValue().AsText());
            help := JsonObjectFilters.Path();
        end;



    end;



}