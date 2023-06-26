/// <summary>
/// Page ACKWMOClientListPart
/// </summary>
page 50049 ACKWMOClientListPart
{
    Caption = 'Clients';
    PageType = ListPart;
    SourceTable = ACKWMOClient;
    CardPageId = ACKWMOClientDoc;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SSN; Rec.SSN)
                {
                }
                field(Geboortedatum; Rec.Geboortedatum)
                {
                }
                field(Voorletters; Rec.Voorletters)
                {
                }
                field(Voorvoegsel; Rec.Voorvoegsel)
                {
                }
                field(Achternaam; Rec.Achternaam)
                {
                }
                field(Geslacht; Rec.Geslacht)
                {
                    Importance = Additional;
                }
            }
        }
    }
}
