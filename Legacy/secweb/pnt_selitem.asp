<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef2.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<%
Dim sHead
Dim sList
Dim vOpt

Select Case Request.QueryString("Listing")
	Case "Change"
		sHead = "Change Order Information"
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Change", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Change", "0", "")
		End If
	Case "Doc"
		sHead = "Document Information"
		If (Request.QueryString("Opt") <> "") Then
			vOpt = Request.QueryString("Opt")
		Else
			vOpt = ""
		End If
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Doc", CStr(Request.QueryString("Item")), vOpt)
		Else
			sList = GetHTML("SelItem", "Doc", "0", vOpt)
		End If
	Case "Order"
		sHead = "Order Information"
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Order", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Order", "0", "")
		End If
	Case "Part"
		sHead = "Part Information"
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Part", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Part", "0", "")
		End If
	Case "Project"
		sHead = "Project Information"
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Project", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Project", "0", "")
		End If
	Case "QAction"
		sHead = "Quality Action Information"
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "QAction", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "QAction", "0", "")
		End If
	Case "Task"
		sHead = "Task Information"
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Task", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Task", "0", "")
		End If
	Case Else
		sHead = "Item Information"
		sList = ""
End Select

%>
<script language="JavaScript">
<!--
// begin - Info PopUp Window
function iPop(url) { 
	window.open(url, "InfoPop", "toolbar=no,width=800,height=600,status=no,scrollbars=yes,resize=yes,menubar=no");
} 
// -->
</script>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMSWeb - <% =sHead %></title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" width="660">
  <tr>
    <td><strong><font face="Verdana" size="3"><% =sHead %></font></strong></td>
    <td align="right"><img src="../graphics/mar_logo_320.gif"></td>
  </tr>
</table>

<% 
If (sList <> "") Then
	Response.Write sList
Else
%> 
<div>

<table border="2" cellpadding="2" cellspacing="1" width="660">
  <tr>
    <td width="100%" bgcolor="#0075FF"><font face="Verdana" size="2" color="#FFFFFF"><strong>No
    Records Returned</strong></font></td>
  </tr>
  <tr>
    <td width="100%"><font face="Verdana" size="2">No Data</font></td>
  </tr>
</table>
<%
End If
%>
</div>

<p>&nbsp;</p>
</body>
</html>
