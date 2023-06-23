/// <summary>
/// Page ACKWMOMessageDeclDoc (ID 50079).
/// </summary>
page 50079 ACKWMOMessageDeclDoc
{
    ApplicationArea = All;
    Caption = 'Wmo message declaration';
    PageType = Document;
    SourceTable = ACKWMOHeader;
    SourceTableTemporary = false;
    UsageCategory = None;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(content)
        {
            group(Header)
            {
                Caption = 'Header';
                field(Status; Rec.Status)
                {
                }
                field(ReturnStatus; Rec.ReturnStatus())
                {
                    Caption = 'Return status';
                }
                field(Identificatie; Rec.Identificatie)
                {
                }
                field(Dagtekening; Rec.Dagtekening)
                {
                }
                group(GroupSender)
                {
                    Caption = 'Afzender', Locked = true;
                    field(Afzender; Rec.Afzender)
                    {
                        CaptionClass = Rec.AfzenderCaption() + ' No.';
                    }
                    field(AfzenderName; Rec.AfzenderName())
                    {
                        CaptionClass = Rec.AfzenderCaption();
                    }
                }
                group(GroupReceiver)
                {
                    Caption = 'Ontvanger';
                    field(Ontvanger; Rec.Ontvanger)
                    {
                        CaptionClass = Rec.OntvangerCaption() + ' No.';
                    }
                    field(OntvangerName; Rec.OntvangerName())
                    {
                        CaptionClass = Rec.OntvangerCaption();
                    }
                }

                group(Retour)
                {
                    Caption = 'Retour information';
                    Visible = IsRetourVisible;

                    field(IdentificatieRetour; Rec.IdentificatieRetour)
                    {
                        Importance = Promoted;
                    }

                    field(DagtekeningRetour; Rec.DagtekeningRetour)
                    {
                    }
                    field(XsltVersie; Rec.XsltVersie)
                    {
                        Importance = Additional;
                    }
                }

                group(Other)
                {
                    Caption = 'Overige';
                    field(Referentienummer; Rec.Referentienummer)
                    {
                        Importance = Additional;
                    }
                    field(BerichtVersie; Rec.BerichtVersie)
                    {
                        Importance = Additional;
                    }
                    field(BerichtSubversie; Rec.BerichtSubversie)
                    {
                        Importance = Additional;
                    }
                    field(BasisschemaXsdVersie; Rec.BasisschemaXsdVersie)
                    {
                        Importance = Additional;
                    }
                    field(BerichtXsdVersie; Rec.BerichtXsdVersie)
                    {
                        Importance = Additional;
                    }
                    field(BasisschemaXsdVersieRetour; Rec.BasisschemaXsdVersieRetour)
                    {
                        Importance = Additional;
                    }
                    field(BerichtXsdVersieRetour; Rec.BerichtXsdVersieRetour)
                    {
                        Importance = Additional;
                    }
                }
            }
            group(Declaration)
            {
                Visible = Is323;
                Caption = 'Declaration';
                field(DeclaratieNummer; WMODeclaration.DeclaratieNummer)
                {
                }
                field(Begindatum; WMODeclaration.Begindatum)
                {
                }
                field(Einddatum; WMODeclaration.Einddatum)
                {
                }
                field(DeclaratieDagtekening; WMODeclaration.DeclaratieDagtekening)
                {
                    Importance = Additional;
                }
                field(DebetCredit; WMODeclaration.DebetCredit)
                {
                }
                field(TotaalBedrag; WMODeclaration.TotaalBedrag)
                {
                }
            }
            group(DeclaratieAntwoord)
            {
                Visible = not Is323;
                Caption = 'Declaratie antwoord';
                field(DeclaratieAntwoordDNummer; WMODeclaratieAntwoord.DeclaratieNummer)
                {
                    Caption = 'Declaratie nummer';
                }
                field(IngediendTotaalBedrag; WMODeclaratieAntwoord.IngediendTotaalBedrag)
                {
                }
                field(IngediendDebetCredit; WMODeclaratieAntwoord.IngediendDebetCredit)
                {
                }
                field(ToegekendTotaalBedrag; WMODeclaratieAntwoord.ToegekendTotaalBedrag)
                {
                }
                field(ToegekendDebetCredit; WMODeclaratieAntwoord.ToegekendDebetCredit)
                {
                }
            }
            part(ACKWMOClientListPart; ACKWMOClientListPart)
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = HeaderId = field(SystemId);
            }
        }
        area(FactBoxes)
        {
            part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                ApplicationArea = All;
                SubPageLink = HeaderId = field(SystemId);
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        case Rec.BerichtCode of
            ACKVektisCode::wmo323:
                begin
                    WMODeclaration.Get(Rec.SystemId);
                    Is323 := true;
                    IsRetourVisible := false;
                end;
            ACKVektisCode::wmo325:
                begin
                    Is323 := false;
                    WMODeclaratieAntwoord.Get(Rec.SystemId);
                end;
            else
                Error('Wrong page for message type: %1', Rec.BerichtCode);
        end;
    end;

    var
        WMODeclaration: Record ACKWMODeclaratie;
        WMODeclaratieAntwoord: Record ACKWMODeclaratieAntwoord;
        IsRetourVisible, Is323 : Boolean;
}
