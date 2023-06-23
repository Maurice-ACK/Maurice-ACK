/// <summary>
/// Page ACKStUFDi01 (ID 50019).
/// </summary>
page 50019 ACKStUFAPI
{
    PageType = API;
    SourceTable = ACKStUF;
    ODataKeyFields = Referentienummer;

    Permissions = tabledata ACKStUF = RIMD;

    APIGroup = 'wmo';
    APIPublisher = 'swvo';
    APIVersion = 'v1.0';
    Caption = 'StUF API', Locked = true;
    EntityCaption = 'StUF', Locked = true;
    EntitySetCaption = 'StUF', Locked = true;
    EntityName = 'stuf';
    EntitySetName = 'stuf';

    Extensible = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(berichtcode; Rec.Berichtcode)
                {
                    NotBlank = true;
                    Caption = 'Berichtcode', Locked = true;
                }
                field(zenderOrganisatie; Rec.ZenderOrganisatie)
                {
                    Caption = 'Zender organisatie', Locked = true;
                }
                field(zenderApplicatie; Rec.ZenderApplicatie)
                {
                    Caption = 'Zender applicatie', Locked = true;
                }
                field(zenderAdministratie; Rec.ZenderAdministratie)
                {
                    Caption = 'Zender administratie', Locked = true;
                }
                field(zenderGebruiker; Rec.ZenderGebruiker)
                {
                    Caption = 'Zender gebruiker', Locked = true;
                }
                field(ontvangerOrganisatie; Rec.OntvangerOrganisatie)
                {
                    Caption = 'Ontvanger organisatie', Locked = true;
                }
                field(ontvangerApplicatie; Rec.OntvangerApplicatie)
                {
                    Caption = 'Ontvanger applicatie', Locked = true;
                }
                field(ontvangerAdministratie; Rec.OntvangerAdministratie)
                {
                    Caption = 'Ontvanger administratie', Locked = true;
                }
                field(ontvangerGebruiker; Rec.OntvangerGebruiker)
                {
                    Caption = 'Ontvanger gebruiker', Locked = true;
                }
                field(referentienummer; Rec.Referentienummer)
                {
                    Caption = 'Referentienummer', Locked = true;
                }
                field(tijdstipBericht; Rec.TijdstipBericht)
                {
                    Caption = 'Tijdstip bericht', Locked = true;
                }
                field(crossRefnummer; Rec.CrossRefnummer)
                {
                    Caption = 'CrossRefnummer', Locked = true;
                }
                field(functie; Rec.Functie)
                {
                    Caption = 'Functie', Locked = true;
                }
                field(functieVersie; Rec.FunctieVersie)
                {
                    Caption = 'Functie versie', Locked = true;
                }
                field(functieSubversie; Rec.FunctieSubversie)
                {
                    Caption = 'Functie subversie', Locked = true;
                }
                field(applicatieVersie; Rec.ApplicatieVersie)
                {
                    Caption = 'Applicatie versie', Locked = true;
                }
                field(applicatieSubversie; Rec.ApplicatieSubversie)
                {
                    Caption = 'Applicatie subversie', Locked = true;
                }
                field(berichtXml; Base64StringXml)
                {
                    Caption = 'Bericht xml', Locked = true;
                }
                field(berichtJson; Base64StringJson)
                {
                    Caption = 'Bericht json', Locked = true;
                }
            }
        }
    }

    var
        Base64StringXml, Base64StringJson : Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ImportBase64Messages();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ExportBericht();
    end;

    local procedure ImportBase64Messages()
    var
        Base64Convert: codeunit "Base64 Convert";
        outstream: OutStream;
    begin
        if Text.StrLen(Base64StringXml) <= 0 then
            error('berichtXml cannot be empty');

        if Text.StrLen(Base64StringJson) <= 0 then
            error('berichtJson cannot be empty');

        Rec.BerichtXml.CreateOutStream(outstream, TextEncoding::UTF8);
        Base64Convert.FromBase64(Base64StringXml, outstream);

        Rec.BerichtJson.CreateOutStream(outstream, TextEncoding::UTF8);
        Base64Convert.FromBase64(Base64StringJson, outstream);
    end;

    local procedure ExportBericht()
    var
        Base64Convert: codeunit "Base64 Convert";
        InStream: InStream;
    begin
        Base64StringXml := 'No Content';

        if Rec.BerichtXml.HasValue() then begin
            Rec.CalcFields(BerichtXml);
            Rec.BerichtXml.CreateInStream(InStream, TextEncoding::UTF8);
            Base64StringXml := Base64Convert.ToBase64(InStream);
        end;
    end;

}
