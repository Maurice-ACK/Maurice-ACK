/// <summary>
/// Page ACKNewChangedUnchangedProductC
/// </summary>
page 50031 ACKNewChangedUnchangedProductC
{
    ApplicationArea = All;
    Caption = 'Nieuw/Gewijzigd/Ongewijzigd product', Locked = true;
    PageType = Card;
    SourceTable = ACKNewChangedUnchangedProduct;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(Request)
            {
                Caption = 'Request';

                field(NewChangedUnchangedProductType; Rec.NewChangedUnchangedProductType)
                {
                }
                field(RedenVerzoek; Rec.RedenVerzoek)
                {
                }
                field(ReferentieAanbieder; Rec.ReferentieAanbieder)
                {
                }
            }
            group(ProductAssignedId)
            {
                Caption = 'Assignment';
                Visible = IsProductAssignedVisible;

                field(ToewijzingNummer; Rec.ToewijzingNummer)
                {
                }
            }
            group(Product)
            {
                Caption = 'Product', locked = true;
                Visible = IsProductVisible;

                field(ProductCode; Rec.ProductCode)
                {
                }
                field(ProductCategorie; Rec.ProductCategorie)
                {
                }
            }
            group(Details)
            {
                Caption = 'Details';
                Visible = IsDateVolumeBudgetVisible;

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
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                ApplicationArea = All;
                SubPageLink = RelationTableNo = const(Database::ACKNewChangedUnchangedProduct), RefID = field(SystemId);
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
