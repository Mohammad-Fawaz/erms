<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_ado.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Element Production Traveler / Micropac Industries, Inc.</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<%

Set rsTraveler = GetADORecordset("SELECT * FROM ViewTraveler WHERE WebView = True AND PartID=" & Request.QueryString("PartID"), Nothing)
If (rsTraveler.EOF = True And rsTraveler.BOF = True) Then
	Response.Write("Error: no traveler file found for this element.")
	Response.End()
End If

If (rsTraveler("Par11") = "Thickness") Then
	SliceThickness = rsTraveler("Par5")
Else
	Execute("SliceThickness = " & rsTraveler("Par5") & rsTraveler("Par11"))
End If
SliceThickness = Mid(SliceThickness, InStr(SliceThickness, ".") + 1)
SliceThickness = "." + SliceThickness + String(4 - Len(SliceThickness), "0")

Thickness = Mid(rsTraveler("Par5"), InStr(rsTraveler("Par5"), ".") + 1)
Thickness = "." + Thickness + String(4 - Len(Thickness), "0")

Data = String(2 - Len(Month(Date)), "0") & Month(Date) & "/" & String(2 - Len(Day(Date)), "0") & Day(Date) & "/" & Year(Date)

%>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="5">
  <tr valign="top"> 
    <td width="150" align="center"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif">Date: <%= Data %> </font></div></td>
    <td align="center"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif">Description: <%=rsTraveler("DocDesc")%></font></div></td>
    <td width="100" align="center"><div align="left"><font face="Verdana, Arial, Helvetica, sans-serif">Rev: <%=rsTraveler("CurrentRev")%> </font></div></td>
  </tr>
  <tr> 
    <td colspan="3" align="center"><table width="100%" border="1" cellpadding="5" cellspacing="0" bordercolor="#000000">
        <tr valign="top"> 
          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Element 
            Part No:</font><font face="Verdana, Arial, Helvetica, sans-serif"> 
            <br>
            <%=rsTraveler("PartNo")%></font> </td>
          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Material Number:</font><font face="Verdana, Arial, Helvetica, sans-serif"> 
            <br><%=rsTraveler("MatlPn")%> </font></td>
          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Element Size:</font><font face="Verdana, Arial, Helvetica, sans-serif"> <br>
            <%=rsTraveler("Par1")%> x <%=rsTraveler("Par3")%> x <%=Thickness%> </font></td>
          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Wafer Slice Thickness:</font><font face="Verdana, Arial, Helvetica, sans-serif"> 
            <br>
            <%=SliceThickness%></font></td>
        </tr>
        <tr valign="top"> 
          <td colspan="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Lot Number:<br>
            <br>
            </font></td>
          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Kit #:<br>
            <br>
            </font></td>
          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">Charge No:<br>
            <br>
            </font></td>
        </tr>
      </table>
      <br> </td>
  </tr>
  <tr> 
    <td colspan="3" align="center">
<%
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
'Set objText = objFSO.OpenTextFile(rsTraveler("FileLocation"))
'getFileContents = objText.ReadAll

If Not IsNull(rsTraveler("FileLocation")) Then
	If (objFSO.FileExists(rsTraveler("FileLocation")) = True) Then
		getFileContents = objFSO.OpenTextFile(rsTraveler("FileLocation")).ReadAll
	Else
		getFileContents = "<p><font size='3' face='Verdana'>File information could not be located. No file exists at supplied location.</font></p>"
	End If
Else
	getFileContents = "<p><font size='3' face='Verdana'>File information could not be located. No path was received.</font></p>"
End If

'objText.Close
'Set objText = Nothing

Set objFSO = Nothing
'======================================================
'Objects MUST be explicitly destroyed in order to free system resources.
rsTraveler.Close
Set rsTraveler = Nothing
'======================================================

Response.Write(getFileContents)
%>
    </td>
  </tr>
</table>
</body>
</html>
