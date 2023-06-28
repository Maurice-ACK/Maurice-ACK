/// <summary>
/// Codeunit ACKWMODeclarationHelper
/// </summary>
codeunit 50039 ACKWMODeclarationHelper
{
    /// <summary>
    /// GetTotalAmountDeclaredByAssignment.
    /// </summary>
    /// <param name="MunicipalityNo">Code[20].</param>
    /// <param name="HealthcareProviderNo">Code[20].</param>
    /// <param name="ClientNo">Code[20].</param>
    /// <param name="AssignmentNo">Integer.</param>
    /// <param name="Year">Integer.</param>
    /// <param name="Month">Integer.</param>
    /// <returns>Return variable TotalAmount of type Integer.</returns>
    procedure GetTotalAmountDeclaredInPeriodByAssignment(MunicipalityNo: Code[20]; HealthcareProviderNo: Code[20]; ClientNo: Code[20]; AssignmentNo: Integer; Year: Integer; Month: Integer) TotalAmount: Integer
    var
        WMODeclarationQuery: Query ACKWMODeclarationQuery;
    begin
        WMODeclarationQuery.SetFilter(WMODeclarationQuery.Status, '<>%1', ACKWMODeclarationStatus::Rejected.AsInteger());
        WMODeclarationQuery.SetRange(WMODeclarationQuery.ClientNo, ClientNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.AssignmentNo, AssignmentNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.MunicipalityNo, MunicipalityNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.HealthcareProviderNo, HealthcareProviderNo);
        WMODeclarationQuery.SetRange(Year, Year);
        WMODeclarationQuery.SetRange(Month, Month);

        if WMODeclarationQuery.Open() and WMODeclarationQuery.Read() then
            TotalAmount := WMODeclarationQuery.TotalAmount;
    end;

    /// <summary>
    /// GetTotalApprovedAmountDeclaredInPeriodByAssignment.
    /// </summary>
    /// <param name="MunicipalityNo">Code[20].</param>
    /// <param name="HealthcareProviderNo">Code[20].</param>
    /// <param name="ClientNo">Code[20].</param>
    /// <param name="AssignmentNo">Integer.</param>
    /// <param name="Year">Integer.</param>
    /// <param name="Month">Integer.</param>
    /// <returns>Return variable TotalAmount of type Integer.</returns>
    procedure GetTotalApprovedAmountDeclaredInPeriodByAssignment(MunicipalityNo: Code[20]; HealthcareProviderNo: Code[20]; ClientNo: Code[20]; AssignmentNo: Integer; Year: Integer; Month: Integer) TotalAmount: Integer
    var
        WMODeclarationQuery: Query ACKWMODeclarationQuery;
    begin
        WMODeclarationQuery.SetFilter(WMODeclarationQuery.LineStatus, '>=%1', ACKWMODeclarationStatus::Approved.AsInteger());
        WMODeclarationQuery.SetRange(WMODeclarationQuery.ClientNo, ClientNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.AssignmentNo, AssignmentNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.MunicipalityNo, MunicipalityNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.HealthcareProviderNo, HealthcareProviderNo);
        WMODeclarationQuery.SetRange(Year, Year);
        WMODeclarationQuery.SetRange(Month, Month);

        if WMODeclarationQuery.Open() and WMODeclarationQuery.Read() then
            TotalAmount := WMODeclarationQuery.TotalAmount;
    end;


    /// <summary>
    /// GetTotalAmountDeclaredByDeclarationNo.
    /// </summary>
    /// <param name="HealthcareProviderNo">Code[20].</param>
    /// <param name="DeclarationNo">Text[12].</param>
    /// <returns>Return variable TotalAmount of type Integer.</returns>
    procedure GetTotalAmountDeclaredByDeclarationNo(HealthcareProviderNo: Code[20]; DeclarationNo: Text[12]) TotalAmount: Integer
    var
        WMODeclarationQuery: Query ACKWMODeclarationQuery;
    begin
        WMODeclarationQuery.SetRange(WMODeclarationQuery.HealthcareProviderNo, HealthcareProviderNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.DeclarationNo, DeclarationNo);
        WMODeclarationQuery.SetFilter(WMODeclarationQuery.Status, '<>%1', ACKWMODeclarationStatus::Rejected.AsInteger());

        if WMODeclarationQuery.Open() and WMODeclarationQuery.Read() then
            TotalAmount := WMODeclarationQuery.TotalAmount;
    end;

    /// <summary>
    /// GetTotalAmountDeclaredAssignment.
    /// </summary>
    /// <param name="MunicipalityNo">Code[20].</param>
    /// <param name="HealthcareProviderNo">Code[20].</param>
    /// <param name="ClientNo">Code[20].</param>
    /// <param name="AssignmentNo">Integer.</param>
    /// <returns>Return variable TotalAmount of type Integer.</returns>
    procedure GetTotalAmountDeclaredAssignment(MunicipalityNo: Code[20]; HealthcareProviderNo: Code[20]; ClientNo: Code[20]; AssignmentNo: Integer) TotalAmount: Integer
    var
        WMODeclarationQuery: Query ACKWMODeclarationQuery;
    begin
        WMODeclarationQuery.SetRange(WMODeclarationQuery.MunicipalityNo, MunicipalityNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.HealthcareProviderNo, HealthcareProviderNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.ClientNo, ClientNo);
        WMODeclarationQuery.SetRange(WMODeclarationQuery.AssignmentNo, AssignmentNo);
        WMODeclarationQuery.SetFilter(WMODeclarationQuery.Status, '<>%1', ACKWMODeclarationStatus::Rejected.AsInteger());

        if WMODeclarationQuery.Open() and WMODeclarationQuery.Read() then
            TotalAmount := WMODeclarationQuery.TotalAmount;
    end;

    /// <summary>
    /// GetHealthcareMonthRate.
    /// </summary>
    /// <param name="ProductCode">Text[5].</param>
    /// <param name="Eenheid">Enum ACKWMOEenheid.</param>
    /// <param name="Year">Integer.</param>
    /// <param name="Month">Integer.</param>
    /// <returns>Return variable Rate of type Integer.</returns>
    procedure GetHealthcareMonthRate(ProductCode: Text[5]; Eenheid: Enum ACKWMOEenheid; Year: Integer; Month: Integer) Rate: Integer;
    var
        HealthcareMonthPCRateQuery: Query ACKHealthcareMonthPCRateQuery;
    begin
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.Year, Year);
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.Month, Month);
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.ProductCode, ProductCode);
        HealthcareMonthPCRateQuery.SetRange(HealthcareMonthPCRateQuery.DeclarationUnitId, Eenheid);

        if HealthcareMonthPCRateQuery.Open() and HealthcareMonthPCRateQuery.Read() then
            Rate := HealthcareMonthPCRateQuery.Rate;
    end;
}
