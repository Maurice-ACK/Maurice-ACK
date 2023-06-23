/// <summary>
/// Table ACKStudentTransportSchedule (ID 50012).
/// </summary>
table 50012 ACKStudentTransportSchedule
{
    Caption = 'Rooster', Locked = true;
    LookupPageId = ACKStudentTransportSchedule;
    DrillDownPageId = ACKStudentTransportSchedule;
    DataClassification = SystemMetadata;

    fields
    {
        field(10; custRecordId; GUID)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; routelist; Code[10])
        {
            Caption = 'Route lijst', Locked = true;
            NotBlank = true;
        }
        field(30; customerId; code[10])
        {
            Caption = 'Leerling ID', Locked = true;
            TableRelation = ACKStudentTransportCustomer.CustomerId;
            ValidateTableRelation = false;
        }

        field(40; name; Text[100])
        {
            Caption = 'Naam', Locked = true;
        }

        field(50; startDate; Date)
        {
            Caption = 'Startdatum', Locked = true;
            NotBlank = false;
        }

        field(60; endDate; Date)
        {
            Caption = 'Einddatum', Locked = true;
            NotBlank = false;
        }

        field(70; startDateTransport; Date)
        {
            Caption = 'Startdatum vervoer', Locked = true;
            NotBlank = false;
        }

        field(80; remarks; Text[500])
        {
            Caption = 'Opmerkingen', Locked = true;
            NotBlank = false;
        }

        field(90; createdBy; Text[100])
        {
            Caption = 'Aangemaakt door', Locked = true;
        }

        field(100; modified; Date)
        {
            Caption = 'Wijzigingsdatum', Locked = true;
        }

        field(110; modifiedBy; Text[100])
        {
            Caption = 'Gewijzigd door', Locked = true;
        }

        field(120; deleted; Date)
        {
            Caption = 'Verwijderingsdatum', Locked = true;
        }

        field(130; deletedBy; Text[100])
        {
            Caption = 'Verwijderd door', Locked = true;
        }

        field(140; isEditable; Boolean)
        {
            Caption = 'Wijzigbaar', Locked = true;
        }
        field(150; schoolYear; text[20])
        {
            Caption = 'Schooljaar', Locked = true;
            TableRelation = ACKStudentTransportSchedule.SchoolYear;
        }

        field(160; id; Integer)
        {
            Caption = 'ID', Locked = true;
            AutoIncrement = true;
        }
    }

    keys
    {
        key(scheduleId_PK; CustRecordId, id)
        {
            Clustered = true;

        }
        key(sec; SchoolYear)
        {

        }
    }
    fieldgroups
    {
        fieldgroup(SchoolYear; SchoolYear)
        {
        }
    }
}
