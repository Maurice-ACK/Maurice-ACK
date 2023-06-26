/// <summary>
/// Page ACKStudentTransportIndication
/// </summary>
page 50073 ACKStudentTransportIndication
{
    ApplicationArea = All;
    Caption = 'Indicaties', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportIndication;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(Description; Rec.Description)
                { }
                field(IndicationId; Rec.IndicationId)
                { }
                field(MutationDate; Rec.MutationDate)
                { }
            }
        }
    }
}
