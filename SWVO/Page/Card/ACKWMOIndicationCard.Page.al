/// <summary>
/// Page ACKWMOIndicationCard (ID 50072).
/// </summary>
page 50072 ACKWMOIndicationCard
{
    ApplicationArea = All;
    Caption = 'Client indication';
    PageType = Card;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    SourceTable = ACKWMOIndication;
    UsageCategory = None;
    DataCaptionFields = ClientNo, AssignmentNo, MunicipalityNo, HealthcareProviderNo;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ClientNo; Rec.ClientNo)
                {
                    // Editable = false;
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                }
                field(HealthcareProviderNo; Rec.HealthcareProviderNo)
                {
                }
                field(AssignmentNo; Rec.AssignmentNo)
                {
                }
            }
            group(Product)
            {
                Caption = 'Product', locked = true;

                field(ProductCode; Rec.ProductCode)
                {
                }
                field(StartDate; Rec.StartDate)
                {
                }
                field(EndDate; Rec.EndDate)
                {
                }
                field(EffectiveStartDate; Rec.EffectiveStartDate)
                {
                }
                field(EffectiveEndDate; Rec.EffectiveEndDate)
                {
                }
                field(AssignedDateTime; Rec.AssignedDateTime)
                {
                }
                field(TempStopActive; Rec.IsTempStopActive(Today()))
                {
                    Caption = 'Tijdelijke stop', locked = true;
                    Editable = false;
                }
            }
            group(Omvang)
            {
                Caption = 'Omvang';

                field(ProductVolume; Rec.ProductVolume)
                {
                }
                field(ProductUnit; Rec.ProductUnit)
                {
                }
                field(ProductFrequency; Rec.ProductFrequency)
                {
                }
                field(Budget; Rec.Budget)
                {
                }
            }
            group(System)
            {
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(TempStopPromoted; TempStop)
            {
            }
        }
        area(Navigation)
        {
            action(TempStop)
            {
                ApplicationArea = All;
                Caption = 'Tijdelijke stops', Locked = true;
                Image = Timesheet;
                RunObject = Page ACKIndicationTempStopList;
                RunPageMode = View;
                RunPageLink = IndicationSystemID = field(SystemId);
            }
        }
    }
}

