/// <summary>
/// Page ACKWMOPrestatieListPart
/// </summary>
page 50037 ACKWMOPrestatieListPart
{
    Caption = 'Prestaties';
    PageType = ListPart;
    SourceTable = ACKWMOPrestatieQueryTable;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableTemporary = true;
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SSN; Rec.SSN)
                {
                }
                field(ClientName; ClientName)
                {
                    Caption = 'Naam cliënt';
                }
                field(ReferentieNummer; Rec.ReferentieNummer)
                {
                }
                field(VorigReferentieNummer; Rec.VorigReferentieNummer)
                {
                }
                field(ToewijzingNummer; Rec.ToewijzingNummer)
                {
                }
                field(ProductCategorie; Rec.ProductCategorie)
                {
                }
                field(ProductCode; Rec.ProductCode)
                {
                }
                field(Begindatum; Rec.Begindatum)
                {
                }
                field(Einddatum; Rec.Einddatum)
                {
                }
                field(GeleverdVolume; Rec.GeleverdVolume)
                {
                }
                field(Eenheid; Rec.Eenheid)
                {
                }
                field(ProductTarief; Rec.ProductTarief)
                {
                }
                field(Bedrag; Rec.Bedrag)
                {
                }
                field(DebetCredit; Rec.DebetCredit)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not IsNullGuid(Rec.HeaderSystemId) then
            Fetch();
    end;

    trigger OnAfterGetCurrRecord()
    var
        Client: Record ACKClient;
    begin
        if not Rec.IsEmpty() and (Rec.SSN <> '') then begin
            Client.SetRange(SSN, WMOClient.SSN);
            if Client.FindFirst() then
                ClientName := Client.Surname;
        end;
    end;

    local procedure Fetch()
    var
        WMOPrestatieQuery: Query ACKWMOPrestatieQuery;
    begin
        WMOPrestatieQuery.SetRange(WMOPrestatieQuery.HeaderSystemId, Rec.HeaderSystemId);
        if WMOPrestatieQuery.Open() then begin
            while WMOPrestatieQuery.Read() do begin
                Rec.Init();
                Rec.HeaderSystemId := WMOPrestatieQuery.HeaderSystemId;
                Rec.DeclarationId := WMOPrestatieQuery.DeclaratieSystemId;
                Rec.ClientId := WMOPrestatieQuery.ClientSystemId;
                Rec.PrestatieId := WMOPrestatieQuery.PrestatieSystemId;
                Rec.SSN := WMOPrestatieQuery.SSN;
                Rec.ReferentieNummer := WMOPrestatieQuery.ReferentieNummer;
                Rec.VorigReferentieNummer := WMOPrestatieQuery.VorigReferentieNummer;
                Rec.ToewijzingNummer := WMOPrestatieQuery.ToewijzingNummer;
                Rec.ProductCategorie := WMOPrestatieQuery.ProductCategorie;
                Rec.ProductCode := WMOPrestatieQuery.ProductCode;
                Rec.Begindatum := WMOPrestatieQuery.Begindatum;
                Rec.Einddatum := WMOPrestatieQuery.Einddatum;
                Rec.GeleverdVolume := WMOPrestatieQuery.GeleverdVolume;
                Rec.Eenheid := WMOPrestatieQuery.Eenheid;
                Rec.ProductTarief := WMOPrestatieQuery.ProductTarief;
                Rec.Bedrag := WMOPrestatieQuery.Bedrag;
                Rec.DebetCredit := WMOPrestatieQuery.DebetCredit;
                Rec.Insert();
            end;
            WMOPrestatieQuery.Close();
        end;
    end;

    var
        WMOClient: Record ACKWMOClient;
        ClientName: Text[200];
}
