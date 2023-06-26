/// <summary>
/// Table ACKHCProductCode
/// </summary>
table 50029 ACKHCProductCode
{
    Caption = 'Product codes';
    DataClassification = SystemMetadata;
    DrillDownPageId = ACKHCProductCodeList;
    LookupPageId = ACKHCProductCodeList;

    fields
    {
        field(10; ProductCode; Code[5])
        {
            Caption = 'Product code';
            DataClassification = SystemMetadata;
            NotBlank = true;
            TableRelation = ACKWMOProductCode.ProductCode;
        }
        field(20; HealthcareProviderNo; Code[20])
        {
            Caption = 'Healthcare provider No.';
            DataClassification = OrganizationIdentifiableInformation;
            NotBlank = true;
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
        field(30; HealthcareProviderName; Text[500])
        {
            Caption = 'Healthcare provider';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field(HealthcareProviderNo), "Vendor Posting Group" = const('ZA')));
            Editable = false;
        }
        field(40; ProductCategoryId; Code[2])
        {
            Caption = 'Product category';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKWMOProductCode.CategoryID where(ProductCode = field(ProductCode)));
            Editable = false;
        }
        field(50; ProductCodeDescription; Text[500])
        {
            Caption = 'Product code description';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKWMOProductCode.Description where(ProductCode = field(ProductCode)));
            Editable = false;
        }
        field(60; ProductCodeType; Enum ACKProductCodeType)
        {
            Caption = 'Product code type';
            FieldClass = FlowField;
            CalcFormula = lookup(ACKWMOProductCode.ProductCodeType where(ProductCode = field(ProductCode)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; HealthcareProviderNo, ProductCode)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        ACKHelper.ValidateRecord(Rec);
    end;

    trigger OnModify()
    begin
        ACKHelper.ValidateRecord(Rec);
    end;

    var
        ACKHelper: codeunit ACKHelper;
}
