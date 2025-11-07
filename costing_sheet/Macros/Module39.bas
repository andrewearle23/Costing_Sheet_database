Attribute VB_Name = "Module39"
Sub ToggleHideColumnslanded()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Stock Cost")
    
    ' Unprotect the sheet
    ws.Unprotect password:="Nope"
    
    ' Check if columns are hidden or not, then toggle their visibility
    If ws.Columns("AA:AK").Hidden = True Then
        ' If columns AA to AK are hidden, unhide them
        ws.Columns("AA:AK").Hidden = False
    Else
        ' If columns AA to AK are visible, hide them
        ws.Columns("AA:AK").Hidden = True
    End If
    
    ' Protect the sheet again
    ws.Protect password:="Nope"
    
    MsgBox "Columns toggled successfully!", vbInformation
End Sub

