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
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
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

                column(LineID; ID)
                {
                }
                column(LineIndicationID; IndicationID)
                {
                }
                column(LineReference; Reference)
                {
                }
                column(LinePreviousReference; PreviousReference)
                {
                }
                column(LineAmount; Amount)
                {
                }
                column(LineStartDate; StartDate)
                {
                }
                column(LineEndDate; EndDate)
                {
                }
                column(LineYear; Year)
                {
                }
                column(LineMonth; Month)
                {
                }
                column(LineVolume; Volume)
                {
                }
                column(LineUnit; Unit)
                {
                }
                column(LineProductRate; ProductRate)
                {
                }
                column(LineClientNo; ClientNo)
                {
                }
                column(LineAssignmentNo; AssignmentNo)
                {
                }
                column(LineProductCategoryId; ProductCategoryId)
                {
                }
                column(LineProductCode; ProductCode)
                {
                }
                column(LineStatus; Status)
                {
                }
            }
        }
    }
}