/// <summary>
/// Page ACKProductCategoryAPI
/// </summary>
page 50046 ACKProductCategoryAPI
{
    APIGroup = 'wmo';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    Caption = 'Product category API', Locked = true;
    DelayedInsert = true;
    EntityName = 'productCategory';
    EntitySetName = 'productCategories';
    PageType = API;
    SourceTable = ACKProductCategory;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.ID)
                {

                }
                field(description; Rec.Description)
                {

                }
            }
        }
    }
}
