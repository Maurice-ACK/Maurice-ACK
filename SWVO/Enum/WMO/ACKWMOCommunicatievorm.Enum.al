/// <summary>
/// Enum ACKWMOCommunicatie
/// </summary>
enum 50012 ACKWMOCommunicatievorm
{
    Extensible = false;
    Caption = 'Communicatievorm', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; Tolk)
    {
        Caption = 'Tolk taal', Locked = true;
    }
    value(2; Doventolk)
    {
        Caption = 'Doventolk', Locked = true;
    }
    value(3; Doofblindentolk)
    {
        Caption = 'Doofblindentolk', Locked = true;
    }
}
