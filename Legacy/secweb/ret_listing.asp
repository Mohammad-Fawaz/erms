<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<%
Dim sHead
Dim sList
Dim sParams
Dim sMod
Dim sConst
Dim nPS
Dim sL, sV
Dim bPageChange
Dim x

If (Request.QueryString("PS") <> "") Then
	nPS = Request.QueryString("PS")
Else
	If (Request.Form("PageSize") <> "") Then
		nPS = "1:" & Request.Form("PageSize")
	End If
End If

If (nPS = "") Then
	nPS = "1:50"
End If

If (Request.QueryString("Listing") <> "") Then
	bPageChange = True
	sL = Request.QueryString("Listing")
	sV = IIf(Request.QueryString("V") <> "", Request.QueryString("V"), "")
Else
	bPageChange = False
	If (Request.Form("Listing") <> "") Then
		sL = Request.Form("Listing")
		sV = ""
	End If
End If

x = InStr(1, sV, Chr(37), 1)
If (x > 0) Then
	sV = Replace(sV, Chr(37), "*", 1, -1, 1)
End If

If bPageChange Then
	Select Case sL
		Case "Docs"
			sHead = "Document Listings"
			If (sV <> "") Then
				sParams = "<p><font face='Verdana' size='2'>" & sV & "</font></p>"
				sList = GetListing("Docs", sV, nPS)
			Else
				sParams = "<p><font face='Verdana' size='2'>No Parameters Set...</font></p>"
				sList = GetListing("Docs", "", nPS)
			End If
		Case "Changes"
			sHead = "Change Order Listings"
			If (sV <> "") Then
				sParams = "<p><font face='Verdana' size='2'>" & sV & "</font></p>"
				sList = GetListing("Changes", sV, nPS)
			Else
				sParams = "<p><font face='Verdana' size='2'>No Parameters Set...</font></p>"
				sList = GetListing("Changes", "", nPS)
			End If
		Case Else
			sHead = "Return Listings"
			If (sV <> "") Then
				sParams = "<p><font face='Verdana' size='2'>" & sV & "</font></p>"
				sList = GetListing(sL, sV, nPS)
			Else
				sParams = "<p><font face='Verdana' size='2'>No Parameters Set...</font></p>"
				sList = GetListing(sL, "", nPS)
			End If
	End Select
