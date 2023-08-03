table 50069 ACKSTTClientData
{
    Caption = 'ClientData';
    DataClassification = CustomerContent;

    fields
    {
        field(10; ClientNo; Code[20])
        {
            Caption = 'ClientNo';
            TableRelation = ACKClient.ClientNo;

            trigger OnValidate()
            var
            begin
                // checkClientNo();
            end;
        }
        field(20; CarerNo; Code[20])
        {
            TableRelation = ACKClient.ClientNo;
        }
        field(30; "ClientType"; Enum ACKSTTCLientType)
        {

        }
        field(40; AzureID; Text[40])
        {
            Caption = 'AzureID';
        }

        field(50; Caterogy; Enum ACKStudentTransportCatergory)
        {
            Caption = 'Categorie', Locked = true;
        }
        field(60; EmailLayoutCode; Code[20])
        {
            Caption = 'E-mail layout', Locked = true;
            TableRelation = "Custom Report Layout".Code;
        }
        field(70; compensation; Boolean)
        {
            Caption = 'Compensatie', Locked = true;
        }
        field(80; contribution; Boolean)
        {
            Caption = 'Contributie', Locked = true;
        }
        field(90; Attendant; Guid)
        {
            Caption = 'Begeleider', Locked = true;
            TableRelation = User."User Security ID";
        }


    }
    keys
    {
        key(PK; AzureID)
        {
            Clustered = true;
        }
        key(Sec; ClientNo)
        {
            Unique = true;
        }

    }


    // internal procedure checkClientNo()
    // var
    //     ClientData: Record ACKSTTClientData;
    // begin

    //     ClientData.SetRange(ClientNo, rec.ClientNo);
    //     if ClientData.IsEmpty() then
    //         Error('NUmber already exists');


    // end;




}
