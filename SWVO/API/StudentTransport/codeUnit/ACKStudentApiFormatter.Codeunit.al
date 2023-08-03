codeunit 50001 ACKStudentApiFormatter
{
    procedure yearToText(beginY: Date; endY: Date): text;
    var

        month: Integer;
        output: text;
        year1: Integer;
        year2: Integer;

    begin

        if (beginY <= 0D) and (endY <= 0D) then
            exit('');

        month := System.Date2DMY(beginY, 2);
        year1 := System.Date2DMY(beginY, 3);

        if (month < 8) then
            year1 -= 1;

        output := Format(year1);

        month := System.Date2DMY(endY, 2);
        year2 := System.Date2DMY(endY, 3);

        if (month < 8) then
            year2 -= 1;
        if year1 = year2 then
            year2 += 1;

        output += '-' + Format(year2);

        exit(output);

    end;

    procedure getStartEndYear(beginY: Date; endY: Date; var year1: Integer; var year2: Integer): Boolean;
    var

        month: Integer;
        output: text;


    begin

        if (beginY <= 0D) and (endY <= 0D) then
            exit(false);

        month := System.Date2DMY(beginY, 2);
        year1 := System.Date2DMY(beginY, 3);

        if (month < 8) then
            year1 -= 1;

        output := Format(year1);

        month := System.Date2DMY(endY, 2);
        year2 := System.Date2DMY(endY, 3);

        if (month < 8) then
            year2 -= 1;
        if year1 = year2 then
            year2 += 1;

        output += '-' + Format(year2);

        exit(true);

    end;


    procedure formatter(jsonInput: JsonArray)

    token: JsonToken;

    begin

        foreach token in jsonInput do
            message('');



    end;

    procedure insertData(jsonInput: JsonObject)



    begin




    end;

    procedure getTable(tableName: Text): Integer
    begin
        case tableName of
            'Client':
                exit(Database::ACKClient);
            'Address':
                exit(Database::ACKClientAddress);
            'Schedule':
                exit(Database::ACKStudentTransportSchedule);
            'Route':
                exit(Database::ACKStudentTransportRoute);
            'RouteType':
                exit(Database::ACKStudentTransportRouteType);
            'NodeType':
                exit(Database::ACKStudentTransportNodeType);
            'CheckInNode':
                exit(Database::ACKStudentTransportNode);
            'CheckOutNode':
                exit(Database::ACKStudentTransportNode);
            'Node':
                exit(Database::ACKStudentTransportNode);
            'StudentTransportCustomer':
                exit(Database::ACKStudentTransportCustomer);
            'Indication':
                exit(Database::ACKStudentTransportIndication);
            'CustomerIndication':
                exit(Database::ACKStudentTransportCustIndicat);
            'Card':
                exit(Database::ACKStudentTransportCard);
            else
                Error(tableName + ' Should not be used in this context');

        end;





    end;

    procedure removeCurrentCustomer(id: Guid)
    var
        tableId: Integer;
        keys: Text;
        recRef: RecordRef;
        fdRef: FieldRef;


    begin
        fillList();
        foreach keys in tableIdList.Keys do begin

            recRef.Open(tableIdList.Get(keys));
            fdRef := recRef.Field(1);
            fdRef.SetFilter('=%1', id);

            if recRef.FindSet() then
                recRef.DeleteAll();

            recRef.Close();
        end;


    end;




    procedure nestedJsonObject2Table(input: JsonObject; tableId: integer; recKey: Guid): Code[20]

    var
        keys: List of [Text];
        Ky: Text;
        token: Jsontoken;

        jTokenArr: JsonToken;
        JsonObj: JsonObject;
        jArray: JsonArray;

        it: Integer;
        i: Integer;
        itEnd: Integer;
        tableNo: Integer;
        recRef: RecordRef;
        recOpen: Boolean;

        FR: FieldRef;
        FieldHash: Dictionary of [Text, Integer];
        fieldNo: Integer;
        jValue: JsonValue;

        primKeyIn: Code[40];
        primKeyOut: Code[40];


        JsonTools: Codeunit ACKJsonTools;


    begin
        primKeyOut := '';
        tableNo := 0;
        fillList();


        //open rec 
        if not (tableId = 0) then begin
            recRef.Open(tableId);
            recOpen := true;

            for i := 1 to recRef.FieldCount() do begin
                FR := recRef.FieldIndex(i);
                FieldHash.Add(FR.Name, FR.Number);
            end;
            recRef.Init();





        end;






        keys := input.Keys();

        foreach Ky in keys do begin
            input.Get(ky, token);


            //fill rec
            if (token.IsValue) and (tableId > 0) then begin
                if (FieldHash.Get(ky, fieldNo)) then begin
                    jValue := token.AsValue();
                    if not (jValue.AsText() = '') then begin
                        FR := recRef.Field(fieldNo);
                        if (FR.Type = FieldType::Date) then
                            jValue.SetValue(jValue.AsText().Split('T').Get(1));


                        JsonTools.AssignValueToFieldRef(FR, jValue);
                        recRef.Field(fieldNo).Validate();

                        if tablePrimKeyList.Contains(Ky) then
                            primKeyOut := jValue.AsCode();





                    end;
                end;

            end


            else
                if token.IsArray then begin
                    jArray := token.AsArray();
                    itEnd := jArray.Count();

#pragma warning disable AA0005
                    if (tableIdList.Get(ky, tableNo)) then begin
                        for it := 0 to (itEnd - 1) do begin
                            jArray.Get(it, jTokenArr);
                            primKeyIn := nestedJsonObject2Table(jTokenArr.AsObject(), tableNo, recKey);
                            if primKeyIn = '-100000' then
                                exit(primKeyIn);


                            if (not (primKeyIn = '')) and not (tableId = 0) then begin



                                if FieldHash.Get(ky, fieldNo) then begin
                                    FR := recRef.Field(fieldNo);
                                    FR.value := primKeyIn;
                                    FR.Validate();
                                end;
                            end
                            else
                                primKeyOut := primKeyIn;

                        end;

                    end;
#pragma warning restore AA0005
                end
                else
                    if token.IsObject then begin
                        if (tableIdList.Get(ky, tableNo)) then
                            ;

                        primKeyIn := nestedJsonObject2Table(token.AsObject(), tableNo, recKey);

                        if not (primKeyIn = '') then begin

                            if primKeyIn = '-100000' then begin
                                exit(primKeyIn);

                            end;

                            if FieldHash.Get(ky, fieldNo) then begin
                                FR := recRef.Field(fieldNo);
                                FR.value := primKeyIn;
                                FR.Validate();
                            end;


                        end;

                    end;




        end;



        if (recOpen = true) then begin

            FR := recRef.Field(1);
            FR.Value := recKey;
            recRef.Field(1).Validate();



            if not recRef.Find('=') then
                if not recRef.Insert(false) then
                    primKeyOut := '-100000';






            if tableId = Database::ACKStudentTransportCustomer then
                if TaskScheduler.CanCreateTask() then
                    TaskScheduler.CreateTask(Codeunit::ACKStudentTransportProcessData, 0, true, CompanyName, 0DT, recRef.RecordId);


            recRef.Close();

        end;
        exit(primKeyOut);

    end;

    procedure insertDataClient(input: JsonArray)
    var
        token: JsonToken;
        client: Record ACKClient;
        Address: Record ACKClientAddress;
        object: JsonObject;
    begin



        object.Get('test', token);
        Address.EmailAddress := token.AsValue().AsText();


    end;


    var
        // these lists are use to determine the which table's needs which data 
        tableIdList: Dictionary of [text, Integer];
        tablePrimKeyList: List of [text];


    procedure fillList()
    begin
        if (tableIdList.Count < 2) then begin
            tableIdList.Add('', Database::ACKStudentTransportCustomer);
            tableIdList.Add('schedule', Database::ACKStudentTransportSchedule);
            tableIdList.Add('route', Database::ACKStudentTransportRoute);
            tableIdList.Add('checkInNode', Database::ACKStudentTransportNode);
            tableIdList.Add('checkOutNode', Database::ACKStudentTransportNode);
            tableIdList.Add('routeType', Database::ACKStudentTransportRouteType);
            tableIdList.Add('nodeType', Database::ACKStudentTransportNodeType);
            tableIdList.Add('customerIndication', Database::ACKStudentTransportCustIndicat);
            tableIdList.Add('indication', Database::ACKStudentTransportIndication);
            tableIdList.Add('card', Database::ACKStudentTransportCard);
            tableIdList.Add('customerCLient', Database::ACKSTTClientData);

        end;
        if (tablePrimKeyList.Count < 1) then begin
            tablePrimKeyList.Add('scheduleId');
            tablePrimKeyList.Add('nodeId');
            tablePrimKeyList.Add('routeTypeId');
            tablePrimKeyList.Add('nodeTypeId');
            tablePrimKeyList.Add('indicationId');



        end;

    end;

}