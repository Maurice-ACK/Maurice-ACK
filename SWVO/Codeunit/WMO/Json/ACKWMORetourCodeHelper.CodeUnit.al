/// <summary>
/// Codeunit ACKWMORetourCodeHelper (ID 50005).
/// </summary>
codeunit 50006 ACKWMORetourCodeHelper
{
    // var
    //     RetourCodeList: List of [Code[4]];

    // /// <summary>
    // /// AddCode.
    // /// </summary>
    // /// <param name="RetourCode">Code[4].</param>
    // procedure AddCode(RetourCode: Code[4])
    // begin
    //     RetourCodeList.Add(RetourCode);
    // end;

    // /// <summary>
    // /// GetList.
    // /// </summary>
    // /// <returns>Retour variable RetourCodeList of type List of [Code[4]].</returns>
    // procedure GetList() RetourCodeList: List of [Code[4]]
    // begin
    // end;

    // /// <summary>
    // /// ToList.
    // /// </summary>
    // /// <param name="CommaSeperatedText">Text.</param>
    // /// <returns>Retour variable RetourCodeList of type List of [Code[4]].</returns>
    // procedure ToList(CommaSeperatedText: Text) RetourCodeList: List of [Code[4]]
    // var
    //     RetourCode: Text;
    // begin
    //     foreach RetourCode in CommaSeperatedText.Split(',') do
    //         RetourCodeList.Add(CopyStr(RetourCode, 1, 4));
    // end;

    // /// <summary>
    // /// ToCommaSeperatedText.
    // /// </summary>
    // /// <returns>Retour variable CommaSeperatedText of type Text.</returns>
    // procedure ToCommaSeperatedText() CommaSeperatedText: Text
    // var
    //     RetourCode: Code[4];
    // begin
    //     foreach RetourCode in RetourCodeList do
    //         CommaSeperatedText := InsStr(CommaSeperatedText, RetourCode, StrLen(CommaSeperatedText));
    // end;

    // /// <summary>
    // /// ImportJsonArray.
    // /// </summary>
    // /// <param name="JsonArray">JsonArray.</param>
    // /// <param name="ACKTableRelationType">Enum ACKTableRelationType.</param>
    // /// <param name="RefId">Guid.</param>
    // procedure ImportJsonArray(JsonArray: JsonArray; ACKTableRelationType: Enum ACKTableRelationType; RefId: Guid)
    // var
    //     ACKWMORetourCode: Record ACKWMORetourCode;
    //     JsonToken: JsonToken;
    // begin

    //     foreach JsonToken in JsonArray do
    //         if JsonToken.IsValue() then begin
    //             ACKWMORetourCode.RetourCode := CopyStr(JsonToken.AsValue().AsCode(), 1, 4);
    //             ACKWMORetourCode.Insert();
    //         end
    //         else
    //             Error('Only values from an array are supported.');
    // end;
}
