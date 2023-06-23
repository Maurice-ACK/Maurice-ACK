/// <summary>
/// PageExtension ACKGeneralJournal.PageExt.al (ID 50007) extends Record General Journal.
/// </summary>
pageextension 50004 "ACKGeneralJournal.PageExt.al" extends "General Journal"
{
    layout
    {
        modify("Number of Lines")
        {
            Visible = false;
        }
        modify("Total Debit")
        {
            Visible = false;
        }
        modify("Total Credit")
        {
            Visible = false;
        }
        modify(Control1902759701)
        {
            //Balance
            Visible = false;
        }
        modify("Total Balance")
        {
            Visible = false;
        }

        addfirst(Control1901776101)
        {
            group(BalanceBeforePostingGroup)
            {
                Caption = 'Saldo voor boeking', Locked = true;
                field(BalanceBeforePosting; BalanceBeforePosting)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Saldo voor boeking', Locked = true;
                    Editable = false;
                }
            }
            group(ACKDebit)
            {
                Caption = 'Debit';
                field(Debit; CalculateTotalDebitForAccount(Rec))
                {
                    ApplicationArea = All;
                    Caption = 'Debit';
                    Editable = false;
                }
            }
            group(ACKCredit)
            {
                Caption = 'Credit';
                field(Credit; CalculateTotalCreditForBalAccount(Rec))
                {
                    ApplicationArea = All;
                    Caption = 'Credit';
                    Editable = false;
                }
            }
        }

        addlast(Control1901776101)
        {
            group(BalanceAfterPostingGroup)
            {
                Caption = 'Saldo na boeking', Locked = true;
                field(BalanceAfterPosting; BalanceAfterPosting)
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    Caption = 'Saldo na boeking', Locked = true;
                    Editable = false;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //CalculateBalances(Rec, BalanceBeforePosting, BalanceAfterPosting);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //CalculateBalances(Rec, BalanceBeforePosting, BalanceAfterPosting);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //CalculateBalances(Rec, BalanceBeforePosting, BalanceAfterPosting);
    end;

    local procedure CalculateBalances(var GenJnlLine: Record "Gen. Journal Line"; var BeforePosting: Decimal; var AfterPosting: Decimal)
    var
        TempGLAccNetChange: Record "G/L Account Net Change" temporary;
        GLReconcile: Page Reconciliation;
        TotalNetChangeInJournal: Decimal;
        TotalBalanceAfterPosting: Decimal;
    begin
        GLReconcile.SetGenJnlLine(GenJnlLine);

        TempGLAccNetChange.DeleteAll();
        GLReconcile.ReturnGLAccountNetChange(TempGLAccNetChange);

        if TempGLAccNetChange.FindSet() then
            repeat
                TotalNetChangeInJournal += TempGLAccNetChange."Net Change in Jnl.";
                TotalBalanceAfterPosting += TempGLAccNetChange."Balance after Posting";
            until TempGLAccNetChange.Next() = 0;

        AfterPosting := TotalBalanceAfterPosting;
        BeforePosting := TotalBalanceAfterPosting - TotalNetChangeInJournal;
    end;

    local procedure CalculateTotalDebitForAccount(var GenJnlLine: Record "Gen. Journal Line"): Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        GenJournalLine: Record "Gen. Journal Line";
        SelectedAccountNo: Code[20];
    begin
        SelectedAccountNo := GenJnlLine."Account No.";

        GenJournalLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJournalLine.SetRange("Account No.", SelectedAccountNo);
        GenJournalLine.CalcSums("Debit Amount");
        exit(GenJournalLine."Debit Amount");
    end;

    local procedure CalculateTotalCreditForBalAccount(var GenJnlLine: Record "Gen. Journal Line"): Decimal
    var
        [SecurityFiltering(SecurityFilter::Filtered)]
        GenJournalLine: Record "Gen. Journal Line";
        SelectedBalAccountNo: Code[20];
    begin
        SelectedBalAccountNo := GenJnlLine."Bal. Account No.";

        GenJournalLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJournalLine.SetRange("Bal. Account No.", SelectedBalAccountNo);
        GenJournalLine.CalcSums("Credit Amount");
        exit(GenJournalLine."Credit Amount");
    end;

    var
        BalanceBeforePosting: Decimal;
        BalanceAfterPosting: Decimal;
}
