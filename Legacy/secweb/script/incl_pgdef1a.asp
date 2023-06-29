<!-- #INCLUDE FILE="incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="incl_ado.asp" -->
<!-- #INCLUDE FILE="incl_sessinfo.asp" -->
<!-- #INCLUDE FILE="incl_menu.asp" -->

<%


Dim curSID

'GetUserInfo = Array([UID], [EmpID], [ULNF], [SecGrp])
If (Session("SI") <> "") Then
	'Session("SI") = UpdateSessInfo(Session("SI"))
	curSID = Session("SI")
Else
    '------------------------------
	'Get Session ID
	'------------------------------
    SID = Request.QueryString("SID")
    Session("SI") = SID	
End If

If (Session("SI") = "") Then	
 Response.Redirect "../index.htm"
End If

Dim sMenu

'If (curSID > 0) Then
	'sMenu = GetMenu(GetUserInfoItem(curSID, "ProfileID"))
'Else
	'sMenu = GetMenu(0)
'End If

%>
