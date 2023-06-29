codeunit 50028 ACKWMOHelper
{
    Access = Internal;

    /// <summary>
    /// GetRelatedMessageFilter.
    /// </summary>
    /// <param name="WMOHeader">Record ACKWMOHeader.</param>
    /// <returns>Return variable HeaderIdFilter of type Text.</returns>
    procedure GetRelatedMessageFilter(WMOHeader: Record ACKWMOHeader) HeaderIdFilter: Text
    var
        WMOHeaderHeen: Record ACKWMOHeader;
        ToewijzingNummerFilter: Text;
        InvalidHeaderIdErr: Label 'Invalid header id';
    begin
        if IsNullGuid(WMOHeader.SystemId) then
            Error(InvalidHeaderIdErr);

        if WMOHeader.IsRetour() then
            if WMOHeader.GetToHeader(WMOHeaderHeen, false) then
                WMOHeader := WMOHeaderHeen;

        GetCurrentToewijzingNummerFilter(WMOHeader, ToewijzingNummerFilter);
        GetRelatedHeaderFilter(HeaderIdFilter, ToewijzingNummerFilter);
    end;

    local procedure GetCurrentToewijzingNummerFilter(WMOHeader: Record ACKWMOHeader; var ToewijzingNummerFilter: Text)
    var
        AssignedProductQ: Query ACKAssignedProductQ;
        StartStopProductQ: Query ACKStartStopProductQ;
    begin
        case WMOHeader.BerichtCode of
            ACKVektisCode::wmo301:
                begin
                    AssignedProductQ.SetRange(AssignedProductQ.HeaderId, WMOHeader.ID);
                    AssignedProductQ.Open();

                    while AssignedProductQ.Read() do
                        AddToFilter(ToewijzingNummerFilter, Format(AssignedProductQ.ToewijzingNummer));
                    AssignedProductQ.Close();
                end;
            ACKVektisCode::wmo305:
                begin
                    StartStopProductQ.SetRange(StartStopProductQ.HeaderId, WMOHeader.ID);
                    StartStopProductQ.Open();

                    while StartStopProductQ.Read() do
                        AddToFilter(ToewijzingNummerFilter, Format(StartStopProductQ.ToewijzingNummer));
                    StartStopProductQ.Close();
                end;
        end;
    end;

    local procedure GetRelatedHeaderFilter(var HeaderIdFilter: Text; ToewijzingNummerFilter: Text)
    var
        WMOHeaderRetour: Record ACKWMOHeader;
        AssignedProductQ: Query ACKAssignedProductQ;
        StartStopProductQ: Query ACKStartStopProductQ;
        AfzenderFilter, IdentificatieFilter : Text;
    begin
        //301 & 302
        AssignedProductQ.SetFilter(AssignedProductQ.ToewijzingNummer, ToewijzingNummerFilter);
        AssignedProductQ.SetFilter(AssignedProductQ.IdentificatieRetour, '=%1', '');
        AssignedProductQ.Open();

        while AssignedProductQ.Read() do begin
            AddToFilter(HeaderIdFilter, Format(AssignedProductQ.HeaderId));
            AddToFilter(AfzenderFilter, Format(AssignedProductQ.Afzender));
            AddToFilter(IdentificatieFilter, Format(AssignedProductQ.Identificatie));
        end;
        AssignedProductQ.Close();

        //305 & 306
        StartStopProductQ.SetFilter(StartStopProductQ.ToewijzingNummer, ToewijzingNummerFilter);
        StartStopProductQ.SetFilter(StartStopProductQ.IdentificatieRetour, '=%1', '');
        StartStopProductQ.Open();

        while StartStopProductQ.Read() do begin
            AddToFilter(HeaderIdFilter, Format(StartStopProductQ.HeaderId));
            AddToFilter(AfzenderFilter, Format(StartStopProductQ.Afzender));
            AddToFilter(IdentificatieFilter, Format(StartStopProductQ.Identificatie));
        end;
        StartStopProductQ.Close();

        //Retour
        WMOHeaderRetour.SetFilter(IdentificatieRetour, '<>%1', '');
        WMOHeaderRetour.SetFilter(Identificatie, IdentificatieFilter);
        WMOHeaderRetour.SetFilter(Afzender, AfzenderFilter);
        if WMOHeaderRetour.FindSet(false) then
            repeat
                AddToFilter(HeaderIdFilter, Format(WMOHeaderRetour.ID));
            until WMOHeaderRetour.Next() = 0;
        //Todo add retour headers
    end;

    local procedure AddToFilter(var FilterText: Text; Val: text)
    begin
        if FilterText = '' then
            FilterText := '=';
        if not FilterText.Contains(Val) then begin
            if FilterText <> '=' then
                FilterText += '|';
            FilterText += Val;
        end;
    end;

    procedure GetDaysStopped(_IndicationSystemId: Guid; FromDate: Date; ToDate: Date) Days: Integer
    var
        IndicationTempStop: Record ACKIndicationTempStop;
        TempStartDate, TempEndDate : Date;
    begin
        IndicationTempStop.SetRange(IndicationSystemID, _IndicationSystemId);

        // Include records where the period intersects with the selected month
        IndicationTempStop.SetFilter(StartDate, '<=%1', ToDate);
        IndicationTempStop.SetFilter(EndDate, '>=%1|%2', FromDate, 0D);

        if IndicationTempStop.FindSet(false) then
            repeat
                TempStartDate := FromDate;
                if IndicationTempStop.StartDate > TempStartDate then
                    TempStartDate := IndicationTempStop.StartDate;

                TempEndDate := ToDate;
                if (IndicationTempStop.EndDate <> 0D) and (IndicationTempStop.EndDate < TempEndDate) then
                    TempEndDate := IndicationTempStop.EndDate;

                if TempEndDate > TempStartDate then // Exclude cases where StartDate and EndDate are the same
                    Days += TempEndDate - TempStartDate + 1;
            until IndicationTempStop.Next() = 0;
    end;

    procedure GetIndicationRealStartAndEndDate(IndicationQueryFrom: Query ACKWMOIndicationQuery; var _StartDate: Date; var _EndDate: Date)
    var
        WMOIndication: Record ACKWMOIndication;
        MaxDaysBetween: Integer;
    begin
        MaxDaysBetween := 30;

        if IndicationQueryFrom.ClientNo = '' then
            Error('Wrong use of function.');

        WMOIndication.GetBySystemId(IndicationQueryFrom.IndicationSystemId);

        _StartDate := WMOIndication.GetRealStartDate();
        _EndDate := WMOIndication.GetRealEndDate();

        GetIndicationRealStartDate(IndicationQueryFrom, MaxDaysBetween, _StartDate);

        if _EndDate = 0D then
            exit;

        GetIndicationRealEndDate(IndicationQueryFrom, MaxDaysBetween, _EndDate);
    end;


    local procedure GetIndicationRealStartDate(IndicationQueryFrom: Query ACKWMOIndicationQuery; MaxDaysBetween: Integer; var _StartDate: Date)
    var
        WMOIndication: Record ACKWMOIndication;
    begin
        SetWMOIndicationFilters(IndicationQueryFrom, WMOIndication);
        WMOIndication.SetAscending(StartDate, false);
        WMOIndication.SetFilter(StartDate, '<%1', _StartDate);

        if WMOIndication.FindSet(false) then
            repeat
                if WMOIndication.StartDate <> WMOIndication.EndDate then
                    if WMOIndication.GetRealStartDate() < _StartDate then
                        if (WMOIndication.GetRealEndDate() + MaxDaysBetween) >= _StartDate then
                            _StartDate := WMOIndication.GetRealStartDate()
                        else
                            exit;
            until WMOIndication.Next() = 0;
    end;

    local procedure GetIndicationRealEndDate(IndicationQueryFrom: Query ACKWMOIndicationQuery; MaxDaysBetween: Integer; var _EndDate: Date)
    var
        WMOIndication: Record ACKWMOIndication;
    begin
        SetWMOIndicationFilters(IndicationQueryFrom, WMOIndication);
        WMOIndication.SetAscending(Startdate, true);
        WMOIndication.SetFilter(EndDate, '>%1', _EndDate);

        if WMOIndication.FindSet(false) then
            repeat
                if WMOIndication.StartDate <> WMOIndication.EndDate then
                    if WMOIndication.GetRealEndDate() > _EndDate then
                        if (WMOIndication.GetRealStartDate() - MaxDaysBetween) <= _EndDate then
                            _EndDate := WMOIndication.GetRealEndDate()
                        else
                            exit;
            until WMOIndication.Next() = 0;
    end;

    local procedure SetWMOIndicationFilters(IndicationQueryFrom: Query ACKWMOIndicationQuery; var WMOIndication: Record ACKWMOIndication)
    begin
        Clear(WMOIndication);
        WMOIndication.SetCurrentKey(ClientNo, MunicipalityNo, HealthcareProviderNo, ProductCode, StartDate);
        WMOIndication.SetFilter(SystemId, '<>%1', IndicationQueryFrom.IndicationSystemId);
        WMOIndication.SetRange(ClientNo, IndicationQueryFrom.ClientNo);
        WMOIndication.SetRange(MunicipalityNo, IndicationQueryFrom.MunicipalityNo);
        WMOIndication.SetRange(HealthcareProviderNo, IndicationQueryFrom.HealthcareProviderNo);
        WMOIndication.SetRange(ProductCategoryId, IndicationQueryFrom.ProductCategoryId);
        WMOIndication.SetRange(ProductCode, IndicationQueryFrom.ProductCode);
        WMOIndication.SetRange(ProductUnit, IndicationQueryFrom.ProductUnit);
        WMOIndication.SetRange(ProductFrequency, IndicationQueryFrom.ProductFrequency);
    end;
}
