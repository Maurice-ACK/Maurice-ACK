page 50123 TestApi
{
    PageType = API;
    Caption = 'TestApi';
    APIPublisher = 'swvo';
    APIGroup = 'studentTransport';
    APIVersion = 'v1.0';
    EntityName = 'test';
    EntitySetName = 'test';
    SourceTable = TestTable;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(test; Rec.test)
                {
                    Caption = 'fieldCaption';

                }
            }
        }
    }
}

table 50068 TestTable
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            AutoIncrement = true;
        }
        field(2; test; Text[200])
        {

        }
    }

    keys
    {
        key(Key1; id)
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