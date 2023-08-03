page 50122 ACKJSONMapParentRelation
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ACKJSONMapObjectRelations;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ParentTableNo; Rec.ParenteNo) { }
                // field(ParentTableCaption; rec.ParentTableCaption) { }
                field(ParentField; Rec.ParentField) { }

                field(TableNo; Rec.ObjectNo) { }
                field(TableField; Rec.ObjectField) { }
                // field(ObjectTableCaption; rec.ObjectTableCaption) { }

            }

        }
    }


    trigger OnOpenPage()
    var
    begin

        //Message(rec.GetFilters);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
    begin
        // Message(rec.GetFilters);

    end;


}