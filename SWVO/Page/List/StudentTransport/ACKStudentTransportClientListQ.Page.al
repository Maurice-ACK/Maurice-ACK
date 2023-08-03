// /// <summary>
// /// Page ACKStudentTransportClientListQ
// /// </summary>
// page 50044 ACKStudentTransportClientListQ
// {
//     ApplicationArea = All;
//     Caption = 'Leerlingen', Locked = true;
//     PageType = Worksheet;
//     SourceTable = ACKStudentTransportClientTemp;
//     CardPageID = ACKClientCard;
//     Editable = true;

//     layout
//     {
//         area(content)
//         {
//             group(header)
//             {
//                 ShowCaption = false;
//                 field(SchoolYear; YearSearchPrefix)
//                 {
//                     Caption = 'School jaar', Locked = true;
//                     Editable = true;

//                     trigger OnLookup(var Text: Text): Boolean
//                     var
//                         pageSchedule: Page ACKStudentTransportYearSubpage;
//                     begin
//                         Clear(pageSchedule);
//                         pageSchedule.LookupMode := true;
//                         pageSchedule.Editable := false;
//                         pageSchedule.SetTableView(Year);
//                         pageSchedule.SetRecord(Year);

//                         if pageSchedule.RunModal() = Action::LookupOK then
//                             pageSchedule.GetRecord(Year);

//                         addDataToPage();
//                         YearSearchPrefix := Year."Years";
//                     end;

//                 }
//             }

//             repeater(General)
//             {
//                 field(ClientNo; Rec.ClientNo)
//                 {
//                     Editable = false;
//                 }
//                 field(routelistId; rec.scheduleId)
//                 {
//                     Visible = true;
//                 }
//                 field(CustomerID; Rec.CustomerID)
//                 {
//                     Visible = false;
//                     TableRelation = ACKStudentTransportCustomer.CustomerId;
//                     Editable = false;
//                 }
//                 field(Initials; Rec.Initials)
//                 {
//                     Editable = false;
//                 }
//                 field("First Name"; Rec."First Name")
//                 {
//                     Editable = false;
//                 }
//                 field("Middle Name"; Rec."Middle Name")
//                 {
//                     Editable = false;
//                 }
//                 field(Surname; Rec.Surname)
//                 {
//                     Editable = false;
//                 }

//                 field(Gender; Rec.Gender)
//                 {
//                     Editable = false;
//                 }
//                 field(Birthdate; rec.Birthdate)
//                 {
//                     Editable = false;
//                 }
//                 field(User; Rec.User_Name)
//                 {
//                     Editable = false;
//                 }
//                 field(UserId; Rec.User_Security_ID)
//                 {
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field(compensation; rec.compensation)
//                 {
//                 }
//                 field(contribution; rec.contribution)
//                 {
//                 }
//                 field(schoolName; rec.schoolName)
//                 {
//                     Editable = false;
//                 }
//                 field(phone; rec.phone)
//                 {
//                 }
//                 field(mobile; rec."mobile phone")
//                 {
//                 }
//             }
//             grid(Documents)
//             {
//                 part(ACKDocumentListPart; ACKDocumentListPart)
//                 {
//                     Editable = false;
//                     SubPageLink = "No." = field(ClientNo);
//                 }
//             }
//         }

//         area(FactBoxes)
//         {
//             Part(clientData; ACKStudentTransportFactIndict)
//             {
//                 SubPageLink = ClientNo = field(ClientNo);
//             }
//             part(clientAdress; AckStudentTranportAdressList)
//             {
//                 SubPageLink = ClientNo = field(ClientNo);
//             }
//             part(Notes; ACKClientNotesListPage)
//             {
//                 Editable = true;
//                 SubPageLink = ClientNo = field(ClientNo);
//             }
//         }
//     }

//     actions
//     {
//         area(Navigation)
//         {
//             group(Test)
//             {
//                 action("Schedule")
//                 {
//                     Promoted = true;
//                     PromotedOnly = true;
//                     PromotedCategory = Category4;
//                     Image = CalendarWorkcenter;
//                     RunObject = Page ACKStudentTransportSchedule;
//                     RunPageLink = custRecordId = field(CustRec);
//                 }
//                 action("Card")
//                 {
//                     Caption = 'Kaart', Locked = true;
//                     Promoted = true;
//                     PromotedOnly = true;
//                     PromotedCategory = Category4;
//                     Image = Card;
//                     RunObject = Page ACKStudentTransportCard2;
//                     RunPageLink = custRecordId = field(CustRec);
//                 }
//                 action("Node's")
//                 {
//                     Caption = 'Node''s', Locked = true;
//                     Promoted = true;
//                     PromotedOnly = true;
//                     PromotedCategory = Category4;
//                     Image = Map;
//                     RunObject = Page ACKStudentTransportNode;
//                     RunPageLink = custRecordId = field(CustRec);
//                 }

