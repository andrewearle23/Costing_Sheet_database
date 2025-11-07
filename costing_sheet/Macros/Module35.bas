Attribute VB_Name = "Module35"
Sub AutoAdjustColumnWidthstranscost()
    Dim ws As Worksheet
    Dim rng As Range
    
    ' Specify the worksheet by name
    Set ws = ThisWorkbook.Sheets("Transport Cost")
    
    ' Unprotect the worksheet with password "Nope"
    ws.Unprotect password:="Nope"
    
    ' Define the range of cells to consider for auto-adjusting column widths
    Set rng = ws.Range("C:N")
    
    ' Auto adjust column widths
    rng.Columns.AutoFit
    
    ' Protect the worksheet with password "Nope"
    ws.Protect password:="Nope"
    
    ' Optional: Enable specific protection options
    ' ws.Protect Password:="Nope", UserInterfaceOnly:=True, AllowFormattingColumns:=True
End Sub

