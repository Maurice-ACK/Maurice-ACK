/// <summary>
/// Codeunit ACKStudentApi
/// </summary>
codeunit 50005 ACKStudentApi
{


    /// <summary>
    /// Ping.wq
    /// </summary>
    /// <returns>Return value of type Text.</returns>


    /// <summary>
    /// ping2.
    /// </summary>
    /// <param name="inputJson">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure insertData(inputJson: Text; tableDest: Text): Text
    var
        formatMe: Codeunit ACKStudentApiFormatter;
        ACKJsonTools: Codeunit ACKJsonTools;
        input: JsonArray;
        token: JsonToken;
        object: JsonObject;
        tableRef: Integer;

        Ref: RecordRef;

    begin
        input.ReadFrom(inputJson);
        input.Get(0, token);

        tableRef := formatMe.getTable(tableDest);




        foreach token in input do begin
            object := token.AsObject();




            Ref.Open(tableRef);
            Ref := ACKJsonTools.Json2Rec(object, tableRef);
            if not Ref.Find('=') then
                Ref.Insert(true);



            Ref.Close();
        end;


        token.WriteTo(inputJson);





    end;




    procedure insertData2(inputJson: Text): Text
    var

        keyTokens: List of [Text];

        i: Integer;
        token: JsonToken;
        jsonString: JsonObject;
        temp: Text;
        reformat: Codeunit ACKStudentApiFormatter;
        returnValue: code[20];
        custId: guid;
        ostream: OutStream;
        errorHandling: Record ACKStudentTransportInsertError;
        customer: Record ACKStudentTransportCustomer;

    begin

        jsonString.ReadFrom(inputJson);
        keyTokens := jsonString.Keys();
        custId := CreateGuid();



        jsonString.get('customerId', token);
        customer.SetFilter(customerId, '=%1', token.AsValue().AsText());
        if customer.FindFirst() then
            reformat.removeCurrentCustomer(customer.custRecordId);



        returnValue := reformat.nestedJsonObject2Table(jsonString, Database::ACKStudentTransportCustomer, custId);
        if returnValue = '-100000' then begin

            errorHandling.Init();
            errorHandling.custId := custId;
            errorHandling.Json.CreateOutStream(ostream);
            ostream.Write(inputJson);
            errorHandling.Insert();
            Error('Error has occurred')
        end;

        exit('No error occurred')










    end;




}
