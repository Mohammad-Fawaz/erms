<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef2.asp" -->
<!-- #INCLUDE FILE="script/incl_glovia.asp" -->
<html>

<head>
<%
Dim sRpt
Dim sErr

sErr = ""

If (Request.QueryString("BP") <> "") Then
	sRpt = GetBOMRpt(Request.QueryString("BP") & "*")
Else
	If (Request.Form("BOMItem") <> "") Then
		If Not (InStr(1, Request.Form("BOMItem"), "*", 1) > 0) Then
			sRpt = GetBOMRpt(Request.Form("BOMItem") & "*")
		Else
			sRpt = GetBOMRpt(Request.Form("BOMItem"))
		End If
		'sRpt = TestDB(Request.Form("BOMItem"))
	Else
		sErr = "    <p><font face='Verdana' size='5'>Bills of Material Report</font><br><font face='Verdana' size='3'>NO PARAMETER SET: You must provide a partial [Assembly] number to view BOM Report information.</font></p>"
	End If
End If

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Bills of Material Report</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td>
<%
If (sErr <> "") Then Response.Write sErr
If (sErr <> "") Then Response.Write sRpt
%>
    </td>
  </tr>
    <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>