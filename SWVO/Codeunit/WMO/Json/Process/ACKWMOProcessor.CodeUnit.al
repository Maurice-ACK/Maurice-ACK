/// <summary>
/// Codeunit ACKWMOProcessor.
/// </summary>
codeunit 50015 ACKWMOProcessor
{
    var
        WMOGenerateRetour: Codeunit ACKWMOGenerateRetour;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        SWVOAPIHttpClient: Codeunit ACKSWVOAPHttpClient;
        Base64Convert: Codeunit "Base64 Convert";
        DVSValidator: Codeunit ACKDVSValidator;
        EmptyHeaderErr: label '%1 must not be empty.', Comment = '%1 = ACKWMOHeader';
        InvalidBerichtCodeErr: Label 'Invalid bericht code on WMOProcessor for type: %1', Comment = '%1 = Vektis code';
    //TR135Err: Label 'TR135: Vullen met een bestaande datum die niet in de toekomst ligt.', Comment = '';
    //TR056Err: Label 'TR056: Identificatie moet per berichtsoort uniek zijn voor de verzendende partij.', Comment = '';
    //TR378Err: Label 'TR378: Vullen met een bestaande gemeentecode uit het overzicht van CBS dat actueel is op Ingangsdatum of ToewijzingIngangsdatum.';
    //SW018Err: Label 'SW018: AGB code onbekend.';

    /// <summary>
    /// ValidateProcessStatus.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    procedure ValidateProcessStatus(WMOHeader: Record ACKWMOHeader)
    var
        HeaderAlreadyProcessedErr: Label 'Message: %1, %2 is already processed.', Comment = '%1 = Vektis code, %2 = Identification';
    begin
        if WMOHeader.Status.AsInteger() >= ACKWMOHeaderStatus::Send.AsInteger() then
            Error(HeaderAlreadyProcessedErr, WMOHeader.BerichtCode, WMOHeader.Identificatie);
    end;


    /// <summary>
    /// ValidateHeader.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    /// <param name="ExpectedVektisCode">Enum ACKVektisCode.</param>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure ValidateHeader(var WMOHeader: Record ACKWMOHeader; ExpectedVektisCode: Enum ACKVektisCode): Boolean
    var
        WMOHeaderDuplicate, WMOHeaderTo : Record ACKWMOHeader;
    //SW014Err: Label 'Er is geen geldig heenbericht ontvangen voor retourbericht.';
    begin
        if WMOHeader.IsEmpty() then
            Error(EmptyHeaderErr, WMOHeader.TableCaption());

        if WMOHeader.BerichtCode <> ExpectedVektisCode then
            Error(InvalidBerichtCodeErr, ACKVektisCode::wmo301);

        //Delete retourcodes already inserted on the header.
        if not WMOHeader.IsRetour() then
            MessageRetourCode.DeleteFromHeaderId(WMOHeader.SystemId);

        //Validate decentrale validatie service
        if not DVSValidator.ValidateHeader(WMOHeader) then begin
            //XSD and XSLT validation errors always result in retourcode 0001 on the header.
            MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, WMOHeader.SystemId, WMOHeader.SystemId, ACKRetourCode::"0001");
            exit(false);
        end;

        //Check if municipality and healthcare provider are valid.
        if not ValidateRelations(WMOHeader) then
            exit(false);

        //If already contains invalid retourcode then no need to validate further.
        if HasInvalidRetourCode(WMOHeader.SystemId, Database::ACKWMOHeader, WMOHeader.SystemId) then
            exit(false);

        //TR056: Identificatie moet per berichtsoort uniek zijn voor de verzendende partij.
        WMOHeaderDuplicate.SetFilter(SystemId, '<>%1', WMOHeader.SystemId);
        WMOHeaderDuplicate.SetFilter(Status, '>%1', ACKWMOHeaderStatus.FromInteger(3));
        WMOHeaderDuplicate.SetRange(BerichtCode, WMOHeader.BerichtCode);
        WMOHeaderDuplicate.SetRange(Afzender, WMOHeader.Afzender);
        WMOHeaderDuplicate.SetRange(Identificatie, WMOHeader.Identificatie);

        if not WMOHeaderDuplicate.IsEmpty() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, WMOHeader.SystemId, WMOHeader.SystemId, ACKWMORule::TR056);
            exit(false);
        end;

        //TR135: Vullen met een bestaande datum die niet in de toekomst ligt.
        if WMOHeader.Dagtekening > Today() then begin
            MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, WMOHeader.SystemId, WMOHeader.SystemId, ACKWMORule::TR135);
            exit(false);
        end;

        //When retour then check if the to message is received.
        if WMOHeader.IsRetour() then
            if WMOHeader.GetToHeader(WMOHeaderTo, false) then begin
                if WMOHeaderTo.Status.AsInteger() < ACKWMOHeaderStatus::Invalid.AsInteger() then
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, WMOHeader.SystemId, WMOHeader.SystemId, ACKWMORule::SW014)
            end
            else
                MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, WMOHeader.SystemId, WMOHeader.SystemId, ACKWMORule::SW014);

        //Check if the header contains any invalid retourcode.
        if HasInvalidRetourCode(WMOHeader.SystemId, Database::ACKWMOHeader, WMOHeader.SystemId) then
            exit(false);

        exit(true);
    end;

    /// <summary>
    /// CreateRetour.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    procedure CreateRetour(WMOHeader: Record ACKWMOHeader)
    begin
        WMOGenerateRetour.Run(WMOHeader);
    end;

    procedure Send(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader.SetStatus(ACKWMOHeaderStatus::Send);
        WMOHeader.Modify(true);
    end;



    // procedure ValidateDVS(WMOHeader: Record ACKWMOHeader)
    // begin
    //     SWVOAPIHttpClient.Retour()
    // end;

    /// <summary>
    /// ValidateRelations.
    /// </summary>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    /// <returns>Return variable IsValid of type Boolean.</returns>
    procedure ValidateRelations(var WMOHeader: Record ACKWMOHeader) IsValid: Boolean
    var
        RF: RecordRef;
    begin
        RF.GetTable(WMOHeader);
        IsValid := ValidateRelation(RF, RF.Field(WMOHeader.FieldNo(Afzender))) and ValidateRelation(RF, RF.Field(WMOHeader.FieldNo(Ontvanger)));
    end;

    local procedure ValidateRelation(RF: RecordRef; FRRelation: FieldRef) IsValid: Boolean
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        RelationNr: Code[8];
        RefSystemId: Guid;
        InvalidUseOfMethodErr: Label 'Invalid use of method', Locked = true;
        RelationInvalidErr: Label 'Relation %1 does not exists.', Comment = '%1 = Relation Nr.', Locked = false;
    begin
        IsValid := true;

        if FRRelation.Type() <> FieldType::Code then
            Error(InvalidUseOfMethodErr);

        RefSystemId := RF.Field(RF.SystemIdNo()).Value();
        RelationNr := FRRelation.Value();

        case FRRelation.Relation() of
            Database::Customer:
                if not Customer.Get(RelationNr) then begin
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, RefSystemId, RefSystemId, ACKWMORule::TR378);
                    IsValid := false;
                end;
            Database::Vendor:
                if not Vendor.Get(RelationNr) then begin
                    MessageRetourCode.InsertRetourCode(Database::ACKWMOHeader, RefSystemId, RefSystemId, ACKWMORule::SW018);
                    IsValid := false;
                end;
            else
                Error(RelationInvalidErr, RelationNr);
        end;
    end;

    /// <summary>
    /// HasInvalidRetourCode.
    /// </summary>
    /// <param name="HeaderId">Guid.</param>
    /// <param name="RelationTableNo">Integer.</param>
    /// <param name="RefId">Guid.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure HasInvalidRetourCode(HeaderId: Guid; RelationTableNo: Integer; RefId: Guid): Boolean
    var
        ACKWMOMessageRetourCodeQuery: Query ACKWMOMessageRetourCodeQuery;
    begin
        ACKWMOMessageRetourCodeQuery.SetRange(HeaderId, HeaderId);
        ACKWMOMessageRetourCodeQuery.SetRange(RelationTableNo, RelationTableNo);
        ACKWMOMessageRetourCodeQuery.SetRange(RefId, RefId);
        ACKWMOMessageRetourCodeQuery.SetRange(MessageInvalid, true);

        ACKWMOMessageRetourCodeQuery.TopNumberOfRows(1);
        ACKWMOMessageRetourCodeQuery.Open();

        if ACKWMOMessageRetourCodeQuery.Read() then begin
            ACKWMOMessageRetourCodeQuery.Close();
            exit(true);
        end;

        exit(false);
    end;

    /// <summary>
    /// HeaderContainsRetourCodeInvalid.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure HeaderContainsRetourCodeInvalid(WMOHeader: Record ACKWMOHeader): Boolean
    var
        MessageRetourCodeQuery: Query ACKWMOMessageRetourCodeQuery;
    begin
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.HeaderId, WMOHeader.SystemId);
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.RefId, WMOHeader.SystemId);
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.MessageInvalid, true);

        if MessageRetourCodeQuery.Open() and MessageRetourCodeQuery.Read() then
            exit(true);
        exit(false);
    end;

    /// <summary>
    /// ContainsInvalidRetourCodeFull.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure ContainsInvalidRetourCodeFull(WMOHeader: Record ACKWMOHeader): Boolean
    var
        MessageRetourCodeQuery: Query ACKWMOMessageRetourCodeQuery;
    begin
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.HeaderId, WMOHeader.SystemId);
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.MessageInvalid, true);

        if MessageRetourCodeQuery.Open() and MessageRetourCodeQuery.Read() then
            exit(true);
        exit(false);
    end;

    /// <summary>
    /// HasRetourCode.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    /// <param name="RetourCode">Enum ACKRetourCode.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure HasRetourCode(WMOHeader: Record ACKWMOHeader; RetourCode: Enum ACKRetourCode): Boolean
    var
        MessageRetourCodeQuery: Query ACKWMOMessageRetourCodeQuery;
    begin
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.HeaderId, WMOHeader.SystemId);
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.RetourCodeId, Format(RetourCode));

        if MessageRetourCodeQuery.Open() and MessageRetourCodeQuery.Read() then
            exit(true);
        exit(false);
    end;

    /// <summary>
    /// HasRetourCode.
    /// </summary>
    /// <param name="HeaderId">Guid.</param>
    /// <param name="TableRelationNo">Integer.</param>
    /// <param name="RefId">Guid.</param>
    /// <param name="RetourCode">Code[4].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure HasRetourCode(HeaderId: Guid; TableRelationNo: Integer; RefId: Guid; RetourCode: Enum ACKRetourCode): Boolean
    var
        MessageRetourCodeQuery: Query ACKWMOMessageRetourCodeQuery;
    begin
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.HeaderId, HeaderId);
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.RelationTableNo, TableRelationNo);
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.RefId, RefId);
        MessageRetourCodeQuery.SetRange(MessageRetourCodeQuery.RetourCodeId, Format(RetourCode));

        if MessageRetourCodeQuery.Open() and MessageRetourCodeQuery.Read() then
            exit(true);
        exit(false);
    end;

    /// <summary>
    /// TR081Check.
    /// </summary>
    /// <param name="IndicationProductCode">Text[5].</param>
    /// <param name="ProductCode">Text[5].</param>
    /// <param name="Category">Code[2].</param>
    /// <param name="HeaderId">Guid.</param>
    /// <param name="TableRelationNo">Integer.</param>
    /// <param name="RefId">Guid.</param>
    procedure TR081Check(IndicationProductCode: Text[5]; ProductCode: Text[5]; Category: Code[2]; HeaderId: Guid; TableRelationNo: Integer; RefId: Guid)
    var
        WMOProductCode: Record ACKProductCode;
    begin
        if ProductCode <> '' then begin
            //TR381
            if WMOProductCode.Get(ProductCode) then begin
                if WMOProductCode.CategoryID <> Category then
                    MessageRetourCode.InsertRetourCode(TableRelationNo, RefId, HeaderId, ACKWMORule::TR381);
            end else
                MessageRetourCode.InsertRetourCode(TableRelationNo, RefId, HeaderId, ACKWMORule::TR381);

            // Productcode van het start product moet gelijk zijn aan productcode indicatie.
            if IndicationProductCode <> ProductCode then begin
                MessageRetourCode.InsertRetourCode(TableRelationNo, RefId, HeaderId, ACKWMORule::SW020);
                exit;
            end;
        end;
    end;

    /// <summary>
    /// TR304_ExistingClient.
    /// </summary>
    /// <param name="WMOClient">VAR Record ACKWMOClient.</param>
    /// <param name="WMOHeader">VAR Record ACKWMOHeader.</param>
    /// <param name="ACKClient">VAR Record ACKClient.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure TR304_ExistingClient(var WMOClient: Record ACKWMOClient; var WMOHeader: Record ACKWMOHeader; var ACKClient: Record ACKClient) Found: Boolean
    begin
        Clear(ACKClient);

        ACKClient.SetRange(SSN, WMOClient.SSN);
        Found := ACKClient.FindFirst();

        if Found = false then
            MessageRetourCode.InsertRetourCode(Database::ACKWMOClient, WMOClient.SystemId, WMOHeader.SystemId, ACKWMORule::TR304);
    end;
}