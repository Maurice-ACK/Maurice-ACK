/// <summary>
/// Page ACKWMOStartStopProductCard
/// </summary>
page 50028 ACKWMOStartStopProductCard
{
    ApplicationArea = All;
    Caption = 'Start/Stop product', Locked = true;
    PageType = Card;
    SourceTable = ACKWMOStartStopProduct;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
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
                }
                field(StatusAanlevering; Rec.StatusAanlevering)
                {
                }
                field(RedenBeeindiging; Rec.RedenBeeindiging)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                SubPageLink = RelationTableNo = const(Database::ACKWMOStartStopProduct), RefID = field(SystemId);
            }
        }
    }
}
