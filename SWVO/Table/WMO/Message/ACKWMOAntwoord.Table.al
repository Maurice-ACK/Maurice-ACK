/// <summary>
/// Table ACKWMOAntwoord
/// </summary>
table 50042 ACKWMOAntwoord
{
    Caption = 'Antwoord', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; HeaderId; Guid)
        {
            Caption = 'Header System Id', Locked = true;
            TableRelation = ACKWMOHeader.SystemId;
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                TestField(Rec.HeaderId);
            end;
        }
        field(20; ReferentieAanbieder; Text[36])
        {
            Caption = 'Referentie aanbieder', Locked = true;
            DataClassification = CustomerContent;
        }
        field(30; VerzoekAntwoord; enum ACKWMOVerzoekAntwoord)
        {
            Caption = 'Verzoek antwoord', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(40; RedenAfwijzingVerzoek; enum ACKWMORedenAfwijzingVerzoek)
        {
            Caption = 'Reden afwijzing verzoek', Locked = true;
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; HeaderId)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
    begin
        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMOAntwoord);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;

    /// <summary>
    /// FieldMapDictionary.
    /// </summary>
    /// <returns>Return variable Dict of type Dictionary of [Integer, Text].</returns>
    procedure FieldMapDictionary() Dict: Dictionary of [Integer, Text]
    begin
        Dict.Add(Rec.FieldNo(ReferentieAanbieder), 'referentieAanbieder');
        Dict.Add(Rec.FieldNo(VerzoekAntwoord), 'verzoekAntwoord');
        Dict.Add(Rec.FieldNo(RedenAfwijzingVerzoek), 'redenAfwijzingVerzoek');
    end;
}
