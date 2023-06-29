/// <summary>
/// Codeunit ACKSWVOAPHttpClient
/// </summary>
codeunit 50019 ACKSWVOAPHttpClient
{
    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        URIBuilder: codeunit "Uri Builder";
        ACKJsonTools: codeunit ACKJsonTools;
        ACKHelper: codeunit ACKHelper;
        WebRequestHelper: Codeunit "Web Request Helper";
        Uri: codeunit Uri;
        RecordRef: RecordRef;
        QueryParamDict: Dictionary of [Text, Text];
        FieldMapDictionary: Dictionary of [Integer, Text];
        SendFailedErr: Label 'Failed to send request to: %1', Comment = '%1 = URL of the request', MaxLength = 100, Locked = true;


    /// <summary>
    /// TestAuthConnection.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure TestAuthConnection() Success: Boolean
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        //To test on a local docker instance use http://host.docker.internal
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('TestAuth');
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('GET');

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Accept', 'application/json; charset=utf-8');
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());

        Success := Send(HttpRequestMessage, HttpResponseMessage);
        if Success then
            Message('Connected! Response from api: %1', GetResponseMessageAsText(HttpResponseMessage))
        else
            Error('Connection failed.');
    end;

    procedure SendXMLStuf(InStream: InStream): Boolean
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        JsonContentText: Text;
        RequestHeaders, ContentHeaders : HttpHeaders;
        ACKStUF: Record ACKStUF;
        ACKJsonTools: Codeunit ACKJsonTools;
        ResponseParseErr: Label 'Address API Response, unable to parse JSON as object. %1', Comment = '%1 = Response JSON.', MaxLength = 250, Locked = true;
        RecordRef: RecordRef;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('StUF/XmlReturnJson');
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('POST');

        HttpContent.WriteFrom(InStream);

        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/xml; charset=utf-8');
        HttpRequestMessage.Content(HttpContent);

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());
        RequestHeaders.Add('Accept', 'application/json; charset=utf-8');

        exit(Send(HttpRequestMessage, HttpResponseMessage));
        // if Send(HttpRequestMessage, HttpResponseMessage) then begin
        //     // Read the response content as JSON and into an array.
        //     HttpResponseMessage.Content().ReadAs(JsonContentText);
        //     if not JsonObject.ReadFrom(JsonContentText) then Error(ResponseParseErr, JsonContentText);
        //     //Map the result address to the corresponding fields in the ACKClientAddress table.
        //     RecordRef := ACKJsonTools.Json2Rec(JsonObject, ACKStUF);
        //     RecordRef.SetTable(ACKStUF);
        //     ACKStUF.Insert();
        // end;
    end;

    /// <summary>
    /// ImportWMOXml.
    /// </summary>
    /// <param name="Base64Text">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ImportWMOXml(Base64Text: Text): Boolean
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        RequestHeaders, ContentHeaders : HttpHeaders;
        ContentText, ODataResponse : Text;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('Wmo/ImportWMOXML');
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('POST');

        JsonObject.Add('validate', true);
        JsonObject.Add('contentType', 'XML');
        JsonObject.Add('base64String', Base64Text);
        JsonObject.WriteTo(ContentText);
        Message(ContentText);
        HttpContent.WriteFrom(ContentText);

        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json; charset=utf-8');
        HttpRequestMessage.Content(HttpContent);

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());

        if not Send(HttpRequestMessage, HttpResponseMessage) then begin
            ODataResponse := GetOdataResponse(HttpResponseMessage);

            ACKHelper.AddEventLog(Database::ACKWMOHeader, Severity::Error, ODataResponse);
        end;
    end;


    /// <summary>
    /// ValidateDVS.
    /// </summary>
    /// <param name="Base64Text">Text.</param>
    /// <returns>Return variable DVSResponse of type Text.</returns>
    procedure ValidateDVS(Base64Text: Text) DVSResponse: Text
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        RequestHeaders, ContentHeaders : HttpHeaders;
        ContentText: Text;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('DVS/validate');
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('POST');

        JsonObject.Add('validate', true);
        JsonObject.Add('contentType', 'XML');
        JsonObject.Add('base64String', Base64Text);
        JsonObject.WriteTo(ContentText);
        HttpContent.WriteFrom(ContentText);

        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json; charset=utf-8');
        HttpRequestMessage.Content(HttpContent);

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());

        if Send(HttpRequestMessage, HttpResponseMessage) then
            exit(GetResponseMessageAsText(HttpResponseMessage));
    end;

    procedure Base64Convert(Base64Text: Text): Boolean
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        RequestHeaders, ContentHeaders : HttpHeaders;
        ContentText, ResponseText : Text;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('Wmo/base64Convert');
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('POST');

        JsonObject.Add('validate', true);
        JsonObject.Add('contentType', 'json');
        JsonObject.Add('base64String', Base64Text);
        JsonObject.WriteTo(ContentText);
        HttpContent.WriteFrom(ContentText);

        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json; charset=utf-8');
        HttpRequestMessage.Content(HttpContent);

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Accept', 'application/json');
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());

        exit(Send(HttpRequestMessage, HttpResponseMessage));
    end;

    /// <summary>
    /// Retour.
    /// </summary>
    /// <param name="Base64Text">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure Retour(Base64Text: Text): Boolean
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        RequestHeaders, ContentHeaders : HttpHeaders;
        ContentText: Text;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('dvs/retour');
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('POST');

        JsonObject.Add('validate', true);
        JsonObject.Add('contentType', 'json');
        JsonObject.Add('base64String', Base64Text);
        JsonObject.WriteTo(ContentText);
        HttpContent.WriteFrom(ContentText);
        Message(ContentText);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content(HttpContent);

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        // RequestHeaders.Add('Accept', 'application/json');
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());

        exit(Send(HttpRequestMessage, HttpResponseMessage));
    end;


    /// <summary>
    /// SendStUF.
    /// </summary>
    /// <param name="ACKStUF">Record ACKStUF.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SendStUF(ACKStUF: Record ACKStUF): Boolean
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        JsonContentText: Text;
        RequestHeaders, ContentHeaders : HttpHeaders;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('StUF/SendStuf');

        //Query parameters
        URIBuilder.AddQueryParameter('EndpointURL', 'https://wup.swvo:8107/iwmoserviceegem21.asmx', "Uri Query Duplicate Behaviour"::"Overwrite All Matching");
        URIBuilder.AddQueryParameter('SOAPAction', 'http://www.stufstandaarden.nl/koppelvlak/ggk0210/ggk_Di01', "Uri Query Duplicate Behaviour"::"Overwrite All Matching");

        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('POST');

        JsonObject := ACKJsonTools.Rec2Json(ACKStUF);
        JsonObject.WriteTo(JsonContentText);
        HttpContent.WriteFrom(JsonContentText);

        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json; charset=utf-8');
        HttpRequestMessage.Content(HttpContent);

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Accept', 'application/json; charset=utf-8');
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());
        // RequestHeaders.Add('X-Api-Key', ACKSWVOGeneralSetup.SWVOAPIKey());

        exit(Send(HttpRequestMessage, HttpResponseMessage));
    end;


    /// <summary>
    /// GetXMLFromJson.
    /// </summary>
    /// <param name="Base64Text">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetXMLFromJson(Base64Text: Text) XML: Text
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        JsonObject: JsonObject;
        RequestHeaders, ContentHeaders : HttpHeaders;
        ContentText: Text;
    begin
        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('wmo/xml');
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('POST');

        JsonObject.Add('validate', true);
        JsonObject.Add('contentType', 'json');
        JsonObject.Add('base64String', Base64Text);
        JsonObject.WriteTo(ContentText);
        HttpContent.WriteFrom(ContentText);
        HttpContent.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        HttpRequestMessage.Content(HttpContent);

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Clear();
        RequestHeaders.Add('Accept', 'text/xml, application/xml');
        RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());

        if Send(HttpRequestMessage, HttpResponseMessage) then
            XML := GetResponseMessageAsText(HttpResponseMessage);
    end;


    local procedure GetResponseMessageAsText(HttpResponseMessage: HttpResponseMessage) ReponseText: Text
    var
        HttpContent: HttpContent;
    begin
        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(ReponseText);
    end;


    /// <summary>
    /// GetAddress.
    /// </summary>
    /// <param name="ACKClientAddress">Record ACKClientAddress.</param>
    procedure GetAddress(var ACKClientAddress: Record ACKClientAddress)
    var
        AddressRec: Record ACKClientAddress;
        RecRef: RecordRef;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        ResponseText: Text;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        ResponseParseErr: Label 'Address API Response, unable to parse JSON as array. %1', Comment = '%1 = Response JSON.', MaxLength = 250, Locked = true;
    begin
        if ACKClientAddress.IsEmpty() then
            exit;

        if not ACKSWVOGeneralSetup.Get() then
            exit;

        RecordRef.GetTable(ACKClientAddress);
        FieldMapDictionary := ACKClientAddress.FieldMapDictionary();

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('BAG/Search');
        CreateQueryParams(ACKClientAddress.FieldMapDictionary());
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('GET');

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Accept', 'application/json');
        //RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());
        // RequestHeaders.Add('X-Api-Key', ACKSWVOGeneralSetup.SWVOAPIKey());

        Send(HttpRequestMessage, HttpResponseMessage);

        // Read the response content as JSON and into an array.
        HttpResponseMessage.Content().ReadAs(ResponseText);
        if (ResponseText = '[]') then
            exit;


        if not JsonArray.ReadFrom(ResponseText) then Error(ResponseParseErr, ResponseText);

        if JsonArray.Count() > 1 then
            // MultipleAddressError()
            exit
        else begin
            RecRef := ACKJsonTools.Json2Rec(JsonObject, AddressRec);
            RecRef.Insert();
        end;
    end;

    /// <summary>
    /// Validate Address.
    /// </summary>
    /// <param name="ACKClientAddress">Record ACKClientAddress.</param>
    /// <returns>Returns true if address exits in the BAG database</returns>
    procedure VerifyAddres(var ACKClientAddress: Record ACKClientAddress): Boolean
    var
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        ResponseText: Text;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        JsonTokenAddress: JsonToken;
    begin

        if ACKClientAddress.IsEmpty() then
            exit;

        if not ACKSWVOGeneralSetup.Get() then
            exit;

        //check if the validate with BAG API is set in setup
        if not ACKSWVOGeneralSetup.VerifyAddressBag then
            exit(false);

        RecordRef.GetTable(ACKClientAddress);
        FieldMapDictionary := ACKClientAddress.FieldMapDictionary();

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('BAG/Search');
        CreateQueryParams(ACKClientAddress.FieldMapDictionary());
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('GET');

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Accept', 'application/json');
        //RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());
        // RequestHeaders.Add('X-Api-Key', ACKSWVOGeneralSetup.SWVOAPIKey());

        if not Send(HttpRequestMessage, HttpResponseMessage) then
            exit;

        // Read the response content as JSON and into an array.
        HttpResponseMessage.Content().ReadAs(ResponseText);
        if (ResponseText = '[]') then
            exit(false);

        if not JsonArray.ReadFrom(ResponseText)
            then
            exit(false);

        if JsonArray.Count() < 1 then
            exit(false)
        else begin
            JsonArray.Get(0, JsonTokenAddress);
            JsonObject := JsonTokenAddress.AsObject();
            exit(ACKJsonTools.CompareJsonObjectToRecordRef(ACKClientAddress, JsonObject, FieldMapDictionary));
        end;

        exit(true);
    end;


    /// <summary>
    /// GetMunicipalityNo.
    /// </summary>
    /// <param name="ACKClientAddress">Record ACKClientAddress.</param>
    /// <returns>Returns municipality code from the BAG API</returns>
    procedure GetMunicipalityNo(var ACKClientAddress: Record ACKClientAddress): code[10]
    var
        MunicipalityNoRec: Record ACKMunicipality;
        RecRef: RecordRef;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestHeaders: HttpHeaders;
        ResponseText: Text;
        MunicipalityNoText: Text;
        TextVar: Text;
        IntVar: Integer;
        JsonObject: JsonObject;
        JsonToken: JsonToken;

    begin
        if ACKClientAddress.IsEmpty() then
            exit;

        if not ACKSWVOGeneralSetup.Get() then
            exit;

        if not ACKSWVOGeneralSetup.VerifyAddressBag then
            exit;

        RecordRef.GetTable(ACKClientAddress);
        FieldMapDictionary := ACKClientAddress.FieldMapDictionary();

        //Build the URI
        URIBuilder.Init(ACKSWVOGeneralSetup.SWVOAPIBaseUri);
        URIBuilder.SetPath('BAG/GetCity');
        CreateQueryParams(ACKClientAddress.FieldMapDictionary());
        URIBuilder.GetUri(Uri);

        //Build the HttpRequestMessage
        HttpRequestMessage.SetRequestUri(Uri.GetAbsoluteUri());
        HttpRequestMessage.Method('GET');
        //RequestHeaders.Add('Authorization', 'Bearer ' + AcquireAccessToken());
        //RequestHeaders.Add('X-Api-Key', ACKSWVOGeneralSetup.SWVOAPIKey());

        //Add headers
        HttpRequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Accept', 'application/json');

        Send(HttpRequestMessage, HttpResponseMessage);

        // Read the response content as JSON and into an array.
        HttpResponseMessage.Content().ReadAs(ResponseText);

        if (ResponseText = '{}') then
            exit;

        if not JsonObject.ReadFrom(ResponseText) then
            exit
        else begin
            TextVar := Text.CopyStr(ACKClientAddress.PostCode, 1, 4);
            Evaluate(IntVar, TextVar);

            JsonObject.Add('fromPostode', IntVar);
            JsonObject.Add('toPostode', IntVar);

            RecRef := ACKJsonTools.Json2Rec(JsonObject, MunicipalityNoRec);

            if not RecRef.Insert() then
                exit;

            JsonObject.Get('code', JsonToken);

            MunicipalityNoText := JsonToken.AsValue().AsText();

            if StrLen(MunicipalityNoText) <= 10 then
                exit(MunicipalityNoText);
        end;
    end;


    local procedure MultipleAddressError()
    var
        MultipleAddressFoundErr: Label 'Multiple addresses found with parameters: %1', Comment = '%1 = Query parameters;', MaxLength = 250;
        MultipleAddressSubErr: Label '%1: %2', Comment = '%1 = Caption; %2 = value;', MaxLength = 250, Locked = true;
        ErrorText, Caption, parmValue : Text;
    begin
        foreach Caption in QueryParamDict.Keys() do begin
            parmValue := QueryParamDict.Get(Caption);
            if ErrorText <> '' then
                ErrorText := ErrorText + ', ';
            ErrorText := ErrorText + StrSubstNo(MultipleAddressSubErr, Caption, parmValue);
        end;

        Error(MultipleAddressFoundErr, ErrorText);
    end;


    /// <summary>
    /// RequestTypeToName.
    /// </summary>
    /// <param name="RequestType">enum "Http Request Type".</param>
    /// <returns>Return value of type Text.</returns>
    procedure RequestTypeToName(RequestType: enum "Http Request Type"): Text
    begin
        exit(RequestType.Names().Get(RequestType.Ordinals.IndexOf(RequestType.AsInteger())));
    end;

    /// <summary>
    /// Send.
    /// </summary>
    /// <param name="HttpRequestMessage">HttpRequestMessage.</param>
    /// <param name="HttpResponseMessage">HttpResponseMessage.</param>
    /// <returns>Return value of type Boolean.</returns>
    [TryFunction]
    procedure Send(HttpRequestMessage: HttpRequestMessage; HttpResponseMessage: HttpResponseMessage)
    var
        HttpClient: HttpClient;
    begin
        if WebRequestHelper.IsValidUri(HttpRequestMessage.GetRequestUri()) then
            if not HttpClient.Send(HttpRequestMessage, HttpResponseMessage) or HttpResponseMessage.IsBlockedByEnvironment() then
                Error(SendFailedErr, HttpRequestMessage.GetRequestUri());

        exit(HttpResponseMessage.IsSuccessStatusCode());
    end;

