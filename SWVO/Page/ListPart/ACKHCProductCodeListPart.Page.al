/// <summary>
/// Page ACKHCProductCodeListPart
/// </summary>
page 50060 ACKHCProductCodeListPart
{
    ApplicationArea = All;
    Caption = 'Product codes';
    PageType = ListPart;
    SourceTable = ACKHCProductCode;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(ProductCodeDescription; Rec.ProductCodeDescription)
                {
                }
                field(ProductCategoryId; Rec.ProductCategoryId)
                {
                }
                field(ProductCodeType; Rec.ProductCodeType)
                {
                }
            }
        }
    }
}
