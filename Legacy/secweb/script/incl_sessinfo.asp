<%
Dim curEID
Dim curUN
Dim curSG

Function GetUserInfoItem(nSessID, sItem)
	Dim sSQL
	Dim vRet
	
	vRet = ""
	If (nSessID <> "") Then
		sSQL = "SELECT " & sItem & " AS RetVal FROM EWebSessions WHERE (SessionID = '" & nSessID & "')"
			
		vRet = GetDataValue(sSQL, Nothing)
	'Else
	'	Response.Redirect "../index.htm"
	End If
	
	GetUserInfoItem = vRet
End Function

Function GetUserProfileID(nSessID)

	'sSQL = "SELECT ProfileID FROM EWebSessions "
	'sSQL = sSQL & "WHERE SessionID = " & nSessID
	'Set rsUserInfo = GetADORecordset(sSQL, Nothing)
	
    'sSQL = "SELECT ProfileID FROM AppSecProfiles WHERE SecGroup = '" & rsUserInfo("SecGroup") & "'"
    'Set rsProfileInfo = GetADORecordset(sSQL, Nothing)
    'GetUserProfileID = rsProfileInfo("ProfileID")
	GetUserProfileID = GetUserInfoItem(nSessID, "ProfileID")
    ' rsUserInfo.Close
    'rsProfileInfo.Close

End Function




Function GetUserInfo(nSessID)
	Dim sSQL
	Dim rsUserInfo
	Dim sUID, nEID, sUName, nSecLev
		
	'If (Session.SessionID <> "") then
		'nSessID = Session("SI")
	'End If
	 
	If (nSessID <> "") Then
	
		sSQL = "SELECT SessionID, UID, EmpID, ULNF, ProfileID, SessionStart FROM "
		sSQL = sSQL & "EWebSessions WHERE SessionID = '" & nSessID & " '"
		
		'Response.Write "sSQL=" & sSQL & "<br>"
		
		GetUserInfo = Array(0)
		Set rsUserInfo = GetADORecordset(sSQL, Nothing)				
		If Not ((rsUserInfo.BOF = True) And (rsUserInfo.EOF = True)) Then		    
			sUID = IIf(IsNull(rsUserInfo("UID")), "user", rsUserInfo("UID"))
			nEID = IIf(IsNull(rsUserInfo("EmpID")), 0, rsUserInfo("EmpID"))
			sUName = IIf(IsNull(rsUserInfo("ULNF")), "USER", rsUserInfo("ULNF"))
			nSecLev = IIf(IsNull(rsUserInfo("ProfileID")), 7, rsUserInfo("ProfileID"))				
			GetUserInfo = Array(sUID, nEID, sUName, nSecLev)			
		Else
		    GetUserInfo = Array("user", "0", "USER", 7)			   
		End If
		
	Else	
	    GetUserInfo = Array("user", "0", "USER", 7)		    	
	End If
		
	Set rsUserInfo = Nothing
End Function



Function UpdateSessInfo(nSessID)
	Dim sSQL
	Dim nRet
	Dim bRet
	
	Session.Abandon
	nRet = Session.SessionID
	sSQL = "UPDATE EWebSessions SET SessionID = " & nRet
	sSQL = sSQL & " WHERE (SessionID = " & nSessID & ")"
	
	bRet = RunSQLCmd(sSQL, Nothing)
	If bRet Then
		UpdateSessInfo = nRet
	Else
		UpdateSessInfo = nSessID
	End If
End Function

%>