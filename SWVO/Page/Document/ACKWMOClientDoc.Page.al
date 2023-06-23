/// <summary>
/// Page ACKWMOMessageDocument.
/// </summary>
page 50048 ACKWMOClientDoc
{
    ApplicationArea = All;
    Caption = 'Wmo message client';
    PageType = Document;
    SourceTable = ACKWMOClient;
    RefreshOnActivate = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            part(ACKWMOHeaderCardPart; ACKWMOHeaderCardPart)
            {
                Editable = false;
                SubPageLink = SystemId = field(HeaderId);
                UpdatePropagation = Both;
            }
            group(General)
            {
                ShowCaption = false;

                field(SSN; Rec.SSN)
                {
                }
                field(Geboortedatum; Rec.Geboortedatum)
                {
                }
                field(GeboortedatumGebruik; Rec.GeboortedatumGebruik)
                {
                }
                field(Geslacht; Rec.Geslacht)
                {
                }
                field(JuridischeStatus; Rec.JuridischeStatus)
                {
                }
                field(WettelijkeVertegenwoordiging; Rec.WettelijkeVertegenwoordiging)
                {
                }
                field(Voornamen; Rec.Voornamen)
                {
                }
                field(Voorletters; Rec.Voorletters)
                {
                }
                field(NaamGebruik; Rec.NaamGebruik)
                {
                }
                field(Achternaam; Rec.Achternaam)
                {
                }
                field(Voorvoegsel; Rec.Voorvoegsel)
                {
                }
                field(PartnerAchternaam; Rec.PartnerAchternaam)
                {
                }
                field(PartnerVoorvoegsel; Rec.PartnerVoorvoegsel)
                {
                }
                field(CommunicatieVorm; Rec.CommunicatieVorm)
                {
                }
                field(CommunicatieTaal; Rec.CommunicatieTaal)
                {
                }
                field(Commentaar; Rec.Commentaar)
                {
                }
            }
            part(ACKToegewezenProductListPart; ACKToegewezenProductListPart)
            {
                Editable = false;
                SubPageLink = ClientID = FIELD(SystemId);
                Visible = IsToegewezenProductListPartVisible;
                Enabled = IsToegewezenProductListPartVisible;
                UpdatePropagation = Both;
            }
            part(ACKWMOContactListPart; ACKWMOContactListPart)
            {
                Editable = false;
                SubPageLink = RelationTableNo = const(Database::ACKWMOClient), RefID = field(SystemId);
                Visible = IsContactListPartVisible;
                Enabled = IsContactListPartVisible;
                UpdatePropagation = Both;
            }
            part(ACKWMORelatieListPart; ACKWMORelatieListPart)
            {
                Editable = false;
                SubPageLink = ClientID = field(SystemId);
                Visible = IsRelatieListPartVisible;
                Enabled = IsRelatieListPartVisible;
                UpdatePropagation = Both;
            }
            part(ACKWMOStartStopProductListPart; ACKWMOStartStopProductListPart)
            {
                Editable = false;
                SubPageLink = ClientId = field(SystemId);
                Visible = IsStartStopProductListPartVisible;
                Enabled = IsStartStopProductListPartVisible;
                UpdatePropagation = Both;
            }
            part(ACKNewChangedUnchangedProductL; ACKNewChangedUnchangedProductL)
            {
                Editable = false;
                SubPageLink = ClientID = field(SystemId);
                Visible = IsNewChangedUnchangedProductLVisible;
                Enabled = IsNewChangedUnchangedProductLVisible;
                UpdatePropagation = Both;
            }
            part(ACKWMOPrestatieListPart; ACKWMOPrestatieListPart)
            {
                Editable = false;
                Visible = IsDeclarationVisible;
                Enabled = IsDeclarationVisible;
                SubPageLink = ClientId = field(SystemId);
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                SubPageLink = RelationTableNo = const(Database::ACKWMOClient), RefID = field(SystemId);
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Indication)
            {
                Caption = 'Client';
                Image = Customer;
                RunObject = Page ACKClientCard;
                RunPageLink = SSN = field(SSN);
                ToolTip = 'View client.';
            }
        }
        area(Processing)
        {
            action(Generate)
            {
                Image = "Action";
                Caption = 'Process';
                trigger OnAction()
                var
                    ACKWMOIProcessor: Interface ACKWMOIProcessor;
                begin
                    ACKWMOIProcessor := WMOHeader.BerichtCode;
                    ACKWMOIProcessor.Init(WMOHeader);
                    ACKWMOIProcessor.Process();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RecordId: RecordId;
    begin
        RecordId := Rec.RecordId();

        // case RecordId.TableNo() of
        //     Database::ACKWMOHeader:
        //         WMOHeader := Rec;

        WMOHeader := Rec.GetHeader();

        RetourCodeText := ACKHelper.GetRetourCodeText(Database::ACKWMOClient, Rec.SystemId);

        IsClientVisible := true;
        IsRetourVisible := WMOHeader.IsRetour();

        case WMOHeader.BerichtCode of
            ACKVektisCode::wmo301,
            ACKVektisCode::wmo302:
                begin
                    IsToegewezenProductListPartVisible := true;
                    IsContactListPartVisible := true;
                    IsRelatieListPartVisible := true;
                end;
            ACKVektisCode::wmo305,
            ACKVektisCode::wmo306,
            ACKVektisCode::wmo307,
            ACKVektisCode::wmo308:
                IsStartStopProductListPartVisible := true;
            ACKVektisCode::wmo317,
            ACKVektisCode::wmo318:
                IsNewChangedUnchangedProductLVisible := true;
            ACKVektisCode::wmo323,
            ACKVektisCode::wmo325:
                begin
                    IsClientVisible := false;
                    IsDeclarationVisible := true;
                end;
        end;
    end;

    var
        WMOHeader: Record ACKWMOHeader;
        ACKHelper: codeunit ACKHelper;
        RetourCodeText: Text;
        IsClientVisible,
        IsRetourVisible,
        IsToegewezenProductListPartVisible,
        IsContactListPartVisible,
        IsRelatieListPartVisible,
        IsStartStopProductListPartVisible,
        IsNewChangedUnchangedProductLVisible,
        IsDeclarationVisible : Boolean;
}
