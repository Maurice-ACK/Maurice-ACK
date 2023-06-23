/// <summary>
/// Table ACKStudentTransportCheckInNode (ID 50015).
/// </summary>
table 50015 ACKStudentTransportCheckIn
{
    Caption = 'Check in node', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; NodeId; Code[20])
        {
            Caption = 'Node ID', Locked = true;
        }
        field(20; Name; Text[20])
        {
            Caption = 'Naam', Locked = true;
        }
        field(30; StreetName; Text[20])
        {
            Caption = 'Straatnaam', Locked = true;
        }
        field(40; StreetNumber; Text[20])
        {
            Caption = 'Straatnummer', Locked = true;
        }
        field(50; StreetNumberAddition; Text[20])
        {
            Caption = 'Huisnummer toevoeging', Locked = true;
        }
        field(60; ZipCode; Text[20])
        {
            Caption = 'Postcode';
        }
        field(70; Municipality; Text[20])
        {
            Caption = 'Gemeente', Locked = true;
        }
        field(80; Contact; Text[20])
        {
            Caption = 'Contact', Locked = true;
        }
        field(90; PhoneNumber; Text[20])
        {
            Caption = 'Telefoonnummer', Locked = true;
        }
        field(100; MobileNumber; Text[20])
        {
            Caption = 'Mobiel', Locked = true;
        }
        field(110; EmailAddress; Text[20])
        {
            Caption = 'E-mailadres', Locked = true;
        }
        field(120; Remarks; Text[20])
        {
            Caption = 'Opmerkingen', Locked = true;
        }
        field(130; Latitude; Decimal)
        {
            DecimalPlaces = 6;
            Caption = 'Breedtegraad', Locked = true;
        }
        field(140; Longitude; Decimal)
        {
            DecimalPlaces = 6;
            Caption = 'Lengtegraad', Locked = true;
        }
        field(150; ExternalId; Code[20])
        {
            Caption = 'ExternalId', Locked = true;
        }
        field(160; Active; Boolean)
        {
            Caption = 'Actief', Locked = true;
        }
        field(170; nodeTypeID; code[20])
        {
            TableRelation = ACKStudentTransportNodeType.NodeTypeId;
            Caption = 'Node type', Locked = true;
        }
        field(180; routeID; Code[20])
        {
            TableRelation = ACKStudentTransportRoute.RouteId;
            Caption = 'Route ID', Locked = true;
        }
    }
    keys
    {
        key(checkIn_PK; NodeId)
        {
            Clustered = true;
        }
        key(unique_Keys; nodeTypeID)
        {
            Unique = true;
        }
    }
}
