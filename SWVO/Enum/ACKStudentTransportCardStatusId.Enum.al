/// <summary>
/// Enum ACKStudentTransportCardStatusId (ID 50011).
/// </summary>
enum 50010 ACKStudentTransportCardStaId
{
    Extensible = true;

    value(0; Undefined)
    {
        Caption = 'Waiting';
    }
    value(10; "Active")
    {
        Caption = 'Active';
    }
    value(20; "Inactive")
    {
        Caption = 'Inactive';
    }
    value(40; "Blocked")
    {
        Caption = 'Blocked';
    }
}
