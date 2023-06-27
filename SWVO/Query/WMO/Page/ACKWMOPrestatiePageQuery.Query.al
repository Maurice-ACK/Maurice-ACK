/// <summary>
/// Query ACKWMOPrestatiePageQuery
/// </summary>
query 50012 ACKWMOPrestatiePageQuery
{
    Caption = 'Wmo Header - Client prestatie page Query', Locked = true;
    QueryType = Normal;

    elements
    {
        dataitem(ACKWMOHeader; ACKWMOHeader)
        {
            column(HeaderSystemId; SystemId)
            {
            }

            dataitem(ACKWMODeclaratie; ACKWMODeclaratie)
            {
                DataItemLink = HeaderId = ACKWMOHeader.SystemId;
                SqlJoinType = LeftOuterJoin;

                column(DeclarationSystemId; SystemId)
                {
                }

                dataitem(ACKWMOClient; ACKWMOClient)
                {
                    DataItemLink = HeaderId = ACKWMOHeader.SystemId;
                    SqlJoinType = LeftOuterJoin;

                    column(ClientSystemId; SystemId)
                    {
                    }
                    column(SSN; SSN)
                    {
                    }


                    dataitem(ACKWMOPrestatie; ACKWMOPrestatie)
                    {
                        DataItemLink = ClientID = ACKWMOClient.SystemId;
                        SqlJoinType = LeftOuterJoin;

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
                        column(DebitCredit; DebitCredit)
                        {
                        }
                    }
                }
            }
        }
    }
}
