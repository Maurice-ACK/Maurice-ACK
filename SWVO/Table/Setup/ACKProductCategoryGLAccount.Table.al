/// <summary>
/// Table ACKProductCategoryGLAccount (ID 50041).
/// </summary>
table 50041 ACKProductCategoryGLAccount
{
    Caption = 'Product category - G/L Account';
    DataClassification = OrganizationIdentifiableInformation;
    DrillDownPageId = ACKProductCategoryGLAccountL;
    LookupPageId = ACKProductCategoryGLAccountL;

    fields
    {
        field(10; CategoryID; Code[2])
        {
            Caption = 'Category';
            TableRelation = ACKWMOProductCategory.ID;
            DataClassification = SystemMetadata;
            NotBlank = true;
            ValidateTableRelation = true;

            trigger OnValidate()
            begin
                TestField(Rec.CategoryID);
            end;
        }
        field(20; GLAccountNo; Code[20])
        {
            Caption = 'G/L Account No.';
            NotBlank = true;
            TableRelation = "G/L Account"."No.";
            DataClassification = OrganizationIdentifiableInformation;

            trigger OnValidate()
            begin
                TestField(Rec.GLAccountNo);
            end;
        }
        field(30; ValidFrom; Date)
        {
            Caption = 'Valid from';
            DataClassification = SystemMetadata;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.ValidFrom);
                if (Rec.ValidFrom > Rec.ValidTo) and (ValidTo <> 0D) then
                    Error(StartDateAfterEndDateErr, FieldCaption(ValidFrom), FieldCaption(ValidTo));
            end;
        }
        field(40; ValidTo; Date)
        {
            Caption = 'Valid to';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                Rec.Validate(Rec.ValidFrom);
            end;
        }
    }
    keys
    {
        key(PK; CategoryID, ValidFrom)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        ACKHelper.ValidateRecord(Rec);
        CheckOverlap();
    end;

    trigger OnModify()
    begin
        ACKHelper.ValidateRecord(Rec);
        CheckOverlap();
    end;

    local procedure CheckOverlap()
    var
        ProductCategoryGLAccountOverlap: Record ACKProductCategoryGLAccount;
    begin
        ProductCategoryGLAccountOverlap.SetFilter(SystemId, '<>%1', Rec.SystemId);
        ProductCategoryGLAccountOverlap.SetRange(CategoryID, Rec.CategoryID);

        if Rec.ValidTo <> 0D then
            ProductCategoryGLAccountOverlap.SetFilter(ValidFrom, '<=%1', Rec.ValidTo);
        ProductCategoryGLAccountOverlap.SetFilter(ValidTo, '>=%1|=%2', Rec.ValidFrom, 0D);

        if ProductCategoryGLAccountOverlap.FindFirst() then
            Error(OverlapErr);
    end;

    var
        ACKHelper: Codeunit ACKHelper;
        StartDateAfterEndDateErr: Label '%1 cannot be after %2', Comment = '%1 = From date; %2 = To Date', MaxLength = 50;
        OverlapErr: Label 'Records cannot overlap.', MaxLength = 50;
}
