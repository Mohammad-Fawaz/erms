<!-- #INCLUDE FILE="incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="incl_ado.asp" -->
<!-- #INCLUDE FILE="incl_sessinfo.asp" -->

<%
Dim curSID

'GetUserInfo = Array([UID], [EmpID], [ULNF], [SecGrp])
If (Session("SI") <> "") Then
	'Session("SI") = UpdateSessInfo(Session("SI"))
	curSID = Session("SI")
Else
	Response.Redirect "../index.htm"
End If

%>
