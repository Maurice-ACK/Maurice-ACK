/// <summary>
/// Table ACKResource
/// </summary>
table 50034 ACKResource
{
    Caption = 'ACKResource';
    DataClassification = CustomerContent;
    DataCaptionFields = ClientNo, "Type", Initials, Surname;
    DrillDownPageID = ACKResourceList;
    LookupPageID = ACKResourceList;

    fields
    {
        field(10; ID; BigInteger)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
        field(20; "Type"; Enum ACKResourceType)
        {
            Caption = 'Type', Locked = true;
        }
        field(30; ClientNo; Code[20])
        {
            Caption = 'Client No.';
            TableRelation = ACKClient.ClientNo;
        }
        field(60; Gender; Text[10])
        {
            Caption = 'Geslacht', Locked = true;
        }
        field(70; Birthdate; Date)
        {
            Caption = 'Geboortedatum', Locked = true;
        }
        field(80; PostCode; Text[6])
        {
            Caption = 'Postcode', Locked = true;
        }
        field(90; "Place of residence"; Text[80])
        {
            Caption = 'Woonplaats', Locked = true;
        }
        field(100; Street; Text[100])
        {
            Caption = 'Straatnaam', Locked = true;
        }
        field(110; HouseNumber; Code[15])
        {
            Caption = 'Huisnummer', Locked = true;
        }
        field(120; Letter; Text[20])
        {
            Caption = 'Huisnummer toevoeging', Locked = true;
        }
        field(130; MunicipalityNo; Code[20])
        {
            Caption = 'Gemeente Nr.', Locked = true;
            TableRelation = Customer."No.";
        }
        field(140; ProductCode; Code[5])
        {
            Caption = 'Productcode', Locked = true;
            TableRelation = ACKWMOProductCode.ProductCode;
        }
        field(160; EndDate; Date)
        {
            Caption = 'Einddatum', Locked = true;
        }
        field(170; ReasonEnd; Text[500])
        {
            Caption = 'Reden beëindiging', Locked = true;
        }
        field(180; Insured; Boolean)
        {
            Caption = 'Verzekerd', Locked = true;
        }
        field(190; LogField; Text[200])
        {
            Caption = 'Commentaar', Locked = true;
        }
        field(220; StartDate; Date)
        {
            Caption = 'Startdatum', Locked = true;
        }
        field(230; SSN; Code[9])
        {
            Caption = 'BSN', Locked = true;

            trigger OnValidate()
            begin
                TestField(Rec.SSN);
            end;
        }
        field(240; "First Name"; Text[30])
        {
            Caption = 'Voornaam', Locked = true;
        }
        field(250; "Middle Name"; Text[30])
        {
            Caption = 'Tussenvoegsel', Locked = true;
        }
        field(260; Surname; Text[50])
        {
            Caption = 'Achternaam', Locked = true;
        }
        field(270; Initials; Text[30])
        {
            Caption = 'Initialen', Locked = true;
        }
        field(280; ProductDesc; Text[500])
        {
            Caption = 'Productcode beschrijving', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(ACKWMOProductCode.Description where(ProductCode = field(ProductCode)));
            Editable = false;
        }
        field(290; DeceasedDate; Date)
        {
            Caption = 'Overlijdensdatum', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(ACKClient.DeceasedDate WHERE(ClientNo = field(ClientNo)));
            Editable = false;
        }
        field(300; ImportDate; DateTime)
        {
            Caption = 'Importeerdatum', Locked = true;
        }
        field(310; HealthcareproviderNo; Code[20])
        {
            Caption = 'Zorgaanbieder Nr.', Locked = true;
            TableRelation = Vendor."No.";
        }
        field(320; HealthcareProviderName; Text[100])
        {
            Caption = 'Zorgaanbieder', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field(HealthcareProviderNo)));
            Editable = false;
        }
        field(330; MunicipalityName; Text[100])
        {
            Caption = 'Gemeente', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field(MunicipalityNo)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; Id)
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
        Regex: Codeunit Regex;
    begin
        ACKClient.SetCurrentKey(SSN);
        ACKClient.SetRange(SSN, Rec.SSN);

        if not ACKClient.FindFirst() then begin
            ACKClient.Init();
            ACKClient.Initials := Rec.Initials;
            ACKClient.Surname := Rec.Surname;
            ACKClient.Gender := GetGender();
            ACKClient.Birthdate := Rec.Birthdate;
            ACKClient.SSN := Rec.SSN;
            ACKClient."First Name" := Rec."First Name";
            ACKClient."Middle Name" := Rec."Middle Name";
            ACKClient.Insert(true);

            if (Rec.PostCode <> '') then begin
                ACKClientAddress.Init();
                ACKClientAddress.ClientNo := ACKClient.ClientNo;
                ACKClientAddress.Purpose := ACKWMOAdresSoort::BRP;
                ACKClientAddress.PostCode := Rec.PostCode;
                ACKClientAddress.MunicipalityNo := Rec.MunicipalityNo;
                Evaluate(ACKClientAddress.HouseNumber, Rec.HouseNumber);
                ACKClientAddress.Street := Rec.Street;
                ACKClientAddress."Place of residence" := Rec."Place of residence";
                ACKClientAddress.ValidFrom := Today();

                //Check if Rec.letter is one char and if char is a letter
                if (Regex.IsMatch(Rec.Letter, '^([a-z]|[A-Z])$')) then
                    ACKClientAddress.HouseLetter := CopyStr(Text.UpperCase(Rec.Letter), 1, 1)
                else
                    ACKClientAddress.HouseNumberAddition := CopyStr(Rec.Letter, 1, 1);

                ACKClientAddress.InsertOrUpdate();
            end;
        end;
    end;

    local procedure GetGender(): Enum ACKWMOGeslacht
    begin
        case Rec.Gender of
            MaleLbl:
                exit(ACKWMOGeslacht::Male);
            FemaleLbl:
                exit(ACKWMOGeslacht::Female);
            else
                exit(ACKWMOGeslacht::Unknown);
        end;
    end;

    var
        MaleLbl: Label 'Mannelijk';
        FemaleLbl: Label 'Vrouwelijk';

}