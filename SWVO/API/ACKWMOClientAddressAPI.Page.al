/// <summary>
/// Page ACKWMOClientAddressAPI
/// </summary>
page 50115 ACKWMOClientAddressAPI
{
    PageType = API;

    APIPublisher = 'swvo';
    APIGroup = 'sharepoint';
    APIVersion = 'v1.0';
    EntityName = 'address';
    EntitySetName = 'addresses';
    DelayedInsert = true;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = ACKClientAddress;
    SourceTableView = sorting(ClientNo, Purpose, ValidFrom, ValidTo) order(descending);

    layout
    {
        area(Content)
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
                field(municipality; Municipality)
                {
                }
                field("placeOfResidence"; Rec."Place of residence")
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
                part(ACKWMOIndicationAPI; ACKWMOIndicationAPI)
                {
                    Multiplicity = Many;
                    SubPageLink = ClientNo = field(ClientNo), MunicipalityNo = field(MunicipalityNo);
                }
                part(ACKWMODeclarationAPI; ACKWMODeclarationAPI)
                {
                    Multiplicity = Many;
                    SubPageLink = ClientNo = field(ClientNo), MunicipalityNo = field(MunicipalityNo);
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        PurposeFilter: Text;
    begin
        if Rec.GetFilter(MunicipalityNo) = '' then
            Error('Filter on %1 must be specified.', Rec.FieldCaption(MunicipalityNo));

        PurposeFilter := Rec.GetFilter(Purpose);

        if PurposeFilter = '' then
            Rec.SetRange(Purpose, ACKWMOAdresSoort::BRP);
    end;

    trigger OnAfterGetCurrRecord()
    var
        Customer: Record Customer;
    begin
        Customer.Get(Rec.MunicipalityNo);
        Municipality := Customer.Name;
    end;

    var
        Municipality: Text[100];
}