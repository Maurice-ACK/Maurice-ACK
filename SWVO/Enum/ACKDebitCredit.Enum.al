/// <summary>
/// Enum ACKDebitCredit (ID 50020).
/// </summary>
enum 50019 ACKDebitCredit
{
    Caption = 'Debit/credit', Locked = true;

    value(0; C)
    {
        Caption = 'Credit', Locked = true;
    }
    value(1; D)
    {
        Caption = 'Debit', Locked = true;
    }
}
