/// <summary>
/// Enum ACKWMORedenBeeindiging
/// </summary>
enum 50003 ACKWMORedenBeeindiging
{
    Extensible = false;
    Caption = 'Reden beëindiging', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(2; Overlijden)
    {
        Caption = 'Overlijden', Locked = true;
    }
    value(19; VolgensPlanBeeindigd)
    {
        Caption = 'Levering volgens plan beëindigd', Locked = true;
    }
    value(20; TijdelijkBeeindigd)
    {
        Caption = 'Levering is tijdelijk beëindigd', Locked = true;
    }
    value(21; EenzijdigClientBeeindigd)
    {
        Caption = 'Levering is eenzijdig door client beëindigd', Locked = true;
    }
    value(22; EenzijdigAanbiederBeeindigd)
    {
        Caption = 'Levering is eenzijdig door aanbieder beëindigd', Locked = true;
    }

    value(23; OvereenstemmingBeeindigd)
    {
        Caption = 'Levering is in overeenstemming voortijdig beëindigd', Locked = true;
    }
    value(31; VerhuizingGemeente)
    {
        Caption = 'Verhuizing naar een andere gemeente', Locked = true;
    }
    value(36; GeinitieerdGemeente)
    {
        Caption = 'Geinitieerd door de gemeente', Locked = true;
    }
    value(37; Wijzigingsverzoek)
    {
        Caption = 'In verband met wijzigingsverzoek', Locked = true;
    }
    value(38; OverstapAanbieder)
    {
        Caption = 'Overstap naar andere aanbieder', Locked = true;
    }
    value(39; UitstroomAnderDomein)
    {
        Caption = 'Uitstroom naar ander domein', Locked = true;
    }
}
