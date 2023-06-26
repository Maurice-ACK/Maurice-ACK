/// <summary>
/// Query ACKSTTFilterSchool
/// </summary>
query 50016 ACKSTTFilterSchool
{
    Caption = 'STTFilterSchool Query', Locked = true;
    QueryType = Normal;

    elements
    {
        dataitem(ACKStudentTransportClientData; ACKStudentTransportClientData)
        {
            column(Attendant; Attendant)
            {
            }
            column(Caterogy; Caterogy)
            {
            }
            column(ClientNo; ClientNo)
            {
            }
            column(CustomerID; CustomerID)
            {
            }
            column(EmailLayoutCode; EmailLayoutCode)
            {
            }
            column(compensation; compensation)
            {
            }
            column(contribution; contribution)
            {
            }
            column(custRecordId; custRecordId)
            {
            }
            dataitem(ACKStudentTransportSchedule; ACKStudentTransportSchedule)
            {
                DataItemLink = custRecordId = ACKStudentTransportClientData.custRecordId;
                column(routelist; routelist) { }


                dataitem(ACKStudentTransportRoute; ACKStudentTransportRoute)
                {
                    DataItemLink = scheduleId = ACKStudentTransportSchedule.routelist;

                    column(routeId; routeId) { }
                    column(scheduleId; scheduleId) { }

                    column(checkInNode; checkInNode) { }
                    column(checkOutNode; checkOutNode) { }



                    dataitem(ACKStudentTransportNode; ACKStudentTransportNode)
                    {
                        DataItemLink = nodeId = ACKStudentTransportRoute.checkOutNode;

                        column(schoolName; name)
                        { }

                        column(nodeTypeId2; nodeType) { }



                        dataitem(ACKStudentTransportSchoolNode; ACKStudentTransportSchoolNode)
                        {
                            DataItemLink = nodetypeId = ACKStudentTransportNode.nodeType;
                            SqlJoinType = InnerJoin;

                            DataItemTableFilter = School = filter(true);
                            column(nodeTypeId; nodeTypeId) { }
                            column(nameType; Name)
                            {

                            }

                            column(School2; School)
                            {

                            }

                        }


                    }

                }



            }
        }
    }


    trigger OnBeforeOpen()
    begin

    end;
}
