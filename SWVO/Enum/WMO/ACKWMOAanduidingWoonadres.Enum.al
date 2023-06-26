/// <summary>
/// Enum ACKWMOAanduidingWoonadres
/// </summary>
enum 50042 ACKWMOAanduidingWoonadres
{
    Extensible = false;
    Caption = 'Aanduiding woonadres', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    //Value must be equal to enumeration from iStandaarden
    value(1; "AB")
    {
        Caption = 'Aan boord', Locked = true;
    }
    //Value must be equal to enumeration from iStandaarden
    value(2; "BY")
    {
        Caption = 'Bij', Locked = true;
    }
    //Value must be equal to enumeration from iStandaarden
    value(3; "TO")
    {
        Caption = 'Tegenover', Locked = true;
    }
    //Value must be equal to enumeration from iStandaarden
    value(4; "WW")
    {
        Caption = 'Woonwagen', Locked = true;
    }
}
