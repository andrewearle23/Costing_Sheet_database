Attribute VB_Name = "Module34"
Sub AutoAdjustColumnWidthsstockcost()
    Dim ws As Worksheet
    Dim rng1 As Range
    Dim rng2 As Range
    Dim rng As Range
    
    ' Specify the worksheet by name
    Set ws = ThisWorkbook.Sheets("Stock Cost")
    
    ' Unprotect the worksheet with password "Nope"
    ws.Unprotect password:="Nope"
    
    ' Define the range of cells to consider for auto-adjusting column widths
    Set rng1 = ws.Range("C:E")
    Set rng2 = ws.Range("G:N")
    
    ' Combine both ranges
    Set rng = Union(rng1, rng2)
    
    ' Auto adjust column widths
    rng.Columns.AutoFit
    
    ' Protect the worksheet with password "Nope"
    ws.Protect password:="Nope"
    
    ' Optional: Enable specific protection options
    ' ws.Protect Password:="Nope", UserInterfaceOnly:=True, AllowFormattingColumns:=True
End Sub

