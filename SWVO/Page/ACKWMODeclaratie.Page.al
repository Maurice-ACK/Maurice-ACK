/// <summary>
/// Page WMODeclaratie (ID 50059).
/// </summary>
page 50059 WMODeclaratie
{
    ApplicationArea = All;
    Caption = 'Wmo Declaratie', Locked = true;
    PageType = Card;
    SourceTable = ACKWMODeclaratie;

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }
}
