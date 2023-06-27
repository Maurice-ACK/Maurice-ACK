/// <summary>
/// Page ACKWMOHeaderList.
/// </summary>
page 50003 ACKWMOHeaderList
{
    ApplicationArea = All;
    Caption = 'Wmo messages';
    PageType = List;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    Editable = true;
    SourceTable = ACKWMOHeader;
    SourceTableView = sorting(SystemCreatedAt) order(descending);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(BerichtCode; Rec.BerichtCode)
                {
                    trigger OnDrillDown()
                    var
                        WMOMessagePageCard: Page ACKWMOMessagePageDoc;
                        WMOMessageDeclDoc: Page ACKWMOMessageDeclDoc;
                    begin
                        if (Rec.BerichtCode = ACKVektisCode::wmo323) or (Rec.BerichtCode = ACKVektisCode::wmo325) then begin
                            WMOMessageDeclDoc.SetRecord(Rec);
                            WMOMessageDeclDoc.Run()
                        end
                        else
                            WMOMessagePageCard.RunFromACKWMOHeader(Rec);
                    end;
                }
                field(Status; Rec.Status)
                {
                }
                field(ReturnStatus; Rec.ReturnStatus())
                {
                    Caption = 'Return status';
                }
                field(Afzender; Rec.Afzender)
                {
                }
                field(AfzenderName; Rec.AfzenderName())
                {
                    Caption = 'Afzender naam', Locked = true;
                }
                field(Ontvanger; Rec.Ontvanger)
                {
                }
                field(OntvangerName; Rec.OntvangerName())
                {
                    Caption = 'Ontvanger naam', Locked = true;
                }
                field(Identificatie; Rec.Identificatie)
                {
                }
                field(Dagtekening; Rec.Dagtekening)
                {
                }
                field(LeadTime; Rec.LeadTime())
                {
                    Caption = 'Doorlooptijd', Locked = true;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Importance = Additional;
                }
            }
            part(MessageRetourCodeLPart; ACKWMOMessageRetourCodeLPart)
            {
                SubPageLink = HeaderId = field(SystemId);
                SubPageView = where(MessageInvalid = filter(true));
                Visible = RetourCodesVisible;
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref(ToggleRetourCodesTogglePromoted; ToggleRetourCodesToggle)
            {
            }
            actionref(IndicationsPromoted; Indications)
            {
            }
            actionref(RelatedMessagesPromoted; RelatedMessages)
            {
            }
        }
        area(Reporting)
        {
            action(DownloadOriginalXML)
            {
                Image = Download;
                Caption = 'Download original xml', Locked = true;

                trigger OnAction()
                var
                    ACKDownloadWMOFile: Codeunit ACKDownloadWMOFile;
                begin
                    ACKDownloadWMOFile.DownloadOriginalXML(Rec.Referentienummer);
                end;
            }
            action(DownloadXML)
            {
                Image = Download;
                Caption = 'Download xml', Locked = true;

                trigger OnAction()
                var
                    ACKDownloadWMOFile: Codeunit ACKDownloadWMOFile;
                begin
                    ACKDownloadWMOFile.DownloadXML(Rec.Referentienummer);

                end;
            }
        }
        area(Processing)
        {
            action(ProcessWMO)
            {
                RunObject = codeunit ACKWMOMessagePageRun;
                RunPageOnRec = True;
                Image = Process;
                Caption = 'Process';
            }
            action(Validate)
            {
                Image = ValidateEmailLoggingSetup;
                Caption = 'Validate';
                trigger OnAction()
                var
                    ACKWMOIProcessor: Interface ACKWMOIProcessor;
                begin
                    ACKWMOIProcessor := Rec.BerichtCode;
                    ACKWMOIProcessor.Init(Rec);
                    ACKWMOIProcessor.Validate();
                end;
            }
            action(GenerateRetour)
            {
                Image = ReturnRelated;
                Caption = 'Generate retour';
                trigger OnAction()
                var
                    WMOGenerateRetour: Codeunit ACKWMOGenerateRetour;
                begin
                    WMOGenerateRetour.Run(Rec);
                end;
            }
        }
        area(Creation)
        {
            action(UploadXml)
            {
                Image = Import;
                Caption = 'Upload xml';
                ToolTip = 'Upload a wmo xml message from your computer.';

                trigger OnAction()
                begin
                    ACKHelper.UploadXml();
                end;
            }
            action(UploadJson)
            {
                Image = Import;
                Caption = 'Upload json';
                ToolTip = 'Upload a wmo json message from your computer.';

                trigger OnAction()
                begin
                    ACKHelper.UploadJson();
                end;
            }
        }
        area(Navigation)
        {
            action(Indications)
            {
                Caption = 'Indications';
                Image = CustomerLedger;
                ToolTip = 'View client indications.';

                trigger OnAction()
                var
                    IndicationListPage: Page ACKWMOIndicationList;
                begin
                    IndicationListPage.Editable(false);
                    IndicationListPage.RunFromWMOHeader(Rec);
                end;
            }
            action(EventLog)
            {
                Caption = 'Event log';
                Image = Log;
                RunObject = Page ACKEventLogList;
                RunPageLink = RefTableId = const(Database::ACKWMOHeader), RefSystemID = field(SystemId);
            }
            action(RelatedMessages)
            {
                Caption = 'Related messages';
                ToolTip = 'View related messages.';
                Image = Relationship;

                trigger OnAction()
                var
                    WMOHeaderRelated: Record ACKWMOHeader;
                    WMOHelper: Codeunit ACKWMOHelper;
                    RelatedWMOHeaderList: Page ACKWMOHeaderList;
                    HeaderIdFilter: Text;
                    NoRelatedMessagesFoundLbl: Label 'No related messages found.';
                begin
                    HeaderIdFilter := WMOHelper.GetRelatedMessageFilter(Rec);

                    if HeaderIdFilter = '=' then begin
                        Message(NoRelatedMessagesFoundLbl);
                        exit;
                    end;

                    WMOHeaderRelated.SetFilter(ID, HeaderIdFilter);

                    //To apply the filter to the current page use this.
                    // CurrPage.SetTableView(WMOHeaderRelated);

                    //Opens a second screen with the filter applied.
                    RelatedWMOHeaderList.SetTableView(WMOHeaderRelated);
                    RelatedWMOHeaderList.Editable(false);
                    RelatedWMOHeaderList.LookupMode(true);
                    RelatedWMOHeaderList.Run();
                end;
            }
            action(ToggleRetourCodesToggle)
            {
                Caption = 'Retour codes';
                Image = ShowWarning;

                trigger OnAction()
                begin
                    RetourCodesVisible := not RetourCodesVisible;
                end;
            }
        }
    }

    views
    {
        view("301")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo301));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '301', Locked = true;
        }
        view("302")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo302));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '302', Locked = true;
        }
        view("305")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo305));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '305', Locked = true;
        }
        view("306")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo306));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '306', Locked = true;
        }
        view("307")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo307));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '307', Locked = true;
        }
        view("308")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo308));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '308', Locked = true;
        }
        view("317")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo317));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '317', Locked = true;
        }
        view("318")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo318));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '318', Locked = true;
        }
        view("319")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo319));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '319', Locked = true;
        }
        view("320")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo320));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '320', Locked = true;
        }
        view("323")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo323));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '323', Locked = true;
        }
        view("325")
        {
            Filters = where(BerichtCode = const(ACKVektisCode::wmo325));
            OrderBy = descending(SystemCreatedAt);
            SharedLayout = true;
            Caption = '325', Locked = true;
        }
    }

    var
        ACKHelper: Codeunit ACKHelper;
        [InDataSet]
        RetourCodesVisible: boolean;
}
