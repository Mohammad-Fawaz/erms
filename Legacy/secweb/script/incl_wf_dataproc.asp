<%
Sub DeleteItem(sType, nID)
	Dim sCMD
	
	sCMD = ""
	If ((sType <> "") And (nID <> "") And (CLng(nID) > 0)) Then
		Select Case sType
			
			Case "TItem": sCMD = "DELETE * FROM WFlowTempItems WHERE (WTIID = " & nID & ")"
			
			Case "GMemb": sCMD = "DELETE * FROM WFGroupMembs WHERE (WFMID = " & nID & ")"
			
			Case "Group"
				RunSQLCmd "DELETE * FROM WFGroupMembs WHERE (WFGID = " & nID & ")", Nothing
				sCMD = "DELETE * FROM WFGroups WHERE (WFGID = " & nID & ")"
			
			Case "WFTask"
				RunSQLCmd "DELETE * FROM WFlowTasks WHERE (TaskID = " & nID & ")", Nothing
				sCMD = "DELETE * FROM Tasks WHERE (TaskID = " & nID & ")"
		End Select
	End If
	If (sCMD <> "") Then
		RunSQLCmd sCMD, Nothing
	End If
End Sub

Function UpdWFTask(nID, sType)
	Dim sFields
	Dim sVals
	Dim sCMD
	Dim sTemp
	
	sCMD = ""
	Select Case sType
		Case "A"
			
		Case "R"
			
		Case "T"
			
	End Select
	
	If (sCMD <> "") Then
		RunSQLCmd sCMD, Nothing
	End If
	
	
End Function

