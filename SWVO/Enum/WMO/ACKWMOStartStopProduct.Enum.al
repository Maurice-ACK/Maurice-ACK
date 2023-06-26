/// <summary>
/// Enum ACKWMOStartStopProduct
/// </summary>
enum 50001 ACKWMOStartStopProduct
{
    Extensible = true;
    Caption = 'Start/stop product', Locked = true;

    value(0; Start)
    {
        Caption = 'Start', Locked = true;
    }
    value(1; Stop)
    {
        Caption = 'Stop', Locked = true;
    }
}
