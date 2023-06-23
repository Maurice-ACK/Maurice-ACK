/// <summary>
/// Table ACKWMOProductCode
/// </summary>
table 50007 ACKWMOProductCode
{
    Caption = 'Product code';
    LookupPageId = ACKWMOProductCodeList;
    DrillDownPageId = ACKWMOProductCodeList;

    DataClassification = SystemMetadata;

    fields
    {
        field(10; ProductCode; Code[5])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.ProductCode);
            end;
        }
        field(20; CategoryID; Code[2])
        {
            Caption = 'Category ID';
            TableRelation = ACKWMOProductCategory.ID;
            NotBlank = true;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                TestField(Rec.CategoryID);
            end;
        }
        field(30; Description; Text[500])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestField(Rec.Description);
            end;
        }
        field(40; IsActive; Boolean)
        {
            Caption = 'Active';
        }
        field(50; ProductCodeType; Enum ACKProductCodeType)
        {
            Caption = 'Type';
        }
    }
    keys
    {
        key(PK; ProductCode)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        ACKHelper.ValidateRecord(Rec);
    end;

    trigger OnModify()
    begin
        ACKHelper.ValidateRecord(Rec);
    end;

    var
        ACKHelper: codeunit ACKHelper;
}
