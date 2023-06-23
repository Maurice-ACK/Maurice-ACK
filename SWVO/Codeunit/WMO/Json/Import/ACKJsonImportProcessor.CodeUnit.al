/// <summary>
/// Codeunit ACKJsonImportProcessor (ID 50001).
/// </summary>
codeunit 50002 ACKJsonImportProcessor
{
    var
        ACKHelper: Codeunit ACKHelper;

    /// <summary>
    /// TryValidateStuf.
    /// </summary>
    /// <param name="ACKStUF">Record ACKStUF.</param>
    [TryFunction]
    procedure TryValidateStuf(ACKStUF: Record ACKStUF)
    var
        MessageJsonObject: JsonObject;
        InvalidCrossRefErr: Label 'Referentienummer voldoet niet aan het juiste formaat', Comment = '%1 = CrossReferentienummer';
    begin
        if not ACKStUF.TryGetJsonObject(MessageJsonObject) then
            Error(GetLastErrorText());

        if not ACKStUF.CrossReferenceExists() then begin
            CreateStUFFoutbericht(ACKStUF, ACKStUFBerichtCode::Fo01, 'CC04', StrSubstNo(InvalidCrossRefErr, ACKStUF.CrossRefnummer), 1);
            Error(InvalidCrossRefErr);
        end;
    end;

    /// <summary>
    /// Process.
    /// </summary>
    /// <param name="ACKStUF">Record ACKStUF.</param>
    procedure Process(ACKStUF: Record ACKStUF)
    var
        ACKJsonImport: Codeunit ACKJsonImport;
        EmptyRecordErr: Label 'Record is empty.';
        AlreadyProcessedErr: Label 'Message: %1 is already processed', Comment = '%1 = Referentienummer';
    begin
        if ACKStUF.IsEmpty then
            Error(EmptyRecordErr);

        if ACKStUF.Status <> ACKJobStatus::Ready then
            Error(AlreadyProcessedErr, ACKStUF.Referentienummer);

        if not TryValidateStuf(ACKStUF) then begin
            ACKHelper.AddWmoEventLog(ACKStUF, Severity::Error, CopyStr(GetLastErrorText(), 1, 255));
            ACKStUF.Status := ACKJobStatus::Error;
            ACKStUF.Modify(true);
            exit;
        end;

        ACKJsonImport.Init(ACKStUF);
        if ACKJsonImport.Run() then
            ACKStUF.Status := ACKJobStatus::Completed
        else begin
            ACKHelper.AddWmoEventLog(ACKStUF, Severity::Error, CopyStr(GetLastErrorText(), 1, 255));
            ACKStUF.Status := ACKJobStatus::Error;
        end;

        ACKStUF.Modify(true);
    end;

    /// <summary>
    /// CreateStUFFoutbericht.
    /// </summary>
    /// <param name="StUF">Record ACKStUF.</param>
    /// <param name="BerichtCode">Enum ACKStUFBerichtCode.</param>
    /// <param name="Foutcode">Text[10].</param>
    /// <param name="Omschrijving">Text[250].</param>
    /// <param name="Plek">Option client,server.</param>
    procedure CreateStUFFoutbericht(StUF: Record ACKStUF; BerichtCode: Enum ACKStUFBerichtCode; Foutcode: Text[10];
                                                                           Omschrijving: Text[250];
                                                                           Plek: Option client,server)
    var
        StUfNew: Record ACKStUF;
    begin
        // StUfNew.Init();
        // StUfNew.SetDefaultFields(ACKStUFBerichtCode::Fo03);

        // //Zender
        // StUF.ZenderOrganisatie := StUF.OntvangerOrganisatie;

        // //Ontvanger
        // StUfNew.OntvangerOrganisatie := StUF.ZenderOrganisatie;
        // StUfNew.OntvangerApplicatie := StUF.ZenderApplicatie;

        // //Foutbody
        // StUfNew.Foutcode := Foutcode;
        // StUfNew.Plek := Plek;
        // StUfNew.Omschrijving := Omschrijving;

        // StUfNew.Insert(true);
    end;
}