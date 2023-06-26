/// <summary>
/// Table ACKJSONMessage
/// </summary>
table 50061 ACKJSONMessage
{
    Caption = 'JSON message', Locked = true;
    DataPerCompany = false;

    DataClassification = SystemMetadata;
    fields
    {
        field(10; MessageCode; Code[20])
        {
            Caption = 'Message code', Locked = true;
            NotBlank = true;

            trigger OnValidate()
            begin
                TestField(MessageCode);
            end;
        }
        field(20; "Active"; Boolean)
        {
            Caption = 'Active', Locked = true;
        }
        field(30; VektisCode; Enum ACKVektisCode)
        {
            Caption = 'Vektis code', Locked = true;
        }
        field(40; Versie; Integer)
        {
            Caption = 'Functie versie', Locked = true;
            NotBlank = true;
        }
        field(50; Subversie; Integer)
        {
            Caption = 'Functie sub versie', Locked = true;
            NotBlank = true;
        }
    }
    keys
    {
        key(PK; MessageCode)
        {
            Clustered = true;
        }
        key(VektisVersion; VektisCode, Versie, Subversie, Active)
        {
            Unique = true;
        }
    }

    trigger OnDelete()
    var
        ACKJSONMap: Record ACKJSONMap;
    begin
        ACKJSONMap.SetRange(MessageCode, Rec.MessageCode);
        ACKJSONMap.DeleteAll(false);
    end;

}
