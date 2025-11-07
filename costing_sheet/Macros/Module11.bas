Attribute VB_Name = "Module11"
Sub RefreshAllDataConnections()
    Dim conn As WorkbookConnection
    
    On Error GoTo ErrorHandler
    
    ' Refresh all data connections in the workbook
    For Each conn In ThisWorkbook.Connections
        conn.Refresh
    Next conn
    
    MsgBox "All data connections have been refreshed.", vbInformation
    
    Exit Sub

ErrorHandler:
    MsgBox "An error occurred: " & Err.Description, vbCritical
End Sub



