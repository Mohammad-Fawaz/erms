<!-- #INCLUDE FILE="incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="incl_ado.asp" -->
<!-- #INCLUDE FILE="incl_sessinfo.asp" -->

<%
Dim curSID
Dim aUsr

'GetUserInfo = Array([UID], [EmpID], [ULNF], [SecGrp])
If (Session("SI") <> "") Then
	'Session("SI") = UpdateSessInfo(Session("SI"))
	curSID = Session("SI")
	aUsr = GetUserInfo(curSID)
Else
	Response.Redirect "../index.htm"
End If
	
If IsArray(aUsr) Then
	curEID = aUsr(1)
	curUN = aUsr(2)
	curSG = aUsr(3)
Else
'	curEID = 0
'	curUN = "USER"
'	curSG = 7
End If

%>
