/// <summary>
/// Codeunit ACKHomelessProcessing (ID 50007).
/// </summary>
codeunit 50008 ACKHomelessProcessing
{
    trigger OnRun()
    var
        ACKHomeless: Record ACKHomeless;
    begin
        Dialog.Message('Test: werkt juist!');
    end;
}
