Attribute VB_Name = "Module25"
Sub DeleteRowFromTable()
    Dim ws As Worksheet
    Dim tbl As ListObject
    Dim rowNum As Long
    
    ' Specify the worksheet and table
    Set ws = ThisWorkbook.Sheets("Cash Flow")
    Set tbl = ws.ListObjects("cf_sales")
    
    ' Unprotect the sheet
    ws.Unprotect password:="Nope"
    
    ' Check if there are rows in the table
    If tbl.ListRows.Count > 0 Then
        ' Get the index of the last row in the table
        rowNum = tbl.ListRows.Count
        
        ' Delete the row
        tbl.ListRows(rowNum).Delete
        
        ' Delete cells in columns A:G and BI:BJ from the same row as the table row
        ws.Rows(rowNum).Delete Shift:=xlUp
    Else
        MsgBox "There are no rows to delete in the table.", vbInformation
    End If
    
    ' Protect the sheet again
    ws.Protect password:="Nope"
End Sub

