/// <summary>
/// Codeunit ACKDownloadWMOFile
/// </summary>
codeunit 50041 ACKDownloadWMOFile
{
    var
        ACKStUF: record ACKStUF;
        XMLFileNameFormatLbl: Label '%1.xml', Locked = true;
        JSONFileNameFormatLbl: Label '%1.json', Locked = true;

    /// <summary>
    /// DownloadXML.
    /// /// </summary>
    /// <param name="Referentienummer">Guid.</param>
    procedure DownloadXML(Referentienummer: Guid)
    var
        WMOHeader: Record ACKWMOHeader;
        ACKJsonExport: Codeunit ACKJsonExport;
        SWVOAPIHttpClient: Codeunit ACKSWVOAPHttpClient;
        Base64Convert: Codeunit "Base64 Convert";
        XMLText: Text;
        JsonText: Text;
    begin
        WMOHeader.SetRange(Referentienummer, Referentienummer);
        if not WMOHeader.FindFirst() then
            Message('Not found');

        ACKJsonExport.Export(WMOHeader).WriteTo(JsonText);
        // Message(JsonText);
        XMLText := SWVOAPIHttpClient.GetXMLFromJson(Base64Convert.ToBase64(JsonText, TextEncoding::UTF8));

        DownloadXML(Referentienummer, XMLText);
    end;

    /// <summary>
    /// DownloadOriginalXML.
    /// </summary>
    /// <param name="Referentienummer">Guid.</param>
    procedure DownloadOriginalXML(Referentienummer: Guid)
    var
        XMLText: Text;
    begin
        ACKStUF.Get(ReferentieNummer);
        XMLText := ACKStUF.GetXML();

        DownloadXML(Referentienummer, XMLText);
    end;

    local procedure DownloadXML(Referentienummer: Guid; XMLText: Text)
    var
        TempBlob: codeunit "Temp Blob";
        Instream: InStream;
        OutStream: OutStream;
        XMLDoc: XMLDocument;
        FileName: Text;
        root: XmlElement;
        XMLParseErr: Label 'Failed to parse XML';
    begin
        if not XMLDocument.ReadFrom(XMLText, XMLDoc) then
            Error(XMLParseErr);

        XMLDoc.GetRoot(root);
        FileName := StrSubstNo(XMLFileNameFormatLbl, Referentienummer);

        //Download
        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream);
        XMLDoc.WriteTo(OutStream);
        TempBlob.CreateInStream(Instream);
        DownloadFromStream(Instream, '', '', '', FileName);
    end;


    /// <summary>
    /// DownloadJSON.
    /// </summary>
    /// <param name="Referentienummer">Guid.</param>
    procedure DownloadJSON(Referentienummer: Guid)
    var
        WMOHeader: Record ACKWMOHeader;
        ACKJsonExport: Codeunit ACKJsonExport;
        JsonObject: JsonObject;
    begin
        WMOHeader.Get(Referentienummer);
        JsonObject := ACKJsonExport.Export(WMOHeader);

        DownloadJSON(Referentienummer, JsonObject);
    end;

    /// <summary>
    /// DownloadOriginalJSON.
    /// </summary>
    /// <param name="Referentienummer">Guid.</param>
    procedure DownloadOriginalJSON(Referentienummer: Guid)
    var
        JsonObject: JsonObject;
    begin
        ACKStUF.Get(ReferentieNummer);
        ACKStUF.TryGetJsonObject(JsonObject);
        DownloadJSON(Referentienummer, JsonObject);
    end;

    /// <summary>
    /// DownloadJSON.
    /// </summary>
    /// <param name="Referentienummer">Guid.</param>
    /// <param name="JsonObject">JsonObject.</param>
    procedure DownloadJSON(Referentienummer: Guid; JsonObject: JsonObject)
    var
        TempBlob: codeunit "Temp Blob";
        Instream: InStream;
        OutStream: OutStream;
        FileName: Text;
    begin
        FileName := StrSubstNo(JSONFileNameFormatLbl, Referentienummer);

        //Download
        Clear(TempBlob);
        TempBlob.CreateOutStream(OutStream);
        JsonObject.WriteTo(OutStream);
        TempBlob.CreateInStream(Instream);
        DownloadFromStream(Instream, '', '', '', FileName);
    end;
}
