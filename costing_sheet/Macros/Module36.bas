Attribute VB_Name = "Module36"
Sub ToggleHideRowsstock1()
    Dim ws As Worksheet
    Set ws = ThisWorkbook.Sheets("Stock Cost")
    
    ' Unprotect the sheet
    ws.Unprotect password:="Nope"
    
    ' Check if rows are hidden or not, then toggle their visibility
    If ws.Rows("23:28").Hidden = True Then
        ' If rows 23 to 28 are hidden, unhide them and hide row 1
        ws.Rows("23:28").Hidden = False
        ws.Rows("1:1").Hidden = True
    Else
        ' If rows 23 to 28 are visible, hide them and unhide row 1
        ws.Rows("23:28").Hidden = True
        ws.Rows("1:1").Hidden = False
    End If
    
    ' Protect the sheet again
    ws.Protect password:="Nope"
    
    MsgBox "Rows toggled successfully!", vbInformation
End Sub

