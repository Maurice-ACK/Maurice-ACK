/// <summary>
/// Page ACKWMOIndicationList (ID 50005).
/// </summary>
page 50005 ACKWMOIndicationList
{
    ApplicationArea = All;
    Caption = 'Client indications';
    PageType = List;
    SourceTable = ACKWMOIndication;
    UsageCategory = Lists;
    CardPageId = ACKWMOIndicationCard;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ClientNo; Rec.ClientNo)
                {
                    trigger OnDrillDown()
                    var
                        ACKClient: Record ACKClient;
                        ACKClientCard: Page ACKClientCard;
                    begin
                        ACKClient.Get(Rec.ClientNo);
                        ACKClientCard.SetRecord(ACKClient);
                        ACKClientCard.Run();
                    end;
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
                field(RedenWijziging; Rec.RedenWijziging)
                {
                }
                field(RedenBeeindiging; Rec.RedenBeeindiging)
                {
                }
                field(TempStopActive; Rec.IsTempStopActive(Today()))
                {
                    Caption = 'Tijdelijke stop', locked = true;
                    Editable = false;
                }
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
            actionref("Declarations Promoted"; Declarations)
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
            action(Declarations)
            {
                Caption = 'Declarations';
                Image = Payment;
                RunObject = page ACKWMODeclarationList;
            }
        }
    }

    /// <summary>
    /// RunFromWMOHeader.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    procedure RunFromWMOHeader(WMOHeader: Record ACKWMOHeader)
    var
        ACKWMOIndicationFilter: Record ACKWMOIndication;
        ACKWMOClient: Record ACKWMOClient;
        ACKClient: Record ACKClient;
        WMOHeaderHeen: Record ACKWMOHeader;
        RecFilter: Text;
        NoIndiciationsFoundLbl: Label 'No indications found';
    begin
        ACKWMOClient.SetCurrentKey(HeaderId);
        ACKWMOClient.SetRange(HeaderId, WMOHeader.SystemId);

        if ACKWMOClient.IsEmpty() then
            if WMOHeader.IsRetour() then begin
                WMOHeader.GetToHeader(WMOHeaderHeen, false);
                ACKWMOClient.SetRange(HeaderId, WMOHeaderHeen.SystemId);
            end;

        if ACKWMOClient.IsEmpty() then begin
            Message(NoIndiciationsFoundLbl);
            exit;
        end;

        ACKClient.SetCurrentKey(SSN);

        RecFilter := '=';

        if ACKWMOClient.FindSet() then
            repeat
                ACKClient.SetRange(SSN, ACKWMOClient.SSN);
                if ACKClient.FindFirst() then begin
                    if RecFilter <> '=' then
                        RecFilter += '|';
                    if not RecFilter.Contains(ACKClient.ClientNo) then
                        RecFilter += ACKClient.ClientNo;
                end;
            until ACKWMOClient.Next() = 0;

        if RecFilter = '=' then begin
            Message(NoIndiciationsFoundLbl);
            exit;
        end;

        ACKWMOIndicationFilter.SetFilter(ClientNo, RecFilter);
        CurrPage.SetTableView(ACKWMOIndicationFilter);
        CurrPage.Run();
    end;
}