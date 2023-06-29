<% '***********************************************************************
Const DBDefLogin = "Admin"
' Const DBDefPath="\\ERMS\ERMS_PROD\EDATA\erms42.mdb" 'Const DBDefPath = "\\DIS\ERMS\ERMSapp\ERMS_PROD\EDATA\erms42P.mdb"
Const DBDefPath = "C:\\temp\\erms42P.mdb"
' *********************************************************************** Sub SetCfgFile(sFile) Dim sCfgFile Dim oFSO
	If (sFile <> "") Then
	sCfgFile = sFile
	Else
	sCfgFile = "../_private/ewebcfg.txt"
	End If

	Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
	Set oTS = oFSO.OpenTextFile(sCfgFile, ForWriting, True)

	'==================================
	'Can fill in defaults here for
	'current installation.
	'MS Access Database
	'oTS.WriteLine "DBType=Access"
	'oTS.WriteLine "DBPath=F:\ERMS_PROD\EDATA\erms_data.mdb"
	'oTS.WriteLine "DBName="
	'oTS.WriteLine "DBLogin=Admin"
	'oTS.WriteLine "DBPass="
	'MS SQL Server Database
	'oTS.WriteLine "DBType=SQL"
	'oTS.WriteLine "DBPath=[SQL Server Name]"
	'oTS.WriteLine "DBName=[SQL Server db Name]"
	'oTS.WriteLine "DBLogin=[Login ID]"
	'oTS.WriteLine "DBPass=[Password]"
	'==================================

	oTS.WriteLine "#DB"
	oTS.WriteLine "DBType=Access"
	oTS.WriteLine "DBPath=D:\ERMS\erms41.mdb"
	oTS.WriteLine "DBName="
	oTS.WriteLine "DBLogin=Admin"
	oTS.WriteLine "DBPass="

	oTS.Close
	Set oTS = Nothing
	Set oFSO = Nothing
	End Sub

	Function GetCfgItem(sItem)
	Dim sCfgFile
	Dim sItemData
	Dim sGroup
	Dim oFSO, oTS

	sCfgFile = "../_private/ewebcfg.txt"

	Select Case sItem
	'List items in each grouping
	Case "DBPath", "DBName", "DBLogin", "DBPass"
	'Set Group for search
	sGroup = "DB"
	Case Else
	sGroup = ""
	End Select

	If (sGroup <> "") Then
		Set oFSO = Server.CreateObject("Scripting.FileSystemObject")

		If (oFSO.FileExists(sCfgFile)) Then
		Set oTS = oFSO.OpenTextFile(sCfgFile, ForReading, False)

		oTS.Close
		Set oTS = Nothing
		Else
		SetCfgFile sCfgFile
		sItemData = GetCfgItem(sItem)
		End If

		Set oFSO = Nothing
		Else
		sItemData = ""
		End If

		GetCfgItem = sItemData
		End Function

		Function GetConn()
		Dim sConnect

		'sConnect = "Provider=MSDataShape.1;Data Source=" & DBDefPath & ";Data Provider=Microsoft.Jet.OLEDB.4.0"
		sConnect = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & DBDefPath
		Set GetConn = Server.CreateObject("ADODB.Connection")

		GetConn.ConnectionTimeout = 30
		GetConn.CommandTimeout = 15
		GetConn.Mode = adModeReadWrite

		'GetConn.DefaultDatabase = Trim(aConfig(3))
		'GetConn.IsolationLevel = adXactCursorStability

		GetConn.Open sConnect, DBDefLogin

		'GetConn.CursorLocation = adUseClient
		End Function

		Function GetADORecordset(sSQL, CN)
		Dim x

		If (sSQL <> "") Then
			'Response.Write "sSQL=" & sSQL & "<br>"

			x = InStr(1, sSQL, "WHERE", 1)
			If (x > 0) Then
			x = InStr(x, sSQL, "*", 1)
			If (x > 0) Then
			sSQL = Replace( sSQL, "*", Chr(37), x, -1, 1)
			End If
			End If

			If (CN Is Nothing) Then
			Set CN = GetConn()
			End If

			Set GetADORecordset = Server.CreateObject("ADODB.Recordset")
			'Debug.Print sSQL
			GetADORecordset.Open sSQL, CN ', adOpenStatic, adLockReadOnly
			'GetADORecordset.ActiveConnection = Nothing
			End If
			End Function

			Function RunSQLCmd(stCmd, CN)
			Dim bExecuted
			Dim cmdSQL

			bExecuted = False
			'Response.Write "stCmd = " & stCmd & "<br>"

			If (Trim(stCmd) <> "") Then
				If (CN Is Nothing) Then
				Set CN = GetConn()
				End If
				Set cmdSQL = Server.CreateObject("ADODB.Command")

				Set cmdSQL.ActiveConnection = CN
				cmdSQL.CommandText = stCmd
				cmdSQL.CommandType = 1
				cmdSQL.Execute

				bExecuted = True
				Set cmdSQL = Nothing
				End If

				RunSQLCmd = bExecuted
				End Function

				Function GetDataValue(sSQL, CN)
				Dim rsData
				Dim sReturn

				If Not (CN Is Nothing) Then
				Set rsData = GetADORecordset(sSQL, CN)
				Else
				Set rsData = GetADORecordset(sSQL, Nothing)
				End If

				sReturn = IIf(IsNull(rsData("RetVal")), "", rsData("RetVal"))

				rsData.Close
				Set rsData = Nothing

				GetDataValue = sReturn
				End Function

				%>