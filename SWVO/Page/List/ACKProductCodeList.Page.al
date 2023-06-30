/// <summary>
/// Page ACKProductCodeList
/// </summary>
page 50001 ACKProductCodeList
{
    ApplicationArea = All;
    Caption = 'Product code';
    PageType = List;
    SourceTable = ACKProductCode;
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
        area(Promoted)
        {
            actionref(ACKProductFrequenciesPromoted; ACKProductFrequencies)
            {
            }
            actionref(ACKInvalidPCCombinationPromoted; ACKInvalidPCCombination)
            {
            }
        }

        area(Processing)
        {
            action(ACKProductFrequencies)
            {
                Caption = 'Product frequency combinations';
                Image = Relationship;
                RunObject = Page ACKProductCodeFrequencyList;
                RunPageLink = ProductCode = field(ProductCode);
                ToolTip = 'View or set up product code - frequency combinations.';
            }
            action(ACKInvalidPCCombination)
            {
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