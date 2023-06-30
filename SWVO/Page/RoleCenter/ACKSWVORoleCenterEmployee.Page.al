/// <summary>
/// Page ACKSWVORoleCenterEmployee
/// </summary>
page 50045 ACKSWVORoleCenterEmployee
{
    ApplicationArea = All;
    Caption = 'SWVO employee role center';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            group(General)
            {
                part(HeadlinePart; ACKHeadlinePart)
                {
                }
                part(QuickActionsPart; ACKQuickActionsCardPart)
                {
                }
                part(NewEntriesCuePart; ACKNewEntriesCuePart)
                {
                }
                part(RecentlyChangedCuePart; ACKRecentlyChangedCuePart)
                {
                }
            }
        }
    }
    actions
    {
        area(sections)
        {
            group(Setup)
            {
                Caption = 'Setup';
                Image = Journals;

                action(ACKSWVOGeneralSetup)
                {
                    Image = Journal;
                    RunObject = page ACKSWVOGeneralSetup;
                }
                action(ACKProductCodeList)
                {
                    Caption = 'Product codes';
                    Image = Journal;
                    RunObject = page ACKProductCodeList;
                }
                action(ACKInvalidPCCombinationList)
                {
                    Caption = 'Invalid product code combinations';
                    Image = Relationship;
                    RunObject = page ACKInvalidPCCombinationList;
                }
                action(ACKProductFrequencies)
                {
                    Caption = 'Product code - product frequencies';
                    Image = Relationship;
                    RunObject = page ACKProductCodeFrequencyList;
                }
                action(ACKJSONMessageList)
                {
                    Image = BOM;
                    RunObject = page ACKJSONMessageList;
                    Caption = 'JSON mapping', Locked = true;
                }
            }
            group(Wmo)
            {
                Caption = 'Wmo', Locked = true;
                Image = Journals;

                action(ACKWMOHeaderList)
                {
                    Caption = 'Messages';
                    Image = Journal;
                    RunObject = page ACKWMOHeaderList;
                }
                action(ACKWMOIndicationList)
                {
                    Image = Journal;
                    RunObject = page ACKWMOIndicationList;
                }
                action(ACKProductCodeRateList)
                {
                    Caption = 'Product code rates';
                    Image = Journal;
                    RunObject = page ACKProductCodeRateList;
                }
                action(ACKWMORule)
                {
                    Caption = 'Validation rules';
                    Image = BreakRulesOn;
                    RunObject = page ACKWMORuleList;
                }
            }
            group(StudentTransport)
            {
                Caption = 'Student transport';
                Image = Intrastat;

                action(TransportLineList)
                {
                    Image = Journal;
                    RunObject = page ACKTransportLineList;
                }
            }

            group(Resources)
            {
                Caption = 'Resources';
                Image = FixedAssets;

                action(ACKResourceList)
                {
                    Caption = 'Resources';
                    Image = Journal;
                    RunObject = page ACKResourceList;
                }
            }
            group(Homeless)
            {
                Caption = 'Homeless';
                Image = Home;

                action(ACKHomelessList)
                {
                    Caption = 'Homeless';
                    Image = Home;
                    RunObject = page ACKHomelessWorksheet;
                }
            }
            group(WmoTransport)
            {
                Caption = 'Wmo transport';
                Image = Intrastat;

                action(ACKTransportLineList)
                {
                    Image = Journal;
                    RunObject = page ACKTransportLineList;
                }
            }
            group(PostRegistration)
            {
                Caption = 'Post registration';
                Image = Journals;

                action(ACKPostRegistrationList)
                {
                    Caption = 'Post registration';
                    Image = Journal;
                    RunObject = page ACKPostRegistrationList;
                }
            }
            group(VAT)
            {
                Caption = 'VAT';
                Image = CashFlow;
                action("VAT Statement")
                {
                    Caption = 'Btw-aanfgifte', Locked = true;
                    Image = Journal;
                    RunObject = page "VAT Statement";
                }
            }
            group(Journals)
            {
                Caption = 'Dagboeken', Locked = true;
                Image = Journals;

                action(PeriodicJournals)
                {
                    Caption = 'Periodieke dagboeken', Locked = true;
                    Image = Journal;
                    RunObject = page "General Journal Batches";
                    RunPageLink = "Journal Template Name" = filter('PERIODIEK');
                }
                action(PaymentJournals)
                {
                    Caption = 'Betalingsdagboeken', Locked = true;
                    Image = Journal;
                    RunObject = page "General Journal Batches";
                    RunPageLink = "Journal Template Name" = filter('BETALINGEN');
                }
                action(PostedGeneralJournal)
                {
                    Image = Journal;
                    RunObject = page "Posted General Journal";
                }
            }
            group(Ledger)
            {
                Caption = 'Grootboek', Locked = true;
                Image = Ledger;

                action("Chart of Accounts")
                {
                    Caption = 'Chart of Accounts';
                    Image = Journal;
                    RunObject = page "Chart of Accounts";
                }
                action("G/L Account Categories")
                {
                    Image = Journal;
                    RunObject = page "G/L Account Categories";
                }
            }
            group(Vendors)
            {
                Caption = 'Leveranciers', Locked = true;
                Image = HumanResources;

                action("Vendor List")
                {
                    Image = Journal;
                    RunObject = page "Vendor List";
                }
                action("Inkoopfacturen")
                {
                    Image = Journal;
                    RunObject = page "Purchase Invoices";
                }
                action("Posted Purchase Invoices")
                {
                    Image = Journal;
                    RunObject = page "Posted Purchase Invoices";
                }
            }
            group(Customers)
            {
                Caption = 'Klanten', Locked = true;
                Image = HumanResources;

                action("Customer List")
                {
                    Caption = 'Klanten', Locked = true;
                    Image = Journal;
                    RunObject = page "Customer List";
                }
                action(SalesInvoices)
                {
                    Caption = 'Verkoopfacturen', Locked = true;
                    Image = Journal;
                    RunObject = page "Sales Invoice List";
                }
                action("Posted Sales Invoices")
                {
                    Image = Journal;
                    RunObject = page "Posted Sales Invoices";
                }
            }
            group(Bank)
            {
                Caption = 'Bank', Locked = true;
                Image = Bank;

                action(BankAccounts)
                {
                    Caption = 'Bank Accounts';
                    Image = Journal;
                    RunObject = page "Bank Account List";
                }
                action("Bank Account Statement List")
                {
                    Caption = 'Bank Account Statement List';
                    Image = Journal;
                    RunObject = page "Bank Account Statement List";
                }
                action("Bank Acc. Reconciliation List")
                {
                    Caption = 'Bank Account Reconciliations';
                    Image = Journal;
                    RunObject = page "Bank Acc. Reconciliation List";
                }
            }
        }
    }
}
