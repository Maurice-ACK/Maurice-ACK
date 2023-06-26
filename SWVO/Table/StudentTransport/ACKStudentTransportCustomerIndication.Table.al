/// <summary>
/// Table ACKStudentTransportCustomerIndication
/// </summary>
table 50021 ACKStudentTransportCustIndicat
{
    Caption = 'Leerling indicatie', Locked = true;
    DataClassification = ToBeClassified;

    fields
    {
        field(10; custRecordId; guid)
        {
            Caption = 'Leerling record ID', Locked = true;
        }
        field(20; CustomerId; code[20])
        {
            Caption = 'Leerling ID', Locked = true;
            TableRelation = ACKStudentTransportCustomer.CustomerId;
        }
        field(30; AdditionalValue; Text[20])
        {
            Caption = 'Aanvullende waarde', Locked = true;
        }
        field(40; CreationDate; Date)
        {
            Caption = 'Aanmaakdatum', Locked = true;
        }
        field(50; MutationDate; Date)
        {
            Caption = 'Mutatiedatum', Locked = true;
        }
        field(60; indication; code[20])
        {
            Caption = 'Indicatie', Locked = true;
            TableRelation = ACKStudentTransportIndication.IndicationId;
            ValidateTableRelation = false;
        }
    }
    keys
    {
        key(CustomerIndId_PK; CustomerId)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        dataCheckCustomer: Record ACKStudentTransportCustomer;
        dataCheckIndication: Record ACKStudentTransportIndication;
    begin
        /*
        dataCheckCustomer.CustomerId := Rec.CustomerId;
        dataCheckIndication.IndicationId := Rec.Indication;
        TestField(Rec.CustomerId);
        TestField(Rec.Indication);

        if not dataCheckCustomer.Find('=') then
            Error('Error on insert CustmerId not found in the Customer table');
        if not dataCheckIndication.Find('=') then
            Error('Error on insert IndictionId not found in the Indication table');
    */

    end;
}
