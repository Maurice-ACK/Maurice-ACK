/// <summary>
/// Enum ACKWMOFrequentie (ID 50043).
/// </summary>
enum 50039 ACKWMOFrequentie
{
    Extensible = false;
    Caption = 'Frequentie', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; Dag)
    {
        Caption = 'Per dag', Locked = true;
    }
    value(2; Week)
    {
        Caption = 'Per Week', Locked = true;
    }
    value(4; Maand)
    {
        Caption = 'Per maand', Locked = true;
    }
    value(6; TotaalInToewijzing)
    {
        Caption = 'Totaal binnen geldigheidsduur toewijzing', Locked = true;
    }
}
