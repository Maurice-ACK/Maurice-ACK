/// <summary>
/// Codeunit ACKJSONMap (ID 50038).
/// </summary>
codeunit 50036 ACKJSONMap
{
    /// <summary>
    /// Copy.
    /// </summary>
    /// <param name="ACKJSONMessageFrom">Record ACKJSONMessage.</param>
    /// <returns>Return variable ACKJSONMessageNew of type Record ACKJSONMessage.</returns>
    procedure Copy(ACKJSONMessageFrom: Record ACKJSONMessage) ACKJSONMessageNew: Record ACKJSONMessage
    var
        ACKJSONMessageCopy: Page ACKJSONMessageCopy;
        ResponseAction: Action;
        // ParentIDDictionary: Dictionary of [Integer, Integer];
        CreatedLbl: Label '%1 has been created.', Comment = '%1 = New message Id', Locked = true;
    begin
        ACKJSONMessageCopy.Setup(ACKJSONMessageFrom);
        ResponseAction := ACKJSONMessageCopy.RunModal();
        case ResponseAction of
            Action::OK:
                begin
                    ACKJSONMessageNew.Init();
                    ACKJSONMessageNew.MessageCode := ACKJSONMessageCopy.GetMessageCode();
                    ACKJSONMessageNew.Active := ACKJSONMessageCopy.GetActive();
                    ACKJSONMessageNew.VektisCode := ACKJSONMessageCopy.GetVektisCode();
                    ACKJSONMessageNew.Versie := ACKJSONMessageCopy.GetVersie();
                    ACKJSONMessageNew.Subversie := ACKJSONMessageCopy.GetSubVersie();
                    ACKJSONMessageNew.Insert(true);

                    CopyJSONMap(ACKJSONMessageFrom.MessageCode, '', ACKJSONMessageNew.MessageCode, '');

                    Message(CreatedLbl, ACKJSONMessageNew.MessageCode);
                end;
        end;
    end;

    local procedure CopyJSONMap(MessageIDFrom: Code[20]; NoFrom: Code[20]; MessageIDNew: Code[20]; NoParentNew: Code[20])
    var
        ACKJSONMapFrom, ACKJSONMapNew : Record ACKJSONMap;
    begin
        ACKJSONMapFrom.SetRange(MessageCode, MessageIDFrom);
        ACKJSONMapFrom.SetRange(ParentNo, NoFrom);
        if ACKJSONMapFrom.FindSet(true) then
            repeat
                Clear(ACKJSONMapNew);
                ACKJSONMapNew.Init();
                ACKJSONMapNew.TransferFields(ACKJSONMapFrom, false);
                ACKJSONMapNew.MessageCode := MessageIDNew;
                ACKJSONMapNew.ParentNo := NoParentNew;
                ACKJSONMapNew.Insert(true);

                CopyJSONMap(ACKJSONMapFrom, ACKJSONMapNew);
            until ACKJSONMapFrom.Next() = 0;
    end;

    local procedure CopyJSONMap(FromParent: Record ACKJSONMap; NewParent: Record ACKJSONMap)
    begin
        CopyJSONMap(FromParent.MessageCode, FromParent.No, NewParent.MessageCode, NewParent.No);
    end;
}