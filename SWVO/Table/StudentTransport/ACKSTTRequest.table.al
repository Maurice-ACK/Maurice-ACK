table 50071 ACKSTTRequest
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            AutoIncrement = true;
        }
        field(20; clientID; code[20])
        {
            TableRelation = ACKClient.ClientNo;
        }
        field(30; schoolID; code[20])
        {
            TableRelation = Vendor."No." where(ACKStudentStransport = filter(true));
        }
    }

    keys
    {
        key(Key1; id)
        {
            Clustered = true;
        }
    }


}