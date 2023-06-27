/// <summary>
/// Table ACKNewChangedUnchangedProduct
/// </summary>
table 50005 ACKNewChangedUnchangedProduct
{
    Caption = 'Nieuw/Gewijzigd/Ongewijzigd product', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = NewChangedUnchangedProductType, RedenVerzoek, ReferentieAanbieder;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }

        field(20; ClientID; Guid)
        {
            Caption = 'Client System ID', Locked = true;
            TableRelation = ACKWMOClient.SystemId;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Rec.ClientID);
            end;
        }

        field(30; ReferentieAanbieder; Text[36])
        {
            Caption = 'Referentie aanbieder', Locked = true;
            DataClassification = CustomerContent;
        }

        field(40; RedenVerzoek; enum ACKWMORedenVerzoek)
        {
            Caption = 'Reden verzoek', Locked = true;
            DataClassification = CustomerContent;
        }

        field(50; NewChangedUnchangedProductType; Enum ACKNewChangedUnchangedProductType)
        {
            Caption = 'Type', Locked = true;
            DataClassification = CustomerContent;
        }

        field(60; ToewijzingNummer; Integer)
        {
            Caption = 'Toewijzingsnummer', Locked = true;
            NotBlank = true;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestField(Rec.ToewijzingNummer);
            end;
        }

        field(70; ProductCategorie; Code[2])
        {
            Caption = 'Productcategorie', Locked = true;
            DataClassification = CustomerContent;
        }
        field(80; ProductCode; Text[5])
        {
            Caption = 'Productcode', Locked = true;
            DataClassification = CustomerContent;
        }
        field(90; GewensteIngangsdatum; Date)
        {
            Caption = 'Gewenste ingangsdatum', Locked = true;
            DataClassification = CustomerContent;
        }
        field(100; Einddatum; Date)
        {
            Caption = 'Einddatum', Locked = true;
            DataClassification = CustomerContent;
        }
        field(110; Volume; Integer)
        {
            NotBlank = true;
            MinValue = 0;
            MaxValue = 99999999;
            Caption = 'Volume', Locked = true;
            DataClassification = CustomerContent;
        }
        field(120; Eenheid; enum ACKWMOEenheid)
        {
            NotBlank = true;
            Caption = 'Eenheid', Locked = true;
            DataClassification = CustomerContent;
        }
        field(130; Frequentie; enum ACKWMOFrequentie)
        {
            Caption = 'Frequentie', Locked = true;
            DataClassification = CustomerContent;
        }

        field(140; Budget; Integer)
        {
            MinValue = 0;
            MaxValue = 99999999;
            Caption = 'Budget', Locked = true;
            NotBlank = true;
            DataClassification = CustomerContent;
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
        key(CaptionFields; NewChangedUnchangedProductType, RedenVerzoek, ReferentieAanbieder)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKNewChangedUnchangedProduct);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// FieldMapDictionary.
    /// </summary>
    /// <returns>Return variable Dict of type Dictionary of [Integer, Text].</returns>
    procedure FieldMapDictionary() Dict: Dictionary of [Integer, Text]
    begin
        Dict.Add(Rec.FieldNo(ToewijzingNummer), 'toewijzingNummer');
        Dict.Add(Rec.FieldNo(ProductCategorie), 'product.categorie');
        Dict.Add(Rec.FieldNo(ProductCode), 'product.code');

        Dict.Add(Rec.FieldNo(GewensteIngangsdatum), 'gewensteIngangsdatum');

        Dict.Add(Rec.FieldNo(Einddatum), 'einddatum');

        Dict.Add(Rec.FieldNo(Volume), 'omvang.volume');
        Dict.Add(Rec.FieldNo(Eenheid), 'omvang.eenheid');
        Dict.Add(Rec.FieldNo(Frequentie), 'omvang.frequentie');

        Dict.Add(Rec.FieldNo(Budget), 'budget');
    end;
}
