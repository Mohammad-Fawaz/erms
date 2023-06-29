<%
Function GetWTask(sTID)
	Dim sInfo
	Dim sCMD
	Dim oRS
	Dim sTemp
	
	sInfo = ""
	If (sTID <> "") Then
		sCMD = "SELECT TaskID, Status, Priority, ChargeAcct, Project, DateAssigned, StdTask, TaskDesc, TaskDetail, PlannedStart, PlannedFinish, "
		sCMD = sCMD & "OverrunEstFinish, ActualStart, ActualFinish, BFinish, EstHours, OverrunHrs, BHrs, ActualHours, PcntComplete, EstCost, "
		sCMD = sCMD & "OvrCost, BMCost, ActualCost, WATID, WATActive, WATStatus, WATCreated, WATCreatedBy, AType, WATStep, WATNext, "
		sCMD = sCMD & "WATNextStatus, WATBack, WATBackStatus, WAAByType, AByType, WAAssnBy, WAAToType, AToType, WAAssnTo, WFAssnTo, "
		sCMD = sCMD & "ULNF, WATCtrlRef, WATRefID, WATSchedAdj, WATAdjPStart, WATAdjPFinish, WATAdjOFinish, WATAdjAStart, WATAdjAFinish "
		sCMD = sCMD & "FROM ViewWFTasks WHERE (TaskID = " & sTID & ")"
		Set oRS = GetADORecordset(sCMD, Nothing)
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			'Workflow task information display
			oRS.MoveFirst
			sInfo = "<table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td bgcolor='#D7D7D7' colspan='6'><strong><font face='Verdana' size='3'>Task Information</font></strong></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Task ID:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & sTID & "</font></td>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("Status") & "</font></td>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("Priority") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Date Assigned:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("DateAssigned") & "</font></td>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("ChargeAcct") & "</font></td>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Std Task:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("StdTask") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='5'><font face='Verdana' size='2'>" & oRS("Project") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='5'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Details:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='5'><font face='Verdana' size='2'>" & oRS("TaskDetail") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Workflow Step:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("WATStep") & "</font></td>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='3'><font face='Verdana' size='2'>" & oRS("AType") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("WATNext") & "</font></td>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='3'><font face='Verdana' size='2'>" & oRS("WATNextStatus") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & oRS("WATBack") & "</font></td>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='3'><font face='Verdana' size='2'>" & oRS("WATBackStatus") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			If Not IsNull(oRS("WAAssnBy")) Then
				sTemp = GetDataValue("SELECT WFGroup AS RetVal FROM ViewWFGroups WHERE (WFGID = " & oRS("WAAssnBy") & ")", Nothing)
			End If
			sTemp = oRS("AByType") & IIf(sTemp <> "", " - " & sTemp, "")
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='5'><font face='Verdana' size='2'>" & sTemp & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sTemp = ""
			If Not IsNull(oRS("WAAssnTo")) Then
				sTemp = GetDataValue("SELECT WFGroup AS RetVal FROM ViewWFGroups WHERE (WFGID = " & oRS("WAAssnTo") & ")", Nothing)
			End If
			sTemp = oRS("AToType") & IIf(sTemp <> "", " - " & sTemp, "")
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='5'><font face='Verdana' size='2'>" & sTemp & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Task Assignee:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='5'><font face='Verdana' size='2'>" & oRS("ULNF") & "</font></td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			sInfo = sInfo & vbCrLf & "  <tr>"
			sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "    <td colspan='5'><table border='0' cellspacing='1' width='100%'>"
			sInfo = sInfo & vbCrLf & "      <tr>"
			sInfo = sInfo & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Complete:</strong> " & oRS("PcntComplete") & "%</font></td>"
			sInfo = sInfo & vbCrLf & "        <td bgcolor='#D7D7D7' align='center'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
			sInfo = sInfo & vbCrLf & "        <td bgcolor='#D7D7D7' align='center'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
			sInfo = sInfo & vbCrLf & "        <td bgcolor='#D7D7D7' align='center'><font face='Verdana' size='1'><strong>Hrs</strong></font></td>"
			sInfo = sInfo & vbCrLf & "        <td bgcolor='#D7D7D7' align='center'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
			sInfo = sInfo & vbCrLf & "      </tr>"
			sInfo = sInfo & vbCrLf & "      <tr>"
			sInfo = sInfo & vbCrLf & "        <td align='left'><strong><font face='Verdana' size='2'>Planned:</font></strong></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("PlannedStart") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("PlannedFinish") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("EstHours") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("EstCost") & "</font></td>"
			sInfo = sInfo & vbCrLf & "      </tr>"
			sInfo = sInfo & vbCrLf & "      <tr>"
			sInfo = sInfo & vbCrLf & "        <td align='left'><font face='Verdana' size='2'><strong>Overrun:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("OverrunEstFinish") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("OverrunHrs") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("OvrCost") & "</font></td>"
			sInfo = sInfo & vbCrLf & "      </tr>"
			sInfo = sInfo & vbCrLf & "      <tr>"
			sInfo = sInfo & vbCrLf & "        <td align='left'><font face='Verdana' size='2'><strong>Actual:</strong></font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("ActualStart") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("ActualFinish") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("ActualHours") & "</font></td>"
			sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("ActualCost") & "</font></td>"
			sInfo = sInfo & vbCrLf & "      </tr>"
			If (oRS("WATSchedAdj") <> 0) Then
				sInfo = sInfo & vbCrLf & "      <tr>"
				sInfo = sInfo & vbCrLf & "        <td align='left' bgcolor='#F0F0F0'><font face='Verdana' size='2'><strong>Adjusted Plan:</strong></font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("WATAdjPStart") & "</font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("WATAdjPFinish") & "</font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
				sInfo = sInfo & vbCrLf & "      </tr>"
				sInfo = sInfo & vbCrLf & "      <tr>"
				sInfo = sInfo & vbCrLf & "        <td align='left' bgcolor='#F0F0F0'><strong><font face='Verdana' size='2'>Adjusted Overrun:</font></strong></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("WATAdjOFinish") & "</font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
				sInfo = sInfo & vbCrLf & "      </tr>"
				sInfo = sInfo & vbCrLf & "      <tr>"
				sInfo = sInfo & vbCrLf & "        <td align='left' bgcolor='#F0F0F0'><font face='Verdana' size='2'><strong>Adjusted Actual:</strong></font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("WATAdjAStart") & "</font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & oRS("WATAdjAFinish") & "</font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
				sInfo = sInfo & vbCrLf & "        <td align='center'><font face='Verdana' size='2'></font></td>"
				sInfo = sInfo & vbCrLf & "      </tr>"
			End If
			sInfo = sInfo & vbCrLf & "    </table>"
			sInfo = sInfo & vbCrLf & "    </td>"
			sInfo = sInfo & vbCrLf & "  </tr>"
			If Not IsNull(oRS("WATCtrlRef")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QTaskRefType WHERE (OptCode = '" & oRS("WATCtrlRef") & "')", Nothing)
				sInfo = sInfo & vbCrLf & "  <tr>"
				sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Ref Type:</strong></font></td>"
				sInfo = sInfo & vbCrLf & "    <td><font face='Verdana' size='2'>" & sTemp & "</font></td>"
				sInfo = sInfo & vbCrLf & "    <td align='left'><font face='Verdana' size='2'><strong>Ref Item:</strong></font></td>"
				sInfo = sInfo & vbCrLf & "    <td colspan='3'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("WATRefID")), "NO DATA", oRS("WATRefID")) & "</font></td>"
				sInfo = sInfo & vbCrLf & "  </tr>"
			End If
			sInfo = sInfo & vbCrLf & "</table>"
			sInfo = sInfo & vbCrLf & "<table class='mt-4' border='1' cellpadding='2' cellspacing='0' width='100%'>"
			sInfo = sInfo & vbCrLf & GetInfoSection("Notes", sTID, "TASK", "")
			sInfo = sInfo & vbCrLf & GetInfoSection("Att", sTID, "TA", curEID)
			sInfo = sInfo & vbCrLf & "</table>"
			oRS.Close
		End If
		Set oRS = Nothing
	Else
		'Error, no info found
		sInfo = ""
	End If
	
	GetWTask = sInfo
End Function

Function GetWFSelect(vList, vVal1, vVal2)
	Dim sSelect
	Dim sSQL
	Dim rsList
	Dim sTemp
	
	Select Case vList
    
        Case "WTemplate"
			sSQL = "SELECT WTID AS OptVal, TType + ' - ' + WTName AS OptText FROM ViewWFTemp" & IIf(vVal2 <> "", " WHERE (" & vVal2 & ")", "") & " ORDER BY TType, WTName"
			
			
			
        Case "WActions"
			sSQL = "SELECT WAID AS OptVal, AType + ' - ' + WAName AS OptText FROM ViewWFActions" & IIf(vVal2 <> "", " WHERE (" & vVal2 & ")", "") & " ORDER BY AType, WAName"
		Case "WTItems"
			sSQL = "SELECT WTIID AS OptVal, WTIStep + ': ' + TIType + ' - ' + WTIName AS OptText FROM ViewWFTItems" & IIf(vVal2 <> "", " WHERE (WTID = " & vVal2 & ")", "") & " ORDER BY WTIStep"
			
		Case "ActType"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'WFActType') ORDER BY OptDesc"
			
		Case "TempType"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'WFTempType') ORDER BY OptDesc"
		Case "RtGroup"
			sSQL = "SELECT WFGID AS OptVal, WFGroup AS OptText FROM WFGroups" & IIf(vVal2 <> "", " WHERE (WFGroupType = '" & vVal2 & "')", "") & " ORDER BY WFGroup"
		Case "WFGType"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'WFGroupType')" & IIf(vVal2 <> "", " AND " & vVal2, "") & " ORDER BY OptDesc"
			
		Case "GroupType"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM ViewWFGroupType ORDER BY OptDesc"
		
		
		
		Case "TaskRefType"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'TaskRefType') ORDER BY OptDesc"
		
		
		
		Case "SQL"
			If (vVal2 <> "") Then sSQL = vVal2 Else sSQL = ""
	End Select
	
	If (Trim(sSQL) <> "") Then
        Set rsList = GetADORecordset(sSQL, Nothing)
        
        If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
			rsList.MoveFirst
            Do
				If Not IsNull(rsList("OptText")) Then
					If ((vList = "WTemplate") Or (vList = "WActions") Or (vList = "SQL")) Then
						sTemp = rsList("OptText")
						sTemp = IIf(Len(sTemp) > 54, Left(sTemp, 51) & "...", sTemp)
						sSelect = IIf(Trim(sSelect) <> "", sSelect & vbCrLf, "") & "<option value='" & rsList("OptVal") & "'" & IIf(vVal1 = rsList("OptVal"), " SELECTED", "") & ">" & sTemp & "</option>"
					Else
						sSelect = IIf(Trim(sSelect) <> "", sSelect & vbCrLf, "") & "<option value='" & rsList("OptVal") & "'" & IIf(vVal1 = rsList("OptVal"), " SELECTED", "") & ">" & rsList("OptText") & "</option>"
					End If
				End If
				rsList.MoveNext
			Loop Until rsList.EOF
        Else
            sSelect = ""
        End If
        
        rsList.Close
        Set rsList = Nothing
    Else
        sSelect = ""
    End If
    
    GetWFSelect = sSelect
