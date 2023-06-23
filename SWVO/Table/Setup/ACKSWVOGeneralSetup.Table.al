/// <summary>
/// Table ACKSWVOGeneralSetup.
/// </summary>
table 50011 ACKSWVOGeneralSetup
{
    Caption = 'SWVO general setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; ClientNos; Code[20])
        {
            Caption = 'Client Nos.';
            TableRelation = "No. Series";
        }
        field(21; WMORetourIdentificationNos; Code[20])
        {
            Caption = 'Retour identification Nos.';
            TableRelation = "No. Series";
        }
        field(22; SubcontractorNos; Code[20])
        {
            Caption = 'Subcontractor Nos.';
            TableRelation = "No. Series";
        }
        field(25; WMODeclarationNos; Code[20])
        {
            Caption = 'Wmo Declaration Nos.';
            TableRelation = "No. Series";
        }
        field(30; MailRegistrationNos; Code[20])
        {
            Caption = 'Mail registration Nos';
            TableRelation = "No. Series";
        }
        field(40; SWVOAPIBaseUri; Text[250])
        {
            //To test on a local docker instance use http://host.docker.internal as the host ip.
            Caption = 'SWVO API base url';
        }
        field(50; BC_TenantId; Guid)
        {
            Caption = 'Tenant id';
        }
        field(60; BC_ClientId; Guid)
        {
            Caption = 'Client id', Locked = true;
        }
        field(80; BC_Scope; Text[255])
        {
            Caption = 'Scope';
        }
        field(90; DigiEndpointURL; Text[250])
        {
            Caption = 'Digikoppeling endpoint URL';
        }
        field(100; DigiEndpointSOAPAction; Text[150])
        {
            Caption = 'Digikoppeling endpoint SOAP action';
        }
        field(110; VendorPostingGroup; Code[20])
        {
            Caption = 'Vendor posting group';
            TableRelation = "Vendor Posting Group";
        }
        field(120; HealthcareProviderPostingGroup; Code[20])
        {
            Caption = 'Healthcare provider posting group';
            TableRelation = "Vendor Posting Group";
        }
        field(130; CustomerPostingGroup; Code[20])
        {
            Caption = 'Customer posting group';
            TableRelation = "Customer Posting Group";
        }
        field(140; MunicipalityPostingGroup; Code[20])
        {
            Caption = 'Municipality posting group';
            TableRelation = "Customer Posting Group";
        }
        field(150; StufApplicationVersion; Code[4])
        {
            Caption = 'Application version';
        }
        field(160; StufApplicationSubVersion; Code[4])
        {
            Caption = 'Application sub version';
        }

        field(170; StufFunctionVersion; Code[4])
        {
            Caption = 'Function version';
        }
        field(180; StufFunctionSubVersion; Code[4])
        {
            Caption = 'Function sub version';
        }
        field(190; JSONMapNos; Code[20])
        {
            Caption = 'JSON Map Nos.';
            TableRelation = "No. Series";
        }
        field(200; VerifyAddressBag; Boolean)
        {
            Caption = 'BAG validation';

        }
        field(210; StUFSenderApplicationDefault; Text[60])
        {
            Caption = 'StUF default sender application';
        }
        field(220; StUFReceiverApplicationHC; Text[60])
        {
            Caption = 'StUF applicatie healthcare providers';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// SetClientSecret.
    /// </summary>
    /// <param name="Secret">Text.</param>
    /// <returns>Return value of type Text.</returns>
    procedure SetClientSecret(Secret: Text): Text
    begin
        IsolatedStorage.Set(BC_Client_Secret, Secret, DataScope::Module);
        exit(GetClientSecret());
    end;

    /// <summary>
    /// GetClientSecret.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetClientSecret(): Text
    var
        KeyVal: Text;
    begin
        if IsolatedStorage.Get(BC_Client_Secret, DataScope::Module, KeyVal) then
            exit(KeyVal);
    end;

    var
        BC_Client_Secret: Label 'BC_Client_Secret';
}

