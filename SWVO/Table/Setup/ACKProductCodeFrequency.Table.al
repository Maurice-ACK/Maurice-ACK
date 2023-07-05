/// <summary>
/// Table ACKProductCodeFrequency
/// </summary>
table 50033 ACKProductCodeFrequency
{
    Caption = 'Productcode - frequentie', Locked = true;
    DataClassification = SystemMetadata;
    DrillDownPageId = ACKProductCodeFrequencyList;
    LookupPageId = ACKProductCodeFrequencyList;

    fields
    {
        field(10; ProductCode; Code[5])
        {
            Caption = 'Product code';
            NotBlank = true;
            TableRelation = ACKProductCode.ProductCode;
        }
        field(20; ProductFrequency; enum ACKWMOFrequentie)
        {
            Caption = 'Frequentie', Locked = true;
            NotBlank = true;
        }
        field(30; ProductCodeAlias; Text[30])
        {
            Caption = 'Product code alias';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKProductCode.Alias where(ProductCode = field(ProductCode)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; ProductCode, ProductFrequency)
        {
            Clustered = true;
        }
    }
}