End Function

Function GetGenRefList(sRType, sRID)
	Dim sRList
	Dim sCMD
	
	sRList = ""
	If (sRID <> "") Then
	
		Select Case sRType
			Case "CAR"
				sTemp = "Left(RefNum, " & Len(sRID) & ") = " & sRID
				
				sCMD = "SELECT RefNum AS OptVal, CStr(RefNum) + ' - ' + IssueDesc AS OptText FROM QActions WHERE (" & sTemp & ") AND (RefType = 'CAR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ')) ORDER BY RefNum"
				
			Case "CO"
				sTemp = "Left(CO, " & Len(sRID) & ") = " & sRID
				sCMD = "SELECT CO AS OptVal, CStr(CO) + ' - ' + ChangeDesc AS OptText FROM Changes WHERE (" & sTemp & ") AND (RefType = 'CO') AND ((ChStatus = 'CREQ') OR (ChStatus = 'REQ')) ORDER BY CO"
				
				
			Case "DOC"
				sTemp = "Left(DocID, " & Len(sRID) & ") = '" & sRID & "'"
				sCMD = "SELECT DocID AS OptVal, DocID + ' - ' + DocDesc AS OptText FROM Documents WHERE (" & sTemp & ") AND ((DocStatus = 'CREQ') OR (DocStatus = 'REQ')) ORDER BY DocID"
				
			Case "MDISP"
				sTemp = "Left(MatDispID, " & Len(sRID) & ") = " & sRID
				sCMD = "SELECT MatDispID AS OptVal, OrderDateBatch AS OptText FROM MatDisp WHERE (" & sTemp & ") AND ((DispStatus <> 'COMPL') AND (DispStatus <> 'HOLD')) ORDER BY MatDispID"
				
			Case "NCR"
				sTemp = "Left(RefNum, " & Len(sRID) & ") = " & sRID
				sCMD = "SELECT RefNum AS OptVal, CStr(RefNum) + ' - ' + IssueDesc AS OptText FROM QActions WHERE (" & sTemp & ") AND (RefType = 'NCR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ')) ORDER BY RefNum"
			Case "PROJ"
				sTemp = "Left(ProjNum, " & Len(sRID) & ") = '" & sRID & "'"
				sCMD = "SELECT ProjNum AS OptVal, Project AS OptText FROM QProject WHERE (" & sTemp & ") AND ((ProjStatus = 'ACT') OR (ProjStatus = 'PLN')) ORDER BY ProjNum"
				
			Case "TASK"
				sTemp = "Left(TaskID, " & Len(sRID) & ") = '" & sRID & "'"
				sCMD = "SELECT TaskID AS OptVal, CStr(TaskID) + ' - ' + TaskDesc AS OptText FROM Tasks WHERE (" & sTemp & ") AND (TaskStatus = 'OPEN') ORDER BY TaskID"
				
		End Select
	Else
		Select Case sRType
			Case "CAR": sCMD = "SELECT RefNum AS OptVal, CStr(RefNum) + ' - ' + IssueDesc AS OptText FROM QActions WHERE (RefType = 'CAR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ')) ORDER BY RefNum"
			Case "CO": sCMD = "SELECT CO AS OptVal, CStr(CO) + ' - ' + ChangeDesc AS OptText FROM Changes WHERE (RefType = 'CO') AND ((ChStatus = 'CREQ') OR (ChStatus = 'REQ')) ORDER BY CO"
			Case "DOC": sCMD = "SELECT DocID AS OptVal, DocID + ' - ' + DocDesc AS OptText FROM Documents WHERE ((DocStatus = 'CREQ') OR (DocStatus = 'REQ')) ORDER BY DocID"
			Case "MDISP": sCMD = "SELECT MatDispID AS OptVal, OrderDateBatch AS OptText FROM MatDisp WHERE ((DispStatus <> 'COMPL') AND (DispStatus <> 'HOLD')) ORDER BY MatDispID"
			Case "NCR": sCMD = "SELECT RefNum AS OptVal, CStr(RefNum) + ' - ' + IssueDesc AS OptText FROM QActions WHERE (RefType = 'NCR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ')) ORDER BY RefNum"
			Case "PROJ": sCMD = "SELECT ProjNum AS OptVal, Project AS OptText FROM QProject WHERE ((ProjStatus = 'ACT') OR (ProjStatus = 'PLN')) ORDER BY ProjNum"
			Case "TASK": sCMD = "SELECT TaskID AS OptVal, CStr(TaskID) + ' - ' + TaskDesc AS OptText FROM Tasks WHERE (TaskStatus = 'OPEN') ORDER BY TaskID"
		End Select
	End If
	If (sCMD <> "") Then
		sRList = GetWFSelect("SQL", "", sCMD)
	End If
	
	GetGenRefList = sRList
