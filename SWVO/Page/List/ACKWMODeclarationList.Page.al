/// <summary>
/// Page ACKWMODeclarationList
/// </summary>
page 50111 ACKWMODeclarationList
{
    ApplicationArea = All;
    Caption = 'Wmo Declarations';
    PageType = List;
    SourceTable = ACKWMODeclarationHeader;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(DeclarationHeaderNo; Rec.DeclarationHeaderNo)
                {
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                }
                field(HealthcareProviderNo; Rec.HealthcareProviderNo)
                {
                }
                field(DeclarationNo; Rec.DeclarationNo)
                {
                }
                field(DeclarationDate; Rec.DeclarationDate)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(TotalAmount; Rec.TotalAmount)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref("Lines Promoted"; Lines)
            {
            }
        }
        area(Navigation)
        {
            action(Lines)
            {
                Caption = 'Lines';
                Image = BOM;
                RunObject = page ACKWMODeclarationLineList;
                RunPageLink = DeclarationHeaderNo = field(DeclarationHeaderNo);
            }
        }
    }
}
