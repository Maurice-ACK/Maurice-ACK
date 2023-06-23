/// <summary>
/// Table ACKClient.
/// </summary>
table 50010 ACKClient
{
    Caption = 'Client';
    DataClassification = CustomerContent;
    DataCaptionFields = ClientNo, "First Name", "Middle Name", Surname;
    DrillDownPageID = ACKClientList;
    LookupPageID = ACKClientList;
    fields
    {
        field(10; ClientNo; Code[20])
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
        field(30; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(40; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(50; Surname; Text[50])
        {
            Caption = 'Surname';
        }
        field(70; Initials; Text[30])
        {
            Caption = 'Initials';
        }
        field(80; SSN; Code[9])
        {
            Caption = 'SSN';
            trigger OnValidate()
            begin
                if Rec.SSN <> '' then
                    ACKHelper.ValidateSSN(Rec.SSN, true);
            end;
        }
        field(90; Birthdate; Date)
        {
            Caption = 'Birthdate';
        }
        field(100; Gender; Enum ACKWMOGeslacht)
        {
            Caption = 'Gender';
        }
        field(120; DeceasedDate; Date)
        {
            Caption = 'Date of Death';
            trigger OnValidate()
            begin
                TestDeceasedDate();
            end;
        }
    }

    keys
    {
        key(PK; ClientNo)
        {
            Clustered = true;
        }
        key(SSN; SSN)
        {
            Unique = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; ClientNo)
        {
        }
    }

    trigger OnDelete()
    var
        ACKClientAddress: Record ACKClientAddress;
    begin
        ACKClientAddress.SetCurrentKey(ClientNo);
        ACKClientAddress.SetRange(ClientNo, Rec.ClientNo);
        ACKClientAddress.DeleteAll(true);
    end;

    local procedure GetNextNo(): Code[20]
    var
        Client: Record ACKClient;
        NewNo: Code[20];
        IsFound: Boolean;
    begin
        ACKSWVOGeneralSetup.Get();
        ACKSWVOGeneralSetup.TestField(ClientNos);
        repeat
            NewNo := NoSeriesMgt.DoGetNextNo(ACKSWVOGeneralSetup.ClientNos, Today(), true, false);
            IsFound := Client.Get(NewNo);
            if not IsFound then
                exit(NewNo);
        until not IsFound;
    end;

    trigger OnInsert()
    begin
        if Rec.ClientNo = '' then
            Rec.ClientNo := GetNextNo();
    end;

    local procedure TestDeceasedDate(): Boolean
    var
        error: Label 'Date: %1 is not valid.';
    begin
        if (rec.DeceasedDate > rec.Birthdate) and (rec.DeceasedDate <= System.Today) then
            exit(true);

        Error(error, rec.DeceasedDate);
        exit(false);
    end;

    local procedure TestNoSeries()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if ClientNo <> xRec.ClientNo then begin
            ACKSWVOGeneralSetup.Get();
            NoSeriesMgt.TestManual(ACKSWVOGeneralSetup.ClientNos);
            NoSeries := '';
        end;
    end;

    /// <summary>
    /// DoModify.
    /// </summary>
    /// <param name="ContactBeforeModify">Record Contact.</param>
    procedure DoModify(ContactBeforeModify: Record Contact)
    var
        OldClient: Record ACKClient;
        Client: Record ACKClient;
        IsDuplicateCheckNeeded: Boolean;
    begin
    end;

    procedure AssistEdit(OldClient: Record ACKClient): Boolean
    var
        Client: Record ACKClient;
    begin
        Client := Rec;
        ACKSWVOGeneralSetup.Get();
        ACKSWVOGeneralSetup.TestField(ClientNos);
        if NoSeriesMgt.SelectSeries(ACKSWVOGeneralSetup.ClientNos, OldClient.NoSeries, Client.NoSeries) then begin
            NoSeriesMgt.SetSeries(Client.ClientNo);
            Rec := Client;
            exit(true);
        end;
    end;

    /// <summary>
    /// GetCurrentAddress.
    /// </summary>
    /// <param name="ACKClientAddress">VAR Record ACKClientAddress.</param>
    /// <param name="Purpose">Enum ACKWMOAdresSoort.</param>
    /// <returns>Return variable Found of type Boolean.</returns>
    procedure GetCurrentAddress(var ACKClientAddress: Record ACKClientAddress; Purpose: Enum ACKWMOAdresSoort) Found: Boolean
    begin
        ACKClientAddress.SetRange(ClientNo, Rec.ClientNo);
        ACKClientAddress.SetRange(Purpose, Purpose);
        ACKClientAddress.SetFilter(ValidFrom, '<=%1', Today());
        ACKClientAddress.SetFilter(ValidTo, '>=%1|=%2', Today(), 0D);

        Found := ACKClientAddress.FindFirst();
    end;


    var
        ACKSWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        NoSeriesMgt: codeunit NoSeriesManagement;
        ACKHelper: codeunit ACKHelper;
        RelatedRecordIsCreatedMsg: Label 'The %1 record has been created.', Comment = 'The Cliënt record has been created.';
}