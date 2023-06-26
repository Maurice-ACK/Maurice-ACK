/// <summary>
/// Page ACKSubcontractorList
/// </summary>
page 50032 ACKSubcontractorList
{
    ApplicationArea = All;
    Caption = 'Subcontractors';
    PageType = List;
    SourceTable = ACKSubcontractor;
    UsageCategory = None;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    PopulateAllFields = true;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SubcontractorNo; Rec.SubcontractorNo)
                {
                }
                field(HealthcareProviderNo; Rec.HealthcareProviderNo)
                {
                    ShowMandatory = true;
                }
                field(Name; Rec.Name)
                {
                    ShowMandatory = true;
                }
                field(IsActive; Rec.IsActive)
                {
                }
            }
        }
    }
}
