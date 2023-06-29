<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/requestobjects.asp" -->
<%
'Option Explicit
Response.Buffer = False
Server.ScriptTimeOut = 300

Dim oPseudoRequest, element, i, bTest

%>
<!-- #INCLUDE FILE="script/incl_pgdef2.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_proc.asp" -->
<html>

<head>
<%
Dim sRet
Dim sQString
Dim curRT
Dim curRec

sQString = Request.QueryString

'=====================================================
Dim DefUpDir
'Set upload default directory
DefUpDir = "\\dis\ERMS\ERMSmisc\Incoming"

Function GetUDir(sType)
	Dim sRetDir
	
	'Retrieve upload directory setting
	sRetDir = GetUpDir(sType)
	If (sRetDir = "") Then
		'Send upload to default directory
		sRetDir = DefUpDir
	End If
	sRetDir = IIf(Right(sRetDir, 1) = "\", sRetDir, sRetDir & "\")
	
	GetUDir = sRetDir
End Function
'=====================================================

curRT = Request.QueryString("RT")
curRec = Request.QueryString("CR")
sRet = ""

Sub WriteAttRec()
	Dim bRet
	Dim sDir
	Dim sSQL
	Dim sAttType
	Dim sFName
	Dim sFLoc
	Dim sFLink
	Dim sFType
	
	'Save File attachment
	Set oPseudoRequest = New PseudoRequestDictionary
	oPseudoRequest.ReadRequest()
	oPseudoRequest.ReadQuerystring(Request.Querystring)
	sRet = ""
	If oPseudoRequest.Form("attach1").ContainsFile Then
		Select Case curRT
			Case "CR": sAttType = "COA": sDir = GetUpDir("COA")
			Case "TR": sAttType = "TA": sDir = GetUpDir("TA")
		End Select
		bTest = SaveFileAs(oPseudoRequest, "attach1", IIf(Right(sDir, 1) = "\", sDir, sDir & "\"))
		If bTest Then
			sFName = oPseudoRequest.Form("attach1").FileName
			sFType = UCase(Right(sFName, Len(sFName) - InStr(1, sFName, ".", 1)))
			sFLoc = IIf(Right(sDir, 1) = "\", sDir, sDir & "\") & oPseudoRequest.Form("attach1").FileName
			sFLink = IIf(Left(sFLoc, 2) = "\\", "http:", "http:\\") & sFLoc
			sFLink = Replace(sFLink, "\", "/", 1, -1, 1)
			
			'AttID (Auto-Number)
			'RefType
			'RefID
			'AttLUpd
			'AttLUpdBy
			sFields =  "RefType, RefID, AttLUpd, AttLUpdBy"
			sVals =  "'" & sAttType & "', " & curRec & ", #" & Date & "#, '" & IIf(curUN <> "", curUN, "ERMSWeb User") & "'"
			
			'AttFName
			sFields = IIf(sFields <> "", sFields & ", ", "") & "AttFName"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & sFName & "'"
			'AttFType
			sFields = IIf(sFields <> "", sFields & ", ", "") & "AttFType"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & sFType & "'"
			'AttFLoc
			sFields = IIf(sFields <> "", sFields & ", ", "") & "AttFLoc"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & sFLoc & "'"
			'AttFLink
			sFields = IIf(sFields <> "", sFields & ", ", "") & "AttFLink"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & sFLink & "'"
			
			'AttFDesc
			If (oPseudoRequest.Form("AFDesc") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "AttFDesc"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(oPseudoRequest.Form("AFDesc")) & "'"
			End If
			'PSize
			sFields = IIf(sFields <> "", sFields & ", ", "") & "PSize"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'A'"
			'If (oPseudoRequest.Form("AFPsize") <> "") And (oPseudoRequest.Form("AFPsize") <> "SELECT") Then
			'	sFields = IIf(sFields <> "", sFields & ", ", "") & "PSize"
			'	sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & oPseudoRequest.Form("AFPsize") & "'"
			'End If
			'PLoc
			sFields = IIf(sFields <> "", sFields & ", ", "") & "PLoc"
			sVals = IIf(sVals <> "", sVals & ", ", "") & "'LAN'"
			'If (oPseudoRequest.Form("AFPloc") <> "") And (oPseudoRequest.Form("AFPloc") <> "SELECT") Then
			'	sFields = IIf(sFields <> "", sFields & ", ", "") & "PLoc"
			'	sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & oPseudoRequest.Form("AFPloc") & "'"
			'End If
			'WebView
			sFields = IIf(sFields <> "", sFields & ", ", "") & "WebView"
			sVals = IIf(sVals <> "", sVals & ", ", "") & IIf(oPseudoRequest.Form("AFWview") <> "", "-1", "0")
			
			sSQL = "INSERT INTO AttRefs (" & sFields & ") VALUES (" & sVals & ")"
			'Response.Write sSQL
			bRet = RunSQLCmd(sSQL, Nothing)
			
			If Not bRet Then
				sRet = "An unexpected error occurred while attempting to create the attachment record."
			End If
		Else
			sRet = "An unexpected error occurred while attempting to upload the selected file."
		End If
	'Else
		'No file detected
	End If
    
    Set oPseudoRequest = Nothing
End Sub

Function SaveFileAs(oPseudoRequest, sItem, sSaveDirectory)
	SaveFileAs = False
	'On Error Resume Next
	oPseudoRequest.Form(sItem).SaveAs(sSaveDirectory & oPseudoRequest.Form(sItem).FileName)
	If Not Err Then SaveFileAs = True
End Function

If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	'Save File attachment
	WriteAttRec
End If

Select Case curRT
	Case "CR": sCurList = GetProcInfo("Att2", curRec, "COA")
	Case "TR": sCurList = GetProcInfo("Att2", curRec, "TA")
End Select

%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Add Attachment</title>
</head>

<body>

<table border="0" cellpadding="6" width="600" cellspacing="0">
  <tr>
    <td width="100%"><form method="POST" enctype="multipart/form-data" action="add_att.asp?<% =sQString %>">
      <div align="center"><center><table border="0" cellpadding="2" width="100%">
        <tr>
          <td colspan="2" bgcolor="#0075FF"><font face="Verdana" color="#FFFFFF"><strong>Add File
          Attachment</strong></font></td>
        </tr>
        <tr>
          <td align="right"><strong><font face="Verdana" size="2">Select File:</font></strong></td>
          <td><input name="attach1" type="file" size="35"></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Description:</strong></font></td>
          <td><textarea rows="2" name="AFDesc" cols="48"></textarea></td>
        </tr>
        <!-- <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Print Size:</strong></font></td>
          <td><select name="AFPsize" size="1">
            <option selected>SELECT</option>
<% =GetSelect("PSize", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Print Location:</strong></font></td>
          <td><select name="AFPloc" size="1">
            <option selected>SELECT</option>
<% =GetSelect("PLoc", "") %>
          </select></td>
        </tr> -->
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Web View:</strong></font></td>
          <td><input type="checkbox" name="AFWview" value="T" checked></td>
        </tr>
        <tr>
          <td align="center" colspan="2"><input type="submit" value="Save File" name="BSub"><input
          type="reset" value="Clear Form" name="B3"></td>
        </tr>
      </table>
      </center></div>
    </form>
    </td>
  </tr>
  <tr>
    <td width="100%" align="center"><strong><font face="Verdana" size="2"><a href="JavaScript:window.close(this);"
    onMouseOver="window.status = 'Close Window'; return true;">Close Window</a></font></strong></td>
  </tr>
</table>
<% =sRet %>
<p><strong><font face="Verdana" size="3">Current Listings</font></strong></p>

<table border="0" cellpadding="2" width="600">
  <tr>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>File Name</strong></font></td>
    <td bgcolor="#C0C0C0"><font face="Verdana" size="2"><strong>Description</strong></font></td>
  </tr>
<% =sCurList %>
</table>
</body>
</html>
