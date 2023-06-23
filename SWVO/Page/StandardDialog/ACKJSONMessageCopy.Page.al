/// <summary>
/// Page ACKJSONMessageCopy (ID 50117).
/// </summary>
page 50106 ACKJSONMessageCopy
{
    Caption = 'Copy JSON message', Locked = true;
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field(MessageCode; MessageCode)
            {
                Caption = 'New Message code', Locked = true;
                NotBlank = true;
            }
            field(VektisCode; VektisCode)
            {
                Caption = 'Vektis code', Locked = true;
            }
            field(Versie; Versie)
            {
                Caption = 'Versie', Locked = true;
            }
            field(SubVersie; SubVersie)
            {
                Caption = 'Subversie', Locked = true;
            }
            field(Active; Active)
            {
                Caption = 'Active', Locked = true;
            }
        }
    }

    /// <summary>
    /// Setup.
    /// </summary>
    /// <param name="ACKJSONMessage">Record ACKJSONMessage.</param>
    procedure Setup(ACKJSONMessage: Record ACKJSONMessage)
    begin
        VektisCode := ACKJSONMessage.VektisCode;
        Versie := ACKJSONMessage.Versie;
        SubVersie := ACKJSONMessage.Subversie;
        Active := ACKJSONMessage.Active;
    end;

    procedure GetMessageCode(): Code[20]
    begin
        exit(MessageCode);
    end;

    procedure GetActive(): Boolean
    begin
        exit(Active);
    end;

    procedure GetVektisCode(): Enum ACKVektisCode
    begin
        exit(VektisCode);
    end;


    procedure GetVersie(): Integer
    begin
        exit(Versie);
    end;

    procedure GetSubVersie(): Integer
    begin
        exit(SubVersie);
    end;

    var
        MessageCode: Code[20];
        VektisCode: Enum ACKVektisCode;
        Versie, SubVersie : Integer;
        Active: Boolean;
}