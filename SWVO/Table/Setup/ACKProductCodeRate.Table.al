/// <summary>
/// Table ACKProductCodeRate.
/// </summary>
table 50067 ACKProductCodeRate
{
    Caption = 'Product code rate';
    DataClassification = SystemMetadata;

    fields
    {
        field(10; ProductCodeRateMonthID; Integer)
        {
            Caption = 'Month ID', Locked = true;
            TableRelation = ACKProductCodeRateMonth.ID;
            NotBlank = true;
        }
        field(20; ProductCode; Code[5])
        {
            Caption = 'Product code';
            TableRelation = ACKProductCode.ProductCode;
            NotBlank = true;
        }
        field(40; IndicationUnitid; enum ACKWMOEenheid)
        {
            Caption = 'Indication unit';
            NotBlank = true;
        }
        field(50; DeclarationUnitId; enum ACKWMOEenheid)
        {
            Caption = 'Declaration unit';
            NotBlank = true;
        }

        field(60; Rate; Integer)
        {
            Caption = 'Rate (Eurocent)';
            MinValue = 0;

            trigger OnValidate()
            begin
                TestField(Rec.Rate);
            end;
        }

        field(70; IsPredefined; Boolean)
        {
            Caption = 'Predefined';
        }

        field(80; ProductCategoryId; Code[2])
        {
            Caption = 'Product category';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKProductCode.CategoryID where(ProductCode = field(ProductCode)));
            Editable = false;
        }
        field(90; ProductCodeDescription; Text[500])
        {
            Caption = 'Product code description';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKProductCode.Description where(ProductCode = field(ProductCode)));
            Editable = false;
        }
        field(100; ProductCodeAlias; Text[30])
        {
            Caption = 'Product code alias';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKProductCode.Alias where(ProductCode = field(ProductCode)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; ProductCodeRateMonthID, ProductCode, IndicationUnitid, DeclarationUnitId)
        {
            Clustered = true;
        }
    }
}

