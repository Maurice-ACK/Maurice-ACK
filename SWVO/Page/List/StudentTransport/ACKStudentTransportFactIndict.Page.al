page 50064 ACKStudentTransportFactIndict

{
    ApplicationArea = All;
    Caption = 'Leerlingenvervoer indicaties', Locked = true;
    PageType = CardPart;
    SourceTable = ACKStudentTransportIndiQ;
    SourceTableTemporary = true;
    Editable = false;



    layout
    {
        area(content)
        {
            group(Customer)
            {

                field(ClientNo; Rec.ClientNo) { }
                field(CustomerId; Rec.CustomerId) { }
                field(Status; rec.status)
                {

                }


            }
            group(Indication)
            {


                field("Indication ID"; Rec.IndicationId)
                {
                }

                field(serviceId; rec.serviceId)
                {

                }
                field(locationId; rec.locationId) { }
                field(contractId; rec.contractId) { }


                field(Description; Rec.descriptionInd)
                {
                }
                field(Mutation; rec.mutationDateIndication)
                {

                }



            }
            group(Card)
            {
                field(CardId; Rec.CardId) { }
                field(Caterogy; Rec.Caterogy) { }
                field("Client Status"; Rec.CardStatusId) { }
                field(CardNumber; Rec.CardNumber) { }
            }




        }


    }








    // trigger OnOpenPage()
    // var
    //     queryInd: Query ACKStudentTransportIndictionQ;
    // begin
    //     if queryInd.Open() then begin

    //         while queryInd.Read() do begin


    //             Rec.Init();
    //             Rec.ClientNo := queryInd.ClientNo;
    //             Rec.AdditionalValue := queryInd.AdditionalValue;
    //             Rec.CustomerId := queryInd.CustomerId;
    //             Rec.Indication := queryInd.IndicationId;
    //             Rec.MutationDate := queryInd.MutationDate;
    //             Rec.creationDate := queryInd.CreationDate;
    //             // Rec.Description := queryInd.Description;
    //             Rec.CardId := queryInd.CardId;
    //             Rec.Caterogy := queryInd.Category;
    //             Rec.CardStatusId := queryInd.CardStatusId;
    //             Rec.scheduleCount := queryInd.countIndex;
    //             Rec.CardNumber := queryInd.CardNumber;
    //             rec.status := queryInd.customerStatus;
    //             rec.indicationId := queryInd.indicationId;
    //             rec.descriptionInd := queryInd.descriptionInd;
    //             rec.MutationDate := queryInd.MutationDate;

    //             rec.serviceId := queryInd.serviceId;
    //             rec.locationId := queryInd.locationId;
    //             rec.contractId := queryInd.contractId;

    //             Rec.Insert();
    //         end;
    //         queryInd.Close();
    //     end;


    // end;


}
