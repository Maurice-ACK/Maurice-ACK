/// <summary>
/// Page ACKNewChangedUnchangedProductL
/// </summary>
page 50050 ACKNewChangedUnchangedProductL
{
    Caption = 'New/Changed/Unchanged products';
    ApplicationArea = All;
    PageType = ListPart;
    SourceTable = ACKNewChangedUnchangedProduct;
    CardPageId = ACKNewChangedUnchangedProductC;
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
                field(NewChangedUnchangedProductType; Rec.NewChangedUnchangedProductType)
                {
                }
                field(RedenVerzoek; Rec.RedenVerzoek)
                {
                }
                field(ReferentieAanbieder; Rec.ReferentieAanbieder)
                {
                }
                field(ToewijzingNummer; Rec.ToewijzingNummer)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(ProductCategorie; Rec.ProductCategorie)
                {
                }
                field(GewensteIngangsdatum; Rec.GewensteIngangsdatum)
                {
                }
                field(Einddatum; Rec.Einddatum)
                {
                }
                field(Volume; Rec.Volume)
                {
                }
                field(Eenheid; Rec.Eenheid)
                {
                }
                field(Frequentie; Rec.Frequentie)
                {
                }
                field(Budget; Rec.Budget)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        case Rec.NewChangedUnchangedProductType of
            ACKNewChangedUnchangedProductType::New:
                begin
                    IsProductAssignedVisible := false;
                    IsProductVisible := true;
                    IsDateVolumeBudgetVisible := true;
                end;
            ACKNewChangedUnchangedProductType::Changed:
                begin
                    IsProductAssignedVisible := true;
                    IsProductVisible := false;
                    IsDateVolumeBudgetVisible := true;
                end;
            ACKNewChangedUnchangedProductType::Unchanged:
                begin
                    IsProductAssignedVisible := true;
                    IsProductVisible := false;
                    IsDateVolumeBudgetVisible := false;
                end;
        end;
    end;

    var
        IsProductVisible,
        IsProductAssignedVisible,
        IsDateVolumeBudgetVisible : Boolean;
}
