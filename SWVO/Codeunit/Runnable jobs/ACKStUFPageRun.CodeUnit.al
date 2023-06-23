codeunit 50009 ACKStUFPageRun
{
    TableNo = ACKStUF;

    var
        ACKJsonImport: Codeunit ACKJsonImport;

    trigger OnRun()
    begin
        ValidateStatus(Rec);
        ProcessRecord(Rec);
    end;

    procedure ValidateStatus(var ACKStUF: Record ACKStUF)
    begin
        if ACKStUF.Status <> ACKJobStatus::Ready then
            Error('Status must be %1', Format(ACKJobStatus::Ready));
    end;

    procedure ProcessRecord(var ACKStUF: Record ACKStUF)
    begin
        ACKJsonImport.Init(ACKStUF);
        if ACKJsonImport.Run() then
            ACKStUF.Status := ACKJobStatus::Completed
        else
            ACKStUF.Status := ACKJobStatus::Error;
        ACKStUF.Modify(true);
    end;

    procedure ProcessAllNew()
    var
        ACKStUF: Record ACKStUF;
    begin
        ACKStUF.SetRange(Status, ACKJobStatus::Ready);

        if not ACKStUF.FindSet() then
            exit;

        repeat
            Clear(ACKJsonImport);
            ValidateStatus(ACKStUF);
            ProcessRecord(ACKStUF);
            Commit();
        until ACKStUF.Next() = 0;
    end;
}
