/// <summary>
/// Table ACKWMOPrestatie
/// </summary>
table 50032 ACKWMOPrestatie
{
    Caption = 'Prestatie', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = ReferentieNummer, BeginDatum;

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
        }
        field(30; ReferentieNummer; Text[20])
        {
            Caption = 'Referentienummer', Locked = true;
        }
        field(40; VorigReferentieNummer; Text[20])
        {
            Caption = 'Vorig referentienummer', Locked = true;
        }
        field(50; ToewijzingNummer; Integer)
        {
            Caption = 'Toewijzingsnummer', Locked = true;
        }
        field(60; ProductCategorie; Code[2])
        {
            Caption = 'Product category', Locked = true;
        }
        field(70; ProductCode; Text[5])
        {
            Caption = 'Productcode', Locked = true;
        }
        field(80; Begindatum; Date)
        {
            Caption = 'Begindatum', Locked = true;
        }
        field(90; Einddatum; Date)
        {
            Caption = 'Einddatum', Locked = true;
        }
        field(100; GeleverdVolume; Integer)
        {
            Caption = 'Geleverd volume', Locked = true;
        }
        field(110; Eenheid; Enum ACKWMOEenheid)
        {
            Caption = 'Eenheid', Locked = true;
        }
        field(120; ProductTarief; Integer)
        {
            Caption = 'Product tarief', Locked = true;
        }
        field(130; Bedrag; Integer)
        {
            Caption = 'Bedrag', Locked = true;
        }
        field(140; DebetCredit; Enum ACKDebitCredit)
        {
            Caption = 'Debet/Credit', Locked = true;
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
        key(DataCaptionFields; Begindatum)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMOPrestatie);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// FieldMapDictionary.
    /// </summary>
    /// <returns>Return variable Dict of type Dictionary of [Integer, Text].</returns>
    procedure FieldMapDictionary() Dict: Dictionary of [Integer, Text]
    begin
        Dict.Add(Rec.FieldNo(ReferentieNummer), 'productReferentie.referentieNummer');
        Dict.Add(Rec.FieldNo(VorigReferentieNummer), 'productReferentie.vorigReferentieNummer');
        Dict.Add(Rec.FieldNo(ToewijzingNummer), 'toewijzingNummer');
        Dict.Add(Rec.FieldNo(ProductCategorie), 'productCategorie');
        Dict.Add(Rec.FieldNo(ProductCode), 'productCode');
        Dict.Add(Rec.FieldNo(Begindatum), 'productPeriode.begindatum');
        Dict.Add(Rec.FieldNo(Einddatum), 'productPeriode.einddatum');
        Dict.Add(Rec.FieldNo(GeleverdVolume), 'geleverdVolume');
        Dict.Add(Rec.FieldNo(Eenheid), 'eenheid');
        Dict.Add(Rec.FieldNo(ProductTarief), 'productTarief');
        Dict.Add(Rec.FieldNo(Bedrag), 'ingediendBedrag.bedrag');
        Dict.Add(Rec.FieldNo(DebetCredit), 'ingediendBedrag.debetCredit');
    end;
}
