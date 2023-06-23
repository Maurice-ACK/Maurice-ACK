/// <summary>
/// Page ACKProductCategoryGLAccountL (ID 50084).
/// </summary>
page 50084 ACKProductCategoryGLAccountL
{
    ApplicationArea = All;
    Caption = 'Product category - G/L Accounts';
    PageType = List;
    SourceTable = ACKProductCategoryGLAccount;
    UsageCategory = Lists;
    DelayedInsert = true;
    PopulateAllFields = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(GLAccountNo; Rec.GLAccountNo)
                {
                    ShowMandatory = true;
                }
                field(ValidFrom; Rec.ValidFrom)
                {
                    ShowMandatory = true;
                }
                field(ValidTo; Rec.ValidTo)
                {
                    ShowMandatory = false;
                }
            }
        }
    }
}