End Function

Function GetRStatusList(sRType, sSel)
	Dim sRSList
	
	Select Case sRType
		Case "DOC": sRSList = GetSelect("DocStatus", sSel)
		Case "CO": sRSList = GetSelect("ChStatus", sSel)
		Case "TASK": sRSList = GetSelect("TaskStatus", sSel)
		'Case "CAR": sRSList = GetSelect("", "")
		Case "MDISP": sRSList = GetWFSelect("SQL", sSel, "SELECT OptCode AS OptVal, OptDesc AS OptText FROM QDispStatus ORDER BY OptDesc")
		'Case "NCR": sRSList = GetSelect("", "")
		Case "PROJ": sRSList = GetWFSelect("SQL", sSel, "SELECT OptCode AS OptVal, OptDesc AS OptText FROM QProjStatus ORDER BY OptDesc")
	End Select
	
	GetRStatusList = sRSList
End Function

Function GetRStatusVal(sRType, sSel)
	Dim sRSVal
	Dim sCMD
	
	Select Case sRType
		Case "DOC": sCMD = "SELECT OptDesc AS RetVal FROM QDocStatus WHERE (OptCode = '" & sSel & "')"
		Case "CO": sCMD = "SELECT OptDesc AS RetVal FROM QChStatus WHERE (OptCode = '" & sSel & "')"
		Case "TASK": sCMD = "SELECT OptDesc AS RetVal FROM QTaskStatus WHERE (OptCode = '" & sSel & "')"
		'Case "CAR": sList = GetSelect("", "")
		Case "MDISP": sCMD = "SELECT OptDesc AS RetVal FROM QDispStatus WHERE (OptCode = '" & sSel & "')"
		'Case "NCR": sList = GetSelect("", "")
		Case "PROJ": sCMD = "SELECT OptDesc AS RetVal FROM QProjStatus WHERE (OptCode = '" & sSel & "')"
	End Select
	sRSVal = GetDataValue(sCMD, Nothing)
	If (sRSVal = "") Then sRSVal = sSel
	
	GetRStatusVal = sRSVal
