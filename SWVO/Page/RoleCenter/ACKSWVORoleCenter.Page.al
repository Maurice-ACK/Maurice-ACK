/// <summary>
/// Page ACKSWVORoleCenter
/// </summary>
page 50045 ACKSWVORoleCenter
{
    ApplicationArea = All;
    Caption = 'SWVO Role Center';
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
            group(Action3)
            {
                Caption = 'Student transport';
                Image = Journals;

                action(ACKMulitCardScheduleCard)
                {
                    Image = Journal;
                    RunObject = page ACKStudentTransportSchedule;
                }

                action(ACKStudentTransportNode)
                {
                    Image = Journal;
                    RunObject = page ACKStudentTransportNode;
                }
                action(ACKStudentTransportCustomer)
                {
                    Image = Journal;
                    RunObject = page ACKStudentTransportCustomer;
                }
                action(ACKStudentTransportCustomerIndication)
                {
                    Image = Journal;
                    RunObject = page ACKStudentTransportIndication;
                }
                action(ACKStudentTransportRoute)
                {
                    Image = Journal;
                    RunObject = page ACKStudentTransportRoute;
                }
                action(ACKStudentTransportSchedule)
                {
                    Image = Journal;
                    RunObject = page ACKStudentTransportSchedule;
                }
            }
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
                    Caption = 'Product categories';
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
                action(ACKProductCodeRateList)
                {
                    Caption = 'Product code rates';
                    Image = Journal;
                    RunObject = page ACKProductCodeRateList;
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
                    RunObject = page ACKHomelessList;
                }
            }
            group(Action10)
            {
                Caption = 'Wmo transport';
                Image = Journals;

                action(ACKTransportLineList)
                {
                    Caption = 'Wmo transport lines';
                    Image = Journal;
                    RunObject = page ACKTransportLineList;
                }
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
        }
    }
}