//                 action("Change Attendant")
//                 {
//                     Caption = 'Wijzig begeleider', Locked = true;
//                     Promoted = true;
//                     PromotedOnly = true;
//                     PromotedCategory = Process;
//                     Image = PersonInCharge;

//                     trigger OnAction()
//                     begin
//                         changeUser();
//                     end;
//                 }

//                 action("mail")
//                 {
//                     Caption = 'Verzend mail', Locked = true;
//                     Promoted = true;
//                     PromotedOnly = true;
//                     PromotedCategory = Process;
//                     Image = SendMail;

//                     trigger OnAction()
//                     begin
//                         Email();
//                     end;
//                 }
//                 action(UploadFile)
//                 {
//                     Caption = 'Upload bestand', Locked = true;
//                     Image = Document;
//                     Enabled = true;
//                     Promoted = true;
//                     PromotedCategory = Category5;

//                     trigger OnAction()
//                     var
//                         DocumentAttachmentDetails: Page "Document Attachment Details";
//                         doc: Record "Document Attachment";
//                         RecRef: RecordRef;

//                     begin
//                         doc.SetFilter("No.", '=%1', Rec.ClientNo);
//                         OnBeforeDrillDown(doc, RecRef);
//                         DocumentAttachmentDetails.OpenForRecRef(RecRef);
//                         DocumentAttachmentDetails.RunModal();
//                     end;


//                 }
//                 action("Print")
//                 {
//                     trigger OnAction()
//                     begin
//                         PrintForUsage();
//                     end;
//                 }
//                 action("codeBlock")
//                 {
//                     RunObject = Page ACKStudentTransportRouteLookup;
//                     RunPageLink = routelListId = field(scheduleId);
//                 }
//                 action("page")
//                 {
//                     RunObject = page ACKStudentTransportSchoolQ;
//                 }
//                 action("query")
//                 {
//                     trigger OnAction()
//                     begin

//                         Message(Database.UserId);
//                     end;
//                 }
//             }

//         }
//     }


//     trigger OnModifyRecord(): Boolean
//     var
//         UserName: Record User;
//         clientData: Record ACKSTTClientData;

//     begin
//         clientData.ClientNo := rec.ClientNo;

//         if clientData.Find('=') then begin
//             clientData.contribution := rec.contribution;
//             clientData.compensation := rec.compensation;
//             clientData.Modify();
//         end;

//         Rec.Modify();
//     end;

//     trigger OnOpenPage()
//     var
//         formatter: Codeunit ACKStudentApiFormatter;
//         startY: Integer;
//         endY: Integer;

//     begin
//         formatter.getStartEndYear(System.Today, System.Today, startY, endY);
//         Year.startDate := startY;
//         Year.endDate := endY;
//         YearSearchPrefix := formatter.yearToText(System.Today, System.Today);
//         addDataToPage();
//     end;

//     procedure changeUser()
//     var
//         clientData: record ACKSTTClientData;
//         userQ: Page ACKStudentTransportUserLookup;

//     begin
//         userQ.LookupMode := true;

//         if userQ.RunModal() = Action::LookupOK then begin
//             userQ.GetRecord(userBC);
//             rec.User_Security_ID := userBC.userGuid;
//             rec.User_Name := userBC.Name;
//         end;

//         clientData.ClientNo := rec.ClientNo;

//         if clientData.Find('=') then begin
//             clientData.Attendant := userBC.userGuid;
//             clientData.Modify();

//         end;

//         CurrPage.Update(true);
//     end;

//     local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
//     var
//         ACKClient: Record ACKClient;

//     begin
//         RecRef.Open(DATABASE::"ACKClient");
//         if ACKClient.Get(rec.ClientNo) then
//             RecRef.GetTable(ACKClient);
//     end;

//     procedure changeReportLayout()
//     var
//         rls: record "Report Layout Selection";
//         Layout: Record "Custom Report Layout";
//         clientData: record ACKSTTClientData;

//     begin
//         Layout.SetRange("Report ID", 50000);

//         if page.RunModal(page::"ACKSelectLayout", Layout) = action::LookupOK then begin
//             rls.SetTempLayoutSelected(Layout.Code);
//             rec.emailLayout := Layout.Description;
//             rec.Modify();
//         end;

//         clientData.ClientNo := rec.ClientNo;
//         if clientData.Find('=') then begin
//             clientData.EmailLayoutCode := Layout.Code;
//             clientData.Modify();
//         end;

//         CurrPage.Update(true);
//     end;

//     procedure addDataToPage()
//     var
//         queryInd: Query ACKStudentTransportClQueryV2;
//         schoolQ: Query ACKStudentTransportSchool;

//     begin
//         Rec.DeleteAll();

//         if not (Year."startDate" = 0) then begin
//             queryInd.SetFilter(startDate, '>=%1', Year."startDate");
//             queryInd.SetFilter(endDate, '<=%1', Year."endDate");
//         end;



