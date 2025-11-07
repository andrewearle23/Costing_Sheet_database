Attribute VB_Name = "Module5"
Sub ToggleRowsVisibility()
    Dim ws As Worksheet
    Dim rng As Range
    Dim wsProtect As Boolean
    Dim password As String
    Dim row As Range
    
    ' Set reference to the "Cash Flow" worksheet
    Set ws = ThisWorkbook.Sheets("Cash Flow")
    
    ' Check if worksheet is protected
    wsProtect = ws.ProtectContents
    
    ' Unprotect worksheet with password "Nope" if protected
    If wsProtect Then
        password = "Nope"
        ws.Unprotect password
    End If
    
    ' Define the ranges of rows to hide/unhide
    Set rng = Union(ws.Rows("2:28"), ws.Rows("31:34"), ws.Rows("38:39"), ws.Rows("47:49"), ws.Rows("52:56"))
    
    ' Loop through each row and hide/unhide it
    For Each row In rng.Rows
        If row.Hidden Then
            row.Hidden = False ' Unhide the row
        Else
            row.Hidden = True ' Hide the row
        End If
    Next row
    
    ' Protect worksheet again if it was initially protected
    If wsProtect Then
        ws.Protect password
    End If
End Sub

