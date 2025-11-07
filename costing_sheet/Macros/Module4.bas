Attribute VB_Name = "Module4"
Sub AddNewRowToTableadhoc()
    Dim tbl As ListObject
    Dim newRow As ListRow
    Dim ws As Worksheet
    Dim lastRow As Long
    
    ' Unprotect the worksheet
    ThisWorkbook.Sheets("AD Hoc Cost").Unprotect password:="Nope"
    
    ' Assuming your table starts in row 5
    Set ws = ThisWorkbook.Sheets("AD Hoc Cost") ' Change "Sheet1" to your sheet name
    Set tbl = ws.ListObjects("ad_hoc_cost") ' Change "Table1" to your table name
    
    ' Add a new row to the table
    Set newRow = tbl.ListRows.Add
    
    ' Get the last row of the table
    lastRow = tbl.Range.row + tbl.Range.Rows.Count
    
    ' Protect the worksheet again
    ThisWorkbook.Sheets("AD Hoc Cost").Protect password:="Nope"
End Sub


Sub DeleteLastRowadhoc()
    Dim tbl As ListObject
    Dim lastRow As ListRow

    ' Unprotect the worksheet
    ThisWorkbook.Sheets("Ad Hoc Cost").Unprotect password:="Nope"
    
    ' Specify the table name
    Set tbl = ThisWorkbook.Sheets("Ad Hoc Cost").ListObjects("ad_hoc_cost")

    ' Check if there are rows in the table
    If tbl.ListRows.Count > 0 Then
        ' Get the last row
        Set lastRow = tbl.ListRows(tbl.ListRows.Count)

        ' Delete the last row
        lastRow.Delete
    Else
        MsgBox "Table is empty!"
    End If
    
    ' Protect the worksheet again
    ThisWorkbook.Sheets("Ad Hoc Cost").Protect password:="Nope"
End Sub

