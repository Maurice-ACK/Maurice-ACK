/// <summary>
/// Query ACKProductCodeMonthRateQuery
/// </summary>
query 50003 ACKProductCodeMonthRateQuery
{
    Caption = 'Product code rate query', Locked = true;
    QueryType = Normal;

    elements
    {
        dataitem(ACKProductCodeRateMonth; ACKProductCodeRateMonth)
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
                DataItemLink = ProductCodeRateMonthID = ACKProductCodeRateMonth.ID;
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
