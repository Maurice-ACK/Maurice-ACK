/// <summary>
/// Table ACKWMOPrestatieQueryTable (ID 50043).
/// </summary>
table 50051 ACKWMOPrestatieQueryTable
{
    Caption = 'Wmo Prestatie temp', Locked = true;
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; HeaderSystemId; Guid)
        {
            Caption = 'Header System Id', Locked = true;
            DataClassification = SystemMetadata;
            TableRelation = ACKWMOHeader.SystemId;
        }
        field(20; DeclarationId; Guid)
        {
            Caption = 'Declaratie System Id', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(30; ClientId; Guid)
        {
            Caption = 'Client System Id', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(40; PrestatieId; Guid)
        {
            Caption = 'Prestatie System Id', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(50; ReferentieNummer; Text[20])
        {
            Caption = 'Referentienummer', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(60; VorigReferentieNummer; Text[20])
        {
            Caption = 'Vorig referentienummer', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(70; SSN; Code[9])
        {
            Caption = 'BSN', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(80; ToewijzingNummer; Integer)
        {
            Caption = 'Toewijzingsnummer', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(90; ProductCategorie; Code[2])
        {
            Caption = 'Productcategorie', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(100; ProductCode; Text[5])
        {
            Caption = 'Productcode', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(110; Begindatum; Date)
        {
            Caption = 'Begindatum', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(120; Einddatum; Date)
        {
            Caption = 'Einddatum', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(130; GeleverdVolume; Integer)
        {
            Caption = 'Geleverd volume', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(140; Eenheid; Enum ACKWMOEenheid)
        {
            Caption = 'Eenheid', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(150; ProductTarief; Integer)
        {
            Caption = 'Product tarief', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(160; Bedrag; Integer)
        {
            Caption = 'Bedrag', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(170; DebetCredit; Enum ACKDebitCredit)
        {
            Caption = 'Debet/Credit';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; PrestatieId)
        {
            Clustered = true;
        }
        key(HeaderSystemId; HeaderSystemId)
        {
        }
    }
}
