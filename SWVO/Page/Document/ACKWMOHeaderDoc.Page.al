/// <summary>
/// Page ACKWMOHeaderDoc.
/// </summary>
page 50029 ACKWMOHeaderDoc
{
    ApplicationArea = All;
    Caption = 'Wmo message';
    PageType = Document;
    SourceTable = ACKWMOHeader;
    RefreshOnActivate = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Header', Locked = true;
                ShowCaption = true;

                field(Status; Rec.Status)
                {
                }
                field(Afzender; Rec.Afzender)
                {
                    Caption = 'Afzender', Locked = true;
                }
                field(AfzenderName; Rec.AfzenderName())
                {
                    Caption = 'Afzender naam', locked = true;
                }
                field(Ontvanger; Rec.Ontvanger)
                {
                }
                field(OntvangerName; Rec.OntvangerName())
                {
                    Caption = 'Ontvanger naam', Locked = true;
                }
                field(Dagtekening; Rec.Dagtekening)
                {
                }
                field(Identificatie; Rec.Identificatie)
                {
                }
                field(BerichtVersie; Rec.BerichtVersie)
                {
                }
                field(BerichtSubversie; Rec.BerichtSubversie)
                {
                }
                field(BerichtXsdVersie; Rec.BerichtXsdVersie)
                {
                }
                field(BasisschemaXsdVersie; Rec.BasisschemaXsdVersie)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
            }
            group(Retour)
            {
                Caption = 'Retour information';
                Visible = IsRetourVisible;

                field(IdentificatieRetour; Rec.IdentificatieRetour)
                {
                }

                field(DagtekeningRetour; Rec.DagtekeningRetour)
                {
                }
            }
            part(ACKWMOClientListPart; ACKWMOClientListPart)
            {
                Editable = false;
                SubPageLink = HeaderId = FIELD(SystemId);
                UpdatePropagation = Both;
            }
            part(ACKWMODeclaratieCardPart; ACKWMODeclaratieCardPart)
            {
                Editable = false;
                SubPageLink = HeaderId = field(SystemId);
                Visible = IsDeclarationVisible;
                Enabled = IsDeclarationVisible;
                UpdatePropagation = Both;
            }
        }
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                ApplicationArea = All;
                SubPageLink = RelationTableNo = const(Database::ACKWMOHeader), RefID = field(SystemId);
            }
        }
    }

    actions
    {
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
                    ACKWMOIProcessor := Rec.BerichtCode;
                    ACKWMOIProcessor.Init(Rec);
                    ACKWMOIProcessor.Process();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsRetourVisible := Rec.IsRetour();

        case Rec.BerichtCode of
            ACKVektisCode::wmo323,
            ACKVektisCode::wmo325:
                IsDeclarationVisible := true;
        end;
    end;

    var
        IsRetourVisible,
        IsDeclarationVisible : Boolean;
}
