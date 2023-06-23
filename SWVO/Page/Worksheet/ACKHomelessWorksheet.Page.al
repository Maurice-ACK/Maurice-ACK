/// <summary>
/// Page ACKHomelessList (ID 50051).
/// </summary>
page 50103 ACKHomelessWorksheet
{
    Caption = 'HomelessList';
    CardPageID = ACKHomelessCard;
    DataCaptionFields = SSN_Available;
    PageType = Worksheet;
    SourceTable = ACKHomeless;
    UsageCategory = Administration;
    ApplicationArea = All;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            group(header)
            {
                Caption = 'Search';
                field(StartDate; startDate)
                {
                    Editable = true;
                    Caption = 'Start date';
                    ToolTip = 'Set the start date filter on the page';
                    trigger OnValidate()
                    begin
                        DateSelector();
                    end;

                }
                field(endDate; endDate)
                {
                    Editable = true;
                    Caption = 'End date';
                    ToolTip = 'Set the end date filter on the page';
                    trigger OnValidate()
                    begin
                        DateSelector();
                    end;
                }
            }
            repeater(General)
            {
                Editable = false;

                field(ID; Rec.ID)
                {
                    trigger OnAssistEdit()
                    begin
                        page.RunModal(Page::ACKHomelessCard, rec);
                    end;
                }
                field(ClientNo; Rec.ClientNo)
                {
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field(Surname; Rec.Surname)
                {
                }
                field(Initials; Rec.Initials)
                {
                }
                field(Appropiate; Rec.Appropiate)
                {
                }
                field(Birthyear; Rec.Birthyear)
                {
                }
                field(SSN_Available; Rec.SSN_Available)
                {
                }
                field(CauseIn; Rec.CauseIn)
                {
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                }
                field(MunicipalityNoEntry; Rec.MunicipalityNoEntry)
                {
                }
                field(DateEntry; Rec.DateEntry)
                {
                }
                field(Daycaredeployed; Rec.Daycaredeployed)
                {
                }
                field(DirectCareStartDate; Rec.DirectCareStartDate)
                {
                }
                field(DirectCareEndDate; Rec.DirectCareEndDate)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {
                }
                field(ImportDate; Rec.ImportDate)
                {
                }
                field(IndividualStartDate; Rec.IndividualStartDate)
                {
                }
                field(IndividualEndDate; Rec.IndividualEndDate)
                {
                }
                field(LongCareStartDate; Rec.LongCareStartDate)
                {
                }
                field(LongCareEndDate; Rec.LongCareEndDate)
                {
                }
                field(NextPlace; Rec.NextPlace)
                {
                }
                field(PersonalCharacter; Rec.PersonalCharacter)
                {
                }
                field(ProcessStatus; Rec.ProcessStatus)
                {
                }
                field(ReasonEnd; Rec.ReasonEnd)
                {
                }
                field(Relapse; Rec.Relapse)
                {
                }
                field(Source; Rec.Source)
                {
                }
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

    local procedure DateSelector()
    var
        homelessFilter: Record ACKHomeless;
    begin
        if not (startDate = 0D) then begin
            homelessFilter.SetFilter(IndividualStartDate, '>=%1', startDate);
            fieldTextStartDate := Format(startDate);
        end;
        if not (endDate = 0D) then begin
            homelessFilter.SetFilter(IndividualEndDate, '>%1&<=%2', 0D, endDate);
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
