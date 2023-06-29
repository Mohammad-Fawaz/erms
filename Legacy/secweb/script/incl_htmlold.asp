<%

Function GetHTML(vTag, vItem, sItemVal, bOpt)
    Dim sHTML
    
    Select Case vTag
        '*************************************
        '       Page Content
        '*************************************
        Case "SuppLinks", "SuppCont", "SuppDocs"
            sHTML = GetHTMLBody(vTag)
        '*************************************
        '       Selected Item Information
        '*************************************
        Case "SelItem"
            sHTML = GetSelItemInfo(vItem, sItemVal, bOpt)
        Case "Search"
            sHTML = GetListing(vItem, sItemVal, "1")
        Case Else
            sHTML = "<font face='Verdana' size='2'><p>No information was retruned. An error may have occurred.</p></font>"
    End Select
    
    GetHTML = sHTML
End Function

Function GetHTMLBody(vTag)
    Dim sBody
    
    Select Case vTag
        Case "SuppCont", "SuppLinks"
            sBody = "    <hr noshade color='#808000'>" 
			sBody = sBody & "    <p align='center'><font face='Verdana' size='6'><strong>ERMS</strong><em>Web</em></font><font face='Verdana' size='2'><br>" 
			sBody = sBody & "    <strong>Engineering Resource Management System - Version 4.2<br>" 
			sBody = sBody & "    </strong></font><font face='Verdana' size='1'>©2000-2004, Desktop Devices. All Rights Reserved.</font></p>" 
			sBody = sBody & "    <div align='center'><center><table border='2' cellpadding='4' width='480'>" 
			sBody = sBody & "      <tr>" 
			sBody = sBody & "        <td valign='top' align='right'><strong><font face='Verdana' size='2'>Desktop Devices</font></strong></td>" 
			sBody = sBody & "        <td valign='top'><font face='Verdana' size='2'><strong><a href='http://www.desktopdev.com'>www.desktopdev.com</a></strong></font></td>" 
			sBody = sBody & "      </tr>" 
			sBody = sBody & "      <tr>" 
			sBody = sBody & "        <td valign='top' align='right'><strong><font face='Verdana' size='2'>Customer Care</font></strong></td>" 
			sBody = sBody & "        <td valign='top'><font face='Verdana' size='2'><strong><a href='mailto:casharpiii@aol.com'>Chuck Sharp</a></strong> • 214-289-7443</font></td>" 
			sBody = sBody & "      </tr>" 
			sBody = sBody & "      <tr>" 
			sBody = sBody & "        <td valign='top' align='right'><strong><font face='Verdana' size='2'>Technical Development</font></strong></td>" 
			sBody = sBody & "        <td valign='top'><font face='Verdana' size='2'><strong><a href='mailto:chrisdv@airmail.net'>Chris Vencevich</a></strong> • 972-418-8854</font></td>" 
			sBody = sBody & "      </tr>" 
			sBody = sBody & "    </table>" 
			sBody = sBody & "    </center></div>"
        Case "SuppDocs"
            sBody = ""
    End Select
    
    GetHTMLBody = sBody
End Function

Function GetMenu(vMenu)
	Dim sMenu
	
	If (SVars = "") Then
		If (Request.QueryString <> "") Then
			SVars = "SI=" & Request.QueryString("SI") & "&M=" & Request.QueryString("M")
		End If
	End If
	
	Select Case vMenu
		Case 2		'Management
			sMenu = "<table border='0' cellpadding='2' cellspacing='0' width='100%'>" & vbCrLf
			'sMenu = sMenu & "  <tr>" & vbCrLf
			'sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>REQUESTS</font></strong></td>" & vbCrLf
			'sMenu = sMenu & "  </tr>" & vbCrLf
			'sMenu = sMenu & "  <tr>" & vbCrLf
			'sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_doc.asp?" & SVars & "'><font face='Verdana' size='2'>Document</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_change.asp?" & SVars & "'><font face='Verdana' size='2'>Change</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_qualac.asp?" & SVars & "'><font face='Verdana' size='2'>Quality Action</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_print.asp?" & SVars & "'><font face='Verdana' size='2'>Print Request</font></a>" & vbCrLf
			'sMenu = sMenu & "    </td>" & vbCrLf
			'sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>INFO/VIEW</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			'sMenu = sMenu & "    <a href='view_fcab.asp?" & SVars & "'><font face='Verdana' size='2'>File Cabinet</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='view_qsearch.asp?" & SVars & "'><font face='Verdana' size='2'>Quick Search</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='view_syssearch.asp?" & SVars & "'><font face='Verdana' size='2'>System Search</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>ACTIONS</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			sMenu = sMenu & "    <a href='act_todo.asp?" & SVars & "'><font face='Verdana' size='2'>To Do Listings</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>HELP</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_docs.asp?" & SVars & "'><font face='Verdana' size='2'>Help Files</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_links.asp?" & SVars & "'><font face='Verdana' size='2'>Support Links</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_contact.asp?" & SVars & "'><font face='Verdana' size='2'>Contact Info</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'><strong>" & vbCrLf
			sMenu = sMenu & "    <a href='e_logout.asp?" & SVars & "'><font face='Verdana' size='2'>LOGOUT</font></a></strong>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "</table>"
		Case 3		'Admins
			sMenu = "<table border='0' cellpadding='2' cellspacing='0' width='100%'>" & vbCrLf
			'sMenu = sMenu & "  <tr>" & vbCrLf
			'sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>REQUESTS</font></strong></td>" & vbCrLf
			'sMenu = sMenu & "  </tr>" & vbCrLf
			'sMenu = sMenu & "  <tr>" & vbCrLf
			'sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_doc.asp?" & SVars & "'><font face='Verdana' size='2'>Document</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_change.asp?" & SVars & "'><font face='Verdana' size='2'>Change</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_qualac.asp?" & SVars & "'><font face='Verdana' size='2'>Quality Action</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_print.asp?" & SVars & "'><font face='Verdana' size='2'>Print Request</font></a>" & vbCrLf
			'sMenu = sMenu & "    </td>" & vbCrLf
			'sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>INFO/VIEW</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			'sMenu = sMenu & "    <a href='view_errlogs.asp?" & SVars & "'><font face='Verdana' size='2'>View Error Logs</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='view_fcab.asp?" & SVars & "'><font face='Verdana' size='2'>File Cabinet</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='view_qsearch.asp?" & SVars & "'><font face='Verdana' size='2'>Quick Search</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='view_syssearch.asp?" & SVars & "'><font face='Verdana' size='2'>System Search</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>ACTIONS</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			sMenu = sMenu & "    <a href='act_todo.asp?" & SVars & "'><font face='Verdana' size='2'>To Do Listings</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>HELP</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_docs.asp?" & SVars & "'><font face='Verdana' size='2'>Help Files</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_links.asp?" & SVars & "'><font face='Verdana' size='2'>Support Links</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_contact.asp?" & SVars & "'><font face='Verdana' size='2'>Contact Info</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'><strong>" & vbCrLf
			sMenu = sMenu & "    <a href='e_logout.asp?" & SVars & "'><font face='Verdana' size='2'>LOGOUT</font></a></strong>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "</table>"
		Case Else		'Default
			sMenu = "<table border='0' cellpadding='2' cellspacing='0' width='100%'>" & vbCrLf
			'sMenu = sMenu & "  <tr>" & vbCrLf
			'sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>REQUESTS</font></strong></td>" & vbCrLf
			'sMenu = sMenu & "  </tr>" & vbCrLf
			'sMenu = sMenu & "  <tr>" & vbCrLf
			'sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_doc.asp?" & SVars & "'><font face='Verdana' size='2'>Document</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_change.asp?" & SVars & "'><font face='Verdana' size='2'>Change</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_qualac.asp?" & SVars & "'><font face='Verdana' size='2'>Quality Action</font></a><br>" & vbCrLf
			'sMenu = sMenu & "    <a href='req_print.asp?" & SVars & "'><font face='Verdana' size='2'>Print Request</font></a>" & vbCrLf
			'sMenu = sMenu & "    </td>" & vbCrLf
			'sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>INFO/VIEW</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			'sMenu = sMenu & "    <a href='view_fcab.asp?" & SVars & "'><font face='Verdana' size='2'>File Cabinet</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='view_qsearch.asp?" & SVars & "'><font face='Verdana' size='2'>Quick Search</font></a>" & vbCrLf
			'sMenu = sMenu & "    <a href='view_syssearch.asp?" & SVars & "'><font face='Verdana' size='2'>System Search</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>ACTIONS</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			sMenu = sMenu & "    <a href='act_todo.asp?" & SVars & "'><font face='Verdana' size='2'>To Do Listings</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%' bgcolor='#808000'><strong><font color='#FFFF00' face='Verdana' size='2'>HELP</font></strong></td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_docs.asp?" & SVars & "'><font face='Verdana' size='2'>Help Files</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_links.asp?" & SVars & "'><font face='Verdana' size='2'>Support Links</font></a><br>" & vbCrLf
			sMenu = sMenu & "    <a href='supp_contact.asp?" & SVars & "'><font face='Verdana' size='2'>Contact Info</font></a>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "  <tr>" & vbCrLf
			sMenu = sMenu & "    <td width='100%'><strong>" & vbCrLf
			sMenu = sMenu & "    <a href='e_logout.asp?" & SVars & "'><font face='Verdana' size='2'>LOGOUT</font></a></strong>" & vbCrLf
			sMenu = sMenu & "    </td>" & vbCrLf
			sMenu = sMenu & "  </tr>" & vbCrLf
			sMenu = sMenu & "</table>"
	End Select
	
	GetMenu = sMenu
