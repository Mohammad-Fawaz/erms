<!-- #INCLUDE FILE="incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="incl_ado.asp" -->
<!-- #INCLUDE FILE="incl_sessinfo.asp" -->
<!-- #INCLUDE FILE="incl_menu.asp" -->

<%

Dim curSID , aUsr

SID = Request.QueryString("SID")
If SID <> "" Then    
 Session("SI") = SID
 aUsr = GetUserInfo(SID)    
End If

If (Session("SI") = "") Then	
 Response.Redirect "../index.htm"
End If

'--------------------------------------
'Get User Details
'--------------------------------------	
If IsArray(aUsr) Then
	curEID = aUsr(1)
	curUN = aUsr(2)
	curSG = aUsr(3)	
Else
	curEID = 0
	curUN = "USER"
	curSG = 7
End If

'Response.Write "SID: " & SID & " <br>"
'Response.Write "User Name: " & curUN & " <br>"
'Response.Write "User ID: " & curEID & " <br>"
'Response.Write "SG : " & curSG
	
'--------------------------------------
'MENU
'--------------------------------------	
Dim sMenu
If (curSID <> "") Then
	'sMenu = GetMenu(GetUserInfoItem(curSID, "ProfileID"))
Else
	'sMenu = GetMenu(0)
End If

%>
