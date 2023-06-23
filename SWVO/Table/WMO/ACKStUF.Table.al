/// <summary>
/// This table wil be mapped with a StUF Di01 message and therefore will be using Dutch names.
/// Table ACKStUFDi01 (ID 50017).
/// </summary>
table 50017 ACKStUF
{
    Caption = 'StUF', Locked = true;
    DataClassification = CustomerContent;
    fields
    {
        field(10; Berichtcode; Enum ACKStUFBerichtCode)
        {
            Caption = 'Berichtcode', Locked = true;
            NotBlank = true;
        }
        field(20; ZenderOrganisatie; Code[8])
        {
            Caption = 'Zender organisatie', Locked = true;
            NotBlank = true;
        }
        field(30; ZenderApplicatie; Text[60])
        {
            Caption = 'Zender applicatie', Locked = true;
            NotBlank = true;
        }
        field(40; ZenderAdministratie; Text[60])
        {
            Caption = 'Zender administratie', Locked = true;
        }
        field(50; ZenderGebruiker; Text[30])
        {
            Caption = 'Zender gebruiker', Locked = true;
        }
        field(60; OntvangerOrganisatie; Code[8])
        {
            Caption = 'Ontvanger organisatie', Locked = true;
            NotBlank = true;
        }
        field(70; OntvangerApplicatie; Text[60])
        {
            Caption = 'Ontvanger applicatie', Locked = true;
            NotBlank = true;
        }
        field(80; OntvangerAdministratie; Text[60])
        {
            Caption = 'Ontvanger administratie', Locked = true;
        }
        field(90; OntvangerGebruiker; Text[30])
        {
            Caption = 'Ontvanger gebruiker', Locked = true;
        }
        field(100; Referentienummer; Guid)
        {
            Caption = 'Referentienummer', Locked = true;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.Referentienummer);
            end;
        }
        field(110; TijdstipBericht; Code[14])
        {
            Caption = 'Tijdstip bericht', Locked = true;
            NotBlank = true;
        }
        field(120; CrossRefnummer; Guid)
        {
            Caption = 'Cross referentienummer', Locked = true;
            NotBlank = true;
        }
        field(130; Functie; Enum ACKVektisCode)
        {
            Caption = 'Functie', Locked = true;
            NotBlank = true;
        }
        field(140; ApplicatieVersie; Code[4])
        {
            Caption = 'Applicatie versie', Locked = true;
            NotBlank = true;
        }
        field(150; ApplicatieSubversie; Code[4])
        {
            Caption = 'Applicatie subversie', Locked = true;
            NotBlank = true;
        }
        field(160; FunctieVersie; Code[4])
        {
            Caption = 'Functie versie', Locked = true;
            NotBlank = true;
        }
        field(170; FunctieSubversie; Code[4])
        {
            Caption = 'Functie sub versie', Locked = true;
            NotBlank = true;
        }
        field(180; BerichtXml; Blob)
        {
            Caption = 'Bericht xml', Locked = true;
        }
        field(190; BerichtJson; Blob)
        {
            Caption = 'Bericht json', Locked = true;
        }
        field(200; Status; Enum ACKJobStatus)
        {
            Caption = 'Status', Locked = true;
        }
        field(210; Foutcode; Text[10])
        {
            Caption = 'Foutcode', Locked = true;
        }
        field(220; Plek; Option)
        {
            OptionMembers = client,server;
            Caption = 'Plek', Locked = true;
        }
        field(230; Omschrijving; Text[250])
        {
            Caption = 'Omschrijving', Locked = true;
        }
        field(240; Details; Text[15])
        {
            Caption = 'Details', Locked = true;
        }
    }

    keys
    {
        key(PK; Referentienummer)
        {
            Clustered = true;
        }
        key(SortKey; SystemCreatedAt)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMOHeader: Record ACKWMOHeader;
    begin
        ACKWMOHeader.SetCurrentKey(Referentienummer);
        ACKWMOHeader.SetRange(Referentienummer, Rec.Referentienummer);
        ACKWMOHeader.DeleteAll(true);
    end;

    /// <summary>
    /// GetXML.
    /// </summary>
    /// <returns>Return variable XML of type Text.</returns>
    procedure GetXML() XML: Text
    var
        Base64Convert: codeunit "Base64 Convert";
        Base64Text: Text;
        InStreamBase64Bytes: InStream;
    begin
        if not Rec.BerichtXml.HasValue() then
            exit;

        Rec.CalcFields(BerichtXml);
        Rec.BerichtXml.CreateInStream(InStreamBase64Bytes, TextEncoding::UTF8);
        Base64Text := Base64Convert.ToBase64(InStreamBase64Bytes);
        XML := Base64Convert.FromBase64(Base64Text);
    end;

    /// <summary>
    /// TryGetJsonObject.
    /// </summary>
    /// <param name="JsonObject">VAR JsonObject.</param>
    [TryFunction]
    procedure TryGetJsonObject(var JsonObject: JsonObject)
    var
        Base64Convert: codeunit "Base64 Convert";
        Base64Text: Text;
        InStreamBase64Bytes: InStream;
        JsonText: Text;
        EmptyJSONErr: Label 'JSON message is empty.';
        JSONParseErr: Label 'Cannot parse text %1 to JSON object.', Comment = '%1 = JSON text';
    begin
        if not Rec.BerichtJson.HasValue() then
            Error(EmptyJSONErr);

        Rec.CalcFields(BerichtJson);
        Rec.BerichtJson.CreateInStream(InStreamBase64Bytes, TextEncoding::UTF8);
        Base64Text := Base64Convert.ToBase64(InStreamBase64Bytes);
        JsonText := Base64Convert.FromBase64(Base64Text);

        if not JsonObject.ReadFrom(JsonText) then
            Error(JSONParseErr, JsonText);
    end;

    /// <summary>
    /// CrossReferenceExists.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure CrossReferenceExists(): Boolean
    var
        ACKStUFHeen: Record ACKStUF;
    begin
        if Rec.Berichtcode = ACKStufBerichtCode::Du01 then begin
            ACKStUFHeen.SetFilter(SystemId, '<>%1', Rec.SystemId);
            ACKStUFHeen.SetFilter(Referentienummer, '=%1', Rec.CrossRefnummer);

            exit(not ACKStUFHeen.IsEmpty());
        end;

        exit(true);
    end;

    /// <summary>
    /// SetDefaultFields.
    /// </summary>
    procedure SetDefaultFields()
    begin
        SWVOGeneralSetup.Get();
        Rec.ApplicatieVersie := SWVOGeneralSetup.StufApplicationVersion;
        Rec.ApplicatieSubversie := SWVOGeneralSetup.StufApplicationSubVersion;
        Rec.FunctieVersie := SWVOGeneralSetup.StufFunctionVersion;
        Rec.FunctieSubversie := SWVOGeneralSetup.StufFunctionSubVersion;
        Rec.Details := StrSubstNo(DetailsLbl, Rec.Functie, SWVOGeneralSetup.StufApplicationVersion, SWVOGeneralSetup.StufApplicationSubVersion);
        Rec.TijdstipBericht := Format(CurrentDateTime(), 14, '<Year4><Month><Day,2><Hours24,2><Minutes,2><Seconds,2>');
        Rec.ZenderApplicatie := CopyStr(CompanyName(), 1, 60);
    end;

    var
        SWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        DetailsLbl: Label '%1-%2%3', Comment = '%1 = function, %2 = application version, %3 = application sub version', MaxLength = 15, Locked = true;
}
