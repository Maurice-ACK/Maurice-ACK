/// <summary>
/// Page ACKJSONMapList (No 50103).
/// Page ACKJSONMapList (No 50103).
/// </summary>
page 50102 ACKJSONMapList
{
    ApplicationArea = All;
    Caption = 'JSON mapping', Locked = true;
    PageType = List;
    SourceTable = ACKJSONMap;
    UsageCategory = None;
    Editable = true;
    PopulateAllFields = true;
    SourceTableView = sorting(MessageCode, ParentNo, SortOrder) order(ascending);
    ODataKeyFields = MessageCode, No, ParentNo, Path, JSONType, TableNo, FieldNo, SortOrder, Required;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(MessageCode; Rec.MessageCode)
                {
                    //Used for Excel
                    Visible = false;
                }
                field(No; Rec.No)
                {
                    //Used for Excel
                    Visible = false;
                }
                field(ParentNo; Rec.ParentNo)
                {
                    //Used for Excel
                    Visible = false;
                }
                field(Path; Rec.Path)
                {
                    // ShowMandatory = false;
                    // ShowMandatory = false;
                }
                field(JSONType; Rec.JSONType)
                {
                }
                field(TableNo; Rec.TableNo)
                {
                }
                field(FieldNo; Rec.FieldNo)
                {
                    Enabled = Rec.TableNo <> 0;
                }
                field(SortOrder; Rec.SortOrder)
                {
                }
                field(Required; Rec.Required)
                {
                }
                field(SkipEmptyOrDefault; Rec.SkipEmptyOrDefault)
                {
                }
                field(TableCaption; Rec.TableCaption)
                {
                }
                field(FieldCaption; Rec.FieldCaption)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref("Child mapping Promoted"; "Child mapping")
            {
            }
        }
        area(Navigation)
        {
            action("Child mapping")
            {
                Caption = 'Child mapping', Locked = true;
                Image = Relationship;
                Enabled = Rec.JSONType <> ACKJSONType::"Value";

                trigger OnAction()
                var
                    JSONMap: Record ACKJSONMap;
                    JSONMapList: Page ACKJSONMapList;
                begin
                    Clear(JSONMap);
                    JSONMap.SetRange(MessageCode, Rec.MessageCode);
                    JSONMap.SetRange(ParentNo, Rec.No);
                    JSONMapList.SetTableView(JSONMap);
                    JSONMapList.SetRecord(JSONMap);
                    JSONMapList.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetCaption();
    end;

    local procedure SetCaption()
    var
        JSONMapParent: Record ACKJSONMap;
        ParentIDFilter: Text;
        CaptionFormatLbl: Label '%1 - %2', Comment = '%1 = Message code, %2 = Parent path', Locked = true;
    begin
        if Rec.MessageCode <> '' then
            CurrPage.Caption(Rec.MessageCode);

        ParentIDFilter := Rec.GetFilter(ParentNo);
        if ParentIDFilter <> '' then begin
            ParentIDFilter := Rec.GetFilter(ParentNo);
            if ParentIDFilter <> '' then begin
                JSONMapParent.SetRange(MessageCode, Rec.GetFilter(MessageCode));
                JSONMapParent.SetRange(No, ParentIDFilter);
                JSONMapParent.SetRange(No, ParentIDFilter);
                if JSONMapParent.FindFirst() then
                    CurrPage.Caption(StrSubstNo(CaptionFormatLbl, JSONMapParent.MessageCode, JSONMapParent.GetFullPath()));
            end;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetSortOrder();
        SetTableIdFromParent();
    end;

    local procedure SetSortOrder()
    var
        SameLevelJSONMap: Record ACKJSONMap;
    begin
        if Rec.SortOrder <> 0 then
            exit;

        SameLevelJSONMap.SetRange(MessageCode, rec.MessageCode);
        SameLevelJSONMap.SetRange(ParentNo, Rec.ParentNo);
        SameLevelJSONMap.SetRange(ParentNo, Rec.ParentNo);

        if SameLevelJSONMap.FindLast() then
            Rec.SortOrder := SameLevelJSONMap.SortOrder + 1;
    end;

    local procedure SetTableIdFromParent()
    var
        ParentJSONMap: Record ACKJSONMap;
    begin
        if (Rec.ParentNo = '') or (Rec.TableNo <> 0) then
            if (Rec.ParentNo = '') or (Rec.TableNo <> 0) then
                exit;

        ParentJSONMap.SetRange(MessageCode, rec.MessageCode);
        ParentJSONMap.SetRange(No, rec.ParentNo);
        ParentJSONMap.SetRange(No, rec.ParentNo);

        if ParentJSONMap.FindLast() then
            Rec.TableNo := ParentJSONMap.TableNo;
    end;
}