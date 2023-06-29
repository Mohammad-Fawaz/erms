<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
<%
Dim sMode
Dim sHeader
Dim sForm
Dim sItemList
Dim nTempID

'Verify page retrieval method and fill variables
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	If (Request.Form("B1") = "Cancel") Then
		sMode = "N"
	Else
		sMode = Request.Form("Mode")
	End If
	Select Case sMode
		Case "HN": nTempID = SaveTemp("T", ""): sMode = "N"
		Case "HU": nTempID = SaveTemp("F", Request.Form("TID")): sMode = "N"
		Case "IN": SaveTItem "T", "": sMode = "N": nTempID = Request.Form("TID")
		Case "IU": SaveTItem "F", Request.Form("TItem"): sMode = "N": nTempID = Request.Form("TID")
		Case Else: nTempID = Request.Form("TID")
	End Select
Else
	If (Request.QueryString <> "") Then
		sMode = Request.QueryString("M")
		nTempID = Request.QueryString("T")
		If (sMode = "ID") Then sMode = "N": DeleteItem "TItem", Request.QueryString("TI")
	Else
		sMode = "N"
		nTempID = ""
	End If
End If

sHeader = GetTHead(nTempID)
sForm = GetTItemForm(sMode, nTempID)

Response.Write "Mode: "& sMode & "<br>"
Response.Write "TempID : " & nTempID


sItemList = GetTIList(nTempID)

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Create Workflow Template</title>
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
    <td width="635" valign="top"><font face="Verdana" size="5">Create Workflow Template</font>
    <br>
<% =sHeader %>
<% =sForm %>
    <table border="0" cellpadding="2" width="100%">
      <tr>
        <td valign="top" nowrap colspan="6" bgcolor="#000000"><font face="Verdana" size="3" color="#FFFFFF"><strong>Workflow Template Steps</strong></font></td>
      </tr>
      <tr>
        <td valign="top" nowrap bgcolor="#D7D7D7"><font face="Verdana" size="1"> </font></td>
        <td valign="top" nowrap bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Step Num</strong></font></td>
        <td valign="top" nowrap bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Action</strong></font></td>
        <td valign="top" nowrap bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Next Step</strong></font></td>
        <td valign="top" nowrap bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Back Step</strong></font></td>
        <td valign="top" nowrap bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Action Type</strong></font></td>
      </tr>
<% =sItemList %>
    </table>
    <p align="center"><font face="Verdana" size="2"><strong>
    <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
    <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
    <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
    <a href="wf_help.asp">Help Files and Instructions</a></strong></font></p>
    </td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