End Function

Function GetSelItemInfo(vItem, sItemVal, bOpt)
    Dim sItem
    Dim sList
    Dim sLink
    Dim rsItem
    Dim rsItemDetail
    Dim sSQL
    
    Dim curID
    Dim val1, val2, val3, val4, val5, val6, val7, val8, val9, val10
    Dim val11, val12, val13, val14, val15, val16, val17, val18, val19, val20
    
    Select Case vItem
        Case "Doc"
            Set rsItem = GetADORecordset("SELECT * FROM ViewDocs WHERE DocID = '" & sItemVal & "'", Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("DocID")) Then
					sItem = "<div><table border='0' width='660' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Doc ID:</strong> " & IIf(IsNull(rsItem("DocID")), "-", rsItem("DocID")) & "</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Current Rev:</strong> " & IIf(IsNull(rsItem("CurrentRev")), "NONE", rsItem("CurrentRev")) & "</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Discipline:</strong> " & IIf(IsNull(rsItem("Disc")), "-", rsItem("Disc")) & "</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					'sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Security Class:</strong> " & IIf(IsNull(rsItem("DClass")), "-", rsItem("DClass")) & "</font></td>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Tabulated:</strong> " & IIf(rsItem("Tabulated") = 0, "NO", "YES") & "</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Document Type:</strong> " & IIf(IsNull(rsItem("DType")), "-", rsItem("DType")) & "</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Description:</strong> " & IIf(IsNull(rsItem("DocDesc")), "-", rsItem("DocDesc")) & "</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					'sItem = sItem & vbCrLf & "      <tr>"
					'sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Notes:</strong> " & IIf(IsNull(rsItem("DocNotes")), "-", rsItem("DocNotes")) & "</font></td>"
					'sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='4'><font face='Verdana' size='1'><strong><u>ASSOCIATED FILES</u></strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File ID</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File Name</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Size</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Location</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					Set rsItemDetail = GetADORecordset("SELECT * FROM ViewDocFiles WHERE DocID = '" & sItemVal & "'", Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						
						Do
						    If Not IsNull(rsItemDetail("FileID")) Then
								If IsNull(rsItemDetail("FileLink")) Then
								    If IsNull(rsItemDetail("FileLocation")) Then
								        sLink = ""
								    Else
								        sLink = rsItemDetail("FileLocation")
								        sLink = Replace(sLink, "\", "/", 1, -1, vbTextCompare)
								        sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
								    End If
								Else
								    sLink = "<a href='" & rsItemDetail("FileLink") & "' target = '_blank'>"
								End If
								If (rsItemDetail("PLoc") = "LAN") Then
									val1 = ""
								Else
									val1 = "<a href='q_printreq.asp?" & sVars & "&FID=" & rsItemDetail("FileID") & "'>"
								End If
								
								sItem = sItem & vbCrLf & "      <tr>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & sLink & rsItemDetail("FileID") & IIf(sLink <> "", "</a>", "") & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("FileName")), "-", rsItemDetail("FileName")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("PrintSize")), "-", rsItemDetail("PrintSize")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & val1 & IIf(IsNull(rsItemDetail("PrintLoc")), "-", rsItemDetail("PrintLoc")) & IIf(val1 <> "", "</a>", "")  & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "      </tr>"
						    End If
						    rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						
						rsItemDetail.Close
					End If
					
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td><table border='0' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%' colspan='3'><font face='Verdana' size='1'><strong><u>DOCUMENT RELEASE PROCESS DETAIL</u></strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='25%'><strong><font face='Verdana' size='1'>Action</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='20%'><strong><font face='Verdana' size='1'>Date</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='55%'><strong><font face='Verdana' size='1'>Processed by</font></strong></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Requested:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReqDate")), "-", rsItem("DocReqDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReqBy")), "-", rsItem("DocReqBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Created:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocCreatedDate")), "-", rsItem("DocCreatedDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocCreatedBy")), "-", rsItem("DocCreatedBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Reviewed:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReviewDate")), "-", rsItem("DocReviewDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReviewBy")), "-", rsItem("DocReviewBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Released:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocRelDate")), "-", rsItem("DocRelDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocRelRef")), "-", rsItem("DocRelRef")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Obsolete:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocObsDate")), "-", rsItem("DocObsDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocObsRef")), "-", rsItem("DocObsRef")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Last Modified:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModDate")), "-", rsItem("LastModDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModBy")), "-", rsItem("LastModBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
					
					If (bOpt = False) Then
						sLink = "<a href='ret_selitem.asp?Listing=" & vItem & "&Item=" & sItemVal & "&Opt=True'>DISPLAY DOCUMENT HISTORY</a>"
						sItem = sItem & vbCrLf & "      <tr>"
						sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
						sItem = sItem & vbCrLf & "      </tr>"
						Set rsItemDetail = Nothing
					Else
						'sLink = "<font face='Verdana' size='2'><strong><a href='ret_selitem.asp?Listing=" & vItem & "&Item=" & sItemVal & "&Opt=False'>HIDE DOCUMENT HISTORY</a></strong></font><br>"
						sLink = ""
						sItem = sItem & vbCrLf & "      <tr>"
						sItem = sItem & vbCrLf & "        <td width='100%' colspan='5'>" & sLink & "<font face='Verdana' size='1'><strong><u>DOCUMENT HISTORY</u></strong></font></td>"
						sItem = sItem & vbCrLf & "      </tr>"
						sItem = sItem & vbCrLf & "      <tr>"
						sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Rev</font></strong></td>"
						sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Chg Num</font></strong></td>"
						sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Eff Date</font></strong></td>"
						sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Chg Status</font></strong></td>"
						sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Chg Type</font></strong></td>"
						sItem = sItem & vbCrLf & "      </tr>"
					
						sSQL = "SELECT DocID, CO, RevFrom, RevTo, ChStatus, Status, ChangeType, ChType, ChEffDate "
						sSQL = sSQL & "FROM ViewDocHistory WHERE (DocID = '" & sItemVal & "') ORDER BY CO DESC"
						Set rsItemDetail = GetADORecordset(sSQL, Nothing)
					
						If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
							rsItemDetail.MoveFirst
							
							Do
							    If Not IsNull(rsItemDetail("CO")) Then
									sItem = sItem & vbCrLf & "          <tr>" 
									sItem = sItem & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("RevTo")), "NONE", rsItemDetail("RevTo")) & "&nbsp;</font></td>" 
									sItem = sItem & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?" & sVars & "&Listing=Change&Item=" & rsItemDetail("CO") & "'>" & rsItemDetail("CO") & "</a>&nbsp;</font></td>" 
									sItem = sItem & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ChEffDate")), "-", rsItemDetail("ChEffDate")) & "&nbsp;</font></td>" 
									sItem = sItem & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(isNull(rsItemDetail("Status")), "-", rsItemDetail("Status")) & "&nbsp;</font></td>" 
									sItem = sItem & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ChType")), "-", rsItemDetail("ChType")) & "&nbsp;</font></td>" 
									sItem = sItem & vbCrLf & "          </tr>"
							    End If
							    rsItemDetail.MoveNext
							Loop Until rsItemDetail.EOF
							
							rsItemDetail.Close
							Set rsItemDetail = Nothing
						End If
					End If
					
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "</table></div>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case "Change"
            Set rsItem = GetADORecordset("SELECT * FROM ViewChanges WHERE CO = " & sItemVal, Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("CO")) Then
					curID = sItemVal
					val1 = IIf(IsNull(rsItem("ChDue")), "-", rsItem("ChDue"))
					val2 = IIf(IsNull(rsItem("Status")), "-", rsItem("Status"))
					val3 = IIf(IsNull(rsItem("Priority")), "-", rsItem("Priority"))
					val4 = IIf(IsNull(rsItem("Justification")), "-", rsItem("Justification"))
					val5 = IIf(IsNull(rsItem("ChEffDate")), "-", rsItem("ChEffDate"))
					val6 = IIf(IsNull(rsItem("ProjNum")), "-", "<a href='ret_selitem.asp?" & sVars & "&Listing=Project&Item=" & rsItem("ProjNum") & "'>" & rsItem("ProjNum") & IIf(IsNull(rsItem("ProjName")), "", " - " & rsItem("ProjName")) & "</a>")
					val7 = IIf(IsNull(rsItem("ChType")), "-", rsItem("ChType"))
					val8 = IIf(IsNull(rsItem("ChangeDesc")), "-", rsItem("ChangeDesc"))
					'val9 = IIf(IsNull(rsItem("AddNotes")), "-", rsItem("AddNotes"))
					
					sItem = "<div><table border='1' width='660' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Change Order Num:</strong> " & curID & "</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Date Due:</strong> " & val1 & "</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & val2 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Priority:</strong> " & val3 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Eff Date:</strong> " & val5 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Justification:</strong> " & val4 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Project:</strong> " & val6 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Change Type:</strong> " & val7 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Description:</strong> " & val8 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					'sItem = sItem & vbCrLf & "      <tr>"
					'sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Notes:</strong> " & val9 & "&nbsp;</font></td>"
					'sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='1'><strong><u>CHANGE ORDER PROCESS DETAIL</u></strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='25%'><strong><font face='Verdana' size='1'>Action</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='20%'><strong><font face='Verdana' size='1'>Date</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='55%'><strong><font face='Verdana' size='1'>Processed by</font></strong></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Requested:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReqDate")), "-", rsItem("ChReqDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReqBy")), "-", rsItem("ChReqBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Approved:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChApprDate")), "-", rsItem("ChApprDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChApprBy")), "-", rsItem("ChApprBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Assigned:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChAssignDate")), "-", rsItem("ChAssignDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChAssignTo")), "-", rsItem("ChAssignTo")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Completed:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChCompletedDate")), "-", rsItem("ChCompletedDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChCompletedBy")), "-", rsItem("ChCompletedBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Released:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReleasedDate")), "-", rsItem("ChReleasedDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReleasedBy")), "-", rsItem("ChReleasedBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Last Modified:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModDate")), "-", rsItem("LastModDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModBy")), "-", rsItem("LastModBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='6'><font face='Verdana' size='1'><u><strong>ASSOCIATED DOCUMENTS</strong></u></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2' align='center' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Revision</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td colspan='4'><font face='Verdana' size='1'>&nbsp; </font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Old</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>New</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Doc ID</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Doc Type</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					sSQL = "SELECT CO, DocID, RevFrom, RevTo, CurrentRev, DocStatus, Status, DocType, DType, DocDesc "
					sSQL = sSQL & "FROM ViewAssocDocs WHERE (CO = " & sItemVal & ") ORDER BY DocID"
					Set rsItemDetail = GetADORecordset(sSQL, Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						Do
							sItem = sItem & vbCrLf & "      <tr>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("RevFrom")), "NONE", rsItemDetail("RevFrom")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("RevTo")), "NONE", rsItemDetail("RevTo")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("DocID")), "-", "<a href='ret_selitem.asp?" & sVars & "&Listing=Doc&Item=" & rsItemDetail("DocID") & "'>" & rsItemDetail("DocID") & "</a>") & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("Status")), "-", rsItemDetail("Status")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("DocDesc")), "-", rsItemDetail("DocDesc")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("DType")), "-", rsItemDetail("DType")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "      </tr>"
						    rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						rsItemDetail.Close
					End If
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='6'><font face='Verdana' size='1'><u><strong>FILE ATTACHMENTS</strong></u></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File Name</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Size</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Location</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					sSQL = "SELECT AttFName, AttFDesc, AttFLoc, AttFLink, PrintSize, PrintLoc FROM ViewAttach "
					sSQL = sSQL & "WHERE (WebView <> 0) AND ((RefType = 'COA') AND (RefID = '" & sItemVal & "')) ORDER BY AttFName"
					Set rsItemDetail = GetADORecordset(sSQL, Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						Do
							If IsNull(rsItemDetail("AttFLink")) Then
								If IsNull(rsItemDetail("AttFLoc")) Then
									sLink = ""
								Else
									sLink = rsItemDetail("AttFLoc")
									sLink = Replace(sLink, "\", "/", 1, -1, vbTextCompare)
									sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
								End If
							Else
								sLink = "<a href='" & rsItemDetail("AttFLink") & "' target = '_blank'>"
							End If
							sItem = sItem & vbCrLf & "      <tr>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & sLink & rsItemDetail("AttFName") & IIf(sLink <> "", "</a>", "") & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("AttFDesc")), "-", rsItemDetail("AttFDesc")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("PrintSize")), "-", rsItemDetail("PrintSize")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("PrintLoc")), "-", rsItemDetail("PrintLoc")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "      </tr>"
						    rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						rsItemDetail.Close
					End If
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='7'><u><strong><font face='Verdana' size='1'>MATERIAL DISPOSITION</font></strong></u></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Order/Date/Batch</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Type</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Impact Area</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Assigned To</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Due</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Eff</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					sSQL = "SELECT OrderDateBatch, Status, DispType, ImpAreaDesc, ULNF, DateDue, DispEffDate "
					sSQL = sSQL & "FROM ViewMatDisp WHERE (CO = " & sItemVal & ") ORDER BY DateDue"
					Set rsItemDetail = GetADORecordset(sSQL, Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						Do
							sItem = sItem & vbCrLf & "      <tr>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("OrderDateBatch")), "-", rsItemDetail("OrderDateBatch")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("Status")), "-", rsItemDetail("Status")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("DispType")), "-", rsItemDetail("DispType")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ImpAreaDesc")), "-", rsItemDetail("ImpAreaDesc")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ULNF")), "-", rsItemDetail("ULNF")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("DateDue")), "-", rsItemDetail("DateDue")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("DispEffDate")), "-", rsItemDetail("DispEffDate")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "      </tr>"
						    rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						rsItemDetail.Close
						Set rsItemDetail = Nothing
					End If
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "</table></div>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case "Order"
            Set rsItem = GetADORecordset("SELECT * FROM ViewOrders WHERE OrderID = " & sItemVal, Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("OrderID")) Then
					val1 = IIf(IsNull(rsItem("Parent")), "", rsItem("Parent"))
					If (val1 <> "") Then
						val2 = GetDataValue("SELECT OrderID AS RetVal FROM OrderXRef WHERE (OrderNum = '" & rsItem("Parent") & "')", Nothing)
						val1 = "<a href='ret_selitem.asp?" & sVars & "&Listing=Order&Item=" & val2 & "'>" & rsItem("Parent") & "</a>"
					Else
						val1 = "-"
					End If
					sItem = "<div><table border='1' width='660' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Order Num:</strong> " & IIf(IsNull(rsItem("OrderNum")), "-", rsItem("OrderNum")) & "</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Type:</strong> " & IIf(IsNull(rsItem("OrderType")), "-", rsItem("OrderType")) & "</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("OrderStatus")), "-", rsItem("OrderStatus")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Parent:</strong> " & val1 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Date:</strong> " & IIf(IsNull(rsItem("OrderDate")), "-", rsItem("OrderDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><u><font face='Verdana' size='1'><strong>VENDOR/CUSTOMER</strong></font></u></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					val4 = IIf(IsNull(rsItem("VendCustID")), "", rsItem("VendCustID"))
					If (val4 <> "") Then
						val4 = val4 & IIf(IsNull(rsItem("VCName")), "", " - " & rsItem("VCName"))
					Else
						val4 = "-"
					End If
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'>" & val4 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>Location:</strong> " & IIf(IsNull(rsItem("VCLocation")), "-", rsItem("VCLocation")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					val3 = rsItem("VCContact")
					If (rsItem("VCContEmail") <> "") Then
						val3 = "<a href='mailto:" & rsItem("VCContEmail") & "'>" & IIf(val3 <> "", val3, "-") & "</a>"
					End If
					If (rsItem("VCContPhone") <> "") Then
						val3 = IIf(val3 <> "", val3 & " - ", "") & rsItem("VCContPhone")
					End If
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>Contact:</strong> " & val3 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%' colspan='3'><strong><u><font face='Verdana' size='1'>ORDER SCHEDULE</font></u></strong></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='30%'><font face='Verdana' size='1'>&nbsp; </font></td>"
					sItem = sItem & vbCrLf & "        <td width='35%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Planned</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='35%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Actual</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><strong><font face='Verdana' size='2'>Start Date:</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedStartDate")), "-", rsItem("PlannedStartDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActStartDate")), "-", rsItem("ActStartDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Finish Date:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedEndDate")), "-", rsItem("PlannedEndDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActEndDate")), "-", rsItem("ActEndDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Ship Date:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedShipDate")), "-", rsItem("PlannedShipDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActShipDate")), "-", rsItem("ActShipDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%' colspan='6'><font face='Verdana' size='1'><strong><u>ORDER LINE DETAIL</u></strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Line</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Part Number</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Unit</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Qty</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Subtotal</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					Set rsItemDetail = GetADORecordset("SELECT * FROM ViewOrderLines WHERE OrderID = " & sItemVal, Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						Do
							If Not IsNull(rsItemDetail("LineItemID")) Then
								val4 = IIf(IsNull(rsItemDetail("PartNo")), "-", rsItemDetail("PartNo"))
								If Not IsNull(rsItemDetail("PartID")) Then
									val4 = "<a href='ret_selitem.asp?" & sVars & "&Listing=Part&Item=" & rsItemDetail("PartID") & "'>" & val4 & "</a>"
								End If
								sItem = sItem & vbCrLf & "      <tr>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ItemLine")), "-", rsItemDetail("ItemLine")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & val4 & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ItemUnit")), "-", rsItemDetail("ItemUnit")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ItemQty")), "0", rsItemDetail("ItemQty")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ItemCost")), "0", rsItemDetail("ItemCost")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("LineCost")), "0", rsItemDetail("LineCost")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "      </tr>"
							End If
							rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						rsItemDetail.Close
						Set rsItemDetail = Nothing
					End If
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "</table></div>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case "Part"
            sSQL = "SELECT PartID, PartNo, PartDesc, DocID, FileID, PartDesc, CurRev, RevType, RType, "
            sSQL = sSQL & "RevStatus, RStatus, EffDate, FAI, FAIDate, ParentPartNo, FStatus, FileName, FileLocation, "
            sSQL = sSQL & "FileLink, PrintSize, PLoc, PrintLoc, AutoGenerate FROM ViewParts WHERE PartID = " & sItemVal
            Set rsItem = GetADORecordset(sSQL, Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("PartNo")) Then
					curID = sItemVal
					val1 = IIf(IsNull(rsItem("PartNo")), "-", rsItem("PartNo"))
					val2 = IIf(IsNull(rsItem("CurRev")), "NONE", rsItem("CurRev"))
					val3 = IIf(IsNull(rsItem("RStatus")), "-", rsItem("RStatus"))
					If IsNull(rsItem("DocID")) Then
						val4 = "-"
					Else
						val4 = "<a href='ret_selitem.asp?" & sVars & "&Listing=Doc&Item=" & rsItem("DocID") & "'>" & rsItem("DocID") & "</a>"
					End If
					val5 = IIf(IsNull(rsItem("FileID")), "-", rsItem("FileID"))
					If IsNull(rsItem("FileLink")) Then
						If IsNull(rsItem("FileLocation")) Then
							sLink = ""
						Else
							sLink = rsItem("FileLocation")
							sLink = Replace(sLink, "\", "/", 1, -1, vbTextCompare)
							sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
						End If
					Else
						sLink = "<a href='" & rsItem("FileLink") & "' target = '_blank'>"
					End If
					If (sLink <> "") Then
						val5 = sLink & val5 & "</a>"
					End If
					val6 = IIf(rsItem("FAI") = 0, "COMPLETED", "REQUESTED")
					val7 = IIf(IsNull(rsItem("FAIDate")), "-", rsItem("FAIDate"))
					val8 = IIf(IsNull(rsItem("EffDate")), "-", rsItem("EffDate"))
					If (rsItem("PLoc") = "LAN") Then
						val9 = ""
					Else
						val9 = "<a href='q_printreq.asp?" & sVars & "&FID=" & rsItem("FileID") & "'>"
					End If
					val10 = IIf(IsNull(rsItem("RType")), "-", rsItem("RType"))
					If (IsNull(rsItem("ParentPartNo"))) Then
						val11 = "-"
					Else
						val11 = "<a href='ret_selitem.asp?" & sVars & "&Listing=Part&Item=" & rsItem("ParentPartNo") & "'>" & rsItem("ParentPartNo") & "</a>"
					End If
					val12 = IIf(IsNull(rsItem("PartDesc")), "-", rsItem("PartDesc"))
					val13 = IIf(IsNull(rsItem("FileName")), "-", rsItem("FileName"))
					val14 = IIf(IsNull(rsItem("PrintSize")), "-", rsItem("PrintSize"))
					
					sItem = "<div><table border='1' width='660' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Part Num:</strong> " & val1 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Current Rev:</strong> " & val2 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Rev Status:</strong> " & val3 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>RevType:</strong> " & val10 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Parent:</strong> " & val11 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>FAI:</strong> " & val6 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>FAI Date:</strong> " & val7 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Eff Date:</strong> " & val8 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Description:</strong> " & val12 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='4'><font face='Verdana' size='1'><strong><u>ASSOCIATED FILE</u></strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='4'><font face='Verdana' size='2'><strong>Doc ID:</strong> " & val4 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File ID</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File Name</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Size</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Location</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & val5 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & val13 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & val114 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & val9 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='6'><u><strong><font face='Verdana' size='1'>CURRENT ORDERS</font></strong></u></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Type</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Order Num</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Status</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Line</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Qty</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Planned Ship</font></strong></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					sSQL = "SELECT OrderID, OrderType, OrderNum, OrderStatus, ItemLine, ItemQty, PartID, "
					sSQL = sSQL & "PlannedShipDate FROM QOrdersChange WHERE (PartID = " & curID & ")"
					Set rsItemDetail = GetADORecordset(sSQL, Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						Do
							If Not IsNull(rsItemDetail("OrderID")) Then
								val15 = "<a href='ret_selitem.asp?" & sVars & "&Listing=Order&Item=" & rsItemDetail("OrderID") & "'>" & IIf(IsNull(rsItemDetail("OrderNum")), "-", rsItemDetail("OrderNum")) & "</a>"
								sItem = sItem & vbCrLf & "      <tr>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("OrderType")), "-", rsItemDetail("OrderType")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & val15 & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("OrderStatus")), "-", rsItemDetail("OrderStatus")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ItemLine")), "-", rsItemDetail("ItemLine")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("ItemQty")), "-", rsItemDetail("ItemQty")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("PlannedShipDate")), "-", rsItemDetail("PlannedShipDate")) & "&nbsp;</font></td>"
								sItem = sItem & vbCrLf & "      </tr>"
							End If
							rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						rsItemDetail.Close
						Set rsItemDetail = Nothing
					End If
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "</table></div>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case "Project"
            Set rsItem = GetADORecordset("SELECT * FROM ViewProjects WHERE ProjNum = '" & sItemVal & "'", Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("ProjNum")) Then
					val1 = IIf(IsNull(rsItem("ProjStatus")), "", rsItem("ProjStatus"))
					If (val1 <> "") Then
						val1 = val1 & " - " & GetDataValue("SELECT OptDesc AS RetVal FROM StdOptions WHERE (OptType = 'ProjStatus') AND (OptCode = '" & rsItem("ProjStatus") & "')", Nothing)
					Else
						val1 = "-"
					End If
					val2 = IIf(IsNull(rsItem("MSProjFile")), "", rsItem("MSProjFile"))
					If (val2 <> "") Then
						sLink = val2
						sLink = Replace(sLink, "\", "/", 1, -1, vbTextCompare)
						sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
					Else
						sLink = ""
						val2 = "-"
					End If
					If (sLink <> "") Then
						val2 = sLink & val2 & "</a>"
					End If
					val3 = IIf(IsNull(rsItem("VendCustID")), "-", rsItem("VendCustID") & IIf(IsNull(rsItem("VCName")), "", " - " & rsItem("VCName")))
					val4 = IIf(IsNull(rsItem("VCContact")), "", rsItem("VCContact"))
					If Not IsNull(rsItem("VCContEmail")) Then
						If (val4 <> "") Then
							val4 = "<a href='mailto:" & rsItem("VCContEmail") & "'>" & val4 & "</a>"
						Else
							val4 = "<a href='mailto:" & rsItem("VCContEmail") & "'>" & rsItem("VCContEmail") & "</a>"
						End If
					End If
					If (val4 <> "") Then
						val4 = val4 & IIf(IsNull(rsItem("VCContPhone")), "", " - " & rsItem("VCContPhone"))
					Else
						val4 = IIf(IsNull(rsItem("VCContPhone")), "-", rsItem("VCContPhone"))
					End If
					
					sItem = "<div><table border='1' width='660' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%' bgcolor='#808000'><font face='Verdana' color='#FFFF00'><strong>Project:</strong> " & IIf(IsNull(rsItem("Project")), "-", rsItem("Project")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & val1 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Project DB:</strong> " & val2 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><u><font face='Verdana' size='1'><strong>VENDOR/CUSTOMER</strong></font></u></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'>" & val3 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>Location:</strong> " & IIf(IsNull(rsItem("VCLocation")), "-", rsItem("VCLocation")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>Contact:</strong> " & val4 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='5'><font face='Verdana' size='1'><u><strong>PROJECT SCHEDULE</strong></u></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='20%'><font face='Verdana' size='1'>&nbsp; </font></td>"
					sItem = sItem & vbCrLf & "        <td width='20%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='20%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='20%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Labor ($)</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='20%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Material ($)</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><strong><font face='Verdana' size='2'>Planned:</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedStart")), "-", rsItem("PlannedStart")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedFinish")), "-", rsItem("PlannedFinish")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("BudgetLabor")), "0", rsItem("BudgetLabor")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("BudgetMaterial")), "0", rsItem("BudgetMaterial")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Actual:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualStart")), "-", rsItem("ActualStart")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualFinish")), "-", rsItem("ActualFinish")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualLabor")), "0", rsItem("ActualLabor")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualMaterial")), "0", rsItem("ActualMaterial")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "</table></div>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case "QAction"
            Dim rType
            Dim rNum
            
            If (InStr(1, sItemVal, ";", vbTextCompare) > 0) Then
                rType = Left(sItemVal, InStr(1, sItemVal, ";", vbTextCompare) - 1)
                rNum = Right(sItemVal, Len(sItemVal) - InStr(1, sItemVal, ";", vbTextCompare))
                Set rsItem = GetADORecordset("SELECT * FROM ViewActions WHERE (RefType = '" & rType & "') AND (RefNum = " & rNum & ")", Nothing)
            Else
                If (IsNumeric(sItemVal)) Then
                    Set rsItem = GetADORecordset("SELECT * FROM ViewActions WHERE (RefNum = " & sItemVal & ")", Nothing)
                Else
                    Set rsItem = GetADORecordset("SELECT * FROM ViewActions WHERE (RefType = '" & sItemVal & "')", Nothing)
                End If
            End If
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				If Not IsNull(rsItem("RefNum")) Then
					val1 = IIf(IsNull(rsItem("ProjNum")), "", "<a href='ret_selitem.asp?Listing=Project&Item=" & rsItem("ProjNum") & "'>")
					If (val1 <> "") Then
						val1 = val1 & IIf(IsNull(rsItem("ProjName")), rsItem("ProjNum") & "</a>", rsItem("ProjNum") & "</a> - " & rsItem("ProjName"))
					Else
						val1 = IIf(IsNull(rsItem("ProjName")), "-", rsItem("ProjName"))
					End If
					sItem = "<div><table border='1' width='660' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Action Num:</strong> " & rsItem("RefNum") & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Ref Type:</strong> " & IIf(IsNull(rsItem("ARefType")), "-", rsItem("ARefType")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Eff Date:</strong> " & IIf(IsNull(rsItem("DateEff")), "-", rsItem("DateEff")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Date Due:</strong> " & IIf(IsNull(rsItem("DateRequired")), "-", rsItem("DateRequired")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Issue Type:</strong> " & IIf(IsNull(rsItem("IssueType")), "-", rsItem("IssueType")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Action Type:</strong> " & IIf(IsNull(rsItem("ActionType")), "-", rsItem("ActionType")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Description:</strong> " & IIf(IsNull(rsItem("IssueDesc")), "-", rsItem("IssueDesc")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					'sItem = sItem & vbCrLf & "      <tr>"
					'sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Notes:</strong> " & IIf(IsNull(rsItem("AddNotes")), "-", rsItem("AddNotes")) & "&nbsp;</font></td>"
					'sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Project:</strong> " & val1 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%' colspan='3'><font face='Verdana' size='1'><strong><u>QUALITY ACTION PROCESS DETAIL</u></strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='25%'><strong><font face='Verdana' size='1'>Action</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='20%'><strong><font face='Verdana' size='1'>Date</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' width='55%'><strong><font face='Verdana' size='1'>Processed by</font></strong></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Requested:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DateRequested")), "-", rsItem("DateRequested")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ReqBy")), "-", rsItem("ReqBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DateAssigned")), "-", rsItem("DateAssigned")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("AssignTo")), "-", rsItem("AssignTo")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Completed:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DateCompleted")), "-", rsItem("DateCompleted")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("CompletedBy")), "-", rsItem("CompletedBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Last Modified:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModDate")), "-", rsItem("LastModDate")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModBy")), "-", rsItem("LastModBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "</table></div>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case "Task"
            Set rsItem = GetADORecordset("SELECT * FROM ViewTasks WHERE TaskID = " & sItemVal, Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("TaskID")) Then
					val1 = IIf(rsItem("ParentTask") > 0, rsItem("ParentTask"), "-")
					If (val1 <> "-") Then
						val1 = "<a href='ret_selitem.asp?Listing=Task&Item=" & val1 & "'>" & val1 & "</a>"
					End If
					val2 = IIf(IsNull(rsItem("RefType")), "", rsItem("RefType"))
					If (val2 <> "") Then
						val2 = val2 & IIf(IsNull(rsItem("RefNum")), "", " - " & rsItem("RefNum"))
					Else
						val2 = IIf(IsNull(rsItem("RefNum")), "-", rsItem("RefNum"))
					End If
					val3 = IIf(IsNull(rsItem("ProjNum")), "", "<a href='ret_selitem.asp?Listing=Project&Item=" & rsItem("ProjNum") & "'>")
					If (val1 <> "") Then
						val3 = val3 & IIf(IsNull(rsItem("ProjName")), rsItem("ProjNum") & "</a>", rsItem("ProjNum") & "</a> - " & rsItem("ProjName"))
					Else
						val3 = IIf(IsNull(rsItem("Project")), "-", rsItem("Project"))
					End If
					
					sItem = "<div><table border='1' width='660' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Task ID:</strong> " & rsItem("TaskID") & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' color='#FFFF00'><strong>Type:</strong> " & IIf(IsNull(rsItem("StdTask")), "-", rsItem("StdTask")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Priority:</strong> " & IIf(IsNull(rsItem("Priority")), "-", rsItem("Priority")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Parent:</strong> " & val1 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Chg Acct:</strong> " & IIf(IsNull(rsItem("ChargeAcct")), "-", rsItem("ChargeAcct")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Reference:</strong> " & val2 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Complete:</strong> " & IIf(IsNull(rsItem("PcntComplete")), "-", rsItem("PcntComplete")) & "&nbsp;%</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Description:</strong> " & IIf(IsNull(rsItem("TaskDesc")), "-", rsItem("TaskDesc")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Project:</strong> " & val3 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='1'><u><strong>TASK ASSIGNMENT DETAIL</strong></u></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='40%' bgcolor='#D7D7D7' nowrap><font face='Verdana' size='1'><strong>Assigned By</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='40%' bgcolor='#D7D7D7' nowrap><font face='Verdana' size='1'><strong>Assigned To</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='20%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Date</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("AssnBy")), "-", rsItem("AssnBy")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ResourceName")), "-", rsItem("ResourceName")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DateAssigned")), "-", rsItem("DateAssigned")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7' colspan='3'><font face='Verdana' size='1'><strong>Assignment</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("TaskDetail")), "-", rsItem("TaskDetail")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='4'><u><strong><font face='Verdana' size='1'>TASK SCHEDULE DETAIL</font></strong></u></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='1'>&nbsp; </font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Planned</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Actual</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Overrun</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><strong><font face='Verdana' size='2'>Start Date:</font></strong></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedStart")), "-", rsItem("PlannedStart")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualStart")), "-", rsItem("ActualStart")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Finish Date:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedFinish")), "-", rsItem("PlannedFinish")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualFinish")), "-", rsItem("ActualFinish")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("OverrunEstFinish")), "-", rsItem("OverrunEstFinish")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Hours:</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("EstHours")), "0", rsItem("EstHours")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualHours")), "0", rsItem("ActualHours")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("OverrunHrs")), "0", rsItem("OverrunHrs")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='6'><font face='Verdana' size='1'><u><strong>FILE ATTACHMENTS</strong></u></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File Name</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Size</strong></font></td>"
					sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Location</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					sSQL = "SELECT AttFName, AttFDesc, AttFLoc, AttFLink, PrintSize, PrintLoc FROM ViewAttach "
					sSQL = sSQL & "WHERE (WebView <> 0) AND ((RefType = 'TA') AND (RefID = '" & sItemVal & "')) ORDER BY AttFName"
					Set rsItemDetail = GetADORecordset(sSQL, Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						Do
							If IsNull(rsItemDetail("AttFLink")) Then
								If IsNull(rsItemDetail("AttFLoc")) Then
									sLink = ""
								Else
									sLink = rsItemDetail("AttFLoc")
									sLink = Replace(sLink, "\", "/", 1, -1, vbTextCompare)
									sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
								End If
							Else
								sLink = "<a href='" & rsItemDetail("AttFLink") & "' target = '_blank'>"
							End If
							sItem = sItem & vbCrLf & "      <tr>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & sLink & rsItemDetail("AttFName") & IIf(sLink <> "", "</a>", "") & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("AttFDesc")), "-", rsItemDetail("AttFDesc")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("PrintSize")), "-", rsItemDetail("PrintSize")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItemDetail("PrintLoc")), "-", rsItemDetail("PrintLoc")) & "&nbsp;</font></td>"
							sItem = sItem & vbCrLf & "      </tr>"
						    rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						rsItemDetail.Close
					End If
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><strong><u><font face='Verdana' size='1'>TASK NOTES</font></u></strong></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					
					Set rsItemDetail = GetADORecordset("SELECT * FROM ViewNotes WHERE (RefType = 'TASK') AND (RefID = '" & sItemVal & "')", Nothing)
					
					If Not ((rsItemDetail.BOF = True) And (rsItemDetail.EOF = True)) Then
						rsItemDetail.MoveFirst
						Do
							If Not IsNull(rsItemDetail("NoteID")) Then
								val3 = IIf(IsNull(rsItemDetail("NoteSubj")), "-", rsItemDetail("NoteSubj"))
								val4 = IIf(IsNull(rsItemDetail("NType")), "-", rsItemDetail("NType"))
								val5 = IIf(IsNull(rsItemDetail("ULNF")), "-", rsItemDetail("ULNF"))
								val6 = IIf(IsNull(rsItemDetail("NoteDT")), "-", rsItemDetail("NoteDT"))
								val7 = IIf(IsNull(rsItemDetail("NoteTxt")), "-", rsItemDetail("NoteTxt"))
								If (val8 <> "") Then
									val8 = val8 & vbCrLf & "<p><font face='Verdana' size='2'>*** " & val5 & " - " & val6 & " ***<br>" & vbCrLf
									val8 = val8 & "&lt; <b>Note Type:</b> " & val4 & " <b>Subject:</b> " & val3 & " &gt;<br>" & vbCrLf
									val8 = val8 & val7 & "</font>"
								Else
									val8 = "<font face='Verdana' size='2'>*** " & val5 & " - " & val6 & " ***<br>" & vbCrLf
									val8 = val8 & "&lt; <b>Note Type:</b> " & val4 & " <b>Subject:</b> " & val3 & " &gt;<br>" & vbCrLf
									val8 = val8 & val7 & "</font>"
								End If
							End If
							rsItemDetail.MoveNext
						Loop Until rsItemDetail.EOF
						rsItemDetail.Close
						Set rsItemDetail = Nothing
					End If
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'>" & IIf(val8 <> "", val8, "<font face='Verdana' size='2'>-</font>") & "</td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
					sItem = sItem & vbCrLf & "    </td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "</table></div>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case Else
            sItem = ""
    End Select
    
    rsItem.Close
    Set rsItem = Nothing
    
    GetSelItemInfo = sItem
End Function

Function GetReqItemInfo(vItem, sItemVal)
    Dim sItem
    Dim sList
    Dim rsItem
    Dim sSQL
    
    Dim curID
    Dim val1, val2, val3, val4, val5, val6, val7, val8, val9
    
    'Variable [vItem] provides a numeric section reference for specific information blocks.
    Select Case vItem
        Case 1
            'Header Information
            sSQL = "SELECT CO, ChDue, Status, Priority, Justification, ChEffDate, "
            sSQL = sSQL & "ChType, ChReqBy, ChReqDate FROM ViewChanges "
            sSQL = sSQL & "WHERE CO = " & sItemVal
            Set rsItem = GetADORecordset(sSQL, Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("CO")) Then
					curID = sItemVal
					val1 = IIf(IsNull(rsItem("ChDue")), "-", rsItem("ChDue"))
					val2 = IIf(IsNull(rsItem("Status")), "-", rsItem("Status"))
					val3 = IIf(IsNull(rsItem("Priority")), "-", rsItem("Priority"))
					val4 = IIf(IsNull(rsItem("Justification")), "-", rsItem("Justification"))
					val5 = IIf(IsNull(rsItem("ChEffDate")), "-", rsItem("ChEffDate"))
					'val6 = IIf(IsNull(rsItem("ProjNum")), "-", "<a href='ret_selitem.asp?" & sVars & "&Listing=Project&Item=" & rsItem("ProjNum") & "'>" & rsItem("ProjNum") & IIf(IsNull(rsItem("ProjName")), "", " - " & rsItem("ProjName")) & "</a>")
					val7 = IIf(IsNull(rsItem("ChType")), "-", rsItem("ChType"))
					val8 = IIf(IsNull(rsItem("ChReqBy")), "-", rsItem("ChReqBy"))
					val9 = IIf(IsNull(rsItem("ChReqDate")), "-", rsItem("ChReqDate"))
					
					sItem = sItem & vbCrLf & "    <table border='0' width='100%' cellpadding='2'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Change Order Num:</strong> " & curID & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Date Due:</strong> " & val1 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'></font><font face='Verdana' size='1'><strong>Status:</strong> " & val2 & "&nbsp;</font><font face='Verdana' size='2'></font></td>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'></font><font face='Verdana' size='1'><strong>Eff Date:</strong> " & val5 & "&nbsp;</font><font face='Verdana' size='2'></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='1'><strong>Initiated by:</strong> " & val8 & "&nbsp;&nbsp;&nbsp; <strong>Date:</strong> " & val9 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='1'><strong>Priority:</strong> " & val3 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='1'><strong>Justification:</strong> " & val4 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='1'><strong>Change Type:</strong> " & val7 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td colspan='2'><font face='Verdana' size='1'><strong>Part Number:</strong> _________________________________&nbsp; <strong>Current Rev:</strong> ____</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case 2
            'Description/Notes
            sSQL = "SELECT CO, ChangeDesc FROM ViewChanges WHERE CO = " & sItemVal
            Set rsItem = GetADORecordset(sSQL, Nothing)
            
            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				If Not IsNull(rsItem("CO")) Then
					val1 = IIf(IsNull(rsItem("ChangeDesc")), "-", rsItem("ChangeDesc"))
					'val2 = IIf(IsNull(rsItem("AddNotes")), "-", rsItem("AddNotes"))
					
					sItem = sItem & vbCrLf & "    <table border='0' cellpadding='2' width='100%'>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='1'><strong>Description:</strong> " & val1 & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					'sItem = sItem & vbCrLf & "      <tr>"
					'sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='1'><strong>Notes:</strong> " & val2 & "&nbsp;</font></td>"
					'sItem = sItem & vbCrLf & "      </tr>"
					sItem = sItem & vbCrLf & "    </table>"
				Else
					sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
				End If
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case 99
            'Associated Docs
			sItem = sItem & vbCrLf & "    <table border='0' cellpadding='2' width='100%'>"
			sItem = sItem & vbCrLf & "      <tr>"
			sItem = sItem & vbCrLf & "        <td colspan='6'><font face='Verdana' size='1'><u><strong>ASSOCIATED DOCUMENTS</strong></u></font></td>"
			sItem = sItem & vbCrLf & "      </tr>"
			sItem = sItem & vbCrLf & "      <tr>"
			sItem = sItem & vbCrLf & "        <td colspan='2' align='center' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Revision</strong></font></td>"
			sItem = sItem & vbCrLf & "        <td colspan='4'><font face='Verdana' size='1'>&nbsp; </font></td>"
			sItem = sItem & vbCrLf & "      </tr>"
			sItem = sItem & vbCrLf & "      <tr>"
			sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Old</strong></font></td>"
			sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>New</strong></font></td>"
			sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Doc ID</strong></font></td>"
			sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
			sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
			sItem = sItem & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Doc Type</strong></font></td>"
			sItem = sItem & vbCrLf & "      </tr>"
			
			sSQL = "SELECT CO, DocID, RevFrom, RevTo, CurrentRev, DocStatus, Status, DocType, DType, DocDesc "
			sSQL = sSQL & "FROM ViewAssocDocs WHERE (CO = " & sItemVal & ") ORDER BY DocID"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				Do
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RevFrom")), "NONE", rsItem("RevFrom")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RevTo")), "NONE", rsItem("RevTo")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocID")), "-", "<a href='ret_selitem.asp?" & sVars & "&Listing=Doc&Item=" & rsItem("DocID") & "'>" & rsItem("DocID") & "</a>") & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocDesc")), "-", rsItem("DocDesc")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DType")), "-", rsItem("DType")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
			End If
			sItem = sItem & vbCrLf & "    </table><br><br>"
    End Select
    
    rsItem.Close
    Set rsItem = Nothing
    
    GetReqItemInfo = sItem
End Function

Function GetRpt(sRpt, curEID, curUN, curSG)
	Dim sRet
	Dim sSQL
	Dim rsToDo
	Dim sLink
	
	Select Case sRpt
		Case "ToDoList"
			Select Case curSG
				Case 1, 3, 8, 9
					sSQL = "SELECT TaskID, Priority, TaskDesc, BFinish, ResourceName FROM ViewTasks "
					sSQL = sSQL & "WHERE (TaskStatus <> 'CLS') ORDER BY ResourceName, BFinish, TaskID"
					curSG = 1
				Case Else
					sSQL = "SELECT TaskID, Priority, TaskDesc, BFinish, ResourceName FROM ViewTasks "
					sSQL = sSQL & "WHERE (TaskStatus <> 'CLS') AND (TaskCostType <> 'P') AND "
					sSQL = sSQL & "(ResourceName = '" & curUN & "') ORDER BY BFinish, TaskID"
					curSG = 0
			End Select
		
			Set rsToDo = GetADORecordset(sSQL, Nothing)
		
			If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then
				sRet = "<table border='0' cellpadding='2' width='625'>" & vbCrLf
				sRet = sRet & "  <tr>" & vbCrLf
				sRet = sRet & "    <td bgcolor='#808000'><font face='Verdana' size='1' color='#FFFFFF'><strong>Task ID</strong></font></td>" & vbCrLf
				sRet = sRet & "    <td bgcolor='#808000'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>" & vbCrLf
				If (curSG = 1) Then
					sRet = sRet & "    <td bgcolor='#808000'><font face='Verdana' size='1' color='#FFFFFF'><strong>Assigned To</strong></font></td>" & vbCrLf
				End If
				sRet = sRet & "    <td bgcolor='#808000'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>" & vbCrLf
				sRet = sRet & "    <td bgcolor='#808000'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>" & vbCrLf
				sRet = sRet & "  </tr>" & vbCrLf
				
				rsToDo.MoveFirst
				Do
					sLink = IIf(IsNull(rsToDo("TaskID")), "", "<a href='ret_selitem.asp?" & SVars & "&Listing=Task&Item=" & rsToDo("TaskID") & "'>")
					
					sRet = sRet & "  <tr>" & vbCrLf
					sRet = sRet & "    <td valign='top'><font face='Verdana' size='2'><strong>" & sLink & rsToDo("TaskID") & IIf(sLink <> "", "</a>", "") & "</strong></font></td>" & vbCrLf
					sRet = sRet & "    <td valign='top'><font face='Verdana' size='2'>" & rsToDo("BFinish") & "</font></td>" & vbCrLf
					If (curSG = 1) Then
						sRet = sRet & "    <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ResourceName") & "</font></td>" & vbCrLf
					End If
					sRet = sRet & "    <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>" & vbCrLf
					sRet = sRet & "    <td valign='top'><font face='Verdana' size='2'>" & rsToDo("TaskDesc") & "</font></td>" & vbCrLf
					sRet = sRet & "  </tr>" & vbCrLf
					
					rsToDo.MoveNext
				Loop Until rsToDo.EOF
				sRet = sRet & "</table>"
			Else
				sRet = "<p><font face='Verdana' size='3'><strong>NO CURRENT RECORDS RETURNED</strong></font></p>"
				sRet = sRet & "<p><font face='Verdana' size='2'>There do not appear to be any current tasks assigned to [" & curUN & "] at the present time.</font></p>"
			End If
			
			rsToDo.Close
			Set rsToDo = Nothing
		Case Else
			sRet = "<p><font face='Verdana' size='3'><strong>NOT CURRENTLY AVAILABLE</strong></font></p>"
			sRet = sRet & "<p><font face='Verdana' size='2'>This resource cannot be provided at the present time.</font></p>"
	End Select
	
	GetRpt = sRet
End Function

%>

