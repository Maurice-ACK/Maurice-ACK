/// <summary>
/// Page ACKTransportLineAPI
/// </summary>
page 50055 ACKTransportLineAPI
{
    APIGroup = 'sharepoint';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Wmo Transport', Locked = true;
    DelayedInsert = true;
    EntityName = 'transportline';
    EntitySetName = 'transportlines';
    PageType = API;
    SourceTable = ACKTransportLine;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(transportNumber; Rec.TransportNumber)
                {
                }
                field(carrier; Rec.Carrier)
                {
                }
                field(orderDate; Rec.OrderDate)
                {
                }
                field(orderTime; Rec.OrderTime)
                {
                }
                field(ssn; Rec.SSN)
                {
                }
                field(bookingType; Rec.BookingType)
                {
                }
                field(departingDateDesired; Rec.DepartingDateDesired)
                {
                }
                field(departingTimeDesired; Rec.DepartingTimeDesired)
                {
                }
                field(arrivalDateDesired; Rec.ArrivalDateDesired)
                {
                }
                field(arrivalTimeDesired; Rec.ArrivalTimeDesired)
                {
                }
                field(departingDateActual; Rec.DepartingDateActual)
                {
                }
                field(departingTimeActual; Rec.DepartingTimeActual)
                {
                }
                field(arrivalDateActual; Rec.ArrivalDateActual)
                {
                }
                field(arrivalTimeActual; Rec.ArrivalTimeActual)
                {
                }
                field(departureMunicipalityNo; Rec.DepartureMunicipalityNo)
                {
                }
                field(departureAddress; Rec.DepartureAddress)
                {
                }
                field(departureZipCode; Rec.DepartureZipCode)
                {
                }
                field(departureCity; Rec.DepartureCity)
                {
                }
                field(arrivalMunicipalityNo; Rec.ArrivalMunicipalityNo)
                {
                }
                field(arrivalAddress; Rec.ArrivalAddress)
                {
                }
                field(arrivalZipCode; Rec.ArrivalZipCode)
                {
                }
                field(arrivalCity; Rec.ArrivalCity)
                {
                }
                field(totalKm; Rec.TotalKm)
                {
                }
                field(kmOutside; Rec.KmOutside)
                {
                }
                field(kmInside; Rec.KmInside)
                {
                }
                field(wheelchair; Rec.Wheelchair)
                {
                }
                field(mobilityScooter; Rec.MobilityScooter)
                {
                }
                field(walker; Rec.Walker)
                {
                }
                field(persons; Rec.Persons)
                {
                }
                field(payCard; Rec.PayCard)
                {
                }
                field(medicalAttendant; Rec.MedicalAttendant)
                {
                }
                field(accompanied; Rec.Accompanied)
                {
                }
                field(childs; Rec.Childs)
                {
                }
                field(soHo; Rec.SoHo)
                {
                }
                field(totalOwnContribution; Rec.TotalOwnContribution)
                {
                }
                field(budget; Rec.Budget)
                {
                }
                field(ownContributionInside; Rec.OwnContributionInside)
                {
                }
                field(municipalityNo; Rec.MunicipalityNo)
                {
                }
                field(badgeNumber; Rec.BadgeNumber)
                {
                }
                field(prioRide; Rec.PrioRide)
                {
                }
                field(requestType; Rec.RequestType)
                {
                }
                field(vom; Rec.VOM)
                {
                }
                field(falseRide; Rec.FalseRide)
                {
                }
                field(carrier2; Rec.Carrier2)
                {
                }
                field(declKM; Rec.DeclKM)
                {
                }
                field(category; Rec.Category)
                {
                }
                field(comment; Rec.Comment)
                {
                }
                field(importDate; Rec.ImportDate)
                {
                }
                field(healthcareproviderNo; Rec.HealthcareproviderNo)
                {
                }
            }
        }
    }
}
