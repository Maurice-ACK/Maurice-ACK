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

        WMODeclarationQuery.Open();

        while WMODeclarationQuery.Read() do
            TotalAmount += WMODeclarationQuery.Amount;
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

        WMODeclarationQuery.Open();

        while WMODeclarationQuery.Read() do
            TotalAmount += WMODeclarationQuery.Amount;
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

        WMODeclarationQuery.Open();

        while WMODeclarationQuery.Read() do
            TotalAmount += WMODeclarationQuery.Amount;
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

        WMODeclarationQuery.Open();

        while WMODeclarationQuery.Read() do
            TotalAmount += WMODeclarationQuery.Amount;
    end;

    /// <summary>
    /// GetProductCodeMonthRate.
    /// </summary>
    /// <param name="ProductCode">Text[5].</param>
    /// <param name="Eenheid">Enum ACKWMOEenheid.</param>
    /// <param name="Year">Integer.</param>
    /// <param name="Month">Integer.</param>
    /// <returns>Return variable Rate of type Integer.</returns>
    procedure GetProductCodeMonthRate(ProductCode: Text[5]; Eenheid: Enum ACKWMOEenheid; Year: Integer; Month: Integer) Rate: Integer;
    var
        ProductCodeMonthRateQuery: Query ACKProductCodeMonthRateQuery;
    begin
        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.Year, Year);
        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.Month, Month);
        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.ProductCode, ProductCode);
        ProductCodeMonthRateQuery.SetRange(ProductCodeMonthRateQuery.DeclarationUnitId, Eenheid);

        if ProductCodeMonthRateQuery.Open() and ProductCodeMonthRateQuery.Read() then
            Rate := ProductCodeMonthRateQuery.Rate;
    end;
}
