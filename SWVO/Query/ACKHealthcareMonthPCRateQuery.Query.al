/// <summary>
/// Query ACKHealthcareMonthPCRateQuery (ID 50003).
/// </summary>
query 50003 ACKHealthcareMonthPCRateQuery
{
    Caption = 'Healthcare month - product code rate query';
    QueryType = Normal;

    elements
    {
        dataitem(ACKHealthcareMonth; ACKHealthcareMonth)
        {
            column(Year; Year)
            {
            }
            column(Month; Month)
            {
            }
            column(IsActive; IsActive)
            {
            }
            dataitem(ACKProductCodeRate; ACKProductCodeRate)
            {
                DataItemLink = HealthcareMonthID = ACKHealthcareMonth.ID;
                SqlJoinType = InnerJoin;

                column(ProductCode; ProductCode)
                {
                }
                column(IndicationUnitid; IndicationUnitid)
                {
                }
                column(DeclarationUnitId; DeclarationUnitId)
                {
                }
                column(Rate; Rate)
                {
                }
                column(IsPredefined; IsPredefined)
                {
                }
                column(ProductCategoryId; ProductCategoryId)
                {
                }
                column(ProductCodeDescription; ProductCodeDescription)
                {
                }
            }
        }
    }
}
