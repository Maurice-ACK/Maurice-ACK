query 50007 ACKStudentTransportYears
{
    Caption = 'StudentTransportYears';
    QueryType = Normal;
    OrderBy = descending(StartYear);

    elements
    {
        dataitem(ACKStudentTransportSchedule; ACKStudentTransportSchedule)
        {

            column(StartYear; StartDate)
            {
                Method = Year;
                ColumnFilter = StartYear = filter(> 2000);
            }
            column(startMonth; startDate)
            {
                Method = Month;
            }

            column(EndYear; endDate)
            {
                Method = Year;
                ColumnFilter = EndYear = filter(> 2000);
            }
            column(EndMonth; endDate)
            {
                Method = Month;
            }
        }
    }


}
