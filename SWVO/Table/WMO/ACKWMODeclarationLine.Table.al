/// <summary>
/// Table ACKWMODeclarationLine
/// </summary>
table 50065 ACKWMODeclarationLine
{
    Caption = 'Wmo Declaration line';
    DataClassification = AccountData;

    fields
    {
        field(10; ID; BigInteger)
        {
            AutoIncrement = true;
        }
        field(20; DeclarationHeaderNo; Code[20])
        {
            TableRelation = ACKWMODeclarationHeader.DeclarationHeaderNo;

            trigger OnValidate()
            var
                ACKWMODeclarationHeader: Record ACKWMODeclarationHeader;
            begin
                TestField(Rec.DeclarationHeaderNo);

                if ACKWMODeclarationHeader.Get(Rec.DeclarationHeaderNo) then begin
                    Validate(Rec.MunicipalityNo, ACKWMODeclarationHeader.MunicipalityNo);
                    Validate(Rec.HealthcareProviderNo, ACKWMODeclarationHeader.HealthcareProviderNo);
                end;
            end;
        }
        field(30; IndicationID; BigInteger)
        {
            Caption = 'Indication ID';
            TableRelation = ACKWMOIndication.ID;

            trigger OnValidate()
            var
                ACKWMOIndication: Record ACKWMOIndication;
            begin
                if ACKWMOIndication.Get(Rec.IndicationID) then begin
                    Validate(Rec.ClientNo, ACKWMOIndication.ClientNo);
                    Validate(Rec.AssignmentNo, ACKWMOIndication.AssignmentNo);
                    Validate(Rec.ProductCategoryId, ACKWMOIndication.ProductCategoryId);
                    Validate(Rec.ProductCode, ACKWMOIndication.ProductCode);
                end;
            end;
        }
        field(40; Reference; Text[20])
        {
            Caption = 'Referentienummer', Locked = true;
        }
        field(50; PreviousReference; Text[20])
        {
            Caption = 'Vorig referentienummer', Locked = true;
        }
        field(60; Amount; Integer)
        {
            Caption = 'Amount';
        }
        field(70; StartDate; Date)
        {
            Caption = 'Begindatum', Locked = true;
        }
        field(80; EndDate; Date)
        {
            Caption = 'Einddatum', Locked = true;
        }
        field(90; Volume; Integer)
        {
            Caption = 'Geleverd volume', Locked = true;
        }
        field(100; Unit; Enum ACKWMOEenheid)
        {
            Caption = 'Eenheid', Locked = true;
        }
        field(110; ProductRate; Integer)
        {
            Caption = 'Product tarief', Locked = true;
        }
        field(120; ClientNo; Code[20])
        {
            Caption = 'Client No.';
            TableRelation = ACKWMOIndication.ClientNo where(ID = field(IndicationID));
            Editable = false;
        }
        field(130; MunicipalityNo; Code[20])
        {
            //Field added for relationships
            Caption = 'Municipality No.';
            Editable = false;
            TableRelation = ACKWMODeclarationHeader.MunicipalityNo where(DeclarationHeaderNo = field(DeclarationHeaderNo));
        }
        field(140; HealthcareProviderNo; Code[20])
        {
            //Field added for relationships
            Caption = 'Healthcare provider No.';
            Editable = false;
            TableRelation = ACKWMODeclarationHeader.HealthcareProviderNo where(DeclarationHeaderNo = field(DeclarationHeaderNo));
        }
        field(150; AssignmentNo; Integer)
        {
            //Field added for relationships
            Caption = 'Assignment No.';
            Editable = false;
            TableRelation = ACKWMOIndication.AssignmentNo where(ID = field(IndicationID));
        }
        field(160; ProductCategoryId; Code[2])
        {
            //Field added for relationships
            Caption = 'Category Id';
            TableRelation = ACKWMOIndication.ProductCategoryId where(ID = field(IndicationID));
            Editable = false;
        }
        field(170; ProductCode; Code[5])
        {
            //Field added for relationships
            Caption = 'Product code';
            TableRelation = ACKWMOIndication.ProductCode where(ID = field(IndicationID));
            Editable = false;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
        key(SumAmountKey; DeclarationHeaderNo)
        {
            SumIndexFields = Amount;
        }
    }

    /// <summary>
    /// GetHeader.
    /// </summary>
    /// <param name="ACKWMODeclarationHeader">VAR Record ACKWMODeclarationHeader.</param>
    procedure GetHeader(var ACKWMODeclarationHeader: Record ACKWMODeclarationHeader)
    begin
        ACKWMODeclarationHeader.Get(Rec.DeclarationHeaderNo);
    end;

    trigger OnDelete()
    var
        WMODeclarationHeader: Record ACKWMODeclarationHeader;
    begin
        GetHeader(WMODeclarationHeader);
        if WMODeclarationHeader.Status <> ACKWMODeclarationStatus::New then
            Error('Cannot delete posted declarations');
    end;
}
