/// <summary>
/// Page ACKGeneralDateDialog
/// </summary>
page 50089 ACKGeneralDateDialog
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = '', Locked = true;

    layout
    {
        area(Content)
        {
            field(X; X)
            {
                CaptionClass = X_P_Lbl;
                Visible = x_Vis;
            }
            field(Y; Y)
            {
                CaptionClass = Y_P_Lbl;
                Visible = y_Vis;
            }
            field(Z; Z)
            {
                CaptionClass = Y_P_Lbl;
                Visible = z_Vis;
            }
        }
    }

    /// <summary>
    /// Setup.
    /// </summary>
    /// <param name="X_Lbl">Text.</param>
    /// <param name="Y_Lbl">Text.</param>
    /// <param name="Z_Lbl">Text.</param>
    procedure Setup(X_Lbl: Text; Y_Lbl: Text; Z_Lbl: Text)
    var
    begin
        X_Vis := false;
        Y_Vis := false;
        Z_Vis := false;
        X_P_Lbl := X_Lbl;
        Y_P_Lbl := Y_Lbl;
        Z_P_Lbl := Z_Lbl;

        if not (X_Lbl = '') then
            X_Vis := true;

        if not (Y_Lbl = '') then
            Y_Vis := true;

        if not (Z_Lbl = '') then
            Z_Vis := true;
    end;

    /// <summary>
    /// SetDate.
    /// </summary>
    /// <param name="XIn">Date.</param>
    /// <param name="YIn">Date.</param>
    /// <param name="ZIn">Date.</param>
    procedure SetDate(XIn: Date; YIn: Date; ZIn: Date)
    begin
        X := XIn;
        Y := YIn;
        Z := ZIn;
    end;

    /// <summary>
    /// GetDate.
    /// </summary>
    /// <returns>Return value of type List of [Date].</returns>
    procedure GetDate(): List of [Date]
    var
        ReturnValue: List of [Date];
    begin
        ReturnValue.Add(X);
        ReturnValue.Add(Y);
        ReturnValue.Add(Z);

        exit(ReturnValue);
    end;

    var
        X: Date;
        Y: Date;
        Z: Date;
        X_P_Lbl: Text;
        Y_P_Lbl: Text;
        Z_P_Lbl: Text;

        [InDataSet]
        X_Vis, Y_Vis, Z_Vis : Boolean;
}