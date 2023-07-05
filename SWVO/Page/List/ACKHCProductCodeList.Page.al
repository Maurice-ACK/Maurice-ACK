/// <summary>
/// Page ACKHCProductCodeList
/// </summary>
page 50030 ACKHCProductCodeList
{
    Caption = 'Healthcare provider - Product codes';
    PageType = List;
    SourceTable = ACKHCProductCode;
    UsageCategory = Lists;
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
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                    LookupPageId = ACKProductCodeList;
                }
                field(ProductCodeAlias; Rec.ProductCodeAlias)
                {
                    Caption = 'Afkorting', Locked = true;
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
