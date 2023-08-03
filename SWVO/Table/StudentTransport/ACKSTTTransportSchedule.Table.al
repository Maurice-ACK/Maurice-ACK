table 50070 ACKSTTTransportSchedule
{
    DataClassification = ToBeClassified;

    fields
    {

        field(20; request; Integer)
        {
            TableRelation = ACKSTTRequest;
        }
        field(30; Day; Enum "Recurrence - Day of Week")
        { }
        field(40; pickUpTime; Time) { }
        field(50; dropOffTime; Time) { }


    }




    keys
    {
        key(Key1; request, Day)
        {
            Clustered = true;
        }
    }

}