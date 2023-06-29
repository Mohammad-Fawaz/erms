<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head><%
Dim sMode
Dim sForm
Dim sMList
Dim sGList
Dim nG

'Verify page retrieval method and fill variables
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	If (Request.Form("B1") = "New Group") Then
		sMode = "G"
		nG = ""
	Else
		sMode = Request.Form("Mode")
	End If
	Select Case sMode
		Case "GN": nG = SaveGroup("T", ""): sMode = "M"
		Case "GU": nG = SaveGroup("F", Request.Form("GID")): sMode = "M"
		Case "MN": SaveGMemb "T", "": sMode = "M": nG = Request.Form("GID")
		Case "MU": SaveGMemb "F", Request.Form("MID"): sMode = "M": nG = Request.Form("GID")
	End Select
Else
	If (Request.QueryString <> "") Then
		Select Case sMode
			Case "GD": DeleteItem "Group", Request.QueryString("G"): sMode = "G": nG = ""
			Case "MD": DeleteItem "GMemb", Request.QueryString("GM"): sMode = "M": nG = Request.QueryString("G")
			Case Else: sMode = Request.QueryString("M"): nG = Request.QueryString("G")
		End Select
	Else
		sMode = "G"
		nG = ""
	End If
End If

sForm = GetGForm(sMode, nG)
If (sMode = "G") Then sMList = "" Else sMList = GetGMList(nG)
sGList = GetGList()

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Workflow Routing Groups</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  
    <td width="635" valign="top"><font face="Verdana" size="5">Workflow Routing Groups</font>
    <p><font face="Verdana" size="2">These groups provide the basis for workflow assignments
    by allowing single selections to generate multiple concurrent workflow tasks.</font></p>
<% =sForm %>
<% =sMList %>
    <p><strong><font face="Verdana" size="3">Workflow Routing Groups</font></strong></p>
    <table border="0" cellpadding="2" cellspacing="0" width="100%">
      <tr>
        <td bgcolor="#D7D7D7"><font face="Verdana" size="1">&nbsp;</font></td>
        <td bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Type</strong></font></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Group Name</font></strong></td>
      </tr>
<% =sGList %>
    </table>
    <p align="center"><font face="Verdana" size="2"><strong>
    <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
    <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
    <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
    <a href="wf_help.asp">Help Files and Instructions</a></strong></font></p>
    <p>&nbsp;</td>
  </tr>  
</table>
</body>
</html>
