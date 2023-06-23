query 50013 ACKStudentTransportScheduleQv2
{
    Caption = 'StudentTransportScheduleQ';
    QueryType = Normal;
    QueryCategory = 'StudentTransport Query';

    elements
    {

        dataitem(ACKClient; ACKClient)
        {
            column(ClientNo; ClientNo) { }
            dataitem(ACKStudentTransportClientData; ACKStudentTransportClientData)
            {
                DataItemLink = ClientNo = ACKClient.ClientNo;
                SqlJoinType = InnerJoin;

                column(CustomerID; CustomerID) { }

                dataitem(ACKStudentTransportSchedule; ACKStudentTransportSchedule)
                {
                    DataItemLink = custRecordId = ACKStudentTransportClientData.custRecordId;

                    column(routelist; routelist) { }
                    column(Remarks; Remarks) { }
                }
            }


        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
