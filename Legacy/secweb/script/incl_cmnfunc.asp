<%
'Dim SVars

'If (Request.QueryString <> "") Then
'	SVars = "SI=" & Request.QueryString("SI") & "&M=" & Request.QueryString("M")
'Else
'	If (Session.SessionID <> "") then
'		SVars = "SI=" & Session.SessionID
'	End If
'End If

Function IIf(sEval, TrueResp, FalseResp)
	Dim RetResp
	
	If (sEval = True) Then
		RetResp = TrueResp
	Else
		RetResp = FalseResp
	End If
	
	IIf = RetResp
End Function

Function CheckSearchString(sEval)
	Dim sRet
	
	'sRet = Replace(sEval, "*", Chr(37), 1, -1, 1)
	sRet = Replace(sEval, "'", "''", 1, -1, 1)
    sRet = Replace(sRet, "'''", "''", 1, -1, 1)
	sRet = Replace(sRet, Chr(34), Chr(34) & Chr(34), 1, -1, 1)
    sRet = Replace(sRet, Chr(34) & Chr(34) & Chr(34), Chr(34) & Chr(34), 1, -1, 1)
	
	CheckSearchString = sRet
End Function

Function CheckString(sCheck)
    Dim sRet
    
    sRet = Replace(sCheck, "'", "''", 1, -1, 1)
    sRet = Replace(sRet, "'''", "''", 1, -1, 1)
    sRet = Replace(sRet, Chr(34), Chr(34) & Chr(34), 1, -1, 1)
    sRet = Replace(sRet, Chr(34) & Chr(34) & Chr(34), Chr(34) & Chr(34), 1, -1, 1)
    
    CheckString = sRet
End Function

Function GetVirtualLink(sLink)
	Dim sFind
	Dim sRepl
	
	If (Left(sLink, 5) = "FILE:") Or (Left(sLink, 5) = "http:") Then sLink = Right(sLink, Len(sLink) - 5)
	sFind = "//DIS/ERMS/"
	sRepl = "../disfiles/"
	If (sFind <> "") And (sRepl <> "") Then sLink = Replace(sLink, sFind, sRepl, 1, -1, 1)
	GetVirtualLink = sLink
End Function

Function GetWebRoot()
	Dim sRoot
	Dim oF
	Dim oDC
    Dim oD
	
	Set oF = Server.CreateObject("Scripting.FileSystemObject")
	Set oDC = oF.Drives
	sRoot = ""
    
    For Each oD In oDC
        If (oD.DriveType = 2) Or (oD.DriveType = 3) Then
            If (Asc(oD.DriveLetter) >= Asc("C")) And (Asc(oD.DriveLetter) <= Asc("Z")) Then
                If (oF.FileExists(oD.DriveLetter & ":\InetPub\wwwroot\ermsweb42\index.htm")) Then
                    sRoot = oD.DriveLetter & ":\InetPub\wwwroot\ermsweb42\"
                    Exit For
                End If
            End If
        End If
    Next
    
    Set oF = Nothing
	Set oDC = Nothing
    
    GetWebRoot = sRoot
End Function

Function GetConstraint(vField, vMod, vVal)
    Dim sConstraint
    Dim sFType
    Dim x, y, z
    Dim curMod
    
    sFType = GetDataValue("SELECT FieldType AS RetVal FROM SearchFields WHERE (SearchField = '" & vField & "')", Nothing)
    
    Select Case vMod
		Case "E"
			curMod = "="
		Case "LT"
			curMod = "<"
		Case "GT"
			curMod = ">"
		Case "N"
			curMod = "<>"
		Case "L"
			curMod = "LIKE"
    End Select
    
    'Response.Write "vField=" & vField & "<br>"
    'Response.Write "vMod=" & vMod & "<br>"
    'Response.Write "vVal=" & vVal & "<br>"
    
    Select Case sFType
        Case "String"
            Select Case curMod
                Case "LIKE"
					x = InStr(1, CStr(vVal), "*", 1)
					y = InStr(1, CStr(vVal), Chr(37), 1)
					If (y > 0) Then
						vVal = Replace(CStr(vVal), Chr(37), "*", 1, -1, 1)
					End If
					z = InStr(1, CStr(vVal), "_", 1)
					If ((x > 0) Or (y > 0) Or (z > 0)) Then
						sConstraint = "(" & CStr(vField) & " LIKE ||" & CStr(vVal) & "||)"
					Else
						sConstraint = "(" & CStr(vField) & " LIKE ||*" & CStr(vVal) & "*||)"
                    End If
                Case Else
                    If (UCase(vVal) = "NULL") Then
                        sConstraint = "(" & vField & IIf(curMod = "=", " IS", " IS NOT") & " NULL)"
                    Else
                        sConstraint = "(" & CStr(vField) & " " & CStr(curMod) & " ||" & CStr(vVal) & "||)"
                    End If
            End Select
        Case "Number", "Long", "Single", "Double", "Float"
            If IsNumeric(vVal) Then
				Select Case curMod
				    Case "LIKE"
						sConstraint = "(" & CStr(vField) & " = " & Left(CStr(vVal), Len(vVal)) & ")"
				    Case Else
				        If (UCase(vVal) = "NULL") Then
				            sConstraint = "(" & vField & IIf(curMod = "=", " IS", " IS NOT") & " NULL)"
				        Else
				            sConstraint = "(" & vField & " " & curMod & " " & vVal & ")"
				        End If
				End Select
            End If
        Case "Date"
            If IsDate(vVal) Then
				Select Case curMod
				    Case "LIKE"
						x = InStr(1, vVal, "*", 1)
						y = InStr(1, vVal, Chr(37), 1)
						If (y > 0) Then
							vVal = Replace(vVal, Chr(37), "*", 1, -1, 1)
						End If
						z = InStr(1, vVal, "_", 1)
						If ((x > 0) Or (y > 0) Or (z > 0)) Then
							sConstraint = "(" & vField & " LIKE ||" & vVal & "||)"
						Else
							sConstraint = "(" & vField & " LIKE ||*" & vVal & "*||)"
				        End If
				        
				    Case Else
				        If (UCase(vVal) = "NULL") Then
				            sConstraint = "(" & vField & IIf(curMod = "=", " IS", " IS NOT") & " NULL)"
				        Else
				            sConstraint = "(" & vField & " " & curMod & " @" & vVal & "@)"
				        End If
				End Select
            End If
        Case "Boolean"
            If ((vVal = "True") Or (vVal = "False") Or (vVal = 0) Or (vVal = 1) Or (vVal = -1)) Then
				sConstraint = "(" & vField & " " & curMod & " " & vVal & ")"
            End If
        Case Else
			sConstraint = ""
    End Select
    	
    GetConstraint = sConstraint
End Function

%>