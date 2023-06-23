/// <summary>
/// Page ACKStUFCard (ID 50047).
/// </summary>
page 50047 ACKStUFCard
{
    Caption = 'StUf';
    PageType = Card;
    SourceTable = ACKStUF;
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Referentienummer; Rec.Referentienummer)
                {
                    ApplicationArea = All;
                }
                field(Berichtcode; Rec.Berichtcode)
                {
                    ApplicationArea = All;
                }
                field(ZenderOrganisatie; Rec.ZenderOrganisatie)
                {
                    ApplicationArea = All;
                }
                field(ZenderApplicatie; Rec.ZenderApplicatie)
                {
                    ApplicationArea = All;
                }
                field(ZenderAdministratie; Rec.ZenderAdministratie)
                {
                    ApplicationArea = All;
                }
                field(ZenderGebruiker; Rec.ZenderGebruiker)
                {
                    ApplicationArea = All;
                }
                field(OntvangerOrganisatie; Rec.OntvangerOrganisatie)
                {
                    ApplicationArea = All;
                }
                field(OntvangerApplicatie; Rec.OntvangerApplicatie)
                {
                    ApplicationArea = All;
                }
                field(OntvangerAdministratie; Rec.OntvangerAdministratie)
                {
                    ApplicationArea = All;
                }
                field(OntvangerGebruiker; Rec.OntvangerGebruiker)
                {
                    ApplicationArea = All;
                }
                field(TijdstipBericht; Rec.TijdstipBericht)
                {
                    ApplicationArea = All;
                }
                field(CrossRefnummer; Rec.CrossRefnummer)
                {
                    ApplicationArea = All;
                }
                field(Functie; Rec.Functie)
                {
                    ApplicationArea = All;
                }
                field(ApplicatieVersie; Rec.ApplicatieVersie)
                {
                    ApplicationArea = All;
                }
                field(ApplicatieSubversie; Rec.ApplicatieSubversie)
                {
                    ApplicationArea = All;
                }
                field(FunctieVersie; Rec.FunctieVersie)
                {
                    ApplicationArea = All;
                }
                field(FunctieSubversie; Rec.FunctieSubversie)
                {
                    ApplicationArea = All;
                }
                field(BerichtXml; Rec.BerichtXml)
                {
                    ApplicationArea = All;
                }
                field(BerichtJson; Rec.BerichtJson)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
