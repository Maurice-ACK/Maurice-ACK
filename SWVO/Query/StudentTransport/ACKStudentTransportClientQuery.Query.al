query 50011 ACKStudentTransportClientQuery
{
    Caption = 'StudentTransportClientQuery';
    QueryType = Normal;
    QueryCategory = 'Client List';


    elements
    {
        dataitem(ACKClient; ACKClient)
        {
            column(Birthdate; Birthdate)
            {
            }
            column(ClientNo; ClientNo)
            {
            }
            column(FirstName; "First Name")
            {
            }
            column(Gender; Gender)
            {
            }
            column(Initials; Initials)
            {
            }
            column(MiddleName; "Middle Name")
            {
            }
            column(NoSeries; NoSeries)
            {
            }
            column(SSN; SSN)
            {
            }
            column(Surname; Surname)
            {
            }


            dataitem(ACKStudentTransportClientData; ACKStudentTransportClientData)
            {
                SqlJoinType = InnerJoin;
                DataItemLink = ClientNo = ACKClient.ClientNo;
                column(CustomerID; CustomerID) { }
                column(compensation; "compensation")
                {

                }
                column(contribution; contribution)
                {

                }

                dataitem(User; User)
                {
                    DataItemLink = "User Security ID" = ACKStudentTransportClientData.Attendant;

                    column(User_Name; "User Name") { }
                    column(User_Security_ID; "User Security ID") { }


                }

            }

        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
