/// <summary>
/// Page ACKWMOPrestatieListPart
/// </summary>
page 50037 ACKWMOPrestatieListPart
{
    Caption = 'Prestaties';
    PageType = ListPart;
    SourceTable = ACKWMOClient;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableTemporary = false;
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SSN; ACKWMOPrestatieQueryTable.SSN)
                {
                }
                field(ClientName; ACKWMOPrestatieQueryTable.ClientName)
                {
                    Caption = 'Naam';
                }
                field(ReferentieNummer; ACKWMOPrestatieQueryTable.ReferentieNummer)
                {
                }
                field(VorigReferentieNummer; ACKWMOPrestatieQueryTable.VorigReferentieNummer)
                {
                }
                field(ToewijzingNummer; ACKWMOPrestatieQueryTable.ToewijzingNummer)
                {
                }
                field(ProductCategorie; ACKWMOPrestatieQueryTable.ProductCategorie)
                {
                }
                field(ProductCode; ACKWMOPrestatieQueryTable.ProductCode)
                {
                }
                field(Begindatum; ACKWMOPrestatieQueryTable.Begindatum)
                {
                }
                field(Einddatum; ACKWMOPrestatieQueryTable.Einddatum)
                {
                }
                field(GeleverdVolume; ACKWMOPrestatieQueryTable.GeleverdVolume)
                {
                }
                field(Eenheid; ACKWMOPrestatieQueryTable.Eenheid)
                {
                }
                field(ProductTarief; ACKWMOPrestatieQueryTable.ProductTarief)
                {
                }
                field(Bedrag; ACKWMOPrestatieQueryTable.Bedrag)
                {
                }
                field(DebitCredit; ACKWMOPrestatieQueryTable.DebitCredit)
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if not IsNullGuid(Rec.HeaderId) and (ACKWMOPrestatieQueryTable.HeaderSystemId <> Rec.HeaderId) then
            Fetch();
    end;

    local procedure Fetch()
    var
        ACKClient: Record ACKClient;
        WMOPrestatieQuery: Query ACKWMOPrestatieQuery;
    begin
        WMOPrestatieQuery.SetRange(WMOPrestatieQuery.HeaderSystemId, Rec.HeaderId);
        if WMOPrestatieQuery.Open() then begin
            while WMOPrestatieQuery.Read() do begin
                Clear(ACKClient);
                ACKClient.SetRange(SSN, WMOPrestatieQuery.SSN);
                ACKClient.FindFirst();

                ACKWMOPrestatieQueryTable.Init();
                ACKWMOPrestatieQueryTable.HeaderSystemId := WMOPrestatieQuery.HeaderSystemId;
                ACKWMOPrestatieQueryTable.DeclarationId := WMOPrestatieQuery.DeclaratieSystemId;
                ACKWMOPrestatieQueryTable.ClientId := WMOPrestatieQuery.ClientSystemId;
                ACKWMOPrestatieQueryTable.PrestatieId := WMOPrestatieQuery.PrestatieSystemId;
                ACKWMOPrestatieQueryTable.SSN := WMOPrestatieQuery.SSN;
                ACKWMOPrestatieQueryTable.ClientName := ACKClient.Surname;
                ACKWMOPrestatieQueryTable.ReferentieNummer := WMOPrestatieQuery.ReferentieNummer;
                ACKWMOPrestatieQueryTable.VorigReferentieNummer := WMOPrestatieQuery.VorigReferentieNummer;
                ACKWMOPrestatieQueryTable.ToewijzingNummer := WMOPrestatieQuery.ToewijzingNummer;
                ACKWMOPrestatieQueryTable.ProductCategorie := WMOPrestatieQuery.ProductCategorie;
                ACKWMOPrestatieQueryTable.ProductCode := WMOPrestatieQuery.ProductCode;
                ACKWMOPrestatieQueryTable.Begindatum := WMOPrestatieQuery.Begindatum;
                ACKWMOPrestatieQueryTable.Einddatum := WMOPrestatieQuery.Einddatum;
                ACKWMOPrestatieQueryTable.GeleverdVolume := WMOPrestatieQuery.GeleverdVolume;
                ACKWMOPrestatieQueryTable.Eenheid := WMOPrestatieQuery.Eenheid;
                ACKWMOPrestatieQueryTable.ProductTarief := WMOPrestatieQuery.ProductTarief;
                ACKWMOPrestatieQueryTable.Bedrag := WMOPrestatieQuery.Bedrag;
                ACKWMOPrestatieQueryTable.DebitCredit := WMOPrestatieQuery.DebitCredit;
                ACKWMOPrestatieQueryTable.Insert();
            end;
            WMOPrestatieQuery.Close();
        end;
    end;

    var

        ACKWMOPrestatieQueryTable: Record ACKWMOPrestatieQueryTable temporary;
}
