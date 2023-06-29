<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_proc.asp" -->
<html>

<head>
<%
Dim sRet
Dim sQString
Dim curRec
Dim sHead

If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	If (Request.Form("Mode") = "Add") Then
		'Save Change record
		sRet = WriteRec("Change", "A", "")
		curRec = vNewNum
	Else
		sRet = WriteRec("Change", "E", Request.Form("CR"))
		curRec = Request.Form("CR")
	End If
	sQString = "RT=CR&CR=" & curRec
Else
	'Refresh Listings
	If (Request.QueryString <> "") Then
		curRec = Request.QueryString("CR")
		sQString = "RT=CR&CR=" & curRec
	End If
End If

If (curRec <> "") Then
	sHead = "<table border='0' cellpadding='2' width='100%'>"
	sHead = sHead & "  <tr>"
	sHead = sHead & "    <td><font face='Verdana' size='5'>Change Order Request</font></td>"
	sHead = sHead & "    <td align='right'><a href='ret_selitem.asp?Listing=Change&Item=" & curRec & "'><strong><font face='Verdana' size='2'>View Change</a> | <a href='pnt_selitem.asp?Listing=Change&Item=" & curRec & "' target='_blank'>Printable Format</a></font></strong><br>"
	sHead = sHead & "    <a href='pnt_chgreq.asp?Listing=Change&Item=" & curRec & "' target='_blank'><strong><font face='Verdana' size='1'>Printable Change Request Form</font></strong></a><br>"
	sHead = sHead & "    <a href='pnt_dev.asp?Listing=Change&Item=" & curRec & "' target='_blank'><strong><font face='Verdana' size='1'>Printable Waiver/Deviation Form</font></strong></a></td>"
	sHead = sHead & "  </tr>"
	sHead = sHead & "</table>"
Else
	sHead = "<font face='Verdana' size='5'>Change Order Request</font>"
End If

%>
<script language="JavaScript">
<!--
// begin - Info PopUp Window
function iPop(url, idx) { 
	if (idx == "2") {
		window.open(url, "InfoPop", "toolbar=no,width=800,height=600,status=no,scrollbars=yes,resize=yes,menubar=no");
	}
	else {
		window.open(url, "InfoPop", "toolbar=no,width=645,height=600,status=no,scrollbars=yes,resize=yes,menubar=no");
	}
} 
// -->
</script>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>New Change Order Request</title>
    <style type="text/css">
        .auto-style1 {
            height: 26px;
        }
    </style>
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
    <td width="635" valign="top"><% =sHead %>
<%
If (sRet <> "") Then
%>
    <p><font face="Verdana" size="2"><% =sRet %></font></p>
<%
Else
%>
    <p><font face="Verdana" size="2">Please attach file(s) or create associated notes. <strong><a href="req_change1.asp?<% =sQString %>">Refresh Listings</a></strong>.</font></p>
<% =GetProcInfo("Change", curRec, "") %>
    <table border="0" cellpadding="2" width="100%">
      <tr>
        <td width="100%" colspan="4" bgcolor="#000000"><font face="Verdana" color="#FFFFFF"><strong>Associated Documents</strong></font></td>
      </tr>
      <tr>
        <td bgcolor="#C0C0C0" class="auto-style1"><font face="Verdana" size="2"><strong>Document Number</strong></font></td>
        <td bgcolor="#C0C0C0" class="auto-style1"><font face="Verdana" size="2"><strong>Current Rev</strong></font></td>
        <td bgcolor="#C0C0C0" class="auto-style1"><font face="Verdana" size="2"><strong>New Rev</strong></font></td>
        <td bgcolor="#C0C0C0" class="auto-style1"><font face="Verdana" size="2"><strong>Status</strong></font></td>
      </tr>
<% =GetProcInfo("AssDoc1", curRec, "") %>
      <tr>
        <td colspan="4" bgcolor="#FFFFC8"><font face="Verdana" size="2"><strong>
        <a href="javascript:iPop('add_assdoc.asp?<% =sQString %>', '1')" onMouseOver="window.status = 'Add Associated Documents'; return true;">Add Associated Documents</a></strong></font></td>
      </tr>
    </table>
    <table border="0" cellpadding="2" width="100%">
      <tr>
        <td width="100%" colspan="2" bgcolor="#000000"><font face="Verdana" color="#FFFFFF"><strong>Attached Files</strong></font></td>
      </tr>
      <tr>
        <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>File Name</strong></font></td>
        <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Description</strong></font></td>
      </tr>
<% =GetProcInfo("Att1", curRec, "COA") %>
      <tr>
        <td width="100%" colspan="2" bgcolor="#FFFFC8"><font face="Verdana" size="2"><strong>
        <a href="javascript:iPop('add_att.asp?<% =sQString %>', '1')" onMouseOver="window.status = 'Add File Attachments'; return true;">Add File Attachments</a></strong></font></td>
      </tr>
    </table>
    <table border="0" cellpadding="2" width="100%">
      <tr>
        <td width="100%" colspan="4" bgcolor="#000000"><font face="Verdana" color="#FFFFFF"><strong>Notes</strong></font></td>
      </tr>
      <tr>
        <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Date</strong></font></td>
        <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>From</strong></font></td>
        <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Note Type</strong></font></td>
        <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Subject</strong></font></td>
      </tr>
<% =GetProcInfo("Note", curRec, "CO") %>
      <tr>
        <td bgcolor="#FFFFC8" colspan="4"><font face="Verdana" size="2"><strong>
        <a href="javascript:iPop('add_note.asp?<% =sQString %>', '1')" onMouseOver="window.status = 'Add Notes'; return true;">Add Notes</a></strong></font></td>
      </tr>
    </table>
<%
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
