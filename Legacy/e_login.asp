<%@ Language=VBScript %>
<!-- #INCLUDE FILE="secweb/script/incl_sessstart.asp" -->

<%
Dim vUser
Dim SessID

'Session.Abandon
'Session.Timeout = 30
SessID = Session.SessionID
vUser = ""

If (Request.Form <> "") Then
	'Set Session Information
	If (Request.Form("sUID") <> "") And (Request.Form("sPW") <> "") Then
		vUser = SetUser(SessID, Request.Form("sUID"), Request.Form("sPW"))
	End If
Else
	If (Request.QueryString <> "") Then
		'Set Session Information
		'Response.Write "<p>UID: " & Request.QueryString("U") & "<br>PW: " & Request.QueryString("P") & "</p>"
		If (Request.QueryString("U") <> "") And (Request.QueryString("P") <> "") Then
			vUser = SetUser(SessID, Request.QueryString("U"), Request.QueryString("P"))
		End If
	End If
End If

'SVars = "SI=[SessID]&UI=[UID]&EI=[EmpID]&U=[ULNF]&S=[SecGroup]"
'SVars = "SI=" & SessID & "&UI=" & UID & "&EI=" & EmpID & "&U=" & ULNF & "&S=" & SecGroup
If (vUser = "") Then vUser = 1
Select Case vUser
	Case 0
		Response.Write "<html><head><meta http-equiv='refresh' content='0;URL=secweb/ermsw_index.asp'></head><title>Verifying Login Information...</title><body></body></html>"
	Case Else
		Response.Write "<html><head><meta http-equiv='refresh' content='0;URL=no_user.htm'></head><title>Verifying Login Information...</title><body></body></html>"
End Select

%>
