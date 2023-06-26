/// <summary>
/// Page ACKWMOStartStopProductListPart
/// </summary>
page 50027 ACKWMOStartStopProductListPart
{
    Caption = 'Start/Stop products';
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = ACKWMOStartStopProduct;
    CardPageId = ACKWMOStartStopProductCard;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ToewijzingNummer; Rec.ToewijzingNummer)
                {
                }
                field(ProductCategorie; Rec.ProductCategorie)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(ToewijzingIngangsdatum; Rec.ToewijzingIngangsdatum)
                {
                }
                field(Begindatum; Rec.Begindatum)
                {
                }
                field(Einddatum; Rec.Einddatum)
                {
                    ApplicationArea = All;
                }
                field(StatusAanlevering; Rec.StatusAanlevering)
                {
                    ApplicationArea = All;
                }
                field(RedenBeeindiging; Rec.RedenBeeindiging)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
