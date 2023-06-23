table 50058 ACKOtherDocuments
{
    Caption = 'Other documents';
    DataClassification = SystemMetadata;

    fields
    {
        field(10; id; Integer)
        {
            AutoIncrement = true;
        }
        field(20; HealthcareproviderNo; Code[20])
        {
            Caption = 'Healthcare provider No.';
            TableRelation = Vendor."No.";
        }
        field(30; url; Text[2048])
        {
        }
        field(40; Title; Text[250])
        {
        }
        field(50; Description; Text[250])
        {
        }
        field(60; importDate; DateTime)
        {
        }
        field(70; HealthcareProviderName; Text[500])
        {
            Caption = 'Healthcare provider';
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field(HealthcareProviderNo)));
        }
    }

    keys
    {
        key(id; id)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Brick; Title, importDate, Description)
        {

        }
    }
}