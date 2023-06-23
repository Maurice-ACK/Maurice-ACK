query 50010 ACKStudentTransportIndictionQ
{
    Caption = 'StudentTransportIndictionQ';
    QueryType = Normal;

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
                column(custRecordId; custRecordId) { }


                dataitem(ACKStudentTransportCard; ACKStudentTransportCard)
                {
                    DataItemLink = custRecordId = ACKStudentTransportClientData.custRecordId;

                    column(CardId; CardId) { }
                    column(Category; Category) { }
                    column(CardStatusId; CardStatusId) { }
                    column(CardNumber; CardNumber) { }
                    column(serviceId; serviceId) { }
                    column(locationId; locationId) { }
                    column(contractId; contractId) { }


                    dataitem(ACKStudentTransportCustIndicat; ACKStudentTransportCustIndicat)
                    {
                        DataItemLink = custRecordId = ACKStudentTransportClientData.custRecordId;

                        column(CreationDate; CreationDate) { }
                        column(MutationDate; MutationDate) { }
                        column(AdditionalValue; AdditionalValue) { }
                        column(Indication; Indication) { }


                        dataitem(ACKStudentTransportIndication; ACKStudentTransportIndication)
                        {
                            DataItemLink = indicationId = ACKStudentTransportCustIndicat.indication;

                            column(indicationId; indicationId) { }

                            column(descriptionInd; description) { }

                            column(mutationDateIndication; mutationDate) { }



                            dataitem(ACKStudentTransportSchedule; ACKStudentTransportSchedule)
                            {



                                DataItemLink = custRecordId = ACKStudentTransportClientData.custRecordId;
                                column(countIndex)
                                {
                                    Method = Count;
                                }

                                dataitem(ACKStudentTransportCustomer; ACKStudentTransportCustomer)
                                {

                                    DataItemLink = custRecordId = ACKStudentTransportClientData.custRecordId;
                                    column(customerStatus; customerStatus)
                                    {

                                    }

                                }

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
