/// <summary>
/// /// /// Page ACKClientList.
/// </summary>
page 50009 ACKClientList
{
    Caption = 'Clients';
    CardPageID = ACKClientCard;
    Editable = true;
    PageType = List;
    QueryCategory = 'Client List';
    SourceTable = ACKClient;
    UsageCategory = Lists;
    ApplicationArea = All;
    AboutTitle = 'About clients';
    AboutText = 'Here you overview all registered clients.';

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(ClientNo; Rec.ClientNo)
                { }
                field(SSN; Rec.SSN)
                {
                }
                field("First Name"; Rec."First Name")
                { }
                field("Middle Name"; Rec."Middle Name")
                { }
                field(surname; Rec.Surname)
                { }
                field(Initials; Rec.Initials)
                { }
                field(Birthdate; Rec.Birthdate)
                { }
                field(Gender; Rec.Gender)
                { }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50010),
                               "No." = FIELD(ClientNo);
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            group(WMOPromoted)
            {
                Caption = 'Wmo', Locked = true;

                actionref(WMOIndicationsPromoted; WMOIndications)
                {
                }
            }
            group(ProtectedLivingPromoted)
            {
                Caption = 'Beschermd wonen', Locked = true;

                actionref("Connected Resources promoted"; "Connected Resources")
                {
                }
                actionref("Ended Resources promoted"; "Ended Resources")
                {
                }
                actionref(HomelessPromoted; Homeless)
                {
                }
            }
            group(StudentTransportPromoted)
            {
                Caption = 'Leerlingenvervoer', Locked = true;

                actionref("Ride registration promoted"; "Ride registration")
                {
                }
                actionref("Wmo Transport promoted"; "Wmo Transport")
                {
                }
                actionref("Student Transport promoted"; "Student Transport")
                {
                }
                actionref("Student Query promoted"; "Student Query")
                {
                }
            }
        }
        area(Navigation)
        {
            group(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                action(DimensionsSingle)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions-Single';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(50010),
                                      "No." = FIELD(ClientNo);
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                }
                action(DimensionsMultiple)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions-&Multiple';
                    Image = DimensionSets;
                    ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                    trigger OnAction()
                    var
                        ACKClient: Record ACKClient;
                        DefaultDimMultiple: Page "Default Dimensions-Multiple";
                    begin
                        CurrPage.SetSelectionFilter(ACKClient);
                        DefaultDimMultiple.SetMultiRecord(ACKClient, Rec.FieldNo(ClientNo));
                        DefaultDimMultiple.RunModal();
                    end;
                }
            }
            group(Wmo)
            {
                Caption = 'Wmo', Locked = true;
                action(WMOIndications)
                {
                    Caption = 'Indications';
                    ToolTip = 'View client indications.';
                    Image = CustomerLedger;
                    RunObject = Page ACKWMOIndicationList;
                    RunPageLink = ClientNo = field(ClientNo);
                }
            }
            group(BeschermdWonen)
            {
                Caption = 'Beschermd wonen', Locked = true;
                action("Connected Resources")
                {
                    Image = Document;
                    Caption = 'Gelinkte hulpmiddelen', Locked = true;
                    ToolTip = 'Toon gelinkte hulpmiddelen van de cliënt', Locked = true;

                    trigger OnAction()
                    var
                        ResourceStart, ResourceEnd : Record ACKResource;
                        ResourceList: Page ACKResourceList;
                        RecFilter: Text;
                    begin
                        RecFilter := '=';
                        ResourceStart.SetRange(ClientNo, Rec.ClientNo);
                        ResourceStart.SetFilter("Type", '=S|M');
                        if ResourceStart.FindSet() then
                            repeat
                                ResourceEnd.SetFilter(Id, '<>%1', ResourceStart.Id);
                                ResourceEnd.SetRange(ClientNo, Rec.ClientNo);
                                ResourceEnd.SetRange(ProductCode, ResourceStart.ProductCode);
                                ResourceEnd.SetRange(StartDate, ResourceStart.StartDate);
                                ResourceEnd.SetRange("Type", ACKResourceType::B);
                                if ResourceEnd.IsEmpty() then begin
                                    if RecFilter <> '=' then
                                        RecFilter += '|';
                                    RecFilter += format(ResourceStart.Id);
                                end;
                            until ResourceStart.Next() = 0;

                        if RecFilter = '=' then begin
                            Message('Geen hulpmiddelen gevonden.');
                            exit;
                        end;
                        Clear(ResourceStart);
                        ResourceStart.SetFilter(Id, RecFilter);
                        ResourceList.SetTableView(ResourceStart);
                        ResourceList.Run();
                    end;
                }
                action("Ended Resources")
                {
                    Caption = 'Beëindigde hulpmiddelen', Locked = true;
                    ToolTip = 'Toon beëindigde hulpmiddelen.', Locked = true;
                    Image = Document;
                    RunObject = Page ACKResourceList;
                    RunPageLink = ClientNo = FIELD(ClientNo), "type" = const(B);
                }
                action(Homeless)
                {
                    Caption = 'Dakloosheid', Locked = true;
                    ToolTip = 'Toon dakloosheid registratie.', Locked = true;
                    Image = Document;
                    RunObject = Page ACKHomelessList;
                    RunPageLink = ClientNo = FIELD(ClientNo);
                }
            }
            group(StudentTransport)
            {
                Caption = 'Leerlingenvervoer', Locked = true;

                action("Ride registration")
                {
                    Caption = 'Ritregistratie', Locked = true;
                    Image = Document;
                    RunObject = Page ACKTransportLineList;
                    RunPageLink = SSN = FIELD(SSN);
                }

                action("Wmo Transport")
                {
                    Caption = 'Wmo vervoer', Locked = true;
                    Image = Document;
                    RunObject = Page ACKTransportMutationList;
                    RunPageLink = ClientNo = FIELD(ClientNo);
                }

                action("Student Transport")
                {
                    Caption = 'Leerlingenvervoer', Locked = true;
                    Image = GLJournal;
                    RunObject = Page ACKStudentTransportClientListQ;
                }
                action("Student Query")
                {
                    Caption = 'Leerlingenvervoer', Locked = true;
                    Visible = false;
                    Image = Document;
                    RunObject = Query ACKStudentTransportClQueryV2;
                }
            }
        }
        area(Creation)
        {
            action(WordTemplate)
            {
                Caption = 'Apply Word Template';
                ToolTip = 'Apply a Word template on the selected records.';
                Image = Word;

                trigger OnAction()
                var
                    ACKClient: Record ACKClient;
                    WordTemplateSelectionWizard: Page "Word Template Selection Wizard";
                begin
                    CurrPage.SetSelectionFilter(ACKClient);
                    WordTemplateSelectionWizard.SetData(ACKClient);
                    WordTemplateSelectionWizard.RunModal();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ACKClient: Record ACKClient;
    begin
        CurrPage.SetSelectionFilter(ACKClient);

    end;

    trigger OnOpenPage()
    var
        OfficeManagement: codeunit "Office Management";
    begin
        IsOfficeAddin := OfficeManagement.IsAvailable();
    end;

    var
        IsOfficeAddin: Boolean;
}