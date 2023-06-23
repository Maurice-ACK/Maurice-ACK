/// <summary>
/// Page ACKWMOContactCardPart.
/// </summary>
page 50024 ACKWMOContactCardPart
{
    ApplicationArea = All;
    Caption = 'Contact';
    PageType = CardPart;
    SourceTable = ACKWMOContact;
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

                field(Soort; Rec.Soort)
                {
                }
                field(Huisnummer; Rec.Huisnummer)
                {
                }
                field(Huisletter; Rec.Huisletter)
                {
                }
                field(HuisnummerToevoeging; Rec.HuisnummerToevoeging)
                {
                }
                field(AanduidingWoonadres; Rec.AanduidingWoonadres)
                {
                }
                field(Postcode; Rec.Postcode)
                {
                }
                field(Straatnaam; Rec.Straatnaam)
                {
                }
                field(Plaatsnaam; Rec.Plaatsnaam)
                {
                }
                field(LandCode; Rec.LandCode)
                {
                }
                field(Organisatie; Rec.Organisatie)
                {
                }
                field(Telefoonnummer01; Rec.Telefoonnummer01)
                {
                }
                field(Landnummer01; Rec.Landnummer01)
                {
                }
                field(Telefoonnummer02; Rec.Telefoonnummer02)
                {
                }
                field(Landnummer02; Rec.Landnummer02)
                {
                }
                field(Emailadres; Rec.Emailadres)
                {
                }
                field(Begindatum; Rec.Begindatum)
                {
                }
                field(Einddatum; Rec.Einddatum)
                {
                }
            }
        }
    }
}
