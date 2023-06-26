/// <summary>
/// Table ACKMunicipality
/// </summary>
table 50062 ACKMunicipality
{
    DataClassification = SystemMetadata;
    LookupPageId = ACKMunicipalityNoList;
    Caption = 'Municipality';

    fields
    {
        field(10; MunicipalityNo; Code[20])
        {
            Caption = 'No.';
        }
        field(20; Name; Text[60])
        {
            Caption = 'Name';
        }
        field(30; FromPostcode; Integer)
        {
            Caption = 'From postcode';

        }
        field(40; ToPostcode; Integer)
        {
            Caption = 'To postcode';
        }
    }

    keys
    {
        key(Key1; MunicipalityNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; MunicipalityNo, Name)
        {
        }
    }

    trigger OnInsert()
    begin
        ValidatePostcodeRange();
    end;

    trigger OnModify()
    begin
        ValidatePostcodeRange();
    end;

    local procedure ValidatePostcodeRange()
    var
        TmpCity: Record ACKMunicipality temporary;
    begin
        // Check if there's already a record with the same or overlapping postcode range
        TmpCity.SetRange(FromPostcode, Rec.FromPostcode, Rec.ToPostcode);
        TmpCity.SetRange(ToPostcode, Rec.FromPostcode, Rec.ToPostcode);

        if not TmpCity.IsEmpty() then
            Error('The postcode range from %1 to %2 is not unique.', Rec.FromPostcode, Rec.ToPostcode);
    end;

    /// <summary>
    /// GetCityNo.
    /// </summary>
    /// <param name="Postcode">Code[10].</param>
    /// <returns>Return value of type Code[10].</returns>
    procedure GetMunicipalityNo(Postcode: Code[10]): Code[20]
    var
        Municipality: Record ACKMunicipality;
        IntVar: Integer;
        TextVar: Text;
    begin
        TextVar := Postcode;
        TextVar := Text.CopyStr(TextVar, 1, 4);

        Evaluate(IntVar, TextVar);

        Municipality.SetFilter(FromPostcode, '>=%1', IntVar);
        Municipality.SetFilter(ToPostcode, '<=%1', IntVar);

        if Municipality.FindFirst() then
            exit(Municipality.MunicipalityNo)
        else
            exit('');
    end;
}