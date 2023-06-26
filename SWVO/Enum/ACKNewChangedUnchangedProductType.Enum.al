/// <summary>
/// Enum ACKNewChangedUnchangedProductType
/// </summary>
enum 50005 ACKNewChangedUnchangedProductType
{
    Extensible = true;

    value(0; New)
    {
        Caption = 'New';
    }
    value(1; Changed)
    {
        Caption = 'Changed';
    }
    value(2; Unchanged)
    {
        Caption = 'Unchanged';
    }
}
