/// <summary>
/// Enum ACKWMORedenWijziging
/// </summary>
enum 50027 ACKWMORedenWijziging
{
    Extensible = false;
    Caption = 'Reden wijziging', Locked = true;

    value(0; Empty)
    {
        Caption = 'Empty', Locked = true;
    }
    value(02; ClientOverleden)
    {
        Caption = 'Cliënt overleden', Locked = true;
    }
    value(03; Contractwijziging)
    {
        Caption = 'Contractwijziging', Locked = true;
    }
    value(04; Verlenging)
    {
        Caption = 'Verlenging toewijzing', Locked = true;
    }
    value(05; Verkorting)
    {
        Caption = 'Verkorting toewijzing', Locked = true;
    }
    value(06; UitstroomAnderDomein)
    {
        Caption = 'Uitstroom naar ander domein', Locked = true;
    }
    value(07; VerhuizingGemeente)
    {
        Caption = 'Verhuizing naar een andere gemeente', Locked = true;
    }
    value(08; WijzigingLeveringsvorm)
    {
        Caption = 'Wijziging leveringsvorm', Locked = true;
    }
    value(09; OverstapAanbieder)
    {
        Caption = 'Overstap naar andere aanbieder', Locked = true;
    }
    value(10; NieuweBekostigingssystematiek)
    {
        Caption = 'Overgang naar nieuwe bekostigingssystematiek', Locked = true;
    }
    value(11; GemeentelijkeHerindeling)
    {
        Caption = 'Gemeentelijke herindeling', Locked = true;
    }
    value(12; GeinitieerdAanbieder)
    {
        Caption = 'Geinitieerd door de aanbieder', Locked = true;
    }
    value(13; Verwijderd)
    {
        Caption = 'Verwijderd', Locked = true;
    }
    value(14; AdministratieveCorrectie)
    {
        Caption = 'Administratieve correctie', Locked = true;
    }
}
