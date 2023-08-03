/// <summary>
/// Page ACKClientData
/// </summary>
page 50092 ACKSTTClientData
{
    ApplicationArea = All;
    Caption = 'Cliënt gegevens', Locked = true;
    PageType = List;
    SourceTable = ACKSTTClientData;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(AzureID; Rec.AzureID) { }
                field(Attendant; Rec.Attendant)
                {
                }
                field(CarerNo; Rec.CarerNo)
                {
                }
                field(Caterogy; Rec.Caterogy) { }
                field(ClientNo; Rec.ClientNo) { }
                field(ClientType; Rec.ClientType) { }
                field(compensation; Rec.compensation) { }
                field(contribution; Rec.contribution) { }
                field(EmailLayoutCode; Rec.EmailLayoutCode) { }

            }
        }

    }
}
