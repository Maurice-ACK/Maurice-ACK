/// <summary>
/// Codeunit ACKStUFJob.
/// </summary>
codeunit 50042 ACKStUFJob
{
    // TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ACKStUF: Record ACKStUF;
        ACKJsonImportProcessor: Codeunit ACKJsonImportProcessor;
    begin
        ACKStUF.SetCurrentKey(SystemCreatedAt);
        ACKStUF.SetRange(Status, ACKJobStatus::Ready);
        ACKStUF.SetAscending(SystemCreatedAt, true);

        if ACKStUF.FindSet(true) then
            repeat
                ACKJsonImportProcessor.Process(ACKStUF);
                Commit();
            until ACKStUF.Next() = 0;
    end;
}
