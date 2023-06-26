/// <summary>
/// Page ACKStudentTransportCustomer
/// </summary>
page 50052 ACKStudentTransportCustomer
{
    Caption = 'Leerlingen', Locked = true;
    PageType = List;
    SourceTable = ACKStudentTransportCustomer;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {

        area(content)
        {
            repeater(General)
            {
                field(custRecordId; Rec.custRecordId) { }
                field(municipalityNo; Rec.municipalityNo)
                {
                }
                field(CountryId; Rec.CountryId)
                {
                }
                field(CustomerId; Rec.CustomerId)
                {
                }
                field(CustomerStatus; Rec.CustomerStatus)
                {
                }
                field(DateOfBirth; Rec.DateOfBirth)
                {
                }
                field(EmailAddress; Rec.EmailAddress)
                {
                }
                field(FirstName; Rec.FirstName)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field(Iban; Rec.Iban)
                {
                }
                field(Infix; Rec.Infix)
                {
                }
                field(Initials; Rec.Initials)
                {
                }

                field(MobileNumber; Rec.MobileNumber)
                {
                }
                field(SSN; Rec.SSN)
                {
                }
                field(State; Rec.State)
                {
                }
                field(StreetName; Rec.StreetName)
                {
                }
                field(StreetNr; Rec.StreetNr)
                {
                }
                field(StreetNrAddition; Rec.StreetNrAddition)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
                field(TelephoneNumber; Rec.TelephoneNumber)
                {
                }
                field(ZipCode; Rec.ZipCode)
                {
                }
            }
        }
    }
    actions
    {
        // Adds the action called "My Actions" to the Action menu 
        area(Processing)
        {
            action("Process")
            {

                trigger OnAction()
                var
                    runner: Codeunit ACKStudentTransportProcessData;
                    rec: Record ACKStudentTransportNodeType;
                begin
                    runner.STTCustomerToClient();
                end;
            }

            action("test")
            {
                trigger OnAction()
                var
                    test: Codeunit ACKStudentApiFormatter;
                begin

                    test.removeCurrentCustomer(xRec.custRecordId);
                end;
            }
        }
    }
}
