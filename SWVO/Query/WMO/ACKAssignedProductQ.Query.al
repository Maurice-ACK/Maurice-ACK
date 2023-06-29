/// <summary>
/// Query ACKAssignedProductQ
/// </summary>
query 50019 ACKAssignedProductQ
{
    Caption = 'Header - Client - Assigned product query', Locked = true;
    QueryType = Normal;
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(ACKWMOToegewezenProduct; ACKWMOToegewezenProduct)
        {
            column(ToewijzingNummer; ToewijzingNummer)
            {
                //Method = Sum;
            }

            dataitem(ACKWMOClient; ACKWMOClient)
            {
                DataItemLink = SystemId = ACKWMOToegewezenProduct.ClientID;
                SqlJoinType = InnerJoin;

                column(HeaderSystemId; HeaderId)
                {
                }
                dataitem(ACKWMOHeader; ACKWMOHeader)
                {
                    DataItemLink = SystemId = ACKWMOClient.HeaderId;
                    SqlJoinType = InnerJoin;

                    column(HeaderId; ID)
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
