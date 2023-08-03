/// <summary>
/// Table ACKJSONMap (No 50060).
/// </summary>
table 50060 ACKJSONMap
{
    Caption = 'JSON Mapping', Locked = true;
    DataPerCompany = false;
    DataCaptionFields = No, JSONType, Path;
    DataClassification = SystemMetadata;
    LookupPageId = ACKJSONMapList;

    fields
    {
        field(10; No; Code[20])
        {
            Caption = 'No.', Locked = true;
            Editable = true;
            NotBlank = false;

            trigger OnValidate()
            begin
                TestNoSeries();
                TestField(Rec.No);
            end;
        }
        field(20; MessageCode; Code[20])
        {
            Caption = 'Message code', Locked = true;
            TableRelation = ACKJSONMessage.MessageCode;
            Editable = true;
            NotBlank = true;
        }
        field(30; ParentNo; Code[20])
        {
            Caption = 'Parent No.', Locked = true;
            TableRelation = ACKJSONMap.No where(MessageCode = field(MessageCode));
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                CircularReferenceErr: Label 'Cannot have relation to itself.', Locked = true;
            begin
                if (Rec.ParentNo <> '') and (Rec.ParentNo = Rec.No) then
                    Error(CircularReferenceErr);
            end;
        }
        field(40; Path; Text[250])
        {
            Caption = 'Path', Locked = true;
            NotBlank = false;
        }
        field(50; JSONType; Enum ACKJSONType)
        {
            Caption = 'JSON Type', locked = true;
            trigger OnValidate()
            begin
                if Rec.JSONType <> ACKJSONType::"Value" then
                    Rec.FieldNo := 0;
                //ToDo Else should delete child mappings just to be sure.
            end;
        }
        field(60; TableNo; Integer)
        {
            Caption = 'Table No.', Locked = true;
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            begin
                if Rec.TableNo <> xRec.TableNo then
                    Rec.FieldNo := 0;
            end;
        }
        field(70; FieldNo; Integer)
        {
            Caption = 'Field No.', Locked = true;
            TableRelation = Field."No." where(TableNo = field(TableNo));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                FieldRec: Record Field;
                OnlyOnJSONTypeValueErr: Label 'Only specify %1 when %2 is of type Value.', Comment = '%1 = Field Id caption; %2 = JSON Type caption', Locked = true;
            begin
                if Rec.FieldNo <> 0 then
                    if Rec.JSONType = ACKJSONType::"Value" then begin
                        FieldRec.Get(Rec.TableNo, Rec.FieldNo);
                        if Rec.Path = '' then
                            Rec.Path := LowerCase(CopyStr(FieldRec.FieldName, 1, 1)) + CopyStr(FieldRec.FieldName, 2);
                    end
                    else
                        Error(OnlyOnJSONTypeValueErr, Rec.FieldCaption(FieldNo), Rec.FieldCaption(JSONType));
            end;

            trigger OnLookup()
            var
                RecField: Record Field;
                FieldSelection: Codeunit "Field Selection";
            begin
                RecField.Reset();
                RecField.SetRange(TableNo, Rec.TableNo);

                if FieldSelection.Open(RecField) then
                    Rec.Validate(FieldNo, RecField."No.");
            end;
        }
        field(80; SortOrder; Integer)
        {
            Caption = 'Sort order', Locked = true;
            MinValue = 0;
        }
        field(85; SkipEmptyOrDefault; Boolean)
        {
            //Skips empty or null or default values on export.
            Caption = 'Skip empty or default', Locked = true;
            InitValue = true;
        }
        field(90; "Required"; Boolean)
        {
            Caption = 'Required', Locked = true;
            InitValue = true;

            // trigger OnValidate()
            // var
            //     JSONMapParent: Record ACKJSONMap;
            //     ParentNotRequiredErr: Label 'Cannot set required if parent is not required.';
            // begin
            //     if Rec.Required then
            //         if Rec.GetParent(JSONMapParent) then
            //             if not JSONMapParent.Required then
            //                 Error(ParentNotRequiredErr);
            // end;
        }
        field(100; MaxLength; Integer)
        {
            Caption = 'Max length', Locked = true;
        }
        field(130; TableCaption; Text[250])
        {
            FieldClass = FlowField;
            Caption = 'Table Caption', Locked = true;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table),
                                                                        "Object ID" = field(TableNo)));
            Editable = false;
        }
        field(140; FieldCaption; Text[80])
        {
            Caption = 'Field Caption', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field(TableNo), "No." = field(FieldNo)));
            Editable = false;
        }
        field(150; ParentPath; Text[250])
        {
            Caption = 'Parent path', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(ACKJSONMap.Path where(No = field(ParentNo)));
            Editable = false;
        }
        field(160; ParentJSONType; Enum ACKJSONType)
        {
            Caption = 'Parent JSON Type', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(ACKJSONMap.JSONType where(No = field(ParentNo)));
            Editable = false;
        }




    }
    keys
    {
        key(PK; "No")
        {
            Clustered = true;
        }
        key(SortOrder; MessageCode, ParentNo, SortOrder)
        {
            Unique = true;
        }
        key(Path; MessageCode, ParentNo, Path)
        {
            Unique = true;
        }
    }

    trigger OnDelete()
    var
        ACKJSONMapChild: Record ACKJSONMap;
    begin
        ACKJSONMapChild.SetRange(MessageCode, Rec.MessageCode);
        ACKJSONMapChild.SetRange(ParentNo, Rec.No);
        ACKJSONMapChild.DeleteAll(true);
    end;

    trigger OnModify()
    begin
        Validate();
    end;

    local procedure Validate(): Boolean
    var
        JSONMapParent: Record ACKJSONMap;
        JSONValueFieldNoErr: Label 'When %1 is Value, then %2 cannot be empty.', Comment = '%1 = JSON Type, %2 = Field No.', Locked = true;
        JSONValueParentTableNoErr: Label 'When %1 is Value, then %2 cannot be different than the parent %2.', Comment = '%1 = JSON Type, %2 = Table No.', Locked = true;
    begin
        Validate(ParentNo);

        // if Rec.JSONType = ACKJSONType::"Value" then begin
        //     if Rec.FieldNo = 0 then
        //         Error(JSONValueFieldNoErr, Rec.FieldCaption(JSONType), Rec.FieldCaption(FieldNo));

        //     if Rec.ParentNo <> '' then begin
        //         Rec.GetParent(JSONMapParent);

        //         if Rec.TableNo <> JSONMapParent.TableNo then
        //             Error(JSONValueParentTableNoErr, Rec.FieldCaption(JSONType), Rec.FieldCaption(TableNo));
        //     end;
        // end;
    end;

    /// <summary>
    /// GetFullPath.
    /// </summary>
    /// <returns>Return variable FullPath of type Text.</returns>
    procedure GetFullPath() FullPath: Text
    begin
        FullPath := GetParentPath();

        if Rec.Path <> '' then begin
            if FullPath <> '' then
                FullPath += '.';
            FullPath += Rec.Path;
        end;
    end;

    /// <summary>
    /// GetParentPath.
    /// </summary>
    /// <returns>Return variable FullPath of type Text.</returns>
    procedure GetParentPath() FullPath: Text
    var
        PathList: List of [Text[250]];
        Val: text[250];
    begin
        AddParentPath(PathList, Rec);
        PathList.Reverse();

        foreach Val in PathList do begin
            if FullPath <> '' then
                FullPath += '.';
            FullPath += Val;
        end;
    end;

    local procedure AddParentPath(var PathList: List of [Text[250]]; JSONMapFrom: Record ACKJSONMap)
    var
        JSONMapParent: Record ACKJSONMap;
    begin
        if not JSONMapFrom.GetParent(JSONMapParent) then
            exit;

        if JSONMapParent.Path <> '' then
            PathList.Add(JSONMapParent.Path);

        AddParentPath(PathList, JSONMapParent);
    end;

    /// <summary>
    /// GetParent.
    /// </summary>
    /// <param name="JSONMapParent">VAR Record ACKJSONMap.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetParent(var JSONMapParent: Record ACKJSONMap) Found: Boolean
    begin
        if Rec.ParentNo = '' then
            exit;

        JSONMapParent.SetRange(MessageCode, Rec.MessageCode);
        JSONMapParent.SetRange(No, Rec.ParentNo);
        Found := JSONMapParent.FindFirst();
    end;

    /// <summary>
    /// GetFirstChild.
    /// </summary>
    /// <param name="JSONMapChild">VAR Record ACKJSONMap.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetFirstChild(var JSONMapChild: Record ACKJSONMap) Found: Boolean
    begin
        JSONMapChild.SetCurrentKey(SortOrder);
        JSONMapChild.SetAscending(SortOrder, true);
        JSONMapChild.SetRange(MessageCode, Rec.MessageCode);
        JSONMapChild.SetRange(ParentNo, Rec.No);

        Found := JSONMapChild.FindFirst();
    end;

    trigger OnInsert()
    begin
        if Rec.No = '' then
            Rec.No := GetNextNo();
    end;

    local procedure TestNoSeries()
    begin
        if Rec.No <> xRec.No then begin
            SWVOGeneralSetup.Get();
            NoSeriesMgt.TestManual(SWVOGeneralSetup.JSONMapNos);
        end;
    end;

    /// <summary>
    /// GetNextCode.
    /// </summary>
    /// <returns>Return value of type Code[20].</returns>
    procedure GetNextNo(): Code[20]
    var
        JSONMap: Record ACKJSONMap;
        NewNo: Code[20];
        IsFound: Boolean;
    begin
        SWVOGeneralSetup.Get();
        SWVOGeneralSetup.TestField(JSONMapNos);
        repeat
            NewNo := NoSeriesMgt.DoGetNextNo(SWVOGeneralSetup.JSONMapNos, Today(), true, false);
            IsFound := JSONMap.Get(NewNo);
            if not IsFound then
                exit(NewNo);
        until not IsFound;
    end;

    var
        SWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        NoSeriesMgt: codeunit NoSeriesManagement;
}