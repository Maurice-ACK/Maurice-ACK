/// <summary>
/// Codeunit ACKHelper
/// </summary>
codeunit 50003 ACKHelper
{
    Access = Public;
    SingleInstance = true;

    var
        SSNInvalidErr: Label 'Social security number: %1, is invalid.', Comment = '%1 = social security number;', MaxLength = 50;
    //MultiSelectErr: Label 'Cannot select multiple records.', MaxLength = 50;

    local procedure ValidateSSN(SSN: Code[9]): Boolean
    var
        I, Val, Weight, Checksum, Length : Integer;
    begin
        Length := StrLen(SSN);

        //Validate the social security number with the 11-proef.
        for I := 1 to Length do begin
            if I = Length then
                Weight := -1
            else
                Weight := Length - (I + -1);

            //Test if the character is of the type integer.
            if not Evaluate(Val, SSN[I]) then
                exit(false);

            //Create a checksum by multiplying each value of the social security number by the corresponding weight of the 11-proef.
            Checksum += Val * Weight;
        end;

        //The result of the checksum should be a multiple of 11.
        exit((Length >= 8) and (Length <= 9) and (Checksum > 0) and (Checksum mod 11 = 0));
    end;

    /// <summary>
    /// ValidateSSN.
    /// </summary>
    /// <param name="SSN">Code[9].</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ValidateSSN(SSN: Code[9]; ThrowError: Boolean): Boolean
    var
        Valid: Boolean;
    begin
        Valid := ValidateSSN(SSN);
        if Valid = false and ThrowError = true then
            Error(SSNInvalidErr, SSN);
        exit(Valid);
    end;

    /// <summary>
    /// MaxDate.
    /// </summary>
    /// <returns>Return value of type Date.</returns>
    procedure MaxDate(): Date
    begin
        exit(99991231D);
    end;


    /// <summary>
    /// ValidateRecord.
    /// </summary>
    /// <param name="Rec">Variant.</param>
    procedure ValidateRecord(Rec: Variant)
    var
        DataTypeManagement: codeunit "Data Type Management";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        I: Integer;
    begin
        if not DataTypeManagement.GetRecordRef(Rec, RecordRef) then
            exit;

        for I := 1 to RecordRef.FieldCount() do
            if RecordRef.FieldExist(I) then begin
                FieldRef := RecordRef.Field(I);
                if FieldRef.Class() = FieldClass::Normal then
                    FieldRef.Validate();
            end;
    end;

    /// <summary>
    /// StartEndDateValidation.
    /// </summary>
    /// <param name="StartDate">Date.</param>
    /// <param name="EndDate">Date.</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure StartEndDateValidation(StartDate: Date; EndDate: Date; ThrowError: Boolean): Boolean
    var
        StartDateAfterEndDateErr: Label 'Start date cannot be after end date.', MaxLength = 50;
    begin
        if (StartDate > EndDate) and (EndDate <> 0D) then
            Error(StartDateAfterEndDateErr);
    end;

    /// <summary>
    /// FindFirstKeyByValue.
    /// </summary>
    /// <param name="Dict">Dictionary of [Integer, Text].</param>
    /// <param name="Val">Text.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure FindFirstKeyByValue(Dict: Dictionary of [Integer, Text]; Val: Text): Integer
    var
        K: Integer;
    begin
        foreach K in Dict.Keys() do
            if Val.ToLower() = Dict.Get(k).ToLower() then
                exit(K);
    end;

    /// <summary>
    /// NewRecordRef.
    /// </summary>
    /// <param name="RecordRef">VAR RecordRef.</param>
    /// <param name="TableNo">Integer.</param>
    procedure NewRecordRef(var RecordRef: RecordRef; TableNo: Integer)
    begin
        RecordRef.Close();
        RecordRef.Open(TableNo);
    end;


    /// <summary>
    /// NoOfDaysInMonth.
    /// </summary>
    /// <param name="Year">Integer.</param>
    /// <param name="Month">Integer.</param>
    /// <returns>Return variable TotalDays of type Integer.</returns>
    procedure NoOfDaysInMonth(Year: Integer; Month: Integer) TotalDays: Integer
    begin
        TotalDays := DATE2DMY(LastDayOfMonthDate(Year, Month), 1);
    end;

    /// <summary>
    /// FirstDayOfMonth.
    /// </summary>
    /// <param name="InputDate">Date.</param>
    /// <returns>Return variable FirstDayDate of type Date.</returns>
    procedure FirstDayOfMonth(InputDate: Date) FirstDayDate: Date
    var
        Year, Month : Integer;
    begin
        Year := Date2DMY(InputDate, 3);
        Month := GetMonthByDate(InputDate).AsInteger();
        FirstDayDate := DMY2DATE(01, Month, Year)
    end;

    /// <summary>
    /// LastDayOfMonthDate.
    /// </summary>
    /// <param name="InputDate">Date.</param>
    /// <returns>Return variable LastDayDate of type Date.</returns>
    procedure LastDayOfMonthDate(InputDate: Date) LastDayDate: Date
    var
        Year, Month : Integer;
    begin
        Year := Date2DMY(InputDate, 3);
        Month := GetMonthByDate(InputDate).AsInteger();
        LastDayDate := LastDayOfMonthDate(Year, Month);
    end;

    /// <summary>
    /// LastDayOfMonthDate.
    /// </summary>
    /// <param name="Year">Integer.</param>
    /// <param name="MonthOfYear">Enum ACKMonthOfYear.</param>
    /// <returns>Return variable LastDayDate of type Date.</returns>
    procedure LastDayOfMonthDate(Year: Integer; MonthOfYear: Integer) LastDayDate: Date
    begin
        LastDayDate := CALCDATE('<CM>', DMY2DATE(01, MonthOfYear, Year));
    end;

    /// <summary>
    /// GetMonthByDate.
    /// </summary>
    /// <param name="InputDate">Date.</param>
    /// <returns>Return variable MonthOfYear of type Enum ACKMonthOfYear.</returns>
    procedure GetMonthByDate(InputDate: Date) MonthOfYear: Enum ACKMonthOfYear
    begin
        MonthOfYear := ACKMonthOfYear.FromInteger(Date2DMY(InputDate, 2));
    end;

    /// <summary>
    /// ListToSeperatedText.
    /// </summary>
    /// <param name="VarList">List of [Text].</param>
    /// <param name="Seperator">Code[1].</param>
    /// <returns>Return value of type begin.</returns>
    procedure ListToSeperatedText(VarList: List of [Text]; Seperator: Code[1]) ResultText: Text
    var
        Val: Text;
        FormatLbl: Label '%1 %2', Locked = true, Comment = '%1 = Seperator; %2 = Value', MaxLength = 100;
    begin
        foreach Val in VarList do
            if ResultText <> '' then
                ResultText := ResultText + StrSubstNo(FormatLbl, Seperator, Val)
            else
                ResultText := Val;
    end;

    /// <summary>
    /// GetRetourCodeText.
    /// </summary>
    /// <param name="RelationTableNo">integer.</param>
    /// <param name="RefId">Guid.</param>
    /// <returns>Return variable RetourCodeText of type Text.</returns>
    procedure GetRetourCodeText(RelationTableNo: integer; RefId: Guid) RetourCodeText: Text
    var
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
        RetourCodeList: List of [Text];
    begin
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, RelationTableNo);
        ACKWMOMessageRetourCode.SetRange(RefID, RefId);

        if ACKWMOMessageRetourCode.FindSet(false, false) then
            repeat
                RetourCodeList.Add(ACKWMOMessageRetourCode.RetourCodeID);
            until ACKWMOMessageRetourCode.Next() = 0;

        RetourCodeText := ListToSeperatedText(RetourCodeList, ',');
    end;


    /// <summary>
    /// GetRelationTableNo.
    /// /// /// </summary>
    /// <param name="Rec">Variant.</param>
    /// <param name="FieldNo">Integer.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetRelationTableNo(Rec: Variant; FieldNo: Integer): Integer
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        if Rec.IsRecord() then begin
            RecordRef.GetTable(Rec);
            FieldRef := RecordRef.Field(FieldNo);
            exit(FieldRef.Relation());
        end;
        exit(0);
    end;

    /// <summary>
    /// GetCustVendName.
    /// </summary>
    /// <param name="Rec">Variant.</param>
    /// <param name="FieldNo">Integer.</param>
    /// <returns>Return value of type Text[100].</returns>
    procedure GetCustVendName(Rec: Variant; FieldNo: Integer): Text[100]
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        No: Code[20];
    begin
        if not Rec.IsRecord() then
            exit('');

        RecordRef.GetTable(Rec);
        FieldRef := RecordRef.Field(FieldNo);

        if (FieldRef.Type <> FieldType::Text) and (FieldRef.Type <> FieldType::Code) then
            exit('');

        No := FieldRef.Value();

        case FieldRef.Relation() of
            Database::Customer:
                if Customer.Get(No) then
                    exit(Customer.Name);
            Database::Vendor:
                if Vendor.Get(No) then
                    exit(Vendor.Name);
        end;
    end;

    /// <summary>
    /// GetRelation.
    /// </summary>
    /// <param name="Rec">Variant.</param>
    /// <param name="FieldNo">Integer.</param>
    /// <returns>Return variable Relation of type Integer.</returns>
    procedure GetRelation(Rec: Variant; FieldNo: Integer) Relation: Integer
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        if not Rec.IsRecord() then
            exit(0);

        RecordRef.GetTable(Rec);
        FieldRef := RecordRef.Field(FieldNo);
        Relation := FieldRef.Relation();
    end;

    /// <summary>
    /// VendorLookup.
    /// </summary>
    /// <param name="Vendor">VAR Record Vendor.</param>
    /// <param name="IsHealthcareProvider">Boolean.</param>
    /// <returns>Return value of type Action.</returns>
    procedure VendorLookup(var Vendor: Record Vendor; IsHealthcareProvider: Boolean): action;
    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
    begin
        if IsHealthcareProvider then begin
            ACKSWVOGeneralSetup.Get();
            if ACKSWVOGeneralSetup.HealthcareProviderPostingGroup <> '' then
                Vendor.SetRange("Vendor Posting Group", ACKSWVOGeneralSetup.HealthcareProviderPostingGroup);
        end;

        exit(Page.RunModal(Page::"Vendor Lookup", Vendor));
    end;

    /// <summary>
    /// CustomerLookup.
    /// </summary>
    /// <param name="Customer">VAR Record Customer.</param>
    /// <param name="IsMunicipality">Boolean.</param>
    /// <returns>Return value of type action.</returns>
    procedure CustomerLookup(var Customer: Record Customer; IsMunicipality: Boolean): action;
    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
    begin
        ACKSWVOGeneralSetup.Get();

        if IsMunicipality then
            Customer.SetRange("Customer Posting Group", ACKSWVOGeneralSetup.MunicipalityPostingGroup)
        else
            Customer.SetRange("Customer Posting Group", ACKSWVOGeneralSetup.CustomerPostingGroup);

        exit(Page.RunModal(Page::"Customer Lookup", Customer));
    end;

    /// <summary>
    /// NullGuid.
    /// </summary>
    /// <returns>Return value of type Guid.</returns>
    procedure NullGuid(): Guid
    begin
        exit('{00000000-0000-0000-0000-000000000000}');
    end;

    /// <summary>
    /// ShowErrorDialog.
    /// </summary>
    /// <param name="Message">Text.</param>
    procedure ShowErrorDialog(Message: Text)
    begin
        Dialog.Error(ErrorInfo.Create(Message));
    end;

    /// <summary>
    /// InsertRecord.
    /// </summary>
    /// <param name="Rec">Variant.</param>
    procedure InsertRecord(Rec: Variant)
    var
        RecordRef: RecordRef;
        InvalidParameterTypeErr: Label 'Parameter must be of type: Record', Locked = true;
        InsertFailedErr: Label '%1: insert failed', Comment = '%1 = Table caption';
    begin
        if not Rec.IsRecord() then
            Error(InvalidParameterTypeErr);

        RecordRef.GetTable(Rec);
        if not RecordRef.Insert(true) then
            Error(InsertFailedErr, RecordRef.Caption());
    end;

    /// <summary>
    /// AddLog.
    /// </summary>
    /// <param name="RecVariant">Variant.</param>
    /// <param name="Severity">Enum Severity.</param>
    /// <param name="Message">Text[255].</param>
    [TryFunction]
    procedure AddWmoEventLog(RecVariant: Variant; Severity: Enum Severity; Message: Text)
    var
        NewEventLog: Record ACKEventLog;
        RecordRef: RecordRef;
        RefSystemID: Guid;
    begin
        if not RecVariant.IsRecord() then
            Error('Rec must be of type record.');

        RecordRef.GetTable(RecVariant);

        if RecordRef.Number() = 0 then
            Error('Invalid table id: 0');

        RefSystemID := RecordRef.Field(RecordRef.SystemIdNo()).Value();

        if IsNullGuid(RefSystemID) then
            Error('System Id cannot be a null guid.');

        NewEventLog.Init();
        NewEventLog.RefTableID := RecordRef.Number();
        NewEventLog.RefSystemID := RefSystemID;
        NewEventLog.Severity := Severity;
        NewEventLog.Message := CopyStr(Message, 1, 1024);
        NewEventLog.Insert(true);
    end;

    /// <summary>
    /// AddEventLog.
    /// </summary>
    /// <param name="TableNo">Integer.</param>
    /// <param name="Severity">Enum Severity.</param>
    /// <param name="Message">Text[255].</param>
    procedure AddEventLog(TableNo: Integer; Severity: Enum Severity; Message: Text)
    var
        NewEventLog: Record ACKEventLog;
    begin
        NewEventLog.Init();
        NewEventLog.RefTableID := TableNo;
        NewEventLog.Severity := Severity;
        NewEventLog.Message := CopyStr(Message, 1, 1024);
        NewEventLog.Insert(true);
    end;

    /// <summary>
    /// UploadXml.
    /// </summary>
    procedure UploadXml()
    var
        FileMgmnt: Codeunit "File Management";
        SWVOAPIHttpClient: Codeunit ACKSWVOAPHttpClient;
        Base64Convert: Codeunit "Base64 Convert";
        InStream: InStream;
        XMLDoc: XMLDocument;
        FilePath, InstreamText : Text;
        XMLFileTypeLbl: Label 'XML Files (*.xml)|*.xml', Locked = true;
        SelectFileLbl: Label 'Select file..';
        XMLParseErr: Label 'Failed to parse XML';
        ReadOptions: XmlReadOptions;
        WriteOptions: XmlWriteOptions;
    begin
        if UploadIntoStream(SelectFileLbl, '', XMLFileTypeLbl, FilePath, InStream) then begin
            FileMgmnt.ValidateFileExtension(FilePath, '.xml');

            ReadOptions.PreserveWhitespace(false);
            WriteOptions.PreserveWhitespace(false);

            if not XmlDocument.ReadFrom(InStream, ReadOptions, XMLDoc) then
                Error(XMLParseErr);

            XMLDoc.WriteTo(WriteOptions, InstreamText);
            SWVOAPIHttpClient.ImportWMOXml(Base64Convert.ToBase64(InstreamText, TextEncoding::UTF8));
        end;
    end;

    /// <summary>
    /// UploadJson.
    /// </summary>
    procedure UploadJson()
    var
        ACKJsonImportProcessorV2: Codeunit ACKJsonImport;
        FileMgmnt: Codeunit "File Management";
        InStream: InStream;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        VektisCode: Enum ACKVektisCode;
        BerichtVersie, BerichtSubversie : Integer;
        FilePath, InstreamText : Text;
        JSONFileTypeLbl: Label 'JSON Files (*.JSON)|*.JSON', Locked = true;
        SelectFileLbl: Label 'Select file..';
    begin
        if UploadIntoStream(SelectFileLbl, '', JSONFileTypeLbl, FilePath, InStream) then begin
            FileMgmnt.ValidateFileExtension(FilePath, '.JSON');

            JsonObject.ReadFrom(InStream);
            JsonObject.SelectToken('header.berichtCode', JsonToken);
            VektisCode := ACKVektisCode.FromInteger(JsonToken.AsValue().AsInteger());

            JsonObject.SelectToken('header.berichtVersie', JsonToken);
            BerichtVersie := JsonToken.AsValue().AsInteger();

            JsonObject.SelectToken('header.berichtSubversie', JsonToken);
            BerichtSubversie := JsonToken.AsValue().AsInteger();

            ACKJsonImportProcessorV2.Init(JsonObject, VektisCode, BerichtVersie, BerichtSubversie, true);
            ACKJsonImportProcessorV2.Run();
        end;
    end;

    /// <summary>
    /// FilterMultiValue.
    /// </summary>
    /// <param name="VarRec">VAR Variant.</param>
    /// <param name="FieldNo">Integer.</param>
    /// <returns>Return variable RecFilter of type Text.</returns>
    procedure FilterMultiValue(VarRec: Variant; FieldNo: Integer) RecFilter: Text;
    var
        RecRef: RecordRef;
        Val: Text;
    begin
        RecFilter := '=';

        if not VarRec.IsRecord() then
            exit;

        RecRef.GetTable(VarRec);

        if RecRef.FindSet() then
            repeat
                if RecFilter <> '=' then
                    RecFilter += '|';

                Val := Format(RecRef.Field(FieldNo).Value());
                RecFilter += Val;
            until RecRef.Next() = 0;
    end;

    /// <summary>
    /// GetRecordFromVariant.
    /// </summary>
    /// <param name="_Rec">Variant.</param>
    /// <param name="RecordRef">VAR RecordRef.</param>
    /// <param name="EmptyValid">Boolean.</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure GetRecordFromVariant(_Rec: Variant; var RecordRef: RecordRef; EmptyValid: Boolean; ThrowError: Boolean): Boolean
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RecordTypeErrMsg: Label 'Parameter must be of type Record or RecordRef.', Locked = true;
        RecordEmptyErrMsg: Label 'Record should not be empty.', Locked = true;
        IsValid: Boolean;
    begin
        IsValid := DataTypeManagement.GetRecordRef(_Rec, RecordRef);

        if not IsValid then begin
            if ThrowError then
                Error(RecordTypeErrMsg);
            exit(false);
        end;

        if EmptyValid then
            exit(true);

        if RecordRef.IsEmpty() then begin
            if ThrowError then
                Error(RecordEmptyErrMsg);
            exit(false);
        end;

        exit(true);
    end;

    /// <summary>
    /// ValidateMunicipalityRelation.
    /// </summary>
    /// <param name="MunicipalityNo">Code[20].</param>
    /// <param name="AllowEmpty">Boolean.</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure ValidateMunicipalityRelation(MunicipalityNo: Code[20]; AllowEmpty: Boolean; ThrowError: Boolean) Found: Boolean;
    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        Customer: Record Customer;
        NotFoundErr: Label 'Invalid relation to customer municipality.', Locked = true;
    begin
        if MunicipalityNo = '' then
            if AllowEmpty then
                exit(true)
            else
                if ThrowError then
                    Error(NotFoundErr)
                else
                    exit(false);

        ACKSWVOGeneralSetup.Get();

        Customer.SetRange("No.", MunicipalityNo);
        Customer.SetRange("Customer Posting Group", ACKSWVOGeneralSetup.MunicipalityPostingGroup);

        Found := Customer.FindFirst();

        if not Found and ThrowError then
            Error(NotFoundErr);
    end;

    /// <summary>
    /// ValidateHealthcareProviderRelation.
    /// </summary>
    /// <param name="HealthcareProviderNo">Code[20].</param>
    /// <param name="AllowEmpty">Boolean.</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure ValidateHealthcareProviderRelation(HealthcareProviderNo: Code[20]; AllowEmpty: Boolean; ThrowError: Boolean) Found: Boolean;
    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        Vendor: Record Vendor;
        NotFoundErr: Label 'Invalid relation to vendor healthcare provider.', Locked = true;
    begin
        if HealthcareProviderNo = '' then
            if AllowEmpty then
                exit(true)
            else
                if ThrowError then
                    Error(NotFoundErr)
                else
                    exit(false);

        ACKSWVOGeneralSetup.Get();

        Vendor.SetRange("No.", HealthcareProviderNo);
        Vendor.SetRange("Vendor Posting Group", ACKSWVOGeneralSetup.HealthcareProviderPostingGroup);

        Found := Vendor.FindFirst();

        if not Found and ThrowError then
            Error(NotFoundErr);
    end;
}
