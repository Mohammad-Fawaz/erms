<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<%
Select Case Request.QueryString("A")
	Case "":
		sBody = GetHTML("Report", "List", "0", "")
	Case "S":
		sBody = GetHTML("Report", "Search", Request.QueryString("ReportID"), "")
	Case "G":
		If (Request.Form("Submit") = "View Online") Then
			If (Request.Form("PageSize") <> "") Then
				nPgSz = "1:" & Request.Form("PageSize")
			Else
				If (Request.QueryString("PS") <> "") Then
					nPgSz = Request.QueryString("PS")
				End If
			End If
			If (nPgSz = "") Then
				nPgSz = "1:50"
			End If
			
			sV = ""
			For Each Field in Request.Form
				If Not (Field  = "ReportID" Or Field = "Submit") Then
					sV = Field & " = '" & Request.Form(Field) & "' AND "
				End If
			Next
			If (sV <> "") Then
				sV = Left(sV, Len(sV) - 5)
			End If
			Response.Redirect("ret_search.asp?Listing=Report&V=" & Request.Form("ReportID") & "|" & sV & "&PS=" & nPgSz)
		ElseIf (Request.Form("Submit") = "Download CSV") Then
			Response.ContentType = "application/csv"
			Response.AddHeader "Content-Disposition", "attachment; filename=report.csv;"
			Set rsReport = GetADORecordset("SELECT Query FROM QReports WHERE ReportID = " & Request.Form("ReportID"), Nothing)
			If Not (rsReport.EOF = True And rsReport.BOF = True) Then
				sSQL = rsReport("Query")
				sSQL = sSQL & IIf(sV <> "", " WHERE " & sV, "")
				Set rsQuery = GetADORecordset(sSQL, Nothing)
				For Each Cell in rsQuery.fields
					Response.Write("""" & Cell.name & """,")
				Next
				Response.Write(vbCrLf)
				While Not (rsQuery.EOF = True)
					For Each Cell in rsQuery.fields
						Response.Write("""" & Cell.value & """,")
					Next
					Response.Write(vbCrLf)
					rsQuery.MoveNext
				Wend
			End If
		End If
End Select

%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Document Information</title>
</head>
<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">
<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr> 
    <td width="100%" colspan="2"> 
      <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
    </td>
  </tr>
  <tr> 
    <td width="145" valign="top" bgcolor="#FFFFC8"> <% =sMenu %> </td>
    <td width="635" valign="top"><p><font face="Verdana" size="5">Reports</font> 
      </p>
      <p>
        <%
	
	If (sBody <> "") Then
		Response.Write(sBody)
	Else
		Response.Write("<font face='Verdana, Arial, Helvetica, sans-serif'>No reports are available.</font>")
	End If
	
	%>
      </p></td> </tr> 
<tr> 
  <td width="100%" colspan="2"> 
    <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
  </td>
</tr></table>
</body>
</html>
