/// <summary>
/// Page ACKTransportLineCard (ID 50034).
/// </summary>
page 50034 ACKTransportLineCard
{
    Caption = 'Wmo vervoer', Locked = true;
    PageType = Card;
    RefreshOnActivate = true;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    SourceTable = ACKTransportLine;
    UsageCategory = None;
    DelayedInsert = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Personal data")
            {
                Caption = 'Persoonsgegevens', Locked = true;
                field(SSN; Rec.SSN)
                {
                }
                field(ClientNo; ACKClient.ClientNo)
                {
                }
                field("First Name"; ACKClient."First Name")
                {
                }
                field("Middle Name"; ACKClient."Middle Name")
                {
                }
                field(Surname; ACKClient.Surname)
                {
                }
                field(Initials; ACKClient.Initials)
                {
                }
                field(Gender; ACKClient.Gender)
                {
                }
                field(Birthdate; ACKClient.Birthdate)
                {
                }
            }
            group("Trip data")
            {
                Caption = 'Ritgegevens', Locked = true;
                field(TransportNumber; Rec.TransportNumber)
                {
                }
                field(Carrier; Rec.Carrier)
                {
                }
                field(BadgeNumber; Rec.BadgeNumber)
                {
                }
                field(TotalKm; Rec.TotalKm)
                {
                }
                field(PrioRide; Rec.PrioRide)
                {
                }
                field(BookingType; Rec.BookingType)
                {
                }
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                }
                field(Persons; Rec.Persons)
                {
                }
                field(RequestType; Rec.RequestType)
                {
                }
                field(Accompanied; Rec.Accompanied)
                {
                }
                field(OrderDate; Rec.OrderDate)
                {
                }
                field(OrderTime; Rec.OrderTime)
                {
                }
                field(FalseRide; Rec.FalseRide)
                {
                }
                field(KmInside; Rec.KmInside)
                {
                }
                field(KmOutside; Rec.KmOutside)
                {
                }
                field(DepartingDateActual; Rec.DepartingDateActual)
                {
                }
                field(DepartingDateDesired; Rec.DepartingDateDesired)
                {
                }
                field(DepartingTimeActual; Rec.DepartingTimeActual)
                {
                }
                field(DepartingTimeDesired; Rec.DepartingTimeDesired)
                {
                }
                field(DepartureAddress; Rec.DepartureAddress)
                {
                }
                field(DepartureCity; Rec.DepartureCity)
                {
                }
                field(DepartureMunicipalityNo; Rec.DepartureMunicipalityNo)
                {
                }
                field(DepartureZipCode; Rec.DepartureZipCode)
                {
                }
                field(Childs; Rec.Childs)
                {
                }
                field(ArrivalAddress; Rec.ArrivalAddress)
                {
                }
                field(ArrivalCity; Rec.ArrivalCity)
                {
                }
                field(ArrivalMunicipalityNo; Rec.ArrivalMunicipalityNo)
                {
                }
                field(ArrivalDateActual; Rec.ArrivalDateActual)
                {
                }
                field(ArrivalDateDesired; Rec.ArrivalDateDesired)
                {
                }
                field(ArrivalTimeActual; Rec.ArrivalTimeActual)
                {
                }
                field(ArrivalTimeDesired; Rec.ArrivalTimeDesired)
                {
                }
                field(ArrivalZipCode; Rec.ArrivalZipCode)
                {
                }
            }
            group("Other Medical")
            {
                Caption = 'Overig Medisch', Locked = true;
                field(VOM; Rec.VOM)
                {
                }
                field(Walker; Rec.Walker)
                {
                }
                field(Wheelchair; Rec.Wheelchair)
                {
                }
                field(SoHo; Rec.SoHo)
                {
                }
                field(MedicalAttendant; Rec.MedicalAttendant)
                {
                }
                field(MobilityScooter; Rec.MobilityScooter)
                {
                }
            }
            group("Payment details")
            {
                Caption = 'Betalingsgegevens', Locked = true;
                field(TotalOwnContribution; Rec.TotalOwnContribution)
                {
                }
                field(OwnContributionInside; Rec.OwnContributionInside)
                {
                }
                field(PayCard; Rec.PayCard)
                {
                }
                field(Budget; Rec.Budget)
                {
                }
            }
            group(Other)
            {
                Caption = 'Overig', Locked = true;
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {
                }
                field(ImportDate; Rec.ImportDate)
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ACKClient.SetRange(SSN, Rec.SSN);
        ACKClient.FindFirst();
    end;

    var
        ACKClient: Record ACKClient;
}
