<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef2a.asp" -->
<!-- #INCLUDE FILE="script/incl_bom.asp" -->
<html>

<head>
<%
Dim sTitle
Dim bDisplay
Dim sRPT

'Verify page retrieval method and fill variables
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	Select Case Request.Form("RFmt")
		Case "StdBOM": sTitle = "Standard BOM Report"
		Case "BItemEff": sTitle = "BOM Item Effectivity Report"
		Case "CostBOM": sTitle = "Standard Costed BOM Report"
	End Select
	bDisplay = True
Else
	sTitle = "Report Error"
	bDisplay = False
End If

If (bDisplay = True) Then
	If (Request.Form("BItemID") <> "") Then
		sRPT = GetEBRpt(Request.Form("BItemID"), Request.Form("RFmt"))
	End If
Else
	sRPT = "<p><font face='Verdana' size='3'>REPORT ERROR</font></p>"
End If

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMS BOM Report</title>
</head>

<body bgcolor="#FFFFFF">

<table border="0" cellpadding="2" width="660">
  <tr>
    <td><strong><font face="Verdana" size="3"><% =sTitle %></font></strong></td>
    <td align="right"><img src="../graphics/mar_logo_320.gif"></td>
  </tr>
</table>

<% =sRPT %>

<p>&nbsp;</p>

</body>
</html>
