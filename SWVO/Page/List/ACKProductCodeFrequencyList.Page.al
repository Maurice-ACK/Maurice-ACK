/// <summary>
/// Page ACKProductCodeFrequencyList
/// </summary>
page 50085 ACKProductCodeFrequencyList
{
    ApplicationArea = All;
    Caption = 'Product code - frequency';
    PageType = List;
    SourceTable = ACKProductCodeFrequency;
    UsageCategory = None;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    PopulateAllFields = true;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ProductCode; Rec.ProductCode)
                {
                    LookupPageId = ACKProductCodeList;
                }
                field(ProductCodeAlias; Rec.ProductCodeAlias)
                {
                    Caption = 'Afkorting', Locked = true;
                }
                field(ProductFrequency; Rec.ProductFrequency)
                {
                }
            }
        }
    }
}
