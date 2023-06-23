query 50001 ACKInvalidPCCombinationQuery
{
    Caption = 'InvalidPCCombinationQuery';
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

                column(MunicipalityNo; MunicipalityNo)
                {
                }
                column(HealthcareProviderNo; HealthcareProviderNo)
                {
                }
                column(AssignmentNo; AssignmentNo)
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

                dataitem(ACKInvalidPCCombination; ACKInvalidPCCombination)
                {
                    DataItemLink = ProductCode = ACKWMOIndication.ProductCode;
                    SqlJoinType = InnerJoin;

                    column(ProductCodeInvalid; ProductCodeInvalid)
                    {
                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
