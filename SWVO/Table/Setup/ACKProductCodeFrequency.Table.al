/// <summary>
/// Table ACKProductCodeFrequency (ID 50033).
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
            TableRelation = ACKWMOProductCode.ProductCode;
        }
        field(20; ProductFrequency; enum ACKWMOFrequentie)
        {
            Caption = 'Frequentie', Locked = true;
            NotBlank = true;
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
