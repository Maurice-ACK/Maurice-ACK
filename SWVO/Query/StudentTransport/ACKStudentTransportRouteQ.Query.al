query 50014 ACKStudentTransportRouteQ
{
    Caption = 'StudentTransportRouteQ';
    QueryType = Normal;

    elements
    {
        dataitem(ACKStudentTransportSchedule; ACKStudentTransportSchedule)
        {
            /*
            column(routelist; routelist) { }
            column(startDate; startDate) { }
            column(endDate; endDate) { }*/

            dataitem(ACKStudentTransportRoute; ACKStudentTransportRoute)
            {
                DataItemLink = scheduleId = ACKStudentTransportSchedule.routelist;


                dataitem(ACKStudentTransportNode; ACKStudentTransportNode)
                {
                    DataItemLink = nodeid = ACKStudentTransportRoute.checkInNode;
                    column(name1; name)
                    {

                    }
                    dataitem(ACKStudentTransportNodeType; ACKStudentTransportNodeType)
                    {
                        DataItemLink = nodeTypeId = ACKStudentTransportNode.nodeType;
                        column(nameNT1; name) { }
                        dataitem(ACKStudentTransportNode2; ACKStudentTransportNode)
                        {
                            DataItemLink = nodeid = ACKStudentTransportRoute.checkOutNode;

                            column(name2; name)
                            {

                            }
                            dataitem(ACKStudentTransportNodeType1; ACKStudentTransportNodeType)
                            {
                                DataItemLink = nodeTypeId = ACKStudentTransportNode2.nodeType;
                                column(nameNT2; name) { }

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
