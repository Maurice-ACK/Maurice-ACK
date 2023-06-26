/// <summary>
/// Page ACKWMOContactListPart
/// </summary>
page 50021 ACKWMOContactListPart
{
    Caption = 'Contacts';
    PageType = ListPart;
    SourceTable = ACKWMOContact;
    CardPageId = ACKWMOContactCard;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Soort; Rec.Soort)
                {
                    ApplicationArea = All;
                }
                field(Huisnummer; Rec.Huisnummer)
                {
                    ApplicationArea = All;
                }
                field(Huisletter; Rec.Huisletter)
                {
                    ApplicationArea = All;
                }
                field(HuisnummerToevoeging; Rec.HuisnummerToevoeging)
                {
                    ApplicationArea = All;
                }
                field(AanduidingWoonadres; Rec.AanduidingWoonadres)
                {
                    ApplicationArea = All;
                }
                field(Postcode; Rec.Postcode)
                {
                    ApplicationArea = All;
                }
                field(Straatnaam; Rec.Straatnaam)
                {
                    ApplicationArea = All;
                }
                field(Plaatsnaam; Rec.Plaatsnaam)
                {
                    ApplicationArea = All;
                }
                field(LandCode; Rec.LandCode)
                {
                    ApplicationArea = All;
                }
                field(Organisatie; Rec.Organisatie)
                {
                    ApplicationArea = All;
                }
                field(Telefoonnummer01; Rec.Telefoonnummer01)
                {
                    ApplicationArea = All;
                }
                field(Landnummer01; Rec.Landnummer01)
                {
                    ApplicationArea = All;
                }
                field(Telefoonnummer02; Rec.Telefoonnummer02)
                {
                    ApplicationArea = All;
                }
                field(Landnummer02; Rec.Landnummer02)
                {
                    ApplicationArea = All;
                }
                field(Emailadres; Rec.Emailadres)
                {
                    ApplicationArea = All;
                }
                field(Begindatum; Rec.Begindatum)
                {
                    ApplicationArea = All;
                }
                field(Einddatum; Rec.Einddatum)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
