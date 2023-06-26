/// <summary>
/// Query ACKWMOMessageRetourCodeQuery
/// </summary>
query 50000 ACKWMOMessageRetourCodeQuery
{
    Caption = 'Retour code query';
    QueryType = Normal;

    elements
    {
        dataitem(ACKWMOMessageRetourCode; ACKWMOMessageRetourCode)
        {
            column(HeaderId; HeaderId)
            {
            }
            column(RetourCodeId; RetourCodeID)
            {
            }
            column(RefId; RefID)
            {
            }
            column(RelationTableNo; RelationTableNo)
            {
            }

            dataitem(ACKWMORetourCode; ACKWMORetourCode)
            {
                DataItemLink = ID = ACKWMOMessageRetourCode.RetourCodeID;
                SqlJoinType = InnerJoin;

                column(Description; Description)
                {
                }
                column(MessageInvalid; MessageInvalid)
                {
                }
                column(IsActive; IsActive)
                {
                    ColumnFilter = IsActive = const(true);
                }
            }
        }
    }
}
