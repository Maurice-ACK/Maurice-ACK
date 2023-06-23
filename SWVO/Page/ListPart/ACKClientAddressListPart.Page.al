/// <summary>
/// Page ACKClientAddressListPart
/// </summary>
page 50004 ACKClientAddressListPart
{
    Caption = 'Addresses';
    CardPageID = ACKClientAddressCard;
    DataCaptionFields = ClientNo;
    Editable = false;
    PageType = ListPart;
    SourceTable = ACKClientAddress;
    UsageCategory = None;
    ApplicationArea = All;
    SourceTableView = sorting(ClientNo, Purpose, ValidFrom, ValidTo) order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(purpose; Rec.Purpose)
                {
                }
                field(postcode; Rec.PostCode)
                {
                }
                field(houseNumber; Rec.HouseNumber)
                {
                }
                field(houseLetter; Rec.HouseLetter)
                {
                }
                field(houseNumberAddition; Rec.HouseNumberAddition)
                {
                }
                field(street; Rec.Street)
                {
                }
                field(municipalityNo; Rec.MunicipalityNo)
                {
                }
                field(placeOfResidence; Rec."Place of residence")
                {
                }
                field(countryRegion; Rec."Country/Region Code")
                {
                }
                field(organisation; Rec.Organisation)
                {
                }
                field(designation; Rec.Designation)
                {
                }
                field(emailAddress; Rec.EmailAddress)
                {
                    ExtendedDatatype = EMail;
                }
                field(validFrom; Rec.ValidFrom)
                {
                }
                field(validTo; Rec.ValidTo)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PurposeFilter: Text;
    begin
        PurposeFilter := Rec.GetFilter(Purpose);

        if PurposeFilter = '' then
            Rec.SetRange(Purpose, ACKWMOAdresSoort::BRP);
    end;
}
