table 50040 ACKTransportMutationLine
{
    Caption = 'Vervoer mutaties', Locked = true;
    DataClassification = CustomerContent;
    LookupPageId = ACKTransportMutationList;
    DrillDownPageId = ACKTransportMutationList;

    fields
    {
        field(10; ProcessStatus; enum ACKJobStatus)
        {
            Caption = 'Status', Locked = true;
        }
        field(15; ClientNo; Code[20])
        {
            TableRelation = ACKClient.ClientNo;
            Caption = 'Cliënt Nr.', Locked = true;
        }
        field(20; SSN; Code[9])
        {
            Caption = 'BSN', Locked = true;
            trigger OnValidate()
            begin
                TestField(Rec.SSN);
            end;
        }
        field(30; BadgeNumber; Text[10])
        {
            Caption = 'Pasnummer', Locked = true;
        }
        field(40; BadgeNumberOld; Text[10])
        {
            Caption = 'Pasnummer (oud)', Locked = true;
        }
        field(50; FirstName; Text[25])
        {
            Caption = 'Voornaam', Locked = true;
        }
        field(60; MiddleName; Text[25])
        {
            Caption = 'Tussenvoegsel', Locked = true;
        }
        field(80; Gender; Enum ACKWMOGeslacht)
        {
            Caption = 'Geslacht', Locked = true;
        }
        field(90; Birthdate; Date)
        {
            Caption = 'Geboortedatum', Locked = true;
        }
        field(100; Phone; Text[20])
        {
            Caption = 'Telefoonnummer', Locked = true;
        }
        field(110; PhoneMobile; Text[20])
        {
            Caption = 'Mobiel', Locked = true;
        }
        field(120; Street; Text[250])
        {
            Caption = 'Straatnaam', Locked = true;
        }
        field(130; HouseNumberExt; Text[10])
        {
            Caption = 'Huisnummer toevoeging', Locked = true;
        }
        field(140; ZipCode; Text[10])
        {
            Caption = 'Postcode', Locked = true;
        }
        field(150; Municipality; Text[60])
        {
            Caption = 'Gemeente', Locked = true;
        }
        field(160; CorrStreet; Text[250])
        {
            Caption = 'CorrStreet', Locked = true; //?
        }
        field(170; CorrZipCode; Text[10])
        {
            Caption = 'CorrZipCode', Locked = true; //?
        }
        field(180; CorrCity; Text[60])
        {
            Caption = 'CorrCity', Locked = true; //?
        }
        field(190; PaymentOnAccount; boolean)
        {
            Caption = 'PaymentOnAccount', Locked = true; //?
        }
        field(200; BankAccount; Text[35])
        {
            Caption = 'Bankrekeningnummer', Locked = true;
        }
        field(210; BankAccountStreet; Text[250])
        {
            Caption = 'Bankrekening straat', Locked = true; //?
        }
        field(220; BankAccountHouseNumberExt; Text[10])
        {
            Caption = 'Bankrekening huisnummer toevoeging', Locked = true;
        }
        field(230; BankAccountZipCode; Text[10])
        {
            Caption = 'Bankrekening postcode', Locked = true;
        }
        field(240; BankAccountCity; Text[60])
        {
            Caption = 'BankAccountCity', Locked = true;
            DataClassification = ToBeClassified;
        }
        field(250; BankAccountName; Text[25])
        {
            Caption = 'Bank naam';
        }
        field(260; BankAccountPhone; Text[20])
        {
            Caption = 'Bankrekening telefoon', Locked = true;
        }
        field(270; Remarks; Text[255])
        {
            Caption = 'Opmerkingen', Locked = true;
        }
        field(280; GuideDog; boolean)
        {
            Caption = 'Blindengeleidehond', Locked = true;
        }
        field(290; Walker; boolean)
        {
            Caption = 'Rollator', Locked = true;
        }
        field(300; Wheelchair; boolean)
        {
            Caption = 'Rolstoel', Locked = true;
        }
        field(310; WheelchairFoldable; boolean)
        {
            Caption = 'Rolstoel opvouwbaar', Locked = true;
        }
        field(320; WheelchairElectric; boolean)
        {
            Caption = 'Rolstoel elektrisch', Locked = true;
        }
        field(330; MobilityScooter; boolean)
        {
            Caption = 'Scootmobiel', Locked = true;
        }
        field(340; FreeAssistance; boolean)
        {
            Caption = 'Vrije hulpverlening', Locked = true;
        }
        field(350; Front; boolean)
        {
            Caption = 'Voor', Locked = true;
        }
        field(360; MutationCode; Text[10])
        {
            Caption = 'Mutatie code', Locked = true;
        }
        field(370; WmoCategory; enum ACKTransportRequestType)
        {
            Caption = 'Wmo Category', Locked = true;
        }
        field(380; DisposalEndDate; Date)
        {
            Caption = 'Buitengebruikstelling', Locked = true;
        }
        field(390; Budget; Decimal)
        {
            Caption = 'Budget', Locked = true;
        }
        field(400; BudgetStartDate; Date)
        {
            Caption = 'Startdatum budget', Locked = true;
        }
        field(410; BudgetEndDate; Date)
        {
            Caption = 'Einddatum budget', Locked = true;
        }
        field(420; TaxiIndication; boolean)
        {
            Caption = 'Taxi indicatie', Locked = true;
        }
        field(430; MutCreatedDate; Date)
        {
            Caption = 'Aanmaakdatum', Locked = true;
        }
        field(440; MutModifiedDate; Date)
        {
            Caption = 'Wijzigingsdatum', Locked = true;
        }
        field(450; OverruleCityId; Text[20])
        {
            Caption = 'Gemeente Nr. overrule?', Locked = true;
        }
        field(490; "First Name"; Text[30])
        {
            Caption = 'Voornaam', Locked = true;
        }
        field(530; "Middle Name"; Text[30])
        {
            Caption = 'Tussenvoegsel', Locked = true;
        }
        field(510; Surname; Text[50])
        {
            Caption = 'Achternaam', Locked = true;
        }

        field(520; Initials; Text[30])
        {
            Caption = 'Initialen', Locked = true;
        }
    }
    keys
    {
        key(PK; ProcessStatus)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        CreateClient();
    end;

    local procedure CreateClient() ACKClient: Record ACKClient
    var
        ACKClientAddress: Record ACKClientAddress;
    begin
        ACKClient.SetCurrentKey(SSN);
        ACKClient.SetRange(SSN, Rec.SSN);

        if not ACKClient.FindFirst() then begin
            ACKClient.Init();
            ACKClient.Initials := Rec.Initials;
            ACKClient.Surname := Rec.Surname;
            ACKClient.Gender := Rec.Gender;
            ACKClient.Birthdate := Rec.Birthdate;
            ACKClient.SSN := Rec.SSN;
            ACKClient."First Name" := Rec."First Name";
            ACKClient."Middle Name" := Rec."Middle Name";
            ACKClient.Insert(true);

        end;
        Rec.ClientNo := ACKClient.ClientNo;
        Rec.Initials := ACKClient.Initials;
        Rec."First Name" := ACKClient."First Name";
        Rec."Middle Name" := ACKClient."Middle Name";
        Rec.Surname := ACKClient.Surname;
        Rec.Gender := ACKClient.Gender;
        Rec.Birthdate := ACKClient.Birthdate;
        Rec.SSN := ACKClient.SSN;
    end;
}