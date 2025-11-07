Attribute VB_Name = "Module16"
Sub UnhideAndGoToSheetsglprod()
    Dim ws As Worksheet
    Dim sheetName As String
    Dim password As String

    ' Define the name of the sheet you want to unhide and go to
    sheetName = "Quo (sgl) Prod"
    ' Define the password to unprotect the sheet
    password = "Nope"

    ' Unprotect the workbook
    ThisWorkbook.Unprotect password

    ' Unprotect the sheet
    ThisWorkbook.Sheets(sheetName).Unprotect password

    ' Check if the sheet exists in the workbook
    On Error Resume Next
    Set ws = ThisWorkbook.Sheets(sheetName)
    On Error GoTo 0

    ' If the sheet exists, unhide it and activate it
    If Not ws Is Nothing Then
        ws.Visible = xlSheetVisible
        ws.Activate
    Else
        MsgBox "Sheet '" & sheetName & "' not found.", vbExclamation
    End If

    ' Protect the sheet again
    ThisWorkbook.Sheets(sheetName).Protect password
    ' Protect the workbook again
    ThisWorkbook.Protect password
End Sub

