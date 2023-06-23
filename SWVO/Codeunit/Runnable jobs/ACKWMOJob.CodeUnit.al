/// <summary>
/// Codeunit ACKWMOJob.
/// </summary>
codeunit 50011 ACKWMOJob
{
    trigger OnRun()
    var
        WMOHeader: Record ACKWMOHeader;
        WMOIProcessor: Interface ACKWMOIProcessor;
    begin
        WMOHeader.SetCurrentKey(SystemCreatedAt);
        WMOHeader.SetRange(Status, ACKWMOHeaderStatus::New);
        WMOHeader.SetRange(BerichtCode, ACKVektisCode::wmo301, ACKVektisCode::wmo320);
        WMOHeader.SetAscending(SystemCreatedAt, true);

        if WMOHeader.FindSet(true) then
            repeat
                WMOIProcessor := WMOHeader.BerichtCode;
                WMOIProcessor.Init(WMOHeader);
                WMOIProcessor.Process();
            until WMOHeader.Next() = 0;
    end;
}
