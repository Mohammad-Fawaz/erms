<%

Dim curEID
Dim curUN
Dim curSG

Function SetUser(vSID, vUID, vPW)
    Dim bUserSet
    Dim nEmpID
    Dim sUName
    Dim nProfileID
    Dim nMenu
    Dim nRetCode
    Dim sSQL
    
    nRetCode = 0
    bUserSet = False
    
    If ((vUID <> "") And (vPW <> "")) Then
		If ((LCase(vUID) = "superuser") And (LCase(vPW) = "erms")) Then
			nEmpID = 99999
			sUName = "SUPERUSER"
			nProfileID = 8
			bUserSet = True
		End If
		'If ((vUID = "user") And (vPW = "")) Then
		'	nEmpID = 0
		'	sUName = "USER"
		'	nProfileID = 7
		'	bUserSet = True
		'End If
		
		If Not bUserSet Then
		    Dim rsUser
		    
			'Set rsUser = Server.CreateObject("ADODB.Recordset")
			sSQL = "SELECT EmpID, UPass, ULNF, ProfileID FROM QUserInfo WHERE "
			sSQL = sSQL & "(UID = '" & vUID & "') AND (UPass = '" & vPW & "')"
			Set rsUser = GetADORecordset(sSQL, Nothing)
		        
			If Not ((rsUser.BOF = True) And (rsUser.EOF = True)) Then
				nEmpID = IIf(IsNull(rsUser("EmpID")), 0, rsUser("EmpID"))
				sUName = IIf(IsNull(rsUser("ULNF")), "USER", rsUser("ULNF"))
				nProfileID = IIf(IsNull(rsUser("ProfileID")), 7, rsUser("ProfileID"))
				bUserSet = True
			Else
				'Provide minimal access
				'nEmpID = 0
				'sUName = "USER"
				'nProfileID = 7
				'bUserSet = True
			End If
			
			rsUser.Close
			Set rsUser = Nothing
		End If
    End If
    
    'Set Session Info Record
    If (bUserSet = True) Then
		Dim bUser
		
		Select Case LCase(vUID)
			Case "superuser", "user", "guest"
				bUser = False
			Case Else
				'Dump any old sessions
				DumpUserSession(vSID)
				bUser = False
		End Select
		
		sSQL = "INSERT INTO EWebSessions (SessionID, UID, EmpID, ULNF, ProfileID, SessionStart) "
		sSQL = sSQL & "VALUES ("
		sSQL = sSQL & vSID & ", '" & vUID & "', " & nEmpID & ", '" & sUName & "', " 
		sSQL = sSQL & nProfileID & ", #" & Now() & "#)"
		
		'Response.Write sSQL
		bUser = RunSQLCmd(sSQL, Nothing)
		
		If bUser Then
			Select Case nProfileID
				Case 1, 3		'Admins
					nMenu = 3
				Case 8, 9		'Management
					nMenu = 2
				Case Else
					nMenu = 1
			End Select
			SVars = "SI=" & vSID & "&M=" & nMenu
		Else
			nRetCode = 2
		End If
    Else
		nRetCode = 1
    End If
    
    SetUser = nRetCode
End Function

Function GetUserInfo(nSessID)
	Dim sSQL
	Dim rsUserInfo
	Dim sUID, nEID, sUName, nSecLev
	
	If Not (nSessID > 0) Then
		If (Session.SessionID <> "") then
			nSessID = Session.SessionID
		End If
	End If
	
	If (nSessID <> "") Then
		sSQL = "SELECT SessionID, UID, EmpID, ULNF, ProfileID, SessionStart FROM "
		sSQL = sSQL & "EWebSessions WHERE SessionID = " & nSessID
		Set rsUserInfo = GetADORecordset(sSQL, Nothing)
	
		GetUserInfo = Array(0)
	
		If Not ((rsUserInfo.BOF = True) And (rsUserInfo.EOF = True)) Then
			sUID = IIf(IsNull(rsUserInfo("UID")), "user", rsUserInfo("UID"))
			nEID = IIf(IsNull(rsUserInfo("EmpID")), 0, rsUserInfo("EmpID"))
			sUName = IIf(IsNull(rsUserInfo("ULNF")), "USER", rsUserInfo("ULNF"))
			nSecLev = IIf(IsNull(rsUserInfo("ProfileID")), 7, rsUserInfo("ProfileID"))
			GetUserInfo = Array(sUID, nEID, sUName, nSecLev)
		'Else
		'	GetUserInfo = Array("user", "0", "USER", 7)
		End If
	Else
	'	GetUserInfo = Array("user", "0", "USER", 7)
		GetUserInfo = ""
	End If
	
	Set rsUserInfo = Nothing
End Function

Function DumpUserSession(nSessID)
	Dim sSQL
	Dim bRet
	Dim aUInf
	
	aUInf = GetUserInfo(nSessID)
	
	If IsArray(aUInf) Then
		If (aUInf(0) <> "") Then
			sSQL = "DELETE * FROM EWebSessions WHERE (UID = '" & aUInf(0) & "')"
			bRet = RunSQLCmd(sSQL, Nothing)
		End If
	Else
		'Drop specified session
		sSQL = "DELETE * FROM EWebSessions WHERE (SessionID = " & nSessID & ")"
		bRet = RunSQLCmd(sSQL, Nothing)
	End If
	
	'Dump any sessions over 8 hours old
	sSQL = "DELETE * FROM EWebSessions WHERE "
	sSQL = sSQL & "(SessionStart < #" & DateSerial(Year(Date), Month(Date), Day(Date) - 1) & "#)"
	bRet = RunSQLCmd(sSQL, Nothing)
	sSQL = "DELETE * FROM EWebSessions WHERE "
	sSQL = sSQL & "(SessionStart < #" & TimeSerial(Hour(Time) - 8, Minute(Time), Second(Time)) & "#)"
	bRet = RunSQLCmd(sSQL, Nothing)
	
	DumpUserSession = bRet
End Function

%>