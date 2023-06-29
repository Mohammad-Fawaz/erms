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
Dim sCurList
Dim sRT

If (Request.Form <> "") Then
	'Save Change record
	curRT = Request.Form("RT")
	curRec = Request.Form("CR")
	Select Case curRT
		Case "CR": sRet = WriteRec("Note", "CO", curEID)
		Case "DR": sRet = WriteRec("Note", "DOC", curEID)
		Case "TR": sRet = WriteRec("Note", "TASK", curEID)
	End Select
Else
	curRT = Request.QueryString("RT")
	curRec = Request.QueryString("CR")
End If

Select Case curRT
	Case "CR": sCurList = GetProcInfo("Note", curRec, "CO")
	Case "DR": sCurList = GetProcInfo("Note", curRec, "DOC")
	Case "TR": sCurList = GetProcInfo("Note", curRec, "TASK")
End Select

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Add Note</title>
</head>

<body>

<table border="0" cellpadding="6" width="600" cellspacing="0">
  <tr>
    <td width="100%"><form method="POST" action="add_note.asp">
    <input type="hidden" name="RT" value="<% =Request.QueryString("RT") %>">
    <input type="hidden" name="CR" value="<% =Request.QueryString("CR") %>">
      <table border="0" cellpadding="2" width="100%">
        <tr>
          <td colspan="2" bgcolor="#0075FF"><font face="Verdana" color="#FFFFFF"><strong>Add Note</strong></font></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Note Type:</strong></font></td>
          <td><select name="NType" size="1">
		    <option selected>SELECT</option>
<% =GetSelect("NoteType", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Subject:</strong></font></td>
          <td><input type="text" name="NSubj" size="48"></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Note Text:</strong></font></td>
          <td><textarea rows="6" name="NText" cols="48"></textarea></td>
        </tr>
        <tr>
          <td align="center" colspan="2"><input type="submit" value="Save Note" name="B1"><input
          type="reset" value="Clear Form" name="B2"></td>
        </tr>
      </table>
    </form>
    </td>
  </tr>
  <tr>
    <td width="100%" align="center"><strong><font face="Verdana" size="2"><a href="JavaScript:window.close(this);"
    onMouseOver="window.status = 'Close Window'; return true;">Close Window</a></font></strong></td>
  </tr>
</table>
<% =sRet %>
<p><strong><font face="Verdana" size="3">Current Listings</font></strong></p>

<table border="0" cellpadding="2" width="600">
  <tr>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Date</strong></font></td>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>From</strong></font></td>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Note Type</strong></font></td>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Subject</strong></font></td>
  </tr>
<% =sCurList %>
</table>
</body>
</html>
