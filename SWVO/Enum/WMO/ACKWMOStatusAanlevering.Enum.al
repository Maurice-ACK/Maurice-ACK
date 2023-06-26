/// <summary>
/// Enum ACKWMOStatusAanlevering
/// </summary>
enum 50002 ACKWMOStatusAanlevering
{
    Extensible = false;
    Caption = 'Status aanlevering', Locked = true;

    value(0; Empty)
    {
        Caption = 'Empty', Locked = true;
    }
    value(1; First)
    {
        Caption = 'Eerste aanlevering', Locked = true;
    }
    value(2; Changed)
    {
        Caption = 'Gewijzigde aanlevering', Locked = true;
    }
    value(3; Deleted)
    {
        Caption = 'Verwijderen aanlevering', Locked = true;
    }
    value(9; Unchanged)
    {
        Caption = 'Niet van toepassing (ongewijzigd)';
    }
}
