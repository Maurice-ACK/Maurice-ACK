/// <summary>
/// Page ACKWMOPrestatieCard
/// </summary>
page 50043 ACKWMOPrestatieCard
{
    ApplicationArea = All;
    Caption = 'Prestatie';
    PageType = Card;
    SourceTable = ACKWMOClient;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ReferentieNummer; Rec.Achternaam)
                {
                    ApplicationArea = All;
                }
                // field(ReferentieNummer; Rec.ReferentieNummer)
                // {
                //     ApplicationArea = All;
                // }
                // field(VorigReferentieNummer; Rec.VorigReferentieNummer)
                // {
                //     ApplicationArea = All;
                // }
                // field(ToewijzingNummer; Rec.ToewijzingNummer)
                // {
                //     ApplicationArea = All;
                // }
                // field(ProductCategorie; Rec.ProductCategorie)
                // {
                //     ApplicationArea = All;
                // }
                // field(ProductCode; Rec.ProductCode)
                // {
                //     ApplicationArea = All;
                // }
                // field(Begindatum; Rec.Begindatum)
                // {
                //     ApplicationArea = All;
                // }
                // field(Einddatum; Rec.Einddatum)
                // {
                //     ApplicationArea = All;
                // }
                // field(GeleverdVolume; Rec.GeleverdVolume)
                // {
                //     ApplicationArea = All;
                // }
                // field(Eenheid; Rec.Eenheid)
                // {
                //     ApplicationArea = All;
                // }
                // field(ProductTarief; Rec.ProductTarief)
                // {
                //     ApplicationArea = All;
                // }
                // field(Bedrag; Rec.Bedrag)
                // {
                //     ApplicationArea = All;
                // }
                // field(DebetCredit; Rec.DebetCredit)
                // {
                //     ApplicationArea = All;
                // }
            }
        }
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                SubPageLink = RelationTableNo = const(Database::ACKWMOPrestatie), RefID = field(SystemId);
            }
        }
    }
}
