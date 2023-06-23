/// <summary>
/// Page AckStudentTranportAdressList (ID 50056).
/// </summary>
page 50056 AckStudentTranportAdressList
{
    ApplicationArea = All;
    Caption = 'Adres', Locked = true;
    PageType = CardPart;
    SourceTable = ACKClientAddress;

    layout
    {
        area(content)
        {
            group(address)
            {
                Caption = 'Adres', Locked = true;
                field("Place of residence"; Rec."Place of residence")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field(EmailAddress; Rec.EmailAddress)
                {
                }
                field(HouseNumber; Rec.HouseNumber)
                {
                }
                field(HouseNumberAddition; Rec.HouseNumberAddition)
                {
                }
                field(Street; Rec.Street)
                {
                }
                field(Postcode; Rec.PostCode)
                {
                }
                field(Organisation; Rec.Organisation)
                {
                }
                field(Purpose; Rec.Purpose)
                {
                    Visible = false;
                }
            }
        }
    }

}
