Attribute VB_Name = "Module22"
Sub AdjustColumnWidthProtectedSheet()
    Dim ws As Worksheet
    Dim password As String

    ' Set the password
    password = "Nope"

    ' Unprotect the "Overview" sheet
    On Error Resume Next ' In case the sheet is already unprotected
    Set ws = ThisWorkbook.Worksheets("Overview")
    ws.Unprotect password:=password
    On Error GoTo 0 ' Reset error handling

    ' Adjust column widths
    With ws
        .Cells.Columns.AutoFit
    End With

    ' Protect the "Overview" sheet again
    ws.Protect password:=password

    MsgBox "Column widths adjusted successfully.", vbInformation
End Sub

