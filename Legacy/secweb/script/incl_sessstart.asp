<!-- #INCLUDE FILE="incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="incl_ado.asp" -->
<!-- #INCLUDE FILE="incl_sessdrop.asp" -->

<%
Function SetUser(vSID, vUID, vPW)
    Dim bUserSet
    Dim nEmpID
    Dim sUName
    Dim nProfileID
    'Dim nMenu
    Dim nRetCode
    Dim sSQL
    Dim rsUser
    Dim bUser
    
    nRetCode = 1
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
			'Set rsUser = Server.CreateObject("ADODB.Recordset")
			
			sSQL = "SELECT EmpID, UPass, ULNF, ProfileID FROM QUserInfo WHERE "
			sSQL = sSQL & "(UID = '" & vUID & "') AND (UPass = '" & vPW & "')"
			Set rsUser = GetADORecordset(sSQL, Nothing)
		        
			If Not ((rsUser.BOF = True) And (rsUser.EOF = True)) Then
				nEmpID = IIf(IsNull(rsUser("EmpID")), 0, rsUser("EmpID"))
				sUName = IIf(IsNull(rsUser("ULNF")), "USER", rsUser("ULNF"))
				nProfileID = IIf(IsNull(rsUser("ProfileID")), 7, rsUser("ProfileID"))
				bUserSet = True
			'Else
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
		Select Case LCase(vUID)
			Case "superuser", "user", "guest"
				bUser = False
			Case Else
				'Dump any old sessions
				DumpUserSession vSID, vUID
				bUser = False
		End Select
		
		sSQL = "INSERT INTO EWebSessions (SessionID, UID, EmpID, ULNF, ProfileID, SessionStart) "
		sSQL = sSQL & "VALUES ("
		sSQL = sSQL & vSID & ", '" & vUID & "', " & nEmpID & ", '" & sUName & "', " 
		sSQL = sSQL & nProfileID & ", #" & Now() & "#)"
		
		Response.Write sSQL
		'bUser = RunSQLCmd(sSQL, Nothing)
		
		If bUser Then
			
			'Select Case nProfileID
			'	Case 1, 3		'Admins
			'		nMenu = 3
			'	Case 8, 9		'Management
			'		nMenu = 2
			'	Case Else
			'		nMenu = 1
			'End Select
			'SVars = "SI=" & vSID		' & "&M=" & nMenu
			
			Session("SI") = vSID
			nRetCode = 0
		Else
			nRetCode = 2
		End If
    End If
    
    SetUser = nRetCode
End Function

%>
