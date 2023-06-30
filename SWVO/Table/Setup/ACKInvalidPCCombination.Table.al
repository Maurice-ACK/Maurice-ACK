/// <summary>
/// Table ACKInvalidPCCombination
/// </summary>
table 50037 ACKInvalidPCCombination
{
    Caption = 'Invalid product code combinations';
    DrillDownPageId = ACKInvalidPCCombinationList;
    LookupPageId = ACKInvalidPCCombinationList;

    DataClassification = CustomerContent;

    fields
    {
        field(10; ProductCode; Code[5])
        {
            Caption = 'Product code';
            NotBlank = true;
            TableRelation = ACKProductCode.ProductCode;

            trigger OnValidate()
            begin
                TestField(Rec.ProductCode);
            end;
        }
        field(20; ProductCodeInvalid; Code[5])
        {
            Caption = 'Product code invalid';
            NotBlank = true;
            TableRelation = ACKProductCode.ProductCode;

            trigger OnValidate()
            begin
                TestField(Rec.ProductCodeInvalid);
            end;
        }
    }
    keys
    {
        key(PK; ProductCode, ProductCodeInvalid)
        {
            Clustered = true;
        }

    }
}
