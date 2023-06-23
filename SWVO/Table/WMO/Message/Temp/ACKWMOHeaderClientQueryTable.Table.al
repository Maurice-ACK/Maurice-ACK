/// <summary>
/// Table ACKWMOHeaderClientQueryTable (ID 50035).
/// </summary>
table 50035 ACKWMOHeaderClientQueryTable
{
    Caption = 'WMOHeaderClientQueryTable', Locked = true;
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; HeaderSystemID; Guid)
        {
            Caption = 'Header ID', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(20; BerichtCode; Enum ACKVektisCode)
        {
            Caption = 'Bericht code', Locked = true;
            DataClassification = CustomerContent;
        }
        field(30; Afzender; Code[8])
        {
            Caption = 'Afzender', Locked = true;
            DataClassification = CustomerContent;
        }
        field(40; Identificatie; Text[12])
        {
            Caption = 'Identificatie', Locked = true;
            DataClassification = CustomerContent;
        }

        field(50; XsltVersie; Text[5])
        {
            Caption = 'XsltVersie', Locked = true;
            DataClassification = CustomerContent;
        }
        field(60; Referentienummer; Guid)
        {
            Caption = 'Referentienummer', Locked = true;
            DataClassification = CustomerContent;
        }
        field(70; Status; Enum ACKWMOHeaderStatus)
        {
            Caption = 'Status', Locked = true;
            DataClassification = CustomerContent;
        }
        field(80; ClientSystemID; Guid)
        {
            Caption = 'Client System ID', Locked = true;
            DataClassification = SystemMetadata;
        }
        field(90; SSN; Code[9])
        {
            Caption = 'BSN', Locked = true;
            DataClassification = CustomerContent;
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
    procedure MapFromHeaderId(HeaderId: Guid)
    var
        WMOHeaderClientQuery: Query ACKWMOHeaderClientQuery;
    begin
        WMOHeaderClientQuery.SetRange(WMOHeaderClientQuery.HeaderSystemId, HeaderId);
        MapFromQuery(WMOHeaderClientQuery);
    end;

    /// <summary>
    /// MapFromQuery.
    /// </summary>
    /// <param name="WMOHeaderClientQuery">Query ACKWMOHeaderClientQuery.</param>
    local procedure MapFromQuery(WMOHeaderClientQuery: Query ACKWMOHeaderClientQuery)
    var
        WMOHeader: Record ACKWMOHeader;
    begin
        WMOHeaderClientQuery.TopNumberOfRows(1);
        if WMOHeaderClientQuery.Open() and WMOHeaderClientQuery.Read() then begin
            WMOHeader.GetBySystemId(WMOHeaderClientQuery.HeaderSystemId);

            Clear(Rec);
            //Header
            Rec.HeaderSystemID := WMOHeaderClientQuery.HeaderSystemId;
            Rec.BerichtCode := WMOHeaderClientQuery.BerichtCode;
            Rec.Afzender := WMOHeaderClientQuery.Afzender;
            Rec.Identificatie := WMOHeaderClientQuery.Identificatie;
            Rec.Referentienummer := WMOHeaderClientQuery.Referentienummer;
            Rec.Status := WMOHeaderClientQuery.Status;

            //Client
            Rec.ClientSystemID := WMOHeaderClientQuery.ClientSystemId;
            Rec.SSN := WMOHeaderClientQuery.SSN;

            WMOHeaderClientQuery.Close();
        end;
    end;
}