End Function

Function GetAssignInfo(sType, nAssign)
	Dim sRInfo
	Dim sCMD
	
	Select Case sType
		Case "EMP": sCMD = "SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & nAssign & ")"
		Case Else: sCMD = "SELECT WFGroup AS RetVal FROM ViewWFGroups WHERE (WFGID = " & nAssign & ")"
	End Select
	sRInfo = GetDataValue(sCMD, Nothing)
	
	GetAssignInfo = sRInfo
End Function

Function GetWFInfo(sRType, sRID)
	Dim sRText
	Dim sCMD
	Dim oRS
	Dim sTemp
	
	If ((sRType = "") Or (sRID = "")) Then
		If ((Request.QueryString("RT") <> "") And (Request.QueryString("R") <> "")) Then
			sRType = Request.QueryString("RT")
			sRID = Request.QueryString("R")
		Else
			If ((Request.Form("RT") <> "") And (Request.Form("RID") <> "")) Then
				sRType = Request.Form("RT")
				sRID = Request.Form("RID")
			End If
		End If
	End If
	
	If ((sRType <> "") And (sRID <> "")) Then
		sRText = "    <table class='my-4' border='0' cellpadding='2' cellspacing='0' width='100%'>"
		sRText = sRText & vbCrLf & "      <tr>"
		sRText = sRText & vbCrLf & "        <td colspan='6' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Information</strong></font></td>"
		sRText = sRText & vbCrLf & "      </tr>"
		sCMD = "SELECT DISTINCT WTID, TType, WTName, RType, RefNum, WFCreated FROM ViewWFInfo "
		sCMD = sCMD & "WHERE ((RefType = '" & sRType & "') AND (RefNum = '" & sRID & "'))"
		Set oRS = GetADORecordset(sCMD, Nothing)
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td align='left'><font face='Verdana' size='2'><strong>Template Type:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("TType") & "</font></td>"
			sRText = sRText & vbCrLf & "        <td colspan='2' align='left'><font face='Verdana' size='2'><strong>Template:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'>" & oRS("WTName") & "</font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td align='left'><font face='Verdana' size='2'><strong>Reference Type:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("RType") & "</font></td>"
			sRText = sRText & vbCrLf & "        <td colspan='2' align='left'><font face='Verdana' size='2'><strong>Reference ID:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'>" & oRS("RefNum") & "</font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td align='left'><font face='Verdana' size='2'><strong>Created:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("WFCreated") & "</font></td>"
			sRText = sRText & vbCrLf & "        <td align='left'><font face='Verdana' size='2'><strong># Steps:</strong></font></td>"
			sTemp = GetDataValue("SELECT COUNT(WTIStep) AS RetVal FROM WFlowTempItems WHERE (WTID = " & oRS("WTID") & ")", Nothing)
			sRText = sRText & vbCrLf & "        <td><font face='Verdana' size='2'>" & sTemp & "</font></td>"
			sRText = sRText & vbCrLf & "        <td align='left'><font face='Verdana' size='2'><strong># Tasks:</strong></font></td>"
			sTemp = GetDataValue("SELECT COUNT(TaskID) AS RetVal FROM WFlowTasks WHERE (WTID = " & oRS("WTID") & ") AND (WFActive = TRUE)", Nothing)
			sRText = sRText & vbCrLf & "        <td><font face='Verdana' size='2'>" & sTemp & "</font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			oRS.Close
		End If
		sRText = sRText & vbCrLf & "    </table>"
		Set oRS = Nothing
	Else
		sRText = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while attempting to "
		sRText = sRText & vbCrLf & "build the item listing. The [Workflow Reference] was not supplied properly.</font></p>"
	End If
	
	GetWFInfo = sRText
