reportextension 50005 ACKVendorPaymentsExt extends "Suggest Vendor Payments"
{
    dataset
    {
        modify(Vendor)
        {
            trigger OnBeforeAfterGetRecord()
            var
            begin
                Vendor.SetFilter("Vendor Posting Group", '=%1', VendorFilter);
            end;
        }
    }

    requestpage
    {
        layout
        {
            addafter(Options)
            {
                group(AutoFilter)
                {
                    Caption = 'Automatic filter';

                    field(VendorFilter; VendorFilter)
                    {
                        Caption = 'Vendor/Healthcare provider';
                        ApplicationArea = all;
                        Editable = false;
                    }
                }
            }
        }
    }


    procedure setVendorFilter(VendorPostingGroupFilter: Text)
    begin
        if not (VendorPostingGroupFilter = '') then begin
            Vendor.SetFilter("Vendor Posting Group", '=%1', VendorPostingGroupFilter);
            VendorFilter := VendorPostingGroupFilter;
        end else
            VendorFilter := '';

    end;

    var
        VendorFilter: text;
}