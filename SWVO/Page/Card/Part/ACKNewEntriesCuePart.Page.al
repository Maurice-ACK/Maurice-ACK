/// <summary>
/// Page ACKNewEntriesCuePart
/// </summary>
page 50063 ACKNewEntriesCuePart
{
    ApplicationArea = All;
    Caption = 'Nieuw', Locked = true;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            cuegroup("")
            {
                CuegroupLayout = wide;

                actions
                {
                    action(PostRegistration)
                    {
                        Caption = 'Postregistratie', Locked = true;
                        RunObject = page "ACKPostRegistrationCard";
                        Image = TileNew;
                        RunPageMode = Create;
                    }
                    action(GeneralJournal)
                    {
                        Caption = 'Diversendagboek', Locked = true;
                        RunObject = page "General Journal";
                        Image = TileNew;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Start Btw-aangifte")
                    {
                        Caption = 'Start Btw-aangifte', Locked = true;
                        RunObject = report "VAT Statement";
                        Image = TileNew;
                        RunPageMode = Create;
                    }
                    action(Customer)
                    {
                        Caption = 'Klant', Locked = true;
                        RunObject = page "Customer Card";
                        Image = TileNew;
                        RunPageMode = Create;
                    }
                    action(SalesInvoice)
                    {
                        Caption = 'Nieuwe verkoopfactuur', Locked = true;
                        RunObject = page "Sales Invoice";
                        Image = TileNew;
                        RunPageMode = Create;
                    }
                    action(Vendor)
                    {
                        Caption = 'Nieuwe leverancier', Locked = true;
                        RunObject = page "Vendor Card";
                        Image = TileNew;
                        RunPageMode = Create;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action(HealthcareProvider)
                    {
                        Caption = 'Zorgaanbieder', Locked = true;
                        RunObject = page "Vendor Card";
                        Image = TileNew;
                        RunPageMode = Create;
                    }
                    action(Municipality)
                    {
                        Caption = 'Gemeente', Locked = true;
                        RunObject = page "Customer Card";
                        Image = TileNew;
                        RunPageMode = Create;
                    }
                    action(PurchaseInvoice)
                    {
                        Caption = 'Inkoopfactuur', Locked = true;
                        RunObject = page "Purchase Invoice";
                        Image = TileNew;
                        RunPageMode = Create;
                    }
                    action(PaymentJournal)
                    {
                        Caption = 'Betaling genereren', Locked = true;
                        RunObject = page "Payment Journal";
                        Image = TileNew;
                    }
                }
            }
        }
    }
}
