// query 50008 ACKStudentTransportClQueryV2
// {
//     Caption = 'StudentTransportClQueryV2';
//     QueryType = Normal;

//     elements
//     {
//         dataitem(ACKStudentTransportClientData; ACKSTTClientData)
//         {
//             column(Attendant; Attendant)
//             {
//             }
//             column(ClientNo; ClientNo)
//             {
//             }

//             column(CustomerID; CustomerID)
//             {
//             }
//             column(custRecordId; custRecordId) { }
//             column(Caterogy; custRecordId) { }
//             column(EmailLayoutCode; EmailLayoutCode)
//             {

//             }
//             column(compensation; compensation)
//             {

//             }
//             column(contribution; contribution) { }

//             dataitem(ACKClient; ACKClient)
//             {
//                 SqlJoinType = InnerJoin;
//                 DataItemLink = ClientNo = ACKStudentTransportClientData.ClientNo;
//                 column(Birthdate; Birthdate)
//                 {
//                 }

//                 column(FirstName; "First Name")
//                 {
//                 }
//                 column(Gender; Gender)
//                 {
//                 }
//                 column(Initials; Initials)
//                 {
//                 }
//                 column(MiddleName; "Middle Name")
//                 {
//                 }
//                 column(NoSeries; NoSeries)
//                 {
//                 }
//                 column(SSN; SSN)
//                 {
//                 }
//                 column(Surname; Surname)
//                 {
//                 }

//                 dataitem(Custom_Report_Layout; "Custom Report Layout")
//                 {
//                     DataItemLink = Code = ACKStudentTransportClientData.EmailLayoutCode;

//                     column(Description; Description)
//                     {

//                     }
//                     dataitem(User; User)
//                     {
//                         DataItemLink = "User Security ID" = ACKStudentTransportClientData.Attendant;

//                         column(User_Name; "User Name") { }
//                         column(User_Security_ID; "User Security ID") { }

//                         dataitem(ACKStudentTransportSchedule; ACKStudentTransportSchedule)
//                         {
//                             DataItemLink = custRecordId = ACKStudentTransportClientData.custRecordId;

//                             column(SchoolYear; SchoolYear)
//                             {
//                             }
//                             column(startDate; startDate)
//                             {
//                                 Method = Year;
//                             }
//                             column(endDate; endDate)
//                             {
//                                 Method = Year;

//                             }
//                             column(startDate2; startDate)
//                             {


//                             }
//                             column(endDate2; endDate)
//                             {


//                             }

//                             column(startDateTransport; startDateTransport)
//                             {

//                             }
//                             column(modified; modified)
//                             {

//                             }
//                             column(routelist; routelist)
//                             {

//                             }
//                             column(scheduleId; routelist) { }

//                             dataitem(ACKStudentTransportRoute; ACKStudentTransportRoute)
//                             {
//                                 DataItemLink = scheduleId = ACKStudentTransportSchedule.routelist;





//                                 dataitem(ACKStudentTransportNode; ACKStudentTransportNode)
//                                 {
//                                     DataItemLink = nodeId = ACKStudentTransportRoute.checkOutNode;
//                                     SqlJoinType = LeftOuterJoin;
//                                     column(CheckOutname; name) { }

//                                     dataitem(ACKStudentTransportSchoolNode; ACKStudentTransportSchoolNode)
//                                     {
//                                         DataItemLink = nodetypeId = ACKStudentTransportNode.nodeType;
//                                         SqlJoinType = InnerJoin;

//                                         DataItemTableFilter = School = filter(true);
//                                         column(nodeTypeId; nodeTypeId) { }
//                                         column(nameType; Name)
//                                         {

//                                         }

//                                         column(School2; School)
//                                         {

//                                         }

//                                         dataitem(ACKClientAddress; ACKClientAddress)
//                                         {
//                                             DataItemLink = ClientNo = ACKclient.ClientNo;
//                                             column(EmailAddress; EmailAddress) { }
//                                             column(telefoon; Phone) { }
//                                             column(mobile_phone; MobilePhone) { }
//                                         }
//                                     }
//                                 }



//                             }

//                         }

//                     }
//                 }

//             }


//         }
//     }

//     trigger OnBeforeOpen()
//     begin

//     end;
// }
