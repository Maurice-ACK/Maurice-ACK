/// <summary>
/// Enum ACKWMOReturnStatus
/// </summary>
enum 50038 ACKWMOReturnStatus
{
    Extensible = false;
    Caption = 'Return status';

    value(0; NotReceived)
    {
        Caption = 'Not received';
    }
    value(1; ReceivedAccepted)
    {
        Caption = 'Received / Accepted';
    }
    value(2; ReceivedRejected)
    {
        Caption = 'Received / Rejected';
    }
    value(3; ReturnedRejected)
    {
        Caption = 'Returned / Rejected';
    }
}
