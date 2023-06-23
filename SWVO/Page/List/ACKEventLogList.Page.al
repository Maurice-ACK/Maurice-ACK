/// <summary>
/// Page ACKEventLogList (ID 50080).
/// </summary>
page 50097 ACKEventLogList
{
    ApplicationArea = All;
    Caption = 'Event logs';
    PageType = List;
    SourceTable = ACKEventLog;
    UsageCategory = Lists;
    Editable = false;
    DeleteAllowed = true;
    SourceTableView = sorting(ID) order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TableName; Rec.TableName)
                {
                }
                field(RefSystemID; Rec.RefSystemID)
                {
                    trigger OnDrillDown()
                    var
                        WMOHeader: Record ACKWMOHeader;
                        StUF: Record ACKStUF;
                    begin
                        case Rec.RefTableId of
                            Database::ACKWMOHeader:
                                begin
                                    WMOHeader.SetFilter(SystemId, Rec.RefSystemID);
                                    Page.Run(Page::ACKWMOHeaderList, WMOHeader);
                                end;
                            Database::ACKStUF:
                                begin
                                    StUF.SetFilter(SystemId, Rec.RefSystemID);
                                    Page.Run(Page::ACKStUFList, StUF);
                                end;
                        end;
                    end;
                }
                field(Severity; Rec.Severity)
                {
                }
                field(Message; Rec.Message)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
            }
        }
    }
}
