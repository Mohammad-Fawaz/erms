<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<%
Dim sUInfo
Dim bProcess
Dim sTemp

If (Request.Form <> "") Then
	Dim nEID
	Dim sCP
	Dim sNP
	Dim sVP
	
	nEID = Request.Form("EmpID")
	sCP = Request.Form("CurPW")
	sNP = Request.Form("NewPW")
	sVP = Request.Form("VerPW")
	
	If (nEID <> "") Then
		sTemp = GetDataValue("SELECT UPass AS RetVal FROM UserXRef WHERE (EmpID = " & nEID & ")", Nothing)
		If (sCP <> "") Then
			If (sTemp = sCP) Then
				If (sNP <> "") And (sVP <> "") Then
					If (sNP = sVP) Then
						If (sTemp <> sNP) Then
							sTemp = "UPDATE UserXRef SET UPass = '" & sNP & "' WHERE (EmpID = " & nEID & ")"
							bProcess = RunSQLCmd(sTemp, Nothing)
							If (bProcess = True) Then
								sUInfo = "Your password has been successfully updated. The new password will be required the next time you login to the system."
							Else
								sUInfo = "<b>ERROR:</b> An unexpected error occurred while attempting to update the record. No changes have been made."
							End If
						Else
							sUInfo = "<b>ERROR:</b> A new password must be provided. No changes have been made."
						End If
					Else
						sUInfo = "<b>ERROR:</b> The new password could not be verified. Please be certain to type the new password exactly the same in both fields. No changes have been made."
					End If
				Else
					sUInfo = "<b>ERROR:</b> A new password must be provided. No changes have been made."
				End If
			Else
				sUInfo = "<b>ERROR:</b> Current password does not match information on file. No changes have been made."
			End If
		Else
			sUInfo = "<b>ERROR:</b> User information could not be verified. No changes have been made."
		End If
	Else
		sUInfo = "<b>ERROR:</b> User information could not be verified. No changes have been made."
	End If
	bProcess = True
Else
	bProcess = False
	If (curEID <> 0) Then
		sUInfo = "Change current password for [" & curUN & "]."
	Else
		sUInfo = ""
	End If
End If

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Update Password</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2">
    <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" --></td>
  </tr>
  <tr>
    <!--<td width="145" valign="top" bgcolor="#FFFFC8"><% '=sMenu %>-->
</td>
    <td width="635" valign="top"><font face="Verdana" size="5">Update Password</font>
<%
If (bProcess = False) Then
	If (sUInfo <> "") Then
%>
    <p><font face="Verdana" size="2"><% =sUInfo %>&nbsp;</font></p>
    <form method="POST" action="upd_pw.asp?<% =SVars %>">
    <input type="hidden" name="EmpID" value="<% =curEID %>">
      <div align="center"><center><table border="0" cellpadding="2">
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Current Password:</strong></font></td>
          <td><input type="password" name="CurPW" size="20"></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>New Password:</strong></font></td>
          <td><input type="password" name="NewPW" size="20"></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Verify New Password:</strong></font></td>
          <td><input type="password" name="VerPW" size="20"></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input type="submit" value="Save New Password" name="B1"><input type="reset" value="Reset" name="B2"></td>
        </tr>
      </table>
      </center></div>
    </form></td>
<%
	Else
%>
    <p>You are currently logged in anonymously. The current information cannot be updated.</p></td>
<%
	End If
Else
%>
    <p><% =sUInfo %>&nbsp;</p></td>
<%
End If
%>
  </tr>
  <tr>
    <td width="100%" colspan="2">
    <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" --></td>
  </tr>
</table>
</body>
</html>
