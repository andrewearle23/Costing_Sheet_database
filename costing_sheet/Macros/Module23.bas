Attribute VB_Name = "Module23"
Sub AddRowToTable()
    Dim ws As Worksheet
    Dim tbl As ListObject
    Dim newRow As ListRow
    Dim lastRow As Long
    
    ' Specify the worksheet and table
    Set ws = ThisWorkbook.Sheets("Cash Flow")
    Set tbl = ws.ListObjects("cf_sales")
    
    ' Unprotect the sheet
    ws.Unprotect password:="Nope"
    
    ' Add a new row to the table
    Set newRow = tbl.ListRows.Add
    
    ' Get the index of the last row in the table
    lastRow = newRow.index
    
    ' Insert cells in columns A:G and BI:BJ from the same row as the table row
    ws.Rows(lastRow).Insert Shift:=xlDown
    
    ' Protect the sheet again
    ws.Protect password:="Nope"
End Sub


