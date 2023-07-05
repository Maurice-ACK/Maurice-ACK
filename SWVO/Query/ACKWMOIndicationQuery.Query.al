query 50002 ACKWMOIndicationQuery
{
    Caption = 'Indication Query';
    QueryType = Normal;

    elements
    {
        dataitem(ACKClient; ACKClient)
        {
            column(ClientNo; ClientNo)
            {
            }
            column(SSN; SSN)
            {
            }

            dataitem(ACKWMOIndication; ACKWMOIndication)
            {
                SqlJoinType = InnerJoin;
                DataItemLink = ClientNo = ACKClient.ClientNo;

                column(IndicationSystemId; SystemId)
                {
                }
                column(IndicationID; ID)
                {
                }
                column(MunicipalityNo; MunicipalityNo)
                {
                }
                column(HealthcareProviderNo; HealthcareProviderNo)
                {
                }
                column(AssignmentNo; AssignmentNo)
                {
                }
                column(ProductCategoryId; ProductCategoryId)
                {
                }
                column(ProductCode; ProductCode)
                {
                }
                column(StartDate; StartDate)
                {
                }
                column(EndDate; EndDate)
                {
                }
                column(EffectiveStartDate; EffectiveStartDate)
                {
                }
                column(EffectiveEndDate; EffectiveEndDate)
                {
                }
                column(AssignedDateTime; AssignedDateTime)
                {
                }
                column(ProductVolume; ProductVolume)
                {
                }
                column(ProductUnit; ProductUnit)
                {
                }
                column(ProductFrequency; ProductFrequency)
                {
                }
                column(Budget; Budget)
                {
                }
                column(RedenWijziging; RedenWijziging)
                {
                }
            }
        }
    }
}
