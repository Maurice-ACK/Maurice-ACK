/// <summary>
/// Page ACKTransportMutationList (ID 50042).
/// </summary>
page 50042 ACKTransportMutationList
{
    Caption = 'Vervoer mutaties', Locked = true;
    CardPageID = ACKTransportMutCard;
    DataCaptionFields = ClientNo;
    Editable = false;
    PageType = List;
    SourceTable = ACKTransportMutationLine;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ClientNo; Rec.ClientNo)
                {
                }
                field(SSN; Rec.SSN)
                {
                }
                field(Birthdate; Rec.Birthdate)
                {
                }
                field(FirstName; Rec.FirstName)
                {
                }
                field(HouseNumberExt; Rec.HouseNumberExt)
                {
                }
            }
        }
    }
}
