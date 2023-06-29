<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<%
Dim oFSO
Dim oTS
Dim sRet
Dim sRootDir

sRootDir = GetWebRoot()

If (sRootDir <> "") Then
	sRootDir = sRootDir & "errors"
	sRet = ""
	
	Set oFSO = Server.CreateObject("Scripting.FileSystemObject")
	
	If (oFSO.FolderExists(sRootDir)) Then
		If (oFSO.FileExists(sRootDir & "\rec_errs.log")) Then
			Set oTS = oFSO.OpenTextFile(sRootDir & "\rec_errs.log", ForReading, False)
			sRet = sRet & "<p><font face='Verdana' size='4'>RECORD SAVE ERRS</font></p>" & vbCrLf
			sRet = sRet & "<pre><font face='Courier New, Courier' size='2'>" & oTS.ReadAll & "</font></pre>" & vbCrLf
			oTS.Close
		End If
		
		If (oFSO.FileExists(sRootDir & "\db_errs.log")) Then
			Set oTS = oFSO.OpenTextFile(sRootDir & "\db_errs.log", ForReading, False)
			sRet = sRet & "<p><font face='Verdana' size='4'>DATABASE ERRS</font></p>" & vbCrLf
			sRet = sRet & "<pre><font face='Courier New, Courier' size='2'>" & oTS.ReadAll & "</font></pre>" & vbCrLf
			oTS.Close
		End If
		
		If (oFSO.FileExists(sRootDir & "\sql_errs.log")) Then
			Set oTS = oFSO.OpenTextFile(sRootDir & "\sql_errs.log", ForReading, False)
			sRet = sRet & "<p><font face='Verdana' size='4'>SQL SELECTION ERRS</font></p>" & vbCrLf
			sRet = sRet & "<pre><font face='Courier New, Courier' size='2'>" & oTS.ReadAll & "</font></pre>" & vbCrLf
			oTS.Close
		End If
		
		If (oFSO.FileExists(sRootDir & "\pg_errs.log")) Then
			Set oTS = oFSO.OpenTextFile(sRootDir & "\pg_errs.log", ForReading, False)
			sRet = sRet & "<p><font face='Verdana' size='4'>PAGE RENDER ERRS</font></p>" & vbCrLf
			sRet = sRet & "<pre><font face='Courier New, Courier' size='2'>" & oTS.ReadAll & "</font></pre>" & vbCrLf
			oTS.Close
		End If
		
		If (oFSO.FileExists(sRootDir & "\lst_errs.log")) Then
			Set oTS = oFSO.OpenTextFile(sRootDir & "\lst_errs.log", ForReading, False)
			sRet = sRet & "<p><font face='Verdana' size='4'>LIST RENDER ERRS</font></p>" & vbCrLf
			sRet = sRet & "<pre><font face='Courier New, Courier' size='2'>" & oTS.ReadAll & "</font></pre>" & vbCrLf
			oTS.Close
		End If
		
		If (oFSO.FileExists(sRootDir & "\ext_errs.log")) Then
			Set oTS = oFSO.OpenTextFile(sRootDir & "\ext_errs.log", ForReading, False)
			sRet = sRet & "<p><font face='Verdana' size='4'>EXTENDED ERRS</font></p>" & vbCrLf
			sRet = sRet & "<pre><font face='Courier New, Courier' size='2'>" & oTS.ReadAll & "</font></pre>" & vbCrLf
			oTS.Close
		End If
		
		If (sRet = "") Then
			sRet = "<p><font face='Verdana' size='4'>No error logs found.</font></p>"
		End If
		
		Set oTS = Nothing
		Set oFSO = Nothing
	Else
		sRet = "<p><font face='Verdana' size='4'>No error logs found.</font></p>"
	End If
Else
	sRet = "<p><font face='Verdana' size='3'>An unexpected error occurred while attempting to search for error logs.</font></p>"
End If
%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>View Error Logs</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %></td>
    <td width="635" valign="top"><font face="Verdana" size="5">View Error Logs</font><hr noshade size="3" color="#0075FF">
    <p><% =sRet %>&nbsp;</td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
