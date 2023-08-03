codeunit 50034 ACKStudentTransportProcessData
{
    trigger OnRun()
    begin
        STTCustomerToClient();
    end;


    procedure STTCustomerToClient()
    var
        Customers: Record ACKStudentTransportCustomer;
        Client: Record ACKClient;
        ClientSearch: Record ACKClient;
        ClientDataLink: Record ACKSTTClientData;
        error: Record ACKStudentTransportInsertError;


    begin
        //Message('Customer to process' + Format(Customers.Count()));
        Customers.SetFilter(processed, '=%1', false);

        if Customers.FindSet() then
            repeat
                Customers.processed := true;
                Customers.Modify();

                ClientSearch.SetFilter(SSN, '=%1', Customers.SSN);

                if ClientSearch.IsEmpty then begin
                    Client."First Name" := Customers.FirstName;
                    Client.Surname := Customers.Lastname;
                    Client.Initials := Customers.Initials;
                    Client.SSN := Customers.SSN;
                    client.Birthdate := Customers.DateOfBirth;

                    if Customers.gender = 'F' then
                        client.Gender := ACKWMOGeslacht::Female;
                    if Customers.gender = 'M' then
                        client.Gender := ACKWMOGeslacht::Male;


                    if not client.Insert(true) then
                        Error('📃');


                end
                else begin
                    ClientSearch.FindFirst();
                    Client.ClientNo := ClientSearch.ClientNo;

                end;


                addAddressToClient(Client.ClientNo, Customers);
                ClientDataLink.ClientNo := Client.ClientNo;
                // ClientDataLink.CustomerID := Customers.CustomerId;
                // ClientDataLink.custRecordId := Customers.custRecordId;
                ClientDataLink.Insert();

                System.Clear(Client);
            until (Customers.Next() = 0);




    end;


    procedure addAddressToClient(clientNo: Code[20]; customer: Record ACKStudentTransportCustomer)
    var
        addressRec: Record ACKClientAddress;

    begin



        addressRec.ClientNo := clientNo;
        addressRec.Purpose := ACKWMOAdresSoort::StudentTransport;
        addressRec.PostCode := customer.ZipCode;
        addressRec.HouseNumber := TextToInt(customer.StreetNr);
        addressRec.HouseNumberAddition := customer.StreetNrAddition;
        addressRec.EmailAddress := customer.EmailAddress;
        addressRec.Street := customer.StreetName;
        addressRec.ValidFrom := Today;
        addressRec.MunicipalityNo := customer.municipalityNo;
        addressRec.Phone := customer.telephoneNumber;
        addressRec.MobilePhone := customer.mobileNumber;

        if addressRec.InsertOrUpdate() then
           ;

        if addressRec.Insert() then
            ;
    end;




    procedure onRecordRemove(clientN: Code[20])
    var
        address: record ACKClientAddress;

    begin
        address.SetFilter(ClientNo, '=%1', clientN);
        address.SetFilter(Purpose, '=%1', ACKWMOAdresSoort::StudentTransport);
        address.setfilter(ValidTo, '<=%1', 0D);

        if address.FindSet() then
            repeat
                address.ValidTo := Today;
                address.Modify();

            until address.Next() = 0



    end;

    procedure TextToInt(input: Text): Integer
    var
        int: Integer;
    begin
        Evaluate(int, input);
        exit(int);

    end;


    procedure deleteRecords(tableIndex: Integer; fieldName: Text; recKey: Code[20])
    var
        recRef: RecordRef;
        MyFieldRef: FieldRef;
        i: Integer;
        fieldIndex: Integer;
    begin

        recRef.Open(tableIndex);
        for i := 1 to recRef.FieldCount() do begin
            if recRef.FieldIndex(i).Name = fieldName then begin
                fieldIndex := i;
                break;
            end;
        end;


        MyFieldRef := recRef.Field(fieldIndex);
        MyFieldRef.Value := recKey;
        if recRef.Find('=') then begin
            recRef.DeleteAll(true);
        end;

        Message(format(fieldIndex));


    end;




}
