page 50124 ACKJSONMapListpart
{
    ApplicationArea = All;
    Caption = 'JSON mapping', Locked = true;
    PageType = ListPart;
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
                    Visible = false;

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
}