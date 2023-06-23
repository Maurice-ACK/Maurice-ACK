/// <summary>
/// Page ACKWMOToegewezenProductCard (ID 50018).
/// </summary>
page 50018 ACKWMOToegewezenProductCard
{
    ApplicationArea = All;
    Caption = 'Toegewezenproduct', Locked = true;
    PageType = Card;
    SourceTable = ACKWMOToegewezenProduct;
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(Assignment)
            {
                Caption = 'Assignment';

                field(ToewijzingNummer; Rec.ToewijzingNummer)
                {
                }
                field(Ingangsdatum; Rec.Ingangsdatum)
                {
                }
                field(Einddatum; Rec.Einddatum)
                {
                }
                field(Toewijzingsdatum; Rec.Toewijzingsdatum)
                {
                }
                field(Toewijzingstijd; Rec.Toewijzingstijd)
                {
                }
            }
            group(Product)
            {
                Caption = 'Product', locked = true;

                field(ProductCategorie; Rec.ProductCategorie)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(Eenheid; Rec.Eenheid)
                {
                }
                field(Frequentie; Rec.Frequentie)
                {
                }
                field(Volume; Rec.Volume)
                {
                }
                field(Budget; Rec.Budget)
                {
                }
            }

            field(ReferentieAanbieder; Rec.ReferentieAanbieder)
            {
            }
            field(RedenWijziging; Rec.RedenWijziging)
            {
            }
            field(Commentaar; Rec.Commentaar)
            {
            }
        }
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                SubPageLink = RelationTableNo = const(Database::ACKWMOToegewezenProduct), RefID = field(SystemId);
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ACKWMOIndiciation)
            {
                Caption = 'Indication';
                Image = Relationship;
                Enabled = IndicationExists;

                trigger OnAction()
                var
                    WMOIndicationCard: Page ACKWMOIndicationCard;
                begin
                    WMOIndicationCard.SetRecord(WMOIndication);
                    WMOIndicationCard.Run();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ToegewezenProductIndicationQ: Query ACKToegewezenProdIndicationQ;
    begin
        IndicationExists := false;

        ToegewezenProductIndicationQ.SetRange(ToegewezenProductIndicationQ.ToegewezenProductSystemId, Rec.SystemId);

        if ToegewezenProductIndicationQ.Open() and ToegewezenProductIndicationQ.Read() then begin
            if WMOIndication.GetBySystemId(ToegewezenProductIndicationQ.IndicationSystemId) then
                IndicationExists := true;
            ToegewezenProductIndicationQ.Close();
        end;
    end;

    var
        WMOIndication: Record ACKWMOIndication;
        IndicationExists: Boolean;
}
