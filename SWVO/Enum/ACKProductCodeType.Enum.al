/// <summary>
/// Enum ACKProductCodeType
/// </summary>
enum 50026 ACKProductCodeType
{
    Extensible = false;
    Caption = 'Product code type';

    value(0; Wmo)
    {
        Caption = 'Wmo';
    }
    value(1; Transport)
    {
        Caption = 'Transport';
    }
    value(2; Resources)
    {
        Caption = 'Resources';
    }
    value(3; ShelteredHousing)
    {
        Caption = 'Sheltered housing';
    }
}
