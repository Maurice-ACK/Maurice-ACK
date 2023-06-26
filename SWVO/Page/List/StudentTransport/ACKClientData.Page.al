/// <summary>
/// Page ACKClientData
/// </summary>
page 50092 ACKClientData
{
    ApplicationArea = All;
    Caption = 'Cliënt gegevens', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportClientData;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Attendant; Rec.Attendant)
                {
                }
                field(ClientNo; Rec.ClientNo)
                {
                }
                field(CustomerID; Rec.CustomerID)
                {
                }
            }
        }
    }
}
