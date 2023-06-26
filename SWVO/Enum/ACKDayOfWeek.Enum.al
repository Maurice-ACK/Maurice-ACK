/// <summary>
/// Enum ACKDayOfWeek
/// </summary>
enum 50007 ACKDayOfWeek
{
    Extensible = true;
    Caption = 'Day of the week';

    /// <summary>
    /// Specifies that the recurrence to occur on Monday.
    /// </summary>
    value(1; Monday)
    {
        Caption = 'Monday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on Tuesday.
    /// </summary>
    value(2; Tuesday)
    {
        Caption = 'Tuesday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on Wednesday.
    /// </summary>
    value(3; Wednesday)
    {
        Caption = 'Wednesday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on Thursday.
    /// </summary>
    value(4; Thursday)
    {
        Caption = 'Thursday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on Friday.
    /// </summary>
    value(5; Friday)
    {
        Caption = 'Friday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on Saturday.
    /// </summary>
    value(6; Saturday)
    {
        Caption = 'Saturday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on Sunday.
    /// </summary>
    value(7; Sunday)
    {
        Caption = 'Sunday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur every day.
    /// </summary>
    value(8; Day)
    {
        Caption = 'Day';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on all days from Monday to Friday.
    /// </summary>
    value(9; Weekday)
    {
        Caption = 'Weekday';
    }

    /// <summary>
    /// Specifies that the recurrence to occur on Saturday and Sunday.
    /// </summary>
    value(10; "Weekend Day")
    {
        Caption = 'Weekend day';
    }

}
