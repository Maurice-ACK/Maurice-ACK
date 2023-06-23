/// <summary>
/// Query ACKToegewezenProdIndicationQ (ID 50006).
/// </summary>
query 50006 ACKToegewezenProdIndicationQ
{
    Caption = 'Assigned product - indication query';
    QueryType = Normal;

    elements
    {
        dataitem(ACKWMOHeader; ACKWMOHeader)
        {
            column(BerichtCode; BerichtCode)
            {
            }
            column(Afzender; Afzender)
            {
            }
            column(Identificatie; Identificatie)
            {
            }
            column(Ontvanger; Ontvanger)
            {
            }
            column(Referentienummer; Referentienummer)
            {
            }
            column(Status; Status)
            {
            }
            dataitem(ACKWMOClient; ACKWMOClient)
            {
                DataItemLink = HeaderId = ACKWMOHeader.SystemId;
                SqlJoinType = InnerJoin;

                column(ClientSystemId; SystemId)
                {
                }
                column(SSN; SSN)
                {
                }
                dataitem(ACKWMOToegewezenProduct; ACKWMOToegewezenProduct)
                {
                    DataItemLink = ClientID = ACKWMOClient.SystemId;
                    SqlJoinType = InnerJoin;

                    column(ToegewezenProductSystemId; SystemId)
                    {
                    }
                    column(ToewijzingNummer; ToewijzingNummer)
                    {
                    }

                    dataitem(ACKWMOIndication; ACKWMOIndication)
                    {
                        DataItemLink = AssignmentNo = ACKWMOToegewezenProduct.ToewijzingNummer, MunicipalityNo = ACKWMOHeader.Afzender;
                        SqlJoinType = InnerJoin;

                        column(IndicationSystemId; SystemId)
                        {
                        }
                        column(AssignmentNo; AssignmentNo)
                        {
                        }
                        column(MunicipalityNo; MunicipalityNo)
                        {
                        }
                    }
                }
            }
        }
    }
}
