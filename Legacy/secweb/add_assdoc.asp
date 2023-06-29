<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef2.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_proc.asp" -->
<html>

<head>
<%
Dim sRet
Dim curRT
Dim curRec
Dim sQString
Dim sCurList
Dim sLVal
Dim sNav
Dim sNav1

sQString = Request.QueryString
sLVal = ""
sNav = ""
sNav1 = ""
If (Request.Form <> "") Then
	'Save Change record
	curRT = Request.QueryString("RT")
	curRec = Request.QueryString("CR")
	Select Case Request.Form("BSub")
		Case "Save Doc"
			sRet = WriteRec("AssDoc", curRec, "")
		Case "Get Info"
			sLVal = Request.Form("ADNum")
			sNav = GetAlertInfo("AssDoc", sLVal)
			If IsNumeric(sNav) Then
				Select Case sNav
					Case "1"
						sNav1 = "<p><font face='Verdana' size='2'>Information for Document Number [<strong>" & sLVal & "</strong>] "
						sNav1 = sNav1 & "could not be located within the system.</font></p>"
					Case "2"
						sNav1 = "<p><font face='Verdana' size='2'>A current Change Request is pending for Document "
						sNav1 = sNav1 & "Number [<strong>" & sLVal & "</strong>].</font></p>"
					Case "3"
						sNav1 = "<p><font face='Verdana' size='2'>Document Number [<strong>" & sLVal & "</strong>] is obsolete "
						sNav1 = sNav1 & "and cannot be changed at this time.</font></p>"
				End Select
				sLVal = ""
				sNav = ""
			End If
		Case "Clear Form"
			sLVal = ""
			sNav = ""
			sNav1 = ""
	End Select
Else
	curRT = Request.QueryString("RT")
	curRec = Request.QueryString("CR")
End If

sCurList = GetProcInfo("AssDoc2", curRec, "")

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Add Associated Document</title>
    <style type="text/css">
        .auto-style1 {
            height: 31px;
        }
    </style>
</head>

<body>
<% =sNav1 %>
<table border="0" cellpadding="6" width="600" cellspacing="0">
  <tr>
    <td width="100%"><form method="POST" action="add_assdoc.asp?<% =sQString %>">
    <input type="hidden" name="RT" value="<% =Request.QueryString("RT") %>">
    <input type="hidden" name="CR" value="<% =Request.QueryString("CR") %>">
      <table border="0" cellpadding="2" width="100%">
        <tr>
          <td colspan="2" bgcolor="#0075FF" class="auto-style1"><font face="Verdana" color="#FFFFFF"><strong style="background-color: #0075FF">Add
          Associated Document</strong></font></td>
        </tr>
        <tr>
          <td align="right"><strong><font face="Verdana" size="2">Document Number:</font></strong></td>
          <td><input type="text" name="ADNum" size="24" value="<% =sLVal %>"> <input type="submit" value="Get Info"
          name="BSub"></td>
        </tr>
<% =sNav %>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>New Revision:</strong></font></td>
          <td><input type="text" name="ADRev" size="5"></td>
        </tr>
        <tr>
          <td align="center" colspan="2"><input type="submit" value="Save Doc" name="BSub"><input
          type="submit" value="Clear Form" name="BSub"></td>
        </tr>
      </table>
    </form>
    </td>
  </tr>
  <tr>
    <td width="100%" align="center"><strong><font face="Verdana" size="2"><a
    href="JavaScript:window.close(this);"
    onMouseOver="window.status = 'Close Window'; return true;">Close Window</a></font></strong></td>
  </tr>
</table>
<% =sRet %>
<p><strong><font face="Verdana" size="3">Current Listings</font></strong></p>

<table border="0" cellpadding="2" width="600">
  <tr>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Document Number</strong></font></td>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Current Rev</strong></font></td>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>New Rev</strong></font></td>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Status</strong></font></td>
  </tr>
<% =sCurList %>
</table>
</body>
</html>
