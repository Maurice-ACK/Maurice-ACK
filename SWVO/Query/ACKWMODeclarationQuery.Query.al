query 50022 ACKWMODeclarationQuery
{
    Caption = 'WMODeclarationQuery', Locked = true;
    QueryType = Normal;

    elements
    {
        dataitem(ACKWMODeclarationHeader; ACKWMODeclarationHeader)
        {
            column(DeclarationHeaderNo; DeclarationHeaderNo)
            {
            }
            column(NoSeries; NoSeries)
            {
            }
            column(HeaderId; HeaderId)
            {
            }
            column(MunicipalityNo; MunicipalityNo)
            {
            }
            column(HealthcareProviderNo; HealthcareProviderNo)
            {
            }
            column(DeclarationNo; DeclarationNo)
            {
            }
            column(DeclarationDate; DeclarationDate)
            {
            }
            column(Status; Status)
            {
            }
            column(Year; Year)
            {
            }
            column(Month; Month)
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
            column(SystemCreatedBy; SystemCreatedBy)
            {
            }
            column(SystemId; SystemId)
            {
            }
            column(SystemModifiedAt; SystemModifiedAt)
            {
            }
            column(SystemModifiedBy; SystemModifiedBy)
            {
            }

            dataitem(ACKWMODeclarationLine; ACKWMODeclarationLine)
            {
                DataItemLink = DeclarationHeaderNo = ACKWMODeclarationHeader.DeclarationHeaderNo;
                SqlJoinType = InnerJoin;

                column(ID; ID)
                {
                }
                column(IndicationID; IndicationID)
                {
                }
                column(Reference; Reference)
                {
                }
                column(PreviousReference; PreviousReference)
                {
                }
                column(Amount; Amount)
                {
                }
                column(StartDate; StartDate)
                {
                }
                column(EndDate; EndDate)
                {
                }
                column(Volume; Volume)
                {
                }
                column(Unit; Unit)
                {
                }
                column(ProductRate; ProductRate)
                {
                }
                column(ClientNo; ClientNo)
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
                column(TotalLineAmount; Amount)
                {
                    Method = Sum;
                }
            }
        }
    }
}