/// <summary>
/// Codeunit ACKJsonExport
/// </summary>
codeunit 50021 ACKJsonExport
{
    var
        JSONMessage: Record ACKJSONMessage;
        WMOHeader: Record ACKWMOHeader;
        ACKJsonTools: codeunit ACKJsonTools;
        JsonTokenRoot: JsonToken;

    /// <summary>
    /// Export.
    /// </summary>
    /// <param name="_WMOHeader">Record ACKWMOHeader.</param>
    /// <returns>Return variable JsonObject of type JsonObject.</returns>
    procedure Export(_WMOHeader: Record ACKWMOHeader) JsonObject: JsonObject
    var
        JSONMapStart: Record ACKJSONMap;
        RecordRef: RecordRef;
        Versie, SubVersie : Integer;
    begin
        WMOHeader := _WMOHeader;

        Evaluate(Versie, WMOHeader.BerichtVersie);
        Evaluate(SubVersie, WMOHeader.BerichtSubversie);

        JSONMessage.SetRange(VektisCode, WMOHeader.BerichtCode);
        JSONMessage.SetRange(Versie, Versie);
        JSONMessage.SetRange(SubVersie, SubVersie);
        JSONMessage.SetRange(Active, true);

        JSONMessage.FindFirst();

        RecordRef.GetTable(WMOHeader);

        JSONMapStart.SetRange(MessageCode, JSONMessage.MessageCode);
        JSONMapStart.SetRange(ParentNo, '');

        JsonTokenRoot := JsonObject.AsToken();

        NextMap(JSONMapStart, JsonTokenRoot, RecordRef);
    end;

    local procedure NextMap(JSONMapParent: Record ACKJSONMap; var JsonTokenParent: JsonToken; RecordRefParent: RecordRef)
    var
        JSONMapChild: Record ACKJSONMap;
    begin
        JSONMapChild.SetCurrentKey(SortOrder);
        JSONMapChild.SetRange(MessageCode, JSONMessage.MessageCode);
        JSONMapChild.SetRange(ParentNo, JSONMapParent.No);
        JSONMapChild.SetAscending(SortOrder, true);

        if JSONMapChild.FindSet(true) then
            repeat
                ProcessMap(JSONMapChild, JsonTokenParent, RecordRefParent);
            until JSONMapChild.Next() = 0;
    end;

    local procedure ProcessMap(JSONMap: Record ACKJSONMap; JsonTokenParent: JsonToken; RecordRefParent: RecordRef)
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        JsonObjectNew: JsonObject;
        JsonArrayNew: JsonArray;
        JsonToken: JsonToken;
    begin
        if RecordRefParent.Number() = JSONMap.TableNo then
            RecordRef := RecordRefParent;

        if RecordRef.Number() = 0 then
            RecordRef.Open(JSONMap.TableNo);

        if RecordRefParent.Number() <> RecordRef.Number() then begin
            GetChild(RecordRefParent, RecordRef, JSONMap.Path);

            if not RecordRef.FindSet(false) then
                exit;
        end;

        case JSONMap.JSONType of
            ACKJSONType::"Array":
                begin
                    JsonToken := JsonArrayNew.AsToken();
                    repeat
                        NextMap(JSONMap, JsonToken, RecordRef);
                    until RecordRef.Next() = 0;
                end;
            ACKJSONType::"Object":
                begin
                    JsonToken := JsonObjectNew.AsToken();
                    NextMap(JSONMap, JsonToken, RecordRef);
                end;
            ACKJSONType::"Value":
                begin
                    FieldRef := RecordRef.Field(JSONMap.FieldNo);
                    FieldRef2JsonToken(FieldRef, JsonToken);
                end;
        end;

        //JSONMap.Required check ommitted on purpose, let dvs validation handle it.
        if not IsJsonTokenEmpty(JsonToken) then
            AddToParent(JsonTokenParent, JsonToken, JSONMap.Path)
        else
            if not JSONMap.SkipEmptyOrDefault then
                AddToParent(JsonTokenParent, JsonToken, JSONMap.Path)
    end;

    local procedure IsJsonTokenEmpty(JsonToken: JsonToken): Boolean
    var
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonValue: JsonValue;
        ValueAsText: Text;
        ParsedInteger: Integer;
    begin
        if JsonToken.IsObject() then begin
            JsonObject := JsonToken.AsObject();
            exit(JsonObject.Keys().Count() = 0);
        end;

        if JsonToken.IsArray() then begin
            JsonArray := JsonToken.AsArray();
            exit(JsonArray.Count() = 0);
        end;

        if JsonToken.IsValue() then begin
            JsonValue := JsonToken.AsValue();
            if JsonValue.IsNull() or JsonValue.IsUndefined() then
                exit(true);

            ValueAsText := JsonValue.AsText();
            if ValueAsText = '' then
                exit(true);

            if Evaluate(ParsedInteger, ValueAsText) and (ParsedInteger = 0) then
                exit(true);

            exit(false);
        end;
    end;

    local procedure AddToParent(var JsonTokenParent: JsonToken; JsonTokenChild: JsonToken; Path: Text)
    var
        JsonArray: JsonArray;
        JsonObject: JsonObject;
    begin
        if JsonTokenParent.IsArray() then begin
            JsonArray := JsonTokenParent.AsArray();
            JsonArray.Add(JsonTokenChild);
        end;
        if JsonTokenParent.IsObject() then begin
            JsonObject := JsonTokenParent.AsObject();
            JsonObject.Add(Path, JsonTokenChild);
        end;
    end;

    local procedure FieldRef2JsonToken(FRef: FieldRef; var JsonToken: JsonToken)
    var
        V: JsonValue;
        D: Date;
        DT: DateTime;
        T: Time;
        B: Boolean;
        I: Integer;
        BI: BigInteger;
        Txt: Text;
    begin
        case FRef.Type() of
            FieldType::Integer:
                begin
                    I := FRef.Value();
                    V.SetValue(I);
                end;
            FieldType::BigInteger:
                begin
                    BI := FRef.Value();
                    V.SetValue(BI);
                end;
            FieldType::Date:
                begin
                    D := FRef.Value();
                    if (D = 0D) then
                        v.SetValueToUndefined()
                    else
                        V.SetValue(D);
                end;
            FieldType::Time:
                begin
                    T := FRef.Value();
                    if (T = 0T) then
                        v.SetValueToUndefined()
                    else
                        V.SetValue(T);
                end;
            FieldType::DateTime:
                begin
                    DT := FRef.Value();
                    if (DT = 0DT) then
                        v.SetValueToUndefined()
                    else
                        V.SetValue(DT);
                end;
            fieldType::Boolean:
                begin
                    B := FRef.Value();
                    V.SetValue(B);
                end;
            fieldType::Blob:
                V.SetValue(ACKJsonTools.GetBase64String(FRef));
            FieldType::Option:
                begin
                    Txt := Format(FRef.Value(), 0, 9);
                    if Evaluate(I, Txt) then
                        V.SetValue(Txt);
                end;
            else
                V.SetValue(Format(FRef.Value, 0, 9));
        end;
        JsonToken := V.AsToken();
    end;

    local procedure GetChild(ParentRecordRef: RecordRef; var ChildRecordRef: RecordRef; Path: Text)
    var
        WMOClient: Record ACKWMOClient;
        WMORelatie: Record ACKWMORelatie;
        WMOContact: Record ACKWMOContact;
        WMOToegewezenProduct: Record ACKWMOToegewezenProduct;
        NewChangedUnchangedProduct: Record ACKNewChangedUnchangedProduct;
        WMOStartStopProduct: Record ACKWMOStartStopProduct;
        WMODeclaratie: Record ACKWMODeclaratie;
        WMODeclaratieAntwoord: Record ACKWMODeclaratieAntwoord;
        WMOPrestatie: Record ACKWMOPrestatie;
        WMOMessageRetourCode: Record ACKWMOMessageRetourCode;
        ParentSystemId: Guid;
    begin
        if (ChildRecordRef.Number() = Database::ACKWMOClient) or
            (ChildRecordRef.Number() = Database::ACKWMODeclaratie) or
            (ChildRecordRef.Number() = Database::ACKWMODeclaratieAntwoord) or
            (ChildRecordRef.Number() = Database::ACKWMOAntwoord) then
            ParentRecordRef.GetTable(WMOHeader);

        ParentSystemId := ParentRecordRef.Field(ParentRecordRef.SystemIdNo()).Value();

        case ChildRecordRef.Number() of
            Database::ACKWMOClient:
                begin
                    ChildRecordRef.SetTable(WMOClient);
                    WMOClient.SetRange(HeaderId, ParentSystemId);
                    ChildRecordRef.GetTable(WMOClient);
                end;
            Database::ACKWMORelatie:
                begin
                    ChildRecordRef.SetTable(WMORelatie);
                    WMORelatie.SetRange(ClientID, ParentSystemId);
                    ChildRecordRef.GetTable(WMORelatie);
                end;
            Database::ACKWMOContact:
                begin
                    ChildRecordRef.SetTable(WMOContact);
                    WMOContact.SetRange(RelationTableNo, ParentRecordRef.Number());
                    WMOContact.SetRange(RefID, ParentSystemId);
                    ChildRecordRef.GetTable(WMOContact);
                end;
            Database::ACKWMOToegewezenProduct:
                begin
                    ChildRecordRef.SetTable(WMOToegewezenProduct);
                    WMOToegewezenProduct.SetRange(ClientID, ParentSystemId);
                    ChildRecordRef.GetTable(WMOToegewezenProduct);
                end;
            Database::ACKNewChangedUnchangedProduct:
                begin
                    ChildRecordRef.SetTable(NewChangedUnchangedProduct);
                    NewChangedUnchangedProduct.SetRange(ClientID, ParentSystemId);

                    case Path of
                        'ongewijzigdeProducten':
                            NewChangedUnchangedProduct.SetRange(NewChangedUnchangedProductType, ACKNewChangedUnchangedProductType::Unchanged);
                        'teWijzigenProducten':
                            NewChangedUnchangedProduct.SetRange(NewChangedUnchangedProductType, ACKNewChangedUnchangedProductType::Changed);
                        'nieuweProducten':
                            NewChangedUnchangedProduct.SetRange(NewChangedUnchangedProductType, ACKNewChangedUnchangedProductType::New);
                    end;

                    ChildRecordRef.GetTable(NewChangedUnchangedProduct);
                end;
            Database::ACKWMOStartStopProduct:
                begin
                    ChildRecordRef.SetTable(WMOStartStopProduct);
                    WMOStartStopProduct.SetRange(ClientId, ParentSystemId);
                    ChildRecordRef.GetTable(WMOStartStopProduct);
                end;
            Database::ACKWMODeclaratie:
                begin
                    ChildRecordRef.SetTable(WMODeclaratie);
                    WMODeclaratie.SetRange(HeaderId, ParentSystemId);
                    ChildRecordRef.GetTable(WMODeclaratie);
                end;
            Database::ACKWMODeclaratieAntwoord:
                begin
                    ChildRecordRef.SetTable(WMODeclaratieAntwoord);
                    WMODeclaratieAntwoord.SetRange(HeaderId, ParentSystemId);
                    ChildRecordRef.GetTable(WMODeclaratieAntwoord);
                end;
            Database::ACKWMOPrestatie:
                begin
                    ChildRecordRef.SetTable(WMOPrestatie);
                    WMOPrestatie.SetRange(ClientID, ParentSystemId);
                    ChildRecordRef.GetTable(WMOPrestatie);
                end;
            Database::ACKWMOMessageRetourCode:
                begin
                    WMOMessageRetourCode.SetCurrentKey(RelationTableNo, HeaderId, RefID);
                    ChildRecordRef.SetTable(WMOMessageRetourCode);
                    WMOMessageRetourCode.SetRange(RelationTableNo, ParentRecordRef.Number());
                    WMOMessageRetourCode.SetRange(HeaderId, WMOHeader.SystemId);
                    WMOMessageRetourCode.SetRange(RefID, ParentSystemId);
                    ChildRecordRef.GetTable(WMOMessageRetourCode);
                end;
        end;
    end;

    /// <summary>
    /// GetJSONMessage.
    /// </summary>
    /// <returns>Return value of type Record ACKJSONMessage.</returns>
    procedure GetJSONMessage(): Record ACKJSONMessage
    begin
        exit(JSONMessage);
    end;

}