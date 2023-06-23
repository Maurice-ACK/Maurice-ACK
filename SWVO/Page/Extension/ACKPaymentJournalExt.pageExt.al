pageextension 50002 ACKPaymentJournalExt extends "Payment Journal"
{
    layout
    {
    }

    actions
    {
        modify("SuggestVendorPayments")
        {
            Visible = false;
        }


        addfirst("&payments")
        {
            action("Suggest Vendor Payments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest Vendor Payments';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Category5;
                Image = SuggestVendorPayments;
                ToolTip = 'Create payment suggestions as lines in the payment journal.';

                trigger OnAction()
                var
                    filter: record ACKVendorAndPosting;
                    postingGroup: code[10];
                    suggestVendorPayments: Report "Suggest Vendor Payments";
                begin
                    filter.SetRange(JournalName, Rec."Journal Batch Name");
                    postingGroup := '';

                    if filter.FindFirst() then
                        postingGroup := filter.postingGroup;

                    Clear(SuggestVendorPayments);
                    suggestVendorPayments.SetGenJnlLine(Rec);
                    suggestVendorPayments.setVendorFilter(postingGroup);
                    suggestVendorPayments.RunModal();

                end;
            }
        }
    }

}
