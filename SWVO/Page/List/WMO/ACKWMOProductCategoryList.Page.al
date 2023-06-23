/// <summary>
/// Page ACKWMOProductCategoryList.
/// </summary>
page 50002 ACKWMOProductCategoryList
{
    ApplicationArea = All;
    Caption = 'Product category';
    PageType = List;
    SourceTable = ACKWMOProductCategory;
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.ID)
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GLAccounts)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Caption = 'G/L Accounts';
                Image = GL;
                RunObject = Page ACKProductCategoryGLAccountL;
                RunPageLink = CategoryID = field(ID);
                ToolTip = 'View or set up the G/L Accounts by product category.';
            }
        }
    }
}