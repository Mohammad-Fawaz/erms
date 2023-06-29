<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
<%
Dim sMode
Dim sForm
Dim sTitle
Dim sAList

'Verify page retrieval method and fill variables
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	If (Request.Form("B1") = "Cancel") Then
		sMode = "N"
	Else
		sMode = Request.Form("Mode")
	End If
	Select Case sMode
		Case "S": SaveAction "T", "": sMode = "N"
		Case "U": SaveAction "F", Request.Form("AID"): sMode = "N"
	End Select
Else
	If (Request.QueryString <> "") Then
		sMode = Request.QueryString("M")
		If (sMode = "AD") Then
			DeleteItem "WFAction", Request.QueryString("A")
			sMode = "N"
		End If
	Else
		sMode = "N"
	End If
End If

'Page Modes
'N					Begin New Entry
'R1 - R?		Refresh Modes
'S	
'Save Entry
Select Case sMode
	Case "RU": sTitle = "Edit/Modify Workflow Action"
	Case Else: sTitle = "New Workflow Action"
End Select
sForm = GetActForm(sMode)

If (sForm = "") Then
	sForm = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while attempting to load the form.</font></p>"
End If

sAList = GetAList()

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Workflow Actions</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  
  <tr>
    <td width="635" valign="top"><font face="Verdana" size="5">New Workflow Action</font>
<% =sForm %>
    <p align="center"><font face="Verdana" size="2"><strong><a href="wf_add_temp.asp">Create
    New Workflow Template</a> &#149; <a href="wf_mod_temp.asp">Open/Modify Workflow Template</a></strong></font></p>
    <p><strong><font face="Verdana" size="3">Workflow Actions</font></strong></p>
<% =sAList %>
    <p align="center">&nbsp;</p>
    <p align="center"><font face="Verdana" size="2"><strong>
    <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
    <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
    <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
    <a href="wf_help.asp">Help Files and Instructions</a></strong></font></p></td>
  </tr>
  
</table>

<p>&nbsp;</p>
</body>
</html>
