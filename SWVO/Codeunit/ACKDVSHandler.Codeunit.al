/// <summary>
/// Codeunit ACKDVSValidator
/// </summary>
codeunit 50040 ACKDVSValidator
{
    TableNo = ACKWMOHeader;

    var
        WMOHeader: Record ACKWMOHeader;
        SWVOAPIHttpClient: Codeunit ACKSWVOAPHttpClient;
        Base64Convert: Codeunit "Base64 Convert";
        ACKJsonExport: Codeunit ACKJsonExport;
        ACKJSONTools: Codeunit ACKJsonTools;
        ACKHelper: Codeunit ACKHelper;

    trigger OnRun()
    begin
        ValidateHeader(Rec);
    end;

    /// <summary>
    /// ValidateStUF.
    /// </summary>
    /// <param name="StUF">VAR Record ACKStUF.</param>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure ValidateStUF(var StUF: Record ACKStUF) IsValid: Boolean
    var
        Base64XML: Text;
    begin
        if StUF.IsEmpty() then
            exit;

        Base64XML := Base64Convert.ToBase64(StUF.GetXML(), TextEncoding::UTF8);

        IsValid := ValidateBase64Xml(Base64XML);

        if IsValid = false then begin
            StUF.Status := ACKJobStatus::Error;
            StUF.Modify(true);
        end;
    end;

    /// <summary>
    /// ValidateHeader.
    /// </summary>
    /// <param name="_WMOHeader">VAR Record ACKWMOHeader.</param>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure ValidateHeader(var _WMOHeader: Record ACKWMOHeader) IsValid: Boolean
    var
        JsonText, XmlText : Text;
        Base64XML: Text;
        StUF: Record ACKStUF;
    begin
        if WMOHeader.IsEmpty() then
            exit(false);

        WMOHeader := _WMOHeader;

        StUF.SetRange(Referentienummer, WMOHeader.Referentienummer);
        if StUF.FindFirst() then
            XmlText := StUF.GetXML()
        else begin
            ACKJsonExport.Export(WMOHeader).WriteTo(JsonText);
            XmlText := SWVOAPIHttpClient.GetXMLFromJson(Base64Convert.ToBase64(JsonText, TextEncoding::UTF8));
        end;

        //Message(XmlText);
        Base64XML := Base64Convert.ToBase64(XmlText, TextEncoding::UTF8);

        exit(ValidateBase64Xml(Base64XML));
    end;

    local procedure ValidateBase64Xml(Base64Xml: Text) IsValid: Boolean;
    var
        DVSResponse: Text;
    begin
        DVSResponse := SWVOAPIHttpClient.ValidateDVS(Base64Xml);
        IsValid := HandleDVSResponse(DVSResponse);
    end;

    local procedure HandleDVSResponse(DVSResponse: Text) IsValid: Boolean
    var
        JsonObjectResponse, JsonObjectStatusCode, JsonObjectRapport, JsonObjectHeader, JsonObjectFouten, JsonObjectFout : JsonObject;
        JsonArrayFout, JsonArrayLocatie : JsonArray;
        JsonTokenFout, JsonTokenLocatie : JsonToken;
        StatusCode, FoutCode : Code[5];
        Reason, Details, Location : Text;
        StatusCodeReasonLbl: Label '%1: %2', Comment = '%1 = Status code; %2 = Reason', Locked = true;
        ErrorMsg: Label '%1: %2. %3', Comment = '%1 =Code; %2 = Location, %3 = Details', Locked = true;
    begin
        IsValid := true;

        if DVSResponse = '' then
            exit(false);

        if not JsonObjectResponse.ReadFrom(DVSResponse) then
            exit(false);

        JsonObjectStatusCode := ACKJsonTools.SelectJsonObject(JsonObjectResponse, 'statusCode');
        StatusCode := CopyStr(ACKJsonTools.SelectJsonToken(JsonObjectStatusCode, 'code').AsValue().AsText(), 1, 4);

        if StatusCode = '406' then
            exit(false);

        if StatusCode <> '200' then begin
            Reason := ACKJsonTools.SelectJsonToken(JsonObjectStatusCode, 'reason').AsValue().AsText();
            ACKHelper.AddWmoEventLog(WMOHeader, Severity::Critical, StrSubstNo(StatusCodeReasonLbl, StatusCode, Reason));
            exit(false);
        end;

        JsonObjectRapport := ACKJsonTools.SelectJsonObject(JsonObjectResponse, 'rapport');
        JsonObjectHeader := ACKJsonTools.SelectJsonObject(JsonObjectRapport, 'header');
        JsonObjectFouten := ACKJsonTools.SelectJsonObject(JsonObjectRapport, 'fouten');
        JsonArrayFout := ACKJsonTools.SelectJsonArray(JsonObjectFouten, 'fout');

        foreach JsonTokenFout in JsonArrayFout do
            if JsonTokenFout.IsObject() then begin
                JsonObjectFout := JsonTokenFout.AsObject();

                IsValid := false;

                //Foutcode en details
                FoutCode := CopyStr(ACKJsonTools.SelectJsonToken(JsonObjectFout, 'code').AsValue().AsText(), 1, 5);

                JsonArrayLocatie := ACKJsonTools.SelectJsonArray(JsonObjectFout, 'locatie');

                foreach JsonTokenLocatie in JsonArrayLocatie do
                    Location += JsonTokenLocatie.AsValue().AsText();

                Details := ACKJsonTools.SelectJsonToken(JsonObjectFout, 'details').AsValue().AsText();

                ACKHelper.AddWmoEventLog(WMOHeader, Severity::Error, StrSubstNo(ErrorMsg, FoutCode, Location, Details));
            end;
    end;
}
