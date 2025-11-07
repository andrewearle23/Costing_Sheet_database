Attribute VB_Name = "Module10"
Sub ExportToPDFAndEmailsgltrans()
    Dim ws As Worksheet
    Dim overviewSheet As Worksheet
    Dim pdfFileName As String
    Dim savePath As String
    Dim index As Integer
    
    ' Set the path to save the PDF dynamically based on the current user's name
    savePath = "C:\Users\" & Environ("UserName") & "\Hodari Group\Pure Trade - Pure Trade Africa Sales\0. Active Sales\1. Active Sales\6. Quotes (From Deal Sheet)\"

    ' Set reference to the worksheet
    Set ws = ThisWorkbook.Sheets("Quo (Sgl) Trans")
    
    ' Unprotect the sheet with password "nope"
    ws.Unprotect password:="Nope"
    
    ' Get the overview sheet
    Set overviewSheet = ThisWorkbook.Sheets("Overview")

    ' Get the file name from cell B2 of the overview sheet
    pdfFileName = savePath & overviewSheet.Range("B2").Value
    
    ' Check if the file already exists and increment index if necessary
    index = 1
    Do While Dir(pdfFileName & " - " & index & ".pdf") <> ""
        index = index + 1
    Loop

    ' Append index to the filename
    pdfFileName = pdfFileName & " - " & index & ".pdf"

    ' Export the sheet to PDF
    ws.ExportAsFixedFormat Type:=xlTypePDF, fileName:=pdfFileName, Quality:=xlQualityStandard

    ' Protect the sheet again if needed
    ws.Protect password:="Nope"

    ' Create email draft and attach the PDF
    send_email_signature pdfFileName
    
    ' Call RecordQuoteDetails macro
    RecordQuoteDetails pdfFileName
    
End Sub



Sub RecordQuoteDetails(ByVal pdfFileName As String)
    Dim overviewSheet As Worksheet
    Dim quoteSheet As Worksheet
    Dim quoSheet As Worksheet
    Dim salesSheet As Worksheet
    Dim quoteNo As String
    Dim quoteCreated As Date
    Dim quoteExpired As Date
    Dim quoteType As String
    Dim quant As Double
    Dim sales As Double
    Dim costOfSales As Double
    Dim grossProfit As Double
    Dim protectPassword As String
    Dim versionCount As Integer

    ' Set the password for protecting the sheets
    protectPassword = "Nope"
    
    ' Unprotect the sheets
    Set overviewSheet = ThisWorkbook.Sheets("Overview")
    Set quoteSheet = ThisWorkbook.Sheets("Sheet4")
    Set quoSheet = ThisWorkbook.Sheets("Quo (Sgl) Trans")
    Set salesSheet = ThisWorkbook.Sheets("Sales Tbls - One Prod")
    
    overviewSheet.Unprotect password:=protectPassword
    quoSheet.Unprotect password:=protectPassword
    salesSheet.Unprotect password:=protectPassword
    quoteSheet.Unprotect password:=protectPassword
    
    ' Retrieve data from respective cells
    quoteNo = overviewSheet.Range("D6").Value
    quoteCreated = quoSheet.Range("F7").Value
    quoteExpired = quoSheet.Range("F8").Value
    quoteType = quoSheet.Name
    quant = salesSheet.Range("E5").Value
    sales = salesSheet.Range("G8").Value
    costOfSales = salesSheet.Range("G10").Value
    grossProfit = salesSheet.Range("G21").Value
    
    ' Ensure that the "quote" table exists
    If Not quoteSheet.ListObjects("quote") Is Nothing Then
        ' Add a new row to the "quote" table at the first position
        quoteSheet.ListObjects("quote").ListRows.Add Position:=1
        
        ' Record data in the first row of the "quote" table
        With quoteSheet.ListObjects("quote")
            .ListRows(1).Range.Cells(1, 1).Value = quoteNo ' Quote No.
            .ListRows(1).Range.Cells(1, 2).Value = quoteCreated ' Quote Created
            .ListRows(1).Range.Cells(1, 3).Value = quoteExpired ' Quote Expired
            .ListRows(1).Range.Cells(1, 4).Value = quoteType ' Type
            .ListRows(1).Range.Cells(1, 5).Value = quant ' Quantity
            .ListRows(1).Range.Cells(1, 6).Value = sales ' Sales
            .ListRows(1).Range.Cells(1, 7).Value = costOfSales ' Cost of Sales
            .ListRows(1).Range.Cells(1, 8).Value = grossProfit ' Gross Profit
        End With
    Else
        MsgBox "The 'quote' table was not found on the 'Sheet4'.", vbExclamation
    End If
    
    ' Protect the sheets
    overviewSheet.Protect password:=protectPassword
    quoSheet.Protect password:=protectPassword
    salesSheet.Protect password:=protectPassword
    
    ' Inform the user
    MsgBox "Quote details recorded successfully.", vbInformation
End Sub


Sub send_email_signature(ByVal pdfFileName As String)
    Dim outlook_App As Object
    Dim msg As Object
    Dim sign As String
    Dim recipientName As String
    Dim sh As Worksheet
    Dim quoValid As String
    Dim overviewSheet As Worksheet
    
    ' Get the overview sheet
    Set overviewSheet = ThisWorkbook.Sheets("Overview")

    ' Set reference to the worksheet
    Set sh = ThisWorkbook.Sheets("Quo (Sgl) Trans")
    
    ' Get the quote No. from cell F8 of the Quo (Sgl) Prod sheet
    quoValid = sh.Range("F8").Value

    ' Get the recipient name to use in the email's greeting
    recipientName = sh.Range("L17").Value
    
    ' Unprotect the worksheet
    sh.Unprotect password:="Nope"

    ' Create Outlook application object
    Set outlook_App = CreateObject("Outlook.Application")
    
    ' Create a new email message
    Set msg = outlook_App.createitem(0)
    
    ' Display the email message
    msg.display

    ' Get the email signature from the message body
    sign = msg.htmlbody
    
    ' Update the email message with recipient name and signature
    With msg
        .To = "" ' Add recipient's email address here
        .CC = "" ' Add CC email address here if needed
        .Subject = "PureTrade Africa Quote"
        .htmlbody = "Dear " & recipientName & ",<br><br>" & _
                    "Please find the quote for " & " attached above.<br><br>" & _
                    "Quote is valid until " & quoValid & "<br><br>" & sign
                    
        ' Attach the PDF file
        .Attachments.Add pdfFileName

        .display
    End With

End Sub



