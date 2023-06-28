/// <summary>
/// Codeunit ACKWMOProcessor302.
/// </summary>
codeunit 50014 ACKWMOProcessor302 implements ACKWMOIProcessor
{
    var
        WMOHeader302, WMOHeader301 : Record ACKWMOHeader;
        Client: Record ACKClient;
        MessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOProcessor: codeunit ACKWMOProcessor;

    /// <summary>
    /// ParmHeader.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    procedure Init(var WMOHeader: Record ACKWMOHeader)
    begin
        WMOHeader302 := WMOHeader;
    end;

    /// <summary>
    /// Process.
    /// </summary>
    procedure Process()
    begin
        WMOProcessor.ValidateProcessStatus(WMOHeader302);

        if Validate() then
            ProcessClient();

        WMOProcessor.Send(WMOHeader302);
        WMOHeader302.Modify(true);
    end;

    /// <summary>
    /// Validate.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure Validate() IsValid: Boolean
    begin
        IsValid := ValidateLoc();

        if IsValid then
            WMOHeader302.SetStatus(ACKWMOHeaderStatus::Valid)
        else
            WMOHeader302.SetStatus(ACKWMOHeaderStatus::Invalid);
    end;

    local procedure ValidateLoc(): Boolean
    begin
        if not WMOProcessor.ValidateHeader(WMOHeader302, ACKVektisCode::wmo302) then
            exit(false);

        WMOHeader302.GetToHeader(WMOHeader301, true);

        if WMOProcessor.ContainsInvalidRetourCodeFull(WMOHeader302) then
            exit(false);

        exit(true);
    end;

    local procedure ProcessClient()
    var
        WMOClient: Record ACKWMOClient;
        WMOToegewezenProduct: Record ACKWMOToegewezenProduct;
        ACKWMOContact: Record ACKWMOContact;
    begin
        WMOClient.SetRange(HeaderId, WMOHeader301.SystemId);
        WMOClient.FindFirst();

        //Create or update the cliënt
        CreateOrUpdateClient(WMOClient, Client);

        //Contacts
        ACKWMOContact.SetCurrentKey(Soort);
        ACKWMOContact.SetRange(RelationTableNo, Database::ACKWMOClient);
        ACKWMOContact.SetRange(RelationTableNo, Database::ACKWMOClient);
        ACKWMOContact.SetRange(RefID, WMOClient.SystemId);
        ACKWMOContact.SetAscending(Soort, true);

        if ACKWMOContact.FindSet() then
            repeat
                ProcessContact(ACKWMOContact);
            until ACKWMOContact.Next() = 0;

        //Relations - ToDo what to do do with relations?

        //Assigned products
        WMOToegewezenProduct.SetRange(ClientID, WMOClient.SystemId);
        if WMOToegewezenProduct.FindSet() then
            repeat
                ProcessToegewezenProduct(WMOToegewezenProduct);
            until WMOToegewezenProduct.Next() = 0;
    end;

    local procedure ProcessContact(ACKWMOContact: Record ACKWMOContact)
    var
        ACKClientAddress: Record ACKClientAddress;
        FromDate, ToDate : Date;
    begin
        if ACKWMOContact.Soort = ACKWMOAdresSoort::TijdelijkVerblijf then begin
            FromDate := ACKWMOContact.Begindatum;
            ToDate := ACKWMOContact.Einddatum;
        end
        else begin
            FromDate := WMOHeader301.Dagtekening;
            ToDate := 0D;
        end;

        ACKClientAddress.Init();
        ACKClientAddress.ClientNo := Client.ClientNo;
        ACKClientAddress.Purpose := ACKWMOContact.Soort;
        ACKClientAddress.ValidFrom := FromDate;
        ACKClientAddress.ValidTo := ToDate;
        ACKClientAddress.PostCode := ACKWMOContact.Postcode;
        ACKClientAddress.HouseNumber := ACKWMOContact.Huisnummer;
        ACKClientAddress.HouseLetter := ACKWMOContact.Huisletter;
        ACKClientAddress.HouseNumberAddition := ACKWMOContact.HuisnummerToevoeging;
        ACKClientAddress.Street := ACKWMOContact.Straatnaam;
        ACKClientAddress."Place of residence" := ACKWMOContact.Plaatsnaam;
        ACKClientAddress."Country/Region Code" := ACKWMOContact.LandCode;
        ACKClientAddress.Designation := ACKWMOContact.AanduidingWoonadres;
        ACKClientAddress.EmailAddress := ACKWMOContact.Emailadres;
        ACKClientAddress.Organisation := ACKWMOContact.Organisatie;

        ACKClientAddress.InsertOrUpdate();
    end;

    local procedure ProcessToegewezenProduct(WMOToegewezenProduct: Record ACKWMOToegewezenProduct)
    ACKWMOIndication: Record ACKWMOIndication;
    begin
        ACKWMOIndication.SetCurrentKey(MunicipalityNo, AssignmentNo);
        ACKWMOIndication.SetRange(MunicipalityNo, WMOHeader301.Afzender);
        ACKWMOIndication.SetRange(AssignmentNo, WMOToegewezenProduct.ToewijzingNummer);

        if ACKWMOIndication.FindFirst() then begin
            ACKWMOIndication.EndDate := WMOToegewezenProduct.Einddatum;
            ACKWMOIndication.RedenWijziging := WMOToegewezenProduct.RedenWijziging;
            ACKWMOIndication.Modify(true);
        end
        else begin
            ACKWMOIndication.Init();
            ACKWMOIndication.AssignmentNo := WMOToegewezenProduct.ToewijzingNummer;
            ACKWMOIndication.MunicipalityNo := WMOHeader301.Afzender;
            ACKWMOIndication.ClientNo := Client.ClientNo;
            ACKWMOIndication.ProductCategoryId := WMOToegewezenProduct.ProductCategorie;
            ACKWMOIndication.ProductCode := WMOToegewezenProduct.ProductCode;
            ACKWMOIndication.HealthcareProviderNo := WMOHeader301.Ontvanger;
            ACKWMOIndication.AssignedDateTime := CreateDateTime(WMOToegewezenProduct.Toewijzingsdatum, WMOToegewezenProduct.Toewijzingstijd);
            ACKWMOIndication.StartDate := WMOToegewezenProduct.Ingangsdatum;
            ACKWMOIndication.EndDate := WMOToegewezenProduct.Einddatum;
            ACKWMOIndication.ProductFrequency := WMOToegewezenProduct.Frequentie;
            ACKWMOIndication.ProductVolume := WMOToegewezenProduct.Volume;
            ACKWMOIndication.ProductUnit := WMOToegewezenProduct.Eenheid;
            ACKWMOIndication.Budget := WMOToegewezenProduct.Budget;
            ACKWMOIndication.Insert(true);
        end;

    end;

    /// <summary>
    /// CreateOrUpdateClient.
    /// </summary>
    /// <param name="WMOClient">Record ACKWMOClient.</param>
    /// <param name="ACKClient">VAR Record ACKClient.</param>
    procedure CreateOrUpdateClient(WMOClient: Record ACKWMOClient; var ACKClient: Record ACKClient)
    begin
        ACKClient.SetCurrentKey(SSN);
        ACKClient.SetRange(SSN, WMOClient.SSN);

        if ACKClient.FindFirst() then begin
            SetClientFields(WMOClient, ACKClient);
            ACKClient.Modify(true);
        end
        else begin
            ACKClient.Init();
            ACKClient.SSN := WMOClient.SSN;
            SetClientFields(WMOClient, ACKClient);
            ACKClient.Insert(true);
        end;
    end;

    local procedure SetClientFields(WMOClient: Record ACKWMOClient; var ACKClient: Record ACKClient)
    begin
        ACKClient."First Name" := CopyStr(WMOClient.Voornamen, 1, MaxStrLen(ACKClient."First Name"));
        ACKClient.Initials := WMOClient.Voorletters;
        ACKClient."Middle Name" := WMOClient.Voorvoegsel;
        ACKClient.Surname := CopyStr(WMOClient.Achternaam, 1, MaxStrLen(ACKClient.Surname));
        ACKClient.Gender := WMOClient.Geslacht;
        ACKClient.Birthdate := WMOClient.Geboortedatum;
    end;

}
