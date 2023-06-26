/// <summary>
/// Page ACKRecentlyChangedCuePart
/// </summary>
page 50062 ACKRecentlyChangedCuePart
{
    ApplicationArea = All;
    Caption = 'Recentelijke wijzigingen', Locked = true;
    PageType = CardPart;
    SourceTable = ACKClient;

    layout
    {
        area(content)
        {
            cuegroup("")
            {
                Caption = 'Recentelijke wijzigingen', Locked = true;

                field(Cue1; Rec.ClientNo)
                {
                    Caption = 'Recente cliënten', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue2; Rec.SystemCreatedAt)
                {
                    Caption = 'Aantal cliënten per gemeente', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue3; Rec.SystemCreatedAt)
                {
                    Caption = 'Nieuwe beschikkingen', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue4; Rec.SystemCreatedAt)
                {
                    Caption = 'Openstaande leveranciersfacturen', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue5; Rec.SystemCreatedAt)
                {
                    Caption = 'Openstaande zorgaanbieder facturen', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue6; Rec.SystemCreatedAt)
                {
                    Caption = 'Openstaande betalingen van klanten', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue7; Rec.SystemCreatedAt)
                {
                    Caption = 'Aantal nieuwe indicaties', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue8; Rec.SystemCreatedAt)
                {
                    Caption = 'Aantal openstaande declaraties', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue9; Rec.SystemCreatedAt)
                {
                    Caption = 'Nieuwe cliënten Hulpmiddelen', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue10; Rec.SystemCreatedAt)
                {
                    Caption = 'Totaal aantal cliënten Hulpmiddelen', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
                field(Cue11; Rec.SystemCreatedAt)
                {
                    Caption = 'Nieuwe cliënten Dakloosheid', Locked = true;
                    DrillDownPageId = "ACKClientList";
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.Reset();
        if not Rec.get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}