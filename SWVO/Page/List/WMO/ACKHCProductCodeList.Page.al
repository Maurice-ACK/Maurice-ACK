/// <summary>
/// Page ACKHCProductCodeList (ID 50030).
/// </summary>
page 50030 ACKHCProductCodeList
{
    Caption = 'Product codes';
    PageType = List;
    SourceTable = ACKHCProductCode;
    UsageCategory = None;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ProductCode; Rec.ProductCode)
                {
                    LookupPageId = ACKWMOProductCodeList;
                }
                field(ProductCodeDescription; Rec.ProductCodeDescription)
                {
                    Editable = false;
                }
                field(ProductCategoryId; Rec.ProductCategoryId)
                {
                    Enabled = false;
                    Editable = false;
                }
            }
        }
    }
}
