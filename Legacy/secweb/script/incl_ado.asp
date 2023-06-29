<% '***********************************************************************
Const DBDefLogin = "Admin"
' Const DBDefPath="D:\WD1-Shares\ERMS\ERMS42\erms42t.mdb" 'Const DBDefPath = "C:\inetpub\wwwroot\ermsweb42\erms42P.mdb"
'Local ***
Const DBDefPath = ""
	
'Live *****
'Const DBDefPath = "C:\\inetpub\\wwwroot\\TransportTriangle.com\\Publish\\Database\\erms42P.mdb"


 Sub SetCfgFile(sFile)
    Dim sCfgFile
    Dim oFSO
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
    
    
    '//changing ots.writeline to differnet database listed above 1/22/2021 tmc
    oTS.WriteLine "#DB"
    oTS.WriteLine "DBType=Access"
    'oTS.WriteLine "DBPath=D:\ERMS\erms41.mdb"
    'oTS.WriteLine "DBPath=C:\temp\erms42P.mdb"
    
    'Local *****
    oTS.WriteLine ""
    
    'Live *****
    'oTS.WriteLine "DBPath=C:\inetpub\wwwroot\Database\erms42P.mdb"
    
    
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
    
    'Local ****
    sConnect = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & DBDefPath
    
    
    'Live ****
    'sConnect = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & DBDefPath
    
    Set GetConn = Server.CreateObject("ADODB.Connection")
    
    GetConn.ConnectionTimeout = 30
    GetConn.CommandTimeout = 15
    GetConn.Mode = 3
    
    'GetConn.DefaultDatabase = Trim(aConfig(3))
    'GetConn.IsolationLevel = adXactCursorStability
    'GetConn.CursorLocation = adUseClient

    'Database Setting
    Dim testDBPath
    Dim prodDBPath
    Dim path

    testDBPath = Server.MapPath("/Database/test/")
    prodDBPath = Server.MapPath("/Database/prod/")
        
    Dim isProdDB
    Set isProdDB = Request.Cookies("isProdDB")
    If isProdDB = "true" Then
        path = prodDBPath
    Else
        path = testDBPath
    End If

    Dim fileName
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set objFolder = fso.GetFolder(path + "/")
    Set colFiles = objFolder.Files
    For Each objFile In colFiles
        fileName = objFile.Name
        Exit For
    Next

    Dim pos, name, xtn
	pos = InstrRev(fileName,".")
	xtn = Mid(fileName,pos+1)
	name = Mid(fileName,1,pos-1)
    
    sConnect = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & path &  "\" & name & ".mdb"

    'Set qfile = fso.OpenTextFile("D:\qtptest.txt",2,True)
    'qfile.WriteLine "Path--" + path
    'qfile.WriteLine "fileName--" + name
    'qfile.WriteLine "sConnect--" + sConnect

    GetConn.Open sConnect, DBDefLogin
    
    
End Function



Function GetADORecordset(sSQL, CN)
    Dim x
    
    If (sSQL <> "") Then
        
        x = InStr(1, sSQL, "WHERE", 1)
        If (x > 0) Then
            x = InStr(x, sSQL, "*", 1)
            If (x > 0) Then
                sSQL = Replace( sSQL, "*", Chr(37), x, - 1, 1)
            End If
        End If
        
        If (CN Is Nothing) Then
            Set CN = GetConn()
        End If
        
    'Set fso = CreateObject("Scripting.FileSystemObject")
    'Set qfile = fso.OpenTextFile("D:\qtptest.txt",2,True)
    'qfile.WriteLine "sSQL--" & sSQL

        Set GetADORecordset = Server.CreateObject("ADODB.Recordset")
        GetADORecordset.Open sSQL, CN
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
    
    If Not ((rsData.BOF = True) And (rsData.EOF = True)) Then
        sReturn = IIf(IsNull(rsData("RetVal")), "", rsData("RetVal"))
    Else
        sReturn = ""
    End If
    
    rsData.Close
    Set rsData = Nothing
    
    GetDataValue = sReturn
End Function

%>
