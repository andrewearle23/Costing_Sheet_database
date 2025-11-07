Attribute VB_Name = "Module6"
Sub HideUnhideRows()
    Dim ws As Worksheet
    Dim rowsRange As Range
    Dim row As Range
    
    ' Unprotect the worksheet
    ThisWorkbook.Sheets("Transport Cost").Unprotect password:="Nope"
    
    ' Set the worksheet object
    Set ws = ThisWorkbook.Sheets("Transport Cost") ' Change "Transport Cost" to your sheet name
    
    ' Set the range for rows 17 to 23
    Set rowsRange = ws.Rows("16:24")
    
    ' Loop through the rows
    For Each row In rowsRange.Rows
        ' Check if the row is hidden
        If row.Hidden Then
            ' Unhide the row
            row.Hidden = False
        Else
            ' Hide the row
            row.Hidden = True
        End If
    Next row
    
    ' Protect the worksheet again
    ThisWorkbook.Sheets("Transport Cost").Protect password:="Nope"
End Sub

