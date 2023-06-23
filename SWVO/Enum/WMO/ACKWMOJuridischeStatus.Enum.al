/// <summary>
/// Enum ACKWMOJuridicalStatus (ID 50014).
/// </summary>
enum 50013 ACKWMOJuridischeStatus
{
    Extensible = false;
    Caption = 'Juridische status', Locked = true;

    value(0; Empty)
    {
        Caption = '-', Locked = true;
    }
    value(1; RM)
    {
        Caption = 'Rechterlijke machtiging (rm) voorlopig / voortgezette machtiging', Locked = true;
    }
    value(2; RMOwnRequest)
    {
        Caption = 'RM op eigen verzoek', Locked = true;
    }
    value(3; RMConditionalDischarge)
    {
        Caption = 'RM met voorwaardelijk ontslag', Locked = true;
    }
    value(4; OTS)
    {
        Caption = 'Onder toezichtstelling (ots)', Locked = true;
    }
    value(5; IBS)
    {
        Caption = 'In bewaring stelling (ibs)', Locked = true;
    }
    value(11; TBS)
    {
        Caption = 'Strafrechterlijke justitiele contacten: tbs', Locked = true;
    }
    value(12; Other)
    {
        Caption = 'Strafrechterlijke justitiele contacten: overig', Locked = true;
    }
}
