/// <summary>
/// Query ACKWMORetourCodeQuery
/// </summary>
query 50004 ACKWMORetourCodeQuery
{
    Caption = 'Retourcode query';
    QueryType = Normal;

    elements
    {
        dataitem(ACKWMORetourCode; ACKWMORetourCode)
        {
            column(RetourCodeSystemId; SystemId)
            {
            }
            column(Id; ID)
            {
            }
            column(Description; Description)
            {
            }
            column(IsActive; IsActive)
            {
            }
            column(MessageInvalid; MessageInvalid)
            {
            }

            dataitem(ACKWMOMessageRetourCode; ACKWMOMessageRetourCode)
            {
                SqlJoinType = InnerJoin;
                DataItemLink = RetourCodeID = ACKWMORetourCode.ID;

                column(MessageRetourCodeSystemId; SystemId)
                {
                }
                column(HeaderId; HeaderId)
                {

                }
                column(RefId; RefID)
                {
                }
                column(RelationTableNo; RelationTableNo)
                {
                }
                column(Rule; Rule)
                {
                }
                // dataitem(ACKWMOHeader; ACKWMOHeader)
                // {
                //     SqlJoinType = InnerJoin;
                //     DataItemLink = SystemId = ACKWMOMessageRetourCode.HeaderId;

                //     column(SystemId; SystemId)
                //     {
                //     }
                // }
            }
        }
    }
}