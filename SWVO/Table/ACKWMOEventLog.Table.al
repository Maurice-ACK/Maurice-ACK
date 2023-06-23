/// <summary>
/// Table ACKEventLog (ID 50054).
/// </summary>
table 50054 ACKEventLog
{
    Caption = 'Event log';
    DataClassification = SystemMetadata;

    fields
    {
        field(10; ID; BigInteger)
        {
            AutoIncrement = true;
            Caption = 'ID', Locked = true;
            Editable = false;
        }
        field(20; RefTableId; Integer)
        {
            Caption = 'Reference Table ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Table));
            ValidateTableRelation = true;
        }
        field(30; RefSystemID; Guid)
        {
            Caption = 'Reference record';
            ValidateTableRelation = false;

            TableRelation =
            if (RefTableId = const(Database::ACKWMOHeader)) ACKWMOHeader.SystemId
            else
            if (RefTableId = const(Database::ACKStUF)) ACKStUF.SystemId;
        }
        field(40; Severity; enum Severity)
        {
            Caption = 'Severity';
        }
        field(50; Message; Text[1024])
        {
            Caption = 'Message';
        }
        field(60; TableName; Text[249])
        {
            Caption = 'Table name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                        "Object ID" = field(RefTableId)));
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}
