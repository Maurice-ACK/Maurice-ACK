query 50009 ACKStudentTransportScheduleQ
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
                    DataItemLink = CustomerId = ACKStudentTransportClientData.CustomerId;

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
