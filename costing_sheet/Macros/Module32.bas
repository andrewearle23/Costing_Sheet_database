Attribute VB_Name = "Module32"
Sub HideAndGoToSalesTblMult()
    Dim currentSheet As Worksheet
    Dim targetSheetName As String
    Dim targetSheet As Worksheet
    Dim password As String

    ' Define the name of the target sheet
    targetSheetName = "Sales Tbls - Mult Prod"
    ' Define the password to protect the sheet
    password = "Nope"

    ' Unprotect the workbook
    ThisWorkbook.Unprotect password

    ' Get the current sheet
    Set currentSheet = ThisWorkbook.ActiveSheet

    ' Unprotect the current sheet
    currentSheet.Unprotect password

    ' Check if the target sheet exists
    On Error Resume Next
    Set targetSheet = ThisWorkbook.Sheets(targetSheetName)
    On Error GoTo 0

    ' If the target sheet exists, hide the current sheet and navigate to the target sheet
    If Not targetSheet Is Nothing Then
        currentSheet.Visible = xlSheetHidden
        targetSheet.Activate
    Else
        MsgBox "Sheet '" & targetSheetName & "' not found.", vbExclamation
    End If

    ' Protect the current sheet again
    currentSheet.Protect password
    ' Protect the workbook again
    ThisWorkbook.Protect password
End Sub


