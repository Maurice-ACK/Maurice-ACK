table 50056 ACKPostRegistrationArchive
{
    DataClassification = CustomerContent;

    fields
    {
        field(10; id; Integer)
        {
            AutoIncrement = true;
        }
        field(20; Name; Text[50])
        {
        }
        field(30; Active; Boolean)
        {
        }
    }

    keys
    {
        key(Archive_id; id)
        {
            Clustered = true;
        }
    }
}