<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef2.asp" -->
<!-- #INCLUDE FILE="script/incl_info.asp" -->
<html>

<head>
<%
Dim sSec1
Dim sSec2
Dim sSec3
Dim sSec4
Dim sSec5

If (Request.QueryString("Item") <> "") Then
	sSec1 = GetInfoSection("ChangeReqFmt", Request.QueryString("Item"), "", "")
	sSec2 = GetInfoSection("ChangeDesc", Request.QueryString("Item"), "", "")
	sSec3 = GetInfoSection("ChangeAssDoc", Request.QueryString("Item"), "", "")
	sSec4 = GetInfoSection("FmtNotes", Request.QueryString("Item"), "CO", "")
	sSec5 = GetInfoSection("FmtAtt", Request.QueryString("Item"), "COA", "")
Else
	sSec1 = "<p><font face='Verdana' size='2'><strong>CHANGE INFORMATION:</strong> NO DATA RETURNED</strong></font></p>"
	sSec2 = "<p><font face='Verdana' size='2'><strong>DESCRIPTION:</strong> NO DATA RETURNED</strong></font></p>"
	sSec3 = "<p><font face='Verdana' size='2'><strong>ASSOCIATED DOCUMENTS:</strong> NO DATA RETURNED</font></p>"
	sSec4 = "<p><font face='Verdana' size='2'><strong>NOTES:</strong> NO DATA RETURNED</font></p>"
	sSec5 = "<p><font face='Verdana' size='2'><strong>ATTACHMENTS:</strong> NO DATA RETURNED</font></p>"
End If

%>
<link rel="stylesheet" type="text/css" href="pg_style.css">
<title>Printable Waiver/Deviation Form</title>
</head>

<body bgcolor="#FFFFFF">

<table border="0" cellpadding="2" width="660">
  <tr>
    <td><strong><font face="Verdana" size="3">Deviation / Waiver Request</font></strong></td>
    <td align="right"><img src="../graphics/mar_logo_320.gif"></td>
  </tr>
</table>

<table border="1" cellpadding="4" width="660">
  <tr>
    <td width="100%"><% =sSec1 %></td>
  </tr>
  <tr>
    <td width="100%"><% =sSec3 %></td>
  </tr>
  <tr>
    <td width="100%"><!-- #INCLUDE Virtual="/Legacy/fill/dev_fill.htm" --></td>
  </tr>
  <tr>
    <td width="100%"><% =sSec2 %></td>
  </tr>
  <tr>
    <td width="100%"><% =sSec4 %></td>
  </tr>
  <tr>
    <td width="100%"><% =sSec5 %></td>
  </tr>
</table>

<p>&nbsp;</p>

</body>
</html>
