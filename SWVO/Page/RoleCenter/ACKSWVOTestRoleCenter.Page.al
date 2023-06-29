/// <summary>
/// Page ACKSWVOTestRoleCenter
/// </summary>
page 50058 ACKSWVOTestRoleCenter
{
    ApplicationArea = All;
    Caption = 'SWVOTestRoleCenter';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            group(Group1)
            {
                part(Headline1; ACKHeadlinePart)
                {
                }
                part(Part1; ACKQuickActionsCardPart)
                {
                }
                part(Part2; ACKNewEntriesCuePart)
                {
                }
                part(Part3; ACKRecentlyChangedCuePart)
                {
                }
            }
        }
    }
    actions
    {
        area(sections)
        {
            group(Action1)
            {
                Caption = 'Client';
                Image = Journals;

                action(ACKClientList)
                {
                    Image = Journal;
                    RunObject = page ACKClientList;
                }
            }
            group(Action2)
            {
                Caption = 'Wmo';
                Image = Journals;

                action(ACKWMOHeaderList)
                {
                    Caption = 'Messages';
                    Image = Journal;
                    RunObject = page ACKWMOHeaderList;
                }
                action(ACKWMOIndicationList)
                {
                    Caption = 'Indications';
                    Image = Journal;
                    RunObject = page ACKWMOIndicationList;
                }
                action(ACKWMORetourCodeList)
                {
                    Image = Journal;
                    RunObject = page ACKWMORetourCodeList;
                }
            }
            // group(Action3)
            // {
            //     Caption = 'Student transport';
            //     Image = Journals;

            //     action(ACKMulitCardScheduleCard)
            //     {
            //         ApplicationArea = all;
            //         Image = Journal;
            //         RunObject = page ACKStudentTransportSchedule;
            //     }

            //     action(ACKStudentTransportNode)
            //     {
            //         Image = Journal;
            //         RunObject = page ACKStudentTransportNode;
            //     }
            //     action(ACKStudentTransportCustomer)
            //     {
            //         Image = Journal;
            //         RunObject = page ACKStudentTransportCustomer;
            //     }
            //     action(ACKStudentTransportCustomerIndication)
            //     {
            //         Image = Journal;
            //         RunObject = page ACKStudentTransportIndication;
            //     }
            //     // action(ACKStudentTransportNodeType)
            //     // {
            //     //     ApplicationArea = all;
            //     //     Image = Journal;
            //     //     RunObject = page ACKStudentTransportNodeType;
            //     // }
            //     action(ACKStudentTransportRoute)
            //     {
            //         Image = Journal;
            //         RunObject = page ACKStudentTransportRoute;
            //     }
            //     // action(ACKStudentTransportRouteType)
            //     // {
            //     //     ApplicationArea = all;
            //     //     Image = Journal;
            //     //     RunObject = page ACKStudentTransportRouteType;
            //     // }
            //     action(ACKStudentTransportSchedule)
            //     {
            //         Image = Journal;
            //         RunObject = page ACKStudentTransportSchedule;
            //     }
            // }
            group(Action5)
            {
                Caption = 'Setup';
                Image = Journals;

                action(ACKSWVOGeneralSetup)
                {
                    Image = Journal;
                    RunObject = page ACKSWVOGeneralSetup;
                }
                action(ACKWMOProductCategoryList)
                {
                    Caption = 'Productcategories';
                    Image = Journal;
                    RunObject = page ACKWMOProductCategoryList;
                }
                action(ACKWMOProductCodeList)
                {
                    Caption = 'Product codes';
                    Image = Journal;
                    RunObject = page ACKWMOProductCodeList;
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
                action(ACKProductCodeRateMonthList)
                {
                    Caption = 'Product code rates';
                    Image = Journal;
                    RunObject = page ACKProductCodeRateList;
                }
                action(ACKJSONMessageList)
                {
                    Image = BOM;
                    RunObject = page ACKJSONMessageList;
                    Caption = 'JSON mapping', Locked = true;
                }
            }
            group(Action8)
            {
                Caption = 'Resources';
                Image = Journals;

                action(ACKResourceList)
                {
                    Image = Journal;
                    RunObject = page ACKResourceList;
                }
            }
            group(Action9)
            {
                Caption = 'Homeless';
                Image = Journals;

                action(ACKHomelessList)
                {
                    Image = Journal;
                    RunObject = page ACKHomelessWorksheet;
                }
            }
            group(Action10)
            {
                Caption = 'Wmo Transport';
                Image = Journals;

                action(ACKTransportLineList)
                {
                    Caption = 'Wmo Transport lines';
                    Image = Journal;
                    RunObject = page ACKTransportLineList;
                }

                // action(ACKTransportMutatImpList)
                // {
                //     ApplicationArea = all;
                //     Image = Journal;
                //     RunObject = page ACKTransportMutationList;
                // }
            }
            group(Action11)
            {
                Caption = 'Post registration';
                Image = Journals;

                action(ACKPostRegistrationList)
                {
                    Image = Journal;
                    RunObject = page ACKPostRegistrationList;
                }
            }
            group(Action12)
            {
                Caption = 'Btw';
                Image = Journals;

                action("VAT Statement")
                {
                    Image = Journal;
                    RunObject = page "VAT Statement";
                }
            }
            group(Action13)
            {
                Caption = 'Dagboeken';
                Image = Journals;

                action("Periodieke dagboeken")
                {
                    Image = Journal;
                    RunObject = page 251;
                    RunPageLink = "Journal Template Name" = filter('PERIODIEK');

                }
                action("Betalingsdagboeken")
                {
                    ;
                    Image = Journal;
                    RunObject = page 251;
                    RunPageLink = "Journal Template Name" = filter('BETALINGEN');
                }
                action("Posted General Journal")
                {
                    Image = Journal;
                    RunObject = page "Posted General Journal";
                }
            }
            group(Action14)
            {
                Caption = 'Grootboek';
                Image = Journals;

                action("Chart of Accounts")
                {
                    Image = Journal;
                    RunObject = page 16;
                }
                action("G/L Account Categories")
                {
                    Image = Journal;
                    RunObject = page "G/L Account Categories";
                }
            }
            group(Action15)
            {
                Caption = 'Leveranciers';
                Image = Journals;

                action("Vendor List")
                {
                    Image = Journal;
                    RunObject = page "Vendor List";
                }
                action("Inkoopfacturen")
                {
                    Image = Journal;
                    RunObject = page 9308;
                }
                action("Posted Purchase Invoices")
                {
                    Image = Journal;
                    RunObject = page "Posted Purchase Invoices";
                }
            }
            group(Action16)
            {
                Caption = 'Klanten';
                Image = Journals;

                action("Customer List")
                {
                    Image = Journal;
                    RunObject = page "Customer List";
                }
                action("Verkoopfacturen")
                {
                    Image = Journal;
                    RunObject = page 9301;
                }
                action("Posted Sales Invoices")
                {
                    Image = Journal;
                    RunObject = page "Posted Sales Invoices";
                }
            }
            group(Action17)
            {
                Caption = 'Bank';
                Image = Journals;

                action("Bank Account List")
                {
                    Image = Journal;
                    RunObject = page "Bank Account List";
                }
                action("Bank Account Statement List")
                {
                    Image = Journal;
                    RunObject = page "Bank Account Statement List";
                }
                action("Bank Acc. Reconciliation List")
                {
                    Image = Journal;
                    RunObject = page "Bank Acc. Reconciliation List";
                }
            }
        }
    }
}