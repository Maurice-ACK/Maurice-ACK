/// <summary>
/// Page ACKWMOProductCodeList
/// </summary>
page 50001 ACKWMOProductCodeList
{
    ApplicationArea = All;
    Caption = 'Product code';
    PageType = List;
    SourceTable = ACKWMOProductCode;
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ProductCode; Rec.ProductCode)
                {
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ShowMandatory = true;
                }
                field(CategoryId; Rec.CategoryID)
                {
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field(ProductCodeType; Rec.ProductCodeType)
                {
                }
                field(IsActive; Rec.IsActive)
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACKProductFrequencies)
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Product frequency combinations';
                Image = Relationship;
                RunObject = Page ACKProductCodeFrequencyList;
                RunPageLink = ProductCode = field(ProductCode);
                ToolTip = 'View or set up product code - frequency combinations.';
            }
            action(ACKInvalidPCCombination)
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Invalid combinations';
                Image = ErrorLog;
                RunObject = Page ACKInvalidPCCombinationList;
                RunPageLink = ProductCode = field(ProductCode);
                ToolTip = 'View or set up the invalid product code combinations.';
            }
        }
    }
    views
    {
        view(IsActiveFilter)
        {
            Filters = where(IsActive = const(true));
            Caption = 'Actief', Locked = true;
            SharedLayout = true;
        }
        view(TypeWmoFilter)
        {
            Filters = where(ProductCodeType = const(ACKProductCodeType::Wmo));
            Caption = 'Wmo', Locked = true;
            SharedLayout = true;
        }
        view(TypeTransportFilter)
        {
            Caption = 'Vervoer', Locked = true;
            Filters = where(ProductCodeType = const(ACKProductCodeType::Transport));
            SharedLayout = true;
        }
        view(TypeResourcesFilter)
        {
            Caption = 'Hulpmiddelen', Locked = true;
            Filters = where(ProductCodeType = const(ACKProductCodeType::Resources));
            SharedLayout = true;
        }
        view(TypeShelteredHousingFilter)
        {
            Caption = 'Beschermd wonen', Locked = true;
            Filters = where(ProductCodeType = const(ACKProductCodeType::ShelteredHousing));
            SharedLayout = true;
        }
    }
}