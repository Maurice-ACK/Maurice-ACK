/// <summary>
/// Enum ACKWMORedenAfwijzingVerzoek
/// </summary>
enum 50037 ACKWMORedenAfwijzingVerzoek
{
    Extensible = false;
    Caption = 'Reden afwijzing verzoek', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; NieuweAanvraag)
    {
        Caption = 'Geen wijziging maar nieuwe aanvraag', Locked = true;
    }
    value(2; InOnderzoek)
    {
        Caption = 'Aanvraag in onderzoek', Locked = true;
    }
    value(3; GeenContract)
    {
        Caption = 'Geen contract', Locked = true;
    }
    value(4; PastNietBinnenContract)
    {
        Caption = 'Past niet binnen contract', Locked = true;
    }
    value(5; AndereGemeente)
    {
        Caption = 'Andere gemeente', Locked = true;
    }
    value(6; Stapeling)
    {
        Caption = 'Stapeling', Locked = true;
    }
    value(7; ZorginhoudelijkeAfkeur)
    {
        Caption = 'Zorginhoudelijke afkeur', Locked = true;
    }
    value(8; Woonplaatsbeginsel)
    {
        Caption = 'Woonplaatsbeginsel', Locked = true;
    }
    value(9; LeeftijdsgrensIsBereikt)
    {
        Caption = 'Leeftijdsgrens is bereikt', Locked = true;
    }
}
