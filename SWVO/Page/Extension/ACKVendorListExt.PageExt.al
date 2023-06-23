/// <summary>
/// PageExtension ACKVendorListExt (ID 50003) extends Record Vendor List.
/// </summary>
pageextension 50003 ACKVendorListExt extends "Vendor List"
{
    layout
    {
        addafter(Control1)
        {
            group("Other documents list")
            {
                Caption = 'Other documents list';
                Group(SubPart)
                {
                    ShowCaption = false;

                    part(doc; ACKOtherDocumentListPart)
                    {
                        Caption = ' ', Locked = true;
                        SubPageLink = HealthcareproviderNo = field("No.");
                        ApplicationArea = all;
                    }
                }
            }
        }
    }
}
