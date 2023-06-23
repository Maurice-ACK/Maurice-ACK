reportextension 50000 ACKInvoiceExt extends "Standard Sales - Invoice"
{

    dataset
    {
        add(Line)
        {
            column(VAT_Line; VATPrice)
            {
            }
            column(VAT_Line_Lbl; VATLine_Lbl)
            {
            }
        }
        modify(line)
        {
            trigger OnAfterAfterGetRecord()
            begin
                VATPrice := "Amount Including VAT" - Amount;
            end;
        }
    }

    var
        VATPrice: Decimal;
        VATLine_Lbl: Label 'VAT', Comment = 'sets the field label for the field Vat_line';

}