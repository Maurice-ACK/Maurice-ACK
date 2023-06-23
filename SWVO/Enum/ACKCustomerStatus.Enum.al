/// <summary>
/// Enum ACKCustomerStatus (ID 50009).
/// </summary>
enum 50009 ACKCustomerStatus
{
    Extensible = true;
    Caption = 'Status', Locked = true;

    value(0; Waiting)
    {
        Caption = 'Waiting';
    }
    value(1; Active)
    {
        Caption = 'Active';
    }
    value(2; Inactive)
    {
        Caption = 'In active';
    }
    value(3; Blocked)
    {
        Caption = 'Blocked';
    }

}
