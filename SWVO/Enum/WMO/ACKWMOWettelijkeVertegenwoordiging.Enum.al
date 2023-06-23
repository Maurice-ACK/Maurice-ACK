/// <summary>
/// Enum ACKWMOWettelijkeVertegenwoordiging (ID 50015).
/// </summary>

//https://experience.dynamics.com/ideas/categories/list/?category=4e96aa66-ad39-e911-a978-000d3a4f3343&forum=e288ef32-82ed-e611-8101-5065f38b21f1
enum 50014 ACKWMOWettelijkeVertegenwoordiging
{
    Extensible = false;
    Caption = 'Wettelijke vertegenwoordiging', Locked = true;

    value(0; Empty)
    {
        Caption = 'Empty', Locked = true;
    }
    value(6; Voogdij)
    {
        Caption = 'Voogdij', Locked = true;
    }
    value(7; Bewindvoering)
    {
        Caption = 'Bewindvoering', Locked = true;
    }
    value(8; Mentorschap)
    {
        Caption = 'Mentorschap', Locked = true;
    }
    value(9; OnderCurateleStelling)
    {
        Caption = 'Onder curatele stelling', Locked = true;
    }
    value(10; Zaakwaarneming)
    {
        Caption = 'Zaakwaarneming', Locked = true;
    }

}
