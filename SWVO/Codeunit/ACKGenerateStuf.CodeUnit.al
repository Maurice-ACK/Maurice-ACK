/// <summary>
/// Codeunit ACKGenerateStuf (ID ACKStuf).
/// </summary>
codeunit 50027 ACKGenerateStuf
{
    TableNo = ACKWMOHeader;

    var
        WMOHeader: Record ACKWMOHeader;
        StUF: Record ACKStUF;
        SWVOGeneralSetup: Record ACKSWVOGeneralSetup;
        ACKJsonExport: Codeunit ACKJsonExport;

    trigger OnRun()
    var
        EmptyHeaderErr: label '%1 must not be empty.', Comment = '%1 = ACKWMOHeader';
    begin
        WMOHeader := Rec;

        //Header must exist
        if WMOHeader.IsEmpty() then
            Error(EmptyHeaderErr, WMOHeader.TableCaption());

        SWVOGeneralSetup.Get();

        Create();
    end;

    local procedure Create()
    var
        FromStuf: Record ACKStUF;
        WMOHeaderHeen: Record ACKWMOHeader;
        Customer: Record Customer;
        StUFBerichtCode: Enum ACKStUFBerichtCode;
    begin
        StUF.Init();
        StUF.SetDefaultFields();

        if WMOHeader.IsRetour() and (WMOHeader.BerichtCode <> ACKVektisCode::wmo325) then begin
            StUFBerichtCode := ACKStUFBerichtCode::Du01;

            //Get StUF heenbericht and set crossRefnummer
            WMOHeader.GetToHeader(WMOHeaderHeen, true);
            FromStuf.Get(WMOHeaderHeen.Referentienummer);

            StUF.CrossRefnummer := FromStuf.Referentienummer;
        end
        else
            StUFBerichtCode := ACKStUFBerichtCode::Di01;

        StUF.Referentienummer := WMOHeader.Referentienummer;
        StUF.Berichtcode := StUFBerichtCode;
        StUF.Functie := WMOHeader.BerichtCode;

        if WMOHeader.Relation(Ontvanger) = Database::Customer then
            Customer.Get(WMOHeader.Ontvanger)
        else
            if WMOHeader.Relation(Afzender) = Database::Customer then
                Customer.Get(WMOHeader.Afzender);

        case WMOHeader.BerichtCode of
            ACKVektisCode::wmo301,
            ACKVektisCode::wmo306,
            ACKVektisCode::wmo308,
            ACKVektisCode::wmo318,
            ACKVektisCode::wmo319,
            ACKVektisCode::wmo325:
                begin
                    //Sender is municipality
                    StUF.ZenderOrganisatie := WMOHeader.Afzender;
                    StUF.ZenderApplicatie := Customer.StUFApplication;

                    //receiver is healthcare provider
                    StUF.OntvangerOrganisatie := WMOHeader.Ontvanger;
                    StUF.OntvangerApplicatie := SWVOGeneralSetup.StUFReceiverApplicationHC;
                end;
            ACKVektisCode::wmo302,
            ACKVektisCode::wmo305,
            ACKVektisCode::wmo307,
            ACKVektisCode::wmo317,
            ACKVektisCode::wmo320,
            ACKVektisCode::wmo323:
                begin
                    //Sender is healthcare provider
                    StUF.ZenderOrganisatie := WMOHeader.Ontvanger;
                    StUF.ZenderApplicatie := SWVOGeneralSetup.StUFSenderApplicationDefault;

                    //Receiver is municipality
                    StUF.OntvangerOrganisatie := WMOHeader.Afzender;
                    StUF.OntvangerApplicatie := Customer.StUFApplication;
                end;
            else
                Error('Berichtcode not supported.');
        end;

        StUF.Status := ACKJobStatus::Completed;

        CreateJsonAndXml();

        StUF.Insert();
    end;

    [TryFunction]
    local procedure CreateJsonAndXml()
    var
        SWVOAPIHttpClient: Codeunit ACKSWVOAPHttpClient;
        Base64Convert: Codeunit "Base64 Convert";
        outstream: OutStream;
        JsonObject: JsonObject;
        JsonText, XMl : Text;
    begin
        //Create the json object from data
        JsonObject := ACKJsonExport.Export(WMOHeader);

        //Save the json text in the blob field
        StUF.BerichtJson.CreateOutStream(outstream, TextEncoding::UTF8);
        JsonObject.WriteTo(outstream);

        //Create the xml text from the json text
        JsonObject.WriteTo(JsonText);
        XMl := SWVOAPIHttpClient.GetXMLFromJson(Base64Convert.ToBase64(JsonText, TextEncoding::UTF8));

        //Save the xml text in the blob field
        StUF.BerichtXml.CreateOutStream(outstream, TextEncoding::UTF8);
        outstream.WriteText(XML);
    end;
}