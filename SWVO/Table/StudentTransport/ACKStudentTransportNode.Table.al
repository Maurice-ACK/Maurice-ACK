/// <summary>
/// Table ACKStudentTransportCheckOutNode (ID 50018).
/// </summary>
table 50018 ACKStudentTransportNode
{
    Caption = 'Check uit node', Locked = true;
    DataClassification = CustomerContent;

    fields
    {
        field(10; custRecordId; GUID)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; nodeId; Code[20])
        {
            Caption = 'Node ID', Locked = true;
        }
        field(30; name; Text[50])
        {
            Caption = 'Naam', Locked = true;
        }
        field(40; streetName; Text[50])
        {
            Caption = 'Straatnaam', Locked = true;
        }
        field(50; streetNumber; Text[20])
        {
            Caption = 'Straatnummer', Locked = true;
        }
        field(60; streetNumberAddition; Text[20])
        {
            Caption = 'Huisnummer toevoeging', Locked = true;
        }
        field(70; zipCode; Text[20])
        {
            Caption = 'Postcode', Locked = true;
        }
        field(80; municipality; Text[20])
        {
            Caption = 'Gemeente', Locked = true;
        }
        field(90; contact; Text[20])
        {
            Caption = 'Contact', Locked = true;
        }
        field(100; phoneNumber; Text[20])
        {
            Caption = 'Telefoonnummer', Locked = true;
        }
        field(110; mobileNumber; Text[20])
        {
            Caption = 'Mobiel', Locked = true;
        }
        field(120; emailAddress; Text[50])
        {
            Caption = 'E-mailadres', Locked = true;
        }
        field(130; remarks; Text[300])
        {
            Caption = 'Opmerkingen', Locked = true;
        }
        field(140; externalId; Code[20])
        {
            Caption = 'Extern nummer', Locked = true;
        }
        field(150; active; Boolean)
        {
            Caption = 'Actief', Locked = true;
        }
        field(160; nodeType; code[20])
        {
            Caption = 'Node type', Locked = true;
            TableRelation = ACKStudentTransportNodeType.NodeTypeId;
            ValidateTableRelation = false;
        }
        field(170; routeId; Code[20])
        {
            Caption = 'Route ID', Locked = true;
            TableRelation = ACKStudentTransportRoute.RouteId;
            ValidateTableRelation = false;

        }
        field(180; type; Enum ACKStudentTransportNodeType)
        {
            Caption = 'Node type', Locked = true;
        }
    }
    keys
    {
        key(checkOut_PK; nodeId, custRecordId)
        {
            Clustered = true;
        }

    }
    trigger OnInsert()
    var
        dataCheckNodeType: Record ACKStudentTransportNodeType;
    begin
        dataCheckNodeType.NodeTypeId := Rec.NodeType;
        //TestField(Rec.NodeTypeId);

        //if not dataCheckNodeType.Find('=') then
        //Error('Error on insert NodeTypeId not found in the NodeType table');


    end;
}
