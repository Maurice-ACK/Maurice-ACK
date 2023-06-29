/// <summary>
/// Page ACKSWVOGeneralSetup.
/// </summary>
page 50007 ACKSWVOGeneralSetup
{
    ApplicationArea = Basic, Suite;
    Caption = 'SWVO general setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = ACKSWVOGeneralSetup;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field(ClientNos; Rec.ClientNos)
                { }
                field(WMORetourIdentificationNos; Rec.WMORetourIdentificationNos)
                { }
                field(WMODeclarationNos; Rec.WMODeclarationNos)
                { }
                field(SubcontractorNos; Rec.SubcontractorNos)
                { }
                field(MailRegistrationNos; Rec.MailRegistrationNos)
                { }
                field(JSONMapNos; Rec.JSONMapNos)
                { }
            }

            group(Endpoints)
            {
                Caption = 'Endpoints';
                group("SWVO API")
                {
                    Caption = 'SWVO API';

                    field(SWVOAPIBaseUri; Rec.SWVOAPIBaseUri)
                    {
                        Caption = 'Base url', Locked = true;
                        ToolTip = 'Base endpoint for connecting with SWVO API.';
                    }
                    field(Tenant_Id; Rec.BC_TenantId)
                    {
                        Caption = 'Tenant ID';
                    }

                    field(BC_Client_Id; Rec.BC_ClientId)
                    {
                        Caption = 'Client ID', Locked = true;
                        ToolTip = 'Specifies the client ID for the app registration.', Locked = true;
                    }
                    field(Scope; Rec.BC_Scope)
                    { }
                    field(ClientSecret; ClientSecretVar)
                    {
                        Caption = 'Client secret', Locked = true;
                        ToolTip = 'Client secret', Locked = true;
                        Editable = PageEdit;
                        ExtendedDatatype = Masked;
                        trigger OnValidate()
                        begin
                            Rec.SetClientSecret(ClientSecretVar);
                        end;
                    }
                }
            }
            group("Posting groups")
            {
                Caption = 'Posting groups';
                field(VendorPostingGroup; Rec.VendorPostingGroup)
                {
                    Caption = 'Vendor';
                }
                field(HealthcareProviderPostingGroup; Rec.HealthcareProviderPostingGroup)
                {
                    Caption = 'Healthcare provider';
                }
                field(CustomerPostingGroup; Rec.CustomerPostingGroup)
                {
                    Caption = 'Customer';
                }
                field(MunicipalityPostingGroup; Rec.MunicipalityPostingGroup)
                {
                    Caption = 'Municipality';
                }
            }
            group("Wmo")
            {
                field(StufApplicationVersion; Rec.StufApplicationVersion)
                {
                }
                field(StufApplicationSubVersion; Rec.StufApplicationSubVersion)
                {
                }
                field(StufFunctionVersion; Rec.StufFunctionVersion)
                {
                }
                field(StufFunctionSubVersion; Rec.StufFunctionSubVersion)
                {
                }
                field(StUFSenderApplicationDefault; Rec.StUFSenderApplicationDefault)
                {
                }
                field(StUFReceiverApplicationHC; Rec.StUFReceiverApplicationHC)
                {
                }
            }
            group("BAG")
            {
                field(ValidateAddressBag; Rec.VerifyAddressBag)
                {
                    ToolTip = 'Use the BAG API to validate addresses';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestAuthConnectionSWVOAPI)
            {
                Image = LinkWeb;
                Caption = 'SWVO API Connection test';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    ACKSWVOAPIHttpClient: codeunit ACKSWVOAPHttpClient;
                begin
                    ACKSWVOAPIHttpClient.TestAuthConnection();
                end;
            }

        }
        area(Creation)
        {
            action(SetVendorPostingGroup)
            {
                Image = PostedVendorBill;
                Caption = 'Setup Vendor ↔ Posting group';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                RunObject = page ACKVendorAndPostingList;
            }
        }

    }

    trigger OnAfterGetRecord()
    var
        ten: text;
    begin
        PageEdit := CurrPage.Editable;
        ClientSecretVar := Rec.GetClientSecret();
    end;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end
    end;

    var
        [InDataSet]
        ClientSecretVar: Text;
        PageEdit: Boolean;
}

