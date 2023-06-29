<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="script/incl_ado.asp" -->
<!-- #INCLUDE FILE="script/incl_sessinfo.asp" -->
<!-- #INCLUDE FILE="script/incl_sessdrop.asp" -->

<%

Dim sUID
Dim bLogout

If (Session("SI") <> "") And (Session("SI") > 0) Then
	sUID = GetUserInfoItem(Session("SI"), "UID")
	bLogout = DumpUserSession(Session("SI"), sUID)
End If
Session.Abandon
Response.Write "<html><head><meta http-equiv='refresh' content='0;URL=../'></head><title>Logging Off...</title><body></body></html>"

%>