Function SaveGroup(sNew, nID)
	Dim sFields
	Dim sVals
	Dim sCMD
	
	If (sNew = "T") Then
		sCMD = "SELECT (MAX(WFGID) + 1) AS RetVal FROM WFGroups"
		nID = GetDataValue(sCMD, Nothing)
		'WFGID
		If (nID <> "") Then
			sFields = "WFGID"
			sVals = nID
		Else
			sFields = "WFGID"
			sVals = "1"
			nID = 1
		End If
		'WFGroupType
		If ((Request.Form("GType") <> "") And (Request.Form("GType") <> "SELECT")) Then
			sFields = sFields & ", WFGroupType"
			sVals = sVals & ", '" & Request.Form("GType") & "'"
		End If
		'WFGroup
		If (Request.Form("GName") <> "") Then
			sFields = sFields & ", WFGroup"
			sVals = sVals & ", '" & Request.Form("GName") & "'"
		End If
		
		sCMD = "INSERT INTO WFGroups (" & sFields & ") VALUES (" & sVals & ")"
	Else
		'WFGID
		sVals = "WFGID = " & nID
		'WFGroupType
		If ((Request.Form("GType") <> "") And (Request.Form("GType") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WFGroupType = '" & Request.Form("GType") & "'"
		End If
		'WFGroup
		If (Request.Form("GName") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WFGroup = '" & Request.Form("GName") & "'"
		End If
		
		sCMD = "UPDATE WFGroups SET " & sFields & " WHERE (" & sVals & ")"
	End If
	
	RunSQLCmd sCMD, Nothing
	SaveGroup = nID
End Function

Sub SaveGMemb(sNew, nID)
	Dim sFields
	Dim sVals
	Dim sTemp
	Dim sCMD
	
	If (sNew = "T") Then
		'WFMID (Auto Number)
		'WFGID
		sFields = "WFGID"
		sVals = Request.Form("GID")
		'WFMName
		If (Request.Form("MName") <> "") Then
			sFields = sFields & ", WFMName"
			sVals = sVals & ", '" & Request.Form("MName") & "'"
			'WFMEmpID
			If ((Request.Form("EmpID") <> "") And (Request.Form("EmpID") <> "SELECT")) Then
				sFields = sFields & ", WFMEmpID"
				sVals = sVals & ", " & Request.Form("EmpID")
				'WFMEmail
				sTemp = GetDataValue("SELECT EmpEMail AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("EmpID") & ")", Nothing)
				If (sTemp <> "") Then
					sFields = sFields & ", WFMEmail"
					sVals = sVals & ", '" & sTemp & "'"
				Else
					If (Request.Form("MEmail") <> "") Then
						sFields = sFields & ", WFMEmail"
						sVals = sVals & ", '" & Request.Form("MEmail") & "'"
					End If
				End If
			Else
				'WFMEmail
				If (Request.Form("MEmail") <> "") Then
					sFields = sFields & ", WFMEmail"
					sVals = sVals & ", '" & Request.Form("MEmail") & "'"
				End If
			End If
		Else
			'WFMEmpID
			If ((Request.Form("EmpID") <> "") And (Request.Form("EmpID") <> "SELECT")) Then
				sFields = sFields & ", WFMEmpID"
				sVals = sVals & ", " & Request.Form("EmpID")
				'WFMName
				sTemp = GetDataValue("SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("EmpID") & ")", Nothing)
				sFields = sFields & ", WFMName"
				sVals = sVals & ", '" & sTemp & "'"
				'WFMEmail
				sTemp = GetDataValue("SELECT EmpEMail AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("EmpID") & ")", Nothing)
				If (sTemp <> "") Then
					sFields = sFields & ", WFMEmail"
					sVals = sVals & ", '" & sTemp & "'"
				Else
					If (Request.Form("MEmail") <> "") Then
						sFields = sFields & ", WFMEmail"
						sVals = sVals & ", '" & Request.Form("MEmail") & "'"
					End If
				End If
			Else
				'WFMEmail
				If (Request.Form("MEmail") <> "") Then
					sFields = sFields & ", WFMEmail"
					sVals = sVals & ", '" & Request.Form("MEmail") & "'"
				End If
			End If
		End If
		
		sCMD = "INSERT INTO WFGroupMembs (" & sFields & ") VALUES (" & sVals & ")"
	Else
		'WFMID
		sVals = "WFMID = " & nID
		'WFGID (No update)
		'WFMName
		If (Request.Form("MName") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMName = '" & Request.Form("MName") & "'"
			'WFMEmpID
			If ((Request.Form("EmpID") <> "") And (Request.Form("EmpID") <> "SELECT")) Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmpID = " & Request.Form("EmpID")
				'WFMEmail
				sTemp = GetDataValue("SELECT EmpEMail AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("EmpID") & ")", Nothing)
				If (sTemp <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = '" & sTemp & "'"
				Else
					If (Request.Form("MEmail") <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = '" & Request.Form("MEmail") & "'"
					Else
						sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = NULL"
					End If
				End If
			Else
				'WFMEmpID
				sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmpID = NULL"
				'WFMEmail
				If (Request.Form("MEmail") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = '" & Request.Form("MEmail") & "'"
				Else
					sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = NULL"
				End If
			End If
		Else
			'WFMEmpID
			If ((Request.Form("EmpID") <> "") And (Request.Form("EmpID") <> "SELECT")) Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmpID = " & Request.Form("EmpID")
				'WFMName
				sTemp = GetDataValue("SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("EmpID") & ")", Nothing)
				sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMName = '" & sTemp & "'"
				'WFMEmail
				sTemp = GetDataValue("SELECT EmpEMail AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("EmpID") & ")", Nothing)
				If (sTemp <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = '" & sTemp & "'"
				Else
					If (Request.Form("MEmail") <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = '" & Request.Form("MEmail") & "'"
					End If
				End If
			Else
				'WFMEmpID
				sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmpID = NULL"
				'WFMEmail
				If (Request.Form("MEmail") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = '" & Request.Form("MEmail") & "'"
				Else
					sFields = IIf(sFields <> "", sFields & ", ", "") & "WFMEmail = NULL"
				End If
			End If
		End If
		
		sCMD = "UPDATE WFGroupMembs SET " & sFields & " WHERE (" & sVals & ")"
	End If
	
	RunSQLCmd sCMD, Nothing
End Sub

Sub SaveAction(sNew, nID)
	Dim sFields
	Dim sVals
	Dim sCMD
	Dim sTemp
	
	If (sNew = "T") Then
		sCMD = "SELECT (MAX(WAID) + 1) AS RetVal FROM WFlowActions"
		nID = GetDataValue(sCMD, Nothing)
		'WAID
		If (nID <> "") Then
			sFields = "WAID"
			sVals = nID
		Else
			sFields = "WAID"
			sVals = "1"
			nID = 1
		End If
		'WAName
		If (Request.Form("AName") <> "") Then
			sFields = sFields & ", WAName"
			sVals = sVals & ", '" & CheckStrData(Request.Form("AName"), "SAVE") & "'"
		End If
		'WAType
		If (Request.Form("AType") <> "SELECT") Then
			sFields = sFields & ", WAType"
			sVals = sVals & ", '" & Request.Form("AType") & "'"
		End If
		'WADesc
		If (Request.Form("ADesc") <> "") Then
			sFields = sFields & ", WADesc"
			sVals = sVals & ", '" & CheckStrData(Request.Form("ADesc"), "SAVE") & "'"
		End If
		'WAStdTaskID
		If ((Request.Form("StdTask") <> "") And (Request.Form("StdTask") <> "SELECT")) Then
			sFields = sFields & ", WAStdTaskID"
			sVals = sVals & ", '" & Request.Form("StdTask") & "'"
		End If
		'WAChgAcct
		If (Request.Form("ChgAcct") <> "") Then
			sFields = sFields & ", WAChgAcct"
			sVals = sVals & ", '" & CheckStrData(Request.Form("ChgAcct"), "SAVE") & "'"
		End If
		'WADur
		If (Request.Form("ADur") <> "") Then
			sFields = sFields & ", WADur"
			sVals = sVals & ", " & Request.Form("ADur")
		End If
		'WAHrs
		If (Request.Form("AHrs") <> "") Then
			sFields = sFields & ", WAHrs"
			sVals = sVals & ", " & Request.Form("AHrs")
		End If
		'WAMins
		If (Request.Form("AMin") <> "") Then
			sFields = sFields & ", WAMins"
			sVals = sVals & ", " & Request.Form("AMin")
		End If
		'WACost
		If (Request.Form("ACost") <> "") Then
			sFields = sFields & ", WACost"
			sVals = sVals & ", " & Request.Form("ACost")
		End If
		'WAAByType
		If ((Request.Form("AssignerType") <> "") And (Request.Form("AssignerType") <> "SELECT")) Then
			sFields = sFields & ", WAAByType"
			sVals = sVals & ", '" & Request.Form("AssignerType") & "'"
		End If
		'WAAssnBy
		If ((Request.Form("AssnBy") <> "") And (Request.Form("AssnBy") <> "SELECT")) Then
			sFields = sFields & ", WAAssnBy"
			sVals = sVals & ", " & Request.Form("AssnBy")
		End If
		'WAAToType
		If ((Request.Form("AssigneeType") <> "") And (Request.Form("AssigneeType") <> "SELECT")) Then
			sFields = sFields & ", WAAToType"
			sVals = sVals & ", '" & Request.Form("AssigneeType") & "'"
		End If
		'WAAssnTo
		If ((Request.Form("AssnTo") <> "") And (Request.Form("AssnTo") <> "SELECT")) Then
			sFields = sFields & ", WAAssnTo"
			sVals = sVals & ", " & Request.Form("AssnTo")
		End If
		'WACtrlRef
		If ((Request.Form("CRef") <> "") And (Request.Form("CRef") <> "SELECT")) Then
			sFields = sFields & ", WACtrlRef"
			sVals = sVals & ", '" & Request.Form("CRef") & "'"
			'WAParams
			sTemp = IIf(Request.Form("P1") = "Y", "1", "0") & IIf(Request.Form("P2") = "Y", "1", "0")
			sFields = sFields & ", WAParams"
			sVals = sVals & ", '" & sTemp & "'"
		End If
		
		sCMD = "INSERT INTO WFlowActions (" & sFields & ") VALUES (" & sVals & ")"
	Else
		'WAID
		sVals = "WAID = " & nID
		'WAName
		If (Request.Form("AName") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAName = '" & CheckStrData(Request.Form("AName"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAName = NULL"
		End If
		'WAType
		If (Request.Form("AType") <> "SELECT") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAType = '" & Request.Form("AType") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAType = NULL"
		End If
		'WADesc
		If (Request.Form("ADesc") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WADesc = '" & CheckStrData(Request.Form("ADesc"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WADesc = NULL"
		End If
		'WAStdTaskID
		If ((Request.Form("StdTask") <> "") And (Request.Form("StdTask") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAStdTaskID = '" & Request.Form("StdTask") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAStdTaskID = NULL"
		End If
		'WAChgAcct
		If (Request.Form("ChgAcct") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAChgAcct = '" & CheckStrData(Request.Form("ChgAcct"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAChgAcct = NULL"
		End If
		'WADur
		If (Request.Form("ADur") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WADur = " & Request.Form("ADur")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WADur = 0"
		End If
		'WAHrs
		If (Request.Form("AHrs") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAHrs = " & Request.Form("AHrs")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAHrs = 0"
		End If
		'WAMins
		If (Request.Form("AMin") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAMins = " & Request.Form("AMin")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAMins = 0"
		End If
		'WACost
		If (Request.Form("ACost") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WACost = " & Request.Form("ACost")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WACost = 0"
		End If
		'WAAByType
		If ((Request.Form("AssignerType") <> "") And (Request.Form("AssignerType") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAByType = '" & CheckStrData(Request.Form("AssignerType"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAByType = NULL"
		End If
		'WAAssnBy
		If ((Request.Form("AssnBy") <> "") And (Request.Form("AssnBy") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAssnBy = " & Request.Form("AssnBy")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAssnBy = NULL"
		End If
		'WAAToType
		If ((Request.Form("AssigneeType") <> "") And (Request.Form("AssigneeType") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAToType = '" & CheckStrData(Request.Form("AssigneeType"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAToType = NULL"
		End If
		'WAAssnTo
		If ((Request.Form("AssnTo") <> "") And (Request.Form("AssnTo") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAssnTo = " & Request.Form("AssnTo")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAAssnTo = NULL"
		End If
		'WACtrlRef
		If ((Request.Form("CRef") <> "") And (Request.Form("CRef") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WACtrlRef = '" & Request.Form("CRef") & "'"
			'WAParams
			sTemp = IIf(Request.Form("P1") = "Y", "1", "0") & IIf(Request.Form("P2") = "Y", "1", "0")
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAParams = '" & sTemp & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WACtrlRef = NULL"
			'WAParams
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WAParams = NULL"
		End If
		
		sCMD = "UPDATE WFlowActions SET " & sFields & " WHERE (" & sVals & ")"
	End If
	
	RunSQLCmd sCMD, Nothing
End Sub

Function SaveTemp(sNew, nID)
	Dim sFields
	Dim sVals
	Dim sCMD
	Dim vRet
	
	If (sNew = "T") Then
		vRet = GetDataValue("SELECT (MAX(WTID) + 1) AS RetVal FROM WFlowTemplate", Nothing)
		'WTID
		If (vRet <> "") Then
			sFields = "WTID"
			sVals = vRet
		Else
			vRet = 1
			sFields = "WTID"
			sVals = vRet
		End If
		'WTName
		If (Request.Form("TName") <> "") Then
			sFields = sFields & ", WTName"
			sVals = sVals & ", '" & CheckStrData(Request.Form("TName"), "SAVE") & "'"
		End If
		'WTType
		If (Request.Form("TType") <> "SELECT") Then
			sFields = sFields & ", WTType"
			sVals = sVals & ", '" & Request.Form("TType") & "'"
		End If
		'WTDesc
		If (Request.Form("TDesc") <> "") Then
			sFields = sFields & ", WTDesc"
			sVals = sVals & ", '" & CheckStrData(Request.Form("TDesc"), "SAVE") & "'"
		End If
		
		sCMD = "INSERT INTO WFlowTemplate (" & sFields & ") VALUES (" & sVals & ")"
	Else
		'WTID
		vRet = nID
		sVals = "WTID = " & vRet
		'WTName
		If (Request.Form("TName") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTName = '" & CheckStrData(Request.Form("TName"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTName = NULL"
		End If
		'WTType
		If (Request.Form("TType") <> "SELECT") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTType = '" & Request.Form("TType") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTType = NULL"
		End If
		'WTDesc
		If (Request.Form("TDesc") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTDesc = '" & CheckStrData(Request.Form("TDesc"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTDesc = NULL"
		End If
		
		sCMD = "UPDATE WFlowTemplate SET " & sFields & " WHERE (" & sVals & ")"
	End If
	
	RunSQLCmd sCMD, Nothing
	SaveWFTemp = vRet
End Function

Sub SaveTItem(sNew, nID)
	Dim sFields
	Dim sVals
	Dim sCMD
	Dim sTemp
	
	If (sNew = "T") Then
		'sCMD = "SELECT (MAX(WTIID) + 1) AS RetVal FROM WFlowTempItems"
		'nID = GetDataValue(sCMD, Nothing)
		'WTIID
		'sFields = "WTIID"
		'sVals = nID
		'WTID
		sFields = "WTID"
		sVals = Request.Form("TID")
		'WTIName
		sFields = sFields & ", WTIName"
		sVals = sVals & ", '" & Request.Form("AName") & "'"
		'WTIType
		sFields = sFields & ", WTIType"
		sVals = sVals & ", '" & Request.Form("AType") & "'"
		'WTIStep
		sFields = sFields & ", WTIStep"
		If (Request.Form("Step") <> "") Then
			sVals = sVals & ", '" & Request.Form("Step") & "'"
		Else
			sVals = sVals & ", NULL"
		End If
		'WTINext
		sFields = sFields & ", WTINext"
		If (Request.Form("Next") <> "") Then
			sVals = sVals & ", '" & Request.Form("Next") & "'"
		Else
			sVals = sVals & ", NULL"
		End If
		'WTINextStatus
		If ((Request.Form("NStatus") <> "") And (Request.Form("NStatus") <> "SELECT")) Then
			sFields = sFields & ", WTINextStatus"
			sVals = sVals & ", '" & Request.Form("NStatus") & "'"
		End If
		'WTIBack
		sFields = sFields & ", WTIBack"
		If (Request.Form("Back") <> "") Then
			sVals = sVals & ", '" & Request.Form("Back") & "'"
		Else
			sVals = sVals & ", NULL"
		End If
		'WTIBackStatus
		If ((Request.Form("BStatus") <> "") And (Request.Form("BStatus") <> "SELECT")) Then
			sFields = sFields & ", WTIBackStatus"
			sVals = sVals & ", '" & Request.Form("BStatus") & "'"
		End If
		'WTIDesc
		If (Request.Form("ADesc") <> "") Then
			sFields = sFields & ", WTIDesc"
			sVals = sVals & ", '" & Request.Form("ADesc") & "'"
		End If
		'WTIStdTaskID
		If ((Request.Form("StdTask") <> "") And (Request.Form("StdTask") <> "SELECT")) Then
			sFields = sFields & ", WTIStdTaskID"
			sVals = sVals & ", '" & Request.Form("StdTask") & "'"
		End If
		'WTIChgAcct
		If (Request.Form("ChgAcct") <> "") Then
			sFields = sFields & ", WTIChgAcct"
			sVals = sVals & ", '" & Request.Form("ChgAcct") & "'"
		End If
		'WTIDur
		sFields = sFields & ", WTIDur"
		If (Request.Form("ADur") <> "") Then
			sVals = sVals & ", " & Request.Form("ADur")
		Else
			sVals = sVals & ", 0"
		End If
		'WTIHrs
		sFields = sFields & ", WTIHrs"
		If (Request.Form("AHrs") <> "") Then
			sVals = sVals & ", " & Request.Form("AHrs")
		Else
			sVals = sVals & ", 0"
		End If
		'WTIMins
		sFields = sFields & ", WTIMins"
		If (Request.Form("AMin") <> "") Then
			sVals = sVals & ", " & Request.Form("AMin")
		Else
			sVals = sVals & ", 0"
		End If
		'WTICost
		sFields = sFields & ", WTICost"
		If (Request.Form("ACost") <> "") Then
			sVals = sVals & ", " & Request.Form("ACost")
		Else
			sVals = sVals & ", 0"
		End If
		'WTIAByType
		If ((Request.Form("AssignerType") <> "") And (Request.Form("AssignerType") <> "SELECT")) Then
			sFields = sFields & ", WTIAByType"
			sVals = sVals & ", '" & Request.Form("AssignerType") & "'"
			'WTIAssnBy
			If ((Request.Form("AssnBy") <> "") And (Request.Form("AssnBy") <> "SELECT")) Then
				sFields = sFields & ", WTIAssnBy"
				sVals = sVals & ", " & Request.Form("AssnBy")
			End If
		End If
		'WTIAToType
		If ((Request.Form("AssigneeType") <> "") And (Request.Form("AssigneeType") <> "SELECT")) Then
			sFields = sFields & ", WTIAToType"
			sVals = sVals & ", '" & Request.Form("AssigneeType") & "'"
			'WTIAssnTo
			If ((Request.Form("AssnTo") <> "") And (Request.Form("AssnTo") <> "SELECT")) Then
				sFields = sFields & ", WTIAssnTo"
				sVals = sVals & ", " & Request.Form("AssnTo")
			End If
		End If
		'WTICtrlRef
		If ((Request.Form("CRef") <> "") And (Request.Form("CRef") <> "SELECT")) Then
			sFields = sFields & ", WTICtrlRef"
			sVals = sVals & ", '" & Request.Form("CRef") & "'"
			'WTIParams
			sTemp = IIf(Request.Form("P1") = "Y", "1", "0") & IIf(Request.Form("P2") = "Y", "1", "0")
			sFields = sFields & ", WTIParams"
			sVals = sVals & ", '" & sTemp & "'"
		End If
		
		sCMD = "INSERT INTO WFlowTempItems (" & sFields & ") VALUES (" & sVals & ")"
	Else
		'WTIID
		sVals = "WTIID = " & nID
		'WTID
		'WTIName
		If (Request.Form("AName") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIName = '" & CheckStrData(Request.Form("AName"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIName = NULL"
		End If
		'WTIType
		If (Request.Form("AType") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIType = '" & Request.Form("AType") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIType = NULL"
		End If
		'WTIStep
		If (Request.Form("Step") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIStep = '" & Request.Form("Step") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIStep = NULL"
		End If
		'WTINext
		If (Request.Form("Next") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTINext = '" & Request.Form("Next") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTINext = NULL"
		End If
		'WTINextStatus
		If ((Request.Form("NStatus") <> "") And (Request.Form("NStatus") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTINextStatus = '" & Request.Form("NStatus") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTINextStatus = NULL"
		End If
		'WTIBack
		If (Request.Form("Back") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIBack = '" & Request.Form("Back") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIBack = NULL"
		End If
		'WTIBackStatus
		If ((Request.Form("BStatus") <> "") And (Request.Form("BStatus") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIBackStatus = '" & Request.Form("BStatus") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIBackStatus = NULL"
		End If
		'WTIDesc
		If (Request.Form("ADesc") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIDesc = '" & CheckStrData(Request.Form("ADesc"), "SAVE") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIDesc = NULL"
		End If
		'WTIStdTaskID
		If ((Request.Form("StdTask") <> "") And (Request.Form("StdTask") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIStdTaskID = '" & Request.Form("StdTask") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIStdTaskID = NULL"
		End If
		'WTIChgAcct
		If (Request.Form("ChgAcct") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIChgAcct = '" & Request.Form("ChgAcct") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIChgAcct = NULL"
		End If
		'WTIDur
		If (Request.Form("ADur") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIDur = " & Request.Form("ADur")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIDur = 0"
		End If
		'WTIHrs
		If (Request.Form("AHrs") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIHrs = " & Request.Form("AHrs")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIHrs = 0"
		End If
		'WTIMins
		If (Request.Form("AMin") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIMins = " & Request.Form("AMin")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIMins = 0"
		End If
		'WTICost
		If (Request.Form("ACost") <> "") Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTICost = " & Request.Form("ACost")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTICost = 0"
		End If
		'WTIAByType
		If ((Request.Form("AssignerType") <> "") And (Request.Form("AssignerType") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAByType = '" & Request.Form("AssignerType") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAByType = NULL"
		End If
		'WTIAssnBy
		If ((Request.Form("AssnBy") <> "") And (Request.Form("AssnBy") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAssnBy = " & Request.Form("AssnBy")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAssnBy = NULL"
		End If
		'WTIAToType
		If ((Request.Form("AssigneeType") <> "") And (Request.Form("AssigneeType") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAToType = '" & Request.Form("AssigneeType") & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAToType = NULL"
		End If
		'WTIAssnTo
		If ((Request.Form("AssnTo") <> "") And (Request.Form("AssnTo") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAssnTo = " & Request.Form("AssnTo")
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIAssnTo = NULL"
		End If
		'WTICtrlRef
		If ((Request.Form("CRef") <> "") And (Request.Form("CRef") <> "SELECT")) Then
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTICtrlRef = '" & Request.Form("CRef") & "'"
			'WTIParams
			sTemp = IIf(Request.Form("P1") = "Y", "1", "0") & IIf(Request.Form("P2") = "Y", "1", "0")
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIParams = '" & sTemp & "'"
		Else
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTICtrlRef = NULL"
			'WTIParams
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WTIParams = NULL"
		End If
		
		sCMD = "UPDATE WFlowTempItems SET " & sFields & " WHERE (" & sVals & ")"
	End If
	
	'Response.Write sCMD
	'Response.End
	
	RunSQLCmd sCMD, Nothing
	'SaveTItem = sCMD
End Sub










Sub GenWFTask()



	Dim sTFields, sTVals
	Dim sWFields, sWVals
	Dim sTF, sTV
	Dim sWF, sWV
	Dim sTCMD, sWCMD
	Dim oRS
	Dim nID
	Dim nS
	Dim vTemp
	Dim sTemp
	
	'---------------------------------------------------------------------------------
	'Table - Tasks
	'TaskCostType		W - Workflow
	'PcntComplete		0
	'SchedVisible		0
	'AutoGenerate		0
	'DateAssigned
	'---------------------------------------------------------------------------------
	sTFields = "TaskCostType, PcntComplete, SchedVisible, AutoGenerate, DateAssigned"
	
	sTVals = "'W', 0, 0, 0, #" & Date() & "#"
	'ChargeAcct
	If (Request.Form("WTIChgAcct") <> "") Then
		sTFields = sTFields & ", ChargeAcct"
		sTVals = sTVals & ", '" & Request.Form("WTIChgAcct") & "'"
	Else
		If ((Request.Form("DefAcct") <> "") And (Request.Form("DefAcct") <> "SELECT")) Then
			sTFields = sTFields & ", ChargeAcct"
			sTVals = sTVals & ", '" & Request.Form("DefAcct") & "'"
		End If
	End If
	'TaskPriority
	If ((Request.Form("DefPrior") <> "") And (Request.Form("DefPrior") <> "SELECT")) Then
		sTFields = sTFields & ", TaskPriority"
		sTVals = sTVals & ", '" & Request.Form("DefPrior") & "'"
	Else
		sTFields = sTFields & ", TaskPriority"
		sTVals = sTVals & ", 'OPEN'"
	End If
	'ProjNum
	If ((Request.Form("DefProj") <> "") And (Request.Form("DefProj") <> "SELECT")) Then
		sTFields = sTFields & ", ProjNum"
		sTVals = sTVals & ", '" & Request.Form("DefProj") & "'"
	End If
	'RefType
	If ((Request.Form("RT") <> "") And (Request.Form("RT") <> "SELECT")) Then
		sTFields = sTFields & ", RefType"
		sTVals = sTVals & ", '" & Request.Form("RT") & "'"
	End If
	'RefNum
	If (Request.Form("RID") <> "") Then
		sTFields = sTFields & ", RefNum"
		sTVals = sTVals & ", '" & Request.Form("RID") & "'"
	End If
	'StdTaskID
	If ((Request.Form("WTIStdTaskID") <> "") And (Request.Form("WTIStdTaskID") <> "SELECT")) Then
		sTFields = sTFields & ", StdTaskID"
		sTVals = sTVals & ", '" & Request.Form("WTIStdTaskID") & "'"
	End If
	'TaskDesc
	If (Request.Form("WTIName") <> "") Then
		sTFields = sTFields & ", TaskDesc"
		sTVals = sTVals & ", '" & Request.Form("WTIName") & "'"
	End If
	'TaskDetail
	If (Request.Form("WTIDesc") <> "") Then
		sTFields = sTFields & ", TaskDetail"
		sTVals = sTVals & ", '" & Request.Form("WTIDesc") & "'"
	End If
	'PlannedStart
	If (Request.Form("PStart") <> "") Then
		sTFields = sTFields & ", PlannedStart"
		sTVals = sTVals & ", #" & Request.Form("PStart") & "#"
	End If
	'PlannedFinish
	If (Request.Form("PFinish") <> "") Then
		sTFields = sTFields & ", PlannedFinish"
		sTVals = sTVals & ", #" & Request.Form("PFinish") & "#"
	End If
	'EstDur
	If ((Request.Form("PStart") <> "") And (Request.Form("PFinish") <> "")) Then
	
		vTemp = GetDataValue("SELECT SUM(WorkDay) AS RetVal FROM QCalendar WHERE ((CalDay >= #" & Request.Form("PStart") & "#) AND (CalDay <= #" & Request.Form("PFinish") & "#))", Nothing)
		
		sTFields = sTFields & ", EstDur"
		sTVals = sTVals & ", " & vTemp
		
		
	Else
		If (Request.Form("WTIDur") <> "") Then
			sTFields = sTFields & ", EstDur"
			sTVals = sTVals & ", " & Request.Form("WTIDur")
		End If
	End If
	
	'EstHours
	If ((Request.Form("WTIHrs") <> "") Or (Request.Form("WTIMins") <> "")) Then
		vTemp = 0
		If (Request.Form("WTIHrs") <> "") Then vTemp = vTemp + Request.Form("WTIHrs")
		If (Request.Form("WTIMins") <> "") Then vTemp = vTemp + (Request.Form("WTIMins") / 60)
		sTFields = sTFields & ", EstHours"
		sTVals = sTVals & ", " & vTemp
	Else
		sTFields = sTFields & ", EstHours"
		sTVals = sTVals & ", 0"
	End If
	
	'EstCost
	If (Request.Form("WTICost") <> "") Then
		sTFields = sTFields & ", EstCost"
		sTVals = sTVals & ", " & Request.Form("WTICost")
	Else
		sTFields = sTFields & ", EstCost"
		sTVals = sTVals & ", 0"
	End If
				
					
				
					
	'---------------------------------------------------------------------------------
	'Table - WFlowTasks
	'WATID (Auto Number)
	'WATCreated
	'WATCreatedBy
	'---------------------------------------------------------------------------------
	
	sWFields = "WATCreated, WATCreatedBy"
	sWVals = "#" & Date() & "#, " & curEID
	'WTID
	If (Request.Form("TID") <> "") Then
		sWFields = sWFields & ", WTID"
		sWVals = sWVals & ", " & Request.Form("TID")
	End If
	'WTIID
	If (Request.Form("WTIID") <> "") Then
		sWFields = sWFields & ", WTIID"
		sWVals = sWVals & ", " & Request.Form("WTIID")
	End If
	'WFRefType
	If ((Request.Form("RT") <> "") And (Request.Form("RT") <> "SELECT")) Then
		sWFields = sWFields & ", WFRefType"
		sWVals = sWVals & ", '" & Request.Form("RT") & "'"
	End If
	'WFRefID
	If (Request.Form("RID") <> "") Then
		sWFields = sWFields & ", WFRefID"
		sWVals = sWVals & ", '" & Request.Form("RID") & "'"
	End If
	'WATType
	If ((Request.Form("WTIType") <> "") And (Request.Form("WTIType") <> "SELECT")) Then
		sWFields = sWFields & ", WATType"
		sWVals = sWVals & ", '" & Request.Form("WTIType") & "'"
	End If
	'WATNext
	If (Request.Form("WTINext") <> "") Then
		sWFields = sWFields & ", WATNext"
		sWVals = sWVals & ", '" & Request.Form("WTINext") & "'"
	End If
	'WATNextStatus
	If ((Request.Form("WTINextStatus") <> "") And (Request.Form("WTINextStatus") <> "SELECT")) Then
		sWFields = sWFields & ", WATNextStatus"
		sWVals = sWVals & ", '" & Request.Form("WTINextStatus") & "'"
	End If
	'WATBack
	If (Request.Form("WTIBack") <> "") Then
		sWFields = sWFields & ", WATBack"
		sWVals = sWVals & ", '" & Request.Form("WTIBack") & "'"
	End If
	'WATBackStatus
	If ((Request.Form("WTIBackStatus") <> "") And (Request.Form("WTIBackStatus") <> "SELECT")) Then
		sWFields = sWFields & ", WATBackStatus"
		sWVals = sWVals & ", '" & Request.Form("WTIBackStatus") & "'"
	End If
	'WAAByType
	If ((Request.Form("WTIAByType") <> "") And (Request.Form("WTIAByType") <> "SELECT")) Then
		sWFields = sWFields & ", WAAByType"
		sWVals = sWVals & ", '" & Request.Form("WTIAByType") & "'"
	End If
	'WAAssnBy
	If ((Request.Form("WTIAssnBy") <> "") And (Request.Form("WTIAssnBy") <> "SELECT")) Then
		sWFields = sWFields & ", WAAssnBy"
		sWVals = sWVals & ", " & Request.Form("WTIAssnBy")
	End If
	'WAAToType
	If ((Request.Form("WTIAToType") <> "") And (Request.Form("WTIAToType") <> "SELECT")) Then
		sWFields = sWFields & ", WAAToType"
		sWVals = sWVals & ", '" & Request.Form("WTIAToType") & "'"
	End If
	'WAAssnTo
	If ((Request.Form("WTIAssnTo") <> "") And (Request.Form("WTIAssnTo") <> "SELECT")) Then
		sWFields = sWFields & ", WAAssnTo"
		sWVals = sWVals & ", " & Request.Form("WTIAssnTo")
	End If
	'WATCtrlRef
	If ((Request.Form("WTICtrlRef") <> "") And (Request.Form("WTICtrlRef") <> "SELECT")) Then
		sWFields = sWFields & ", WATCtrlRef"
		sWVals = sWVals & ", '" & Request.Form("WTICtrlRef") & "'"
	End If
	'WATParams
	If (Request.Form("WTIParams") <> "") Then
		sWFields = sWFields & ", WATParams"
		sWVals = sWVals & ", '" & Request.Form("WTIParams") & "'"
	End If
	
					
	'---------------------------------------------------------------------------------
	'---------------------------------------------------------------------------------	
	' Loop on both Task and WF Task
	'---------------------------------------------------------------------------------
	'---------------------------------------------------------------------------------
	
	vTemp = SetActive(Request.Form("RT"), Request.Form("RID"))	
	If ((Request.Form("WTIAToType") <> "EMP") And (Request.Form("WTIAToType") <> "SELECT")) Then
	
		sTemp = GetDataValue("SELECT COUNT(WFMID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WTIAssnTo") & ")", Nothing)
		
		If (CInt(sTemp) > 1) Then
			
			'Retrieve Assignee list			
			Set oRS = GetADORecordset("SELECT WFMID, WFMEmpID FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WTIAssnTo") & ")", Nothing)
			
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
				nS = 1
				Do
					sTF = ""
					sTV = ""
					sWF = ""
					sWV = ""
					
					'---------------------------------------------------------------------------------
					'Add final fields and run save for each
					'Table - Tasks
					'---------------------------------------------------------------------------------
					
					'TaskStatus
					If (vTemp = "T") Then
						sTF = sTF & ", TaskStatus"
						sTV = sTV & ", 'OPEN'"
					Else
						sTF = sTF & ", TaskStatus"
						sTV = sTV & ", 'HOLD'"
					End If
					
					'TaskID
					If (nS = 1) Then
						nID = GetDataValue("SELECT (MAX(TaskID) + 1) AS RetVal FROM Tasks", Nothing)
						If (nID = "" ) Then nID = 1
					Else
						nID = nID + 1
					End If
					sTF = sTF & ", TaskID"
					sTV = sTV & ", " & nID
					sWF = sWF & ", TaskID"
					sWV = sWV & ", " & nID
					
					'AssignBy
					If ((Request.Form("WTIAssnBy") <> "") And (Request.Form("WTIAssnBy") <> "SELECT")) Then
						If (Request.Form("WTIAByType") = "EMP") Then
							sTF = sTF & ", AssignBy"
							sTV = sTV & ", " & Request.Form("WTIAssnBy")
						Else
							sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WTIAssnBy") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
							If (sTemp <> "") Then
								sTF = sTF & ", AssignBy"
								sTV = sTV & ", " & sTemp
							Else
								sTF = sTF & ", AssignBy"
								sTV = sTV & ", " & Request.Form("WTIAssnBy")
							End If
						End If
					End If
					
					'AssignTo
					If Not IsNull(oRS("WFMEmpID")) Then
						sTF = sTF & ", AssignTo"
						sTV = sTV & ", " & oRS("WFMEmpID")
						'AssignWkgrp
						sTemp = GetDataValue("SELECT MAX(ContribPct), WorkgroupID AS RetVal FROM AssigneeWkgrp WHERE (ResourceID = " & oRS("WFMEmpID") & ") GROUP BY WorkgroupID", Nothing)
						If (sTemp <> "") Then
							sTF = sTF & ", AssignWkgrp"
							sTV = sTV & ", '" & sTemp & "'"
						End If
					Else
						sTF = sTF & ", AssignTo"
						sTV = sTV & ", " & Request.Form("WTIAssnTo")
					End If
					
					'---------------------------------------------------------------------------------
					'Table - WFlowTasks
					'---------------------------------------------------------------------------------
					
					'WFActive
					sWF = sWF & ", WFActive"
					sWV = sWV & ", -1"
					'WATActive
					If (vTemp = "T") Then
						sWF = sWF & ", WATActive"
						sWV = sWV & ", -1"
					Else
						sWF = sWF & ", WATActive"
						sWV = sWV & ", 0"
					End If
					
					'WATStatus
					sWF = sWF & ", WATStatus"
					sWV = sWV & ", 'ACTIVE'"
					'WATStep
					If (Request.Form("WTIStep") <> "") Then
						sWF = sWF & ", WATStep"
						sWV = sWV & ", '" & Request.Form("WTIStep") & "." & nS & "'"
					End If
					
					'AssnTo
					If Not IsNull(oRS("WFMEmpID")) Then
						sWF = sWF & ", AssnTo"
						sWV = sWV & ", " & oRS("WFMEmpID")
					Else
						If Not IsNull(oRS("WFMID")) Then
							sWF = sWF & ", AssnTo"
							sWV = sWV & ", " & oRS("WFMID")
						Else
							sWF = sWF & ", AssnTo"
							sWV = sWV & ", " & Request.Form("WTIAssnTo")
						End If
					End If
					
					
					sTCMD = "INSERT INTO Tasks (" & sTFields & sTF & ") VALUES (" & sTVals & sTV & ")"
					Response.Write "<p><strong>INSERT (Tasks):</strong> " & sTCMD & "<p>"
					RunSQLCmd sTCMD, Nothing
					
					
					sWCMD = "INSERT INTO WFlowTasks (" & sWFields & sWF & ") VALUES (" & sWVals &sWV & ")"
					Response.Write "<p><strong>INSERT (WFlowTasks):</strong> " & sWCMD & "<p>"
					RunSQLCmd sWCMD, Nothing
					
					
					nS = nS + 1
					oRS.MoveNext
				Loop Until oRS.EOF
				oRS.Close
				
			End If ' ---- oRS.BOF = True AND oRS.EOF = True
			
		Else ' ----- CInt(sTemp) <= 1
		
			'---------------------------------------------------------------------------------
			'Add final fields and run save
			'Table - Tasks
			'---------------------------------------------------------------------------------	
			'TaskStatus
			If (vTemp = "T") Then
				sTFields = sTFields & ", TaskStatus"
				sTVals = sTVals & ", 'OPEN'"
			Else
				sTFields = sTFields & ", TaskStatus"
				sTVals = sTVals & ", 'HOLD'"
			End If
			'TaskID
			nID = GetDataValue("SELECT (MAX(TaskID) + 1) AS RetVal FROM Tasks", Nothing)
			If (nID = "" ) Then nID = 1
			sTFields = sTFields & ", TaskID"
			sTVals = sTVals & ", " & nID
			sWFields = sWFields & ", TaskID"
			sWVals = sWVals & ", " & nID	
					
			'AssignBy
			If ((Request.Form("WTIAssnBy") <> "") And (Request.Form("WTIAssnBy") <> "SELECT")) Then
				If (Request.Form("WTIAByType") = "EMP") Then
					sTFields = sTFields & ", AssignBy"
					sTVals = sTVals & ", " & Request.Form("WTIAssnBy")
				Else
					sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WTIAssnBy") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
					If (sTemp <> "") Then
						sTFields = sTFields & ", AssignBy"
						sTVals = sTVals & ", " & sTemp
					Else
						sTFields = sTFields & ", AssignBy"
						sTVals = sTVals & ", " & Request.Form("WTIAssnBy")
					End If
				End If
			End If
			
			'AssignTo
			If ((Request.Form("WTIAssnTo") <> "") And (Request.Form("WTIAssnTo") <> "SELECT")) Then
				sTFields = sTFields & ", AssignTo"
				sTVals = sTVals & ", " & Request.Form("WTIAssnTo")
				
				'AssignWkgrp
				sTemp = GetDataValue("SELECT MAX(ContribPct), WorkgroupID AS RetVal FROM AssigneeWkgrp WHERE (ResourceID = " & Request.Form("WTIAssnTo") & ") GROUP BY WorkgroupID", Nothing)
				If (sTemp <> "") Then
					sTFields = sTFields & ", AssignWkgrp"
					sTVals = sTVals & ", '" & sTemp & "'"
				End If
				
			End If
			
			'---------------------------------------------------------------------------------
			'Table - WFlowTasks
			'---------------------------------------------------------------------------------
			'WFActive
			sWFields = sWFields & ", WFActive"
			sWVals = sWVals & ", -1"
			'WATActive
			If (vTemp = "T") Then
				sWFields = sWFields & ", WATActive"
				sWVals = sWVals & ", -1"
			Else
				sWFields = sWFields & ", WATActive"
				sWVals = sWVals & ", 0"
			End If
			'WATStatus
			sWFields = sWFields & ", WATStatus"
			sWVals = sWVals & ", 'ACTIVE'"
			'WATStep
			If (Request.Form("WTIStep") <> "") Then
				sWFields = sWFields & ", WATStep"
				sWVals = sWVals & ", '" & Request.Form("WTIStep") & "'"
			End If
			'AssnTo
			If ((Request.Form("WTIAssnTo") <> "") And (Request.Form("WTIAssnTo") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WTIAssnTo") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
				If (sTemp <> "") Then
					sWFields = sWFields & ", AssnTo"
					sWVals = sWVals & ", " & sTemp
				Else
					sWFields = sWFields & ", AssnTo"
					sWVals = sWVals & ", " & Request.Form("WTIAssnTo")
				End If
			End If
			
			sTCMD = "INSERT INTO Tasks (" & sTFields & ") VALUES (" & sTVals & ")"
			Response.Write "<p><strong>INSERT (Tasks):</strong> " & sTCMD & "<p>"
			RunSQLCmd sTCMD, Nothing
			sWCMD = "INSERT INTO WFlowTasks (" & sWFields & ") VALUES (" & sWVals & ")"
			Response.Write "<p><strong>INSERT (WFlowTasks):</strong> " & sWCMD & "<p>"
			RunSQLCmd sWCMD, Nothing
		End If
		Set oRS = Nothing
		
	Else ' ---((Request.Form("WTIAToType") <> "EMP") And (Request.Form("WTIAToType") <> "SELECT"))
	
		'---------------------------------------------------------------------------------
		'Add final fields and run save
		'Table - Tasks
		'---------------------------------------------------------------------------------
		'TaskStatus
		If (vTemp = "T") Then
			sTFields = sTFields & ", TaskStatus"
			sTVals = sTVals & ", 'OPEN'"
		Else
			sTFields = sTFields & ", TaskStatus"
			sTVals = sTVals & ", 'HOLD'"
		End If
		
		'TaskID
		nID = GetDataValue("SELECT (MAX(TaskID) + 1) AS RetVal FROM Tasks", Nothing)
		If (nID = "" ) Then nID = 1
		sTFields = sTFields & ", TaskID"
		sTVals = sTVals & ", " & nID
		sWFields = sWFields & ", TaskID"
		sWVals = sWVals & ", " & nID
		
		'AssignBy
		If ((Request.Form("WTIAssnBy") <> "") And (Request.Form("WTIAssnBy") <> "SELECT")) Then
			
			If (Request.Form("WTIAByType") = "EMP") Then
				sTFields = sTFields & ", AssignBy"
				sTVals = sTVals & ", " & Request.Form("WTIAssnBy")
			Else
				
				sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WTIAssnBy") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
				If (sTemp <> "") Then
					sTFields = sTFields & ", AssignBy"
					sTVals = sTVals & ", " & sTemp
				Else
					sTFields = sTFields & ", AssignBy"
					sTVals = sTVals & ", " & Request.Form("WTIAssnBy")
				End If
				
			End If
		End If
		
		
		'AssignTo
		If ((Request.Form("WTIAssnTo") <> "") And (Request.Form("WTIAssnTo") <> "SELECT")) Then
			
			sTFields = sTFields & ", AssignTo"
			sTVals = sTVals & "," & Request.Form("WTIAssnTo")
			
			'AssignWkgrp
			sTemp = GetDataValue("SELECT MAX(ContribPct), WorkgroupID AS RetVal FROM AssigneeWkgrp WHERE (ResourceID = " & Request.Form("WTIAssnTo") & ") GROUP BY WorkgroupID", Nothing)
			If (sTemp <> "") Then
				sTFields = sTFields & ", AssignWkgrp"
				sTVals = sTVals & ", '" & sTemp & "'"
			End If
			
		End If
		
		'---------------------------------------------------------------------------------
		'Table - WFlowTasks
		'---------------------------------------------------------------------------------
		'WFActive
		sWFields = sWFields & ", WFActive"
		sWVals = sWVals & ", -1"
		'WATActive
		If (vTemp = "T") Then
			sWFields = sWFields & ", WATActive"
			sWVals = sWVals & ", -1"
		Else
			sWFields = sWFields & ", WATActive"
			sWVals = sWVals & ", 0"
		End If
		'WATStatus
		sWFields = sWFields & ", WATStatus"
		sWVals = sWVals & ", 'ACTIVE'"
		'WATStep
		If (Request.Form("WTIStep") <> "") Then
			sWFields = sWFields & ", WATStep"
			sWVals = sWVals & ", '" & Request.Form("WTIStep") & "'"
		End If
		'AssnTo
		If ((Request.Form("WTIAssnTo") <> "" And (Request.Form("WTIAssnTo") <> "SELECT"))) Then
			sWFields = sWFields & ", AssnTo"
			sWVals = sWVals & ", " & Request.Form("WTIAssnTo")
		End If
		
		sTCMD = "INSERT INTO Tasks (" & sTFields & ") VALUES (" & sTVals & ")"
		Response.Write "<p><strong>INSERT (Tasks):</strong> " & sTCMD & "<p>"
		RunSQLCmd sTCMD, Nothing
		
		sWCMD = "INSERT INTO WFlowTasks (" & sWFields & ") VALUES (" & sWVals & ")"
		Response.Write "<p><strong>INSERT (WFlowTasks):</strong> " & sWCMD & "<p>"
		RunSQLCmd sWCMD, Nothing
	End If
	
	
	
End Sub







Sub ModWFTask(nID)
	Dim sTFields, sTVals
	Dim sWFields, sWVals
	Dim sTCMD, sWCMD
	Dim sTemp
	
	'TaskID
	sTVals = "TaskID = " & Request.Form("TaskID")
	'TaskStatus
	If ((Request.Form("TaskStatus") <> "") And (Request.Form("TaskStatus") <> "SELECT")) Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "TaskStatus = '" & Request.Form("TaskStatus") & "'"
	End If
	'TaskPriority
	If ((Request.Form("TaskPriority") <> "") And (Request.Form("TaskPriority") <> "SELECT")) Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "TaskPriority = '" & Request.Form("TaskPriority") & "'"
	End If
	'ProjNum
	If ((Request.Form("ProjNum") <> "") And (Request.Form("ProjNum") <> "SELECT")) Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "ProjNum = '" & Request.Form("ProjNum") & "'"
	End If
	'TaskDesc
	If (Request.Form("TaskDesc") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "TaskDesc = '" & Request.Form("TaskDesc") & "'"
	End If
	'TaskDetail
	If (Request.Form("TaskDetail") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "TaskDetail = '" & Request.Form("TaskDetail") & "'"
	End If
	'ChargeAcct
	If (Request.Form("ChargeAcct") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "ChargeAcct = '" & Request.Form("ChargeAcct") & "'"
	End If
	'StdTaskID
	'PcntComplete
	If (Request.Form("PcntComplete") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "PcntComplete = " & Request.Form("PcntComplete")
	End If
	'PlannedStart
	If (Request.Form("PlannedStart") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "PlannedStart = #" & Request.Form("PlannedStart") & "#"
	End If
	'PlannedFinish
	If (Request.Form("PlannedFinish") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "PlannedFinish = #" & Request.Form("PlannedFinish") & "#"
	End If
	'EstHours
	If (Request.Form("EstHours") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "EstHours = " & Request.Form("EstHours")
	End If
	'EstCost
	If (Request.Form("EstCost") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "EstCost = " & Request.Form("EstCost")
	End If
	'OverrunEstFinish
	If (Request.Form("OverrunEstFinish") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "OverrunEstFinish = #" & Request.Form("OverrunEstFinish") & "#"
	End If
	'OverrunHrs
	If (Request.Form("OverrunHrs") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "OverrunHrs = " & Request.Form("OverrunHrs")
	End If
	'OvrCost
	If (Request.Form("OvrCost") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "OvrCost = " & Request.Form("OvrCost")
	End If
	'ActualStart
	If (Request.Form("ActualStart") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "ActualStart = #" & Request.Form("ActualStart") & "#"
	End If
	'ActualFinish
	If (Request.Form("ActualFinish") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "ActualFinish = #" & Request.Form("ActualFinish") & "#"
	End If
	'ActualHours
	If (Request.Form("ActualHours") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "ActualHours = " & Request.Form("ActualHours")
	End If
	'ActualCost
	If (Request.Form("ActualCost") <> "") Then
		sTFields = IIf(sTFields <> "", sTFields & ", ", "") & "ActualCost = " & Request.Form("ActualCost")
	End If
	
	'WATID
	sWVals = "WATID = " & nID
	'WATNext
	If (Request.Form("WATNext") <> "") Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATNext = '" & Request.Form("WATNext") & "'"
	End If
	'WATNextStatus
	If ((Request.Form("WATNextStatus") <> "") And (Request.Form("WATNextStatus") <> "SELECT")) Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATNextStatus = '" & Request.Form("WATNextStatus") & "'"
	End If
	'WATBack
	If (Request.Form("WATBack") <> "") Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATBack = '" & Request.Form("WATBack") & "'"
	End If
	'WATBackStatus
	If ((Request.Form("WATBackStatus") <> "") And (Request.Form("WATBackStatus") <> "SELECT")) Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATBackStatus = '" & Request.Form("WATBackStatus") & "'"
	End If
	'WAAByType
	'WAAssnBy
	If ((Request.Form("WAAssnBy") <> "") And (Request.Form("WAAssnBy") <> "SELECT")) Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WAAssnBy = " & Request.Form("WAAssnBy")
	End If
	'WAAToType
	'WAAssnTo
	'AssnTo - (WFAssnTo)
	If ((Request.Form("WFAssnTo") <> "") And (Request.Form("WFAssnTo") <> "SELECT")) Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "AssnTo = " & Request.Form("WFAssnTo")
	End If
	'WATCtrlRef
	If ((Request.Form("WATCtrlRef") <> "") And (Request.Form("WATCtrlRef") <> "SELECT")) Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATCtrlRef = '" & Request.Form("WATCtrlRef") & "'"
		'WATRefID
		If (Request.Form("WATRefID") <> "") Then
			sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATRefID = '" & Request.Form("WATRefID") & "'"
		End If
		'WATParams
		sTemp = IIf(Request.Form("P1") = "Y", "1", "0") & IIf(Request.Form("P2") = "Y", "1", "0")
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATParams = '" & sTemp & "'"
	End If
	'WATAdjPStart
	If (Request.Form("WATAdjPStart") <> "") Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATAdjPStart = #" & Request.Form("WATAdjPStart") & "#"
	End If
	'WATAdjPFinish
	If (Request.Form("WATAdjPFinish") <> "") Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATAdjPFinish = #" & Request.Form("WATAdjPFinish") & "#"
	End If
	'WATAdjOFinish
	If (Request.Form("WATAdjOFinish") <> "") Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATAdjOFinish = #" & Request.Form("WATAdjOFinish") & "#"
	End If
	'WATAdjAStart
	If (Request.Form("WATAdjAStart") <> "") Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATAdjAStart = #" & Request.Form("WATAdjAStart") & "#"
	End If
	'WATAdjAFinish
	If (Request.Form("WATAdjAFinish") <> "") Then
		sWFields = IIf(sWFields <> "", sWFields & ", ", "") & "WATAdjAFinish = #" & Request.Form("WATAdjAFinish") & "#"
	End If
	
	sTCMD = "UPDATE Tasks SET " & sTFields & " WHERE (" & sTVals & ")"
	RunSQLCmd sTCMD, Nothing
	sWCMD = "UPDATE WFlowTasks SET " & sWFields & " WHERE (" & sWVals & ")"
	RunSQLCmd sWCMD, Nothing
End Sub

Sub SaveWFTask()


	Dim sTFields, sTVals
	Dim sWFields, sWVals
	Dim sTF, sTV
	Dim sWF, sWV
	Dim sTCMD, sWCMD
	Dim oRS
	Dim nID
	Dim nS
	Dim vTemp
	Dim sTemp
	
	'Table - Tasks
	'TaskCostType		W - Workflow
	'PcntComplete		0
	'SchedVisible		0
	'AutoGenerate		0
	'DateAssigned
	
	sTFields = "TaskCostType, PcntComplete, SchedVisible, AutoGenerate, DateAssigned"
	sTVals = "'W', 0, 0, 0, #" & Date() & "#"
	'ChargeAcct
	If (Request.Form("ChargeAcct") <> "") Then
		sTFields = sTFields & ", ChargeAcct"
		sTVals = sTVals & ", '" & Request.Form("ChargeAcct") & "'"
	End If
	'TaskPriority
	If ((Request.Form("TaskPriority") <> "") And (Request.Form("TaskPriority") <> "SELECT")) Then
		sTFields = sTFields & ", TaskPriority"
		sTVals = sTVals & ", '" & Request.Form("TaskPriority") & "'"
	Else
		sTFields = sTFields & ", TaskPriority"
		sTVals = sTVals & ", 'OPEN'"
	End If
	'ProjNum
	If ((Request.Form("ProjNum") <> "") And (Request.Form("ProjNum") <> "SELECT")) Then
		sTFields = sTFields & ", ProjNum"
		sTVals = sTVals & ", '" & Request.Form("ProjNum") & "'"
	End If
	'RefType
	If ((Request.Form("RT") <> "") And (Request.Form("RT") <> "SELECT")) Then
		sTFields = sTFields & ", RefType"
		sTVals = sTVals & ", '" & Request.Form("RT") & "'"
	End If
	'RefNum
	If (Request.Form("RID") <> "") Then
		sTFields = sTFields & ", RefNum"
		sTVals = sTVals & ", '" & Request.Form("RID") & "'"
	End If
	'StdTaskID
	If ((Request.Form("StdTaskID") <> "") And (Request.Form("StdTaskID") <> "SELECT")) Then
		sTFields = sTFields & ", StdTaskID"
		sTVals = sTVals & ", '" & Request.Form("StdTaskID") & "'"
	End If
	'TaskDesc
	If (Request.Form("TaskDesc") <> "") Then
		sTFields = sTFields & ", TaskDesc"
		sTVals = sTVals & ", '" & Request.Form("TaskDesc") & "'"
	End If
	'TaskDetail
	If (Request.Form("TaskDetail") <> "") Then
		sTFields = sTFields & ", TaskDetail"
		sTVals = sTVals & ", '" & Request.Form("TaskDetail") & "'"
	End If
	'PlannedStart
	If (Request.Form("PlannedStart") <> "") Then
		sTFields = sTFields & ", PlannedStart"
		sTVals = sTVals & ", #" & Request.Form("PlannedStart") & "#"
	End If
	'PlannedFinish
	If (Request.Form("PlannedFinish") <> "") Then
		sTFields = sTFields & ", PlannedFinish"
		sTVals = sTVals & ", #" & Request.Form("PlannedFinish") & "#"
	End If
	'EstDur
	If ((Request.Form("PlannedStart") <> "") And (Request.Form("PlannedFinish") <> "")) Then
		vTemp = GetDataValue("SELECT SUM(WorkDay) AS RetVal FROM QCalendar WHERE ((CalDay >= #" & Request.Form("PlannedStart") & "#) AND (CalDay <= #" & Request.Form("PlannedFinish") & "#))", Nothing)
		sTFields = sTFields & ", EstDur"
		sTVals = sTVals & ", " & vTemp
	Else
		sTFields = sTFields & ", EstDur"
		sTVals = sTVals & ", 1"
	End If
	'EstHours
	If (Request.Form("EstHours") <> "") Then
		sTFields = sTFields & ", EstHours"
		sTVals = sTVals & ", " & Request.Form("EstHours")
	Else
		sTFields = sTFields & ", EstHours"
		sTVals = sTVals & ", 0"
	End If
	'EstCost
	If (Request.Form("EstCost") <> "") Then
		sTFields = sTFields & ", EstCost"
		sTVals = sTVals & ", " & Request.Form("EstCost")
	Else
		sTFields = sTFields & ", EstCost"
		sTVals = sTVals & ", 0"
	End If
	
	'Table - WFlowTasks
	'WATID (Auto Number)
	'WATCreated
	'WATCreatedBy
	
	sWFields = "WATCreated, WATCreatedBy"
	sWVals = "#" & Date() & "#, " & curEID
	'WTID
	'If ((Request.Form("RT") <> "") And (Request.Form("RID") <> "")) Then
	'	sTemp = GetDataValue("SELECT WTID AS RetVal FROM WFlowTasks WHERE ((WFRefType = '" & Request.Form("RT") & "') AND (WFRefID = '" & Request.Form("RID") & "')) AND (WFActive <> 0)", Nothing)
		If (Request.Form("TID") <> "") Then
		'If (sTemp <> "") Then
			sWFields = sWFields & ", WTID"
			sWVals = sWVals & ", " & Request.Form("TID")
			'sWVals = sWVals & ", " & sTemp
		End If
	'End If
	'WTIID
	If (Request.Form("WTIID") <> "") Then
		sWFields = sWFields & ", WTIID"
		sWVals = sWVals & ", " & Request.Form("WTIID")
	End If
	'WFRefType
	If ((Request.Form("RT") <> "") And (Request.Form("RT") <> "SELECT")) Then
		sWFields = sWFields & ", WFRefType"
		sWVals = sWVals & ", '" & Request.Form("RT") & "'"
	End If
	'WFRefID
	If (Request.Form("RID") <> "") Then
		sWFields = sWFields & ", WFRefID"
		sWVals = sWVals & ", '" & Request.Form("RID") & "'"
	End If
	'WATType
	If ((Request.Form("WATType") <> "") And (Request.Form("WATType") <> "SELECT")) Then
		sWFields = sWFields & ", WATType"
		sWVals = sWVals & ", '" & Request.Form("WATType") & "'"
	End If
	'WATNext
	If (Request.Form("WATNext") <> "") Then
		sWFields = sWFields & ", WATNext"
		sWVals = sWVals & ", '" & Request.Form("WATNext") & "'"
	End If
	'WATNextStatus
	If ((Request.Form("WATNextStatus") <> "") And (Request.Form("WATNextStatus") <> "SELECT")) Then
		sWFields = sWFields & ", WATNextStatus"
		sWVals = sWVals & ", '" & Request.Form("WATNextStatus") & "'"
	End If
	'WATBack
	If (Request.Form("WATBack") <> "") Then
		sWFields = sWFields & ", WATBack"
		sWVals = sWVals & ", '" & Request.Form("WATBack") & "'"
	End If
	'WATBackStatus
	If ((Request.Form("WATBackStatus") <> "") And (Request.Form("WATBackStatus") <> "SELECT")) Then
		sWFields = sWFields & ", WATBackStatus"
		sWVals = sWVals & ", '" & Request.Form("WATBackStatus") & "'"
	End If
	'WAAByType
	If ((Request.Form("WAAByType") <> "") And (Request.Form("WAAByType") <> "SELECT")) Then
		sWFields = sWFields & ", WAAByType"
		sWVals = sWVals & ", '" & Request.Form("WAAByType") & "'"
	End If
	'WAAssnBy
	If ((Request.Form("WAAssnBy") <> "") And (Request.Form("WAAssnBy") <> "SELECT")) Then
		sWFields = sWFields & ", WAAssnBy"
		sWVals = sWVals & ", " & Request.Form("WAAssnBy")
	End If
	'WAAToType
	If ((Request.Form("WAAToType") <> "") And (Request.Form("WAAToType") <> "SELECT")) Then
		sWFields = sWFields & ", WAAToType"
		sWVals = sWVals & ", '" & Request.Form("WAAToType") & "'"
	End If
	'WAAssnTo
	If ((Request.Form("WAAssnTo") <> "") And (Request.Form("WAAssnTo") <> "SELECT")) Then
		sWFields = sWFields & ", WAAssnTo"
		sWVals = sWVals & ", " & Request.Form("WAAssnTo")
	End If
	'WATCtrlRef
	If ((Request.Form("WATCtrlRef") <> "") And (Request.Form("WATCtrlRef") <> "SELECT")) Then
		sWFields = sWFields & ", WATCtrlRef"
		sWVals = sWVals & ", '" & Request.Form("WATCtrlRef") & "'"
		'WATRefID
		If (Request.Form("WATRefID") <> "") Then
			sWFields = sWFields & ", WATRefID"
			sWVals = sWVals & ", '" & Request.Form("WATRefID") & "'"
		End If
		'WATParams
		sTemp = IIf(Request.Form("P1") = "Y", "1", "0") & IIf(Request.Form("P2") = "Y", "1", "0")
		sWFields = sWFields & ", WATParams"
		sWVals = sWVals & ", '" & sTemp & "'"
	End If
	
	vTemp = SetActive(Request.Form("RT"), Request.Form("RID"))
	If (Request.Form("WATStep") <> "") Then
		sTemp = "SELECT COUNT(WATID) AS RetVal FROM ViewWFTasks WHERE (((RefType = '" & Request.Form("RT") & "') AND "
		sTemp = sTemp & "(RefNum = '" & Request.Form("RID") & "')) AND (WFActive <> 0)) AND (TStep = " & Request.Form("WATStep") & ")"
		nS = GetDataValue(sTemp, Nothing)
		
		
		If (nS <> "") Then
			If (CInt(nS) = 1) Then
				sTemp = "UPDATE WFlowTasks SET WATStep = " & Request.Form("WATStep") & "." & nS & " WHERE (((WFRefType = '" & Request.Form("RT") & "') AND "
				sTemp = sTemp & "(WFRefID = '" & Request.Form("RID") & "')) AND (WFActive <> 0)) AND (WATStep = " & Request.Form("WATStep") & ")"
				RunSQLCmd sTemp, Nothing
			End If
			nS = CInt(nS) + 1
		Else
			nS = 1
		End If
	End If
	
	
	nID = GetDataValue("SELECT (MAX(TaskID) + 1) AS RetVal FROM Tasks", Nothing)
	If (nID = "" ) Then nID = 1
	
	If ((Request.Form("AssnTo") <> "") And (Request.Form("AssnTo") <> "SELECT")) Then
		'Add final fields and run save
		'Table - Tasks
		'TaskStatus
		If (vTemp = "T") Then
			sTFields = sTFields & ", TaskStatus"
			sTVals = sTVals & ", 'OPEN'"
		Else
			sTFields = sTFields & ", TaskStatus"
			sTVals = sTVals & ", 'HOLD'"
		End If
		'TaskID
		sTFields = sTFields & ", TaskID"
		sTVals = sTVals & ", " & nID
		sWFields = sWFields & ", TaskID"
		sWVals = sWVals & ", " & nID
		'AssignBy
		If ((Request.Form("WAAssnBy") <> "") And (Request.Form("WAAssnBy") <> "SELECT")) Then
			If (Request.Form("WAAByType") = "EMP") Then
				sTFields = sTFields & ", AssignBy"
				sTVals = sTVals & ", " & Request.Form("WAAssnBy")
			Else
				sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WAAssnBy") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
				If (sTemp <> "") Then
					sTFields = sTFields & ", AssignBy"
					sTVals = sTVals & ", " & sTemp
				Else
					sTFields = sTFields & ", AssignBy"
					sTVals = sTVals & ", " & Request.Form("WAAssnBy")
				End If
			End If
		End If
		'AssignTo
		sTFields = sTFields & ", AssignTo"
		sTVals = sTVals & "," & Request.Form("AssnTo")
		'AssignWkgrp
		sTemp = GetDataValue("SELECT MAX(ContribPct), WorkgroupID AS RetVal FROM AssigneeWkgrp WHERE (ResourceID = " & Request.Form("AssnTo") & ") GROUP BY WorkgroupID", Nothing)
		If (sTemp <> "") Then
			sTFields = sTFields & ", AssignWkgrp"
			sTVals = sTVals & ", '" & sTemp & "'"
		End If
		
		'Table - WFlowTasks
		'WFActive
		sWFields = sWFields & ", WFActive"
		sWVals = sWVals & ", -1"
		'WATActive
		If (vTemp = "T") Then
			sWFields = sWFields & ", WATActive"
			sWVals = sWVals & ", -1"
		Else
			sWFields = sWFields & ", WATActive"
			sWVals = sWVals & ", 0"
		End If
		'WATStatus
		sWFields = sWFields & ", WATStatus"
		sWVals = sWVals & ", 'ACTIVE'"
		'WATStep
		If (Request.Form("WATStep") <> "") Then
			sWFields = sWFields & ", WATStep"
			sWVals = sWVals & ", '" & Request.Form("WATStep") & IIf(nS > 1, "." & nS, "") & "'"
		End If
		'AssnTo
		sWFields = sWFields & ", AssnTo"
		sWVals = sWVals & ", " & Request.Form("AssnTo")
		
		sTCMD = "INSERT INTO Tasks (" & sTFields & ") VALUES (" & sTVals & ")"
		RunSQLCmd sTCMD, Nothing
		sWCMD = "INSERT INTO WFlowTasks (" & sWFields & ") VALUES (" & sWVals & ")"
		RunSQLCmd sWCMD, Nothing
	Else
		If ((Request.Form("WAAToType") <> "EMP") And (Request.Form("WAAToType") <> "SELECT")) Then
			sTemp = GetDataValue("SELECT COUNT(WFMID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WAAssnTo") & ")", Nothing)
			If (CInt(sTemp) > 1) Then
				'Retrieve Assignee list
				Set oRS = GetADORecordset("SELECT WFMID, WFMEmpID FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WAAssnTo") & ")", Nothing)
				If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
					oRS.MoveFirst
					Do
						sTF = ""
						sTV = ""
						sWF = ""
						sWV = ""
						'Add final fields and run save for each
						'Table - Tasks
						'TaskStatus
						If (vTemp = "T") Then
							sTF = sTF & ", TaskStatus"
							sTV = sTV & ", 'OPEN'"
						Else
							sTF = sTF & ", TaskStatus"
							sTV = sTV & ", 'HOLD'"
						End If
						'TaskID
						sTF = sTF & ", TaskID"
						sTV = sTV & ", " & nID
						sWF = sWF & ", TaskID"
						sWV = sWV & ", " & nID
						'AssignBy
						If ((Request.Form("WAAssnBy") <> "") And (Request.Form("WAAssnBy") <> "SELECT")) Then
							If (Request.Form("WAAByType") = "EMP") Then
								sTF = sTF & ", AssignBy"
								sTV = sTV & ", " & Request.Form("WAAssnBy")
							Else
								sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WAAssnBy") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
								If (sTemp <> "") Then
									sTF = sTF & ", AssignBy"
									sTV = sTV & ", " & sTemp
								Else
									sTF = sTF & ", AssignBy"
									sTV = sTV & ", " & Request.Form("WAAssnBy")
								End If
							End If
						End If
						'AssignTo
						If Not IsNull(oRS("WFMEmpID")) Then
							sTF = sTF & ", AssignTo"
							sTV = sTV & ", " & oRS("WFMEmpID")
							'AssignWkgrp
							sTemp = GetDataValue("SELECT MAX(ContribPct), WorkgroupID AS RetVal FROM AssigneeWkgrp WHERE (ResourceID = " & oRS("WFMEmpID") & ") GROUP BY WorkgroupID", Nothing)
							If (sTemp <> "") Then
								sTF = sTF & ", AssignWkgrp"
								sTV = sTV & ", '" & sTemp & "'"
							End If
						Else
							sTF = sTF & ", AssignTo"
							sTV = sTV & ", " & Request.Form("WAAssnTo")
						End If
						
						'Table - WFlowTasks
						'WFActive
						sWF = sWF & ", WFActive"
						sWV = sWV & ", -1"
						'WATActive
						If (vTemp = "T") Then
							sWF = sWF & ", WATActive"
							sWV = sWV & ", -1"
						Else
							sWF = sWF & ", WATActive"
							sWV = sWV & ", 0"
						End If
						'WATStatus
						sWF = sWF & ", WATStatus"
						sWV = sWV & ", 'ACTIVE'"
						'WATStep
						If (Request.Form("WATStep") <> "") Then
							sWF = sWF & ", WATStep"
							sWV = sWV & ", '" & Request.Form("WATStep") & "." & nS & "'"
						End If
						'AssnTo
						If Not IsNull(oRS("WFMEmpID")) Then
							sWF = sWF & ", AssnTo"
							sWV = sWV & ", " & oRS("WFMEmpID")
						Else
							If Not IsNull(oRS("WFMID")) Then
								sWF = sWF & ", AssnTo"
								sWV = sWV & ", " & oRS("WFMID")
							Else
								sWF = sWF & ", AssnTo"
								sWV = sWV & ", " & Request.Form("WAAssnTo")
							End If
						End If
						
						sTCMD = "INSERT INTO Tasks (" & sTFields & sTF & ") VALUES (" & sTVals & sTV & ")"
						'Response.Write "<p><strong>INSERT (Tasks):</strong> " & sTCMD & "<p>"
						RunSQLCmd sTCMD, Nothing
						sWCMD = "INSERT INTO WFlowTasks (" & sWFields & sWF & ") VALUES (" & sWVals &sWV & ")"
						'Response.Write "<p><strong>INSERT (WFlowTasks):</strong> " & sWCMD & "<p>"
						RunSQLCmd sWCMD, Nothing
						nS = nS + 1
						nID = nID + 1
						oRS.MoveNext
					Loop Until oRS.EOF
					oRS.Close
				End If
			Else
				'Add final fields and run save
				'Table - Tasks
				'TaskStatus
				If (vTemp = "T") Then
					sTFields = sTFields & ", TaskStatus"
					sTVals = sTVals & ", 'OPEN'"
				Else
					sTFields = sTFields & ", TaskStatus"
					sTVals = sTVals & ", 'HOLD'"
				End If
				'TaskID
				sTFields = sTFields & ", TaskID"
				sTVals = sTVals & ", " & nID
				sWFields = sWFields & ", TaskID"
				sWVals = sWVals & ", " & nID
				'AssignBy
				If ((Request.Form("WAAssnBy") <> "") And (Request.Form("WAAssnBy") <> "SELECT")) Then
					If (Request.Form("WAAByType") = "EMP") Then
						sTFields = sTFields & ", AssignBy"
						sTVals = sTVals & ", " & Request.Form("WAAssnBy")
					Else
						sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WAAssnBy") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
						If (sTemp <> "") Then
							sTFields = sTFields & ", AssignBy"
							sTVals = sTVals & ", " & sTemp
						Else
							sTFields = sTFields & ", AssignBy"
							sTVals = sTVals & ", " & Request.Form("WAAssnBy")
						End If
					End If
				End If
				'AssignTo
				If ((Request.Form("WAAssnTo") <> "") And (Request.Form("WAAssnTo") <> "SELECT")) Then
					sTFields = sTFields & ", AssignTo"
					sTVals = sTVals & ", " & Request.Form("WAAssnTo")
					'AssignWkgrp
					sTemp = GetDataValue("SELECT MAX(ContribPct), WorkgroupID AS RetVal FROM AssigneeWkgrp WHERE (ResourceID = " & Request.Form("WAAssnTo") & ") GROUP BY WorkgroupID", Nothing)
					If (sTemp <> "") Then
						sTFields = sTFields & ", AssignWkgrp"
						sTVals = sTVals & ", '" & sTemp & "'"
					End If
				End If
				
				'Table - WFlowTasks
				'WFActive
				sWFields = sWFields & ", WFActive"
				sWVals = sWVals & ", -1"
				'WATActive
				If (vTemp = "T") Then
					sWFields = sWFields & ", WATActive"
					sWVals = sWVals & ", -1"
				Else
					sWFields = sWFields & ", WATActive"
					sWVals = sWVals & ", 0"
				End If
				'WATStatus
				sWFields = sWFields & ", WATStatus"
				sWVals = sWVals & ", 'ACTIVE'"
				'WATStep
				If (Request.Form("WATStep") <> "") Then
					sWFields = sWFields & ", WATStep"
					sWVals = sWVals & ", '" & Request.Form("WATStep") & IIf(nS > 1, "." & nS, "") & "'"
				End If
				'AssnTo
				If ((Request.Form("WAAssnTo") <> "") And (Request.Form("WAAssnTo") <> "SELECT")) Then
					sTemp = GetDataValue("SELECT FIRST(WFMEmpID) AS RetVal FROM WFGroupMembs WHERE (WFGID = " & Request.Form("WAAssnTo") & ") AND (WFMEmpID IS NOT NULL)", Nothing)
					If (sTemp <> "") Then
						sWFields = sWFields & ", AssnTo"
						sWVals = sWVals & ", " & sTemp
					Else
						sWFields = sWFields & ", AssnTo"
						sWVals = sWVals & ", " & Request.Form("WAAssnTo")
					End If
				End If
				
				sTCMD = "INSERT INTO Tasks (" & sTFields & ") VALUES (" & sTVals & ")"
				RunSQLCmd sTCMD, Nothing
				sWCMD = "INSERT INTO WFlowTasks (" & sWFields & ") VALUES (" & sWVals & ")"
				RunSQLCmd sWCMD, Nothing
			End If
			Set oRS = Nothing
		End If
	End If
End Sub

%>