End Function

Function GetTHead(nTID)
	Dim sRText
	Dim oRS
	
	If (nTID <> "") Then
		Set oRS = GetADORecordset("SELECT WTName, TType, WTDesc FROM ViewWFTemp WHERE (WTID = " & nTID & ")", Nothing)
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			sRText = "    <table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td valign='top' nowrap colspan='4' bgcolor='#D7D7D7'>"
			sRText = sRText & vbCrLf & "         <font face='Verdana' size='3'><strong>Template Header Information</strong></font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td align='right' nowrap><font face='Verdana' size='2'><strong>Template Name:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("WTName") & "</font></td>"
			sRText = sRText & vbCrLf & "        <td align='right'><font face='Verdana' size='2'><strong>Template Type:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("TType") & "</font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td align='right' nowrap valign='top'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
			sRText = sRText & vbCrLf & "        <td colspan='3' valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("WTDesc")), "", oRS("WTDesc")) & "</font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td align='center' nowrap colspan='4'><font face='Verdana' size='2'><strong>"
			sRText = sRText & vbCrLf & "        <a href='wf_add_temp.asp?M=U&T=" & nTID & "'>Edit Header Information</a> &#149; "
			sRText = sRText & vbCrLf & "         <a href='wf_add_act.asp'>Create New Workflow Action</a></strong></font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf & "    </table>"
			oRS.Close
		End If
	Else
		sRText = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while "
		sRText = sRText & vbCrLf & "attempting to build the header. The [Template ID] was not supplied properly.</font></p>"
	End If
	Set oRS = Nothing
	
	GetTHead = sRText
