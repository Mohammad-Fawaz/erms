<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_glovia.asp" -->
<html>

<head>
<%
Dim sRpt
Dim bDisplayForm
Dim sErr

sErr = ""

If (Request.QueryString("BP") <> "") Then
	bDisplayForm = False
	sRpt = GetBOMRpt(Request.QueryString("BP") & "*")
Else
	bDisplayForm = True
	If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
		If (Request.Form("BOMItem") <> "") Then
			bDisplayForm = False
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
End If

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Display BOM Information</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %>
</td>
    <td width="635" valign="top">
<%
If (bDisplayForm = True) Then
%>
    <font face="Verdana" size="5">Display BOM Report</font>
    <p><font face="Verdana" size="2">Please provide a partial [Assembly] number to view BOM Report information. You may use an asterisk [*] as a wildcard character.</font></p>
    <form method="POST" action="glov_bom.asp">
      <div align="center"><center><table border="0" cellpadding="2" cellspacing="0">
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Assembly:</strong></font></td>
          <td valign="top"><input type="text" name="BOMItem" size="20"></td>
        </tr>
        <tr>
          <td align="right" valign="top"></td>
          <td valign="top"><input type="submit" value="Display Report" name="B1"> </td>
        </tr>
      </table>
      </center></div>
    </form>
<%
	If (sErr <> "") Then Response.Write sErr
Else
	Response.Write sRpt
End If
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
