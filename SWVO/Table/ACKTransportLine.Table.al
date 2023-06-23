/// <summary>
/// Table ACKTransportLine (ID 50039).
/// </summary>
table 50039 ACKTransportLine
{
    Caption = 'Wmo vervoer', Locked = true;

    DataClassification = CustomerContent;
    LookupPageId = ACKTransportLineList;
    DrillDownPageId = ACKTransportLineList;

    fields
    {
        field(10; TransportNumber; Code[12])
        {
            Caption = 'Ritnummer', Locked = true;
        }
        field(20; Carrier; Text[10])
        {
            Caption = 'Vervoerder', Locked = true;
        }
        field(30; SSN; Code[9])
        {
            Caption = 'BSN', Locked = true;
            TableRelation = ACKClient.SSN;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                TestField(Rec.SSN);
            end;
        }
        field(40; BookingType; Integer)
        {
            Caption = 'Soort boeking', Locked = true;
        }
        field(50; MunicipalityNo; Text[4])
        {
            Caption = 'Gemeente Nr.', Locked = true;
        }
        field(60; BadgeNumber; Text[10])
        {
            Caption = 'Pasnummer', Locked = true;
        }
        field(70; RequestType; Enum ACKTransportRequestType)
        {
            Caption = 'Type aanvraag', Locked = true;
        }
        field(80; Accompanied; Boolean)
        {
            Caption = 'Meereizende', Locked = true;
        }
        field(90; ArrivalAddress; Text[250])
        {
            Caption = 'Bestemmingsadres', Locked = true;
        }
        field(100; ArrivalCity; Text[60])
        {
            Caption = 'Bestemmingsplaats', Locked = true;
        }
        field(110; ArrivalMunicipalityNo; Text[10])
        {
            Caption = 'Bestemmingsgemeente', Locked = true;
        }
        field(120; ArrivalDateActual; Date)
        {
            Caption = 'Werkelijke aankomstdatum', Locked = true;
        }
        field(130; ArrivalDateDesired; Date)
        {
            Caption = 'Gewenste aankomstdatum', Locked = true;
        }
        field(140; ArrivalTimeActual; Time)
        {
            Caption = 'Werkelijke aankomsttijd', Locked = true;
        }
        field(150; ArrivalTimeDesired; Time)
        {
            Caption = 'Gewenste aankomsttijd', Locked = true;
        }
        field(160; ArrivalZipCode; Text[10])
        {
            Caption = 'Bestemmingspostcode', Locked = true;
        }
        field(170; Budget; Decimal)
        {
            Caption = 'Budget', Locked = true;
            DecimalPlaces = 0 : 2;
        }
        field(180; Childs; boolean)
        {
            Caption = 'Kinderen', Locked = true;
        }
        field(190; DepartingDateActual; Date)
        {
            Caption = 'Werkelijke vertrekdatum', Locked = true;
        }
        field(200; DepartingDateDesired; Date)
        {
            Caption = 'Gewenste aankomstdatum', Locked = true;
        }
        field(210; DepartingTimeActual; Time)
        {
            Caption = 'Werkelijke vertrektijd', Locked = true;
        }
        field(220; DepartingTimeDesired; Time)
        {
            Caption = 'Gewenste vertrektijd', Locked = true;
        }
        field(230; DepartureAddress; Text[250])
        {
            Caption = 'Vertrek adres', Locked = true;
        }
        field(240; DepartureCity; Text[60])
        {
            Caption = 'Vertrekplaats', Locked = true;
        }
        field(250; DepartureMunicipalityNo; Text[4])
        {
            Caption = 'Vertrek gemeente', Locked = true;
        }
        field(260; DepartureZipCode; Text[10])
        {
            Caption = 'Vertrek postcode', Locked = true;
        }
        field(270; FalseRide; boolean)
        {
            Caption = 'Loze rit', Locked = true;
        }
        field(290; KmInside; Decimal)
        {
            Caption = 'KM binnen', Locked = true;
            DecimalPlaces = 0 : 2;
        }
        field(300; KmOutside; Decimal)
        {
            Caption = 'KM buiten', Locked = true;
            DecimalPlaces = 0 : 2;
        }
        field(310; MedicalAttendant; boolean)
        {
            Caption = 'Medisch begeleider', Locked = true;
        }
        field(320; MobilityScooter; boolean)
        {
            Caption = 'Scootmobiel', Locked = true;
        }
        field(330; OrderDate; Date)
        {
            Caption = 'Besteldatum', Locked = true;
        }
        field(340; OrderTime; Time)
        {
            Caption = 'Besteltijd', Locked = true;
        }
        field(350; OwnContributionInside; Decimal)
        {
            Caption = 'Eigen bijdrage binnen', Locked = true;
            DecimalPlaces = 0 : 2;
        }
        field(360; PayCard; boolean)
        {
            Caption = 'Betaalpas', Locked = true;
        }
        field(370; Persons; Integer)
        {
            Caption = 'Aantal personen', Locked = true;
        }
        field(380; PrioRide; boolean)
        {
            Caption = 'Prioriteitsrit', Locked = true;
        }
        field(390; SoHo; boolean)
        {
            Caption = 'SoHo', Locked = true;
        }
        field(400; TotalKm; Decimal)
        {
            Caption = 'KM totaal', Locked = true;
            DecimalPlaces = 0 : 2;
        }
        field(410; TotalOwnContribution; Decimal)
        {
            Caption = 'Totaal eigenbijdrage', Locked = true;
            DecimalPlaces = 0 : 2;
        }
        field(420; VOM; boolean)
        {
            Caption = 'VOM', Locked = true;
        }
        field(430; Walker; boolean)
        {
            Caption = 'Rollator', Locked = true;
        }
        field(440; Wheelchair; boolean)
        {
            Caption = 'Rolstoel', Locked = true;
        }
        field(450; Carrier2; Text[10])
        {
            Caption = 'Vervoerder 2';
        }
        field(460; DeclKm; Decimal)
        {
            Caption = 'Gedeclareerde KM', Locked = true;
            DecimalPlaces = 0 : 2;
        }
        field(470; Category; Integer)
        {
            Caption = 'Categorie', Locked = true;
        }
        field(480; Comment; Text[512])
        {
            Caption = 'Opmerking', Locked = true;
        }
        field(490; HealthcareproviderNo; Code[20])
        {
            Caption = 'Zorgaanbieder Nr.', Locked = true;
            TableRelation = Vendor."No.";
        }
        field(500; HealthcareProviderName; Text[100])
        {
            Caption = 'Zorgaanbieder', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field(HealthcareProviderNo)));
            Editable = false;
        }
        field(515; MunicipalityName; Text[100])
        {
            Caption = 'Gemeente', Locked = true;
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field(MunicipalityNo)));
            Editable = false;
        }
        field(510; ImportDate; DateTime)
        {
            Caption = 'ImportDate';
        }
    }
    keys
    {
        key(PK; TransportNumber)
        {
            Clustered = true;
        }
    }
}
