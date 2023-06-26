/// <summary>
/// Query ACKStartStopProductQuery
/// </summary>
query 50020 ACKStartStopProductQ
{
    Caption = 'Header - Client - Start/Stop product query';
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(ACKWMOStartStopProduct; ACKWMOStartStopProduct)
        {
            column(Id; Id)
            {
            }
            column(ToewijzingNummer; ToewijzingNummer)
            {
            }
            column(RedenBeeindiging; RedenBeeindiging)
            {
            }
            column(StatusAanlevering; StatusAanlevering)
            {
            }

            dataitem(ACKWMOClient; ACKWMOClient)
            {
                DataItemLink = SystemId = ACKWMOStartStopProduct.ClientId;
                SqlJoinType = InnerJoin;

                column(ClientSystemId; SystemId)
                {
                }

                column(HeaderSystemId; HeaderId)
                {
                }

                dataitem(ACKWMOHeaderHeen; ACKWMOHeader)
                {
                    DataItemLink = SystemId = ACKWMOClient.HeaderId;
                    SqlJoinType = InnerJoin;

                    column(HeaderId; ID)
                    {
                    }
                    column(BerichtCode; BerichtCode)
                    {
                    }
                    column(Status; Status)
                    {
                    }
                    column(Identificatie; Identificatie)
                    {
                    }
                    column(Afzender; Afzender)
                    {
                    }
                    column(IdentificatieRetour; IdentificatieRetour)
                    {
                    }
                }
            }
        }
    }
}