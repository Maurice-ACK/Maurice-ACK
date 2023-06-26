/// <summary>
/// Page ACKStudentTransportCustIndic
/// </summary>
page 50041 ACKStudentTransportCustIndic
{
    ApplicationArea = All;
    Caption = 'Indicaties', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportCustIndicat;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(AdditionalValue; Rec.AdditionalValue)
                {
                }
                field(CreationDate; Rec.CreationDate)
                {
                }
                field(IndicationId; Rec.Indication)
                {
                }
                field(MutationDate; Rec.MutationDate)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }
}
