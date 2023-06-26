/// <summary>
/// Table ACKWMOContact
/// </summary>
table 50024 ACKWMOContact
{
    Caption = 'Contact', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = Soort, Postcode, Huisnummer, HuisnummerToevoeging, Huisletter;

    fields
    {
        field(10; ID; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
            DataClassification = SystemMetadata;

        }
        field(20; RefID; Guid)
        {
            Caption = 'Reference ID', Locked = true;
            TableRelation =
                if (RelationTableNo = const(Database::ACKWMOClient)) ACKWMOClient.SystemId
            else
            if (RelationTableNo = const(Database::ACKWMORelatie)) ACKWMORelatie.SystemId;

            trigger OnValidate()
            begin
                TestField(Rec.RefID);
            end;
        }
        field(30; RelationTableNo; Integer)
        {
            Caption = 'Relation Table No.', Locked = true;
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));

            trigger OnValidate()
            var
                RelationToSelfErr: Label '%1 cannot have a relation to itself.', Comment = '%1 = Table caption', Locked = true;
            begin
                if Rec.RelationTableNo = Database::ACKWMOContact then
                    Error(RelationToSelfErr, Rec.TableCaption());
            end;
        }
        field(40; Soort; Enum ACKWMOAdresSoort)
        {
            Caption = 'Soort adres', Locked = true;
            DataClassification = CustomerContent;
        }
        field(50; Huisnummer; Integer)
        {
            MinValue = 0;
            MaxValue = 999999;
            Caption = 'Huisnummer', Locked = true;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(60; Huisletter; Code[1])
        {
            Caption = 'Huisletter', Locked = true;
            DataClassification = CustomerContent;
        }
        field(70; HuisnummerToevoeging; Text[4])
        {
            Caption = 'Huisnummer toevoeging', Locked = true;
            DataClassification = CustomerContent;
        }
        field(80; AanduidingWoonadres; Enum ACKWMOAanduidingWoonadres)
        {
            Caption = 'Aanduiding woonadres', Locked = true;
            DataClassification = CustomerContent;
            //InitValue = NVT;
        }
        field(90; Postcode; Text[8])
        {
            Caption = 'Postcode', Locked = true;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(100; Straatnaam; Text[24])
        {
            Caption = 'Straatnaam', Locked = true;
            DataClassification = CustomerContent;
        }
        field(110; Plaatsnaam; Text[80])
        {
            Caption = 'Plaatsnaam', Locked = true;
            DataClassification = CustomerContent;
        }
        field(120; LandCode; Code[2])
        {
            Caption = 'Land code', Locked = true;
            DataClassification = CustomerContent;
        }
        field(130; Organisatie; Text[35])
        {
            Caption = 'Organisatie', Locked = true;
            DataClassification = CustomerContent;
        }
        field(140; Telefoonnummer01; Text[15])
        {
            Caption = 'Telefoonnummer', Locked = true;
            DataClassification = CustomerContent;
        }
        field(150; Landnummer01; Text[4])
        {
            Caption = 'Landnummer', Locked = true;
            DataClassification = CustomerContent;
        }
        field(160; Telefoonnummer02; Text[15])
        {
            Caption = 'Telefoonnummer', Locked = true;
            DataClassification = CustomerContent;
        }
        field(170; Landnummer02; Text[4])
        {
            Caption = 'Landnummer', Locked = true;
            DataClassification = CustomerContent;
        }
        field(180; Emailadres; Text[80])
        {
            Caption = 'E-mailadres';
            DataClassification = CustomerContent;
        }
        field(190; Begindatum; Date)
        {
            Caption = 'Begindatum', Locked = true;
            DataClassification = CustomerContent;
        }
        field(200; Einddatum; Date)
        {
            Caption = 'Einddatum', Locked = true;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(KeyTableRelationRefIdSoort; RelationTableNo, RefID, Soort)
        {
        }

        key(DataCaptionFields; Soort, Postcode, Huisnummer, HuisnummerToevoeging, Huisletter)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMOMessageRetourCode.SetCurrentKey(RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMOContact);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// FieldMapDictionary.
    /// Arrays in the object must be mapped with the tableId of the object inside the array.
    /// </summary>
    /// <returns>Return variable Dict of type Dictionary of [Integer, Text].</returns>
    procedure FieldMapDictionary() Dict: Dictionary of [Integer, Text]
    begin
        Dict.Add(Rec.FieldNo(Soort), 'soort');
        Dict.Add(Rec.FieldNo(Huisnummer), 'adres.huis.huisnummer');
        Dict.Add(Rec.FieldNo(Huisletter), 'adres.huis.huisletter');
        Dict.Add(Rec.FieldNo(HuisnummerToevoeging), 'adres.huis.huisnummerToevoeging');
        Dict.Add(Rec.FieldNo(AanduidingWoonadres), 'adres.huis.aanduidingWoonadres');

        Dict.Add(Rec.FieldNo(Postcode), 'adres.postcode');
        Dict.Add(Rec.FieldNo(Straatnaam), 'adres.straatnaam');

        Dict.Add(Rec.FieldNo(Plaatsnaam), 'adres.plaatsnaam');
        Dict.Add(Rec.FieldNo(LandCode), 'adres.landCode');

        Dict.Add(Rec.FieldNo(Organisatie), 'organisatie');

        Dict.Add(Rec.FieldNo(Telefoonnummer01), 'telefoon.telefoon01.telefoonnummer');
        Dict.Add(Rec.FieldNo(Landnummer01), 'telefoon.telefoon01.landnummer');
        Dict.Add(Rec.FieldNo(Telefoonnummer02), 'telefoon.telefoon02.telefoonnummer');
        Dict.Add(Rec.FieldNo(Landnummer02), 'telefoon.telefoon02.landnummer');

        Dict.Add(Rec.FieldNo(Emailadres), 'emailadres');
    end;
}
