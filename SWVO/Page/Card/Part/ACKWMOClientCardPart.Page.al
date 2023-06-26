/// <summary>
/// Page WMOClientCardPart
/// </summary>
page 50016 ACKWMOClientCardPart
{
    ApplicationArea = All;
    Caption = 'Client';
    PageType = CardPart;
    SourceTable = ACKWMOClient;
    CardPageId = ACKWMOClientDoc;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DataCaptionFields = SSN;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(Client)
            {
                Caption = 'Client';

                field(SSN; Rec.SSN)
                {
                }
                field(Geboortedatum; Rec.Geboortedatum)
                {
                    Importance = Additional;
                }
                field(Voornamen; Rec.Voornamen)
                {
                }
                field(Voorletters; Rec.Voorletters)
                {
                }
                field(Achternaam; Rec.Achternaam)
                {
                }
                field(Voorvoegsel; Rec.Voorvoegsel)
                {
                }
                field(Commentaar; Rec.Commentaar)
                {
                }
                field(Geslacht; Rec.Geslacht)
                {
                    Importance = Additional;
                }
                field(JuridischeStatus; Rec.JuridischeStatus)
                {
                    Importance = Additional;
                }
                field(WettelijkeVertegenwoordiging; Rec.WettelijkeVertegenwoordiging)
                {
                    Importance = Additional;
                }
                field(PartnerAchternaam; Rec.PartnerAchternaam)
                {
                    Importance = Additional;
                }
                field(PartnerVoorvoegsel; Rec.PartnerVoorvoegsel)
                {
                    Importance = Additional;
                }
                field(CommunicatieVorm; Rec.CommunicatieVorm)
                {
                    Importance = Additional;
                }
                field(CommunicatieTaal; Rec.CommunicatieTaal)
                {
                    Importance = Additional;
                }
                field(NaamGebruik; Rec.NaamGebruik)
                {
                    Importance = Additional;
                }
                field(GeboortedatumGebruik; Rec.GeboortedatumGebruik)
                {
                    Importance = Additional;
                }
            }
        }
    }
}
