/// <summary>
/// PageExtension ACKCustomerCardExt (ID 50001).
/// </summary>
pageextension 50001 ACKCustomerCardExt extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            group(SWVO)
            {
                field(StUFApplication; Rec.StUFApplication)
                {
                    ApplicationArea = All;
                }
                field(StUFHeenEndpointURL; Rec.StUFHeenEndpointURL)
                {
                    ApplicationArea = All;
                }
                field(StUFHeenEndpointSOAPAction; Rec.StUFHeenEndpointSOAPAction)
                {
                    ApplicationArea = All;
                }
                field(StUFRetourEndpointURL; Rec.StUFRetourEndpointURL)
                {
                    ApplicationArea = All;
                }
                field(StUFRetourEndpointSOAPAction; Rec.StUFRetourEndpointSOAPAction)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
