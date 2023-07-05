/// <summary>
/// Codeunit ACKWMOGenerateRetour
/// </summary>
codeunit 50023 ACKWMOGenerateRetour
{
    TableNo = ACKWMOHeader;

    var
        FromWMOHeader, RetourHeader : Record ACKWMOHeader;
        SWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        RetourVektisCode: Enum ACKVektisCode;
        HasErrors: Boolean;

    trigger OnRun()
    var
        EmptyHeaderErr: label '%1 must not be empty.', Comment = '%1 = ACKWMOHeader';
        DuplicateRetourErr: Label 'Retour already exists with keys: %1, %2, %3', Comment = '%1 = Berichtcode, %2 = Afzender, %3 = Identificatie';
    begin
        FromWMOHeader := Rec;
        HasErrors := false;

        //Can only create a retour from an existing heen message
        if FromWMOHeader.IsEmpty() then
            Error(EmptyHeaderErr, FromWMOHeader.TableCaption());

        //Check if the passed WMOHeader has a retour Vektis code
        FromWMOHeader.GetRetourVektisCode(RetourVektisCode, true);

        //Check if retour message already exists before creating one.
        FromWMOHeader.GetRetourHeader(RetourHeader, false);

        RetourHeader.SetRange(RefHeaderId, FromWMOHeader.SystemId);
        if RetourHeader.FindFirst() then
            Error(DuplicateRetourErr, RetourVektisCode, FromWMOHeader.Afzender, FromWMOHeader.Identificatie);

        Clear(RetourHeader);

        Create();

        Commit();
        CheckAndCreateStUF();
    end;

    local procedure CheckAndCreateStUF()
    var
        ACKStUF: Record ACKStUF;
        ACKGenerateStuf: Codeunit ACKGenerateStuf;
    begin
        if not ACKStUF.Get(RetourHeader.Referentienummer) then
            ACKGenerateStuf.Run(RetourHeader);
    end;

    /// <summary>
    /// GetRetourHeader.
    /// </summary>
    /// <returns>Return value of type Record ACKWMOHeader.</returns>
    procedure GetRetourHeader(): Record ACKWMOHeader
    begin
        exit(RetourHeader);
    end;

    local procedure Create()
    begin
        //Create the retour header
        Clear(RetourHeader);
        RetourHeader.TransferFields(FromWMOHeader, false);
        RetourHeader.RefHeaderId := FromWMOHeader.SystemId;

        if RetourVektisCode = ACKVektisCode::wmo325 then begin
            RetourHeader.Afzender := FromWMOHeader.Ontvanger;
            RetourHeader.Ontvanger := FromWMOHeader.Afzender;
            RetourHeader.Identificatie := GetNextIdentificationNo();
            RetourHeader.Dagtekening := Today();
            RetourHeader.IdentificatieRetour := FromWMOHeader.Identificatie;
            RetourHeader.DagtekeningRetour := FromWMOHeader.Dagtekening;
        end
        else begin
            RetourHeader.IdentificatieRetour := GetNextIdentificationNo();
            RetourHeader.DagtekeningRetour := Today();
        end;

        RetourHeader.Status := ACKWMOHeaderStatus::New;
        RetourHeader.BerichtCode := RetourVektisCode;
        RetourHeader.Referentienummer := CreateGuid();
        RetourHeader.BasisschemaXsdVersieRetour := FromWMOHeader.BerichtXsdVersie;
        RetourHeader.BerichtXsdVersieRetour := FromWMOHeader.BerichtXsdVersie;
        RetourHeader.Insert(true);

        FromWMOHeader.RefHeaderId := RetourHeader.SystemId;

        //Retour codes
        CopyRetourCodes(Database::ACKWMOHeader, FromWMOHeader.SystemId, RetourHeader.SystemId);

        CopyClients();

        if (RetourVektisCode = ACKVektisCode::wmo325) then
            CopyDeclarationAnswer();
    end;

    local procedure CopyDeclarationAnswer()
    var
        FromDeclarationAnswer, WMODeclarationAnswerRetour : Record ACKWMODeclaratieAntwoord;
        WMODeclaratie: Record ACKWMODeclaratie;
        WMODeclaration: Codeunit ACKWMODeclarationHelper;
        TotalAmountSubmitted, TotalAmountAssigned : Integer;
        SubmittedDebitCredit, AssignedDebitCredit : Enum ACKDebitCredit;
    begin
        WMODeclaratie.Get(FromWMOHeader.SystemId);

        TotalAmountSubmitted := WMODeclaratie.TotaalBedrag;
        SubmittedDebitCredit := WMODeclaratie.DebitCredit;

        TotalAmountAssigned := WMODeclaration.GetTotalAmountDeclaredByDeclarationNo(FromWMOHeader.Afzender, WMODeclaratie.DeclaratieNummer);

        if TotalAmountAssigned >= 0 then
            AssignedDebitCredit := ACKDebitCredit::D
        else
            AssignedDebitCredit := ACKDebitCredit::C;

        WMODeclarationAnswerRetour.Init();
        WMODeclarationAnswerRetour.HeaderId := RetourHeader.SystemId;
        WMODeclarationAnswerRetour.DeclaratieNummer := WMODeclaratie.DeclaratieNummer;
        WMODeclarationAnswerRetour.IngediendDebitCredit := SubmittedDebitCredit;
        WMODeclarationAnswerRetour.IngediendTotaalBedrag := TotalAmountSubmitted;
        WMODeclarationAnswerRetour.ToegekendDebitCredit := AssignedDebitCredit;
        WMODeclarationAnswerRetour.ToegekendTotaalBedrag := Abs(TotalAmountAssigned);
        WMODeclarationAnswerRetour.Insert(true);

        //Retour codes
        CopyRetourCodes(Database::ACKWMODeclaratieAntwoord, FromDeclarationAnswer.SystemId, WMODeclarationAnswerRetour.SystemId)
    end;

    local procedure CopyClients()
    var
        FromWMOClient, WMOClientRetour : Record ACKWMOClient;
    begin
        FromWMOClient.SetRange(HeaderId, FromWMOHeader.SystemId);

        if FromWMOClient.FindSet(false) then
            repeat
                if ClientHasErrors(FromWMOClient) then begin
                    HasErrors := true;

                    Clear(WMOClientRetour);
                    WMOClientRetour.TransferFields(FromWMOClient, false);
                    WMOClientRetour.HeaderId := RetourHeader.SystemId;
                    WMOClientRetour.Insert(true);

                    //Retour codes
                    CopyRetourCodes(Database::ACKWMOClient, FromWMOClient.SystemId, WMOClientRetour.SystemId);

                    if RetourVektisCode = ACKVektisCode::wmo302 then begin
                        //Contact
                        CopyContacts(Database::ACKWMOClient, FromWMOClient.SystemId, WMOClientRetour.SystemId);

                        //Relations
                        CopyRelaties(FromWMOClient.SystemId, WMOClientRetour.SystemId);

                        //Assigned products
                        CopyToegewezenProducten(FromWMOClient.SystemId, WMOClientRetour.SystemId);
                    end;

                    if (RetourVektisCode = ACKVektisCode::wmo306) or (RetourVektisCode = ACKVektisCode::wmo308) then
                        //Start/Stop products
                        CopyStartStopProducten(FromWMOClient.SystemId, WMOClientRetour.SystemId);

                    if RetourVektisCode = ACKVektisCode::wmo318 then
                        //New/Changed/Unchanged products
                        CopyNewChangedUnchangedProducts(FromWMOClient.SystemId, WMOClientRetour.SystemId);

                    if RetourVektisCode = ACKVektisCode::wmo320 then
                        //Answer
                        CopyAntwoord();

                    if RetourVektisCode = ACKVektisCode::wmo325 then
                        CopyPrestaties(FromWMOClient.SystemId, WMOClientRetour.SystemId);
                end;
            until FromWMOClient.Next() = 0;
    end;

    local procedure CopyRetourCodes(RelationTableNo: Integer; FromRefId: Guid; ToRefId: Guid)
    var
        MessageRetourCodeLoc, MessageRetourCodeNew : Record ACKWMOMessageRetourCode;
    begin
        MessageRetourCodeLoc.SetCurrentKey(RelationTableNo, RefID);
        MessageRetourCodeLoc.SetRange(RelationTableNo, RelationTableNo);
        MessageRetourCodeLoc.SetRange(RefID, FromRefId);

        if MessageRetourCodeLoc.FindSet(false) then
            repeat
                Clear(MessageRetourCodeNew);
                MessageRetourCodeNew.Init();
                MessageRetourCodeNew.HeaderId := RetourHeader.SystemId;
                MessageRetourCodeNew.RelationTableNo := RelationTableNo;
                MessageRetourCodeNew.RefID := ToRefId;
                MessageRetourCodeNew.RetourCodeID := MessageRetourCodeLoc.RetourCodeID;
                MessageRetourCodeNew.Rule := MessageRetourCodeLoc.Rule;
                MessageRetourCodeNew.Insert(true);
            until MessageRetourCodeLoc.Next() = 0
        else
            //Declarations that have been fully approved must have retour code 8001. 
            //If one or more of the prestatie record has retour codes and no retourcode is present on the declaration record then it gets retourcode 0200.
            if (RelationTableNo = Database::ACKWMODeclaratieAntwoord) and not HasErrors then
                MessageRetourCodeNew.InsertRetourCode(RelationTableNo, ToRefId, RetourHeader.SystemId, ACKRetourCode::"8001")
            else
                MessageRetourCodeNew.InsertRetourCode(RelationTableNo, ToRefId, RetourHeader.SystemId, ACKRetourCode::"0200");
    end;

    local procedure CopyRelaties(FromClientId: Guid; ToClientId: Guid)
    var
        FromWMORelatie, WMORelatieRetour : Record ACKWMORelatie;
    begin
        //Relaties
        FromWMORelatie.SetRange(ClientID, FromClientId);

        if FromWMORelatie.FindSet(false) then
            repeat
                Clear(WMORelatieRetour);
                WMORelatieRetour.TransferFields(FromWMORelatie, false);
                WMORelatieRetour.ClientID := ToClientId;
                WMORelatieRetour.Insert(true);

                CopyRetourCodes(Database::ACKWMORelatie, FromWMORelatie.SystemId, WMORelatieRetour.SystemId);

                //Contact
                CopyContacts(Database::ACKWMORelatie, FromWMORelatie.SystemId, WMORelatieRetour.SystemId);
            until FromWMORelatie.Next() = 0;
    end;

    local procedure CopyContacts(RelationTableNo: Integer; FromRefIdId: Guid; ToRefId: Guid)
    var
        FromWMOContact, WMOContactRetour : Record ACKWMOContact;
    begin
        FromWMOContact.SetRange(RelationTableNo, RelationTableNo);
        FromWMOContact.SetRange(RefID, FromRefIdId);

        if FromWMOContact.FindSet(false) then
            repeat
                Clear(WMOContactRetour);
                WMOContactRetour.TransferFields(FromWMOContact, false);
                WMOContactRetour.RelationTableNo := RelationTableNo;
                WMOContactRetour.RefID := ToRefId;
                WMOContactRetour.Insert(true);

                CopyRetourCodes(Database::ACKWMOContact, FromWMOContact.SystemId, WMOContactRetour.SystemId);
            until FromWMOContact.Next() = 0;
    end;

    local procedure CopyToegewezenProducten(FromClientId: Guid; ToClientId: Guid)
    var
        FromWMOToegewezenProduct, WMOToegewezenProductRetour : Record ACKWMOToegewezenProduct;
    begin
        FromWMOToegewezenProduct.SetRange(ClientID, FromClientId);

        if FromWMOToegewezenProduct.FindSet(false) then
            repeat
                Clear(WMOToegewezenProductRetour);
                WMOToegewezenProductRetour.TransferFields(FromWMOToegewezenProduct, false);
                WMOToegewezenProductRetour.ClientID := ToClientId;
                WMOToegewezenProductRetour.Insert(true);

                CopyRetourCodes(Database::ACKWMOToegewezenProduct, FromWMOToegewezenProduct.SystemId, WMOToegewezenProductRetour.SystemId);
            until FromWMOToegewezenProduct.Next() = 0;
    end;

    local procedure CopyStartStopProducten(FromClientId: Guid; ToClientId: Guid)
    var
        FromWMOStartStopProduct, WMOToegewezenProductRetour : Record ACKWMOStartStopProduct;
    begin
        FromWMOStartStopProduct.SetRange(ClientId, FromClientId);

        if FromWMOStartStopProduct.FindSet(false) then
            repeat
                Clear(WMOToegewezenProductRetour);
                WMOToegewezenProductRetour.TransferFields(FromWMOStartStopProduct, false);
                WMOToegewezenProductRetour.ClientId := ToClientId;
                WMOToegewezenProductRetour.Insert(true);

                CopyRetourCodes(Database::ACKWMOStartStopProduct, FromWMOStartStopProduct.SystemId, WMOToegewezenProductRetour.SystemId);
            until FromWMOStartStopProduct.Next() = 0;
    end;

    local procedure CopyNewChangedUnchangedProducts(FromClientId: Guid; ToClientId: Guid)
    var
        FromNewChangedUnchangedProduct, NewChangedUnchangedProductRetour : Record ACKNewChangedUnchangedProduct;
    begin
        FromNewChangedUnchangedProduct.SetRange(ClientID, FromClientId);

        if FromNewChangedUnchangedProduct.FindSet(false) then
            repeat
                Clear(NewChangedUnchangedProductRetour);
                NewChangedUnchangedProductRetour.TransferFields(FromNewChangedUnchangedProduct, false);
                NewChangedUnchangedProductRetour.ClientID := ToClientId;
                NewChangedUnchangedProductRetour.Insert(true);

                CopyRetourCodes(Database::ACKNewChangedUnchangedProduct, FromNewChangedUnchangedProduct.SystemId, NewChangedUnchangedProductRetour.SystemId);
            until FromNewChangedUnchangedProduct.Next() = 0;
    end;

    local procedure CopyAntwoord()
    var
        FromWMOAntwoord, WMOAntwoordRetour : Record ACKWMOAntwoord;
    begin
        if FromWMOAntwoord.Get(FromWMOHeader.SystemId) then
            repeat
                Clear(WMOAntwoordRetour);
                WMOAntwoordRetour.TransferFields(FromWMOAntwoord, false);
                WMOAntwoordRetour.Insert(true);

                CopyRetourCodes(Database::ACKWMOAntwoord, FromWMOAntwoord.SystemId, WMOAntwoordRetour.SystemId);
            until FromWMOAntwoord.Next() = 0;
    end;

    local procedure CopyPrestaties(FromClientId: Guid; ToClientId: Guid)
    var
        FromWMOPrestatie, WMOPrestatieRetour : Record ACKWMOPrestatie;
    begin
        FromWMOPrestatie.SetRange(ClientID, FromClientId);

        if FromWMOPrestatie.FindSet(false) then
            repeat
                if HasInvalidRetourCode(Database::ACKWMOPrestatie, FromWMOPrestatie.SystemId) then begin
                    Clear(WMOPrestatieRetour);
                    WMOPrestatieRetour.TransferFields(FromWMOPrestatie, false);
                    WMOPrestatieRetour.ClientID := ToClientId;
                    WMOPrestatieRetour.Insert(true);

                    CopyRetourCodes(Database::ACKWMOPrestatie, FromWMOPrestatie.SystemId, WMOPrestatieRetour.SystemId);
                end;
            until FromWMOPrestatie.Next() = 0;
    end;

    local procedure ClientHasErrors(WMOClient: Record ACKWMOClient): Boolean
    begin
        //Client
        if HasInvalidRetourCode(Database::ACKWMOClient, WMOClient.SystemId) then
            exit(true);

        if RetourVektisCode = ACKVektisCode::wmo302 then begin
            //Contacts
            if ContactHasRetourCode(Database::ACKWMOClient, WMOClient.SystemId) then
                exit(true);

            //Relation
            if RelationHasRetourCode(WMOClient.SystemId) then
                exit(true);

            //Assigned product
            if ToegewezenProductHasRetourCode(WMOClient.SystemId) then
                exit(true);
        end;

        if (RetourVektisCode = ACKVektisCode::wmo306) or (RetourVektisCode = ACKVektisCode::wmo308) then
            //Start/Stop products
            if StartStopProductHasRetourCode(WMOClient.SystemId) then
                exit(true);

        if RetourVektisCode = ACKVektisCode::wmo318 then
            //New/Changed/Unchanged product
            if NewChangedUnchangedProductHasRetourCode(WMOClient.SystemId) then
                exit(true);

        if RetourVektisCode = ACKVektisCode::wmo320 then
            //Antwoord
            if AntwoordHasRetourCode() then
                exit(true);

        if RetourVektisCode = ACKVektisCode::wmo325 then
            //Prestatie
            if PrestatieHasRetourCode(WMOClient.SystemId) then
                exit(true);

        exit(false);
    end;

    local procedure ContactHasRetourCode(RelationTableNo: Integer; RefId: Guid) RetourCodeExists: Boolean
    var
        WMOContact: Record ACKWMOContact;
    begin
        WMOContact.SetRange(RelationTableNo, RelationTableNo);
        WMOContact.SetRange(RefID, RefId);

        if WMOContact.FindSet(false) then
            repeat
                RetourCodeExists := HasInvalidRetourCode(Database::ACKWMOContact, WMOContact.SystemId);
                if RetourCodeExists = true then
                    exit;
            until WMOContact.Next() = 0;
    end;

    local procedure RelationHasRetourCode(ClientId: Guid) RetourCodeExists: Boolean
    var
        WMORelatie: Record ACKWMORelatie;
    begin
        WMORelatie.SetRange(ClientID, ClientId);

        if WMORelatie.FindSet(false) then
            repeat
                RetourCodeExists := HasInvalidRetourCode(Database::ACKWMORelatie, WMORelatie.SystemId) and ContactHasRetourCode(Database::ACKWMORelatie, WMORelatie.SystemId);
                if RetourCodeExists = true then
                    exit;
            until WMORelatie.Next() = 0;
    end;

    local procedure ToegewezenProductHasRetourCode(ClientId: Guid) RetourCodeExists: Boolean
    var
        WMOToegewezenProduct: Record ACKWMOToegewezenProduct;
    begin
        WMOToegewezenProduct.SetRange(ClientID, ClientId);

        if WMOToegewezenProduct.FindSet(false) then
            repeat
                RetourCodeExists := HasInvalidRetourCode(Database::ACKWMOToegewezenProduct, WMOToegewezenProduct.SystemId);
                if RetourCodeExists = true then
                    exit;
            until WMOToegewezenProduct.Next() = 0;
    end;

    local procedure StartStopProductHasRetourCode(ClientId: Guid) RetourCodeExists: Boolean
    var
        WMOStartStopProduct: Record ACKWMOStartStopProduct;
    begin
        WMOStartStopProduct.SetRange(ClientId, ClientId);

        if WMOStartStopProduct.FindSet(false) then
            repeat
                RetourCodeExists := HasInvalidRetourCode(Database::ACKWMOStartStopProduct, WMOStartStopProduct.SystemId);
                if RetourCodeExists = true then
                    exit;
            until WMOStartStopProduct.Next() = 0;
    end;

    local procedure NewChangedUnchangedProductHasRetourCode(ClientId: Guid) RetourCodeExists: Boolean
    var
        NewChangedUnchangedProduct: Record ACKNewChangedUnchangedProduct;
    begin
        NewChangedUnchangedProduct.SetRange(ClientID, ClientId);

        if NewChangedUnchangedProduct.FindSet(false) then
            repeat
                RetourCodeExists := HasInvalidRetourCode(Database::ACKNewChangedUnchangedProduct, NewChangedUnchangedProduct.SystemId);
                if RetourCodeExists = true then
                    exit;
            until NewChangedUnchangedProduct.Next() = 0;
    end;

    local procedure AntwoordHasRetourCode() RetourCodeExists: Boolean
    var
        WMOAntwoord: Record ACKWMOAntwoord;
    begin
        WMOAntwoord.SetRange(HeaderId, FromWMOHeader.SystemId);

        if WMOAntwoord.FindSet(false) then
            repeat
                RetourCodeExists := HasInvalidRetourCode(Database::ACKWMOAntwoord, WMOAntwoord.SystemId);
                if RetourCodeExists = true then
                    exit;
            until WMOAntwoord.Next() = 0;
    end;

    local procedure PrestatieHasRetourCode(ClientId: Guid) RetourCodeExists: Boolean
    var
        WMOPrestatie: Record ACKWMOPrestatie;
    begin
        WMOPrestatie.SetRange(ClientID, ClientId);

        if WMOPrestatie.FindSet(false) then
            repeat
                RetourCodeExists := HasInvalidRetourCode(Database::ACKWMOPrestatie, WMOPrestatie.SystemId);
                if RetourCodeExists = true then
                    exit;
            until WMOPrestatie.Next() = 0;
    end;

    /// <summary>
    /// HasInvalidRetourCode.
    /// </summary>
    /// <param name="RelationTableNo">Integer.</param>
    /// <param name="RefId">Guid.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure HasInvalidRetourCode(RelationTableNo: Integer; RefId: Guid): Boolean
    var
        ACKWMOMessageRetourCodeQuery: Query ACKWMOMessageRetourCodeQuery;
    begin
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

    local procedure GetNextIdentificationNo(): Code[12]
    var
        WMOHeader: Record ACKWMOHeader;
        NoSeriesMgt: codeunit NoSeriesManagement;
        NewIdentificationNo: Code[12];
    begin
        SWVOGeneralSetup.Get();
        SWVOGeneralSetup.TestField(WMORetourIdentificationNos);

        repeat
            NewIdentificationNo := CopyStr(NoSeriesMgt.DoGetNextNo(SWVOGeneralSetup.WMORetourIdentificationNos, Today(), true, false), 1, 12);
            WMOHeader.SetRange(Identificatie, NewIdentificationNo);
            if WMOHeader.IsEmpty() then
                exit(NewIdentificationNo);
        until WMOHeader.IsEmpty();
    end;

    /// <summary>
    /// GenerateRetourDVS.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    procedure GenerateRetourDVS(WMOHeader: Record ACKWMOHeader)
    var
        Base64Convert: Codeunit "Base64 Convert";
        JsonExport: Codeunit ACKJsonExport;
        SWVOAPIHttpClient: Codeunit ACKSWVOAPHttpClient;
        JsonText: Text;
        InvalidTypeErr: Label 'Cannot create retour message from this type %1', Comment = '%1 = Vektiscode';
        EmptyRecordErr: Label 'Empty record', Locked = true;
    begin
        if WMOHeader.IsEmpty() then
            Error(EmptyRecordErr);

        if WMOHeader.IsRetour() then
            Error(InvalidTypeErr, WMOHeader.BerichtCode);

        JsonExport.Export(WMOHeader).WriteTo(JsonText);
        SWVOAPIHttpClient.Retour(Base64Convert.ToBase64(JsonText, TextEncoding::UTF8));
    end;
}