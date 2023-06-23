/// <summary>
/// Page ACKStudentTransportCard (ID 50036).
/// </summary>
page 50036 ACKStudentTransportCard2
{
    ApplicationArea = All;
    Caption = 'Kaart', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportCard;
    UsageCategory = Administration;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ApproveDate; Rec.ApproveDate)
                {
                }
                field(CardNumber; Rec.CardNumber)
                {
                }
                field(CardStatusId; Rec.CardStatusId)
                {
                }
                field(CardTypeId; Rec.CardTypeId)
                {
                }
                field(Category; Rec.Category)
                {
                }
                field(ContractId; Rec.ContractId)
                {
                }
                field(LocationId; Rec.LocationId)
                {
                }
                field(MutationDate; Rec.MutationDate)
                {
                }
                field(ReplacedCard; Rec.ReplacedCard)
                {
                }
                field(ServiceId; Rec.ServiceId)
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
