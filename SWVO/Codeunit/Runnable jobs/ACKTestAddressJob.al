/// <summary>
/// Codeunit ACKTestAddressJob.
/// </summary>
codeunit 50020 ACKTestAddressJob
{
    trigger OnRun()
    var
        ACKWMOContact: record ACKWMOContact;
    begin
        if not ACKClient.FindFirst() then
            Error('No clients to test with.')
        else
            Message('Testing with client: %1', ACKClient.ClientNo);

        ACKWMOContact := MockContact(ACKWMOAdresSoort::BRP, 'AAAA 11', 1, 20220101D, 0D);
        ACKWMOContact := MockContact(ACKWMOAdresSoort::BRP, 'AAAA 11', 1, 20220101D, 0D);

    end;

    local procedure MockContact(ACKWMOAdresSoort: Enum ACKWMOAdresSoort; Postcode: Text[8]; HouseNumber: Integer; FromDate: Date; ToDate: Date) ACKWMOContact: record ACKWMOContact
    begin
        ACKWMOContact.Init();
        ACKWMOContact.RefID := ACKClient.ClientNo;
        ACKWMOContact.Soort := ACKWMOAdresSoort;
        ACKWMOContact.Postcode := Postcode;
        ACKWMOContact.Huisnummer := HouseNumber;
        ACKWMOContact.Plaatsnaam := 'Plaats';
        ACKWMOContact.Straatnaam := 'Straat';
    end;

    var
        ACKClient: record ACKClient;
}
