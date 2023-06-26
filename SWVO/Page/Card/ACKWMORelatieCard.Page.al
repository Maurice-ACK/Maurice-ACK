/// <summary>
/// Page ACKWMORelatieCard
/// </summary>
page 50025 ACKWMORelatieCard
{
    ApplicationArea = All;
    Caption = 'Relatie', Locked = true;
    PageType = Card;
    SourceTable = ACKWMORelatie;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;

                field(Nummer; Rec.Nummer)
                {
                }
                field(Volgorde; Rec.Volgorde)
                {
                }
                field(Soort; Rec.Soort)
                {
                }
                field(Geboortedatum; Rec.Geboortedatum)
                {
                }
                field(GeboortedatumGebruik; Rec.GeboortedatumGebruik)
                {
                }
                field(Geslacht; Rec.Geslacht)
                {
                }
                field(Achternaam; Rec.Achternaam)
                {
                }
                field(Voorvoegsel; Rec.Voorvoegsel)
                {
                }
                field(PartnerAchternaam; Rec.PartnerAchternaam)
                {
                }
                field(PartnerVoorvoegsel; Rec.PartnerVoorvoegsel)
                {
                }
                field(Voornamen; Rec.Voornamen)
                {
                }
                field(Voorletters; Rec.Voorletters)
                {
                }
                field(NaamGebruik; Rec.NaamGebruik)
                {
                }
            }
            part(ACKWMOContactCardPart; ACKWMOContactCardPart)
            {
                Editable = false;
                SubPageLink = RelationTableNo = const(Database::ACKWMORelatie), RefID = field(SystemId);
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                SubPageLink = RelationTableNo = const(Database::ACKWMORelatie), RefID = field(SystemId);
            }
        }
    }
}
