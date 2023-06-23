/// <summary>
/// Enum ACKWMONaamGebruik (ID 50012).
/// </summary>
enum 50011 ACKWMONaamGebruik
{
    Extensible = false;
    Caption = 'Naam gebruik', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; EigenNaam)
    {
        Caption = 'Eigen naam', Locked = true;
    }
    value(2; AlternatieveNaam)
    {
        //Naam echtgenoot of geregistreerd partner of alternatieve naam
        Caption = 'Alternatieve naam', Locked = true;
    }
    value(3; PartnerNaamMetEigenNaam)
    {
        //Naam echtgenoot of geregistreerd partner gevolgd door eigen naam
        Caption = 'Partner naam met eigen naam', Locked = true;
    }
    value(4; EigenNaamMetPartnerNaam)
    {
        Caption = 'Eigen naam met partner naam', Locked = true;
    }
    value(5; Pseudoniem)
    {
        Caption = 'Pseudoniem', Locked = true;
    }
    value(6; NietNatuurlijk)
    {
        Caption = 'Niet natuurlijk persoon', Locked = true;
    }
}
