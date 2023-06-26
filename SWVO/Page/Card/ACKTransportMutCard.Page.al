/// <summary>
/// Page ACKTransportMutCard
/// </summary>
page 50082 ACKTransportMutCard
{
    Caption = 'Vervoer mutatie', Locked = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = ACKTransportMutationLine;
    UsageCategory = None;
    DelayedInsert = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ClientNo; Rec.ClientNo)
                {
                }
                field(ProcessStatus; Rec.ProcessStatus)
                {
                }
                field(SSN; Rec.SSN)
                {
                }
                field(BadgeNumber; Rec.BadgeNumber)
                {
                }
                field(BadgeNumberOld; Rec.BadgeNumberOld)
                {
                }
                field(FirstName; Rec.FirstName)
                {
                }
                field(MiddleName; Rec.MiddleName)
                {
                }
                field(surname; Rec.Surname)
                {
                }
                field(Initials; Rec.Initials)
                { }
                field(Gender; Rec.Gender)
                {
                }
                field(Birthdate; Rec.Birthdate)
                {
                }
                field(Phone; Rec.Phone)
                {
                }
                field(PhoneMobile; Rec.PhoneMobile)
                {
                }
                field(Street; Rec.Street)
                {
                }
                field(HouseNumberExt; Rec.HouseNumberExt)
                {
                }
                field(ZipCode; Rec.ZipCode)
                {
                }
                field(Municipality; Rec.Municipality)
                {
                }
                field(CorrStreet; Rec.CorrStreet)
                { }
                field(CorrZipCode; Rec.CorrZipCode)
                { }
                field(CorrCity; Rec.CorrCity)
                { }
                field(PaymentOnAccount; Rec.PaymentOnAccount)
                { }
                field(BankAccount; Rec.BankAccount)
                { }
                field(BankAccountStreet; Rec.BankAccountStreet)
                { }
                field(BankAccountHouseNumberExt; Rec.BankAccountHouseNumberExt)
                { }
                field(BankAccountZipCode; Rec.BankAccountZipCode)
                { }
                field(BankAccountCity; Rec.BankAccountCity)
                { }
                field(BankAccountName; Rec.BankAccountName)
                { }
                field(BankAccountPhone; Rec.BankAccountPhone)
                { }
                field(Remarks; Rec.Remarks)
                { }
                field(GuideDog; Rec.GuideDog)
                { }
                field(Walker; Rec.Walker)
                { }
                field(Wheelchair; Rec.Wheelchair)
                { }
                field(WheelchairFoldable; Rec.WheelchairFoldable)
                { }
                field(WheelchairElectric; Rec.WheelchairElectric)
                { }
                field(MobilityScooter; Rec.MobilityScooter)
                { }
                field(FreeAssistance; Rec.FreeAssistance)
                { }
                field(Front; Rec.Front)
                { }
                field(MutationCode; Rec.MutationCode)
                { }
                field(WMOCategory; Rec.WmoCategory)
                { }
                field(DisposalEndDate; Rec.DisposalEndDate)
                { }
                field(Budget; Rec.Budget)
                { }
                field(BudgetStartDate; Rec.BudgetStartDate)
                { }
                field(BudgetEndDate; Rec.BudgetEndDate)
                { }
                field(TaxiIndication; Rec.TaxiIndication)
                { }
                field(MutCreatedDate; Rec.MutCreatedDate)
                { }
                field(MutModifiedDate; Rec.MutModifiedDate)
                { }
                field(OverruleCityId; Rec.OverruleCityId)
                { }
            }
        }
    }
}
