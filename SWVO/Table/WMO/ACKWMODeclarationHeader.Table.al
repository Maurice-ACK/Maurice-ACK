/// <summary>
/// Table ACKWMODeclarationHeader
/// </summary>
table 50064 ACKWMODeclarationHeader
{
    Caption = 'Wmo Declaration Header';
    DataClassification = AccountData;

    fields
    {
        field(10; DeclarationHeaderNo; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(20; NoSeries; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(30; HeaderId; Guid)
        {
            Caption = 'Header System Id', Locked = true;
            TableRelation = ACKWMOHeader.SystemId;
        }
        field(40; MunicipalityNo; Code[20])
        {
            Caption = 'Municipality No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                ACKHelper.ValidateMunicipalityRelation(Rec.MunicipalityNo, true, true);
            end;
        }
        field(50; HealthcareProviderNo; Code[20])
        {
            Caption = 'Healthcare provider No.';
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                ACKHelper.ValidateHealthcareProviderRelation(Rec.HealthcareProviderNo, true, true);
            end;
        }
        field(60; DeclarationNo; Text[12])
        {
            Caption = 'Declaratie nummer', Locked = true;
        }
        field(70; DeclarationDate; Date)
        {
            Caption = 'Dagtekening', Locked = true;
        }
        field(80; Status; Enum ACKWMODeclarationStatus)
        {
            Caption = 'Status', Locked = true;
        }
        field(90; StartDate; Date)
        {
            Caption = 'Start date';
        }
        field(95; EndDate; Date)
        {
            Caption = 'End date';
        }
        field(100; TotalAmount; Integer)
        {
            Caption = 'Total amount';
            FieldClass = FlowField;
            CalcFormula = sum(ACKWMODeclarationLine.Amount where(DeclarationHeaderNo = field(DeclarationHeaderNo)));
            Editable = false;
        }
        field(110; TotalAmountApproved; Integer)
        {
            Caption = 'Total amount';
            FieldClass = FlowField;
            CalcFormula = sum(ACKWMODeclarationLine.Amount where(DeclarationHeaderNo = field(DeclarationHeaderNo)));
            Editable = false;
        }
        field(120; TotalAmountCanceled; Integer)
        {
            Caption = 'Total amount';
            FieldClass = FlowField;
            CalcFormula = sum(ACKWMODeclarationLine.Amount where(DeclarationHeaderNo = field(DeclarationHeaderNo)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; DeclarationHeaderNo)
        {
            Clustered = true;
        }
        key(HeaderKey; HeaderId, Status)
        {
            Unique = true;
        }
    }

    trigger OnDelete()
    var
        WMODeclarationLine: Record ACKWMODeclarationLine;
    begin
        if Rec.Status <> ACKWMODeclarationStatus::New then
            Error('Cannot delete posted declarations');

        WMODeclarationLine.SetRange(DeclarationHeaderNo, Rec.DeclarationHeaderNo);
        WMODeclarationLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if not ACKSWVOGeneralSetup.Get() then
            Error('SWVO setup does not exits.');

        if DeclarationHeaderNo = '' then begin
            ACKSWVOGeneralSetup.TestField(WMODeclarationNos);
            NoSeriesMgt.InitSeries(ACKSWVOGeneralSetup.WMODeclarationNos, xRec.NoSeries, 0D, DeclarationHeaderNo, NoSeries);
        end;
    end;

    local procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if DeclarationHeaderNo <> xRec.DeclarationHeaderNo then begin
            ACKSWVOGeneralSetup.Get();
            NoSeriesMgt.TestManual(ACKSWVOGeneralSetup.WMODeclarationNos);
            NoSeries := '';
        end;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldWMODeclarationHeader">Record WMODeclarationHeader.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldWMODeclarationHeader: Record ACKWMODeclarationHeader): Boolean
    var
        WMODeclarationHeader: Record ACKWMODeclarationHeader;
    begin
        WMODeclarationHeader := Rec;
        ACKSWVOGeneralSetup.Get();
        ACKSWVOGeneralSetup.TestField(WMODeclarationNos);
        if NoSeriesMgt.SelectSeries(ACKSWVOGeneralSetup.WMODeclarationNos, OldWMODeclarationHeader.NoSeries, WMODeclarationHeader.NoSeries) then begin
            NoSeriesMgt.SetSeries(WMODeclarationHeader.DeclarationHeaderNo);
            Rec := WMODeclarationHeader;
            exit(true);
        end;
    end;

    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        NoSeriesMgt: codeunit NoSeriesManagement;
        ACKHelper: Codeunit ACKHelper;
}
