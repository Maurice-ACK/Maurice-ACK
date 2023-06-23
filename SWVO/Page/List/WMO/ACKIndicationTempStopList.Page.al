/// <summary>
/// Page ACKIndicationTempStopList.
/// </summary>
page 50095 ACKIndicationTempStopList
{
    ApplicationArea = All;
    Caption = 'Tijdelijke stop', Locked = true;
    Editable = true;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = ACKIndicationTempStop;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(StartDate; Rec.StartDate)
                {
                }
                field(EndDate; Rec.EndDate)
                {
                }
            }
        }
    }
}