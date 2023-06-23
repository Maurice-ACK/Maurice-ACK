/// <summary>
/// Table ACKSubcontractor (ID 50003).
/// </summary>
table 50027 ACKSubcontractor
{
    Caption = 'Subcontractor';
    DrillDownPageId = ACKSubcontractorList;
    LookupPageId = ACKSubcontractorList;
    DataClassification = OrganizationIdentifiableInformation;

    fields
    {
        field(10; SubcontractorNo; Code[20])
        {
            Caption = 'No';

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
        field(30; Name; Text[100])
        {
            Caption = 'Name';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.Name);
            end;
        }
        field(40; HealthcareProviderNo; Code[20])
        {
            Caption = 'Healthcare provider No.';
            DataClassification = OrganizationIdentifiableInformation;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                ACKHelper.ValidateHealthcareProviderRelation(Rec.HealthcareProviderNo, true, true);
            end;

            trigger OnLookup()
            var
                Vendor: Record Vendor;
            begin
                if ACKHelper.VendorLookup(Vendor, true) = Action::LookupOK then
                    Rec.HealthcareProviderNo := Vendor."No.";
            end;
        }
        field(50; IsActive; Boolean)
        {
            Caption = 'Active';
        }
        field(60; HealthcareProviderName; Text[500])
        {
            Caption = 'Healthcare provider';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field(HealthcareProviderNo)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; SubcontractorNo)
        {
            Clustered = true;
        }
        key(HealthcareProviderNo; HealthcareProviderNo)
        {
        }
    }

    trigger OnInsert()
    begin
        ACKSWVOGeneralSetup.Get();

        if Rec.SubcontractorNo = '' then begin
            ACKSWVOGeneralSetup.TestField(SubcontractorNos);
            NoSeriesMgt.InitSeries(ACKSWVOGeneralSetup.SubcontractorNos, xRec.NoSeries, 0D, Rec.SubcontractorNo, NoSeries);
        end;
    end;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldSubcontractor">Record ACKSubcontractor.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldSubcontractor: Record ACKSubcontractor): Boolean
    var
        Subcontractor: Record ACKSubcontractor;
    begin
        Subcontractor := Rec;
        ACKSWVOGeneralSetup.Get();
        ACKSWVOGeneralSetup.TestField(SubcontractorNos);
        if NoSeriesMgt.SelectSeries(ACKSWVOGeneralSetup.SubcontractorNos, OldSubcontractor.NoSeries, Subcontractor.NoSeries) then begin
            NoSeriesMgt.SetSeries(Subcontractor.SubcontractorNo);
            Rec := Subcontractor;
            exit(true);
        end;
    end;

    local procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if Rec.SubcontractorNo <> xRec.SubcontractorNo then begin
            ACKSWVOGeneralSetup.Get();
            NoSeriesMgt.TestManual(ACKSWVOGeneralSetup.SubcontractorNos);
            NoSeries := '';
        end;
    end;

    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        NoSeriesMgt: codeunit NoSeriesManagement;
        ACKHelper: codeunit ACKHelper;
}
