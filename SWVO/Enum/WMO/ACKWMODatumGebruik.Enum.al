/// <summary>
/// Enum ACKWMODatumGebruik
/// Codering om aan te geven welk deel van een datum onbekend is. 
/// </summary>
enum 50016 ACKWMODatumGebruik
{
    Extensible = false;
    Caption = 'Datum gebruik', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; MaandJaar)
    {
        //dag onbekend; alleen maand en jaar gebruiken
        Caption = 'Maand en jaar', Locked = true;
    }
    value(2; Jaar)
    {
        //dag en maand onbekend; alleen jaar gebruiken
        Caption = 'Jaar', Locked = true;
    }
    value(3; Onbekend)
    {
        //dag, maand en jaar onbekend; onbekende datum 
        Caption = 'Onbekend', Locked = true;
    }
}
