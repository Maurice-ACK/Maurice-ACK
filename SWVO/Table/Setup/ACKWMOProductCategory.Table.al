/// <summary>
/// Table ACKWMOProductCategory
/// </summary>
table 50008 ACKWMOProductCategory
{
    Caption = 'Product category';
    LookupPageId = ACKWMOProductCategoryList;
    DrillDownPageId = ACKWMOProductCategoryList;

    DataClassification = CustomerContent;

    fields
    {
        field(10; ID; Code[2])
        {
            Caption = 'Category';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.ID);
            end;
        }
        field(20; Description; Text[80])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TestField(Rec.Description);
            end;
        }
    }
    keys
    {
        key(PK; ID)
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
