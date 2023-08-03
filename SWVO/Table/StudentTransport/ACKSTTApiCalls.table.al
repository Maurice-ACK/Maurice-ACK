table 50072 ACKSTTApiCalls
{
    DataClassification = ToBeClassified;

    fields
    {
        field(10; ID; Integer)
        {
            AutoIncrement = true;
        }
        field(20; berichtCode; Enum ACKVektisCode)
        {
            DataClassification = ToBeClassified;
        }
        field(30; Body; Blob)
        {

        }
    }

    keys
    {
        key(ID; ID)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}