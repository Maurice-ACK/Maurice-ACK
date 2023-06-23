/// <summary>
/// Page ACKToegewezenProductListPart
/// </summary>
page 50017 ACKToegewezenProductListPart
{
    Caption = 'Assigned products';
    PageType = ListPart;
    SourceTable = ACKWMOToegewezenProduct;
    CardPageId = ACKWMOToegewezenProductCard;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DataCaptionFields = ToewijzingNummer, ProductCode;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ToewijzingNummer; Rec.ToewijzingNummer)
                {
                    ApplicationArea = All;
                }
                field(Ingangsdatum; Rec.Ingangsdatum)
                {
                    ApplicationArea = All;
                }
                field(Einddatum; Rec.Einddatum)
                {
                    ApplicationArea = All;
                }
                field(ProductCode; Rec.ProductCode)
                {
                    ApplicationArea = All;
                }
                field(Eenheid; Rec.Eenheid)
                {
                    ApplicationArea = All;
                }
                field(Frequentie; Rec.Frequentie)
                {
                    ApplicationArea = All;
                }
                field(Volume; Rec.Volume)
                {
                    ApplicationArea = All;
                }
                field(Commentaar; Rec.Commentaar)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ACKWMOIndiciation)
            {
                ApplicationArea = All;
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
