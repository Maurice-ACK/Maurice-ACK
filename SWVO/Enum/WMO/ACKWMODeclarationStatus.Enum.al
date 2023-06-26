/// <summary>
/// Enum ACKWMODeclarationStatus
/// </summary>
enum 50033 ACKWMODeclarationStatus
{
    value(0; New)
    {
        Caption = 'Nieuw', Locked = true;
    }
    value(1; Canceled)
    {
        Caption = 'Canceled', Locked = true;
    }
    value(2; Posted)
    {
        Caption = 'Geboekt', Locked = true;
    }
    value(3; Paid)
    {
        Caption = 'Betaald', Locked = true;
    }
}
