query 50005 ACKWMOHeaderClientQuery
{
    Caption = 'Wmo Header - Client Query', Locked = true;
    QueryType = Normal;

    elements
    {
        dataitem(ACKWMOHeader; ACKWMOHeader)
        {
            column(HeaderSystemId; SystemId)
            {
            }
            column(BerichtCode; BerichtCode)
            {
            }
            column(Afzender; Afzender)
            {
            }
            column(Identificatie; Identificatie)
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
                SqlJoinType = LeftOuterJoin;

                column(ClientSystemId; SystemId)
                {
                }
                column(SSN; SSN)
                {
                }
            }
        }
    }
}
