Attribute VB_Name = "Module7"
Sub AdjustColumnWidthProtectedSheetSalestbl()
    Dim ws As Worksheet
    Dim password As String

    ' Set the password
    password = "Nope"

    ' Unprotect the sheet
    On Error Resume Next ' In case the sheet is already unprotected
    Set ws = ThisWorkbook.Worksheets("Sales Tbls - Mult Prod")
    ws.Unprotect password:=password
    On Error GoTo 0 ' Reset error handling

    ' Adjust column widths for columns A to S
    With ws
        .Columns("A:S").AutoFit
    End With

    ' Protect the sheet again
    ws.Protect password:=password

    MsgBox "Column widths adjusted successfully.", vbInformation
End Sub

