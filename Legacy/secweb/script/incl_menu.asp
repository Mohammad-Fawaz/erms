<!--<%
Function GetMenu(vMenu)
	Dim sMenu
	Dim sDisp
	Dim sDisp1
	
	If (Session("SI") = "") Then
		vMenu = 0
	End If
	
	Select Case vMenu
		Case 0: sDisp = "000000000000000000000"
		'Micropac
		Case 1, 3: sDisp = "1111111111111111111111111"		'Admin
		Case 8, 9: sDisp = "00000101111111100100110000"		'Management
		Case 5: sDisp = "10100101111111110100110000"		'Document Control
		Case 10: sDisp = "00000101111111100100110000"		'Change Control
		Case Else: sDisp = "00000101111110000100110000"		'Default
		'Micropac
		'Case 1, 3: sDisp = "1010010110111000010110000"		'Admin
		'Case 8: sDisp = "0000010110111101010110000"		'Management
		'Case 5: sDisp = "1010010110111000010110000"		'Document Control
		'Case 9, 10: sDisp = "0000010110111000010110000"		'Change Control
		'Case Else: sDisp = "0000010110111000010110000"		'Default
	End Select
	'sDisp = "0-0000|0-0000|0-00|0-0000|0-000|0-000"
	'sDisp = "1-0100|1-0110|1-11|0-0001|1-011|0-000"	'Admin
	'sDisp = "0-0000|1-0110|1-11|1-0100|1-011|0-000"	'Management
	'sDisp = "1-0100|1-0110|1-11|0-0000|1-011|0-000"	'Document Control
	'sDisp = "0-0000|1-0110|1-11|0-0000|1-011|0-000"	'Change Control
	'sDisp = "0-0000|1-0110|1-11|0-0000|1-011|0-000"	'Default
	
	'sDisp = "0 0000"				REQUESTS | Document | Change | Quality Action | Print Request
	'sDisp = "1 0111"			INFO/VIEW | File Cabinet | Quick Search | Advanced Search | Elements/Wafers
	'sDisp = "1 11"					ACTIONS | To Do Listings | Update Password
	'sDisp = "1 1000"					REPORTS | BOM Report | Custom Reports | View Error Logs | Change Impact (Analysis)
	'sDisp = "1 011"				HELP | Help Files | Support Links | Contact Info
	'sDisp = "1 111"				ADMINISTRATION | Tools Index | Workflow Actions | Workflow Templates
	
	sMenu = "<table border='0' cellpadding='2' cellspacing='0' width='100%'>"
	'sDisp = "0 0000"				REQUESTS | Document | Change | Quality Action | Print Request
	If (Mid(sDisp, 1, 1) = "1") Then
		sDisp1 = Mid(sDisp, 2, 4)
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>REQUESTS</font></strong></td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%'>"
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='req_doc.asp'><font face='Verdana' size='2'>Document</font></a>" & IIf(InStr(2, sDisp1, "1", 1) > 0, "<br>", "")
	'	commented out below to try to remove customers and quality action from request tree view
		If (Mid(sDisp1, 2, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='req_change.asp'><font face='Verdana' size='2'>Change</font></a>" & IIf(InStr(3, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 3, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='req_qualac.asp'><font face='Verdana' size='2'>Quality Action$$$$$$$</font></a>" & IIf(Right(sDisp1, 1) = "1", "<br>", "")
		If (Mid(sDisp1, 4, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='req_print.asp'><font face='Verdana' size='2'>Print Request</font></a>"
		sMenu = sMenu & vbCrLf & "    </td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
	End If
	'sDisp = "1 0111"			INFO/VIEW | File Cabinet | Quick Search | Advanced Search | Elements/Wafers
	If (Mid(sDisp, 6, 1) = "1") Then
		sDisp1 = Mid(sDisp, 7, 4)
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>INFO/VIEW</font></strong></td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%'>"
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='view_fcab.asp'><font face='Verdana' size='2'>File Cabinet</font></a>" & IIf(InStr(2, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 2, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='view_qsearch.asp'><font face='Verdana' size='2'>Quick Search</font></a>" & IIf(InStr(3, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 3, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='view_syssearch.asp'><font face='Verdana' size='2'>System Search</font></a>" & IIf(Right(sDisp1, 1) = "1", "<br>", "")
		If (Mid(sDisp1, 4, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='view_element_wafer.asp'><font face='Verdana' size='2'>Elements/Wafers</font></a>"
		sMenu = sMenu & vbCrLf & "    </td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
	End If
	'sDisp = "1 11"					ACTIONS | To Do Listings | Update Password
	If (Mid(sDisp, 11, 1) = "1") Then
		sDisp1 = Mid(sDisp, 12, 2)
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>ACTIONS</font></strong></td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%'>"
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='act_todo.asp'><font face='Verdana' size='2'>To Do Listings</font></a>" & IIf(Right(sDisp1, 1) = "1", "<br>", "")
		If (Mid(sDisp1, 2, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='upd_pw.asp'><font face='Verdana' size='2'>Update Password</font></a>"
		sMenu = sMenu & vbCrLf & "    </td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
	End If
	'sDisp = "1 100"					REPORTS | BOM Report | Custom Reports | View Error Logs | Change Impact (Analysis)
	If (Mid(sDisp, 14, 1) = "1") Then
		sDisp1 = Mid(sDisp, 15, 4)
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>REPORTS</font></strong></td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%'>"
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='glov_bom.asp'><font face='Verdana' size='2'>BOM Report</font></a>" & IIf(InStr(2, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 2, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='view_reports.asp'><font face='Verdana' size='2'>Custom Reports</font></a>" & IIf(InStr(3, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 3, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='view_errlogs.asp'><font face='Verdana' size='2'>View Error Logs</font></a>" & IIf(Right(sDisp1, 1) = "1", "<br>", "")
		If (Mid(sDisp1, 4, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='view_impact.asp'><font face='Verdana' size='2'>Change Impact</font></a>"
		sMenu = sMenu & vbCrLf & "    </td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
	End If
	'sDisp = "1 011"				HELP | Help Files | Support Links | Contact Info
	If (Mid(sDisp, 19, 1) = "1") Then
		sDisp1 = Mid(sDisp, 20, 3)
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>HELP</font></strong></td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%'>"
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='supp_docs.asp'><font face='Verdana' size='2'>Help Files</font></a>" & IIf(InStr(2, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 2, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='supp_links.asp'><font face='Verdana' size='2'>Support Links</font></a>" & IIf(Right(sDisp1, 1) = "1", "<br>", "")
		If (Mid(sDisp1, 3, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='supp_contact.asp'><font face='Verdana' size='2'>Contact Info</font></a>"
		sMenu = sMenu & vbCrLf & "    </td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
	End If
	'sDisp = "1 111"				ADMINISTRATION | Tools Index | Workflow Actions | Workflow Templates
	If (Mid(sDisp, 23, 1) = "1") Then
		sDisp1 = Mid(sDisp, 24, 3)
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>ADMINISTRATION</font></strong></td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
		sMenu = sMenu & vbCrLf & "  <tr>"
		sMenu = sMenu & vbCrLf & "    <td width='100%'>"
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='wf_tools.asp'><font face='Verdana' size='2'>Workflow</font></a>" & IIf(InStr(1, sDisp1, "1", 1) > 0, "<br>", "")
		'If (Mid(sDisp1, 2, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='wf_add_act.asp'><font face='Verdana' size='2'>Workflow Actions</font></a>" & IIf(Right(sDisp1, 1) = "1", "<br>", "")
		'If (Mid(sDisp1, 3, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='wf_add_temp.asp'><font face='Verdana' size='2'>Workflow Templates</font></a>"
		
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='bom_createh1.asp'><font face='Verdana' size='2'>Create New BOM</font></a>" & IIf(InStr(2, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 1, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='bom_mod.asp'><font face='Verdana' size='2'>Modify BOM</font></a>" & IIf(InStr(2, sDisp1, "1", 1) > 0, "<br>", "")
		If (Mid(sDisp1, 2, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='bom_copy.asp'><font face='Verdana' size='2'>Copy New BOM</font></a>" & IIf(Right(sDisp1, 1) = "1", "<br>", "")
		If (Mid(sDisp1, 3, 1) = "1") Then sMenu = sMenu & vbCrLf & "    <a href='bom_rpts.asp'><font face='Verdana' size='2'>BOM Reports</font></a>"
		
		sMenu = sMenu & vbCrLf & "    </td>"
		sMenu = sMenu & vbCrLf & "  </tr>"
	End If
	'Display always
	sMenu = sMenu & vbCrLf & "  <tr>"
	sMenu = sMenu & vbCrLf & "    <td width='100%'><strong>"
	sMenu = sMenu & vbCrLf & "    <a href='e_logout.asp'><font face='Verdana' size='2'>LOGOUT</font></a></strong>"
	sMenu = sMenu & vbCrLf & "    </td>"
	sMenu = sMenu & vbCrLf & "  </tr>"
	sMenu = sMenu & vbCrLf & "</table>"
	
	GetMenu = sMenu
End Function

%>
-->
