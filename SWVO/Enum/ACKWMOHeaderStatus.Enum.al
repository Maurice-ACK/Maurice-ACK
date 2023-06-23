/// <summary>
/// Enum ACKWMOHeaderStatus (ID 50025).
/// </summary>
enum 50035 ACKWMOHeaderStatus
{
    Extensible = false;
    Caption = 'Header status';

    value(0; NVT)
    {
        Caption = 'N.V.T.';
    }
    value(1; New)
    {
        Caption = 'New';
    }
    value(2; Valid)
    {
        Caption = 'Valid';
    }
    value(3; Invalid)
    {
        Caption = 'Invalid';
    }
    value(4; InvalidRetourCreated)
    {
        Caption = 'Invalid / Returned';
    }
    value(5; Send)
    {
        Caption = 'Valid / Send';
    }
}
