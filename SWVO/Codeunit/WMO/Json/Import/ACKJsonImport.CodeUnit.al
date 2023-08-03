/// <summary>
/// Codeunit ACKJsonImport
/// </summary>
codeunit 50038 ACKJsonImport
{
    var
        JSONMessage: Record ACKJSONMessage;
        ACKJsonTools: codeunit ACKJsonTools;
        JsonObjectRoot: JsonObject;
        ReferentieNummer: Guid;
        ACKHelper: Codeunit ACKHelper;
        IsWMO: Boolean;

    trigger OnRun()
    begin
        if IsWMO then
            ImportWMOJson()
        else
            ImportJson();
    end;

    /// <summary>
    /// Init.
    /// </summary>
    /// <param name="_StUF">Record ACKStUF.</param>
    procedure Init(var _StUF: Record ACKStUF)
    var
        JsonObjectLoc: JsonObject;
        EmptyRecordErr: Label 'Record is empty.';
        AlreadyProcessedErr: Label 'Message: %1 is already processed', Comment = '%1 = Referentienummer';
        InvalidCrossRefErr: Label 'Geen gerelateerd StUF bericht gevonden met referentienummer: %1', Comment = '%1 = CrossReferentienummer', Locked = true;
        Versie, SubVersie : Integer;
    begin
        if _StUF.IsEmpty then
            Error(EmptyRecordErr);

        if _StUF.Status <> ACKJobStatus::Ready then
            Error(AlreadyProcessedErr, _StUF.Referentienummer);

        if not _StUF.TryGetJsonObject(JsonObjectLoc) then
            Error(GetLastErrorText());

        if not _StUF.CrossReferenceExists() then
            //CreateStUFFoutbericht(_StUF, ACKStUFBerichtCode::Fo03, 'CC04', StrSubstNo(InvalidCrossRefErr, _StUF.CrossRefnummer), 1);
            Error(InvalidCrossRefErr);

        ReferentieNummer := _StUF.Referentienummer;
        Evaluate(Versie, _StUF.FunctieVersie);
        Evaluate(SubVersie, _StUF.FunctieSubversie);
        Init(JsonObjectLoc, _StUF.Functie, Versie, SubVersie, true);
    end;

    /// <summary>
    /// RunMessage.
    /// </summary>
    /// <param name="_JsonObjectRoot">JsonObject.</param>
    /// <param name="VektisCode">Enum ACKVektisCode.</param>
    /// <param name="Versie">Code[4].</param>
    /// <param name="Subversie">Code[4].</param>
    procedure Init(_JsonObjectRoot: JsonObject; VektisCode: Enum ACKVektisCode; Versie: Integer; Subversie: Integer; _IsWMO: Boolean)
    begin
        IsWMO := _IsWMO;
        JsonObjectRoot := _JsonObjectRoot;

        JSONMessage.SetRange(VektisCode, VektisCode);
        JSONMessage.SetRange(Versie, Versie);
        JSONMessage.SetRange(SubVersie, Subversie);
        JSONMessage.SetRange(Active, true);
    end;

    /// <summary>
    /// RunMessage.
    /// </summary>
    /// <param name="_ACKJSONMessage">Record ACKJSONMessage.</param>
    /// <param name="_JsonObjectRoot">JsonObject.</param>
    /// <returns>Return value of type begin.</returns>
    procedure Init(_ACKJSONMessage: Record ACKJSONMessage; _JsonObjectRoot: JsonObject)
    begin
        JSONMessage := _ACKJSONMessage;
        JsonObjectRoot := _JsonObjectRoot;
    end;

    local procedure ImportWMOJson()
    var
        JSONMapStart: Record ACKJSONMap;
        WmoHeaderNew, WmoHeaderTo : Record ACKWMOHeader;
        StUF: Record ACKStUF;
        ACKGenerateStuf: Codeunit ACKGenerateStuf;
        RecordRefCurrent: RecordRef;
    begin
        if IsNullGuid(ReferentieNummer) then begin
            ReferentieNummer := CreateGuid();
            ACKHelper.AddEventLog(Database::ACKStUF, Severity::Verbose, StrSubstNo('New Guid Created: %1', ReferentieNummer));
        end;

        JSONMessage.FindFirst();

        NextMap(JSONMapStart, JsonObjectRoot.AsToken(), RecordRefCurrent);

        if GetWMOHeader(WmoHeaderNew) and WmoHeaderNew.IsRetour() then
            if WmoHeaderNew.GetToHeader(WmoHeaderTo, false) then begin
                WmoHeaderNew.RefHeaderId := WmoHeaderTo.SystemId;
                WmoHeaderTo.RefHeaderId := WmoHeaderNew.SystemId;

                WmoHeaderNew.Modify(true);
                WmoHeaderTo.Modify(true);
            end;

        StUF.SetRange(Referentienummer, ReferentieNummer);
        if StUF.IsEmpty() then begin
            ACKHelper.AddEventLog(Database::ACKStUF, Severity::Verbose, 'Start generating stuf');
            ACKGenerateStuf.Run(WmoHeaderNew);
        end;
    end;

    local procedure ImportJson()
    var
        JSONMapStart: Record ACKJSONMap;
        RecordRefCurrent: RecordRef;
    begin
        JSONMessage.FindFirst();

        NextMap(JSONMapStart, JsonObjectRoot.AsToken(), RecordRefCurrent);
    end;


    //Opens a new record or continues to insert values if still on the same level.
    local procedure ProcessMap(JSONMapCurrent: Record ACKJSONMap; JsonTokenCurrent: JsonToken; var RecordRefParent: RecordRef)
    var
        RecordRefCurrent: RecordRef;
    begin
        ValidateExpectedType(JSONMapCurrent.JSONType, JsonTokenCurrent);

        //If the table no did not change then proceed using the same recordref.
        if RecordRefParent.Number() = JSONMapCurrent.TableNo then
            RecordRefCurrent := RecordRefParent
        else
            //Save the parent record before continuing with a new record.
            if RecordRefParent.Number() > 0 then
                InsertOrModifyRecordRef(RecordRefParent);

        //Open a new record and set the relation to it's parent.
        if RecordRefCurrent.Number() = 0 then begin
            OpenRecordRef(RecordRefCurrent, JSONMapCurrent.TableNo);
            SetRelationFields(RecordRefParent, RecordRefCurrent, JSONMapCurrent.Path);
            setJsonRelations(RecordRefParent, RecordRefCurrent, JSONMapCurrent.Path, JSONMapCurrent.No);
        end;



        case JSONMapCurrent.JSONType of
            //If an object is found then start the loop with the procedure NextMap
            ACKJSONType::"Object":
                NextMap(JSONMapCurrent, JsonTokenCurrent, RecordRefCurrent);
            ACKJSONType::"Array":
                ProcessArray(JSONMapCurrent, JsonTokenCurrent.AsArray(), RecordRefCurrent);
            ACKJSONType::"Value":
                ACKJsonTools.SetValue(RecordRefCurrent, JSONMapCurrent.FieldNo, JsonTokenCurrent);
        end;
    end;

    //Finds the next mapping and loops through it's children. 
    local procedure NextMap(JSONMapParent: Record ACKJSONMap; JsonTokenParent: JsonToken; var RecordRefParent: RecordRef)
    var
        JSONMapChild: Record ACKJSONMap;
        JsonTokenCurrent: JsonToken;
        PathNotFoundErr: Label 'Could not find required path %1', Comment = '%1 = Path', Locked = true;
    begin
        JSONMapChild.SetCurrentKey(SortOrder);
        JSONMapChild.SetRange(MessageCode, JSONMessage.MessageCode);
        JSONMapChild.SetRange(ParentNo, JSONMapParent.No);
        JSONMapChild.SetAscending(SortOrder, true);

        if JSONMapChild.FindSet(true) then
            repeat
                if JsonTokenParent.SelectToken(JSONMapChild.Path, JsonTokenCurrent) then
                    ProcessMap(JSONMapChild, JsonTokenCurrent, RecordRefParent)
                else
                    if JSONMapChild.Required = true then
                        Error(PathNotFoundErr, JSONMapChild.Path);
            until JSONMapChild.Next() = 0;

        if (RecordRefParent.Number() <> 0) and (RecordRefParent.Number() <> Database::ACKNewChangedUnchangedProduct) then
            InsertOrModifyRecordRef(RecordRefParent);
    end;

    //Loops through the array and saves the content.
    local procedure ProcessArray(JSONMapCurrent: Record ACKJSONMap; JsonArray: JsonArray; var RecordRefCurrent: RecordRef)
    var
        JSONMapFirstChild: Record ACKJSONMap;
        NewChangedUnchangedProduct: Record ACKNewChangedUnchangedProduct;
        RecordRefCopy: RecordRef;
        JsonToken: JsonToken;
        EmptyRequiredArrayErr: Label 'Array %1 is empty but child is required.', Comment = '%1 = Path', Locked = true;
        ArrayWithoutChildErr: Label 'Array %1 defined without child mappings.', Comment = '%1 = Path', Locked = true;
    begin
        if not JSONMapCurrent.GetFirstChild(JSONMapFirstChild) then
            Error(ArrayWithoutChildErr, JSONMapCurrent.GetFullPath());

        case JSONMapCurrent.Path of
            'ongewijzigdeProducten':
                RecordRefCurrent.Field(NewChangedUnchangedProduct.FieldNo(NewChangedUnchangedProductType)).Validate(ACKNewChangedUnchangedProductType::Unchanged);
            'teWijzigenProducten':
                RecordRefCurrent.Field(NewChangedUnchangedProduct.FieldNo(NewChangedUnchangedProductType)).Validate(ACKNewChangedUnchangedProductType::Changed);
            'nieuweProducten':
                RecordRefCurrent.Field(NewChangedUnchangedProduct.FieldNo(NewChangedUnchangedProductType)).Validate(ACKNewChangedUnchangedProductType::New);
        end;

        //Checks if there is atleast one entry.
        if not JsonArray.Get(0, JsonToken) then
            if JSONMapFirstChild.Required then
                Error(EmptyRequiredArrayErr, JSONMapFirstChild.GetFullPath())
            else
                exit;

        //Loops the array and saves the value or processes the object if the array contains objects.
        foreach JsonToken in JsonArray do begin
            OpenRecordRef(RecordRefCopy, RecordRefCurrent.Number());
            RecordRefCopy.Copy(RecordRefCurrent);

            if JsonToken.IsObject() then
                NextMap(JSONMapCurrent, JsonToken, RecordRefCopy);

            if JsonToken.IsValue() then begin
                ACKJsonTools.SetValue(RecordRefCopy, JSONMapFirstChild.FieldNo, JsonToken);
                RecordRefCopy.Insert(true);
            end;
            InsertOrModifyRecordRef(RecordRefCopy);
        end;
    end;

    //Inserts or updates a record if it already exists.
    local procedure InsertOrModifyRecordRef(var RecordRef: RecordRef)
    begin
        if IsNullGuid(RecordRef.Field(RecordRef.SystemIdNo()).Value()) then
            RecordRef.Insert(true)
        else
            RecordRef.Modify(true)
    end;

    //Returns current type from the json token
    local procedure GetJSONTypeFromJSONToken(JsonToken: JsonToken): Enum ACKJSONType
    begin
        if JsonToken.IsArray() then
            exit(ACKJSONType::"Array");
        if JsonToken.IsObject() then
            exit(ACKJSONType::"Object");
        if JsonToken.IsValue() then
            exit(ACKJSONType::"Value");
    end;

    //Validates that the current jsontoken matches the expected type in the json map.
    local procedure ValidateExpectedType(ExpectedJSONType: Enum ACKJSONType; JsonToken: JsonToken)
    var
        TokenJSONType: Enum ACKJSONType;
        ExpectedTypeErr: Label 'Expected %1 but found %2.', Comment = '%1 = JSON Type expected, %2 JSON Type found', Locked = true;
    begin
        TokenJSONType := GetJSONTypeFromJSONToken(JsonToken);

        if ExpectedJSONType <> TokenJSONType then
            Error(ExpectedTypeErr, Format(ExpectedJSONType), Format(TokenJSONType));
    end;

    //Checks if there is a relation between the child and the parent record, if found then it sets the relation
    local procedure SetRelationFields(ParentRecordRef: RecordRef; var ChildRecordRef: RecordRef; Path: Text)
    var
        WMOHeader: Record ACKWMOHeader;
        WMOClient: Record ACKWMOClient;
        WMORelatie: Record ACKWMORelatie;
        WMOContact: Record ACKWMOContact;
        WMOToegewezenProduct: Record ACKWMOToegewezenProduct;
        NewChangedUnchangedProduct: Record ACKNewChangedUnchangedProduct;
        WMOStartStopProduct: Record ACKWMOStartStopProduct;
        WMODeclaratie: Record ACKWMODeclaratie;
        WMODeclaratieAntwoord: Record ACKWMODeclaratieAntwoord;
        WMOPrestatie: Record ACKWMOPrestatie;
        WMOAntwoord: Record ACKWMOAntwoord;
        WMOMessageRetourCode: Record ACKWMOMessageRetourCode;
        ParentRecordRefCopy: RecordRef;
        ParentSystemId: Guid;

        //
        i: Integer;
        varKeyRef: KeyRef;
        Text000: Label 'KeyIndex: %1   KeyRef: %2';
        testRec: RecordRef;
        Name: text;
    begin
        //Create a copy so we don't change the state of the parameter.
        if ParentRecordRef.Number() > 0 then begin
            ParentRecordRefCopy.Open(ParentRecordRef.Number());
            ParentRecordRefCopy.Copy(ParentRecordRef);

            for i := 1 to ChildRecordRef.KeyCount do begin
                varKeyRef := ChildRecordRef.KeyIndex(i);
                testRec := varKeyRef.Record();

                Name := ParentRecordRef.Name;
                Name := testRec.Name;


                if (ParentRecordRef.Name = testRec.Name) then
                    i := i;
            end;
        end;

        if (ChildRecordRef.Number() = Database::ACKWMOClient) or
           (ChildRecordRef.Number() = Database::ACKWMODeclaratie) or
           (ChildRecordRef.Number() = Database::ACKWMODeclaratieAntwoord) or
           (ChildRecordRef.Number() = Database::ACKWMOAntwoord) then begin

            if not GetWMOHeader(WMOHeader) then
                exit;

            ParentRecordRefCopy.GetTable(WMOHeader);
        end;

        //By now the ParentRecordRef must be initialized
        if ParentRecordRefCopy.Number() = 0 then
            exit;

        ParentSystemId := ParentRecordRefCopy.Field(ParentRecordRefCopy.SystemIdNo()).Value();

        case ChildRecordRef.Number() of
            Database::ACKWMOClient:
                if ChildRecordRef.Field(WMOClient.FieldNo(HeaderId)).Relation() = ParentRecordRefCopy.Number() then
                    ChildRecordRef.Field(WMOClient.FieldNo(HeaderId)).Validate(ParentSystemId);
            Database::ACKWMORelatie:
                ChildRecordRef.Field(WMORelatie.FieldNo(ClientID)).Validate(ParentSystemId);
            Database::ACKWMOContact:
                begin
                    ChildRecordRef.Field(WMOContact.FieldNo(RelationTableNo)).Validate(ParentRecordRefCopy.Number());
                    ChildRecordRef.Field(WMOContact.FieldNo(RefID)).Validate(ParentSystemId);
                end;
            Database::ACKWMOToegewezenProduct:
                ChildRecordRef.Field(WMOToegewezenProduct.FieldNo(ClientID)).Validate(ParentSystemId);
            Database::ACKNewChangedUnchangedProduct:
                ChildRecordRef.Field(NewChangedUnchangedProduct.FieldNo(ClientID)).Validate(ParentSystemId);
            Database::ACKWMOStartStopProduct:
                ChildRecordRef.Field(WMOStartStopProduct.FieldNo(ClientId)).Validate(ParentSystemId);
            Database::ACKWMODeclaratie:
                ChildRecordRef.Field(WMODeclaratie.FieldNo(HeaderId)).Validate(ParentSystemId);
            Database::ACKWMODeclaratieAntwoord:
                ChildRecordRef.Field(WMODeclaratieAntwoord.FieldNo(HeaderId)).Validate(ParentSystemId);
            Database::ACKWMOPrestatie:
                ChildRecordRef.Field(WMOPrestatie.FieldNo(ClientID)).Validate(ParentSystemId);
            Database::ACKWMOAntwoord:
                ChildRecordRef.Field(WMOAntwoord.FieldNo(HeaderId)).Validate(ParentSystemId);
            Database::ACKWMOMessageRetourCode:
                begin
                    if not GetWMOHeader(WMOHeader) then
                        exit;

                    ChildRecordRef.SetTable(WMOMessageRetourCode);
                    WMOMessageRetourCode.RelationTableNo := ParentRecordRefCopy.Number();
                    WMOMessageRetourCode.RefID := ParentSystemId;
                    WMOMessageRetourCode.HeaderId := WMOHeader.SystemId;
                    ChildRecordRef.GetTable(WMOMessageRetourCode);
                end;
        end
    end;

    local procedure setJsonRelations(ParentRecordRef: RecordRef; var ChildRecordRef: RecordRef; Path: Text; CurrentJsonMapNo: Code[20])
    var
        JSONMap: Record ACKJSONMap;
        JSONObjectRelation: Record ACKJSONMapObjectRelations;
        ParentField: FieldRef;
        ObjectField: FieldRef;
        RecRef: RecordRef;
    begin

        JSONObjectRelation.SetRange(ObjectNo, CurrentJsonMapNo);

        if JSONObjectRelation.FindSet() then
            repeat
                ParentField := ParentRecordRef.Field(JSONObjectRelation.ParentField);

                ObjectField := ChildRecordRef.Field(JSONObjectRelation.ObjectField);

                ObjectField.Value := ParentField.Value;
                ObjectField.TestField();
            until JSONObjectRelation.Next() = 0;

    end;

    // local procedure CreateStUFFoutbericht(BerichtCode: Enum ACKStUFBerichtCode; Foutcode: Text[10]; Omschrijving: Text[250]; Plek: Option client,server)
    // var
    //     StUfNew: Record ACKStUF;
    // begin
    //     StUfNew.Init();
    //     StUfNew.SetDefaultFields(BerichtCode);

    //     //Zender
    //     StUF.ZenderOrganisatie := StUF.OntvangerOrganisatie;

    //     //Ontvanger
    //     StUfNew.OntvangerOrganisatie := StUF.ZenderOrganisatie;
    //     StUfNew.OntvangerApplicatie := StUF.ZenderApplicatie;

    //     //Foutbody
    //     StUfNew.Foutcode := Foutcode;
    //     StUfNew.Plek := Plek;
    //     StUfNew.Omschrijving := Omschrijving;

    //     StUfNew.Insert(true);
    // end;

    local Procedure OpenRecordRef(var RecordRef: RecordRef; TableNo: Integer)
    var
        WMOHeader: Record ACKWMOHeader;
    begin
        if RecordRef.Number() > 0 then
            RecordRef.Close();

        RecordRef.Open(TableNo);
        RecordRef.Init();

        if RecordRef.Number() = Database::ACKWMOHeader then
            RecordRef.Field(WMOHeader.FieldNo(Referentienummer)).Validate(ReferentieNummer);
    end;

    Procedure GetWMOHeader(var WMOHeader: Record ACKWMOHeader) Found: Boolean
    begin
        WMOHeader.SetRange(Referentienummer, Referentienummer);
        Found := WMOHeader.FindFirst();
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