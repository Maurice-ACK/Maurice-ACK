/// <summary>
/// Table ACKWMORelatie (ID 50057).
/// </summary>
table 50025 ACKWMORelatie
{
    Caption = 'Relatie', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = Nummer, Soort, Voorletters, Voorvoegsel, Achternaam;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
        field(20; ClientID; Guid)
        {
            Caption = 'Client System ID', Locked = true;
            TableRelation = ACKWMOClient.SystemId;

            trigger OnValidate()
            begin
                TestField(Rec.ClientID);
            end;
        }
        field(30; Nummer; Text[20])
        {
            Caption = 'Relatie Nr.', Locked = true;

            trigger OnValidate()
            begin
                TestField(Rec.Nummer);
            end;
        }
        field(40; Volgorde; Integer)
        {
            Caption = 'Volgorde', Locked = true;
        }
        field(50; Soort; Enum ACKWMOSoortRelatie)
        {
            Caption = 'Soort', Locked = true;

            trigger OnValidate()
            begin
                TestField(Rec.Soort);
            end;
        }
        field(60; Geboortedatum; Date)
        {
            Caption = 'Geboortedatum', Locked = true;
            NotBlank = true;
        }
        field(70; GeboortedatumGebruik; enum ACKWMODatumGebruik)
        {
            Caption = 'Geboortedatum gebruik', Locked = true;
        }
        field(80; Geslacht; Enum ACKWMOGeslacht)
        {
            Caption = 'Geslacht', Locked = true;
        }
        field(90; Achternaam; Text[200])
        {
            Caption = 'Achternaam', Locked = true;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.Achternaam);
            end;
        }
        field(100; Voorvoegsel; Text[10])
        {
            Caption = 'Voorvoegsel', Locked = true;
        }
        field(110; PartnerAchternaam; Text[200])
        {
            Caption = 'Partner achternaam', Locked = true;
            NotBlank = true;
        }
        field(120; PartnerVoorvoegsel; Text[10])
        {
            Caption = 'Partner voorvoegsel', Locked = true;
        }
        field(130; Voornamen; Text[200])
        {
            Caption = 'Voornamen', Locked = true;
        }
        field(140; Voorletters; Code[6])
        {
            Caption = 'Voorletters', Locked = true;
        }
        field(150; NaamGebruik; Enum ACKWMONaamGebruik)
        {
            Caption = 'Naam gebruik', Locked = true;
        }

    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(ClientId; ClientID)
        {
        }
        key(Volgorde; Volgorde)
        {
        }

        key(DataCaptionFields; Nummer, Soort, Voorletters, Voorvoegsel, Achternaam)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMOContact: Record ACKWMOContact;
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMOContact.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOContact.SetRange(RelationTableNo, Database::ACKWMORelatie);
        ACKWMOContact.SetRange(RefID, Rec.SystemId);
        ACKWMOContact.DeleteAll(true);

        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMORelatie);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// FieldMapDictionary.
    /// </summary>
    /// <returns>Return variable Dict of type Dictionary of [Integer, Text].</returns>
    procedure FieldMapDictionary() Dict: Dictionary of [Integer, Text]
    begin
        Dict.Add(Rec.FieldNo(Nummer), 'nummer');
        Dict.Add(Rec.FieldNo(Volgorde), 'volgorde');
        Dict.Add(Rec.FieldNo(Soort), 'soort');
        Dict.Add(Rec.FieldNo(Geboortedatum), 'geboortedatum.datum');
        Dict.Add(Rec.FieldNo(Geslacht), 'geslacht');

        Dict.Add(Rec.FieldNo(Achternaam), 'naam.geslachtsnaam.achternaam');
        Dict.Add(Rec.FieldNo(Voorvoegsel), 'naam.geslachtsnaam.voorvoegsel');

        Dict.Add(Rec.FieldNo(PartnerAchternaam), 'naam.partnernaam.achternaam');
        Dict.Add(Rec.FieldNo(PartnerVoorvoegsel), 'naam.partnernaam.voorvoegsel');

        Dict.Add(Rec.FieldNo(Voornamen), 'naam.voornamen');
        Dict.Add(Rec.FieldNo(Voorletters), 'naam.voorletters');
        Dict.Add(Rec.FieldNo(NaamGebruik), 'naam.naamGebruik');

        // Dict.Add(Database::ACKWMOContact, 'contact');
        // Dict.Add(Database::ACKWMORetourCode, 'retourCodes');
    end;
}
