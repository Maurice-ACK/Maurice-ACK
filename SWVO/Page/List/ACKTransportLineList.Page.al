/// <summary>
/// Page ACKTransportLineList
/// </summary>
page 50094 ACKTransportLineList
{
    Caption = 'Wmo vervoer regels', Locked = true;
    CardPageID = ACKTransportLineCard;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;
    PageType = List;
    SourceTable = ACKTransportLine;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SSN; Rec.SSN)
                {
                }
                field(BadgeNumber; Rec.BadgeNumber)
                {
                }
                field(BookingType; Rec.BookingType)
                {
                }
                field(TransportNumber; Rec.TransportNumber)
                {
                }
                field(Accompanied; Rec.Accompanied)
                {
                }
                field(MunicipalityName; Rec.MunicipalityName)
                {
                }
                field(HealthcareProviderName; Rec.HealthcareProviderName)
                {
                }
                field(ImportDate; Rec.ImportDate)
                {
                }
            }
        }
    }
}
