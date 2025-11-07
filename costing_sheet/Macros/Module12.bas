Attribute VB_Name = "Module12"
Sub RefreshAndLockAllSheets()
    Dim ws As Worksheet
    Dim pwd As String
    Dim isProtected As Boolean
    Dim currentSheet As Worksheet
    
    ' Set the password for protection
    pwd = "Nope"
    
    ' Store the current active sheet
    Set currentSheet = ActiveSheet
    
    ' Disable alerts temporarily
    Application.DisplayAlerts = False
    
    ' Unlock all sheets
    For Each ws In ThisWorkbook.Worksheets
        ' Check if the sheet is protected
        isProtected = ws.ProtectContents
        ' If protected, unprotect the sheet
        If isProtected Then
            ws.Unprotect password:=pwd
        End If
    Next ws
    
    ' Refresh all sheets
    ThisWorkbook.RefreshAll
    
    ' Lock all sheets
    For Each ws In ThisWorkbook.Worksheets
        ' Protect the sheet using the password
        ws.Protect password:=pwd
    Next ws
    
    ' Activate the original active sheet
    currentSheet.Activate
    
    ' Re-enable alerts
    Application.DisplayAlerts = True
End Sub



