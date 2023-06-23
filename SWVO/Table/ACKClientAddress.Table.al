/// <summary>
/// Table ACKClientAddress
/// </summary>
table 50013 ACKClientAddress
{
    Caption = 'Client address';
    DataClassification = CustomerContent;
    DataCaptionFields = ClientNo, PostCode, HouseNumber, HouseLetter, HouseNumberAddition;
    DrillDownPageID = ACKClientAddressListPart;
    LookupPageID = ACKClientAddressListPart;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
        field(20; ClientNo; Code[20])
        {
            Caption = 'Client No.';
            TableRelation = ACKClient.ClientNo;

            trigger OnValidate()
            begin
                TestField(Rec.ClientNo);
            end;
        }
        field(30; ValidFrom; Date)
        {
            Caption = 'Valid from';

            trigger OnValidate()
            begin
                if (Rec.ValidFrom > Rec.ValidTo) and (ValidTo <> 0D) then
                    Error(StartDateAfterEndDateErr, FieldCaption(ValidFrom), FieldCaption(ValidTo));
            end;
        }
        field(40; ValidTo; Date)
        {
            Caption = 'Valid to';

            trigger OnValidate()
            begin
                Rec.Validate(Rec.ValidFrom);
            end;
        }
        field(50; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region".Code;
            InitValue = 'NL';
        }
        field(60; PostCode; Code[6])
        {
            Caption = 'Postcode';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.PostCode);
            end;
        }
        field(70; Street; Text[100])
        {
            Caption = 'Street';
        }
        field(80; "Place of residence"; Text[80])
        {
            Caption = 'Plaatsnaam';

            trigger OnValidate()
            begin
                TestField(Rec."Place of residence");
            end;
        }
        field(100; HouseNumber; Integer)
        {
            MinValue = 0;
            MaxValue = 99999;
            Caption = 'House number';
            NotBlank = true;
        }
        field(110; HouseLetter; Code[1])
        {
            Caption = 'House letter';
        }
        field(120; HouseNumberAddition; Text[10])
        {
            Caption = 'House number addition';
        }
        field(130; Designation; Enum ACKWMOAanduidingWoonadres)
        {
            Caption = 'Designation';
        }
        field(140; Purpose; Enum ACKWMOAdresSoort)
        {
            Caption = 'Purpose';
            InitValue = BRP;

            trigger OnValidate()
            begin
                TestField(Rec.Purpose);
            end;
        }
        field(150; Organisation; Text[35])
        {
            Caption = 'Organisation';
        }
        field(160; EmailAddress; Text[80])
        {
            Caption = 'E-mail address';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: codeunit "Mail Management";
            begin
                if not MailManagement.CheckValidEmailAddress(Rec.EmailAddress) then
                    Rec.EmailAddress := '';
            end;
        }
        field(170; Phone; text[30])
        {
            Caption = 'Phone number';
        }
        field(180; MobilePhone; text[30])
        {
            Caption = 'Mobile phone number';
        }
        field(190; MunicipalityNo; Code[20])
        {
            Caption = 'Gemeente', Locked = true;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                ACKHelper.ValidateMunicipalityRelation(Rec.MunicipalityNo, true, true);
            end;
        }
        field(200; AddressVerify; Boolean)
        {
            Editable = false;
            Caption = 'Address validated';
        }
    }
    keys
    {
        key(PK; ID, ClientNo)
        {
            Clustered = true;
        }
        key(Key1; ClientNo, Purpose, PostCode, HouseNumber, HouseLetter, HouseNumberAddition, ValidFrom, ValidTo)
        {
            Unique = true;
        }

        key(Key2; ClientNo, Purpose, ValidFrom, ValidTo)
        {
        }
    }

    var
        PostcodeRec: Record "Post Code";
        ACKHelper: codeunit ACKHelper;
        County: Text[30];
        StartDateAfterEndDateErr: Label '%1 cannot be after %2', Comment = '%1 = From date; %2 = To Date', MaxLength = 50;

    /// <summary>
    /// InsertWithOverlapCheck.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure InsertOrUpdate(): Boolean
    begin
        VerifyAddress();
        if not CheckOverlap() then
            exit(Rec.Insert(true));
    end;

    trigger OnInsert()
    begin
        FormatAddress();
        //VerifyAddress();
    end;

    trigger OnModify()
    begin
        FormatAddress();
        //VerifyAddress();
    end;

    procedure FormatAddress()
    var
        TextVar: Text;
    begin
        TextVar := Rec.PostCode;
        Rec.PostCode := TextVar.Replace(' ', '');
    end;

    local procedure VerifyAddress()
    begin
        ACKHelper.ValidateRecord(Rec);
        BagApiVerifyAddress();
        GetMunicipalityNo();
    end;

    local procedure BagApiVerifyAddress()
    var
        BagApi: Codeunit ACKSWVOAPHttpClient;
    begin
        rec.AddressVerify := BagApi.VerifyAddres(rec);
    end;

    local procedure GetMunicipalityNo()
    var
        MunicipalityNoRec: Record ACKMunicipality;
        BagApi: Codeunit ACKSWVOAPHttpClient;
    begin
        Rec.MunicipalityNo := MunicipalityNoRec.GetMunicipalityNo(rec.PostCode);

        if (rec.MunicipalityNo = '') and (rec.AddressVerify) then
            rec.MunicipalityNo := BagApi.GetMunicipalityNo(rec);

    end;

    /// <summary>
    /// CheckDuplicate.
    /// True if duplicate found.
    /// </summary>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure CheckDuplicate(ThrowError: Boolean) Duplicate: Boolean
    var
        ACKClientAddress: Record ACKClientAddress;
        DuplicateAddressErr: Label '%1 %2 already has a valid address with fields: %3: %4, %5: %6, %7: %8, %9: %10, %11: %12. Between %13 and %14.', Comment = 'Address key fields', MaxLength = 250;
    begin
        ACKClientAddress.SetFilter(SystemId, '<>%1', Rec.SystemId);
        ACKClientAddress.SetFilter(ClientNo, '=%1', Rec.ClientNo);
        ACKClientAddress.SetFilter(Purpose, '=%1', Rec.Purpose);
        if Rec.ValidTo <> 0D then
            ACKClientAddress.SetFilter(ValidFrom, '<=%1', Rec.ValidTo);
        ACKClientAddress.SetFilter(ValidTo, '>=%1|=%2', Rec.ValidFrom, 0D);

        Duplicate := not ACKClientAddress.IsEmpty();

        if Duplicate and ThrowError then
            Error(DuplicateAddressErr,
                    Rec.FieldCaption(ClientNo),
                    Rec.ClientNo,
                    Rec.FieldCaption(Purpose),
                    Rec.Purpose,
                    Rec.FieldCaption(PostCode),
                    Rec.PostCode,
                    Rec.FieldCaption(HouseNumber),
                    Rec.HouseNumber,
                    Rec.FieldCaption(HouseLetter),
                    Rec.HouseLetter,
                    Rec.FieldCaption(HouseNumberAddition),
                    Rec.HouseNumberAddition,
                    Rec.ValidFrom,
                    Rec.ValidTo);

        exit(Duplicate);
    end;

    /// <summary>
    /// FieldMapDictionary.
    /// </summary>
    /// <returns>Return variable Dict of type Dictionary of [Integer, Text].</returns>
    procedure FieldMapDictionary() Dict: Dictionary of [Integer, Text]
    begin
        Dict.Add(Rec.FieldNo(PostCode), 'postCode');
        Dict.Add(Rec.FieldNo(HouseNumber), 'houseNumber');
        Dict.Add(Rec.FieldNo(HouseLetter), 'houseLetter');
        Dict.Add(Rec.FieldNo(HouseNumberAddition), 'houseNumberAddition');
        Dict.Add(Rec.FieldNo("Place of residence"), 'municipality');
        Dict.Add(Rec.FieldNo(Street), 'street');
    end;

    /// <summary>
    /// MandatoryFields.
    /// </summary>
    /// <returns>Return variable MandatoryFieldList of type List of [Integer].</returns>
    procedure MandatoryFields() MandatoryFieldList: List of [Integer]
    begin
        MandatoryFieldList.Add(Rec.FieldNo(ClientNo));
        MandatoryFieldList.Add(Rec.FieldNo(Purpose));
        MandatoryFieldList.Add(Rec.FieldNo(PostCode));
        MandatoryFieldList.Add(Rec.FieldNo(HouseNumber));
        MandatoryFieldList.Add(Rec.FieldNo("Place of residence"));
        MandatoryFieldList.Add(Rec.FieldNo(Street));
        MandatoryFieldList.Add(Rec.FieldNo("Country/Region Code"));
    end;

    /// <summary>
    /// CheckOverlap
    /// Checks for a previous overlapping address and updates it when found.
    /// When the previous address has the same key fields the address is updated and a boolean IsHandled indicates that the insert can be skipped.
    /// </summary>
    /// <returns>Return variable IsHandled of type Boolean.</returns>
    local procedure CheckOverlap() IsHandled: Boolean
    var
        ACKClientAddressOverlap: Record ACKClientAddress;
        IsDifferent: Boolean;
    begin
        if Rec.ValidFrom = 0D then
            Rec.ValidFrom := Today();

        ACKClientAddressOverlap.SetCurrentKey(ClientNo, Purpose, ValidFrom, ValidTo);
        ACKClientAddressOverlap.SetFilter(SystemId, '<>%1', Rec.SystemId);
        ACKClientAddressOverlap.SetRange(ClientNo, Rec.ClientNo);
        ACKClientAddressOverlap.SetRange(Purpose, Rec.Purpose);

        if Rec.ValidTo <> 0D then
            ACKClientAddressOverlap.SetFilter(ValidFrom, '<=%1', Rec.ValidTo);
        ACKClientAddressOverlap.SetFilter(ValidTo, '>=%1|=%2', Rec.ValidFrom, 0D);

        if ACKClientAddressOverlap.FindFirst() then begin
            IsDifferent :=
          (Rec.PostCode <> ACKClientAddressOverlap.PostCode) or
          (Rec.HouseNumber <> ACKClientAddressOverlap.HouseNumber) or
          (Rec.HouseLetter <> ACKClientAddressOverlap.HouseLetter) or
          (Rec.HouseNumberAddition <> ACKClientAddressOverlap.HouseNumberAddition) or
          (Rec.HouseNumber <> ACKClientAddressOverlap.HouseNumber);

            if not IsDifferent then begin
                //Keep the largest date range.
                if ACKClientAddressOverlap.ValidFrom < Rec.ValidFrom then
                    Rec.ValidFrom := ACKClientAddressOverlap.ValidFrom;

                if ACKClientAddressOverlap.ValidTo > Rec.ValidTo then
                    Rec.ValidTo := ACKClientAddressOverlap.ValidTo;

                //Key fields of the address are the same as a previous adress, transfer all the fields and update the previous address instead of inserting a new one.
                ACKClientAddressOverlap.TransferFields(Rec, false);
                IsHandled := ACKClientAddressOverlap.Modify(false);
            end
            //If this is a different address update the previous validTo date so they don't overlap.
            else begin
                //It could be possible for the modify to fail, this results in overlapping addresses.
                ACKClientAddressOverlap.ValidTo := CalcDate('<-1D>', Rec.ValidFrom);
                ACKClientAddressOverlap.Modify(true);
            end;
        end;
    end;

}
