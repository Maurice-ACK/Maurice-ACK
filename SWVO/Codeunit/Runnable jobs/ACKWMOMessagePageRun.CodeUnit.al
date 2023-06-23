/// <summary>
/// Codeunit ACKWMOMessagePageRun.
/// </summary>
codeunit 50012 ACKWMOMessagePageRun
{
    TableNo = ACKWMOHeader;

    trigger OnRun()
    var
        ACKHelper: codeunit ACKHelper;
        ACKWMOIProcessor: Interface ACKWMOIProcessor;
    begin
        ACKWMOIProcessor := Rec.BerichtCode;
        ACKWMOIProcessor.Init(Rec);
        ACKWMOIProcessor.Process();
    end;
}
