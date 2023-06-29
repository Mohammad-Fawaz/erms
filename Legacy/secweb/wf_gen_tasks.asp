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
Dim sInst
Dim sRefType, sRef

sRefType = ""
sRef = ""
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	If (Request.Form("B1") = "Cancel") Then
		sMode = "NR"
	Else
		sMode = Request.Form("Mode")
		sRefType = Request.Form("RT")
		sRef = Request.Form("RID")
	End If
	Select Case sMode
		Case "N2"
			If (Request.Form("RID") <> "") Then
				sRefType = Request.Form("RT")
				sRef = Request.Form("RID")
				'Test for complete, specific ID. If only one record is returned, modify Mode to reference next step.
				sMode = TestGenMode(sRefType, sRef)
			Else
				sRefType = Request.Form("RT")
				'Test for available items.
				sMode = TestGenMode(sRefType, "")
			End If
	End Select
Else
	If (Request.QueryString <> "") Then
		If ((Request.QueryString("RT") <> "") And (Request.QueryString("R") <> "")) Then
			sMode = "SR"
			sRefType = Request.QueryString("RT")
			sRef = Request.QueryString("R")
		Else
			If (Request.QueryString("RT") <> "") Then
				sMode = "N1"
				sRefType = Request.QueryString("RT")
			Else
				sMode = "NR"
			End If
		End If
	Else
		sMode = "NR"
	End If
End If

Select Case sMode
	Case "NR"
		sTitle = "Select Reference Item"
		sInst = "Workflow tasks must reference an item such as a document or change order. Please select the item type to reference."
	Case "N1", "N2"
		sTitle = "Select Reference Item"
		sInst = "Please complete the item reference by selecting the specific item to be referenced by the workflow tasks."
	Case "N1A"
		sTitle = "Select Reference Item"
		sInst = "<strong>ERROR:</strong> No items were found to reference. Please complete the item reference by selecting a different item type."
		sRefType = ""
	Case "SR"
		sTitle = "Select Template"
		sInst = "Please select a template to begin the process. You will have the opportunity to define the workflow tasks in the next step."
	Case "S1"
		sTitle = "Provide Defaults"
		sInst = "Please provide default values. You will have the opportunity to create tasks in the next steps."
End Select

sForm = GetGenTaskForm(sMode, sRefType, sRef)
'If (sForm = "") Then
'	sForm = "<p><b>Mode:</b> " & sMode & "<br>"
'	sForm = sForm & vbCrLf & "<b>Ref Type:</b> " & sRefType & "<br>"
'	sForm = sForm & vbCrLf & "<b>Ref ID:</b> " & sRef & "</p>"
'End If

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Generate Workflow Tasks</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
    <td width="635" valign="top"><font face="Verdana" size="5"><% =sTitle %></font>
    <p><font face="Verdana" size="2"><% =sInst %></font></p>
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
