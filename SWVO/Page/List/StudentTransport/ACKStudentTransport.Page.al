/// <summary>
/// Page StudentTransport
/// </summary>
page 50090 StudentTransport
{
    ApplicationArea = All;
    Caption = 'Leerlingenvervoer', Locked = true;
    PageType = ListPart;
    SourceTable = ACKStudentTransportCustomer;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(MunicipalityNo; Rec.municipalityNo)
                {
                }
                field(DateOfBirth; Rec.DateOfBirth)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(surname; Rec.LastName)
                {
                }
            }
        }
    }
}
