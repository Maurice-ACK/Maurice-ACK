/// <summary>
/// Page ACKClientAddressCard.
/// </summary>
page 50010 ACKClientAddressCard
{
    ApplicationArea = All;
    Caption = 'Client address';
    PageType = Card;
    SourceTable = ACKClientAddress;
    UsageCategory = None;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Purpose; Rec.Purpose)
                {
                    ShowMandatory = true;
                }
                field(Postcode; Rec.PostCode)
                {
                    ShowMandatory = true;
                }
                field(HouseNumber; Rec.HouseNumber)
                {
                    ShowMandatory = true;
                }
                field(HouseLetter; Rec.HouseLetter)
                {
                }
                field(HouseNumberAddition; Rec.HouseNumberAddition)
                {
                }
                field(Street; Rec.Street)
                {
                    ShowMandatory = true;
                }
                field("Place of residence"; Rec."Place of residence")
                {
                    ShowMandatory = true;
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {

                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ShowMandatory = true;
                }
                field(Designation; Rec.Designation)
                {
                }
                field(Organisation; Rec.Organisation)
                {
                }
                field(EmailAddress; Rec.EmailAddress)
                {
                    ExtendedDatatype = EMail;
                }
                field(ValidFrom; Rec.ValidFrom)
                {
                }
                field(ValidTo; Rec.ValidTo)
                {
                }
                field(AddressValidated; Rec.AddressVerify)
                {

                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(VerifyAddres)
            {
                Caption = 'Validate address';
                Image = Addresses;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AddressApi: Codeunit ACKSWVOAPHttpClient;
                begin

                    if not (AddressApi.VerifyAddres(Rec)) then
                        Message(AdressNotValidated)
                    else
                        Message(AdressValidated);
                end;
            }
        }
    }




    trigger OnInsertRecord(BelowxRec: Boolean): Boolean

    begin
        ValidatAddress();
    end;

    trigger OnModifyRecord(): Boolean

    begin
        ValidatAddress();
    end;

    local procedure ValidatAddress()
    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        AddressApi: Codeunit ACKSWVOAPHttpClient;

    begin
        rec.FormatAddress();

        if not ACKSWVOGeneralSetup.Get() then
            exit;
        if not ACKSWVOGeneralSetup.VerifyAddressBag then
            exit;

        if not (AddressApi.VerifyAddres(Rec)) then
            Message(AdressNotValidated);
    end;

    var
        AdressNotValidated: Label 'Address could not be found.';
        AdressValidated: Label 'Address is validated.';
}

