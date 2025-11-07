Attribute VB_Name = "Module41"
Sub RefreshSheetDataShared()

    Dim ws As Worksheet
    Dim wsName As String
    Dim password As String
    Dim sheetFound As Boolean
    Dim qt As QueryTable
    Dim lo As ListObject
    
    wsName = "Average Payment Days"   ' <--- Change to your sheet name
    password = "Nope" ' <--- Change to your actual password
    sheetFound = False
    
    ' Look for the sheet to avoid errors
    For Each ws In ThisWorkbook.Sheets
        If ws.Name = wsName Then
            sheetFound = True
            Exit For
        End If
    Next ws
    
    If Not sheetFound Then
        MsgBox "Sheet '" & wsName & "' was not found in the workbook.", vbCritical
        Exit Sub
    End If

    ' Attempt to unprotect workbook (if applicable)
    On Error Resume Next
    ThisWorkbook.Unprotect password:=password
    On Error GoTo 0

    ' Try to unhide the sheet (even if it's very hidden)
    On Error Resume Next
    ws.Visible = xlSheetVisible
    If Err.Number <> 0 Then
        MsgBox "Could not unhide the sheet. It may be protected or workbook structure may be locked.", vbExclamation
        Exit Sub
    End If
    On Error GoTo 0

    ' Unprotect the sheet
    On Error Resume Next
    ws.Unprotect password:=password
    On Error GoTo 0

    ' Refresh QueryTables (older style)
    For Each qt In ws.QueryTables
        On Error Resume Next
        qt.Refresh BackgroundQuery:=False
        On Error GoTo 0
    Next qt

    ' Refresh ListObjects with Power Query connections
    For Each lo In ws.ListObjects
        On Error Resume Next
        If Not lo.QueryTable Is Nothing Then
            lo.QueryTable.Refresh BackgroundQuery:=False
        End If
        On Error GoTo 0
    Next lo

    ' Update timestamp
    ws.Range("C2").Value = Format(Now, "dd-mm-yyyy")

    ' Reprotect the sheet and workbook
    On Error Resume Next
    ws.Protect password:=password
    ThisWorkbook.Protect password:=password
    On Error GoTo 0

    MsgBox "Average Payment Days Updated"
End Sub

