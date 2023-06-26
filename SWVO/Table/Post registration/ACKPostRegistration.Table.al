/// <summary>
/// Table ACKPostRegistration
/// </summary>
table 50036 ACKPostRegistration
{
    Caption = 'Post registration';
    DataClassification = CustomerContent;
    DataCaptionFields = MailRegistration;
    DrillDownPageID = ACKPostRegistrationList;
    LookupPageID = ACKPostRegistrationList;

    fields
    {
        field(10; MailRegistration; Code[20])
        {
            Caption = 'Registration Nr.';
            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(20; ArchiveId; Integer)
        {
            Caption = 'Archive id';
            DataClassification = ToBeClassified;
            TableRelation = ACKPostRegistrationArchive.id;
        }
        field(30; InOut; Enum "PostRegINOUT")
        {
            Caption = 'In/Out';
            DataClassification = SystemMetadata;
        }
        field(40; MailComment; Text[60])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(50; MailConfidential; Boolean)
        {
            Caption = 'Confindential';
            DataClassification = SystemMetadata;
        }
        field(60; MailCopy; Text[30])
        {
            Caption = 'Copy';
            DataClassification = CustomerContent;
        }
        field(70; MailDate; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(80; MailDepartmentId; Text[35])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(90; MailDescription; Text[60])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(100; MailReceiverId; Integer)
        {
            Caption = 'ReceiverId';
            TableRelation = ACKPostRegistrationSendRecv.id;
            DataClassification = CustomerContent;
        }
        field(110; MailReceiverName; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(ACKPostRegistrationSendRecv.SenderReceiverId where(id = field(MailReceiverId)));
            Caption = 'Receiver';
            Editable = false;
        }
        field(120; MailSenderId; Integer)
        {
            Caption = 'SenderId';
            TableRelation = ACKPostRegistrationSendRecv.id;
            DataClassification = CustomerContent;
        }
        field(130; MailSenderName; Text[50])
        {
            FieldClass = FlowField;
            Editable = true;
            CalcFormula = lookup(ACKPostRegistrationSendRecv.SenderReceiverId where(id = field(MailSenderId)));
            Caption = 'Sender';
        }
        field(140; NoSeries; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(150; ArchiveActive; Boolean)
        {
            Caption = 'Is archive active';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKPostRegistrationArchive.Active where(id = field(ArchiveId)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; MailRegistration)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; MailRegistration)
        {
        }
    }

    trigger OnInsert()
    begin
        if not ACKSWVOGeneralSetup.Get() then
            Error('SWVO setup does not exits.');

        if MailRegistration = '' then begin
            ACKSWVOGeneralSetup.TestField(MailRegistrationNos);
            NoSeriesMgt.InitSeries(ACKSWVOGeneralSetup.MailRegistrationNos, xRec.NoSeries, 0D, MailRegistration, NoSeries);
        end;

        //Rec.Validate(SocialSecurityNumber);
    end;


    local procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if MailRegistration <> xRec.MailRegistration then begin
            ACKSWVOGeneralSetup.Get();
            NoSeriesMgt.TestManual(ACKSWVOGeneralSetup.MailRegistrationNos);
            NoSeries := '';
        end;
    end;

    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        NoSeriesMgt: codeunit NoSeriesManagement;
        ACKHelper: codeunit ACKHelper;
        RelatedRecordIsCreatedMsg: Label 'The %1 record has been created.', Comment = 'The Cliënt record has been created.';

    /// <summary>
    /// DoModify.
    /// </summary>
    /// <param name="ContactBeforeModify">Record Contact.</param>
    procedure DoModify(ContactBeforeModify: Record Contact)
    var
        OldPostRegistration: Record ACKPostRegistration;
        PostRegistration: Record ACKPostRegistration;
        IsDuplicateCheckNeeded: Boolean;
    begin
    end;

    procedure AssistEdit(OldPostRegistration: Record ACKPostRegistration): Boolean
    var
        PostRegistration: Record ACKPostRegistration;
    begin
        with PostRegistration do begin
            PostRegistration := Rec;
            ACKSWVOGeneralSetup.Get();
            ACKSWVOGeneralSetup.TestField(MailRegistrationNos);
            if NoSeriesMgt.SelectSeries(ACKSWVOGeneralSetup.MailRegistrationNos, OldPostRegistration.NoSeries, Rec.NoSeries) then begin
                NoSeriesMgt.SetSeries(Rec.MailRegistration);
                Rec := PostRegistration;
                exit(true);
            end;
        end;
    end;
}