End Function

Function GetAList()
	Dim sRText
	Dim oRS
	Dim sLink
	
	Set oRS = GetADORecordset("SELECT DISTINCT AType, WAName, WAID FROM ViewWFActions", Nothing)
	If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
		sRText = "    <table border='0' cellpadding='2' cellspacing='0' width='100%'>"
		sRText = sRText & vbCrLf & "      <tr>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Type</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Name</strong></font></td>"
		sRText = sRText & vbCrLf & "      </tr>"
		oRS.MoveFirst
		Do
			sLink = "<a href='wf_add_act.asp?M=RU&A=" & oRS("WAID") & "'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
			sLink = sLink & vbCrLf & "<a href='wf_add_act.asp?M=AD&A=" & oRS("WAID") & "'><img src='../graphics/delete.gif' alt='Delete' border='0' WIDTH='18' HEIGHT='18'></a>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td valign='top' nowrap>" & sLink & "</td>"		'Button links
			sRText = sRText & vbCrLf & "        <td valign='top' nowrap><font face='Verdana' size='2'>" & oRS("AType") & "</font></td>"
			sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WAName") & "</font></td>"	
			sRText = sRText & vbCrLf & "      </tr>"
			oRS.MoveNext
		Loop Until oRS.EOF
		oRS.Close
		sRText = sRText & vbCrLf & "    </table>"
	Else
		sRText = "    <table border='0' cellpadding='2' cellspacing='0' width='100%'>"
		sRText = sRText & vbCrLf & "      <tr>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Type</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Name</strong></font></td>"
		sRText = sRText & vbCrLf & "      </tr>"
		sRText = sRText & vbCrLf & "      <tr>"
		sRText = sRText & vbCrLf & "        <td colspan='3'><font face='Verdana' size='3'>NO RECORDS RETURNED</font></td>"
		sRText = sRText & vbCrLf & "      </tr>"
		sRText = sRText & vbCrLf & "    </table>"
	End If
	Set oRS = Nothing
	
	GetAList = sRText
End Function

