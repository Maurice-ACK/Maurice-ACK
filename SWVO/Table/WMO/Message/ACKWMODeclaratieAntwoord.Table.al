/// <summary>
/// Table ACKWMODeclaratie (ID 50068).
/// </summary>
table 50063 ACKWMODeclaratieAntwoord
{
    Caption = 'Declaratie antwoord', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; HeaderId; Guid)
        {
            Caption = 'Header System Id', Locked = true;
            TableRelation = ACKWMOHeader.SystemId;
        }
        field(20; DeclaratieNummer; Text[12])
        {
            Caption = 'Declaratie nummer', Locked = true;
        }
        field(40; IngediendTotaalBedrag; Integer)
        {
            Caption = 'Ingediend Totaal bedrag', Locked = true;
        }
        field(50; IngediendDebetCredit; Enum ACKDebitCredit)
        {
            Caption = 'Ingediend Debet/Credit', Locked = true;
        }
        field(60; ToegekendTotaalBedrag; Integer)
        {
            Caption = 'Toegekend Totaal bedrag', Locked = true;
        }
        field(70; ToegekendDebetCredit; Enum ACKDebitCredit)
        {
            Caption = 'Toegekend Debet/Credit', Locked = true;
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
        ACKWMOMessageRetourCode: Record ACKWMOMessageRetourCode;
        WMOClient: Record ACKWMOClient;
    begin
        WMOClient.SetCurrentKey(HeaderId);
        WMOClient.SetRange(HeaderId, Rec.HeaderId);
        WMOClient.DeleteAll(true);

        ACKWMOMessageRetourCode.SetCurrentKey(RelationTableNo, RefID);
        ACKWMOMessageRetourCode.SetRange(RelationTableNo, Database::ACKWMODeclaratieAntwoord);
        ACKWMOMessageRetourCode.SetRange(RefID, Rec.SystemId);
        ACKWMOMessageRetourCode.DeleteAll(true);
    end;
}
