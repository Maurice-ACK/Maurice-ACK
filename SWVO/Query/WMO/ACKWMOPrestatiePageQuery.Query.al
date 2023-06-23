/// <summary>
/// Query ACKWMOPrestatieQuery (ID 50024).
/// </summary>
query 50021 ACKWMOPrestatieQuery
{
    Caption = 'Wmo Prestatie Query', Locked = true;
    QueryType = Normal;

    elements
    {
        dataitem(WMOHeader; ACKWMOHeader)
        {
            column(HeaderSystemId; SystemId)
            {
            }
            column(BerichtCode; BerichtCode)
            {
            }
            column(Status; Status)
            {
            }
            column(Identificatie; Identificatie)
            {
            }
            column(Afzender; Afzender)
            {
            }
            column(Ontvanger; Ontvanger)
            {
            }
            column(IdentificatieRetour; IdentificatieRetour)
            {
            }

            dataitem(WMODeclaratie; ACKWMODeclaratie)
            {
                DataItemLink = HeaderId = WMOHeader.SystemId;
                SqlJoinType = InnerJoin;

                column(DeclaratieSystemId; SystemId)
                {
                }
                column(DeclaratieNummer; DeclaratieNummer)
                {
                }
                column(DeclaratieBegindatum; Begindatum)
                {
                }
                column(DeclaratieEinddatum; Einddatum)
                {
                }
                column(DeclaratieDagtekening; DeclaratieDagtekening)
                {
                }
                column(DeclaratieTotaalBedrag; TotaalBedrag)
                {
                }
                column(DeclaratieDebetCredit; DebetCredit)
                {
                }

                dataitem(WMOClient; ACKWMOClient)
                {
                    DataItemLink = HeaderId = WMODeclaratie.HeaderId;
                    SqlJoinType = InnerJoin;

                    column(ClientSystemId; SystemId)
                    {
                    }
                    column(SSN; SSN)
                    {
                    }
                    dataitem(WMOPrestatie; ACKWMOPrestatie)
                    {
                        DataItemLink = ClientID = WMOClient.SystemId;
                        SqlJoinType = InnerJoin;

                        column(PrestatieSystemId; SystemId)
                        {
                        }
                        column(ReferentieNummer; ReferentieNummer)
                        {
                        }
                        column(VorigReferentieNummer; VorigReferentieNummer)
                        {
                        }
                        column(ToewijzingNummer; ToewijzingNummer)
                        {
                        }
                        column(ProductCategorie; ProductCategorie)
                        {
                        }
                        column(ProductCode; ProductCode)
                        {
                        }
                        column(Begindatum; Begindatum)
                        {
                        }
                        column(Einddatum; Einddatum)
                        {
                        }
                        column(GeleverdVolume; GeleverdVolume)
                        {
                        }
                        column(Eenheid; Eenheid)
                        {
                        }
                        column(ProductTarief; ProductTarief)
                        {
                        }
                        column(Bedrag; Bedrag)
                        {
                        }
                        column(DebetCredit; DebetCredit)
                        {
                        }
                    }
                }
            }
        }
    }
}