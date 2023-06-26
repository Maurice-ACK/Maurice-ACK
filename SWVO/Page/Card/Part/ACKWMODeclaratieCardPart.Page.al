/// <summary>
/// Page ACKWMODeclaratieCardPart
/// </summary>
page 50035 ACKWMODeclaratieCardPart
{
    ApplicationArea = All;
    Caption = 'Declaration';
    PageType = CardPart;
    SourceTable = ACKWMODeclaratie;
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
                ShowCaption = false;

                field(DeclaratieNummer; Rec.DeclaratieNummer)
                {
                }
                field(Begindatum; Rec.Begindatum)
                {
                }
                field(Einddatum; Rec.Einddatum)
                {
                }
                field(DeclaratieDagtekening; Rec.DeclaratieDagtekening)
                {
                }
                field(TotaalBedrag; Rec.TotaalBedrag)
                {
                }
                field(DebetCredit; Rec.DebetCredit)
                {
                }
            }
        }
    }
}
