Attribute VB_Name = "Module15"
Sub ToggleSalesProductSheetVisibilityMult()
    ' Unprotect the workbook
    ThisWorkbook.Unprotect password:="Nope"
    
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Sales Tbls - Mult Prod")
    
    ' Store the current active sheet
    Dim currentSheet As Worksheet
    Set currentSheet = ActiveSheet
    
    If ws.Visible = xlSheetVisible Then
        ws.Visible = xlSheetHidden
    Else
        ws.Visible = xlSheetVisible
        ws.Select
    End If
    
    ' Activate the originally active sheet
    currentSheet.Activate
    
    ' Protect the workbook again
    ThisWorkbook.Protect password:="Nope"
End Sub


