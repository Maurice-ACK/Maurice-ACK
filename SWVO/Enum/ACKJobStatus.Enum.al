/// <summary>
/// Enum ACKJobStatus
/// </summary>
enum 50006 ACKJobStatus
{
    Extensible = true;
    Caption = 'Job status', Locked = true;

    value(0; Ready)
    {
        Caption = 'Ready';
    }
    value(1; Completed)
    {
        Caption = 'Completed';
    }
    value(2; Cancelled)
    {
        Caption = 'Cancelled';
    }
    value(3; Error)
    {
        Caption = 'Error';
    }
}
