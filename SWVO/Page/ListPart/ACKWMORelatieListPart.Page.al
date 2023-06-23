/// <summary>
/// Page ACKWMORelatieListPart (ID 50023).
/// </summary>
page 50023 ACKWMORelatieListPart
{
    Caption = 'Relaties';
    PageType = ListPart;
    SourceTable = ACKWMORelatie;
    CardPageId = ACKWMORelatieCard;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting(Volgorde);
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Nummer; Rec.Nummer)
                {
                    ApplicationArea = All;
                }
                field(Volgorde; Rec.Volgorde)
                {
                    ApplicationArea = All;
                }
                field(Soort; Rec.Soort)
                {
                    ApplicationArea = All;
                }
                field(Geboortedatum; Rec.Geboortedatum)
                {
                    ApplicationArea = All;
                }
                field(GeboortedatumGebruik; Rec.GeboortedatumGebruik)
                {
                    ApplicationArea = All;
                }
                field(Geslacht; Rec.Geslacht)
                {
                    ApplicationArea = All;
                }
                field(Achternaam; Rec.Achternaam)
                {
                    ApplicationArea = All;
                }
                field(Voorvoegsel; Rec.Voorvoegsel)
                {
                    ApplicationArea = All;
                }
                field(PartnerAchternaam; Rec.PartnerAchternaam)
                {
                    ApplicationArea = All;
                }
                field(PartnerVoorvoegsel; Rec.PartnerVoorvoegsel)
                {
                    ApplicationArea = All;
                }
                field(Voornamen; Rec.Voornamen)
                {
                    ApplicationArea = All;
                }
                field(Voorletters; Rec.Voorletters)
                {
                    ApplicationArea = All;
                }
                field(NaamGebruik; Rec.NaamGebruik)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
