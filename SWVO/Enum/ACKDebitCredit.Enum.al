/// <summary>
/// Enum ACKDebitCredit
/// </summary>
enum 50019 ACKDebitCredit
{
    Caption = 'Debet/credit', Locked = true;

    value(0; C)
    {
        Caption = 'Credit', Locked = true;
    }
    value(1; D)
    {
        Caption = 'Debet', Locked = true;
    }
}
