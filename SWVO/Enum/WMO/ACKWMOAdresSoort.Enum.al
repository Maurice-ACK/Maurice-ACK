/// <summary>
/// Enum ACKWMOAdresSoort (ID 50048).
/// </summary>
enum 50040 ACKWMOAdresSoort
{
    Extensible = false;
    Caption = 'Adres soort', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; BRP)
    {
        Caption = 'BRP-adres', Locked = true;
    }
    value(2; Correspondentie)
    {
        Caption = 'Correspondentie-adres', Locked = true;
    }
    value(3; Verblijf)
    {
        Caption = 'Verblijfadres', Locked = true;
    }
    value(4; TijdelijkVerblijf)
    {
        Caption = 'Tijdelijk verblijfadres', Locked = true;
    }
    value(5; Mybility)
    {
        Caption = 'Mybility', Locked = true;
    }
}
