page 50099 ACKVendorAndPostingList
{
    ApplicationArea = All;
    Caption = 'Vendor & Posting';
    PageType = List;
    SourceTable = ACKVendorAndPosting;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(PostingGroup; Rec.PostingGroup)
                {
                }
                field(BatchName; Rec.JournalName)
                {
                }
            }
        }
    }
}
