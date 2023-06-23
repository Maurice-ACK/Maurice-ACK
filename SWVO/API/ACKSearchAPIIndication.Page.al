/// <summary>
/// Page ACKSearchAPIIndications (ID 50124).
/// </summary>
page 50107 ACKSearchAPIIndications
{
    PageType = API;
    Caption = 'Indications API', Locked = true;
    APIPublisher = 'swvo';
    APIGroup = 'sharepoint';
    APIVersion = 'v1.0';
    EntityName = 'Oldindication';
    EntitySetName = 'Oldindications';
    SourceTable = ACKWMOIndication;
    DelayedInsert = true;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(order; rec.AssignmentNo) { }
                field(productCode; Rec.ProductCode) { }
                field(municipalityNo; Rec.MunicipalityNo) { }
                field(provider; provider) { }
                field(indicationStart; Rec.StartDate) { }
                field(indicationEnd; Rec.EndDate) { }
                field(careStart; rec.EffectiveStartDate) { }
                field(careEnd; rec.EffectiveEndDate) { }
            }
        }
    }
    trigger OnOpenPage()
    var
        CityNoFilter, ClientNoFilter : Text;
    begin
        CityNoFilter := rec.GetFilter(MunicipalityNo);
        ClientNoFilter := rec.GetFilter(ClientNo);

        // if CityNoFilter <> '-1' then begin
        //     rec.Reset();
        //     rec.SetRange(ClientNo, ClientNoFilter);
        // end;
    end;

    trigger OnAfterGetCurrRecord()
    var
        providerRec: Record Vendor;
    begin
        providerRec.SetRange("No.", rec.HealthcareProviderNo);

        if providerRec.FindFirst() then
            provider := providerRec.Name;
    end;

    var
        provider: text;
}