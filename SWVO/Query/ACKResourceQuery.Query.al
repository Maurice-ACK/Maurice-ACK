/// <summary>
/// Query ACKResourceQuery
/// </summary>
query 50018 ACKResourceQuery
{
    Caption = 'ResourceQuery';
    QueryType = Normal;

    elements
    {
        dataitem(ACKResourceStart; ACKResource)
        {
            DataItemTableFilter = "Type" = filter(S | M);

            column(ClientNo; ClientNo)
            {
            }
            column(StartId; Id)
            {
            }
            dataitem(ACKResourceEnd; ACKResource)
            {
                SqlJoinType = FullOuterJoin;
                DataItemLink = ClientNo = ACKResourceStart.ClientNo, ProductCode = ACKResourceStart.ProductCode, StartDate = ACKResourceStart.StartDate;
                DataItemTableFilter = "Type" = const(B);

                column(EndId; Id)
                {
                }
            }
        }
    }
}
