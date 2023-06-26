/// <summary>
/// Page ACKJSONMessageList
/// </summary>
page 50100 ACKJSONMessageList
{
    ApplicationArea = All;
    Caption = 'JSON messages';
    PageType = List;
    SourceTable = ACKJSONMessage;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(MessageCode; Rec.MessageCode)
                {
                }
                field(VektisCode; Rec.VektisCode)
                {
                }
                field(Versie; Rec.Versie)
                {
                }
                field(Subversie; Rec.Subversie)
                {
                }
                field(Active; Rec.Active)
                {
                }
            }
        }
    }
    actions
    {
        area(Promoted)
        {
            actionref("Mapping Promoted"; Mapping)
            {
            }
            actionref("Copy Promoted"; Copy)
            {
            }
        }
        area(Navigation)
        {
            action(Mapping)
            {
                Caption = 'Mapping', Locked = true;
                Image = BOM;
                RunObject = page ACKJSONMapList;
                RunPageLink = MessageCode = field(MessageCode);
                RunPageView = where(ParentNo = const(''));
            }
        }
        area(Processing)
        {
            action(Copy)
            {
                Caption = 'Copy';
                Image = CopyBOM;
                Enabled = CopyEnabled;

                trigger OnAction()
                var
                    ACKJSONMap: Codeunit ACKJSONMap;
                begin
                    ACKJSONMap.Copy(Rec);
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CopyEnabled := not IsNullGuid(Rec.SystemId);
    end;

    var
        CopyEnabled: Boolean;
}