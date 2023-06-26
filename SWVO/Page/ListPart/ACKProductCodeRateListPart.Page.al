/// <summary>
/// Page ACKProductCodeRateListPart
/// </summary>
page 50012 ACKProductCodeRateListPart
{
    Caption = 'Product code rates';
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = ACKProductCodeRate;
    DelayedInsert = true;
    UsageCategory = None;
    MultipleNewLines = false;
    SourceTableView = sorting(ProductCode, IndicationUnitid, DeclarationUnitId);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ProductCode; Rec.ProductCode)
                {
                    LookupPageID = ACKWMOProductCodeList;

                    trigger OnAfterLookup(Selected: RecordRef)
                    var
                        ACKWMOProductCode: Record ACKWMOProductCode;
                    begin
                        Selected.SetTable(ACKWMOProductCode);

                        Rec.ProductCategoryId := ACKWMOProductCode.CategoryID;
                        Rec.ProductCodeDescription := ACKWMOProductCode.Description;
                    end;
                }
                field(ProductCategoryId; Rec.ProductCategoryId)
                {
                }
                field(ProductCodeDescription; Rec.ProductCodeDescription)
                {
                }
                field(DeclarationUnitId; Rec.DeclarationUnitId)
                {
                }
                field(IndicationUnitid; Rec.IndicationUnitid)
                {
                }
                field(IsPredefined; Rec.IsPredefined)
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field(EuroRate; RateInEuro())
                {
                    Caption = 'Rate (Euro)';
                    AutoFormatType = 2;
                    AutoFormatExpression = 'EUR';
                    Editable = false;
                }
            }
        }
    }

    local procedure RateInEuro(): Decimal
    begin
        exit(Rec.Rate / 100);
    end;
}
