<!-- #INCLUDE FILE="incl_wf_listinfo.asp" -->
<!-- #INCLUDE FILE="incl_wf_forms.asp" -->
<!-- #INCLUDE FILE="incl_wf_dataproc.asp" -->

<%
Function CheckStrData(sData, sPurpose)
	Dim sRData
	
	Select Case sPurpose
		Case "DISPLAY"
			sRData = Replace(sData, "^", "'", 1, -1, 1)
			sRData = Replace(sData, "~", Chr(34), 1, -1, 1)
		Case "TRANSFER"
			sRData = Replace(sData, "'", "^", 1, -1, 1)
			sRData = Replace(sData, Chr(34), "~", 1, -1, 1)
		Case "SAVE"
			sRData = Replace(sData, "'", "''", 1, -1, 1)
			sRData = Replace(sData, Chr(34), Chr(34) & Chr(34), 1, -1, 1)
	End Select
	
	CheckStrData = sRData
End Function

Function GetPFinish(sStart, nDur)
	Dim sRDate
	
	If (nDur > 1) Then
		
		sRDate = DateSerial(Year(CDate(sStart)), Month(CDate(sStart)), Day(CDate(sStart)) + nDur)
	Else
		sRDate = sStart
	End If
	
	GetPFinish = sRDate
End Function

Function TestGenMode(sRType, sRID)
	Dim sRMode
	Dim vTest
	Dim sCMD
	Dim sTemp
	
	sRMode = "N2"
	If (sRID <> "") Then
		Select Case sRType
			Case "CAR"
				sTemp = "Left(RefNum, " & Len(sRID) & ") = " & sRID
				sCMD = "SELECT COUNT(RefNum) AS RetVal FROM QActions WHERE (" & sTemp & ") AND (RefType = 'CAR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ'))"
			Case "CO"
				sTemp = "Left(CO, " & Len(sRID) & ") = " & sRID
				sCMD = "SELECT COUNT(CO) AS RetVal FROM Changes WHERE (" & sTemp & ") AND (RefType = 'CO') AND ((ChStatus = 'CREQ') OR (ChStatus = 'REQ'))"
			Case "DOC"
				sTemp = "Left(DocID, " & Len(sRID) & ") = '" & sRID & "'"
				sCMD = "SELECT COUNT(DocID) AS RetVal FROM Documents WHERE (" & sTemp & ") AND ((DocStatus = 'CREQ') OR (DocStatus = 'REQ'))"
			Case "MDISP"
				sTemp = "Left(OrderDateBatch, " & Len(sRID) & ") = '" & sRID & "'"
				sCMD = "SELECT COUNT(MatDispID) AS RetVal FROM MatDisp WHERE (" & sTemp & ") AND ((DispStatus <> 'COMPL') AND (DispStatus <> 'HOLD'))"
			Case "NCR"
				sTemp = "Left(RefNum, " & Len(sRID) & ") = " & sRID
				sCMD = "SELECT COUNT(RefNum) AS RetVal FROM QActions WHERE (" & sTemp & ") AND (RefType = 'NCR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ'))"
			Case "PROJ"
				sTemp = "Left(ProjNum, " & Len(sRID) & ") = '" & sRID & "'"
				sCMD = "SELECT COUNT(ProjNum) AS RetVal FROM ProjXRef WHERE (" & sTemp & ") AND ((ProjStatus = 'ACT') OR (ProjStatus = 'PLN'))"
			Case "TASK"
				sTemp = "Left(TaskID, " & Len(sRID) & ") = '" & sRID & "'"
				sCMD = "SELECT COUNT(TaskID) AS RetVal FROM Tasks WHERE (" & sTemp & ") AND (TaskStatus = 'OPEN')"
		End Select
		If (sCMD <> "") Then
			vTest = GetDataValue(sCMD, Nothing)
			If (vTest = "") Then sRMode = "N1A"
			If (vTest = 1) Then sRMode = "SR"
		End If
	Else
		Select Case sRType
			Case "CAR": sCMD = "SELECT COUNT(RefNum) AS RetVal FROM QActions WHERE (RefType = 'CAR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ'))"
			Case "CO": sCMD = "SELECT COUNT(CO) AS RetVal FROM Changes WHERE (RefType = 'CO') AND ((ChStatus = 'CREQ') OR (ChStatus = 'REQ'))"
			Case "DOC": sCMD = "SELECT COUNT(DocID) AS RetVal FROM Documents WHERE ((DocStatus = 'CREQ') OR (DocStatus = 'REQ'))"
			Case "MDISP": sCMD = "SELECT COUNT(MatDispID) AS RetVal FROM MatDisp WHERE ((DispStatus <> 'COMPL') AND (DispStatus <> 'HOLD'))"
			Case "NCR": sCMD = "SELECT COUNT(RefNum) AS RetVal FROM QActions WHERE (RefType = 'NCR') AND ((AStatus = 'CREQ') OR (AStatus = 'REQ'))"
			Case "PROJ": sCMD = "SELECT COUNT(ProjNum) AS RetVal FROM ProjXRef WHERE ((ProjStatus = 'ACT') OR (ProjStatus = 'PLN'))"
			Case "TASK": sCMD = "SELECT COUNT(TaskID) AS RetVal FROM Tasks WHERE (TaskStatus = 'OPEN')"
		End Select
		If (sCMD <> "") Then
			vTest = GetDataValue(sCMD, Nothing)
			If (vTest = "0") Then sRMode = "N1A"
		End If
	End If
	
	TestGenMode = sRMode
End Function

Function SetActive(sRType, sRID)
	Dim sRet
	Dim sCMD
	Dim sTemp
	
	sRet = "F"
	sCMD = "SELECT FIRST(WATID) AS RetVal FROM WFlowTasks WHERE (WATStatus = 'ACTIVE') AND ((WFRefType = '" & sRType & "') AND (WFRefID = '" & sRID & "'))"
	sTemp = GetDataValue(sCMD, Nothing)
	If (sTemp = "") Then sRet = "T"
	
	SetActive = sRet
End Function

%>
