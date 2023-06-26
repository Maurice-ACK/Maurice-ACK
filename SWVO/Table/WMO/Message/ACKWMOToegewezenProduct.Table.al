/// <summary>
/// Table ACKWMOToegewezenProduct
/// </summary>
table 50023 ACKWMOToegewezenProduct
{
    Caption = 'Toegewezen product', Locked = true;
    DataClassification = CustomerContent;
    DataCaptionFields = ToewijzingNummer, ProductCode, ReferentieAanbieder;

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
            NotBlank = true;
            TableRelation = ACKWMOClient.SystemId;
        }
        field(30; ToewijzingNummer; Integer)
        {
            Caption = 'Toewijzingsnummer', Locked = true;
            NotBlank = true;
        }
        field(40; ReferentieAanbieder; Text[36])
        {
            Caption = 'Referentie aanbieder', Locked = true;
        }
        field(50; Toewijzingsdatum; Date)
        {
            Caption = 'Toewijzingsdatum', Locked = true;
            NotBlank = true;
        }
        field(60; Toewijzingstijd; Time)
        {
            Caption = 'Toewijzingstijd', Locked = true;
            NotBlank = true;
        }
        field(70; Ingangsdatum; Date)
        {
            Caption = 'Ingangsdatum', Locked = true;
        }
        field(80; Einddatum; Date)
        {
            Caption = 'Einddatum', Locked = true;
        }
        field(90; RedenWijziging; Enum ACKWMORedenWijziging)
        {
            Caption = 'Reden Wijziging', Locked = true;
        }
        field(100; Budget; Integer)
        {
            MinValue = 0;
            MaxValue = 99999999;
            Caption = 'Budget', Locked = true;
        }
        field(110; ProductCategorie; Code[2])
        {
            Caption = 'Productcategorie', Locked = true;
        }
        field(120; ProductCode; Text[5])
        {
            Caption = 'Productcode', Locked = true;
        }
        field(130; Volume; Integer)
        {
            NotBlank = true;
            MinValue = 0;
            MaxValue = 99999999;
            Caption = 'Volume', Locked = true;
        }
        field(140; Eenheid; enum ACKWMOEenheid)
        {
            NotBlank = true;
            Caption = 'Eenheid', Locked = true;
        }
        field(150; Frequentie; enum ACKWMOFrequentie)
        {
            Caption = 'Frequentie', Locked = true;
        }
        field(160; Commentaar; Text[200])
        {
            Caption = 'Commentaar', Locked = true;
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
        key(DataCaptionFields; ToewijzingNummer, ProductCode, ReferentieAanbieder)
        {
        }
    }

    trigger OnDelete()
    var
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMOToegewezenProduct);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;
}