#pragma warning disable AA0244
    local procedure CreateQueryParams(FieldMapDictionary: Dictionary of [Integer, Text])
#pragma warning restore AA0244
    var
        FieldRef: FieldRef;
        FieldNo: Integer;
        FieldPath, FieldValue : Text;
    begin
        foreach FieldNo in FieldMapDictionary.Keys() do begin
            FieldPath := FieldMapDictionary.get(FieldNo);
            if (FieldPath <> '') then begin
                FieldRef := RecordRef.Field(FieldNo);
                FieldValue := Format(FieldRef.Value());
                if FieldValue <> '' then begin
                    URIBuilder.AddQueryParameter(FieldPath, FieldValue, "Uri Query Duplicate Behaviour"::"Overwrite All Matching");
                    QueryParamDict.Add(FieldRef.Caption(), FieldValue);
                end;
            end
        end;
    end;

    local procedure GetOdataResponse(HttpResponseMessage: HttpResponseMessage) Response: Text;
    var
        JsonObjectResponse, JsonObjectResult, JsonObjectError : JsonObject;
        JsonToken: JsonToken;
        HTTPResponse, CodeText, MessageText : Text;
        ResponseFormatLbl: Label '%1: %2', Comment = '%1 = code; %2 = message', Locked = true;
    begin
        HTTPResponse := GetResponseMessageAsText(HttpResponseMessage);

        if HTTPResponse = '' then
            Error(HttpResponseMessage.ReasonPhrase());

        if not JsonObjectResponse.ReadFrom(HTTPResponse) then
            Error('Failed to parse JSON response: %1', HTTPResponse);

        if JsonObjectResponse.SelectToken('result', JsonToken) then
            if JsonToken.IsValue() then
                if JsonObjectResult.ReadFrom(JsonToken.AsValue().AsText()) then
                    if JsonObjectResult.SelectToken('error', JsonToken) then begin
                        JsonObjectError := JsonToken.AsObject();
                        if JsonObjectError.SelectToken('code', JsonToken) and JsonToken.IsValue() then
                            CodeText := JsonToken.AsValue().AsText();
                        if JsonObjectError.SelectToken('message', JsonToken) and JsonToken.IsValue() then
                            MessageText := JsonToken.AsValue().AsText();

                        Response := StrSubstNo(ResponseFormatLbl, CodeText, MessageText);
                    end;

        if Response = '' then
            Error('Failed to get response');
    end;


    [ErrorBehavior(ErrorBehavior::Collect)]
    local procedure HandleErrorResponse(HttpResponseMessage: HttpResponseMessage)
    var
        EI: ErrorInfo;
        JsonObjectResponse, JsonObjectResult : JsonObject;
        JsonTokenObject, JsonTokenArray, JsonTokenValue : JsonToken;
        ErrorKey: Text;
        FieldNo: Integer;
        JsonToken: JsonToken;
        JVal: JsonValue;
        ResponseText, CodeText, MessageText : Text;

    begin
        Clear(EI);
        EI.Collectible(true);
        EI.ErrorType(ErrorType::Client);
        EI.Verbosity(Verbosity::Warning);

        HttpResponseMessage.Content.ReadAs(ResponseText);

        if ResponseText = '' then
            Error(HttpResponseMessage.ReasonPhrase());

        if not JsonObjectResponse.ReadFrom(ResponseText) then
            Error(ResponseText);

        if JsonObjectResponse.SelectToken('result', JsonToken) then
            if JsonToken.IsValue() then begin
                JVal := JsonToken.AsValue();
                if JsonObjectResult.ReadFrom(JVal.AsText()) then
                    if JsonObjectResult.SelectToken('code', JsonToken) then
                        CodeText := JsonToken.AsValue().AsText();
                if JsonObjectResult.SelectToken('message', JsonToken) then
                    MessageText := JsonToken.AsValue().AsText();
            end;


        if JsonObjectResult.SelectToken('error', JsonToken) then begin
            JsonToken.WriteTo(ResponseText);
            Error(ResponseText);
        end;
    end;

    //         if JsonObjectResponse.SelectToken('errors', JsonTokenObject) and JsonTokenObject.IsObject() then begin
    //             JsonObject := JsonTokenObject.AsObject();

    // #pragma warning disable AA0005
    //             foreach ErrorKey in JsonObject.Keys() do begin
    //                 if JsonObject.Get(ErrorKey, JsonTokenArray) and JsonTokenArray.IsArray() then
    //                     if JsonTokenArray.AsArray().Get(0, JsonTokenValue) and JsonTokenValue.IsValue() then begin
    //                         EI.Message(JsonTokenValue.AsValue().AsText());

    //                         if not RecordRef.IsEmpty() then begin
    //                             FieldNo := ACKHelper.FindFirstKeyByValue(FieldMapDictionary, ErrorKey);
    //                             if FieldNo > 0 then begin
    //                                 EI.FieldNo(FieldNo);
    //                                 EI.ControlName(RecordRef.Field(FieldNo).Caption());
    //                             end
    //                         end;
    //                         Error(EI);
    //                     end;
    //             end;
    // #pragma warning restore AA0005
    //         end;
    //end;


    // [NonDebuggable]
    local procedure AcquireAccessToken() AccessToken: Text
    var
        OAuth2: Codeunit OAuth2;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        AuthorityLbl: Label 'https://login.microsoftonline.com/%1/oauth2/v2.0/token', Comment = '%1 = tenant id', Locked = true;
        AccessTokenErr: Label 'Failed to retrieve access token %1', Comment = '%1 = last error text', Locked = true;
        Scopes: List of [Text];
        ClientId, Secret, OAuthAuthorityUrl : Text;
    begin
        clear(OAuth2);

        ClientId := GraphMgtGeneralTools.StripBrackets(ACKSWVOGeneralSetup.BC_ClientId).ToLower();
        Secret := ACKSWVOGeneralSetup.GetClientSecret();
        OAuthAuthorityUrl := StrSubstNo(AuthorityLbl, GraphMgtGeneralTools.StripBrackets(ACKSWVOGeneralSetup.BC_TenantId).ToLower());
        Scopes.Add(ACKSWVOGeneralSetup.BC_Scope);

        OAuth2.AcquireTokenWithClientCredentials(ClientId,
                                                Secret,
                                                OAuthAuthorityUrl,
                                                '', //Redirect url, if blank uses default BC redirect url.
                                                Scopes,
                                                AccessToken);
        if AccessToken = '' then
            Error(AccessTokenErr, GetLastErrorText());
    end;
}