<%

Function VerifyRec(sItem, vRefID)
	Dim bVerify
	Dim sRet

	
	bVerify = False
	sRet = ""
	Select Case sItem
		Case "Doc": sRet = GetDataValue("SELECT DocID AS RetVal FROM Documents WHERE (DocID = '" & vRefID & "')", Nothing)
		Case "Change": sRet = GetDataValue("SELECT CO AS RetVal FROM Changes WHERE (RefType = 'CO') AND (CO = " & vRefID & ")", Nothing)
		Case "Order": sRet = GetDataValue("SELECT OrderID AS RetVal FROM OrderXRef WHERE (OrderID = " & vRefID & ")", Nothing)
		Case "Part": sRet = GetDataValue("SELECT PartID AS RetVal FROM PartsXRef WHERE (PartID = " & vRefID & ")", Nothing)
		Case "Project": sRet = GetDataValue("SELECT ProjNum AS RetVal FROM ProjXRef WHERE (ProjNum = '" & vRefID & "')", Nothing)
		Case "QAction": sRet = ""	': bVerify = True
		Case "Task": sRet = GetDataValue("SELECT TaskID AS RetVal FROM ViewTasks WHERE (TaskID = " & vRefID & ")", Nothing)
		'Case "DocElem": sRet = GetDataValue("SELECT DocID AS RetVal FROM PartPar WHERE (DocID = '" & vRefID & "')", Nothing)
	End Select
	
	If (sRet <> "") Then bVerify = True
	
	VerifyRec = bVerify
End Function

