/// <summary>
/// Table ACKWMORetourCode
/// </summary>
table 50026 ACKWMORetourCode
{
    Caption = 'Wmo Retour codes';
    DataPerCompany = false;
    DataClassification = CustomerContent;
    LookupPageId = ACKWMORetourCodeList;
    DrillDownPageId = ACKWMORetourCodeList;

    fields
    {
        field(10; ID; Code[4])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(Rec.ID);
            end;
        }
        field(20; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(30; IsActive; Boolean)
        {
            Caption = 'Active';
            InitValue = true;
        }
        field(40; MessageInvalid; Boolean)
        {
            Caption = 'Message invalid';
            InitValue = true;
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
