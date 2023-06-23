/// <summary>
/// Page ACKWMOAntwoordCardPart (ID 50148).
/// </summary>
page 50117 ACKWMOAntwoordCardPart
{
    ApplicationArea = All;
    Caption = 'Antwoord', Locked = true;
    PageType = CardPart;
    CardPageId = ACKWMOMessagePageDoc;
    SourceTable = ACKWMOAntwoord;
    Editable = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;
                field(ReferentieAanbieder; Rec.ReferentieAanbieder)
                {
                }
                field(VerzoekAntwoord; Rec.VerzoekAntwoord)
                {
                }
                field(RedenAfwijzingVerzoek; Rec.RedenAfwijzingVerzoek)
                {
                }
            }
        }
    }
}
