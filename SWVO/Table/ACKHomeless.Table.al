/// <summary>
/// Table ACKHomeless
/// </summary>
table 50003 ACKHomeless
{
    Caption = 'Homeless';
    DataClassification = CustomerContent;

    fields
    {
        field(10; ID; Integer)
        {
            AutoIncrement = true;
            caption = 'ID', Locked = true;
        }
        field(30; ClientNo; Code[20])
        {
            Caption = 'Client No.';
        }
        field(40; Appropiate; Text[60])
        {
            Caption = 'Appropriate waiting time for care';
        }
        field(50; Birthyear; Code[4])
        {
            Caption = 'Birthyear';
        }
        field(60; SSN_Available; Boolean)
        {
            Caption = 'SSN available';
        }
        field(70; CauseIn; Text[200])
        {
            Caption = 'CauseIn';
        }
        field(80; MunicipalityNo; Code[4])
        {
            Caption = 'Municipality No.';
            TableRelation = Customer."No.";
        }
        field(90; MunicipalityNoEntry; Code[4])
        {
            Caption = 'Municipality No. origin';
        }
        field(100; DateEntry; Date)
        {
            Caption = 'DateEntry';
        }
        field(110; DaycareDeployed; Enum "ACKHomelessDaycareDeployed")
        {
            Caption = 'DaycareDeployed';
        }
        field(120; DirectCareEndDate; Date)
        {
            Caption = 'DirectCareEndDate';
        }
        field(130; DirectCareStartDate; Date)
        {
            Caption = 'DirectCareStartDate';
        }
        field(140; Gender; Enum ACKWMOGeslacht)
        {
            Caption = 'Gender';
        }
        field(150; HealthcareproviderNo; Code[20])
        {
            Caption = 'Healthcare provider No.';
            TableRelation = Vendor."No.";
        }
        field(310; HealthcareProviderName; Text[500])
        {
            Caption = 'Healthcare provider';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field(HealthcareProviderNo)));
            Editable = false;
        }
        field(160; ImportDate; DateTime)
        {
            Caption = 'ImportDate';
        }
        field(170; IndividualEndDate; Date)
        {
            Caption = 'IndividualEndDate';
        }
        field(180; IndividualStartDate; Date)
        {
            Caption = 'IndividualStartDate';
        }
        field(190; LongCareEndDate; Date)
        {
            Caption = 'LongCareEndDate';
        }
        field(200; LongCareStartDate; Date)
        {
            Caption = 'LongCareStartDate';
        }
        field(210; NextPlace; Text[200])
        {
            Caption = 'NextPlace';
        }
        field(220; PersonalCharacter; Text[200])
        {
            Caption = 'PersonalCharacter';
        }
        field(230; ProcessStatus; Text[200])
        {
            Caption = 'ProcessStatus';
        }
        field(240; ReasonEnd; Text[200])
        {
            Caption = 'ReasonEnd';
        }
        field(250; Relapse; Text[200])
        {
            Caption = 'Relapse';
        }
        field(260; Source; Text[200])
        {
            Caption = 'Source';
        }
        field(270; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(280; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(290; Surname; Text[50])
        {
            Caption = 'Surname';
        }
        field(300; Initials; Text[30])
        {
            Caption = 'Initials';
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}