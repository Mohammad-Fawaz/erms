<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<%
Function WriteRec(vRec)
    Dim sSQL
    Dim sFields
    Dim sVals
    Dim bRet
    Dim iRet
    Dim i
    Dim sRefs
    Dim vNewNum
    Dim sRetText
    Dim sHead
    Dim sRetRec
    Dim sRecVal
    Dim sRec
    Dim vTemp
    
    sSQL = ""
    sFields = ""
    sVals = ""
    
    Select Case vRec
        Case "Print"
            sHead = "New Print Request"
            sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
                    & "            <td colspan='2' valign='top'><font face='Verdana' size='2' color='#000080'><strong>PRINT REQUEST INFORMATION</strong></font></td>" & vbCrLf _
                    & "          </tr>"
            
			If (Request.Form("PRID") = "(Number Pending)") Or (Request.Form("PRID") = "") Then
				vNewNum = GetNewID("PRID", "")
			Else
				vNewNum = Request.Form("PRID")
			End If
			sFields = IIf(sFields <> "", sFields & ", ", "") & "TaskID"
			sVals = IIf(sVals <> "", sVals & ", ", "") & vNewNum 
			
			sRetRec = "Print Request ID"
			sRecVal = vNewNum
			sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
			
            sFields = IIf(sFields <> "", sFields & ", ", "") & "TaskStatus, TaskCostType, TaskDesc, StdTaskID, DateAssigned, AssignTo, AssignWkgrp"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'OPEN', 'L', 'ERMSWeb PRINT REQUEST', 'EWPR', #" & Date & "#, 100, 'DC'"
			
			If (Request.Form("PRReqBy") <> "") Then
				If (Request.Form("PRReqBy") <> "SELECT") Then
					If Not IsNumeric(Request.Form("PRReqBy")) Then
						vTemp = GetDataValue("SELECT EmpID AS RetVal FROM UserXRef WHERE (ULNF = '" & Request.Form("PRReqBy") & "')", Nothing)
					Else
						vTemp = Request.Form("PRReqBy")
					End If
					If (vTemp = "") Then
						vTemp = 100000
					End If
				Else
					vTemp = 100000
				End If
			Else
				vTemp = 100000
			End If
			sFields = IIf(sFields <> "", sFields & ", ", "") & "AssignBy"
			sVals = IIf(sVals <> "", sVals & ", ", "") & vTemp
			
			sRetRec = "Requested By"
			sRecVal = Request.Form("PRReqBy")
			sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
			
			If (Request.Form("PRProj") <> "") Then
				If (Request.Form("PRProj") <> "SELECT") Then
					vTemp = GetDataValue("SELECT ProjNum AS RetVal, Project FROM QProject WHERE (Project = '" & Request.Form("PRProj") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ProjNum"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Project"
						sRecVal = Request.Form("PRProj")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("PRPrior") <> "") Then
				If (Request.Form("PRPrior") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'TaskPriority') AND (OptDesc = '" & Request.Form("PRPrior") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "TaskPriority"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Priority"
						sRecVal = Request.Form("PRPrior")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("PRDue") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "PlannedStart, PlannedFinish"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "#" & Date & "#, #" & Request.Form("PRDue") & "#"
				
				sRetRec = "Date Due"
				sRecVal = Request.Form("PRDue")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
			If (Request.Form("AttRefs") <> "") Then
				'sRefs = CStr(vVals(i, 1))
				sFields = IIf(sFields <> "", sFields & ", ", "") & "TaskDetail"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("AttRefs")) & "'"
				
				sRetRec = "Attached References"
				sRecVal = Request.Form("AttRefs")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
            sSQL = "INSERT INTO Tasks (" & sFields & ") VALUES (" & sVals & ")"
    End Select
    
    If (sSQL <> "") Then
		bRet = RunSQLCmd(sSQL, Nothing)
		'bRet = False
    Else
		bRet = False
    End If
    
    If (bRet = False) Then
		sRetText = "<p><font face='Verdana' size='2'>An unexpected error occurred.</font></p>"
		sRetText = sRetText & "<p><font face='Verdana' size='2'>sSQL = " & sSQL & "</font></p>"
    '    iRet = LogEWebError("RECORD", Err, "New [" & vRec & "].")
    '    If (iRet > 0) Then
    '    Else
    '        iRet = 3
    '    End If
    Else
        sRetText = "<p><font face='Verdana' size='2'>The record has been successfully added to the database.</font></p>"
    End If
    
    'If (Trim(sRefs) <> "") Then
    '    iRet = SetRefs(vRec, vNewNum, Trim(sRefs))
    'End If
    
    sRetText = sRetText & vbCrLf & "<div align='center'><center><table border='2' cellpadding='4' width='600'>" _
            & "      <tr>" _
            & "        <td width='100%' bgcolor='#808000'><font face='Verdana' size='2' color='#FFFF00'><strong>" & sHead & "</strong>&nbsp;</font></td>" _
            & "      </tr>" _
            & "      <tr>" _
            & "        <td width='100%'><table border='0' cellpadding='2' cellspacing='0' width='100%'>" & vbCrLf _
            & sRec _
            & "          <tr>" & vbCrLf _
            & "            <td align='center' valign='top' colspan='2'><hr noshade color='#0000FF'>" & vbCrLf _
            & "            <p><font face='Verdana'>Please PRINT this page as confirmation of the record addition.</font></p>" & vbCrLf _
            & "            <p><font face='Verdana' size='2'>Thank you for using the <a href='../ermsw_index.asp'><strong>ERMS</strong><em>Web</em></a>" & vbCrLf _
            & "            System.</font></p>" & vbCrLf _
            & "            <hr noshade color='#0000FF'>" & vbCrLf _
            & "            </td>" & vbCrLf _
            & "          </tr>" & vbCrLf _
            & "        </table>" & vbCrLf _
            & "        </td>" & vbCrLf _
            & "      </tr>" & vbCrLf _
            & "    </table>" & vbCrLf _
            & "    </center></div></td>" & vbCrLf _
            & "  </tr>"
    
    WriteRec = sRetText
