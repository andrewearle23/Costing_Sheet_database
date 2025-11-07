Attribute VB_Name = "Module21"
Sub ToggleColumnWidth()
    Dim LastColumn As Long
    Dim ws As Worksheet
    
    ' Set the worksheet
    Set ws = ThisWorkbook.Sheets("Cash Flow") ' Change "Cash Flow" to your sheet name
    
    ' Unprotect the worksheet
    ws.Unprotect password:="Nope"
    
    ' Check the current column width
    If ws.Columns("H:BG").ColumnWidth = 10 Then
        ' If currently 10, autofit columns
        ws.Columns("H:BG").EntireColumn.AutoFit
    Else
        ' If not 10, set width to 10
        ws.Columns("H:BG").ColumnWidth = 10
    End If
    
    ' Protect the worksheet
    ws.Protect password:="Nope"
End Sub

