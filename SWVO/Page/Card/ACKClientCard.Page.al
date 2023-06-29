/// <summary>
/// Page ACKClientCard
/// </summary>
page 50008 ACKClientCard
{
    ApplicationArea = All;
    Caption = 'Client Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = ACKClient;
    UsageCategory = None;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    DelayedInsert = false;

    layout
    {
        area(content)
        {
            group(General)
            {

                field(ClientNo; Rec.ClientNo)
                {
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(SSN; Rec.SSN)
                {
                    ShowMandatory = true;
                }
                field("First Name"; Rec."First Name")
                {
                }
                field("Middle Name"; Rec."Middle Name")
                {
                }
                field(surname; Rec.Surname)
                {
                }
                field(Initials; Rec.Initials)
                {
                }
                field(Birthdate; Rec.Birthdate)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
            }

            part(ACKClientAddressListPart; ACKClientAddressListPart)
            {
                Caption = 'Addresses';
                Editable = true;
                SubPageLink = ClientNo = field(ClientNo);
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Wmo")
            {
                Caption = 'Messages';
                Image = Documents;
                RunObject = Page ACKWMOClientDoc;
                RunPageLink = SSN = FIELD(SSN);
                ToolTip = 'View client wmo messages.';
            }
            action(Indication)
            {
                Caption = 'Indications';
                Image = CustomerLedger;
                RunObject = Page ACKWMOIndicationList;
                RunPageLink = ClientNo = field(ClientNo);
                ToolTip = 'View client indications.';
            }
        }
    }
}