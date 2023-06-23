/// <summary>
/// Table ACKWMOHeader (ID 50003).
/// </summary>
table 50004 ACKWMOHeader
{
    Caption = 'Header', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = BerichtCode, Afzender, Ontvanger, Identificatie;
    LookupPageId = ACKWMOHeaderList;
    DrillDownPageId = ACKWMOHeaderList;
    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
        field(10; BerichtCode; Enum ACKVektisCode)
        {
            Caption = 'Bericht code', Locked = true;
        }
        field(15; RefHeaderId; Guid)
        {
            Caption = 'Reference header System Id', Locked = true;
            TableRelation = ACKWMOHeader.SystemId;
            NotBlank = false;

            trigger OnValidate()
            var
                RefWMOHeader: Record ACKWMOHeader;
                ReferenceToSelfErr: Label 'Reference to self is not allowed.';
                InvalidRelationErr: Label 'Reference header not found.';
            begin
                if Rec.RefHeaderId = '' then
                    exit;

                if Rec.RefHeaderId = Rec.SystemId then
                    Error(ReferenceToSelfErr);

                TestField(Rec.RefHeaderId);

                if IsRetour() or (BerichtCode = ACKVektisCode::wmo325) then
                    RefWMOHeader.SetRange(BerichtCode, GetToVektisCode())
                else
                    RefWMOHeader.SetRange(BerichtCode, GetRetourVektisCode());

                RefWMOHeader.SetRange(RefHeaderId, Rec.RefHeaderId);
                if RefWMOHeader.IsEmpty() then begin
                    Rec.RefHeaderId := ACKHelper.NullGuid();
                    Error(InvalidRelationErr);
                end;
            end;
        }
        field(20; Afzender; Code[8])
        {
            Caption = 'Afzender Nr.', Locked = false;
            NotBlank = true;
            ValidateTableRelation = false;

            TableRelation =
            if (BerichtCode = const(wmo301)) Customer."No."
            else
            if (BerichtCode = const(wmo302)) Customer."No."
            else
            if (BerichtCode = const(wmo319)) Customer."No."
            else
            if (BerichtCode = const(wmo320)) Customer."No."
            else
            if (BerichtCode = const(wmo325)) Customer."No."
            else
            Vendor."No.";

            trigger OnValidate()
            begin
                TestField(Rec.Afzender);
            end;
        }
        field(30; Identificatie; Text[12])
        {
            Caption = 'Identificatie', Locked = true;

            trigger OnValidate()
            begin
                TestField(Rec.Identificatie);
            end;
        }
        field(40; Status; Enum ACKWMOHeaderStatus)
        {
            Caption = 'Status', Locked = true;
            InitValue = New;
        }
        field(50; Ontvanger; Code[8])
        {
            Caption = 'Ontvanger Nr.', Locked = true;

            ValidateTableRelation = false;
            TableRelation =
            if (BerichtCode = const(wmo301)) Vendor."No."
            else
            if (BerichtCode = const(wmo302)) Vendor."No."
            else
            if (BerichtCode = const(wmo319)) Vendor."No."
            else
            if (BerichtCode = const(wmo320)) Vendor."No."
            else
            if (BerichtCode = const(wmo325)) Vendor."No."
            else
            Customer."No.";

            trigger OnValidate()
            begin
                TestField(Rec.Ontvanger);
            end;
        }
        field(60; Dagtekening; Date)
        {
            Caption = 'Dagtekening', Locked = true;
        }
        field(70; BerichtVersie; Code[2])
        {
            Caption = 'Bericht versie', Locked = true;
            NotBlank = true;
        }
        field(80; BerichtSubversie; Code[2])
        {
            Caption = 'Bericht sub versie', Locked = true;
        }
        field(90; BasisschemaXsdVersie; Text[5])
        {
            Caption = 'Basisschema XSD versie', Locked = true;
        }
        field(100; BerichtXsdVersie; Text[5])
        {
            Caption = 'Bericht XSD versie', Locked = true;
        }
        field(110; BasisschemaXsdVersieRetour; Text[5])
        {
            Caption = 'Basisschema XSD versie retour', Locked = true;
        }
        field(120; BerichtXsdVersieRetour; Text[5])
        {
            Caption = 'Bericht XSD versie retour', Locked = true;
        }
        field(130; IdentificatieRetour; Text[12])
        {
            Caption = 'IdentificatieRetour', Locked = true;
        }
        field(140; DagtekeningRetour; Date)
        {
            Caption = 'DagtekeningRetour', Locked = true;
        }
        field(150; XsltVersie; Text[5])
        {
            Caption = 'XsltVersie', Locked = true;
        }
        field(160; Referentienummer; Guid)
        {
            Caption = 'Referentienummer', Locked = true;
            NotBlank = true;
            TableRelation = ACKStUF.Referentienummer;
            ValidateTableRelation = false;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(IdentificationKey; BerichtCode, Afzender, Identificatie)
        {
            Unique = false;
        }
        key(Referentienummer; Referentienummer)
        {
            Unique = true;
        }
        key(DataCaptionFields; BerichtCode, Afzender, Ontvanger, Identificatie)
        {
            Clustered = false;
        }
        key(Created; SystemCreatedAt)
        {
        }
    }

    trigger OnDelete()
    var
        WMOClient: Record ACKWMOClient;
        WMODeclaratie: Record ACKWMODeclaratie;
        WMODeclaratieAntwoord: Record ACKWMODeclaratieAntwoord;
        WMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        WMOClient.SetCurrentKey(HeaderId);
        WMOClient.SetRange(HeaderId, Rec.SystemId);
        WMOClient.DeleteAll(true);

        WMODeclaratie.SetCurrentKey(HeaderId);
        WMODeclaratie.SetRange(HeaderId, Rec.SystemId);
        WMODeclaratie.DeleteAll(true);

        WMODeclaratieAntwoord.SetCurrentKey(HeaderId);
        WMODeclaratieAntwoord.SetRange(HeaderId, Rec.SystemId);
        WMODeclaratieAntwoord.DeleteAll(true);

        WMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        WMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMOHeader);
        WMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        WMOMessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// IsRetour.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure IsRetour(): Boolean
    begin
        case Rec.BerichtCode of
            ACKVektisCode::wmo302,
            ACKVektisCode::wmo306,
            ACKVektisCode::wmo308,
            ACKVektisCode::wmo316,
            ACKVektisCode::wmo318,
            ACKVektisCode::wmo320,
            ACKVektisCode::wmo325:
                exit(true);
        end;
        exit(false);
    end;

    /// <summary>
    /// AfzenderName.
    /// </summary>
    /// <returns>Return value of type Text[100].</returns>
    procedure AfzenderName(): Text[100]
    begin
        exit(ACKHelper.GetCustVendName(Rec, Rec.FieldNo(Afzender)));
    end;

    /// <summary>
    /// AfzenderCaption.
    /// </summary>
    /// <returns>Return variable Caption of type Text[35].</returns>
    procedure AfzenderCaption() Caption: Text[35]
    var
        Relation: Integer;
    begin
        //Relation is table number of customer or vendor
        Relation := ACKHelper.GetRelation(Rec, Rec.FieldNo(Rec.Afzender));
        Caption := GetRelationCaption(Relation);
    end;

    /// <summary>
    /// OntvangerCaption.
    /// </summary>
    /// <returns>Return variable Caption of type Text[35].</returns>
    procedure OntvangerCaption() Caption: Text[35]
    var
        Relation: Integer;
    begin
        //Relation is table number of customer or vendor
        Relation := ACKHelper.GetRelation(Rec, Rec.FieldNo(Rec.Ontvanger));
        Caption := GetRelationCaption(Relation);
    end;

    local procedure GetRelationCaption(Relation: Integer) Caption: Text[21]
    var
        InvalidRelationErr: Label 'Invalid relation';
    begin
        case Relation of
            Database::Customer:
                Caption := 'Municipality';
            Database::Vendor:
                Caption := 'Healthcare provider';
            else
                Error(InvalidRelationErr);
        end;
    end;

    /// <summary>
    /// OntvangerName.
    /// </summary>
    /// <returns>Return value of type Text[100].</returns>
    procedure OntvangerName(): Text[100]
    begin
        exit(ACKHelper.GetCustVendName(Rec, Rec.FieldNo(Ontvanger)));
    end;

    /// <summary>
    /// SetStatus.
    /// </summary>
    /// <param name="_Status">Enum ACKWMOHeaderStatus.</param>
    procedure SetStatus(_Status: Enum ACKWMOHeaderStatus)
    begin
        Rec.Status := _Status;
        Rec.Modify(true);
    end;

    /// <summary>
    /// GetHeader.
    /// </summary>
    /// <param name="WMOHeaderBericht">VAR Record ACKWMOHeader.</param>
    /// <param name="VektisCode">Enum ACKVektisCode.</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetHeader(var WMOHeaderBericht: Record ACKWMOHeader; VektisCode: Enum ACKVektisCode; ThrowError: Boolean) Found: Boolean
    var
        NotFoundErr: Label 'Message not found: %1, %2, %3', Comment = '%1 = Vektis code, %2 = Afzender, %3 = Identification';
    begin
        //If the field RefHeaderId has a value the relation is set.
        if not IsNullGuid(Rec.RefHeaderId) then begin
            WMOHeaderBericht.SetRange(SystemId, Rec.RefHeaderId);
            Found := WMOHeaderBericht.FindFirst();
            exit;
        end;

        WMOHeaderBericht.SetCurrentKey(BerichtCode, Afzender, Identificatie, Status);
        WMOHeaderBericht.SetAscending(Status, false);
        WMOHeaderBericht.SetFilter(SystemId, '<>%1', Rec.SystemId);
        WMOHeaderBericht.SetRange(BerichtCode, VektisCode);

        if VektisCode = VektisCode::wmo323 then begin
            WMOHeaderBericht.SetRange(Afzender, Rec.Ontvanger);
            WMOHeaderBericht.SetRange(Identificatie, Rec.IdentificatieRetour);
        end
        else begin
            WMOHeaderBericht.SetRange(Afzender, Rec.Afzender);
            WMOHeaderBericht.SetRange(Identificatie, Rec.Identificatie);
        end;

        Found := WMOHeaderBericht.FindFirst();

        if not Found and ThrowError then
            Error(NotFoundErr, Rec.BerichtCode, Rec.Afzender, Rec.Identificatie);

        if Found then
            Rec.RefHeaderId := WMOHeaderBericht.SystemId;
    end;

    /// <summary>
    /// GetToHeader.
    /// </summary>
    /// <param name="WMOHeaderHeen">VAR Record ACKWMOHeader.</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetToHeader(var WMOHeaderHeen: Record ACKWMOHeader; ThrowError: Boolean) Found: Boolean
    var
        HeenVektisCode: Enum ACKVektisCode;
    begin
        HeenVektisCode := GetToVektisCode();
        Found := GetHeader(WMOHeaderHeen, HeenVektisCode, ThrowError);
    end;

    /// <summary>
    /// GetRetourHeader.
    /// </summary>
    /// <param name="WMOHeaderRetour">VAR Record ACKWMOHeader.</param>
    /// <param name="ThrowError">Boolean.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetRetourHeader(var WMOHeaderRetour: Record ACKWMOHeader; ThrowError: Boolean) Found: Boolean
    var
        RetourVektisCode: Enum ACKVektisCode;
    begin
        RetourVektisCode := GetRetourVektisCode();
        Found := GetHeader(WMOHeaderRetour, RetourVektisCode, ThrowError);
    end;

    /// <summary>
    /// GetRetourVektisCode.
    /// </summary>
    /// <returns>Return variable RetourVektisCode of type Enum ACKVektisCode.</returns>
    procedure GetRetourVektisCode(): Enum ACKVektisCode
    var
        InvalidCodeErr: Label 'No retour vektis code exists for vektis code: %1', Comment = '%1 = ACKVektisCode';
    begin
        case Rec.BerichtCode of
            ACKVektisCode::wmo301,
            ACKVektisCode::wmo305,
            ACKVektisCode::wmo307,
            ACKVektisCode::wmo315,
            ACKVektisCode::wmo317,
            ACKVektisCode::wmo319,
            ACKVektisCode::wmo401,
            ACKVektisCode::wmo403:
                exit(ACKVektisCode.FromInteger(Rec.BerichtCode.AsInteger() + 1));
            ACKVektisCode::wmo323:
                exit(ACKVektisCode::wmo325);
            else
                Error(InvalidCodeErr, Rec.BerichtCode);
        end;
    end;

    /// <summary>
    /// GetToVektisCode.
    /// </summary>
    /// <returns>Return value of type Enum ACKVektisCode.</returns>
    procedure GetToVektisCode(): Enum ACKVektisCode
    var
        InvalidCodeErr: Label 'No forward vektis code exists for vektis code: %1', Comment = '%1 = ACKVektisCode';
    begin
        case Rec.BerichtCode of
            ACKVektisCode::wmo302,
            ACKVektisCode::wmo306,
            ACKVektisCode::wmo308,
            ACKVektisCode::wmo316,
            ACKVektisCode::wmo318,
            ACKVektisCode::wmo320,
            ACKVektisCode::wmo402,
            ACKVektisCode::wmo404:
                exit(ACKVektisCode.FromInteger(Rec.BerichtCode.AsInteger() - 1));
            ACKVektisCode::wmo325:
                exit(ACKVektisCode::wmo323);
            else
                Error(InvalidCodeErr, Rec.BerichtCode);
        end;
    end;

    /// <summary>
    /// ReturnStatus.
    /// </summary>
    /// <returns>Return value of type Enum ACKWMOHeaderStatus.</returns>
    procedure ReturnStatus() RStatus: Enum ACKWMOHeaderStatus
    var
        WMOHeaderRetour: Record ACKWMOHeader;
    begin
        RStatus := ACKWMOHeaderStatus::NVT;
        if not Rec.IsEmpty() then
            if not Rec.IsRetour() and not (Rec.BerichtCode = ACKVektisCode::wmo325) then
                if GetRetourHeader(WMOHeaderRetour, false) then
                    exit(WMOHeaderRetour.Status);
    end;

    /// <summary>
    /// LeadTime.
    /// </summary>
    /// <returns>Return variable Duration of type Duration.</returns>
    procedure LeadTime() Duration: Duration
    var
        WMOHeaderRelated: Record ACKWMOHeader;
    begin
        if Rec.IsRetour() then
            GetToHeader(WMOHeaderRelated, false)
        else
            GetRetourHeader(WMOHeaderRelated, false);

        if IsNullGuid(WMOHeaderRelated.SystemId) then
            exit;

        Duration := Abs(Rec.SystemCreatedAt - WMOHeaderRelated.SystemCreatedAt);
    end;

    var
        ACKHelper: codeunit ACKHelper;
}
