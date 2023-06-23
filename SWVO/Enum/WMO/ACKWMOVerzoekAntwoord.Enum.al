/// <summary>
/// Enum ACKWMOVerzoekAntwoord
/// </summary>
enum 50036 ACKWMOVerzoekAntwoord
{
    Extensible = false;
    Caption = 'Verzoek antwoord', Locked = true;

    value(0; Empty)
    {
        Caption = 'Empty', Locked = true;
    }
    value(1; Afgewezen)
    {
        Caption = 'Verzoek afgewezen', Locked = true;
    }
    value(2; InOnderzoek)
    {
        Caption = 'Aanvraag in onderzoek', Locked = true;
    }
}