//         if queryInd.Open() then begin

//             while queryInd.Read() do begin
//                 Rec.Init();
//                 Rec.ClientNo := queryInd.ClientNo;
//                 Rec.scheduleId := queryInd.scheduleId;

//                 if (not Rec.Find()) then begin
//                     Rec.ClientNo := queryInd.ClientNo;
//                     Rec."First Name" := queryInd.FirstName;
//                     Rec."Middle Name" := queryInd.MiddleName;
//                     Rec.Surname := queryInd.Surname;
//                     Rec.CustomerID := queryInd.CustomerID;
//                     Rec.User_Security_ID := queryInd.User_Security_ID;
//                     Rec.User_Name := queryInd.User_Name;
//                     Rec.CustRec := queryInd.custRecordId;
//                     rec.Initials := queryInd.Initials;
//                     rec.Birthdate := queryInd.Birthdate;
//                     rec.Gender := queryInd.Gender;
//                     rec.contribution := queryInd.contribution;
//                     rec.compensation := queryInd.compensation;
//                     rec."mobile phone" := queryInd.mobile_phone;
//                     rec.phone := queryInd.telefoon;
//                     rec.emailCode := queryInd.EmailLayoutCode;
//                     rec.emailLayout := queryInd.Description;
//                     rec.scheduleId := queryInd.scheduleId;
//                     rec.routelistId := queryInd.routelist;
//                     schoolQ.SetFilter(custRecordId, '=%1', rec.CustRec);
//                     schoolQ.SetFilter(scheduleId, '=%1', rec.routelistId);
//                     schoolQ.Open();

//                     if schoolQ.Read() then
//                         rec.schoolName := schoolQ.name;
//                     schoolQ.Close();

//                     Rec.Insert();
//                 end;

//             end;

//             queryInd.Close();
//         end;


//     end;





//     local procedure PrintForUsage()
//     var
//         rls: record "Report Layout Selection";
//         client: Record ACKClient;
//         test: Report ACKStudentTransportCustReport;

//     begin
//         client.SetCurrentKey(ClientNo);
//         client.SetFilter(ClientNo, '=%1', Rec.ClientNo);
//         test.SetTableView(client);
//         test.Run();


//     end;

//     local procedure Email(): Boolean
//     var
//         outs: OutStream;
//         ref: RecordRef;
//         fref: FieldRef;
//         reports: Record "Report Selections";
//         mailReport: report ACKStudentTransportCustReport;
//         Layout: Record "Custom Report Layout";
//         client: Record ACKClient;

//         recieve: text;
//         address: record ACKClientAddress;
//         tBlob: codeunit "temp blob";
//         mail: Codeunit "Email Message";
//         mailobj: codeunit "Email";
//         body: text;

//     begin

//         reports.SetCurrentKey("Report ID");

//         reports."Report ID" := 50000;



//         if true then begin
//             tBlob.CreateOutStream(outs);

//             ref.Open(Database::ACKClient);
//             fref := ref.field(Rec.FieldNo(ClientNo));
//             fref.setfilter('=%1', Rec.ClientNo);

//             address.SetFilter(ClientNo, '=%1', rec.ClientNo);

//             if address.FindFirst() then
//                 recieve := address.EmailAddress;

//             if rec.emailCode = '' then begin
//                 Layout.SetRange("Report ID", REport::ACKStudentTransportCustReport);
//                 if page.RunModal(page::ACKSelectLayout, Layout) = action::LookupOK then
//                     mailReport.setLayout(Layout.Code)
//                 else
//                     exit(false);

//             end
//             else
//                 mailReport.setLayout(rec.emailCode);

//             client.SetCurrentKey(ClientNo);
//             client.SetFilter(ClientNo, '=%1', Rec.ClientNo);

//             mailReport.SetTableView(client);
//             mailReport.SaveAs('', ReportFormat::Word, outs);
//             getDocument(outs, 'test.docx');


//         end;



//     end;


//     local procedure getDocument(outs: OutStream; fileName: text)
//     var
//         ref2: RecordRef;
//         fref: FieldRef;
//         DocumentAttachment: Record "Document Attachment";
//         ins: InStream;
//         tBlob: codeunit "temp blob";

//     begin
//         tBlob.CreateInStream(ins, TextEncoding::UTF8);

//         ref2.Open(Database::"ACKClient");
//         fref := ref2.Field(rec.FieldNo(ClientNo));
//         fref.Value := rec.ClientNo;
//         fref := ref2.Field(DocumentAttachment.FieldNo("No."));
//         fref.Value := 'AFD00730';

//         DocumentAttachment.SaveAttachmentFromStream(ins, ref2, fileName);
//     end;

//     var
//         YearSearchPrefix: text[20];
//         Year: Record ACKStudentTransportYearsLookup;
//         userBC: Record ACKStudenTransportUserLookup;

// }