Function GetInfoSection(sItemSec, vRefID, vP1, vP2)
	Dim sInfoTxt
	Dim rsItem
	Dim sSQL
    Dim sLink
    Dim val1,val2,val3, val4, val5, val6, val7, val8, val9

	
	sInfoTxt = ""
	Select Case sItemSec
		Case "Workflow"
			sSQL = "SELECT TaskID, Status, WATStep, TaskDesc, ULNF, WATType, PcntComplete, WATID, AssnTo FROM ViewWFTasks "
			sSQL = sSQL & "WHERE ((RefNum = '" & vRefID & "') AND (RefType = '" & vP1 & "')) ORDER BY TStep, TSubstep"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>WORKFLOW</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Task ID</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Step</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Assigned To</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>% Compl</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				rsItem.MoveFirst
				Do
					'sLink = "<a href='ret_selitem.asp?Listing=Task&Item=" & rsItem("TaskID") & "'><img src='../graphics/find.gif' alt='View' border='0' WIDTH='18' HEIGHT='18'></a>"
					sLink = "<a href='wf_view.asp?T=" & rsItem("TaskID") & "&RT=" & vP1 & "&R=" & vRefID & "'><img src='../graphics/find.gif' alt='View' border='0' WIDTH='18' HEIGHT='18'></a>"
					sLink = sLink & vbCrLf & "<a href='wf_gen_tasks1.asp?M=MT&WT=" & rsItem("WATID") & "&RT=" & vP1 & "&R=" & vRefID & "'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
					sLink = sLink & vbCrLf & "<a href='wf_upd_task.asp?T=" & rsItem("TaskID") & "&TY=" & rsItem("WATType") & "'><img src='../graphics/clock.gif' alt='Update' border='0' WIDTH='18' HEIGHT='18'></a>"
					'sLink = sLink & vbCrLf & "<a href='wf_gen_tasks1.asp?M=DT&WT=" & rsItem("WATID") & "&RT=" & vP1 & "&R=" & vRefID & "'><img src='../graphics/delete.gif' alt='Delete' border='0' WIDTH='18' HEIGHT='18'></a>"
					
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' valign='top'>" & sLink & "</td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsItem("TaskID") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsItem("Status") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsItem("WATStep") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsItem("TaskDesc") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsItem("AssnTo") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsItem("PcntComplete") & "%</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			Else
				'sLink = "<a href='wf_gen_tasks.asp?M=SR&RT=" & vP1 & "&R=" & vRefID & "'>GENERATE WORKFLOW</a>"
				sLink = "<a href='wf_gen_tasks.asp?M=SR&RT=" & vP1 & "&R=" & vRefID & "'></a>"
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			
			rsItem.Close
			
			
		Case "DocElem"
		
			'val1 = GetDataValue("SELECT DocType AS RetVal FROM Documents WHERE (DocID='" & sItemVal & "')", Nothing)
			val2 = GetUserInfoItem(Session("SI"), "ProfileID")
			
		 If (val2 <> "") Then	 		
			
			 If(val2 = 5) Then
			 
			    ''''  Adding Element
				If (vP1 <> "484") Then  
					val9 = "<input type='button' name='AddElement' value='Add Element' onClick=""Javascript:fPop('add_elem.asp?M=A&Item=" & Request.QueryString("Item") & "&DocID=" & Request.QueryString("Item") & "');""> "					
					
				''''  Adding Wafer
				Else
				   val9 = "<input type='button' name='AddWafer' value='Add Wafer' onClick=""Javascript:fPop('add_wafer.asp?M=A&Item=" & Request.QueryString("Item") & "&DocID=" & Request.QueryString("Item") & "');""> "			
				End If
				
			  End If	
			  
			End If
			
			sSQL = "SELECT * FROM PartPar WHERE (DocID = '" & vRefID & "') ORDER BY PartNo"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				
				'If (val2 = 5) Then val5 = 7 Else val5 = 6
				If (vP1 <> "484") Then 
					val3 = "Wafer P/N"
					val4 = "Size"
					val5 = 6
				Else
					val3 = "Ingot P/N"
					val4 = "Slice Form."
					val5 = 7
				End If
				
				
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='" & val5 & "'><font face='Verdana' size='1'><strong><u>PART ATTRIBUTE LISTING</u></strong></font></td>"
				'sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='6'><font face='Verdana' size='1'><strong><u>PART ATTRIBUTE LISTING</u></strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Part No.</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Thick w/ Barr.</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>" & val3 & "</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Qty</font></strong></td>"
				If (vP1 = "484") Then sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Wafer Dia</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>" & val4 & "</font></strong></td>"				
				If (vP1 <> "484") Then sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Actions</font></strong></td>"				
				If (val2 = 5) And (vP1 = "484") Then sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center' bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Actions</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				Do
					'val6 = Mid(rsItem("Par5"), InStr(-1, rsItem("Par5"), ".", 1) + 1)
					'val6 = Len(rsItem("Par5")) - InStr(-1, CStr(rsItem("Par5")), ".", 1)
					'val6 = Right(rsItem("Par5"), Len(val6) - InStr(-1, val6, ".", 1))
					
					val6 = CDbl(rsItem("Par5")) * 10000
					val6 = CDbl(val6) / 10000
					
					
					'val6 = "." & val6 & String(4 - Len(val6), "0")
					val7 = IIf(vP1 = "484", rsItem("Par11"), rsItem("Par1") & " x " & rsItem("Par3"))
					
				
					
					If (vP1 <> "484") Then
						If (rsItem("Par1") = "0") Then
							val8 = "&nbsp;"
						Else
						  val8 = "<input type='image' src='../graphics/find.gif' alt='View Traveler' width='18' height='18' name='Trav' onClick='Javascript:tPop(""pnt_traveler.asp?Item=" & Request.QueryString("Item") & "&PartID=" & rsItem("PartID") & """);'>"
						End If
					Else
						val8 = "&nbsp;"
					End If
					
					If (val2 = 5) Then
					
						If (val8 = "&nbsp;") Then
							
							If (vP1 <> "484") Then
								val8 = "<input type='image' src='../graphics/open.gif' alt='Edit' width='18' height='18' name='Edit' onClick='Javascript:fPop(""mod_element.asp?M=E&Item=" & rsItem("PartNo") & "&DocID=" & Request.QueryString("Item") & """);'>"
							Else
								val8 = "<input type='image' src='../graphics/open.gif' alt='Edit' width='18' height='18' name='Edit' onClick='Javascript:fPop(""mod_wafer.asp?M=E&Item=" & rsItem("PartNo") & "&DocID=" & Request.QueryString("Item") & """);'>"
							End If							
					
						Else
							If (vP1 <> "484") Then
								val8 = val8 & vbCrLf & " <input type='image' src='../graphics/open.gif' alt='Edit' width='18' height='18' name='Edit' onClick='Javascript:fPop(""mod_element.asp?M=E&Item=" & rsItem("PartNo") & "&DocID=" & Request.QueryString("Item") & """);'>"
							Else
								val8 = val8 & vbCrLf & " <input type='image' src='../graphics/open.gif' alt='Edit' width='18' height='18' name='Edit' onClick='Javascript:fPop(""mod_wafer.asp?M=E&Item=" & rsItem("PartNo") & "&DocID=" & Request.QueryString("Item") & """);'>"
							End If
						End If
						val8 = val8 & vbCrLf & " <a href='ret_selitem.asp?Listing=" & Request.QueryString("Listing") & "&Item=" & Request.QueryString("Item") & "&Opt=" & Request.QueryString("Opt") & "&M=D&PartNo=" & rsItem("PartNo") & "'><img src='../graphics/delete.gif' alt='Delete' width='18' height='18' border='0'></a>"
					End If
					
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("PartNo") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & val6 & " +/- " & rsItem("Par6") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("MatlPn") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("Par7") & "</font></td>"
					If (vP1 = "484") Then sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("Par10") & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & val7 & "</font></td>"					
					If (vP1 <> "484") Then sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & val8 & "</font></td>"					
					
					If (val2 <>"") And (val2 = 5) And (vP1 = "484") Then sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & val8 & "</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				If (val2 = 5) Then
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='" & val5 & "' align='center'>" & val9 & "</td>"
					'sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='6' align='center'>" & val9 & "</td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				End If
				
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			Else
				If (val2 = 5) Then
					sInfoTxt = "  <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='1'><strong><u>PART ATTRIBUTE LISTING</u></strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td align='center'>" & val9 & "</td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
					sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
					sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				Else
					sInfoTxt = "  <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>PART ATTRIBUTE LISTING:</strong> NO DATA RETURNED</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				End If
			End If
			rsItem.Close
			
			
		Case "DocInfo"
			sSQL = "SELECT DocID, CurrentRev, Status, Disc, Tabulated, DType, DocDesc FROM ViewDocs WHERE (DocID = '" & vRefID & "')"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Doc ID:</strong> " & IIf(IsNull(rsItem("DocID")), "-", rsItem("DocID")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Current Rev:</strong> " & IIf(IsNull(rsItem("CurrentRev")), "NONE", rsItem("CurrentRev")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Discipline:</strong> " & IIf(IsNull(rsItem("Disc")), "-", rsItem("Disc")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Tabulated:</strong> " & IIf(rsItem("Tabulated") = 0, "NO", "YES") & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Document Type:</strong> " & IIf(IsNull(rsItem("DType")), "-", rsItem("DType")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Description:</strong> " & IIf(IsNull(rsItem("DocDesc")), "-", rsItem("DocDesc")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "DocProc"
			sSQL = "SELECT DocReqDate, DocReqBy, DocCreatedDate, DocCreatedBy, DocReviewDate, DocReviewBy, DocRelDate, DocRelRef, "
			sSQL = sSQL & "DocObsDate, DocObsRef, LastModDate, LastModBy FROM ViewDocs WHERE (DocID = '" & vRefID & "')"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%' colspan='3'><font face='Verdana' size='1'><strong><u>DOCUMENT RELEASE PROCESS DETAIL</u></strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7' width='25%'><strong><font face='Verdana' size='1'>Action</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7' width='20%'><strong><font face='Verdana' size='1'>Date</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7' width='55%'><strong><font face='Verdana' size='1'>Processed by</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Requested:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReqDate")), "-", rsItem("DocReqDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReqBy")), "-", rsItem("DocReqBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Created:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocCreatedDate")), "-", rsItem("DocCreatedDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocCreatedBy")), "-", rsItem("DocCreatedBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Reviewed:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReviewDate")), "-", rsItem("DocReviewDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocReviewBy")), "-", rsItem("DocReviewBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Released:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocRelDate")), "-", rsItem("DocRelDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocRelRef")), "-", rsItem("DocRelRef")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Obsolete:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocObsDate")), "-", rsItem("DocObsDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocObsRef")), "-", rsItem("DocObsRef")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Last Modified:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModDate")), "-", rsItem("LastModDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModBy")), "-", rsItem("LastModBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
			
		Case "DocFiles"
		
			sSQL = "SELECT FileID, FileName, FileLocation, FileLink, PrintSize, PLoc, PrintLoc FROM ViewDocFiles WHERE (DocID = '" & vRefID & "')"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='1'><strong><u>RELATED FILES</u></strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File Name</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Size</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Location</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				Do
					If Not IsNull(rsItem("FileID")) Then
						sLink = ""
						val1 = ""						
						
						If (vP2 <> "") Then
						 if(CLng(vP2) > 0) Then
						 
							val2 = CheckFileSec("DFILE", rsItem("FileID"), vP2)
							If (val2 = True) Then
								If Not IsNull(rsItem("FileLink")) Then
									'sLink = "<a href='" & rsItem("FileLink") & "' target = '_blank'>"
									sLink = rsItem("FileLink")
								Else
									If Not IsNull(rsItem("FileLocation")) Then
										sLink = Replace(rsItem("FileLocation"), "\", "/", 1, -1, vbTextCompare)
										'sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
										sLink = "http:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink
									End If
								End If
								If (sLink <> "") Then
									sLink = GetVirtualLink(sLink)
									sLink = "<a href=" & Chr(34) & "javascript:iPop('" & sLink & "')" & Chr(34) & " onMouseOver=" & Chr(34) & "window.status = 'View File'; return true;" & Chr(34) & ">"
								End If
								If (IsNull(rsItem("PLoc")) = False) And (rsItem("PLoc") <> "LAN") Then
									val1 = "<a href='q_printreq.asp?FID=" & rsItem("FileID") & "'>"
								End If
							End If
							
						  End If	
						  
						End If
						
						sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td nowrap><font face='Verdana' size='2'>" & sLink & IIf(IsNull(rsItem("FileName")), "-", rsItem("FileName")) & IIf(sLink <> "", "</a>", "") & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PrintSize")), "-", rsItem("PrintSize")) & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & val1 & IIf(IsNull(rsItem("PrintLoc")), "-", rsItem("PrintLoc")) & IIf(val1 <> "", "</a>", "")  & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					End If
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			Else
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>RELATED FILES:</strong> NO DATA RETURNED</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "DocParts"
			sSQL = "SELECT PartID, PartNo, CurRev, RStatus, PartDesc FROM ViewParts WHERE (DocID = '" & vRefID & "')"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='4'><font face='Verdana' size='1'><strong><u>RELATED PARTS</u></strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Part Number</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Rev</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				Do
					sLink = "<a href='ret_selitem.asp?Listing=Part&Item=" & rsItem("PartID") & "'>"
					sInfoTxt = sInfoTxt & vbCrLf & "          <tr>" 
					sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top' nowrap><font face='Verdana' size='2'>" & sLink & rsItem("PartNo") & "</a>&nbsp;</font></td>" 
					sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("CurRev")), "NONE", rsItem("CurRev")) & "&nbsp;</font></td>" 
					sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RStatus")), "-", rsItem("RStatus")) & "&nbsp;</font></td>" 
					sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(isNull(rsItem("PartDesc")), "-", rsItem("PartDesc")) & "&nbsp;</font></td>" 
					sInfoTxt = sInfoTxt & vbCrLf & "          </tr>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			Else
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>RELATED PARTS:</strong> NO DATA RETURNED</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "DocHistory"
			'sSQL = "SELECT DocID, CO, RevFrom, RevTo, ChStatus, Status, ChangeType, ChType, ChEffDate "
			'sSQL = sSQL & "FROM ViewDocHistory WHERE (DocID = '" & vRefID & "') ORDER BY CO DESC"
			sSQL = "SELECT Revisions.DocID, Revisions.CO, Revisions.RevFrom, Revisions.RevTo, QChStatus.OptDesc AS Status, Changes.ChangeType, Changes.ChEffDate, Changes.ChangeDesc "
			sSQL = sSQL & "FROM (Changes RIGHT JOIN Revisions ON Changes.CO = Revisions.CO) LEFT JOIN QChStatus ON Changes.ChStatus = QChStatus.OptCode "
			sSQL = sSQL & "WHERE (Revisions.DocID = '" & vRefID & "') ORDER BY Revisions.CO DESC"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				'sLink = "<font face='Verdana' size='2'><strong><a href='ret_selitem.asp?Listing=" & vItem & "&Item=" & sItemVal & "&Opt=False'>HIDE DOCUMENT HISTORY</a></strong></font><br>"
				sLink = ""
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%' colspan='5'>" & sLink & "<font face='Verdana' size='1'><strong><u>DOCUMENT HISTORY</u></strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Rev</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Chg Num</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Eff Date</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Chg Status</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Chg Type - Desc</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				Do
					If Not IsNull(rsItem("CO")) Then
						'Get Change Description for display
						'val1 = GetDataValue("SELECT ChangeDesc AS RetVal FROM Changes WHERE (RefType = 'CO') AND (CO = " & rsItem("CO") & ")", Nothing)
						val1 = IIf(IsNull(rsItem("ChangeDesc")), "", rsItem("ChangeDesc"))
						val1 = IIf(Len(val1) > 30, Left(val1, 30) & "...", val1)
						sInfoTxt = sInfoTxt & vbCrLf & "          <tr>" 
						sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RevTo")), "NONE", rsItem("RevTo")) & "&nbsp;</font></td>" 
						sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=Change&Item=" & rsItem("CO") & "'>" & rsItem("CO") & "</a>&nbsp;</font></td>" 
						sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChEffDate")), "-", rsItem("ChEffDate")) & "&nbsp;</font></td>" 
						sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(isNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>" 
						sInfoTxt = sInfoTxt & vbCrLf & "            <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChangeType")), "-", rsItem("ChangeType")) & IIf(val1 <> "", " - " & val1, "") & "&nbsp;</font></td>" 
						sInfoTxt = sInfoTxt & vbCrLf & "          </tr>"
					End If
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			Else
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>DOCUMENT HISTORY:</strong> NO DATA RETURNED</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "DocRestrictions"
			sSQL = "SELECT RNDesc, RNText1 FROM ViewResNotice WHERE (RefType = 'DOC') AND (RefID = '" & vRefID & "') AND (Disp1 <> 0)"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><p><font face='Verdana' size='3'><strong><u>SPECIAL RESTRICTIONS:</u></strong></font></p>"
				Do
					sInfoTxt = sInfoTxt & vbCrLf & "<p><font face='Verdana' size='2'><strong>" & IIf(IsNull(rsItem("RNDesc")), "-", rsItem("RNDesc")) & "</strong></font>"
					sInfoTxt = sInfoTxt & vbCrLf & "<font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RNText1")), "", "<br>" & rsItem("RNText1")) & "</font></p>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
				sInfoTxt = sInfoTxt & vbCrLf & "</td>"
				sItem = sItem & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "Notes"
			If (vP1 <> "") Then
				sSQL = "SELECT NoteID, NoteDT, NType, ULNF, NoteSubj, NoteTxt FROM ViewNotes WHERE (RefType = '" & vP1 & "') AND (RefID = '" & vRefID & "')"
				Set rsItem = GetADORecordset(sSQL, Nothing)
				
				If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
					rsItem.MoveFirst
					sInfoTxt = "  <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%'><strong><u><font face='Verdana' size='1'>NOTES</font></u></strong></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%'>"
					Do
						sInfoTxt = sInfoTxt & vbCrLf & "<p><font face='Verdana' size='2'><b>" & IIf(IsNull(rsItem("NoteDT")), "-", rsItem("NoteDT")) & "</b> - " & IIf(IsNull(rsItem("ULNF")), "-", rsItem("ULNF")) & "<br>"
						sInfoTxt = sInfoTxt & vbCrLf & "<b>Note Type:</b> " & IIf(IsNull(rsItem("NType")), "-", rsItem("NType")) & "<br>"
						sInfoTxt = sInfoTxt & vbCrLf & "<b>Subject:</b> " & IIf(IsNull(rsItem("NoteSubj")), "-", rsItem("NoteSubj")) & "<br><br>"
						sInfoTxt = sInfoTxt & vbCrLf & IIf(IsNull(rsItem("NoteTxt")), "-", rsItem("NoteTxt")) & "</font></p>"
						rsItem.MoveNext
					Loop Until rsItem.EOF
					sInfoTxt = sInfoTxt & "</td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
					sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
					sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				Else
					sInfoTxt = "  <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>NOTES:</strong> NO DATA RETURNED</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				End If
				rsItem.Close
			End If
		Case "FmtNotes"
			If (vP1 <> "") Then
				sSQL = "SELECT NoteID, NoteDT, NType, ULNF, NoteSubj, NoteTxt FROM ViewNotes WHERE (RefType = '" & vP1 & "') AND (RefID = '" & vRefID & "')"
				Set rsItem = GetADORecordset(sSQL, Nothing)
				
				If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
					rsItem.MoveFirst
					sInfoTxt = "<table border='0' cellpadding='2' width='100%'>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td><strong><u><font face='Verdana' size='1'>NOTES</font></u></strong></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td>"
					Do
						sInfoTxt = sInfoTxt & vbCrLf & "<p><font face='Verdana' size='2'><b>" & IIf(IsNull(rsItem("NoteDT")), "-", rsItem("NoteDT")) & "</b> - " & IIf(IsNull(rsItem("ULNF")), "-", rsItem("ULNF")) & "<br>"
						sInfoTxt = sInfoTxt & vbCrLf & "<b>Note Type:</b> " & IIf(IsNull(rsItem("NType")), "-", rsItem("NType")) & "<br>"
						sInfoTxt = sInfoTxt & vbCrLf & "<b>Subject:</b> " & IIf(IsNull(rsItem("NoteSubj")), "-", rsItem("NoteSubj")) & "<br><br>"
						sInfoTxt = sInfoTxt & vbCrLf & IIf(IsNull(rsItem("NoteTxt")), "-", rsItem("NoteTxt")) & "</font></p>"
						rsItem.MoveNext
					Loop Until rsItem.EOF
					sInfoTxt = sInfoTxt & "</td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				Else
					sInfoTxt = "<p><font face='Verdana' size='2'><strong>NOTES:</strong> NO DATA RETURNED</font></p>"
				End If
				rsItem.Close
			End If
		Case "ChangeInfo"
			sSQL = "SELECT CO, ChDue, ChStatus, Status, Priority, Justification, ChEffDate, ProjNum, ProjName, ChType, ChangeDesc "
			sSQL = sSQL & "FROM ViewChanges WHERE (CO = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				val1 = IIf(IsNull(rsItem("ChDue")), "-", rsItem("ChDue"))
				val2 = IIf(IsNull(rsItem("Status")), "-", rsItem("Status"))
				val3 = IIf(IsNull(rsItem("Priority")), "-", rsItem("Priority"))
				val4 = IIf(IsNull(rsItem("Justification")), "-", rsItem("Justification"))
				val5 = IIf(IsNull(rsItem("ChEffDate")), "-", rsItem("ChEffDate"))
				val6 = IIf(IsNull(rsItem("ProjNum")), "-", "<a href='ret_selitem.asp?Listing=Project&Item=" & rsItem("ProjNum") & "'>" & rsItem("ProjNum") & IIf(IsNull(rsItem("ProjName")), "", " - " & rsItem("ProjName")) & "</a>")
				val7 = IIf(IsNull(rsItem("ChType")), "-", rsItem("ChType"))
				val8 = IIf(IsNull(rsItem("ChangeDesc")), "-", rsItem("ChangeDesc"))
				val9 = GetDataValue("SELECT UDF1 AS RetVal FROM CustomUDF WHERE (RefType = 'CO') AND (RefID = '" & vRefID & "')", Nothing)
				
				sLink = ""
				'If Not IsNull(rsItem("ChStatus")) Then
				'	If (rsItem("ChStatus") <> "REL") And (rsItem("ChStatus") <> "REJ") Then
				'		sLink = "<font face='Verdana' size='2'><strong><a href='ret_impact.asp?RT=CO&CR=" & vRefID & "&M=V'>Display Impact Analysis</a></strong></font>"
				'	End If
				'End If
				
				If (sLink <> "") Then 
					sInfoTxt = "  <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'>" & sLink & "</td>"
					sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "  <tr>"
				Else
					sInfoTxt = "  <tr>"
				End If
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Change Order Num:</strong> " & vRefID & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Date Due:</strong> " & val1 & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & val2 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Priority:</strong> " & val3 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Eff Date:</strong> " & val5 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Justification:</strong> " & val4 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Charge Number: </strong> " & val9 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Change Type:</strong> " & val7 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Project:</strong> " & val6 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Description:</strong> " & val8 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "ChangeReqFmt"
			val1 = GetDataValue("SELECT UDF1 AS RetVal FROM CustomUDF WHERE (RefType = 'CO') AND (RefID = '" & vRefID & "')", Nothing)
			sSQL = "SELECT CO, ChDue, Status, Priority, Justification, ChEffDate, Project, ChType, ChReqBy, ChReqDate "
			sSQL = sSQL & "FROM ViewChanges WHERE (CO = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "<table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Priority:</strong> " & IIf(IsNull(rsItem("Priority")), "-", rsItem("Priority")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Change Order Num:</strong> " & vRefID & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Eff / Start Date:</strong> " & IIf(IsNull(rsItem("ChEffDate")), "-", rsItem("ChEffDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Due / End Date:</strong> " & IIf(IsNull(rsItem("ChDue")), "-", rsItem("ChDue")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='1'><strong>Justification:</strong> " & IIf(IsNull(rsItem("Justification")), "-", rsItem("Justification")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='1'><strong>Change Type:</strong> " & IIf(IsNull(rsItem("ChType")), "-", rsItem("ChType")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2'><font face='Verdana' size='1'><strong>Project:</strong> " & IIf(IsNull(rsItem("Project")), "-", rsItem("Project")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='1'><strong>Initiated by:</strong> " & IIf(IsNull(rsItem("ChReqBy")), "-", rsItem("ChReqBy")) & "&nbsp;&nbsp;&nbsp;<strong>Date:</strong> " & IIf(IsNull(rsItem("ChReqDate")), "-", rsItem("ChReqDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='1'><strong>Charge Num:</strong> " & IIf(val1 <> "", val1, "-") & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				'sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				'sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2'><font face='Verdana' size='1'><strong>Part Number:</strong> _________________________________&nbsp; <strong>Current Rev:</strong> ____</font></td>"
				'sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
			Else
				sInfoTxt = "<p><font face='Verdana' size='2'><strong>CHANGE INFORMATION:</strong> NO DATA RETURNED</font></p>"
			End If
			rsItem.Close
		Case "ChangeAssDoc"
			sSQL = "SELECT CO, DocID, RevFrom, RevTo, CurrentRev, Status, DocType, DocDesc "
			sSQL = sSQL & "FROM ViewAssocDocs WHERE (CO = " & vRefID & ") ORDER BY DocID"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "<table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='5'><font face='Verdana' size='1'><u><strong>ASSOCIATED DOCUMENTS</strong></u></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2' align='center' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Revision</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='1'>&nbsp; </font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Old</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>New</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Doc ID</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				Do
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RevFrom")), "NONE", rsItem("RevFrom")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RevTo")), "NONE", rsItem("RevTo")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top' nowrap><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocID")), "-", rsItem("DocID")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocDesc")), "-", rsItem("DocDesc")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
				sInfoTxt = sInfoTxt & vbCrLf & "    </table><br>&nbsp;"
			Else
				sInfoTxt = "<p><font face='Verdana' size='2'><strong>ASSOCIATED DOCUMENTS:</strong> NO DATA RETURNED</font></p>"
			End If
			rsItem.Close
		Case "ChangeDesc"
			val1 = GetDataValue("SELECT ChangeDesc AS RetVal FROM Changes WHERE (RefType = 'CO') AND (CO = " & vRefID & ")", Nothing)
			If (val1 <> "") Then
				sInfoTxt = "<table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Description:</strong> " & val1 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table><br>&nbsp;"
			Else
				sInfoTxt = "<p><font face='Verdana' size='2'><strong>DESCRIPTION:</strong> NO DATA RETURNED</font></p>"
			End If
		Case "ChangeProc"
			sSQL = "SELECT ChReqDate, ChReqBy, ChApprDate, ChApprBy, ChAssignDate, ChAssignTo, ChCompletedDate, ChCompletedBy, "
			sSQL = sSQL & "ChReleasedDate, ChReleasedBy, LastModDate, LastModBy FROM ViewChanges WHERE (CO = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='1'><strong><u>CHANGE ORDER PROCESS DETAIL</u></strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7' width='25%'><strong><font face='Verdana' size='1'>Action</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7' width='20%'><strong><font face='Verdana' size='1'>Date</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7' width='55%'><strong><font face='Verdana' size='1'>Processed by</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Requested:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReqDate")), "-", rsItem("ChReqDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReqBy")), "-", rsItem("ChReqBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Approved:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChApprDate")), "-", rsItem("ChApprDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChApprBy")), "-", rsItem("ChApprBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Assigned:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChAssignDate")), "-", rsItem("ChAssignDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChAssignTo")), "-", rsItem("ChAssignTo")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Completed:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChCompletedDate")), "-", rsItem("ChCompletedDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChCompletedBy")), "-", rsItem("ChCompletedBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Released:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReleasedDate")), "-", rsItem("ChReleasedDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ChReleasedBy")), "-", rsItem("ChReleasedBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Last Modified:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModDate")), "-", rsItem("LastModDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LastModBy")), "-", rsItem("LastModBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "ChangeDocs"
			sSQL = "SELECT CO, DocID, RevFrom, RevTo, CurrentRev, DocStatus, Status, DocType, DType, DocDesc "
			sSQL = sSQL & "FROM ViewAssocDocs WHERE (CO = " & vRefID & ") ORDER BY DocID"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='6'><font face='Verdana' size='1'><u><strong>ASSOCIATED DOCUMENTS</strong></u></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='2' align='center' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Revision</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='4'><font face='Verdana' size='1'>&nbsp; </font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Old</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>New</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Doc ID</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Doc Type</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				Do
					sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & rsItem("DocID") & "&Opt='>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RevFrom")), "NONE", rsItem("RevFrom")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("RevTo")), "NONE", rsItem("RevTo")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top' nowrap><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocID")), "-", sLink & rsItem("DocID") & "</a>") & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DocDesc")), "-", rsItem("DocDesc")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DType")), "-", rsItem("DType")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			Else
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>ASSOCIATED DOCUMENTS:</strong> NO DATA RETURNED</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "ChangeMDisp"
			sSQL = "SELECT OrderDateBatch, Status, DispType, ImpAreaDesc, ULNF, DateDue, DispEffDate "
			sSQL = sSQL & "FROM ViewMatDisp WHERE (CO = " & vRefID & ") ORDER BY DateDue"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='7'><u><strong><font face='Verdana' size='1'>MATERIAL DISPOSITION</font></strong></u></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Order/Date/Batch</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Status</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Type</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Impact Area</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Assigned To</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Due</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Eff</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				Do
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top' nowrap><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("OrderDateBatch")), "-", rsItem("OrderDateBatch")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DispType")), "-", rsItem("DispType")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ImpAreaDesc")), "-", rsItem("ImpAreaDesc")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ULNF")), "-", rsItem("ULNF")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DateDue")), "-", rsItem("DateDue")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DispEffDate")), "-", rsItem("DispEffDate")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				'sInfoTxt = sInfoTxt & vbCrLf & "</table></div>"
			Else
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>MATERIAL DISPOSITION:</strong> NO DATA RETURNED</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "ChangeImpact"
			sSQL = "SELECT DISTINCT "
			sSQL = sSQL & "OrderID AS [Order ID], LineItemID AS [Line Item ID], "
			sSQL = sSQL & "OrderType AS [Order Type], OrderNum AS [Order Number], OrderStatus AS [Order Status], " 
			sSQL = sSQL & "ItemLine AS [Line Item], PartNo AS [Part Number], RStatus AS [Revision Status], "
			sSQL = sSQL & "PartRev AS [Part Revision], PartEffDate AS [Part Effective Date], PartDesc AS [Part Description], " 
			sSQL = sSQL & "ItemUnit AS [Unit], ItemQty AS [Qty], Cost " 
			sSQL = sSQL & "FROM ViewImpact WHERE (CO = " & vRefID & ") AND (PartNo IS NOT NULL) ORDER BY OrderType, OrderNum, ItemLine"
			Set rsItem = GetADORecordset(sSQL, Nothing)
	
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='11'><u><strong><font face='Verdana' size='1'>LIST OF IMPACTS</font></strong></u></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Order Type</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Order Number</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Order Status</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Line Item</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Part Number</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Revision Status</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Part Revision</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Part Effective Date</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Unit</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Qty</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				Do
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top' nowrap><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Order Type")), "-", rsItem("Order Type")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Order Number")), "-", rsItem("Order Number")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Order Status")), "-", rsItem("Order Status")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Line Item")), "-", rsItem("Line Item")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Part Number")), "-", rsItem("Part Number")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Revision Status")), "-", rsItem("Revision Status")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Part Revision")), "-", rsItem("Part Revision")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Part Effective Date")), "-", rsItem("Part Effective Date")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Unit")), "-", rsItem("Unit")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Qty")), "-", rsItem("Qty")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("Cost")), "-", "$"  & rsItem("Cost")) & "&nbsp;</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "</table></div>"
			Else
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>LIST OF IMPACTS:</strong> NO DATA RETURNED</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "Att"
			If (vP1 <> "") Then
				sSQL = "SELECT AttID, AttFName, AttFDesc, AttFLoc, AttFLink, PrintSize, PrintLoc FROM ViewAttach "
				sSQL = sSQL & "WHERE (WebView <> 0) AND ((RefType = '" & vP1 & "') AND (RefID = '" & vRefID & "')) ORDER BY AttFName"
				Set rsItem = GetADORecordset(sSQL, Nothing)
			
				If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
					rsItem.MoveFirst
					sInfoTxt = "  <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='6'><font face='Verdana' size='1'><u><strong>FILE ATTACHMENTS</strong></u></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File Name</strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Size</strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Location</strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					
					Do
						sLink = ""
						If Not IsNull(rsItem("AttID")) Then
							If ((vP2 <> "") And (CLng(vP2) > 0)) And (vP1 <> "") Then
								val2 = CheckFileSec(vP1, rsItem("AttID"), vP2)
								If (val2 = True) Then
									If Not IsNull(rsItem("AttFLink")) Then
										'sLink = "<a href='" & rsItem("AttFLink") & "' target = '_blank'>"
										sLink = rsItem("AttFLink")
									Else
										If Not IsNull(rsItem("AttFLoc")) Then
											sLink = Replace(rsItem("AttFLoc"), "\", "/", 1, -1, vbTextCompare)
											'sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
											sLink = "http:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink
										End If
									End If
									If (sLink <> "") Then
										sLink = GetVirtualLink(sLink)
										sLink = "<a href=" & Chr(34) & "javascript:iPop('" & sLink & "')" & Chr(34) & " onMouseOver=" & Chr(34) & "window.status = 'View File'; return true;" & Chr(34) & ">"
									End If
								End If
							End If
							
							sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
							sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2' nowrap>" & sLink & IIf(IsNull(rsItem("AttFName")), "-", rsItem("AttFName")) & IIf(sLink <> "", "</a>", "") & "&nbsp;</font></td>"
							sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("AttFDesc")), "-", rsItem("AttFDesc")) & "&nbsp;</font></td>"
							sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PrintSize")), "-", rsItem("PrintSize")) & "&nbsp;</font></td>"
							sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PrintLoc")), "-", rsItem("PrintLoc")) & "&nbsp;</font></td>"
							sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
						End If
						rsItem.MoveNext
					Loop Until rsItem.EOF
					
					sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
					sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
					sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				Else
					sInfoTxt = "  <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>FILE ATTACHMENTS:</strong> NO DATA RETURNED</font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				End If
				rsItem.Close
			End If
		Case "FmtAtt"
			If (vP1 <> "") Then
				sSQL = "SELECT AttID, AttFName, AttFDesc, PrintSize FROM ViewAttach "
				sSQL = sSQL & "WHERE (WebView <> 0) AND ((RefType = '" & vP1 & "') AND (RefID = '" & vRefID & "')) ORDER BY AttFName"
				Set rsItem = GetADORecordset(sSQL, Nothing)
				
				If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
					rsItem.MoveFirst
					sInfoTxt = "<table border='0' cellpadding='2' width='100%'>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='1'><u><strong>FILE ATTACHMENTS</strong></u></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>File Name</strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Description</strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Print Size</strong></font></td>"
					sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					
					Do
						If Not IsNull(rsItem("AttID")) Then
							sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
							sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2' nowrap>" & IIf(IsNull(rsItem("AttFName")), "-", rsItem("AttFName")) & "&nbsp;</font></td>"
							sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("AttFDesc")), "-", rsItem("AttFDesc")) & "&nbsp;</font></td>"
							sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PrintSize")), "-", rsItem("PrintSize")) & "&nbsp;</font></td>"
							sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
						End If
						rsItem.MoveNext
					Loop Until rsItem.EOF
					
					sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				Else
					sInfoTxt = "<p><font face='Verdana' size='2'><strong>FILE ATTACHMENTS:</strong> NO DATA RETURNED</font></p>"
				End If
				rsItem.Close
			End If
		Case "OrderInfo"
			sSQL = "SELECT OrderID, OrderNum, Parent, OrderType, OrderStatus, OrderDate, VendCustID, VCName, VCLocation, "
			sSQL = sSQL & "VCContact, VCContEmail, VCContPhone FROM ViewOrders WHERE (OrderID = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				If Not IsNull(rsItem("Parent")) Then
					val2 = GetDataValue("SELECT OrderID AS RetVal FROM OrderXRef WHERE (OrderNum = '" & rsItem("Parent") & "')", Nothing)
					val1 = "<a href='ret_selitem.asp?Listing=Order&Item=" & val2 & "'>" & rsItem("Parent") & "</a>"
				Else
					val1 = "-"
				End If
				val3 = IIf(IsNull(rsItem("VCContact")), "", rsItem("VCContact"))
				If (rsItem("VCContEmail") <> "") Then
					val3 = "<a href='mailto:" & rsItem("VCContEmail") & "'>" & IIf(val3 <> "", val3, "-") & "</a>"
				End If
				If (rsItem("VCContPhone") <> "") Then
					val3 = IIf(val3 <> "", val3 & " - ", "") & rsItem("VCContPhone")
				End If
				val4 = IIf(IsNull(rsItem("VendCustID")), "", rsItem("VendCustID"))
				If (val4 <> "") Then
					val4 = val4 & IIf(IsNull(rsItem("VCName")), "", " - " & rsItem("VCName"))
				Else
					val4 = "-"
				End If
				
				sInfoTxt =  "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Order Num:</strong> " & IIf(IsNull(rsItem("OrderNum")), "-", rsItem("OrderNum")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Type:</strong> " & IIf(IsNull(rsItem("OrderType")), "-", rsItem("OrderType")) & "</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("OrderStatus")), "-", rsItem("OrderStatus")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Parent:</strong> " & val1 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Date:</strong> " & IIf(IsNull(rsItem("OrderDate")), "-", rsItem("OrderDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%'><u><font face='Verdana' size='1'><strong>VENDOR/CUSTOMER</strong></font></u></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'>" & val4 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>Location:</strong> " & IIf(IsNull(rsItem("VCLocation")), "-", rsItem("VCLocation")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>Contact:</strong> " & val3 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "OrderSched"
			sSQL = "SELECT PlannedStartDate, ActStartDate, PlannedEndDate, ActEndDate, "
			sSQL = sSQL & "PlannedShipDate, ActShipDate FROM ViewOrders WHERE (OrderID = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt =  "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%' colspan='3'><strong><u><font face='Verdana' size='1'>ORDER SCHEDULE</font></u></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='30%'><font face='Verdana' size='1'>&nbsp; </font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='35%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Planned</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='35%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Actual</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><strong><font face='Verdana' size='2'>Start Date:</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedStartDate")), "-", rsItem("PlannedStartDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActStartDate")), "-", rsItem("ActStartDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Finish Date:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedEndDate")), "-", rsItem("PlannedEndDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActEndDate")), "-", rsItem("ActEndDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Ship Date:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedShipDate")), "-", rsItem("PlannedShipDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActShipDate")), "-", rsItem("ActShipDate")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "OrderLines"
			sSQL = "SELECT LineItemID, PartID, PartNo, ItemLine, ItemUnit, ItemQty, ItemCost, LineCost "
			sSQL = sSQL & "FROM ViewOrderLines WHERE (OrderID = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt =  "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='100%' colspan='6'><font face='Verdana' size='1'><strong><u>ORDER LINE DETAIL</u></strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Line</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Part Number</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Unit</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Qty</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Subtotal</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				
				val2 = 0
				Do
					If Not IsNull(rsItem("LineItemID")) Then
						val1 = IIf(IsNull(rsItem("PartNo")), "-", rsItem("PartNo"))
						If Not IsNull(rsItem("PartID")) Then
							val1 = "<a href='ret_selitem.asp?Listing=Part&Item=" & rsItem("PartID") & "'>" & val1 & "</a>"
						End If
						If Not IsNull(rsItem("LineCost")) Then val2 = val2 + rsItem("LineCost")
						sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ItemLine")), "-", rsItem("ItemLine")) & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2' nowrap>" & val1 & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ItemUnit")), "-", rsItem("ItemUnit")) & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ItemQty")), "0", rsItem("ItemQty")) & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ItemCost")), "0", rsItem("ItemCost")) & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("LineCost")), "0", rsItem("LineCost")) & "&nbsp;</font></td>"
						sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
					End If
					rsItem.MoveNext
				Loop Until rsItem.EOF
				
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='5' align='right'><font face='Verdana' size='2'><b>Order Subtotal:</b></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & val2 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			Else
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td><font face='Verdana' size='2'><strong>ORDER LINE DETAIL:</strong> NO DATA RETURNED</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "TaskInfo"
			sSQL = "SELECT TaskID, ParentTask, RefType, RefNum, ProjNum, ProjName, Project, StdTask, Status, Priority, "
			sSQL = sSQL & "ChargeAcct, PcntComplete, TaskDesc FROM ViewTasks WHERE (TaskID = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
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
				
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%' bgcolor='#808000'><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Task ID:</strong> " & rsItem("TaskID") & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' color='#0061f2'><strong>Type:</strong> " & IIf(IsNull(rsItem("StdTask")), "-", rsItem("StdTask")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & IIf(IsNull(rsItem("Status")), "-", rsItem("Status")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Priority:</strong> " & IIf(IsNull(rsItem("Priority")), "-", rsItem("Priority")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Parent:</strong> " & val1 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Chg Acct:</strong> " & IIf(IsNull(rsItem("ChargeAcct")), "-", rsItem("ChargeAcct")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Reference:</strong> " & val2 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Complete:</strong> " & IIf(IsNull(rsItem("PcntComplete")), "-", rsItem("PcntComplete")) & "&nbsp;%</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Description:</strong> " & IIf(IsNull(rsItem("TaskDesc")), "-", rsItem("TaskDesc")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Project:</strong> " & val3 & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "TaskAssn"
			sSQL = "SELECT AssnBy, ResourceName, DateAssigned, TaskDetail FROM ViewTasks WHERE (TaskID = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='1'><u><strong>TASK ASSIGNMENT DETAIL</strong></u></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='40%' bgcolor='#D7D7D7' nowrap><font face='Verdana' size='1'><strong>Assigned By</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='40%' bgcolor='#D7D7D7' nowrap><font face='Verdana' size='1'><strong>Assigned To</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='20%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Date</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("AssnBy")), "-", rsItem("AssnBy")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ResourceName")), "-", rsItem("ResourceName")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("DateAssigned")), "-", rsItem("DateAssigned")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td bgcolor='#D7D7D7' colspan='3'><font face='Verdana' size='1'><strong>Assignment</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("TaskDetail")), "-", rsItem("TaskDetail")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case "TaskSched"
			sSQL = "SELECT PlannedStart, ActualStart, PlannedFinish, ActualFinish, OverrunEstFinish, "
			sSQL = sSQL & "EstHours, ActualHours, OverrunHrs FROM ViewTasks WHERE (TaskID = " & vRefID & ")"
			Set rsItem = GetADORecordset(sSQL, Nothing)
			
			If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				rsItem.MoveFirst
				sInfoTxt = "  <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2'>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td colspan='4'><u><strong><font face='Verdana' size='1'>TASK SCHEDULE DETAIL</font></strong></u></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='1'>&nbsp; </font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Planned</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Actual</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Overrun</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><strong><font face='Verdana' size='2'>Start Date:</font></strong></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedStart")), "-", rsItem("PlannedStart")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualStart")), "-", rsItem("ActualStart")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Finish Date:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("PlannedFinish")), "-", rsItem("PlannedFinish")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualFinish")), "-", rsItem("ActualFinish")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("OverrunEstFinish")), "-", rsItem("OverrunEstFinish")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "      <tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Hours:</strong></font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("EstHours")), "0", rsItem("EstHours")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("ActualHours")), "0", rsItem("ActualHours")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "        <td width='25%'><font face='Verdana' size='2'>" & IIf(IsNull(rsItem("OverrunHrs")), "0", rsItem("OverrunHrs")) & "&nbsp;</font></td>"
				sInfoTxt = sInfoTxt & vbCrLf & "      </tr>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </table>"
				sInfoTxt = sInfoTxt & vbCrLf & "    </td>"
				sInfoTxt = sInfoTxt & vbCrLf & "  </tr>"
			End If
			rsItem.Close
		Case ""
			sInfoTxt = ""
	End Select
	
	Set rsItem = Nothing
	GetInfoSection = sInfoTxt
End Function

Function CheckFileSec(RefType, RefID, curU)
	Dim sSQL
	Dim sRetInfo
	Dim bAllow
	
	bAllow = False
	sSQL = "SELECT SecClass AS RetVal FROM ViewSecClass WHERE (RefType = '" & RefType & "') AND (RefID = '" & RefID & "')"
	sRetInfo = GetDataValue(sSQL, Nothing)
	If (sRetInfo <> "") Then
		If ((curU <> "") And (CLng(curU) > 0)) Then
			sSQL = "SELECT EmpID AS RetVal FROM ViewSecClassMembs WHERE (EmpID = " & curU & ") AND "
			sSQL = sSQL & "(SecClass IN (SELECT SecClass FROM ViewSecClass WHERE (RefType = '" & RefType & "') AND (RefID = '" & RefID & "')))"
			'Response.Write "<p>sSQL = " & sSQL & "</p>"
			sRetInfo = GetDataValue(sSQL, Nothing)
			If (sRetInfo <> "") Then
				bAllow = True
			End If
		End If
	Else
		bAllow = True
	End If
	
	CheckFileSec = bAllow
End Function

%>

