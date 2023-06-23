/// <summary>
/// Table ACKWMOMessageRetourCode
/// </summary>
table 50006 ACKWMOMessageRetourCode
{
    Caption = 'Message retour code';
    DataCaptionFields = RetourCodeID;
    DataClassification = SystemMetadata;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
        field(20; HeaderId; Guid)
        {
            Caption = 'Header System ID', Locked = true;
            TableRelation = ACKWMOHeader.SystemId;

            trigger OnValidate()
            begin
                TestField(Rec.HeaderId);
            end;
        }
        field(30; RetourCodeID; Code[4])
        {
            Caption = 'Retourcode', Locked = true;
            TableRelation = ACKWMORetourCode.ID;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                TestField(Rec.RetourCodeID);
            end;
        }

        field(40; RefID; Guid)
        {
            Caption = 'Reference id', Locked = true;
            TableRelation =
            if (RelationTableNo = const(Database::ACKWMOHeader)) ACKWMOHeader.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMOClient)) ACKWMOClient.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMORelatie)) ACKWMORelatie.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMOContact)) ACKWMOContact.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMOToegewezenProduct)) ACKWMOToegewezenProduct.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMOStartStopProduct)) ACKWMOStartStopProduct.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMOAntwoord)) ACKWMOAntwoord.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMOPrestatie)) ACKWMOPrestatie.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMODeclaratie)) ACKWMODeclaratie.SystemId;

            trigger OnValidate()
            begin
                TestField(Rec.RefID);
            end;
        }

        field(50; RelationTableNo; Integer)
        {
            Caption = 'Relation Table No.';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            var
                RelationToSelfErr: Label '%1 cannot have a relation to itself.', Comment = '%1 = Table caption', Locked = true;
            begin
                if Rec.RelationTableNo = Database::ACKWMOMessageRetourCode then
                    Error(RelationToSelfErr, Rec.TableCaption());
            end;
        }

        field(60; Rule; Enum ACKWMORule)
        {
            Caption = 'Rule';
            TableRelation = ACKWMORule.Rule;
        }

        field(70; RetourCodeDescription; Text[2048])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKWMORetourCode.Description where(ID = field(RetourCodeID)));
            Editable = false;
        }
        field(80; MessageInvalid; Boolean)
        {
            Caption = 'Message invalid';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKWMORetourCode.MessageInvalid where(ID = field(RetourCodeID)));
            Editable = false;
        }
        field(90; RelationTableCaption; Text[249])
        {
            FieldClass = FlowField;
            Caption = 'Related table';
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                        "Object ID" = field(RelationTableNo)));
            Editable = false;
        }
        field(100; RuleDescription; Text[1024])
        {
            FieldClass = FlowField;
            Caption = 'Rule description';
            CalcFormula = lookup(ACKWMORule.Description where(Rule = field(Rule)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(HeaderId; HeaderId)
        {
            Unique = false;
        }
        key(RefKey; RelationTableNo, HeaderId, RefID)
        {
            Unique = true;
        }
    }

    trigger OnInsert()
    begin
        TestField(Rec.RefID);
    end;

    /// <summary>
    /// DeleteFromHeaderId.
    /// </summary>
    /// <param name="_HeaderId">Guid.</param>
    procedure DeleteFromHeaderId(_HeaderId: Guid)
    var
        MessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        MessageRetourCode.SetCurrentKey(HeaderId);
        MessageRetourCode.SetRange(HeaderId, _HeaderId);
        MessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// InsertRetourCode.
    /// </summary>
    /// <param name="_RelationTableNo">Integer.</param>
    /// <param name="_RefId">Guid.</param>
    /// <param name="_Rec">Variant.</param>
    /// <param name="_HeaderId">Guid.</param>
    /// <param name="_RetourCode">Enum ACKRetourCode.</param>
    /// <param name="_Rule">Enum ACKWMORule.</param>
    // procedure InsertRetourCode(_Rec: Variant; _HeaderId: Guid; _Rule: Enum ACKWMORule)
    // var
    //     RecordRef: RecordRef;
    // begin
    //     ACKHelper.GetRecordFromVariant(_Rec, RecordRef, false, true);
    //     InsertRetourCode(RecordRef.Number(), RecordRef.Field(RecordRef.SystemIdNo()).Value(), _HeaderId, _Rule);
    // end;


    procedure InsertRetourCode(_RelationTableNo: Integer; _RefId: Guid; _HeaderId: Guid; _RetourCode: Enum ACKRetourCode)
    begin
        InsertRetourCode(_RelationTableNo, _RefId, _HeaderId, ACKWMORule::Empty, _RetourCode);
    end;

    /// <summary>
    /// InsertRetourCode.
    /// </summary>
    /// <param name="_RelationTableNo">Integer.</param>
    /// <param name="_RefId">Guid.</param>
    /// <param name="_HeaderId">Guid.</param>
    /// <param name="_Rule">Enum ACKWMORule.</param>
    procedure InsertRetourCode(_RelationTableNo: Integer; _RefId: Guid; _HeaderId: Guid; _Rule: Enum ACKWMORule)
    begin
        InsertRetourCode(_RelationTableNo, _RefId, _HeaderId, _Rule, ACKRetourCode::Empty);
    end;

    /// <summary>
    /// InsertRetourCode.
    /// </summary>
    /// <param name="_RelationTableNo">Integer.</param>
    /// <param name="_RefId">Guid.</param>
    /// <param name="_HeaderId">Guid.</param>
    /// <param name="_Rule">Enum ACKWMORule.</param>
    /// <param name="_RetourCode">Enum ACKRetourCode.</param>
    procedure InsertRetourCode(_RelationTableNo: Integer; _RefId: Guid; _HeaderId: Guid; _Rule: Enum ACKWMORule; _RetourCode: Enum ACKRetourCode)
    var
        WMORule: Record ACKWMORule;
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
        RetourCodeText: Code[4];
        InvalidReferenceErr: Label 'Ref id cannot be null';
    begin
        if IsNullGuid(_RefId) then
            Error(InvalidReferenceErr);

        if _RetourCode = ACKRetourCode::Empty then
            RetourCodeText := Format(ACKRetourCode::"0200", 4)
        else
            RetourCodeText := Format(_RetourCode, 4);

        if _Rule <> ACKWMORule::Empty then begin
            WMORule.Get(_Rule);
            RetourCodeText := WMORule.RetourCodeID;
        end;

        ACKWMOMessageRetourCode.SetRange(RelationTableNo, _RelationTableNo);
        ACKWMOMessageRetourCode.SetRange(HeaderId, _HeaderId);
        ACKWMOMessageRetourCode.SetRange(RefID, _RefId);
        ACKWMOMessageRetourCode.SetRange(RetourCodeID, RetourCodeText);

        if not ACKWMOMessageRetourCode.FindFirst() then begin
            ACKWMOMessageRetourCode.Init();
            ACKWMOMessageRetourCode.RetourCodeID := RetourCodeText;
            ACKWMOMessageRetourCode.RelationTableNo := _RelationTableNo;
            ACKWMOMessageRetourCode.RefID := _RefId;
            ACKWMOMessageRetourCode.HeaderId := _HeaderId;
            ACKWMOMessageRetourCode.Rule := _Rule;

            //If insert fails this could be the same retourcode inserted twice during the same transaction
            //This is not a problem so just exit.
            if not ACKWMOMessageRetourCode.Insert(true) then
                exit;
        end;
    end;

    var
        ACKHelper: Codeunit ACKHelper;
}
