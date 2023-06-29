<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<%
Dim sMode
Dim sForm

If (Request.QueryString("Mode") <> "") Then
	If (Request.QueryString("Mode") = "E") Then
		sMode = "Edit"
	Else
		sMode = "Add"
	End If
Else
	sMode = "Add"
End If

If (sMode = "Add") Then
	sForm = "      <table border='0' cellpadding='2' cellspacing='0'>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><strong><font face='Verdana' size='2'>Requested By:</font></strong></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChReqBy' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected value='" & curEID & "'>" & curUN & "</option>"
	sForm = sForm & vbCrLf & GetSelect("EmpList", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Change Class:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChClass' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected>SELECT</option>"
	sForm = sForm & vbCrLf & GetSelect("ChClass", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Change Type:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChType' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected>SELECT</option>"
	sForm = sForm & vbCrLf & GetSelect("ChType", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChProj' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected>SELECT</option>"
	sForm = sForm & vbCrLf & GetSelect("Project1", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChPrior' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected>SELECT</option>"
	sForm = sForm & vbCrLf & GetSelect("ChPriority", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Justification:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChJust' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected>SELECT</option>"
	sForm = sForm & vbCrLf & GetSelect("ChJustification", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Charge Number:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='text' name='Acct' size='20'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Effective / Start Date:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='text' name='ChEff' size='15'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Due / End Date:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='text' name='ChDue' size='15'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><textarea rows='3' name='ChDesc' cols='54'></textarea></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='submit' value='Continue Request' name='B1'> <input type='reset' value='Reset Form' name='B2'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "      </table>"
Else
	Dim sRecSQL
	Dim rsCO
	Dim sVal1, sVal2, sVal3, sVal4, sVal5, sVal6, sVal7, sVal8, sVal9, sVal10, sVal11, sVal12, sVal13, sVal14, sVal15, sVal16
	
	'Retrieve change record for field fills
	sRecSQL = "SELECT CO, ChReqBy, ChangeClass, ChClass, ChangeType, ChType, ProjNum, Project, "
	sRecSQL = sRecSQL & "ChPriority, Priority, ChJustification, Justification, ChEffDate, ChDue, ChangeDesc "
	sRecSQL = sRecSQL & "FROM ViewChanges WHERE (CO = " & Request.QueryString("CR") & ")"
	Set rsCO = GetADORecordset(sRecSQL, Nothing)
	sVal1 = IIf(IsNull(rsCO("ChReqBy")), "SELECT", rsCO("ChReqBy"))
	sVal2 = IIf(IsNull(rsCO("ChangeClass")), "SELECT", rsCO("ChangeClass"))
	sVal3 = IIf(IsNull(rsCO("ChClass")), "SELECT", rsCO("ChClass"))
	sVal4 = IIf(IsNull(rsCO("ChangeType")), "SELECT", rsCO("ChangeType"))
	sVal5 = IIf(IsNull(rsCO("ChType")), "SELECT", rsCO("ChType"))
	sVal6 = IIf(IsNull(rsCO("ProjNum")), "SELECT", rsCO("ProjNum"))
	sVal7 = IIf(IsNull(rsCO("Project")), "SELECT", rsCO("Project"))
	sVal8 = IIf(IsNull(rsCO("ChPriority")), "SELECT", rsCO("ChPriority"))
	sVal9 = IIf(IsNull(rsCO("Priority")), "SELECT", rsCO("Priority"))
	sVal10 = IIf(IsNull(rsCO("ChJustification")), "SELECT", rsCO("ChJustification"))
	sVal11 = IIf(IsNull(rsCO("Justification")), "SELECT", rsCO("Justification"))
	sVal12 = IIf(IsNull(rsCO("ChEffDate")), "", rsCO("ChEffDate"))
	sVal13 = IIf(IsNull(rsCO("ChDue")), "", rsCO("ChDue"))
	sVal14 = IIf(IsNull(rsCO("ChangeDesc")), "", rsCO("ChangeDesc"))
	
	If (sVal1 <> "SELECT") Then sVal15 = GetDataValue("SELECT EmpID AS RetVal FROM UserXRef WHERE (ULNF = '" & sVal1 & "')", Nothing) Else sVal15 = ""
	sVal16 = GetDataValue("SELECT UDF1 AS RetVal FROM CustomUDF WHERE (RefType = 'CO') AND (RefID = '" & Request.QueryString("CR") & "')", Nothing)
	
	'Destroy recordset object
	Set rsCO = Nothing
	
	'Set current values into fields
	sForm = "      <table border='0' cellpadding='2' cellspacing='0'>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Change Number:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & Request.QueryString("CR") & "</font></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><strong><font face='Verdana' size='2'>Requested By:</font></strong></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChReqBy' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected value='" & sVal15 & "'>" & sVal1 & "</option>"
	sForm = sForm & vbCrLf & GetSelect("EmpList", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Change Class:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChClass' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected value='" & sVal2 & "'>" & sVal3 & "</option>"
	sForm = sForm & vbCrLf & GetSelect("ChClass", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Change Type:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChType' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected value='" & sVal4 & "'>" & sVal5 & "</option>"
	sForm = sForm & vbCrLf & GetSelect("ChType", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChProj' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected value='" & sVal6 & "'>" & sVal7 & "</option>"
	sForm = sForm & vbCrLf & GetSelect("Project1", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChPrior' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected value='" & sVal8 & "'>" & sVal9 & "</option>"
	sForm = sForm & vbCrLf & GetSelect("ChPriority", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Justification:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><select name='ChJust' size='1'>"
	sForm = sForm & vbCrLf & "            <option selected value='" & sVal10 & "'>" & sVal11 & "</option>"
	sForm = sForm & vbCrLf & GetSelect("ChJustification", "")
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Charge Number:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='text' name='Acct' size='20' value='" & sVal16 & "'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Effective / Start Date:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='text' name='ChEff' size='15' value='" & sVal12 & "'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Due / End Date:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='text' name='ChDue' size='15' value='" & sVal13 & "'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><textarea rows='3' name='ChDesc' cols='54'>" & sVal14 & "</textarea></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top' nowrap></td>"
	sForm = sForm & vbCrLf & "          <td valign='top'><input type='submit' value='Continue Request' name='B1'> <input type='reset' value='Reset Form' name='B2'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "      </table>"
End If

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>New Change Order Request</title>
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
    <p><font face="Verdana" size="5">New Change Order Request</font></p>
    <p><font face="Verdana" size="2">Please provide the following information to create the
    record. You will have an opportunity to attach file(s) after submitting this portion of
    the data.</font></p>
    <form method="POST" action="req_change1.asp">
      <input type="hidden" name="Request" value="Change">
      <input type="hidden" name="Mode" value="<% =sMode %>">
<%
If (sMode = "Edit") Then
%>
      <input type="hidden" name="CR" value="<% =Request.QueryString("CR") %>">
<%
End If
%>
      <div align="center"><center><% =sForm %></center></div>
    </form>
    <p>&nbsp;</td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
