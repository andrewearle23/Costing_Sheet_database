Attribute VB_Name = "Module24"
Sub UnprotectAll()
    Dim ws As Worksheet
    Dim wb As Workbook
    
    ' Unprotect all worksheets
    For Each ws In ThisWorkbook.Worksheets
        ws.Unprotect password:="Nope"
    Next ws
    
    ' Unprotect workbook
    Set wb = ThisWorkbook
    If Not wb.ProtectStructure Then
        wb.Unprotect password:="Nope"
    End If
    
    MsgBox "All sheets and the workbook have been unprotected with the password 'Nope'."
End Sub