End Function

Function GetNewID(sID, vItem)
    Dim vRet
    
    vRet = 0
    
    Select Case sID
        Case "PRID"
            vRet = GetDataValue("SELECT MAX(TaskID) AS RetVal FROM Tasks", Nothing)
    End Select
    
    If (vRet = "") Then
        vRet = 1
    Else
		vRet = CLng(vRet) + 1
    End If
    
    GetNewID = vRet
End Function

Dim sRequest
Dim sAType
Dim sMode
Dim sHead
Dim sRetText
Dim sRefPage
Dim sTemp
Dim vVals
Dim vProc

sRequest = "Print"

Select Case sRequest
	Case "Print"
		sHead = "New Print Request"
End Select

sMode = "Add"
%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMSWeb - Quick Print Request</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2">
     <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
    </td>
  </tr>
  <tr>
    <!--<td width="145" valign="top" bgcolor="#FFFFC8"><%'=sMenu %></td>-->
    <td width="635" valign="top"><font face="Verdana" size="5">Print Request</font>
<%
If (sMode = "Add") Then
%> <p><font face="Verdana" size="2">Verify Request...</font></p>
    <div align="center"><center><table border="2" cellpadding="2" cellspacing="1" width="600">
      <tr>
        <td width="100%" bgcolor="#000000"><font face="Verdana" size="2" color="#FFFF00"><strong><% =sHead %></strong>&nbsp;</font></td>
      </tr>
      <tr>
        <td width="100%"><form method="POST" action="proc_req.asp?<% =SVars %>">
          <input type="hidden" name="Request" value="<% =sRequest %>">
          <input type="hidden" name="SVars" value="<% =SVars %>">
          <table border="0" cellpadding="2" cellspacing="0" width="100%">
<%
	Select Case sRequest
		Case "Print"
%>
            <tr>
              <td colspan="2" valign="top"><font face="Verdana" size="2" color="#0075FF"><strong>PRINT
              REQUEST INFORMATION</strong></font></td>
            </tr>
            <tr>
              <td valign="top" align="right"><strong><font face="Verdana" size="2">Print Request ID:</font></strong></td>
              <td valign="top"><input type="text" name="PRID" size="20" value="<% =GetNewID("PRID", "") %>"></td>
            </tr>
            <tr>
              <td align="right" valign="top"><strong><font face="Verdana" size="2">Requested By:</font></strong></td>
              <td valign="top"><select name="PRReqBy" size="1">
                <option>SELECT</option>
                <option selected><% =curUN %></option>
<% =GetSelect("EmpList", "") %>              </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
              <td valign="top"><select name="PRProj" size="1">
                <option>SELECT</option>
                <option selected>SELECT</option>
<% =GetSelect("Project", "") %>
              </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Priority:</strong></font></td>
              <td valign="top"><select name="PRPrior" size="1">
                <option>SELECT</option>
                <option selected>SELECT</option>
<% =GetSelect("TaskPriority", "") %>
              </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Date Due:</strong></font></td>
              <td valign="top"><input type="text" name="PRDue" size="20"></td>
            </tr>
<%
	End Select
%>
            <tr>
              <td valign="top" align="right"><strong><font face="Verdana" size="2">References:</font><br>
              </strong><font face="Verdana" size="1">Please place individual references on a single
              line, separated by a [Carraige Return].</font></td>
              <td valign="top"><textarea rows="7" name="AttRefs" cols="40"><% =Request.QueryString("FID") %></textarea></td>
            </tr>
            <tr>
              <td valign="top" colspan="2" align="center"><hr noshade color="#0000FF">
              <p><input type="submit" value="Submit Complete Record" name="btnSubmit"> <input type="reset" value="Reset Form" name="btnReset"></p>
              <hr noshade color="#0000FF">
              </td>
            </tr>
          </table>
        </form>
        </td>
      </tr>
    </table>
    </center></div>
<%
Else
	vProc = WriteRec(Request.Form("Request"))
	Response.Write vProc
End If
%>
</td>
  </tr>
  <tr>
    <td width="100%" colspan="2">
     <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
    </td>
  </tr>
</table>
</body>
</html>
