page 50109 ACKMunicipalityNoList
{
    Caption = 'Municipality code list';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ACKMunicipality;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(MunicipalityNo; Rec.MunicipalityNo)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(FromPostcode; Rec.FromPostcode)
                {
                }
                field(ToPostcode; Rec.ToPostcode)
                {
                }
            }
        }
    }
}