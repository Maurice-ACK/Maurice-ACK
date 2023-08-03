/// <summary>
/// TableExtension ACKVendorExtensionextends Record Vendor.
/// </summary>
tableextension 50001 ACKVendorExtension extends Vendor
{
    Caption = 'Vendor/Healthcare provider';

    fields
    {
        field(50000; ACKStartEndMonthDeclaration; Boolean)
        {
            Caption = 'Start/End-month declaration';
            DataClassification = SystemMetadata;
        }
        field(50002; ACKPermiWMO; Boolean)
        {
            Caption = 'iWMO (301A / 317A)';
            DataClassification = SystemMetadata;
        }
        field(50003; ACKPermHomeless; Boolean)
        {
            Caption = 'Homeless';
            DataClassification = SystemMetadata;
        }
        field(50004; ACKPermResources; Boolean)
        {
            Caption = 'Resources';
            DataClassification = SystemMetadata;
        }
        field(50005; ACKPermWMOTransport; Boolean)
        {
            Caption = 'Wmo Transport';
            DataClassification = SystemMetadata;
        }
        field(50006; ACKPermOtherDocuments; Boolean)
        {
            Caption = 'Other documents';
            DataClassification = SystemMetadata;
        }
        field(50007; ACKStudentStransport; Boolean)
        {
            Caption = 'Other documents';
            DataClassification = SystemMetadata;
        }
    }
}
