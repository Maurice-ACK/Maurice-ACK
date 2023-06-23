page 50105 ACKOtherDocumentListPart
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ACKOtherDocuments;
    Caption = 'Other Documents';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;



    layout
    {
        area(Content)
        {
            repeater("Documents")
            {
                field(HealthcareProviderName; rec.HealthcareProviderName)
                {
                    Visible = false;
                }
                field(Title; Rec.Title)
                {
                    trigger OnDrillDown()
                    begin
                        Hyperlink(rec.url);
                    end;
                }
                field(Description; Rec.Description)
                {
                    trigger OnDrillDown()
                    begin
                        Hyperlink(rec.url);
                    end;
                }
                field(importDate; Rec.importDate)
                {
                    trigger OnDrillDown()
                    begin
                        Hyperlink(rec.url);
                    end;
                }
            }
        }
    }
}