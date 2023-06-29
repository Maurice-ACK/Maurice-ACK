/// <summary>
/// Page ACKQuickActionsCardPart
/// </summary>
page 50093 ACKQuickActionsCardPart
{
    ApplicationArea = All;
    Caption = 'Snelkoppelingen', Locked = true;
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
                    action("Cliënten")
                    {
                        Caption = 'Cliënten', Locked = true;
                        RunObject = page "ACKClientList";
                        Image = TileReport;

                        trigger OnAction()
                        begin

                        end;
                    }
                    action("Hulpmiddelen")
                    {
                        Caption = 'Hulpmiddelen', Locked = true;
                        RunObject = page "ACKResourceList";
                        Image = TileReport;
                    }
                    action(Homeless)
                    {
                        Caption = 'Dakloosheid', Locked = true;
                        RunObject = page "ACKHomelessList";
                        Image = TileReport;
                    }
                    action(WmoTransport)
                    {
                        Caption = 'Wmo vervoer', Locked = true;
                        RunObject = page "ACKTransportLineList";
                        Image = TileReport;
                    }
                    action(PostRegistration)
                    {
                        Caption = 'Postregistratie', Locked = true;
                        RunObject = page "ACKPostRegistrationList";
                        Image = TileReport;
                    }
                    action(StudentTransport)
                    {
                        Caption = 'Leerlingenvervoer', Locked = true;
                        RunObject = page StudentTransport;
                        Image = TileReport;
                    }
                    action(GeneralJournalBatch)
                    {
                        Caption = 'Dagboeken', Locked = true;
                        RunObject = page "General Journal Batches";
                        Image = TileReport;
                    }
                    action(ChartOfAccounts)
                    {
                        Caption = 'Rekeningschema', Locked = true;
                        RunObject = page "Chart of Accounts";
                        Image = TileReport;
                    }
                    action(Customers)
                    {
                        Caption = 'Klanten', Locked = true;
                        RunObject = page "Customer List";
                        RunPageLink = "Customer Posting Group" = const('CUS');
                        RunPageView = where("Customer Posting Group" = const('CUS'));
                        Image = TileReport;
                    }
                    action(Municipalities)
                    {
                        Caption = 'Gemeenten', Locked = true;
                        RunObject = page "Customer List";
                        RunPageLink = "Customer Posting Group" = const('GEM');
                        RunPageView = where("Customer Posting Group" = const('GEM'));
                        Image = TileReport;
                    }
                    action(HealthcareProviders)
                    {
                        Caption = 'Zorgaanbieders', Locked = true;
                        RunObject = page "Vendor List";
                        RunPageLink = "Vendor Posting Group" = const('ZA');
                        RunPageView = where("Vendor Posting Group" = const('ZA'));
                        Image = TileReport;
                    }
                    action(Vendors)
                    {
                        Caption = 'Leveranciers', Locked = true;
                        RunObject = page "Vendor List";
                        RunPageLink = "Vendor Posting Group" = const('LEV');
                        RunPageView = where("Vendor Posting Group" = const('LEV'));
                        Image = TileReport;
                    }
                    action(SalesInvoices)
                    {
                        Caption = 'Verkoopfacturen', Locked = true;
                        RunObject = page "Sales Invoice List";
                        Image = TileReport;
                    }
                    action(PostedSalesInvoices)
                    {
                        Caption = 'Geboekte verkoopfacturen', Locked = true;
                        RunObject = page "Posted Sales Invoices";
                        Image = TileReport;
                    }
                    action(PurchaseInvoices)
                    {
                        Caption = 'Inkoopfacturen', Locked = true;
                        RunObject = page "Purchase Invoices";
                        Image = TileReport;
                    }
                    action(PostedPurchaseInvoices)
                    {
                        Caption = 'Geboekte inkoopfacturen', Locked = true;
                        RunObject = page "Posted Purchase Invoices";
                        Image = TileReport;
                    }
                }
            }
        }
    }
}
