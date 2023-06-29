<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
<%
Dim sMode
Dim nUpdID
Dim sPageTitle
Dim sForm

If (Request.QueryString <> "") Then
	sMode = Request.QueryString("M")
	nUpdID = Request.QueryString("T")
	sPageTitle = "Modify Workflow Template"
Else
	sMode = "N"
	nUpdID = ""
	sPageTitle = "New Workflow Template"
End If

sForm = GetTempForm(sMode, nUpdID)
If (sForm = "") Then
	sForm = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while attempting to load the form controls.</font></p>"
End If

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title><% =sPageTitle %></title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
      <td width="635" valign="top"><font face="Verdana" size="5"><% =sPageTitle %></font>
    <p><font face="Verdana" size="2">Please provide the following information to create the record. You
    will have an opportunity to define workflow actions after submitting this portion of the
    data.</font></p>
<% =sForm %>
    <p>&nbsp;</p>
    <p align="center"><font face="Verdana" size="2"><strong>
    <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
    <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
    <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
    <a href="wf_help.asp">Help Files and Instructions</a></strong></font></p></td>
  </tr>  
</table>
</body>
</html>
