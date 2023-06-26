/// <summary>
/// Table ACKAssignedProductQTable
/// </summary>
table 50057 ACKAssignedProductQTable
{
    Caption = 'Assigned product query table', Locked = true;
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; HeaderSystemID; Guid)
        {
            Caption = 'HeaderSystemID', Locked = true;
        }
        field(20; BerichtCode; Enum ACKVektisCode)
        {
            Caption = 'Bericht code', Locked = true;
        }
        field(30; Afzender; Code[8])
        {
            Caption = 'Afzender', Locked = true;
        }
        field(40; Identificatie; Text[12])
        {
            Caption = 'Identificatie', Locked = true;
        }
        field(50; ClientSystemID; Guid)
        {
            Caption = 'Identificatie', Locked = true;
        }
        field(60; SSN; Code[9])
        {
        }
        field(70; ToewijzingNummer; Integer)
        {
            Caption = 'Toewijzing nummer', Locked = true;
        }
    }
    keys
    {
        key(PK; BerichtCode, Afzender, Identificatie)
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// MapFromHeaderId.
    /// </summary>
    /// <param name="HeaderId">Guid.</param>
    // procedure MapFromHeaderId(HeaderId: Guid)
    // var
    //     WMOHeaderClientQuery: Query ACKWMOHeaderClientQuery;
    // begin
    //     WMOHeaderClientQuery.SetRange(WMOHeaderClientQuery.HeaderSystemId, HeaderId);
    //     MapFromQuery(WMOHeaderClientQuery);
    // end;

    // /// <summary>
    // /// MapFromQuery.
    // /// </summary>
    // /// <param name="WMOHeaderClientQuery">Query ACKWMOHeaderClientQuery.</param>
    // local procedure MapFromQuery(WMOHeaderClientQuery: Query ACKWMOHeaderClientQuery)
    // var
    //     WMOHeader: Record ACKWMOHeader;
    // begin
    //     WMOHeaderClientQuery.TopNumberOfRows(1);
    //     if WMOHeaderClientQuery.Open() and WMOHeaderClientQuery.Read() then begin
    //         WMOHeader.GetBySystemId(WMOHeaderClientQuery.HeaderSystemId);

    //         Clear(Rec);
    //         //Header
    //         Rec.HeaderSystemId := WMOHeaderClientQuery.HeaderSystemId;
    //         Rec.BerichtCode := WMOHeaderClientQuery.BerichtCode;
    //         Rec.Afzender := WMOHeaderClientQuery.Afzender;
    //         Rec.Identificatie := WMOHeaderClientQuery.Identificatie;
    //         Rec.Referentienummer := WMOHeaderClientQuery.Referentienummer;
    //         Rec.Status := WMOHeaderClientQuery.Status;

    //         //Client
    //         Rec.ClientSystemId := WMOHeaderClientQuery.ClientSystemId;
    //         Rec.SSN := WMOHeaderClientQuery.SSN;

    //         WMOHeaderClientQuery.Close();
    //     end;
    //end;
}
