<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<%
Dim sList
Dim sDType

sList = ""

'Select Case Request.QueryString("A")
'	Case "D"
		'Delete record
		
'End Select

sDType = GetDataValue("SELECT DocType AS RetVal FROM Documents WHERE DocID = '" & Request.QueryString("Item") & "'", Nothing)
If (Application("Company") = "Micropac") And (sDType <> "") Then
	Select Case sDType
		Case "484", "485", "486":
			sList = GetHTML("SelItem", "DocElement", Request.QueryString("Item"), "")
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
    <td width="635" valign="top"><font face="Verdana" size="5"><% =sHead %></font><p>
<%
If (sList <> "") Then
	Response.Write sList
Else
%> </p>
    <div align="center"><div align="center"><center><table border="2" cellpadding="2" cellspacing="1" width="625">
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