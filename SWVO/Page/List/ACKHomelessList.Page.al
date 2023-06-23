/// <summary>
/// Page ACKHomelessList (ID 50051).
/// </summary>
page 50051 ACKHomelessList
{
    Caption = 'Homeless';
    CardPageID = ACKHomelessCard;
    DataCaptionFields = SSN_Available;
    PageType = List;
    SourceTable = ACKHomeless;
    UsageCategory = Administration;
    ApplicationArea = All;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            group(header)
            {
                field(StartDate; fieldTextStartDate)
                {
                    Editable = true;
                    Lookup = true;
                    Caption = 'Start date';
                    ToolTip = 'Set the start date filter on the page';

                    trigger OnDrillDown()
                    begin
                        DateSelector();
                    end;
                }
                field(endDate; fieldTextEndDate)
                {
                    Editable = true;
                    Lookup = true;
                    Caption = 'End date';
                    ToolTip = 'Set the end date filter on the page';
                    trigger OnDrillDown()
                    begin
                        DateSelector();
                    end;
                }
            }
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    Editable = true;
                }
                field(ClientNo; Rec.ClientNo)
                {
                    Editable = true;
                }
                field(Appropiate; Rec.Appropiate)
                {
                    Editable = true;
                }
                field(Birthyear; Rec.Birthyear)
                {
                    Editable = true;
                }
                field(SSN_Available; Rec.SSN_Available)
                {
                    Editable = true;
                }
                field(CauseIn; Rec.CauseIn)
                {
                    Editable = true;
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                    Editable = true;
                }
                field(MunicipalityNoEntry; Rec.MunicipalityNoEntry)
                {
                    Editable = true;
                }
                field(DateEntry; Rec.DateEntry)
                {
                    Editable = true;
                }
                field(Daycaredeployed; Rec.Daycaredeployed)
                {
                    Editable = true;
                }
                field(DirectCareEndDate; Rec.DirectCareEndDate)
                {
                    Editable = true;
                }
                field(DirectCareStartDate; Rec.DirectCareStartDate)
                {
                    Editable = true;
                }
                field(Gender; Rec.Gender)
                {
                    Editable = true;
                }
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {
                    Editable = true;
                }
                field(ImportDate; Rec.ImportDate)
                {
                    Editable = true;
                }
                field(IndividualEndDate; Rec.IndividualEndDate)
                {
                    Editable = true;
                }
                field(IndividualStartDate; Rec.IndividualStartDate)
                {
                    Editable = true;
                }
                field(LongCareEndDate; Rec.LongCareEndDate)
                {
                    Editable = true;
                }
                field(LongCareStartDate; Rec.LongCareStartDate)
                {
                    Editable = true;
                }
                field(NextPlace; Rec.NextPlace)
                {
                    Editable = true;
                }
                field(PersonalCharacter; Rec.PersonalCharacter)
                {
                    Editable = true;
                }
                field(ProcessStatus; Rec.ProcessStatus)
                {
                    Editable = true;
                }
                field(ReasonEnd; Rec.ReasonEnd)
                {
                    Editable = true;
                }
                field(Relapse; Rec.Relapse)
                {
                    Editable = true;
                }
                field(Source; Rec.Source)
                {
                    Editable = true;
                }
                field("First Name"; Rec."First Name")
                {
                    Editable = true;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    Editable = true;
                }
                field(Surname; Rec.Surname)
                {
                    Editable = true;
                }
                field(Initials; Rec.Initials)
                {
                    Editable = true;
                }
            }
        }


    }
    actions
    {
        area(Navigation)
        {
            action(Filter)
            {
                trigger OnAction()
                begin
                    DateSelector();
                end;
            }
        }
    }

    trigger OnInit()
    var
        field_Lbl: Label 'Click here to set filter';
    begin
        fieldTextStartDate := field_Lbl;
        fieldTextEndDate := field_Lbl;
    end;

    trigger OnOpenPage()
    begin
        startDate := 0D;
        endDate := 0D;
    end;


    procedure DateSelector()
    var
        DateDialog: Page ACKGeneralDateDialog;
        dialogCaption: Label 'Date selection', Comment = 'sets the caption of popup';
        startDateLbl: Label 'Start date', Comment = 'sets the label in the popup';
        endDateLbl: Label 'End date', Comment = 'sets the label in the popup';
        homelessFilter: Record ACKHomeless;

    begin
        dateDialog.Caption := dialogCaption;
        dateDialog.setup(startDateLbl, endDateLbl, '');
        dateDialog.setDate(startDate, endDate, 0D);

        if dateDialog.RunModal() = Action::OK then begin
            startDate := dateDialog.getDate().Get(1);
            endDate := dateDialog.getDate().Get(2);
        end;

        if not (startDate = 0D) then begin
            homelessFilter.SetFilter(IndividualStartDate, '>=%1', startDate);
            fieldTextStartDate := Format(startDate);
        end;
        if not (endDate = 0D) then begin
            homelessFilter.SetFilter(IndividualEndDate, '>%1&<=%2  ', 0D, endDate);
            fieldTextEndDate := Format(endDate);
        end;

        CurrPage.SetTableView(homelessFilter);
        CurrPage.Update();
    end;

    var
        startDate: Date;
        endDate: Date;
        fieldTextStartDate: Text;
        fieldTextEndDate: Text;

}
