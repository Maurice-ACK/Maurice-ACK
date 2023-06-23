query 50015 ACKStudentTransportUser
{
    Caption = 'StudentTransportUser';
    QueryType = Normal;

    elements
    {
        dataitem(User; User)
        {
            column(LicenseType; "License Type")
            {
            }
            column(UserName; "User Name")
            {
            }
            column(UserSecurityID; "User Security ID")
            {
            }
            column(FullName; "Full Name")
            {
            }
            column(ExpiryDate; "Expiry Date")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
