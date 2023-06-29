/// <summary>
/// Page ACKWMOMessagePageDoc
/// </summary>
page 50057 ACKWMOMessagePageDoc
{
    ApplicationArea = All;
    Caption = 'Wmo bericht', Locked = true;
    PageType = Document;
    SourceTable = ACKWMOHeaderClientQueryTable;
    SourceTableTemporary = true;
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
                field(Status; WMOHeader.Status)
                {
                }
                field(ReturnStatus; WMOHeader.ReturnStatus())
                {
                    Caption = 'Return status';
                }
                field(Identificatie; WMOHeader.Identificatie)
                {
                }
                field(Dagtekening; WMOHeader.Dagtekening)
                {
                }
                group(GroupSender)
                {
                    Caption = 'Afzender', Locked = true;
                    field(Afzender; WMOHeader.Afzender)
                    {
                        CaptionClass = WMOHeader.AfzenderCaption() + ' No.';
                    }
                    field(AfzenderName; WMOHeader.AfzenderName())
                    {
                        CaptionClass = WMOHeader.AfzenderCaption();
                    }
                }
                group(GroupReceiver)
                {
                    Caption = 'Ontvanger';
                    field(Ontvanger; WMOHeader.Ontvanger)
                    {
                        CaptionClass = WMOHeader.OntvangerCaption() + ' No.';
                    }
                    field(OntvangerName; WMOHeader.OntvangerName())
                    {
                        CaptionClass = WMOHeader.OntvangerCaption();
                    }
                }

                group(Retour)
                {
                    Caption = 'Retour information';
                    Visible = IsRetourVisible;

                    field(IdentificatieRetour; WMOHeader.IdentificatieRetour)
                    {
                        Importance = Promoted;
                    }

                    field(DagtekeningRetour; WMOHeader.DagtekeningRetour)
                    {
                    }
                    field(XsltVersie; WMOHeader.XsltVersie)
                    {
                        Importance = Additional;
                    }
                }

                group(Other)
                {
                    Caption = 'Overige';
                    field(Referentienummer; WMOHeader.Referentienummer)
                    {
                        Importance = Additional;
                    }
                    field(BerichtVersie; WMOHeader.BerichtVersie)
                    {
                        Caption = 'Bericht versie', Locked = true;
                        Importance = Additional;
                    }
                    field(BerichtSubversie; WMOHeader.BerichtSubversie)
                    {
                        Caption = 'Bericht sub versie', Locked = true;
                        Importance = Additional;
                    }
                    field(BasisschemaXsdVersie; WMOHeader.BasisschemaXsdVersie)
                    {
                        Caption = 'Basisschema XSD versie', Locked = true;
                        Importance = Additional;
                    }
                    field(BerichtXsdVersie; WMOHeader.BerichtXsdVersie)
                    {
                        Caption = 'Bericht XSD versie', Locked = true;
                        Importance = Additional;
                    }
                    field(BasisschemaXsdVersieRetour; WMOHeader.BasisschemaXsdVersieRetour)
                    {
                        Caption = 'Basisschema XSD versie retour', Locked = true;
                        Importance = Additional;
                    }
                    field(BerichtXsdVersieRetour; WMOHeader.BerichtXsdVersieRetour)
                    {
                        Caption = 'Bericht XSD versie retour', Locked = true;
                        Importance = Additional;
                    }
                }
            }

            group(Client)
            {
                Caption = 'Client';
                Visible = IsClientVisible;
                field(SSN; WMOClient.SSN)
                {
                }
                field(Geboortedatum; WMOClient.Geboortedatum)
                {
                    Importance = Additional;
                }
                field(Voornamen; WMOClient.Voornamen)
                {
                }
                field(Voorletters; WMOClient.Voorletters)
                {
                }
                field(Achternaam; WMOClient.Achternaam)
                {
                }
                field(Voorvoegsel; WMOClient.Voorvoegsel)
                {
                }
                field(Commentaar; WMOClient.Commentaar)
                {
                }
                field(Geslacht; WMOClient.Geslacht)
                {
                    Importance = Additional;
                }
                field(JuridischeStatus; WMOClient.JuridischeStatus)
                {
                    Caption = 'Juridische status', Locked = true;
                    Importance = Additional;
                }
                field(WettelijkeVertegenwoordiging; WMOClient.WettelijkeVertegenwoordiging)
                {
                    Caption = 'WettelijkeVertegenwoordiging', Locked = true;
                    Importance = Additional;
                }
                field(PartnerAchternaam; WMOClient.PartnerAchternaam)
                {
                    Caption = 'Partner achternaam', Locked = true;
                    Importance = Additional;
                }
                field(PartnerVoorvoegsel; WMOClient.PartnerVoorvoegsel)
                {
                    Caption = 'Partner voorvoegsel', Locked = true;
                    Importance = Additional;
                }
                field(CommunicatieVorm; WMOClient.CommunicatieVorm)
                {
                    Caption = 'Communicatie vorm', Locked = true;
                    Importance = Additional;
                }
                field(CommunicatieTaal; WMOClient.CommunicatieTaal)
                {
                    Caption = 'Communicatie taal', Locked = true;
                    Importance = Additional;
                }
                field(NaamGebruik; WMOClient.NaamGebruik)
                {
                    Caption = 'Naam gebruik', Locked = true;
                    Importance = Additional;
                }
                field(GeboortedatumGebruik; WMOClient.GeboortedatumGebruik)
                {
                    Caption = 'Geboortedatum gebruik', Locked = true;
                    Importance = Additional;
                }
            }
            part(ACKToegewezenProductListPart; ACKToegewezenProductListPart)
            {
                Editable = false;
                SubPageLink = ClientID = field(ClientSystemID);
                Visible = IsToegewezenProductListPartVisible;
                Enabled = IsToegewezenProductListPartVisible;
                UpdatePropagation = Both;
            }

            part(ACKWMOContactListPart; ACKWMOContactListPart)
            {
                Editable = false;
                SubPageLink = RelationTableNo = const(Database::ACKWMOClient), RefID = field(ClientSystemID);
                Visible = IsContactListPartVisible;
                Enabled = IsContactListPartVisible;
                UpdatePropagation = Both;
            }
            part(ACKWMORelatieListPart; ACKWMORelatieListPart)
            {
                Editable = false;
                SubPageLink = ClientID = field(ClientSystemID);
                Visible = IsRelatieListPartVisible;
                Enabled = IsRelatieListPartVisible;
                UpdatePropagation = Both;
            }
            part(ACKWMOStartStopProductListPart; ACKWMOStartStopProductListPart)
            {
                Editable = false;
                SubPageLink = ClientId = field(ClientSystemID);
                Visible = IsStartStopProductListPartVisible;
                Enabled = IsStartStopProductListPartVisible;
                UpdatePropagation = Both;
            }
            part(ACKNewChangedUnchangedProductL; ACKNewChangedUnchangedProductL)
            {
                Editable = false;
                SubPageLink = ClientID = field(ClientSystemID);
                Visible = IsNewChangedUnchangedProductLVisible;
                Enabled = IsNewChangedUnchangedProductLVisible;
                UpdatePropagation = Both;
            }
            part(ACKWMOAntwoordCardPart; ACKWMOAntwoordCardPart)
            {
                Editable = false;
                SubPageLink = HeaderId = field(HeaderSystemID);
                Visible = IsAntwoordPartVisible;
                Enabled = IsAntwoordPartVisible;
                UpdatePropagation = Both;
            }
        }
        // area(FactBoxes)
        // {
        //     part(ACKWMOMessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
        //     {
        //         SubPageLink = HeaderId = field(HeaderSystemId);
        //     }
        // }
    }
    actions
    {
        area(Processing)
        {
            action(Process)
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

            action(Validate)
            {
                Image = ValidateEmailLoggingSetup;
                Caption = 'Validate';
                trigger OnAction()
                var
                    ACKWMOIProcessor: Interface ACKWMOIProcessor;
                begin
                    ACKWMOIProcessor := WMOHeader.BerichtCode;
                    ACKWMOIProcessor.Init(WMOHeader);
                    ACKWMOIProcessor.Validate();
                end;
            }
            action(GenerateRetour)
            {
                Image = ReturnRelated;
                Caption = 'Generate retour';
                Enabled = not IsRetourVisible;

                trigger OnAction()
                var
                    WMOGenerateRetour: Codeunit ACKWMOGenerateRetour;
                begin
                    WMOGenerateRetour.Run(WMOHeader);
                end;
            }
        }
    }

    /// <summary>
    /// RunFromReferentienummer.
    /// </summary>
    /// <param name="_Referentienummer">Guid.</param>
    procedure RunFromReferentienummer(_Referentienummer: Guid)
    begin
        Clear(WMOHeader);
        WMOHeader.SetRange(Referentienummer, _Referentienummer);
        WMOHeader.SetLoadFields(SystemId);
        if WMOHeader.FindFirst() then
            RunFromACKWMOHeader(WMOHeader);
    end;

    /// <summary>
    /// RunFromACKWMOHeader.
    /// </summary>
    /// <param name="_WMOHeader">Record ACKWMOHeader.</param>
    procedure RunFromACKWMOHeader(_WMOHeader: Record ACKWMOHeader)
    var
        EmptyHeaderErr: Label 'No Wmo message found.';
    begin
        if not _WMOHeader.IsEmpty() then begin
            WMOHeader := _WMOHeader;
            Rec.MapFromHeaderId(WMOHeader.SystemId);
            Rec.Insert(false);
            CurrPage.Run();
        end
        else
            Error(EmptyHeaderErr);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        WMOHeader.GetBySystemId(Rec.HeaderSystemID);

        if not IsNullGuid(Rec.ClientSystemID) then
            WMOClient.GetBySystemId(Rec.ClientSystemID);

        IsClientVisible := not IsNullGuid(WMOClient.SystemId);
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
            ACKVektisCode::wmo319,
            ACKVektisCode::wmo320:
                IsAntwoordPartVisible := true;
        end;

        if not IsClientVisible then begin
            IsToegewezenProductListPartVisible := false;
            IsStartStopProductListPartVisible := false;
            IsNewChangedUnchangedProductLVisible := false;
            IsContactListPartVisible := false;
            IsRelatieListPartVisible := false;
        end;
    end;

    var
        WMOHeader: Record ACKWMOHeader;
        WMOClient: Record ACKWMOClient;
        [InDataSet]
        IsRetourVisible,
        IsClientVisible,
        IsToegewezenProductListPartVisible,
        IsContactListPartVisible,
        IsRelatieListPartVisible,
        IsStartStopProductListPartVisible,
        IsNewChangedUnchangedProductLVisible,
        IsAntwoordPartVisible : Boolean;
}
