/// <summary>
/// Page ACKWMOHeaderCardPart (ID 50015).
/// </summary>
page 50015 ACKWMOHeaderCardPart
{
    ApplicationArea = All;
    Caption = 'Header';
    PageType = CardPart;
    SourceTable = ACKWMOHeader;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(Header)
            {
                Caption = 'Header';
                field(Status; Rec.Status)
                {
                }
                field(Identificatie; Rec.Identificatie)
                {
                }
                field(Dagtekening; Rec.Dagtekening)
                {
                }
                group(GroupSender)
                {
                    Caption = 'Afzender', Locked = true;
                    field(Afzender; Rec.Afzender)
                    {
                        CaptionClass = Rec.AfzenderCaption() + ' No.';
                    }
                    field(AfzenderName; Rec.AfzenderName())
                    {
                        CaptionClass = Rec.AfzenderCaption();
                    }
                }
                group(GroupReceiver)
                {
                    Caption = 'Ontvanger';
                    field(Ontvanger; Rec.Ontvanger)
                    {
                        CaptionClass = Rec.OntvangerCaption() + ' No.';
                    }
                    field(OntvangerName; Rec.OntvangerName())
                    {
                        CaptionClass = Rec.OntvangerCaption();
                    }
                }

                group(Retour)
                {
                    Caption = 'Retour information';
                    Visible = IsRetourVisible;

                    field(IdentificatieRetour; Rec.IdentificatieRetour)
                    {
                        Importance = Promoted;
                    }

                    field(DagtekeningRetour; Rec.DagtekeningRetour)
                    {
                    }
                    field(XsltVersie; Rec.XsltVersie)
                    {
                        Importance = Additional;
                    }
                }

                group(Other)
                {
                    Caption = 'Overige';
                    field(Referentienummer; Rec.Referentienummer)
                    {
                        Importance = Additional;
                    }
                    field(BerichtVersie; Rec.BerichtVersie)
                    {
                        Importance = Additional;
                    }
                    field(BerichtSubversie; Rec.BerichtSubversie)
                    {
                        Importance = Additional;
                    }
                    field(BasisschemaXsdVersie; Rec.BasisschemaXsdVersie)
                    {
                        Importance = Additional;
                    }
                    field(BerichtXsdVersie; Rec.BerichtXsdVersie)
                    {
                        Importance = Additional;
                    }
                    field(BasisschemaXsdVersieRetour; Rec.BasisschemaXsdVersieRetour)
                    {
                        Importance = Additional;
                    }
                    field(BerichtXsdVersieRetour; Rec.BerichtXsdVersieRetour)
                    {
                        Importance = Additional;
                    }
                }
            }
        }
    }

    var
        IsRetourVisible: Boolean;

    trigger OnAfterGetCurrRecord()
    begin
        IsRetourVisible := Rec.IsRetour();
    end;
}