Function GetTIList(nTID)
	Dim sRText
	Dim oRS
	Dim sLink
	
	If (nTID <> "") Then
		Set oRS = GetADORecordset("SELECT WTIID, WTIName, TIType, WTIStep, WTINext, WTIBack FROM ViewWFTItems WHERE (WTID = " & nTID & ") ORDER BY WTIStep", Nothing)
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			Do
				sLink = "<a href='wf_addedit.asp?M=R3&T=" & nTID & "&TI=" & oRS("WTIID") & "'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
				sLink = sLink & vbCrLf & "<a href='wf_addedit.asp?M=ID&T=" & nTID & "&TI=" & oRS("WTIID") & "'><img src='../graphics/delete.gif' alt='Delete' border='0' WIDTH='18' HEIGHT='18'></a>"
				sRText = IIf(sRText <> "", sRText & vbCrLf, "") & "      <tr>"
				sRText = sRText & vbCrLf & "        <td valign='top'>" & sLink & "</td>"		'Button links
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WTIStep") & "</font></td>"		'Step Num
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WTIName") & "</font></td>"		'Action
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WTINext") & "</font></td>"		'Next Step
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WTIBack") & "</font></td>"		'Back Step
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("TIType") & "</font></td>"		'Action Type
				sRText = sRText & vbCrLf & "      </tr>"
				oRS.MoveNext
			Loop Until oRS.EOF
			oRS.Close
		Else
			sRText = "      <tr>"
			sRText = sRText & vbCrLf & "        <td colspan='6'><font face='Verdana' size='3'>NO RECORDS RETURNED</font></td>"		'Action Type
			sRText = sRText & vbCrLf & "      </tr>"
		End If
		Set oRS = Nothing
	Else
		'sRText = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while "
		'sRText = sRText & vbCrLf & "attempting to build the item listing. The [Template ID] was not supplied properly.</font></p>"
	End If
	
	GetTIList = sRText
End Function

Function GetWFTaskList(sRType, sRID)
	Dim sRText
	Dim sCMD
	Dim oRS
	Dim sLink
	
	If ((sRType = "") Or (sRID = "")) Then
		If ((Request.QueryString("RT") <> "") And (Request.QueryString("R") <> "")) Then
			sRType = Request.QueryString("RT")
			sRID = Request.QueryString("R")
		Else
			If ((Request.Form("RT") <> "") And (Request.Form("RID") <> "")) Then
				sRType = Request.Form("RT")
				sRID = Request.Form("RID")
			End If
		End If
	End If
	
	If ((sRType <> "") And (sRID <> "")) Then
		sRText = "    <table border='0' cellpadding='2' cellspacing='0' width='100%'>"
		sRText = sRText & vbCrLf & "      <tr>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Task ID</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Step</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
		sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
		sRText = sRText & vbCrLf & "      </tr>"
		sCMD = "SELECT WATID, RefType, RefNum, TaskID, TaskDesc, Status, WFActive, WATActive, WATStatus, WATType, WATStep, PlannedStart, BFinish, ActualStart, ActualFinish "
		sCMD = sCMD & "FROM ViewWFTasks WHERE ((RefType = '" & sRType & "') AND (RefNum = '" & sRID & "')) AND (WFActive = TRUE) ORDER BY TStep, TSubstep"
		Set oRS = GetADORecordset(sCMD, Nothing)
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			Do
				sLink = "<a href='wf_view.asp?T=" & oRS("TaskID") & "&RT=" & sRType & "&R=" & sRID & "'><img src='../graphics/find.gif' alt='View' border='0' WIDTH='18' HEIGHT='18'></a>"
				sLink = sLink & vbCrLf & "<a href='wf_gen_tasks1.asp?M=MT&WT=" & oRS("WATID") & "&RT=" & sRType & "&R=" & sRID & "'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
				sLink = sLink & vbCrLf & "<a href='wf_upd_task.asp?T=" & oRS("TaskID") & "&TY=" & oRS("WATType") & "'><img src='../graphics/clock.gif' alt='Update' border='0' WIDTH='18' HEIGHT='18'></a>"
				sLink = sLink & vbCrLf & "<a href='wf_gen_tasks1.asp?M=DT&WT=" & oRS("TaskID") & "&RT=" & sRType & "&R=" & sRID & "'><img src='../graphics/delete.gif' alt='Delete' border='0' WIDTH='18' HEIGHT='18'></a>"
				sRText = sRText & vbCrLf & "      <tr>"
				sRText = sRText & vbCrLf & "        <td valign='top'>" & sLink & "</td>"		'Button links
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("TaskID") & "</font></td>"
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font></td>"
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("Status") & "</font></td>"
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WATStep") & "</font></td>"
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WATStatus") & "</font></td>"
				Select Case oRS("WATStatus")
					Case "ACTIVE"
						sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("PlannedStart") & "</font></td>"
						sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("BFinish") & "</font></td>"
					Case "COMPLETED"
						sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("ActualStart") & "</font></td>"
						sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("ActualFinish") & "</font></td>"
					Case Else
						sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'> -- </font></td>"
						sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'> -- </font></td>"
				End Select
				sRText = sRText & vbCrLf & "      </tr>"
				oRS.MoveNext
			Loop Until oRS.EOF
			oRS.Close
		Else
			sRText = "      <tr>"
			sRText = sRText & vbCrLf & "        <td colspan='8'><font face='Verdana' size='3'>NO RECORDS RETURNED</font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
		End If
		sRText = sRText & vbCrLf & "    </table>"
		Set oRS = Nothing
	Else
		sRText = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while attempting to "
		sRText = sRText & vbCrLf & "build the item listing. The [Workflow Reference] was not supplied properly.</font></p>"
	End If
	
	GetWFTaskList = sRText
