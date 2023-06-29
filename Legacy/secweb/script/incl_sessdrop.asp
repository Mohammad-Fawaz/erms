<%
Function DumpUserSession(nSessID, sUID)
	Dim sSQL
	Dim bRet
	
	If (sUID <> "") Then
		sSQL = "DELETE * FROM EWebSessions WHERE (UID = '" & sUID & "')"
		bRet = RunSQLCmd(sSQL, Nothing)
	End If
	
	'Drop specified session
	sSQL = "DELETE * FROM EWebSessions WHERE (SessionID = " & nSessID & ")"
	bRet = RunSQLCmd(sSQL, Nothing)
	'Dump any sessions from previous day or older
	sSQL = "DELETE * FROM EWebSessions WHERE "
	sSQL = sSQL & "(SessionStart < #" & DateSerial(Year(Date), Month(Date), Day(Date) - 1) & "#)"
	bRet = RunSQLCmd(sSQL, Nothing)
	'Dump any sessions over 8 hours old
	sSQL = "DELETE * FROM EWebSessions WHERE "
	sSQL = sSQL & "(SessionStart < #" & TimeSerial(Hour(Time) - 8, Minute(Time), Second(Time)) & "#)"
	bRet = RunSQLCmd(sSQL, Nothing)
	
	DumpUserSession = bRet
End Function

%>
