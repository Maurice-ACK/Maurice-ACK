/// <summary>
/// Enum ACKWMORedenVerzoek
/// </summary>
enum 50004 ACKWMORedenVerzoek
{
    Extensible = false;
    Caption = 'Reden verzoek', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; WijzigingClientsituatie)
    {
        Caption = 'Verandering clientsituatie', Locked = true;
    }
    value(2; WijzigingZorgplan)
    {
        Caption = 'Wijziging zorgplan', Locked = true;
    }
}