End Function

Function GetGList()
	Dim sRText
	Dim oRS
	
	Set oRS = GetADORecordset("SELECT WFGID, GType, WFGroup FROM ViewWFGroups ORDER BY GType, WFGroup", Nothing)
	If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
		oRS.MoveFirst
		Do
			sLink = "<a href='wf_rtgroups.asp?M=M&G=" & oRS("WFGID") & "'><img src='../graphics/find.gif' alt='Open' border='0' WIDTH='18' HEIGHT='18'></a>"
			sLink = sLink & vbCrLf & "<a href='wf_rtgroups.asp?M=GU&G=" & oRS("WFGID") & "'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
			sLink = sLink & vbCrLf & "<a href='wf_rtgroups.asp?M=GD&G=" & oRS("WFGID") & "'><img src='../graphics/delete.gif' alt='Delete' border='0' WIDTH='18' HEIGHT='18'></a>"
			sRText = IIf(sRText <> "", sRText & vbCrLf, "") & "      <tr>"
			sRText = sRText & vbCrLf & "        <td valign='top'>" & sLink & "</td>"		'Button links
			sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("GType") & "</font></td>"		'Step Num
			sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("WFGroup")), "", oRS("WFGroup")) & "</font></td>"		'Action
			sRText = sRText & vbCrLf & "      </tr>"
			oRS.MoveNext
		Loop Until oRS.EOF
		oRS.Close
	Else
		sRText = "      <tr>"
		sRText = sRText & vbCrLf & "        <td colspan='3'><font face='Verdana' size='3'>NO RECORDS RETURNED</font></td>"		'Action Type
		sRText = sRText & vbCrLf & "      </tr>"
	End If
	Set oRS = Nothing
	
	GetGList = sRText
End Function

Function GetGMList(nGID)
	Dim sRText
	Dim oRS
	Dim sLink
	
	If (nGID <> "") Then
		Set oRS = GetADORecordset("SELECT WFMID, WFMName, WFMEmail, ULNF, EmpEMail FROM ViewWFGMembs WHERE (WFGID = " & nGID & ") ORDER BY WFMName", Nothing)
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			sRText = "    <table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'></font></strong></td>"
			sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Name</font></strong></td>"
			sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>E-Mail</strong></font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			Do
				sLink = "<a href='wf_rtgroups.asp?M=MU&G=" & nGID & "&GM=" & oRS("WFMID") & "'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
				sLink = sLink & vbCrLf & "<a href='wf_rtgroups.asp?M=MD&G=" & nGID & "&GM=" & oRS("WFMID") & "'><img src='../graphics/delete.gif' alt='Delete' border='0' WIDTH='18' HEIGHT='18'></a>"
				sRText = sRText & vbCrLf & "      <tr>"
				sRText = sRText & vbCrLf & "        <td valign='top'>" & sLink & "</td>"		'Button links
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("WFMName") & "</font></td>"		'Step Num
				sRText = sRText & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("WFMEmail")), IIf(IsNull(oRS("EmpEMail")), "NONE", oRS("EmpEMail")), oRS("WFMEmail")) & "</font></td>"		'Action
				sRText = sRText & vbCrLf & "      </tr>"
				oRS.MoveNext
			Loop Until oRS.EOF
			oRS.Close
			sRText = sRText & vbCrLf & "    </table>"
		Else
			sRText = "    <table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRText = sRText & vbCrLf & "      <tr>"
			sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'></font></strong></td>"
			sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Name</font></strong></td>"
			sRText = sRText & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>E-Mail</strong></font></td>"
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf &  "      <tr>"
			sRText = sRText & vbCrLf & "        <td colspan='3'><font face='Verdana' size='3'>NO RECORDS RETURNED</font></td>"		'Action Type
			sRText = sRText & vbCrLf & "      </tr>"
			sRText = sRText & vbCrLf & "    </table>"
		End If
		Set oRS = Nothing
	Else
		sRText = ""
	End If
	
	GetGMList = sRText
End Function

%>