Else
	Select Case sL
		Case "Docs"
			sHead = "Document Listings"
			sParams = IIf(Request.Form("DocID") <> "", "[Doc ID {LIKE} " & CStr(Request.Form("DocID")) & "]", "")
			sConst = IIf(Request.Form("DocID") <> "", "(Doc ID LIKE '" & CheckSearchString(Request.Form("DocID")) & "*')", "")
			
			sParams = IIf(Request.Form("DocDesc") <> "", IIf(sParams <> "", sParams & "<br>", "") & "[Description {LIKE} " & Request.Form("DocDesc") & "]", sParams)
			sConst = IIf(Request.Form("DocDesc") <> "", IIf(sConst <> "", sConst & " AND ", "") & "(DocDesc LIKE '*" & CheckSearchString(Request.Form("DocDesc")) & "*')", sConst)
			
			Select Case Request.Form("DocStatusMod")
				Case "NotEqual"
					sMod = "<>"
				Case "GT"
					sMod = ">"
				Case "LT"
					sMod = "<"
				Case Else
					sMod = Request.Form("DocStatusMod")
			End Select
			sParams = IIf((Request.Form("DocStatus") <> "") And (Request.Form("DocStatus") <> "SELECT"), IIf(sParams <> "", sParams & "<br>", "") & "[Status " & sMod & " " & Request.Form("DocStatus") & "]", sParams)
			sConst = IIf((Request.Form("DocStatus") <> "") And (Request.Form("DocStatus") <> "SELECT"), IIf(sConst <> "", sConst & " AND ", "") & "(DocStatus " & sMod & " '" & Request.Form("DocStatus") & "')", sConst)
			
			Select Case Request.Form("DocRelDateMod")
				Case "NotEqual"
					sMod = "<>"
				Case "GT"
					sMod = ">"
				Case "LT"
					sMod = "<"
				Case Else
					sMod = Request.Form("DocRelDateMod")
			End Select
			sParams = IIf(Request.Form("DocRelDate") <> "", IIf(sParams <> "", sParams & "<br>", "") & "[Release Date " & sMod & " " & Request.Form("DocRelDate") & "]", sParams)
			sConst = IIf(Request.Form("DocRelDate") <> "", IIf(sConst <> "", sConst & " AND ", "") & "(DocRelDate " & sMod & " #" & Request.Form("DocRelDate") & "#)", sConst)
			
			If (sConst <> "") Then
				sParams = "<p><font face='Verdana' size='2'>" & sParams & "</font></p>"
				sList = GetListing("Docs", sConst, nPS)
			Else
				sParams = "<p><font face='Verdana' size='2'>No Parameters Set...</font></p>"
				sList = GetListing("Docs", "", nPS)
			End If
		Case "Changes"
			sHead = "Change Order Listings"
			sParams = IIf(Request.Form("CO") <> "", "[CO {LIKE} " & Request.Form("CO") & "]", "")
			sConst = IIf(Request.Form("CO") <> "", "(CO LIKE '" & CheckSearchString(Request.Form("CO")) & "*')", "")
			
			Select Case Request.Form("ChTypeMod")
				Case "NotEqual"
					sMod = "<>"
				Case "GT"
					sMod = ">"
				Case "LT"
					sMod = "<"
				Case Else
					sMod = Request.Form("ChTypeMod")
			End Select
			sParams = IIf((Request.Form("ChType") <> "") And (Request.Form("ChType") <> "SELECT"), IIf(sParams <> "", sParams & "<br>", "") & "[Change Type " & sMod & " " & Request.Form("ChType") & "]", sParams)
			sConst = IIf((Request.Form("ChType") <> "") And (Request.Form("ChType") <> "SELECT"), IIf(sConst <> "", sConst & " AND ", "") & "(ChangeType LIKE '" & Request.Form("ChType") & "')", sConst)
			
			Select Case Request.Form("ChStatusMod")
				Case "NotEqual"
					sMod = "<>"
				Case "GT"
					sMod = ">"
				Case "LT"
					sMod = "<"
				Case Else
					sMod = Request.Form("ChStatusMod")
			End Select
			sParams = IIf((Request.Form("ChStatus") <> "") And (Request.Form("ChStatus") <> "SELECT"), IIf(sParams <> "", sParams & "<br>", "") & "[Status " & sMod & " " & Request.Form("ChStatus") & "]", sParams)
			sConst = IIf((Request.Form("ChStatus") <> "") And (Request.Form("ChStatus") <> "SELECT"), IIf(sConst <> "", sConst & " AND ", "") & "(ChStatus LIKE '" & Request.Form("ChStatus") & "')", sConst)
			
			Select Case Request.Form("ChEffDateMod")
				Case "NotEqual"
					sMod = "<>"
				Case "GT"
					sMod = ">"
				Case "LT"
					sMod = "<"
				Case Else
					sMod = Request.Form("ChEffDateMod")
			End Select
			sParams = IIf(Request.Form("ChEffDate") <> "", IIf(sParams <> "", sParams & "<br>", "") & "[Eff Date " & sMod & " " & Request.Form("ChEffDate") & "]", sParams)
			sConst = IIf(Request.Form("ChEffDate") <> "", IIf(sConst <> "", sConst & " AND ", "") & "(ChEffDate " & sMod & " #" & Request.Form("ChEffDate") & "#)", sConst)
			
			If (sConst <> "") Then
				sParams = "<p><font face='Verdana' size='2'>" & sParams & "</font></p>"
				sList = GetListing("Changes", sConst, nPS)
			Else
				sParams = "<p><font face='Verdana' size='2'>No Parameters Set...</font></p>"
				sList = GetListing("Changes", "", nPS)
			End If
		Case Else
			sHead = "Return Listings"
			sParams = "<p><font face='Verdana' size='2'>No Parameters Set...</font></p>"
			sList = ""
	End Select
End If

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMSWeb - <% =sHead %></title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %></td>
    <td width="635" valign="top"><font face="Verdana" size="5"><% =sHead %></font><% =sParams %> 
<%
If (sList <> "") Then
	Response.Write sList
Else
%> <div align="center"><div align="center"><center><table border="2" cellpadding="2" cellspacing="1" width="625">
      <tr>
        <td width="100%" bgcolor="#000000"><font face="Verdana" size="2" color="#FFFFFF"><strong>No
        Records Returned</strong></font></td>
      </tr>
      <tr>
        <td width="100%"><font face="Verdana" size="2">No Data</font></td>
      </tr>
    </table>
    </center></div>
<%
End If
%>
</div><p>&nbsp;</td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
