/// <summary>
/// Codeunit ACKJsonTools
/// </summary>
codeunit 50022 ACKJsonTools
{
    /// <summary>
    /// Json2Rec.
    /// </summary>
    /// <param name="JO">JsonObject.</param>
    /// <param name="Rec">Variant.</param>
    /// <returns>Return value of type Variant.</returns>
    procedure Json2Rec(JO: JsonObject; Rec: Variant): Variant
    var
        Ref: RecordRef;
    begin
        Ref.GetTable(Rec);
        exit(Json2Rec(JO, Ref.Number()));
    end;

    /// <summary>
    /// Json2Rec.
    /// </summary>
    /// <param name="JO">JsonObject.</param>
    /// <param name="TableNo">Integer.</param>
    /// <returns>Return value of type Variant.</returns>
    procedure Json2Rec(JO: JsonObject; TableNo: Integer): Variant
    var
        Ref: RecordRef;
        FR: FieldRef;
        FieldHash: Dictionary of [Text, Integer];
        i: Integer;
        JsonKey: Text;
        T: JsonToken;
        JsonKeyValue: JsonValue;
        RecVar: Variant;
    begin
        Ref.OPEN(TableNo);
        for i := 1 to Ref.FieldCount() do begin
            FR := Ref.FieldIndex(i);
            FieldHash.Add(GetJsonFieldName(FR), FR.Number);
        end;
        Ref.Init();
#pragma warning disable AA0005
        foreach JsonKey in JO.Keys() do begin
            if JO.Get(JsonKey, T) then begin
                if T.IsValue() then begin
                    JsonKeyValue := T.AsValue();
                    if not (JsonKeyValue.AsText() = '') then begin
                        FR := Ref.Field(FieldHash.Get(JsonKey));
                        AssignValueToFieldRef(FR, JsonKeyValue);
                        Ref.Field(FieldHash.Get(JsonKey)).Validate();
                    end;

                end;
            end;
        end;
#pragma warning restore AA0005
        RecVar := Ref;
        exit(RecVar);
    end;

    /// <summary>
    /// Rec2Json.
    /// </summary>
    /// <param name="Rec">Variant.</param>
    /// <returns>Return value of type JsonObject.</returns>
    procedure Rec2Json(Rec: Variant): JsonObject
    var
        FRef: FieldRef;
        Ref: RecordRef;
        Out: JsonObject;
        i: Integer;
    begin
        if not Rec.IsRecord then
            error('Parameter Rec is not a record');
        Ref.GetTable(Rec);
        for i := 1 to Ref.FieldCount() do begin
            FRef := Ref.FieldIndex(i);

            if FRef.Class = FieldClass::FlowField then
                FRef.CalcField();

            Out.Add(GetJsonFieldName(FRef), FieldRef2JsonValue(FRef));
        end;

        exit(Out);
    end;

    /// <summary>
    /// GetBase64String.
    /// </summary>
    /// <param name="FieldRef">FieldRef.</param>
    /// <returns>Return variable Base64String of type Text.</returns>
    procedure GetBase64String(FieldRef: FieldRef) Base64String: Text
    var
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: codeunit "Base64 Convert";
        InStream: InStream;
    begin
        FieldRef.CalcField();
        TempBlob.FromFieldRef(FieldRef);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        Base64String := Base64Convert.ToBase64(InStream);
    end;

    /// <summary>
    /// FieldRef2JsonValue.
    /// </summary>
    /// <param name="FRef">FieldRef.</param>
    /// <returns>Return value of type JsonValue.</returns>
    procedure FieldRef2JsonValue(FRef: FieldRef): JsonValue
    var
        V: JsonValue;
        D: Date;
        DT: DateTime;
        T: Time;
        B: Boolean;
        I: Integer;
        Txt, EnumValueName : Text;
    begin
        case FRef.Type() of
            FieldType::Date:
                begin
                    D := FRef.Value;
                    V.SetValue(D);
                end;
            FieldType::Time:
                begin
                    T := FRef.Value;
                    V.SetValue(T);
                end;
            FieldType::DateTime:
                begin
                    DT := FRef.Value;
                    V.SetValue(DT);
                end;
            fieldType::Boolean:
                begin
                    B := FRef.Value;
                    V.SetValue(B);
                end;
            fieldType::Blob:
                V.SetValue(GetBase64String(FRef));
            FieldType::Option:
                begin
                    Txt := Format(FRef.Value, 0, 9);
                    if Evaluate(I, Txt) then
                        if I = 0 then begin
                            EnumValueName := FRef.GetEnumValueNameFromOrdinalValue(0);
                            if EnumValueName = 'Empty' then
                                exit(V);
                        end;
                    V.SetValue(Txt);
                end;
            else
                V.SetValue(Format(FRef.Value, 0, 9));
        end;
        exit(v);
    end;

    local procedure GetJsonFieldName(FRef: FieldRef): Text
    var
        Name: Text;
        i: Integer;
    begin
        Name := FRef.Name();
#pragma warning disable AA0005
        for i := 1 to Strlen(Name) do begin
            if Name[i] < '0' then
                Name[i] := '_';
        end;
#pragma warning restore AA0005
        Name[1] := LowerCase(Name[1]) [1];
        exit(Name.Replace('__', '_').TrimEnd('_').TrimStart('_'));
    end;

    procedure AssignValueToFieldRef(var FR: FieldRef; JsonKeyValue: JsonValue)
    var


        FieldRef: FieldRef;
        JsonValue: JsonValue;
        nullDate: date;


    begin

        case FR.Type() of
            FieldType::Code,
            FieldType::Text:
                FR.Value := JsonKeyValue.AsText();
            FieldType::Integer:
                FR.Value := JsonKeyValue.AsInteger();
            FieldType::Date:
                FR.Value := JsonKeyValue.AsDate();
            FieldType::Option:
                FR.Value := JsonKeyValue.AsInteger();
            FieldType::Time:
                FR.Value := JsonKeyValue.AsTime();
            FieldType::Boolean:
                FR.Value := JsonKeyValue.AsBoolean();
            else
                error('%1 is not a supported field type', FR.Type());
        end;
    end;

    /// <summary>
    /// MapJsonObjectToRecordRef.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="Rec">Variant.</param>
    /// <param name="FieldMapDictionary">Dictionary of [Integer, Text].</param>
    /// <returns>Return value of type RecordRef.</returns>
    procedure MapJsonObjectToRecordRef(Rec: Variant; JsonObject: JsonObject; FieldMapDictionary: Dictionary of [Integer, Text]): RecordRef
    var
        RecordRef: RecordRef;
        FieldNo: Integer;
        FieldPath: Text;
        JsonToken: JsonToken;
    begin
        if not Rec.IsRecord then
            error('Parameter Rec is not a record.');
        RecordRef.GetTable(Rec);

        foreach FieldNo in FieldMapDictionary.Keys() do begin
            FieldPath := FieldMapDictionary.get(FieldNo);
            if (FieldPath <> '') and JsonObject.SelectToken(FieldPath, JsonToken) then
                SetValue(RecordRef, FieldNo, JsonToken);
        end;

        exit(RecordRef);
    end;

    /// <summary>
    /// CompareJsonObjectToRecordRef.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="Rec">Variant.</param>
    /// <param name="FieldMapDictionary">Dictionary of [Integer, Text].</param>
    /// <returns>True is record and the json have the same values.</returns>
    procedure CompareJsonObjectToRecordRef(Rec: Variant; JsonObject: JsonObject; FieldMapDictionary: Dictionary of [Integer, Text]): Boolean
    var
        RecordRef: RecordRef;
        FieldNo: Integer;
        FieldPath: Text;
        JsonToken: JsonToken;
    begin
        if not Rec.IsRecord then
            error('Parameter Rec is not a record.');
        RecordRef.GetTable(Rec);

        foreach FieldNo in FieldMapDictionary.Keys() do begin
            FieldPath := FieldMapDictionary.get(FieldNo);
            if (FieldPath <> '') and JsonObject.SelectToken(FieldPath, JsonToken) then
                if not CompareValue(RecordRef, FieldNo, JsonToken) then
                    exit(false);

        end;

        exit(true);
    end;

    /// <summary>
    /// MapRecordRefToJsonObject.
    /// </summary>
    /// <param name="Rec">Variant.</param>
    /// <param name="FieldMapDictionary">Dictionary of [Integer, Text].</param>
    /// <returns>Return variable JsonObject of type JsonObject.</returns>
    procedure MapRecordRefToJsonObject(Rec: Variant; FieldMapDictionary: Dictionary of [Integer, Text]) JsonObject: JsonObject;
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        FieldNo: Integer;
        FieldPath, ObjectPath, KeyText : Text;
        PathList: List of [Text];
        JsonToken: JsonToken;
    begin
        if not Rec.IsRecord then
            error('Parameter Rec is not a record');
        RecordRef.GetTable(Rec);

        foreach FieldNo in FieldMapDictionary.Keys() do begin
            FieldPath := FieldMapDictionary.get(FieldNo);
            ObjectPath := '';

            if (FieldPath = '') or not RecordRef.FieldExist(FieldNo) then exit;
            PathList := FieldPath.Split('.');
            PathList.Get(PathList.Count, KeyText);

            if PathList.Count > 1 then
                ObjectPath := CreateSubObjects(JsonObject, PathList.GetRange(1, PathList.Count - 1));

            FieldRef := RecordRef.Field(FieldNo);

            if JsonObject.SelectToken(ObjectPath, JsonToken) and JsonToken.IsObject() then
                JsonToken.AsObject().Add(KeyText, FieldRef2JsonValue(FieldRef));
        end;
    end;

    local procedure CreateSubObjects(var JsonObject: JsonObject; Paths: List of [Text]) ObjectPath: Text
    var
        JsonObjectSub: JsonObject;
        JsonToken: JsonToken;
        I: Integer;
    begin
        for I := 1 to Paths.Count do begin
            if ObjectPath = '' then
                ObjectPath := Paths.Get(I)
            else
                ObjectPath := ObjectPath + '.' + Paths.Get(I);

            if JsonObject.SelectToken(ObjectPath, JsonToken) then
                JsonObjectSub := JsonToken.AsObject()
            else
                if I = 1 then
                    JsonObject.Add(Paths.Get(I), JsonObjectSub)
                else
                    JsonObjectSub.Add(Paths.Get(I), JsonObjectSub);
        end;
    end;


    /// <summary>
    /// SetValue.
    /// </summary>
    /// <param name="RecordRef">VAR RecordRef.</param>
    /// <param name="FieldNo">Integer.</param>
    /// <param name="JsonToken">JsonToken.</param>
    procedure SetValue(var RecordRef: RecordRef; FieldNo: Integer; JsonToken: JsonToken)
    var
        TypeConv: codeunit 5302;
        FieldRef: FieldRef;
        JsonValue: JsonValue;
        IntegerValue: Integer;
        OptionMemberList: List of [Text];
        OptionMember: Text;
    begin
        if not RecordRef.FieldExist(FieldNo) then exit;

        FieldRef := RecordRef.Field(FieldNo);

        if not JsonToken.IsValue() then begin
            //Validate if empty value is allowed.
            FieldRef.Validate();
            exit;
        end;

        JsonValue := JsonToken.AsValue();

        if JsonValue.IsNull() or JsonValue.IsUndefined() then begin
            //Validate if empty value is allowed.
            FieldRef.Validate();
            exit;
        end;

        //Trim spaces
        JsonValue.SetValue(JsonValue.AsText().Trim());

        case FieldRef.Type() of
            FieldType::Text:
                FieldRef.Validate(COPYSTR(JsonValue.AsText(), 1, FieldRef.Length));
            FieldType::Code:
                FieldRef.Validate(COPYSTR(JsonValue.AsCode(), 1, FieldRef.Length));
            FieldType::Integer:
                FieldRef.Validate(JsonValue.AsInteger());
            FieldType::Date:
                FieldRef.Validate(JsonValue.AsDate());
            FieldType::Time:
                FieldRef.Validate(JsonValue.AsTime());
            FieldType::DateTime:
                FieldRef.Validate(JsonValue.AsDateTime());
            FieldType::Boolean:
                FieldRef.Validate(JsonValue.AsBoolean());
            FieldType::Option:
                if Evaluate(IntegerValue, JsonValue.AsText()) then
                    FieldRef.Validate(IntegerValue)
                else begin
                    OptionMemberList := FieldRef.OptionMembers().Split(',');
                    foreach OptionMember in OptionMemberList do
                        if OptionMember = JsonValue.AsText() then begin
                            FieldRef.Validate(TypeConv.TextToOptionValue(JsonValue.AsText(), FieldRef.OptionMembers()));
                            exit;
                        end;
                end;
            FieldType::Decimal:
                FieldRef.Validate(JsonValue.AsDecimal());
        end;
    end;



    local procedure CompareValue(var RecordRef: RecordRef; FieldNo: Integer; JsonToken: JsonToken): Boolean
    var
        FieldRef: FieldRef;
        JsonValue: JsonValue;
        IntegerValue: Integer;
        BoolValue: Boolean;
    begin
        if not RecordRef.FieldExist(FieldNo) then exit;

        FieldRef := RecordRef.Field(FieldNo);

        if not JsonToken.IsValue() then begin
            //Validate if empty value is allowed.
            FieldRef.Validate();
            exit;
        end;

        JsonValue := JsonToken.AsValue();

        if JsonValue.IsNull() or JsonValue.IsUndefined() then begin
            //Validate if empty value is allowed.
            FieldRef.Validate();
            exit;
        end;

        //Trim spaces
        JsonValue.SetValue(JsonValue.AsText().Trim());

        case FieldRef.Type() of
            FieldType::Text:
                BoolValue := (Format(FieldRef.Value).ToUpper() = JsonValue.AsText().ToUpper());
            FieldType::Integer:
                begin
                    IntegerValue := FieldRef.Value;
                    BoolValue := IntegerValue = JsonValue.AsInteger();
                end;
            FieldType::Code:
                BoolValue := (Format(FieldRef.Value).ToUpper() = JsonValue.AsText().ToUpper());

        end;

        exit(BoolValue);
    end;

    /// <summary>
    /// SelectJsonToken.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="Path">text.</param>
    /// <returns>Return variable ResultJsonToken of type JsonToken.</returns>
    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) ResultJsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, ResultJsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

    /// <summary>
    /// SelectJsonObject.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="Path">text.</param>
    /// <returns>Return variable ResultJsonObject of type JsonObject.</returns>
    procedure SelectJsonObject(JsonObject: JsonObject; Path: text) ResultJsonObject: JsonObject;
    var
        JsonToken: JsonToken;
    begin
        JsonToken := SelectJsonToken(JsonObject, Path);

        if not JsonToken.IsObject() then
            Error('Could not find object with path %1', Path);

        ResultJsonObject := JsonToken.AsObject();
    end;

    /// <summary>
    /// SelectJsonObject.
    /// </summary>
    /// <param name="JsonToken">JsonToken.</param>
    /// <param name="Path">text.</param>
    /// <param name="JsonObjectResult">VAR JsonObject.</param>
    /// <returns>Return variable Success of type Boolean.</returns>
    procedure SelectJsonObject(JsonToken: JsonToken; Path: text; var JsonObjectResult: JsonObject) Success: Boolean;
    var
        JsonTokenResult: JsonToken;
    begin
        Success := JsonToken.SelectToken(path, JsonTokenResult) and JsonTokenResult.IsObject();

        if Success then
            JsonObjectResult := JsonTokenResult.AsObject();
    end;



    /// <summary>
    /// SelectJsonArray.
    /// </summary>
    /// <param name="JsonObject">JsonObject.</param>
    /// <param name="Path">text.</param>
    /// <returns>Return variable ResultJsonArray of type JsonArray.</returns>
    procedure SelectJsonArray(JsonObject: JsonObject; Path: text) ResultJsonArray: JsonArray;
    var
        JsonToken: JsonToken;
    begin
        JsonToken := SelectJsonToken(JsonObject, Path);

        if not JsonToken.IsArray() then
            Error('Could not find array with path %1', Path);

        ResultJsonArray := JsonToken.AsArray();
    end;

    /// <summary>
    /// SelectJsonArray.
    /// </summary>
    /// <param name="JsonToken">JsonToken.</param>
    /// <param name="Path">text.</param>
    /// <param name="JsonArrayResult">VAR JsonArray.</param>
    /// <returns>Return variable Success of type Boolean.</returns>
    procedure SelectJsonArray(JsonToken: JsonToken; Path: text; var JsonArrayResult: JsonArray) Success: Boolean;
    var
        JsonTokenResult: JsonToken;
    begin
        Success := JsonToken.SelectToken(path, JsonTokenResult) and JsonTokenResult.IsArray();

        if Success then
            JsonArrayResult := JsonTokenResult.AsArray();
    end;
}