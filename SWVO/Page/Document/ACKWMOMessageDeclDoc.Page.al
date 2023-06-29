/// <summary>
/// Page ACKWMOMessageDeclDoc
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
                Caption = 'Header', Locked = true;
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
                field(DebitCredit; WMODeclaration.DebitCredit)
                {
                }
                field(TotaalBedrag; WMODeclaration.TotaalBedrag)
                {
                }
            }
            group(DeclaratieAntwoord)
            {
                Visible = not Is323;
                Caption = 'Declaratie antwoord', Locked = true;
                field(DeclaratieAntwoordDNummer; WMODeclaratieAntwoord.DeclaratieNummer)
                {
                    Caption = 'Declaratie nummer', Locked = true;
                }
                field(IngediendTotaalBedrag; WMODeclaratieAntwoord.IngediendTotaalBedrag)
                {
                }
                field(IngediendDebitCredit; WMODeclaratieAntwoord.IngediendDebitCredit)
                {
                }
                field(ToegekendTotaalBedrag; WMODeclaratieAntwoord.ToegekendTotaalBedrag)
                {
                }
                field(ToegekendDebitCredit; WMODeclaratieAntwoord.ToegekendDebitCredit)
                {
                }
            }
            part(ACKWMOPrestatieListPart; ACKWMOPrestatieListPart)
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = HeaderId = field(SystemId);
                UpdatePropagation = Both;
            }

            // repeater(Prestaties)
            // {
            //     Visible = PrestatiesEnabled;
            //     Enabled = PrestatiesEnabled;
            //     Caption = 'Prestaties', Locked = true;
            //     field(SSN; ACKWMOPrestatieQueryTable.SSN)
            //     {
            //         Caption = 'BSN', Locked = true;
            //     }
            //     field(ClientName; ACKWMOPrestatieQueryTable.ClientName)
            //     {
            //         Caption = 'Naam', Locked = true;
            //     }
            //     field(ToewijzingNummer; ACKWMOPrestatieQueryTable.ToewijzingNummer)
            //     {
            //         Caption = 'Toewijzing nummer', Locked = true;
            //     }
            //     field(ProductCode; ACKWMOPrestatieQueryTable.ProductCode)
            //     {
            //         Caption = 'Productcode', Locked = true;
            //     }
            //     field(PrestatieBegindatum; ACKWMOPrestatieQueryTable.Begindatum)
            //     {
            //         Caption = 'Begindatum', Locked = true;
            //     }
            //     field(PrestatieEinddatum; ACKWMOPrestatieQueryTable.Einddatum)
            //     {
            //         Caption = 'Einddatum', Locked = true;
            //     }
            //     field(GeleverdVolume; ACKWMOPrestatieQueryTable.GeleverdVolume)
            //     {
            //         Caption = 'Geleverd volume', Locked = true;
            //     }
            //     field(Eenheid; ACKWMOPrestatieQueryTable.Eenheid)
            //     {
            //         Caption = 'Eenheid', Locked = true;
            //     }
            //     field(Bedrag; ACKWMOPrestatieQueryTable.Bedrag)
            //     {
            //         Caption = 'Bedrag', Locked = true;
            //     }
            //     field(PrestatieDebitCredit; ACKWMOPrestatieQueryTable.DebitCredit)
            //     {
            //         Caption = 'Debet/Credit', Locked = true;
            //     }
            // }
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
