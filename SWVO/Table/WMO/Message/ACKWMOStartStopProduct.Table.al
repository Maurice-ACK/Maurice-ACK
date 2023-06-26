/// <summary>
/// Table ACKWMOStartStopProduct
/// </summary>
table 50001 ACKWMOStartStopProduct
{
    Caption = 'Start/Stop product', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = ToewijzingNummer, ProductCode, StatusAanlevering;
    fields
    {
        field(10; Id; Integer)
        {
            Caption = 'Id', Locked = true;
            AutoIncrement = true;
        }
        field(20; ClientId; Guid)
        {
            Caption = 'Client System Id', Locked = true;
            TableRelation = ACKWMOClient.SystemId;

            trigger OnValidate()
            begin
                TestField(Rec.ClientId);
            end;
        }
        field(30; ToewijzingNummer; Integer)
        {
            Caption = 'Toewijzingsnummer', Locked = true;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.ToewijzingNummer);
            end;
        }
        field(40; ProductCategorie; Code[2])
        {
            Caption = 'Productcategorie', Locked = true;
        }
        field(50; ProductCode; Text[5])
        {
            Caption = 'Productcode', Locked = true;
        }
        field(60; ToewijzingIngangsdatum; Date)
        {
            Caption = 'Toewijzing Ingangsdatum', Locked = true;
        }
        field(70; Begindatum; Date)
        {
            Caption = 'Startdatum', Locked = true;
        }
        field(80; Einddatum; Date)
        {
            Caption = 'Einddatum', Locked = true;
        }
        field(90; StatusAanlevering; Enum ACKWMOStatusAanlevering)
        {
            Caption = 'Status aanlevering', Locked = true;
        }

        field(100; RedenBeeindiging; Enum ACKWMORedenBeeindiging)
        {
            Caption = 'Reden beëindiging', Locked = true;
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
        key(ClientId; ClientId)
        {
        }
        key(DataCaptionFields; ToewijzingNummer, ProductCode, StatusAanlevering)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMOStartStopProduct);
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
        Dict.Add(Rec.FieldNo(ToewijzingIngangsdatum), 'toewijzingIngangsdatum');
        Dict.Add(Rec.FieldNo(Begindatum), 'begindatum');
        Dict.Add(Rec.FieldNo(Einddatum), 'einddatum');
        Dict.Add(Rec.FieldNo(StatusAanlevering), 'statusAanlevering');
        Dict.Add(Rec.FieldNo(RedenBeeindiging), 'redenBeeindiging');
    end;
}
