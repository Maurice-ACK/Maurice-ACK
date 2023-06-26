/// <summary>
/// Codeunit ACKDVSImport
/// </summary>
codeunit 50004 ACKDVSImport
{
    var
        WMOHeader: Record ACKWMOHeader;
        JSONMessage: Record ACKJSONMessage;
        ACKJsonTools: codeunit ACKJsonTools;
        DVSJsonObjectRoot: JsonObject;

    /// <summary>
    /// Process.
    /// </summary>
    /// <param name="_WMOHeader">Record ACKWMOHeader.</param>
    /// <param name="_DVSJsonObject">JsonObject.</param>
    procedure Process(_WMOHeader: Record ACKWMOHeader; _DVSJsonObject: JsonObject)
    var
        EmptyRecordErr: Label 'Empty record', Locked = true;
        JSONMapStart: Record ACKJSONMap;
    begin
        WMOHeader := _WMOHeader;
        DVSJsonObjectRoot := _DVSJsonObject;

        if WMOHeader.IsEmpty() then
            Error(EmptyRecordErr);

        JSONMessage.SetRange(MessageCode, 'DVS'); //Todo parameter
        JSONMessage.FindFirst();

        /*
            1. Status codes: 200, 400, etc
            

        */



        NextMap(JSONMapStart, DVSJsonObjectRoot.AsToken());
    end;


    local procedure ProcessMap(JSONMapParent: Record ACKJSONMap; JSONMapCurrent: Record ACKJSONMap; JsonTokenParent: JsonToken)
    var
        JsonTokenCurrent: JsonToken;
        PathNotFoundErr: Label 'Could not find required path %1', Comment = '%1 = Path', Locked = true;
    begin
        if not JsonTokenParent.SelectToken(JSONMapCurrent.Path, JsonTokenCurrent) then
            if JSONMapCurrent.Required = true then
                Error(PathNotFoundErr, JSONMapCurrent.Path)
            else
                exit;

        ValidateExpectedType(JSONMapCurrent.JSONType, JsonTokenCurrent);

        case JSONMapCurrent.JSONType of
            ACKJSONType::"Array":
                begin
                    ProcessArray(JSONMapCurrent, JsonTokenCurrent.AsArray());
                    exit;
                end;
            ACKJSONType::"Value":
                Message('');
        end;

        NextMap(JSONMapCurrent, JsonTokenCurrent);
    end;

    local procedure NextMap(JSONMapParent: Record ACKJSONMap; JsonTokenParent: JsonToken)
    var
        JSONMapChild: Record ACKJSONMap;
    begin
        JSONMapChild.SetCurrentKey(SortOrder);
        JSONMapChild.SetRange(MessageCode, JSONMessage.MessageCode);
        JSONMapChild.SetRange(ParentNo, JSONMapParent.No);
        JSONMapChild.SetAscending(SortOrder, true);

        if JSONMapChild.FindSet(true) then
            repeat
                ProcessMap(JSONMapParent, JSONMapChild, JsonTokenParent);
            until JSONMapChild.Next() = 0;
    end;

    local procedure ProcessArray(JSONMapCurrent: Record ACKJSONMap; JsonArray: JsonArray)
    var
        JSONMapFirstChild: Record ACKJSONMap;
        RecordRefCopy: RecordRef;
        JsonToken: JsonToken;
        EmptyRequiredArrayErr: Label 'Array %1 is empty but child is required.', Comment = '%1 = Path', Locked = true;
        ArrayWithoutChildErr: Label 'Array %1 defined without child mappings.', Comment = '%1 = Path', Locked = true;
    begin
        if not JSONMapCurrent.GetFirstChild(JSONMapFirstChild) then
            Error(ArrayWithoutChildErr, JSONMapCurrent.GetFullPath());

        if not JsonArray.Get(0, JsonToken) then
            if JSONMapFirstChild.Required then
                Error(EmptyRequiredArrayErr, JSONMapFirstChild.GetFullPath())
            else
                exit;

        foreach JsonToken in JsonArray do begin
            if JsonToken.IsObject() then
                NextMap(JSONMapCurrent, JsonToken);

            if JsonToken.IsValue() then begin
                //value
            end;
        end;
    end;

    local procedure GetJSONTypeFromJSONToken(JsonToken: JsonToken): Enum ACKJSONType
    begin
        if JsonToken.IsArray() then
            exit(ACKJSONType::"Array");
        if JsonToken.IsObject() then
            exit(ACKJSONType::"Object");
        if JsonToken.IsValue() then
            exit(ACKJSONType::"Value");
    end;

    local procedure ValidateExpectedType(ExpectedJSONType: Enum ACKJSONType; JsonToken: JsonToken)
    var
        TokenJSONType: Enum ACKJSONType;
        ExpectedTypeErr: Label 'Expected %1 but found %2.', Comment = '%1 = JSON Type expected, %2 JSON Type found', Locked = true;
    begin
        TokenJSONType := GetJSONTypeFromJSONToken(JsonToken);

        if ExpectedJSONType <> TokenJSONType then
            Error(ExpectedTypeErr, Format(ExpectedJSONType), Format(TokenJSONType));
    end;
}