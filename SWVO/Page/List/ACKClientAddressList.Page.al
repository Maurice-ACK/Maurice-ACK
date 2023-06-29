/// <summary>
/// Page ACKClientAddressList (ID 50116).
/// </summary>
page 50116 ACKClientAddressList
{
    ApplicationArea = All;
    Caption = 'Client addresses';
    PageType = List;
    SourceTable = ACKClientAddress;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.ID)
                {
                }
                field(ClientNo; Rec.ClientNo)
                {
                }
                field(ValidFrom; Rec.ValidFrom)
                {
                }
                field(ValidTo; Rec.ValidTo)
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field(Postcode; Rec.PostCode)
                {
                }
                field(Street; Rec.Street)
                {
                }
                field("Place of residence"; Rec."Place of residence")
                {
                }
                field(HouseNumber; Rec.HouseNumber)
                {
                }
                field(HouseLetter; Rec.HouseLetter)
                {
                }
                field(HouseNumberAddition; Rec.HouseNumberAddition)
                {
                }
                field(Designation; Rec.Designation)
                {
                }
                field(Purpose; Rec.Purpose)
                {
                }
                field(Organisation; Rec.Organisation)
                {
                }
                field(EmailAddress; Rec.EmailAddress)
                {
                }
                field(Phone; Rec.Phone)
                {
                }
                field(MobilePhone; Rec.MobilePhone)
                {
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                }
                field(AddressVerify; Rec.AddressVerify)
                {
                }
            }
        }
    }
}
