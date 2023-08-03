table 50073 ACKJSONMapObjectRelations
{
    DataClassification = SystemMetadata;

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
        }
        field(20; ParenteNo; Code[20])
        {
            TableRelation = ACKJSONMap.No;
        }
        field(30; ParentTableCaption; TEXT[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(ACKJSONMap.TableCaption where(No = field(ParenteNo)));
        }
        field(40; ParentField; Integer)
        {
            TableRelation = Field."No.";

            trigger OnLookup()
            var
                JsonMap: Record ACKJSONMap;
                RecField: Record Field;
                FieldSelection: Codeunit "Field Selection";
            begin
                JsonMap.SetRange(No, rec.ParenteNo);
                JsonMap.FindFirst();
                RecField.Reset();
                RecField.SetRange(TableNo, JsonMap.TableNo);

                if FieldSelection.Open(RecField) then
                    Rec.Validate(ParentField, RecField."No.");
            end;
        }
        field(50; ObjectNo; Code[20])
        {
            TableRelation = ACKJSONMap.No;
        }
        field(60; ObjectTableCaption; TEXT[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(ACKJSONMap.TableCaption where(No = field(ObjectNo)));
        }

        field(70; ObjectField; Integer)
        {
            TableRelation = Field."No.";
            trigger OnLookup()
            var
                JsonMap: Record ACKJSONMap;
                RecField: Record Field;
                FieldSelection: Codeunit "Field Selection";
            begin
                JsonMap.SetRange(No, rec.ObjectNo);
                JsonMap.FindFirst();

                RecField.Reset();
                RecField.SetRange(TableNo, JsonMap.TableNo);

                if FieldSelection.Open(RecField) then
                    Rec.Validate(ObjectField, RecField."No.");
            end;
        }
    }

    keys
    {
        key(ID; ID, ParenteNo, ObjectNo)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var

    begin

        validateFields();

    end;

    trigger OnModify()
    begin
        validateFields();
    end;


    internal procedure validateFields()
    var
        RecField: Record Field;
        RecRef: RecordRef;
        JsonMap: Record ACKJSONMap;
        ParentFieldRef: FieldRef;
        ObjectFieldRef: FieldRef;

    begin
        JsonMap.SetRange(No, rec.ParenteNo);
        JsonMap.FindFirst();
        RecRef.Open(JsonMap.TableNo);

        ParentFieldRef := RecRef.Field(Rec.ParentField);
        RecRef.Close();
        // ParentFieldRef.EnumValueCount()

        JsonMap.SetRange(No, rec.ObjectNo);
        JsonMap.FindFirst();
        RecRef.Open(JsonMap.TableNo);
        ObjectFieldRef := RecRef.Field(Rec.ObjectField);

        if (ParentFieldRef.Type <> ObjectFieldRef.Type) then
            Message('these field have different types that may lead to errors');
    end;

}