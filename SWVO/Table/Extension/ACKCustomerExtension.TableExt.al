/// <summary>
/// TableExtension ACKCustomerExtensionextends Record Customer.
/// </summary>
tableextension 50000 ACKCustomerExtension extends Customer
{
    fields
    {
        field(50000; StUFHeenEndpointURL; Text[250])
        {
            Caption = 'Heen message endpoint URL';
            DataClassification = SystemMetadata;
        }
        field(50001; StUFHeenEndpointSOAPAction; Text[150])
        {
            Caption = 'Heen message endpoint SOAP action';
            DataClassification = SystemMetadata;
        }
        field(50002; StUFRetourEndpointURL; Text[250])
        {
            Caption = 'Retour message endpoint URL';
            DataClassification = SystemMetadata;
        }
        field(50003; StUFRetourEndpointSOAPAction; Text[150])
        {
            Caption = 'Retour message endpoint SOAP action';
            DataClassification = SystemMetadata;
        }
        field(50004; StUFApplication; Text[60])
        {
            Caption = 'StUF application';
            DataClassification = SystemMetadata;
        }
    }
}
