/// <summary>
/// Report ACKStudentTransportCustReport (ID 50001).
/// </summary>
report 50000 ACKStudentTransportCustReport
{

    ApplicationArea = All;
    Caption = 'Leerlingenvervoer rapport', Locked = true;
    DefaultLayout = Word;
    WordLayout = 'reports/ClientReport.docx';
    UsageCategory = Administration;
    dataset
    {
        dataitem(ACKClient; ACKClient)
        {

            column(ClientNo; ClientNo)
            {
            }
            column(Initials; Initials)
            {
            }
            column(First_Name; "First Name")
            { }
            column(Surname; Surname) { }
            column(Birthdate; Birthdate)
            {


            }
            column(birtdayText; birtdayText)
            {

            }
            column(Middle_Name; "Middle Name")
            { }


            //
            column(schoolname; schoolname)
            {

            }


            dataitem(ACKClientAddress; ACKClientAddress)
            {
                DataItemLink = ClientNo = field(ClientNo);

                column(PlaceOfResidence; "Place of residence") { }
                column(Postcode; PostCode) { }
                column(EmailAddress; EmailAddress) { }
                column(HouseNumber; HouseNumber) { }
                column(HouseLetter; HouseLetter) { }
                column(Street; Street) { }
                column(HouseNumberAddition; HouseNumberAddition) { }




            }
            dataitem(ACKStudentTransportClientData; ACKStudentTransportClientData)
            {
                DataItemLink = ClientNo = field(ClientNo);

            }
            trigger OnAfterGetRecord()
            var
                schoolQ: Query ACKSTTFilterSchool;
            begin
                birtdayText := Format(Birthdate);





            end;

            trigger OnPreDataItem()
            begin

            end;


        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }







    procedure setLayout(layoutCode: code[20])
    var
        rls: record "Report Layout Selection";
    begin

        rls.SetTempLayoutSelected(layoutCode)
    end;


    var
        textTest: text;
        birtdayText: text;
        schoolname: text;

}


