table 50038 ACKVendorAndPosting
{
    caption = 'Vendor and posting group';
    Description = 'Relation between Vendor and posting group';
    DataClassification = SystemMetadata;

    fields
    {
        field(10; JournalName; code[10])
        {
            TableRelation = "Gen. Journal Batch".Name where("Template Type" = filter("Gen. Journal Template Type"::Payments));
            NotBlank = true;
        }
        field(20; PostingGroup; code[10])
        {
            TableRelation = "Vendor Posting Group".Code;
            NotBlank = true;
        }
    }


    keys
    {
        key(KeyId; JournalName)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestField(JournalName);
        TestField(PostingGroup);
    end;


}