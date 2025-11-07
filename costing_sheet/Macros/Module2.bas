Attribute VB_Name = "Module2"
Sub HideUnhideColumns()
    Dim ws As Worksheet
    Dim col As Range
    
    ' Unprotect the worksheet
    ThisWorkbook.Sheets("Ad Hoc Cost").Unprotect password:="Nope"
    
    ' Set the worksheet object
    Set ws = ThisWorkbook.Sheets("Ad Hoc Cost") ' Change "Sheet1" to your sheet name
    
    ' Loop through columns S to Y
    For Each col In ws.Columns("S:Y")
        ' Check if the column is hidden
        If col.Hidden Then
            ' Unhide the column
            col.Hidden = False
        Else
            ' Hide the column
            col.Hidden = True
        End If
    Next col
    
    ' Protect the worksheet again
    ThisWorkbook.Sheets("Ad Hoc Cost").Protect password:="Nope"
End Sub


