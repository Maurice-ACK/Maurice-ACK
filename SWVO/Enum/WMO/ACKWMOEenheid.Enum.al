/// <summary>
/// Enum ACKWMOEenheid (ID 50088).
/// </summary>
enum 50043 ACKWMOEenheid
{
    Extensible = false;
    Caption = 'Eenheid', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(01; Minuut)
    {
        Caption = 'Minuut', Locked = true;
    }
    value(04; Uur)
    {
        Caption = 'Uur', Locked = true;
    }
    value(14; Etmaal)
    {
        Caption = 'Etmaal', Locked = true;
    }
    value(16; Dagdeel)
    {
        Caption = 'Dagdeel (4 uur)', Locked = true;
    }
    value(82; StuksOutput)
    {
        Caption = 'Stuks (output)', Locked = true;
    }
    value(83; Euro)
    {
        Caption = 'Euro', Locked = true;
    }
    value(84; StuksInspanning)
    {
        Caption = 'Stuks inspanning', Locked = true;
    }
}
