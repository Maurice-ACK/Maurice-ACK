/// <summary>
/// Page ACKProductCodeAPI
/// </summary>
page 50054 ACKProductCodeAPI
{
    APIGroup = 'wmo';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    Caption = 'Product code API', Locked = true;
    DelayedInsert = true;
    EntityName = 'productCode';
    EntitySetName = 'productCodes';
    PageType = API;
    SourceTable = ACKProductCode;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(productCode; Rec.ProductCode)
                {
                }
                field(categoryId; Rec.CategoryID)
                {
                }
                field(alias; Rec.Alias)
                {
                }
                field(description; Rec.Description)
                {
                }
                field(isActive; Rec.IsActive)
                {
                }
            }
        }
    }
}
