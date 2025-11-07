Attribute VB_Name = "Module3"
Sub AddNewRowToTableStock()
    Dim tbl As ListObject
    Dim newRow As ListRow
    Dim ws As Worksheet
    
    ' Unprotect the worksheet
    ThisWorkbook.Sheets("Stock Cost").Unprotect password:="Nope"
    
    ' Assuming your table starts in row 5
    Set ws = ThisWorkbook.Sheets("Stock Cost") ' Change "Sheet1" to your sheet name
    Set tbl = ws.ListObjects("stock_cost") ' Change "Table1" to your table name
    
    ' Add a new row to the table
    Set newRow = tbl.ListRows.Add
    
    ' Optionally, you can select the new row for visibility
    newRow.Range.Select
    
    ' Protect the worksheet again
    ThisWorkbook.Sheets("Stock Cost").Protect password:="Nope"
End Sub


Sub DeleteLastRow()
    Dim tbl As ListObject
    Dim lastRow As ListRow

    ' Unprotect the worksheet
    ThisWorkbook.Sheets("Stock Cost").Unprotect password:="Nope"
    
    ' Specify the table name
    Set tbl = ThisWorkbook.Sheets("Stock Cost").ListObjects("stock_cost")

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
    ThisWorkbook.Sheets("Stock Cost").Protect password:="Nope"
End Sub

