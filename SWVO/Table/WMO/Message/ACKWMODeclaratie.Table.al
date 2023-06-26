/// <summary>
/// Table ACKWMODeclaratie
/// </summary>
table 50031 ACKWMODeclaratie
{
    Caption = 'Declaratie', Locked = true;
    DataClassification = ToBeClassified;

    fields
    {
        field(10; HeaderId; Guid)
        {
            Caption = 'Header System Id', Locked = true;
            TableRelation = ACKWMOHeader.SystemId;
            DataClassification = CustomerContent;
        }
        field(20; DeclaratieNummer; Text[12])
        {
            Caption = 'Declaratie nummer', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(30; Begindatum; Date)
        {
            Caption = 'Begindatum', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(40; Einddatum; Date)
        {
            Caption = 'Einddatum', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(50; DeclaratieDagtekening; Date)
        {
            Caption = 'Dagtekening', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(60; TotaalBedrag; Integer)
        {
            Caption = 'Totaal bedrag', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(70; DebetCredit; Enum ACKDebitCredit)
        {
            Caption = 'Debet/Credit', Locked = true;
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; HeaderId)
        {
            Clustered = true;
        }
        key(DeclaratieNummer; DeclaratieNummer)
        {
        }
        key(DataCaptionFields; DeclaratieNummer, DebetCredit, TotaalBedrag)
        {
        }
    }

    /// <summary>
    /// GetHeader.
    /// </summary>
    /// <returns>Return variable ACKWMOHeader of type Record ACKWMOHeader.</returns>
    procedure GetHeader() ACKWMOHeader: Record ACKWMOHeader
    begin
        ACKWMOHeader.Get(Rec.HeaderId);
    end;

    trigger OnDelete()
    var
        ACKWMOPrestatie: Record ACKWMOPrestatie;
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        // ACKWMOPrestatie.SetCurrentKey();
        // ACKWMOPrestatie.SetRange(HeaderId, Rec.HeaderId);
        // ACKWMOPrestatie.DeleteAll(true);

        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMODeclaratie);
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
        Dict.Add(Rec.FieldNo(DeclaratieNummer), 'declaratieNummer');

        Dict.Add(Rec.FieldNo(Begindatum), 'declaratiePeriode.begindatum');
        Dict.Add(Rec.FieldNo(Einddatum), 'declaratiePeriode.einddatum');

        Dict.Add(Rec.FieldNo(DeclaratieDagtekening), 'declaratieDagtekening');

        Dict.Add(Rec.FieldNo(TotaalBedrag), 'totaalIngediendBedrag.totaalBedrag');
        Dict.Add(Rec.FieldNo(DebetCredit), 'totaalIngediendBedrag.debitCredit');
    end;
}
