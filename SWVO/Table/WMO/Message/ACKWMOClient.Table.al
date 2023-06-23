/// <summary>
/// Table ACKWMOClient
/// </summary>
table 50002 ACKWMOClient
{
    Caption = 'Client', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = SSN, Voorletters, Voorvoegsel, Achternaam;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(20; HeaderId; Guid)
        {
            Caption = 'Header System Id', Locked = true;
            TableRelation = ACKWMOHeader.SystemId;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Rec.HeaderId);
            end;
        }
        field(30; SSN; Code[9])
        {
            NotBlank = true;
            Caption = 'SSN';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Rec.SSN);
            end;
        }
        field(40; Geboortedatum; Date)
        {
            Caption = 'Geboortedatum', Locked = true;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(50; GeboortedatumGebruik; enum ACKWMODatumGebruik)
        {
            Caption = 'Geboortedatum gebruik', Locked = true;
        }
        field(60; Geslacht; Enum ACKWMOGeslacht)
        {
            Caption = 'Geslacht', Locked = true;
            DataClassification = CustomerContent;
        }
        field(70; JuridischeStatus; Enum ACKWMOJuridischeStatus)
        {
            Caption = 'Juridische status', Locked = true;
            DataClassification = CustomerContent;
        }
        field(80; WettelijkeVertegenwoordiging; Enum ACKWMOWettelijkeVertegenwoordiging)
        {
            Caption = 'WettelijkeVertegenwoordiging', Locked = true;
            DataClassification = CustomerContent;
        }
        field(90; Voornamen; Text[200])
        {
            Caption = 'Voornamen', Locked = true;
            DataClassification = CustomerContent;
        }
        field(100; Voorletters; Code[6])
        {
            Caption = 'Voorletters', Locked = true;
            DataClassification = CustomerContent;
        }
        field(110; NaamGebruik; Enum ACKWMONaamGebruik)
        {
            Caption = 'Naam gebruik', Locked = true;
            DataClassification = CustomerContent;
        }
        field(120; Achternaam; Text[200])
        {
            Caption = 'Achternaam', Locked = true;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(130; Voorvoegsel; Text[10])
        {
            Caption = 'Voorvoegsel', Locked = true;
            DataClassification = CustomerContent;
        }
        field(140; PartnerAchternaam; Text[200])
        {
            Caption = 'Partner achternaam', Locked = true;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(150; PartnerVoorvoegsel; Text[10])
        {
            Caption = 'Partner voorvoegsel', Locked = true;
            DataClassification = CustomerContent;
        }
        field(160; CommunicatieVorm; Enum ACKWMOCommunicatievorm)
        {
            Caption = 'Communicatie vorm', Locked = true;
            DataClassification = CustomerContent;
        }
        field(170; CommunicatieTaal; Code[25])
        {
            Caption = 'Communicatie taal', Locked = true;
            DataClassification = CustomerContent;
        }
        field(180; Commentaar; Text[200])
        {
            Caption = 'Commentaar', Locked = true;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(Header; HeaderId)
        {
        }
        key(DataCaptionFields; SSN, Voorletters, Voorvoegsel, Achternaam)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMORelatie: Record ACKWMORelatie;
        ACKWMOContact: Record ACKWMOContact;
        ACKWMOToegewezenProduct: Record ACKWMOToegewezenProduct;
        ACKNewChangedUnchangedProduct: Record ACKNewChangedUnchangedProduct;
        ACKWMOStartStopProduct: Record ACKWMOStartStopProduct;
        ACKWMOPrestatie: Record ACKWMOPrestatie;
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMORelatie.SetCurrentKey(ClientID);
        ACKWMORelatie.SetRange(ClientID, Rec.SystemId);
        ACKWMORelatie.DeleteAll(true);

        ACKWMOContact.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOContact.SetRange(RelationTableNo, Database::ACKWMOClient);
        ACKWMOContact.SetRange(RefID, Rec.SystemId);
        ACKWMOContact.DeleteAll(true);

        ACKWMOToegewezenProduct.SetCurrentKey(ClientID);
        ACKWMOToegewezenProduct.SetRange(ClientID, Rec.SystemId);
        ACKWMOToegewezenProduct.DeleteAll(true);

        ACKNewChangedUnchangedProduct.SetCurrentKey(ClientID);
        ACKNewChangedUnchangedProduct.SetRange(ClientID, Rec.SystemId);
        ACKNewChangedUnchangedProduct.DeleteAll(true);

        ACKWMOStartStopProduct.SetCurrentKey(ClientId);
        ACKWMOStartStopProduct.SetRange(ClientId, Rec.SystemId);
        ACKWMOStartStopProduct.DeleteAll(true);

        ACKWMOPrestatie.SetCurrentKey(ClientID);
        ACKWMOPrestatie.SetRange(ClientID, Rec.SystemId);
        ACKWMOPrestatie.DeleteAll(true);

        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMOClient);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// Header.
    /// </summary>
    /// <returns>Return variable ACKWMOHeader of type Record ACKWMOHeader.</returns>
    procedure GetHeader() ACKWMOHeader: Record ACKWMOHeader
    begin
        ACKWMOHeader.GetBySystemId(Rec.HeaderId);
    end;

    /// <summary>
    /// FieldMapDictionary.
    /// Arrays in the object must be mapped with the tableId of the object inside the array.
    /// </summary>
    /// <param name="VektisCode">Enum ACKVektisCode.</param>
    /// <returns>Return variable Dict of type Dictionary of [Integer, Text].</returns>
    procedure FieldMapDictionary(VektisCode: Enum ACKVektisCode) Dict: Dictionary of [Integer, Text]
    begin
        Dict.Add(Rec.FieldNo(SSN), 'bsn');

        case VektisCode of
            ACKVektisCode::wmo317,
            ACKVektisCode::wmo318,
            ACKVektisCode::wmo323,
            ACKVektisCode::wmo325:
                exit(Dict);
        end;

        Dict.Add(Rec.FieldNo(Geboortedatum), 'geboortedatum.datum');
        Dict.Add(Rec.FieldNo(Geslacht), 'geslacht');
        Dict.Add(Rec.FieldNo(Achternaam), 'naam.geslachtsnaam.achternaam');
        Dict.Add(Rec.FieldNo(Voorvoegsel), 'naam.geslachtsnaam.voorvoegsel');

        Dict.Add(Rec.FieldNo(PartnerAchternaam), 'naam.partnernaam.achternaam');
        Dict.Add(Rec.FieldNo(PartnerVoorvoegsel), 'naam.partnernaam.voorvoegsel');

        Dict.Add(Rec.FieldNo(Voornamen), 'naam.voornamen');
        Dict.Add(Rec.FieldNo(Voorletters), 'naam.voorletters');

        case VektisCode of
            ACKVektisCode::wmo301,
            ACKVektisCode::wmo302:
                begin
                    Dict.Add(Rec.FieldNo(NaamGebruik), 'naam.naamGebruik');

                    Dict.Add(Rec.FieldNo(CommunicatieVorm), 'communicatie.vorm');
                    Dict.Add(Rec.FieldNo(CommunicatieTaal), 'communicatie.taal');

                    Dict.Add(Rec.FieldNo(JuridischeStatus), 'juridischeStatus');
                    Dict.Add(Rec.FieldNo(WettelijkeVertegenwoordiging), 'wettelijkeVertegenwoordiging');
                    Dict.Add(Rec.FieldNo(Commentaar), 'commentaar');
                end;
            ACKVektisCode::wmo315,
            ACKVektisCode::wmo316:
                Dict.Add(Rec.FieldNo(Commentaar), 'commentaar');
        end;
    end;
}
