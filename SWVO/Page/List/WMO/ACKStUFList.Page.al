/// <summary>
/// Page ACKStUF
/// </summary>
page 50020 ACKStUFList
{
    ApplicationArea = All;
    Caption = 'Stuf';
    PageType = List;
    SourceTable = ACKStUF;
    CardPageId = ACKStUFCard;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    SourceTableView = sorting(SystemCreatedAt) order(descending);

    AboutTitle = 'Incoming StUF messages';
    AboutText = 'Messages received from cities and healthcare providers.';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Referentienummer; Rec.Referentienummer)
                {
                }
                field(Functie; Rec.Functie)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Berichtcode; Rec.Berichtcode)
                {
                }
                field(ZenderOrganisatie; Rec.ZenderOrganisatie)
                {
                }
                field(ZenderApplicatie; Rec.ZenderApplicatie)
                {
                }
                field(ZenderAdministratie; Rec.ZenderAdministratie)
                {
                }
                field(ZenderGebruiker; Rec.ZenderGebruiker)
                {
                }
                field(OntvangerOrganisatie; Rec.OntvangerOrganisatie)
                {
                }
                field(OntvangerApplicatie; Rec.OntvangerApplicatie)
                {
                }
                field(OntvangerAdministratie; Rec.OntvangerAdministratie)
                {
                }
                field(OntvangerGebruiker; Rec.OntvangerGebruiker)
                {
                }
                field(TijdstipBericht; Rec.TijdstipBericht)
                {
                }
                field(ApplicatieVersie; Rec.ApplicatieVersie)
                {
                }
                field(ApplicatieSubVersie; Rec.ApplicatieSubVersie)
                {
                }
                field(FunctieVersie; Rec.FunctieVersie)
                {
                }
                field(FunctieSubVersie; Rec.FunctieSubVersie)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            action(ShowErrorLog)
            {
                Image = ErrorLog;
                Caption = 'Error log';
                Promoted = true;
                PromotedCategory = Report;
                RunObject = Page ACKEventLogList;
                RunPageLink = RefTableId = CONST(Database::ACKStUF),
                                RefSystemID = FIELD(SystemId);
            }
            action(DownloadJSON)
            {
                Image = Download;
                Caption = 'Download JSON';
                ToolTip = 'Download JSON';

                trigger OnAction()
                var
                    ACKDownloadWMOFile: Codeunit ACKDownloadWMOFile;
                begin
                    ACKDownloadWMOFile.DownloadOriginalJSON(Rec.Referentienummer);
                end;
            }
            action(DownloadXML)
            {
                Image = Download;
                Caption = 'Download XML';
                ToolTip = 'Download XML';

                trigger OnAction()
                var
                    ACKDownloadWMOFile: Codeunit ACKDownloadWMOFile;
                begin
                    ACKDownloadWMOFile.DownloadOriginalXML(Rec.Referentienummer);
                end;
            }
        }
        area(Processing)
        {
            action(Process)
            {
                RunObject = codeunit ACKStUFPageRun;
                RunPageOnRec = True;
                Image = Process;
                Caption = 'Process';
                ToolTip = 'Process';
            }
            action(ProcessWMO)
            {
                Image = Process;
                Caption = 'Process All';
                ToolTip = 'Process All new';

                trigger OnAction()
                var
                    StUFPageRun: codeunit ACKStUFPageRun;
                begin
                    StUFPageRun.ProcessAllNew();
                end;
            }
        }
        area(Creation)
        {
            action(UploadXml)
            {
                Image = Import;
                Caption = 'Upload XML';
                ToolTip = 'Upload a Wmo XML message from your computer.';

                trigger OnAction()
                begin
                    ACKHelper.UploadXml();
                end;
            }
        }
        area(Navigation)
        {
            action(ClientDoc)
            {
                Caption = 'Wmo';
                Image = Document;

                trigger OnAction()
                var
                    WMOHeader: Record ACKWMOHeader;
                    MessagePageDoc: Page ACKWMOMessagePageDoc;
                    WMOMessageDeclDoc: Page ACKWMOMessageDeclDoc;
                begin
                    WMOHeader.SetRange(Referentienummer, Rec.Referentienummer);
                    WMOHeader.FindFirst();

                    if (Rec.Functie = ACKVektisCode::wmo323) or (Rec.Functie = ACKVektisCode::wmo325) then begin
                        WMOMessageDeclDoc.SetRecord(WMOHeader);
                        WMOMessageDeclDoc.SetTableView(WMOHeader);
                        WMOMessageDeclDoc.Run();
                    end
                    else
                        MessagePageDoc.RunFromReferentienummer(Rec.Referentienummer);
                end;
            }
        }
    }

    var
        ACKHelper: Codeunit ACKHelper;
}