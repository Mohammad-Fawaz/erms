<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="script/incl_ado.asp" -->
<!-- #INCLUDE FILE="script/incl_secinfo.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<%
Dim sMenu

If (Request.QueryString <> "") Then
	If (Request.QueryString("M") <> "") Then
		sMenu = GetMenu(Request.QueryString("M"))
	Else
		sMenu = GetMenu(1)
	End If
Else
	sMenu = GetMenu(1)
End If

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
        Case "Change"
            'Format return information
            sHead = "New Change Order Request"
            sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
                    & "            <td colspan='2' valign='top'><font face='Verdana' size='2' color='#000080'><strong>CHANGE ORDER INFORMATION</strong></font></td>" & vbCrLf _
                    & "          </tr>"
            
			If (Request.Form("CO") = "(Number Pending)") Or (Request.Form("CO") = "") Then
				vNewNum = GetNewID("CO", "")
			Else
				vNewNum = Request.Form("CO")
			End If
			'Format current field information
			sFields = IIf(sFields <> "", sFields & ", ", "") & "CO, ChStatus, RefType"
			sVals = IIf(sVals <> "", sVals & ", ", "") & vNewNum & ", 'REQ', 'CO'"
			
			'Format return information
			sRetRec = "CO Number"
			sRecVal = vNewNum
			sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
			
			If (Request.Form("ChReqBy") <> "") Then
				If (Request.Form("ChReqBy") <> "SELECT") Then
					If IsNumeric(Request.Form("ChReqBy")) Then
						vTemp = GetDataValue("SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("ChReqBy") & ")", Nothing)
					Else
						vTemp = Request.Form("ChReqBy")
					End If
					If (vTemp = "") Then
						vTemp = "ERMSWeb Request"
					End If
				Else
					vTemp = "ERMSWeb Request"
				End If
			Else
				vTemp = "ERMSWeb Request"
			End If
            sFields = IIf(sFields <> "", sFields & ", ", "") & "ChReqBy, ChReqDate, LastModBy, LastModDate"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "', #" & Date & "#, '" & vTemp & "', #" & Date & "#"
			
            sRetRec = "Requested By"
			sRecVal = vTemp
            sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
            
			If (Request.Form("ChType") <> "") Then
				If (Request.Form("ChType") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'ChangeType') AND (OptDesc = '" & Request.Form("ChType") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeType"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Change Type"
						sRecVal = Request.Form("ChType")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("ChProj") <> "") Then
				If (Request.Form("ChProj") <> "SELECT") Then
					vTemp = GetDataValue("SELECT ProjNum AS RetVal, Project FROM QProject WHERE (Project = '" & Request.Form("ChProj") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ProjNum"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Project"
						sRecVal = Request.Form("ChProj")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("ChPrior") <> "") Then
				If (Request.Form("ChPrior") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'Priority') AND (OptDesc = '" & Request.Form("ChPrior") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ChPriority"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Priority"
						sRecVal = Request.Form("ChPrior")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("ChJust") <> "") Then
				If (Request.Form("ChJust") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'Justification') AND (OptDesc = '" & Request.Form("ChJust") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ChJustification"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Justification"
						sRecVal = Request.Form("ChJust")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("ChDue") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "ChDue, ChEffDate"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "#" & Request.Form("ChDue") & "#, #" & Request.Form("ChDue") & "#"
				
				sRetRec = "Date Due"
				sRecVal = Request.Form("ChDue")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
			If (Request.Form("ChDesc") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeDesc"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("ChDesc")) & "'"
				
				sRetRec = "Description"
				sRecVal = Request.Form("ChDesc")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
			'If (Request.Form("ChNotes") <> "") Then
			'	sFields = IIf(sFields <> "", sFields & ", ", "") & "AddNotes"
			'	sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("ChNotes")) & "'"
				
			'	sRetRec = "Additional Notes"
			'	sRecVal = Request.Form("ChNotes")
			'	sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
			'			& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
			'			& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
			'			& "          </tr>"
			'End If
            
			If (Request.Form("AttRefs") <> "") Then
				'sRefs = Request.Form("AttRefs")
				sFields = IIf(sFields <> "", sFields & ", ", "") & "AddNotes"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("AttRefs")) & "'"
				
				sRetRec = "Attached References"
				sRecVal = Request.Form("AttRefs")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
            
            sSQL = "INSERT INTO Changes (" & sFields & ") VALUES (" & sVals & ")"
        Case "Doc"
            Dim sProj
            
            sHead = "New Document Request"
            sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
                    & "            <td colspan='2' valign='top'><font face='Verdana' size='2' color='#000080'><strong>DOCUMENT INFORMATION</strong></font></td>" & vbCrLf _
                    & "          </tr>"
            
			If (Request.Form("DocID") = "(Number Pending)") Or (Request.Form("DocID") = "") Then
				vNewNum = GetNewID("DocID", "")
			Else
				vNewNum = Request.Form("DocID")
			End If
			sFields = IIf(sFields <> "", sFields & ", ", "") & "DocID, DocStatus, CurrentRev"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vNewNum & "', 'REQ', '-'"
			
			sRetRec = "Document ID"
			sRecVal = vNewNum
			sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
			
			If (Request.Form("DocReqBy") <> "") Then
				If (Request.Form("DocReqBy") <> "SELECT") Then
					If IsNumeric(Request.Form("DocReqBy")) Then
						vTemp = GetDataValue("SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("DocReqBy") & ")", Nothing)
					Else
						vTemp = Request.Form("DocReqBy")
					End If
					If (vTemp = "") Then
						vTemp = "ERMSWeb Request"
					End If
				Else
					vTemp = "ERMSWeb Request"
				End If
			Else
				vTemp = "ERMSWeb Request"
			End If
			sFields = IIf(sFields <> "", sFields & ", ", "") & "DocReqBy, DocReqDate, LastModBy, LastModDate"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "', #" & Date & "#, '" & vTemp & "', #" & Date & "#"
			
			sRetRec = "Requested By"
			sRecVal = vTemp
			sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
			
			If (Request.Form("DocDisc") <> "") Then
				If (Request.Form("DocDisc") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'Discipline') AND (OptDesc = '" & Request.Form("DocDisc") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "Discipline"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Discipline"
						sRecVal = Request.Form("DocDisc")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("DocProj") <> "") Then
				If (Request.Form("DocProj") <> "SELECT") Then
					vTemp = GetDataValue("SELECT ProjNum AS RetVal, Project FROM QProject WHERE (Project = '" & Request.Form("DocProj") & "')", Nothing)
					If (vTemp <> "") Then
						sProj = Request.Form("DocProj")
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ProjNum"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Project"
						sRecVal = Request.Form("DocProj")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("DocType") <> "") Then
				If (Request.Form("DocType") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'DocType') AND (OptDesc = '" & Request.Form("DocType") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "DocType"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Document Type"
						sRecVal = Request.Form("DocType")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("DocDesc") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "DocDesc"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("DocDesc")) & "'"
				
				sRetRec = "Description"
				sRecVal = Request.Form("DocDesc")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
			'If (Request.Form("DocNotes"") <> "") Then
			'	sFields = IIf(sFields <> "", sFields & ", ", "") & "DocNotes"
			'	sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("DocNotes")) & "'"
				
			'	sRetRec = "Additional Notes"
			'	sRecVal = Request.Form("DocNotes")
			'	sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
			'			& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
			'			& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
			'			& "          </tr>"
			'End If
			
			If (Request.Form("AttRefs") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "DocNotes"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("AttRefs")) & "'"
				
				sRetRec = "Attached References"
				sRecVal = Request.Form("AttRefs")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
            sSQL = "INSERT INTO Documents (" & sFields & ") VALUES (" & sVals & ")"
        Case "QAction"
            sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
                    & "            <td colspan='2' valign='top'><font face='Verdana' size='2' color='#000080'><strong>QUALITY ACTION INFORMATION</strong></font></td>" & vbCrLf _
                    & "          </tr>"
            
			If (Request.Form("QAAType") <> "") Then
				If (Request.Form("QAAType") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'AType') AND (OptDesc = '" & Request.Form("QAAType") & "')", Nothing)
					If (vTemp <> "") Then
						vNewNum = GetNewID("QAID", vTemp)
						sRetRec = "Action Type"
						sRecVal = Request.Form("QAAType")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				Else
					vTemp = ""
					vNewNum = GetNewID("QAID", "")
				End If
			Else
				vTemp = ""
				vNewNum = GetNewID("QAID", "")
			End If
			sFields = IIf(sFields <> "", sFields & ", ", "") & "CO, ChStatus, RefType"
			sVals = IIf(sVals <> "", sVals & ", ", "") & vNewNum & ", 'REQ', " & IIf(vTemp <> "", "'" & vTemp & "'", "NULL")
			
			Select Case Request.Form("QAAType")
				Case "CAR", "CORRECTIVE ACTION REQUEST"
					sHead = "New Corrective Action Request"
				Case "FAI", "FIRST ARTICLE INSPECTION"
					sHead = "New First Article Inspection Request"
				Case "NCR", "NON-CONFORMANCE REPORT"
					sHead = "New Non-Conformance Report Request"
				Case "PN", "PROBLEM NOTIFICATION"
					sHead = "New Problem Notification Request"
				Case Else
					sHead = "New Action (No Type Set)"
			End Select
			
			sRetRec = "Action ID"
			sRecVal = vNewNum
			sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
			
			If (Request.Form("QAReqBy") <> "") Then
				If (Request.Form("QAReqBy") <> "SELECT") Then
					If IsNumeric(Request.Form("QAReqBy")) Then
						vTemp = GetDataValue("SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("QAReqBy") & ")", Nothing)
					Else
						vTemp = Request.Form("QAReqBy")
					End If
					If (vTemp = "") Then
						vTemp = "ERMSWeb Request"
					End If
				Else
					vTemp = "ERMSWeb Request"
				End If
			Else
				vTemp = "ERMSWeb Request"
			End If
			sFields = IIf(sFields <> "", sFields & ", ", "") & "ChReqBy, ChReqDate, LastModBy, LastModDate"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "', #" & Date & "#, '" & vTemp & "', #" & Date & "#"
			
			sRetRec = "Requested By"
			sRecVal = vTemp
			sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
					& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
					& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
					& "          </tr>"
			
			If (Request.Form("QAProj") <> "") Then
				If (Request.Form("QAProj") <> "SELECT") Then
					vTemp = GetDataValue("SELECT ProjNum AS RetVal, Project FROM QProject WHERE (Project = '" & Request.Form("QAProj") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ProjNum"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Project"
						sRecVal = Request.Form("QAProj")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("QAPrior") <> "") Then
				If (Request.Form("QAPrior") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'Priority') AND (OptDesc = '" & Request.Form("QAPrior") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ChPriority"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Priority"
						sRecVal = Request.Form("QAPrior")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("QAIssType") <> "") Then
				If (Request.Form("QAIssType") <> "SELECT") Then
					vTemp = GetDataValue("SELECT OptCode AS RetVal FROM StdOptions WHERE (OptType = 'Justification') AND (OptDesc = '" & Request.Form("QAIssType") & "')", Nothing)
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "ChJustification"
						sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
					
						sRetRec = "Issue Type"
						sRecVal = Request.Form("QAIssType")
						sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
								& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
								& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
								& "          </tr>"
					End If
				End If
			End If
			
			If (Request.Form("QADue") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "ChDue, ChEffDate"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "#" & Request.Form("QADue") & "#, #" & Request.Form("QADue") & "#"
				
				sRetRec = "Date Due"
				sRecVal = Request.Form("QADue")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
			If (Request.Form("QADesc") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeDesc"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("QADesc")) & "'"
				
				sRetRec = "Description"
				sRecVal = Request.Form("QADesc")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
			If (Request.Form("AttRefs") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "AddNotes"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("AttRefs")) & "'"
				
				sRetRec = "Attached References"
				sRecVal = Request.Form("AttRefs")
				sRec = IIf(sRec <> "", sRec & vbCrLf, "") & "          <tr>" & vbCrLf _
						& "            <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>" & sRetRec & ":</font></strong></td>" & vbCrLf _
						& "            <td valign='top'><font face='Verdana' size='2'>" & sRecVal & "</font></td>" & vbCrLf _
						& "          </tr>"
			End If
			
            sSQL = "INSERT INTO Changes (" & sFields & ") VALUES (" & sVals & ")"
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
    
    'If (iRet > 0) Then
    '    GoTo SetErr
    'Else
    '    GoTo FinishCode
    'End If
    
'ErrCode:
'    iRet = LogEWebError("RECORD", Err, "New [" & vRec & "].")
    
'SetErr:
'    Select Case iRet
'        Case 0
            'Set default
'            If Not (iRet > 0) Then
'                iRet = 1
'            End If
'        Case 1
'            sRetText = sRetText & "<p><font face='Verdana' size='2'>An unexpected error occurred while attempting to create the record(s). No log entry has been produced, please report this error to the System Administrator.</font></p>"
'        Case 2
'            sRetText = sRetText & "<p><font face='Verdana' size='2'>An unexpected error occurred while attempting to create reference records. Error logging was unsuccessful, please report this error to the System Administrator.</font></p>"
'        Case 3
'            sRetText = sRetText & "<p><font face='Verdana' size='2'>An unexpected error occurred while attempting to create reference records. Error logging was successful, please report this error to the System Administrator.</font></p>"
'        Case 4
'            sRetText = sRetText & "<p><font face='Verdana' size='2'>SQL BUILD ERR. Error logging was successful, please report this error to the System Administrator.</font></p>"
'        Case 5
'            sRetText = sRetText & "<p><font face='Verdana' size='2'>SQL BUILD ERR. Error logging was unsuccessful, please report this error to the System Administrator.</font></p>"
'        Case Else
'            sRetText = sRetText & "<p><font face='Verdana' size='2'>An unexpected error occurred while attempting to create the record(s). No log entry has been produced, please report this error to the System Administrator.</font></p>"
'    End Select
    
'FinishCode:
'    Set oData = Nothing
    WriteRec = sRetText
End Function

Function GetNewID(sID, vItem)
    Dim vRet
    
    vRet = 0
    
    Select Case sID
        Case "CO"
            vRet = GetDataValue("SELECT MAX(CO) AS RetVal FROM Changes WHERE RefType = 'CO'", Nothing)
        Case "DocID"
            'If (vItem <> "") Then
            '    vRet = GetNewNum("DocID", CStr(vItem))
            'Else
            '    vRet = GetNewNum("DocID")
            'End If
            vRet = ""
        Case "PRID"
            vRet = GetDataValue("SELECT MAX(TaskID) AS RetVal FROM Tasks", Nothing)
        Case "QAID"
			If (vItem <> "") Then
				vRet = GetDataValue("SELECT MAX(CO) AS RetVal FROM Changes WHERE (RefType = '" & CStr(vItem) & "')", Nothing)
            Else
				vRet = GetDataValue("SELECT MAX(CO) AS RetVal FROM Changes", Nothing)
            End If
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

sRequest = CStr(Request.Form("Request"))

Select Case sRequest
	Case "Change"
		sHead = "New Change Order Request"
	Case "Doc"
		sHead = "New Document Request"
	Case "QAction"
		sAType = Request.Form("AType")
		
		Select Case sAType
			Case "CAR", "CORRECTIVE ACTION REQUEST"
				sHead = "New Corrective Action Request"
			Case "FAI", "FIRST ARTICLE INSPECTION"
				sHead = "New First Article Inspection Request"
			Case "NCR", "NON-CONFORMANCE REPORT"
				sHead = "New Non-Conformance Report Request"
			Case "PN", "PROBLEM NOTIFICATION"
				sHead = "New Problem Notification Request"
		End Select
	Case "Print"
		sHead = "New Print Request"
End Select

sMode = Request.Form("Mode")

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMSWeb - Process Request</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %></td>
    <td width="635" valign="top"><font face="Verdana" size="5">Process Request</font> 
<%
If (sMode = "Add") Then
	Select Case sRequest
		Case "Change"
			sRefPage = "select/sel_docs.asp"
		Case "Doc"
			sRefPage = "select/sel_files.asp"
		Case "QAction"
			Select Case sAType
				Case "CAR", "CORRECTIVE ACTION REQUEST"
					sRefPage = "select/sel_parts.asp"
				Case "FAI", "FIRST ARTICLE INSPECTION"
					sRefPage = "select/sel_parts.asp"
				Case "NCR", "NON-CONFORMANCE REPORT"
					sRefPage = "select/sel_parts.asp"
				Case "PN", "PROBLEM NOTIFICATION"
					sRefPage = "select/sel_parts.asp"
			End Select
		Case "Print"
			sRefPage = "select/sel_docs.asp"
	End Select
	
	'sTemp = InputBox("Please enter the [Reference ID] to attach.", "Attach Reference")
	
%> <p><font face="Verdana" size="2">...Add References</font></p>
    <div align="center"><center><table border="2" cellpadding="2" cellspacing="1" width="600">
      <tr>
        <td width="100%" bgcolor="#000000"><font face="Verdana" size="2" color="#00000"><strong><% =sHead %></strong>&nbsp;</font></td>
      </tr>
      <tr>
        <td width="100%"><form method="POST" action="proc_req.asp?<% =SVars %>">
          <input type="hidden" name="Request" value="<% =sRequest %>">
		  <input type="hidden" name="SVars" value="<% =SVars %>">
          <table border="0" cellpadding="2" cellspacing="0" width="100%">
<%
	Select Case sRequest
		Case "Change"
%>
            <tr>
              <td colspan="2" valign="top"><font face="Verdana" size="2" color="#0075FF"><strong>CHANGE
              ORDER INFORMATION</strong></font></td>
            </tr>
            <tr>
              <td valign="top" align="right"><strong><font face="Verdana" size="2">CO Number:</font></strong></td>
              <td valign="top"><input type="text" name="CO" size="20" value="<% =Request.Form("CO") %>"></td>
            </tr>
            <tr>
              <td align="right" valign="top"><strong><font face="Verdana" size="2">Requested By:</font></strong></td>
              <td valign="top"><select name="ChReqBy" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("ChReqBy") %></option>
<% =GetSelect("EmpList", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Change Type:</strong></font></td>
              <td valign="top"><select name="ChType" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("ChType") %></option>
<% =GetSelect("ChType", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
              <td valign="top"><select name="ChProj" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("ChProj") %></option>
<% =GetSelect("Project", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Priority:</strong></font></td>
              <td valign="top"><select name="ChPrior" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("ChPrior") %></option>
<% =GetSelect("ChPriority", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Justification:</strong></font></td>
              <td valign="top"><select name="ChJust" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("ChJust") %></option>
<% =GetSelect("ChJustification", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Date Due:</strong></font></td>
              <td valign="top"><input type="text" name="ChDue" size="20" value="<% =Request.Form("ChDue") %>"></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Description:</strong></font></td>
              <td valign="top"><textarea rows="4" name="ChDesc" cols="40" wrap="physical"><% =Request.Form("ChDesc") %></textarea></td>
            </tr>
            <!-- <tr>              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Additional Notes:</strong></font></td>              <td valign="top"><textarea rows="4" name="ChNotes" cols="40" wrap="physical"><% =Request.Form("ChNotes") %></textarea></td>            </tr> -->
<%
		Case "Doc"
%>
            <tr>
              <td colspan="2" valign="top"><font face="Verdana" size="2" color="#0075FF"><strong>DOCUMENT
              INFORMATION</strong></font></td>
            </tr>
            <tr>
              <td valign="top" align="right"><font face="Verdana" size="2"><strong>Document Number:</strong></font></td>
              <td valign="top"><input type="text" name="DocID" size="20" value="<% =Request.Form("DocID") %>"></td>
            </tr>
            <tr>
              <td valign="top" align="right"><font face="Verdana" size="2"><strong>Requested By:</strong></font></td>
              <td valign="top"><select name="DocReqBy" size="1">
          <option>SELECT</option>
            <option selected><% =Request.Form("DocReqBy") %></option>
<% =GetSelect("EmpList", "") %>
          </select></td>
            </tr>
            <tr>
              <td valign="top" align="right"><font face="Verdana" size="2"><strong>Discipline:</strong></font></td>
              <td valign="top"><select name="DocDisc" size="1">
          <option>SELECT</option>
            <option selected><% =Request.Form("DocDisc") %></option>
<% =GetSelect("Discipline", "") %>
          </select></td>
            </tr>
            <tr>
              <td valign="top" align="right"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
              <td valign="top"><select name="DocProj" size="1">
          <option>SELECT</option>
            <option selected><% =Request.Form("DocProj") %></option>
<% =GetSelect("Project", "") %>
          </select></td>
            </tr>
            <tr>
              <td valign="top" align="right"><font face="Verdana" size="2"><strong>Document Type:</strong></font></td>
              <td valign="top"><select name="DocType" size="1">
          <option>SELECT</option>
            <option selected><% =Request.Form("DocType") %></option>
<% =GetSelect("DocType", "") %>
          </select></td>
            </tr>
            <tr>
              <td valign="top" align="right"><font face="Verdana" size="2"><strong>Description:</strong></font></td>
              <td valign="top"><textarea rows="4" name="S5" cols="40" wrap="physical"><% =Request.Form("DocDesc") %></textarea></td>
            </tr>
            <!-- <tr>              <td valign="top" align="right"><font face="Verdana" size="2"><strong>Additional Notes:</strong></font></td>              <td valign="top"><textarea rows="4" name="S4" cols="40" wrap="physical"><% =Request.Form("DocNotes") %></textarea></td>            </tr> -->
<%
		Case "Print"
%>
            <tr>
              <td colspan="2" valign="top"><font face="Verdana" size="2" color="#0075FF"><strong>PRINT
              REQUEST INFORMATION</strong></font></td>
            </tr>
            <tr>
              <td valign="top" align="right"><strong><font face="Verdana" size="2">Print Request ID:</font></strong></td>
              <td valign="top"><input type="text" name="PRID" size="20" value="<% =Request.Form("PRID") %>"></td>
            </tr>
            <tr>
              <td align="right" valign="top"><strong><font face="Verdana" size="2">Requested By:</font></strong></td>
              <td valign="top"><select name="PRReqBy" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("PRReqBy") %></option>
<% =GetSelect("EmpList", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
              <td valign="top"><select name="PRProj" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("PRProj") %></option>
<% =GetSelect("Project", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Priority:</strong></font></td>
              <td valign="top"><select name="PRPrior" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("PRPrior") %></option>
<% =GetSelect("TaskPriority", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Date Due:</strong></font></td>
              <td valign="top"><input type="text" name="PRDue" size="20" value="<% =Request.Form("PRDue") %>"></td>
            </tr>
<%
		Case "QAction"
%>
            <tr>
              <td colspan="2" valign="top"><font face="Verdana" size="2" color="#0075FF"><strong>QUALITY
              ACTION INFORMATION</strong></font></td>
            </tr>
            <tr>
              <td valign="top" align="right"><strong><font face="Verdana" size="2">Action ID:</font></strong></td>
              <td valign="top"><input type="text" name="QAID" size="20" value="<% =Request.Form("QAID") %>"></td>
            </tr>
            <tr>
              <td valign="top" align="right"><strong><font face="Verdana" size="2">Action Type:</font></strong></td>
              <td valign="top"><select name="QAAType" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("QAAType") %></option>
<% =GetSelect("AType", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><strong><font face="Verdana" size="2">Requested By:</font></strong></td>
              <td valign="top"><select name="QAReqBy" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("QAReqBy") %></option>
<% =GetSelect("EmpList", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
              <td valign="top"><select name="QAProj" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("QAProj") %></option>
<% =GetSelect("Project", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Priority:</strong></font></td>
              <td valign="top"><select name="QAPrior" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("QAPrior") %></option>
<% =GetSelect("TaskPriority", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Issue Type:</strong></font></td>
              <td valign="top"><select name="QAIssType" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("QAIssType") %></option>
<% =GetSelect("ChJustification", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Assign To:</strong></font></td>
              <td valign="top"><select name="QAAssnTo" size="1">
          <option>SELECT</option>
          <option selected><% =Request.Form("QAAssnTo") %></option>
<% =GetSelect("EmpList", "") %>
          </select></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Date Due:</strong></font></td>
              <td valign="top"><input type="text" name="QADue" size="20" value="<% =Request.Form("QADue") %>"></td>
            </tr>
            <tr>
              <td align="right" valign="top"><font face="Verdana" size="2"><strong>Description:</strong></font></td>
              <td valign="top"><textarea rows="4" name="QADesc" cols="40" wrap="physical"><% =Request.Form("QADesc") %></textarea></td>
            </tr>
<%
	End Select
%>
            <tr>
              <td valign="top" align="right"><font face="Verdana" size="2"><strong>References:</font><br>
              </strong><font face="Verdana" size="1">Please place individual references on a single line, separated by a [Carraige Return].</font></td>
              <td valign="top"><textarea rows="7" name="AttRefs" cols="40"></textarea></td>
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
	'If (IsArray(vVals) = True) Then
		vProc = WriteRec(Request.Form("Request"))		', vVals)
	'Else
	'	vProc = "<p><font face='Verdana' size='2'>An unexpected error occurred while attempting to send the record to the database.</font></p>"
	'End If
	
	Response.Write vProc
End If
%>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
