Attribute VB_Name = "Module20"
Sub ToggleCashFlowVis()
    ' Unprotect the workbook
    ThisWorkbook.Unprotect password:="Nope"
    
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Cash Flow")
    
    If ws.Visible = xlSheetVisible Then
        ws.Visible = xlSheetHidden
    Else
        ws.Visible = xlSheetVisible
        ws.Select
    End If
    
    ' Protect the workbook again
    ThisWorkbook.Protect password:="Nope"
End Sub
