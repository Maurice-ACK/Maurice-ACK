query 50017 ACKStudentTransportSchool
{
    Caption = 'StudentTransportSchool';
    QueryType = Normal;

    elements
    {

        dataitem(ACKStudentTransportRoute; ACKStudentTransportRoute)
        {
            column(scheduleId; scheduleId) { }

            dataitem(ACKStudentTransportNode; ACKStudentTransportNode)
            {
                DataItemLink = nodeId = ACKStudentTransportRoute.checkOutNode;
                column(active; active)
                {
                }
                column(municipality; municipality)
                {
                }
                column(contact; contact)
                {
                }
                column(custRecordId; custRecordId)
                {
                }
                column(emailAddress; emailAddress)
                {
                }
                column(mobileNumber; mobileNumber)
                {
                }
                column(name; name)
                {
                }
                column(nodeId; nodeId)
                {
                }
                column(nodeType; nodeType)
                {
                }
                column(phoneNumber; phoneNumber)
                {
                }
                column(remarks; remarks)
                {
                }
                column(routeId; routeId)
                {
                }
                column(streetName; streetName)
                {
                }
                column(streetNumber; streetNumber)
                {
                }
                column(streetNumberAddition; streetNumberAddition)
                {
                }
                column("type"; "type")
                {
                }
                column(zipCode; zipCode)
                {
                }
                dataitem(ACKStudentTransportSchoolNode; ACKStudentTransportSchoolNode)
                {
                    DataItemLink = nodetypeId = ACKStudentTransportNode.nodeType;
                    SqlJoinType = InnerJoin;

                    DataItemTableFilter = School = filter(true);
                    column(nodeTypeId; nodeTypeId) { }
                    column(nameType; Name)
                    {

                    }

                    column(School2; School)
                    {

                    }


                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
