/// <summary>
/// Page ACKInvalidPCCombinationList (ID 50075).
/// </summary>
page 50075 ACKInvalidPCCombinationList
{
    ApplicationArea = All;
    Caption = 'Invalid product code combinations';
    PageType = List;
    SourceTable = ACKInvalidPCCombination;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(ProductCodeInvalid; Rec.ProductCodeInvalid)
                {
                }
            }
        }
    }
}
