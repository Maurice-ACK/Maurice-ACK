codeunit 50043 VerifyAddressJob
{
    trigger OnRun()
    var
        Address: Record ACKClientAddress;
        MunicipalityNoRec: Record ACKMunicipality;
        BagApi: Codeunit ACKSWVOAPHttpClient;
        DTime: DateTime;
    begin
        DTime := System.CurrentDateTime();

        //every record 1 hour back
        Dtime := DTime - ((1000 * 60) * 60);



        Address.SetFilter(SystemModifiedAt, '>=%1', Dtime);
        Address.SetRange(AddressVerify, false);
        if Address.FindSet() then begin
            Message(format(Address.Count));
            repeat
                //check if address exist in bag api
                if BagApi.VerifyAddres(Address) then begin
                    Address.AddressVerify := true;

                    Address.MunicipalityNo := MunicipalityNoRec.GetMunicipalityNo(Address.PostCode);
                    Message('True');
                    Message(Address.MunicipalityNo);

                    Address.Modify();
                end;

            until Address.NEXT() <= 0;
        end;

        Message(format(DTime));

    end;

}