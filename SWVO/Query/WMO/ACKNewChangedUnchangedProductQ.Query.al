/// <summary>
/// Query ACKNewChangedUnchangedProductQ
/// </summary>
query 50023 ACKNewChangedUnchangedProductQ
{
    Caption = 'New/Changed/Unchanged product query';
    QueryType = Normal;

    elements
    {
        dataitem(ACKWMOHeader; ACKWMOHeader)
        {
            column(HeaderSystemId; SystemId)
            {
            }
            column(BerichtCode; BerichtCode)
            {
            }
            column(Afzender; Afzender)
            {
            }
            column(Identificatie; Identificatie)
            {
            }
            column(Ontvanger; Ontvanger)
            {
            }
            column(Referentienummer; Referentienummer)
            {
            }
            column(Status; Status)
            {
            }
            dataitem(ACKWMOClient; ACKWMOClient)
            {
                DataItemLink = HeaderId = ACKWMOHeader.SystemId;
                SqlJoinType = InnerJoin;

                column(ClientSystemId; SystemId)
                {
                }
                column(SSN; SSN)
                {
                }
                dataitem(ACKNewChangedUnchangedProduct; ACKNewChangedUnchangedProduct)
                {
                    DataItemLink = ClientID = ACKWMOClient.SystemId;
                    SqlJoinType = InnerJoin;

                    column(NewChangedUnchangedProductSystemId; SystemId)
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
                    column(Volume; Volume)
                    {
                    }
                    column(Eenheid; Eenheid)
                    {
                    }
                    column(Frequentie; Frequentie)
                    {
                    }
                    column(GewensteIngangsdatum; GewensteIngangsdatum)
                    {
                    }
                    column(Einddatum; Einddatum)
                    {
                    }
                    column(NewChangedUnchangedProductType; NewChangedUnchangedProductType)
                    {
                    }
                    column(RedenVerzoek; RedenVerzoek)
                    {
                    }
                    column(ReferentieAanbieder; ReferentieAanbieder)
                    {
                    }
                }
            }
        }
    }
}
