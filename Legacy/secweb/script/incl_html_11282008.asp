<!-- #INCLUDE FILE="incl_info.asp" -->

<%

'--------------------------------------
'GetHTML
'--------------------------------------
Function GetHTML(vTag, vItem, sItemVal, bOpt)
    Dim sHTML
    
    Select Case vTag
		'*************************************
        '       Reports
        '*************************************
        Case "Report"
            sHTML = GetReport(vItem, sItemVal)
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

'--------------------------------------
'GetRpt
'--------------------------------------
Function GetRpt(sRpt, curEID, curUN, curSG)
	Dim sRet
	Dim sSQL
	Dim rsToDo
	Dim sLink	
	
	If (curSG = 1) Then
	 isAdmin = true
	Else
	 isAdmin = false
	End If
	
	Select Case sRpt
		Case "ToDoList"
			
			'=============================
			'List Projects assigned
			'=============================
			'Add a list for Projects in Process  (all not closed or not cancelled)
            'Show Project Number, Project name, Status, Actual start date, Planned end date 
									
			sSQL = "SELECT ProjNum, ProjName, Status, ActualStart, "
			sSQL = sSQL & "PlannedFinish FROM ViewProjects "
			sSQL = sSQL & "WHERE ProjStatus NOT IN ('CLS') ORDER BY PlannedFinish DESC"		
			
			Set rsToDo = GetADORecordset(sSQL, Nothing)
			If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then
				sRet = "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Assigned Projects</font></strong></td>"
				sRet = sRet & vbCrLf & "    </tr>"
				sRet = sRet & vbCrLf & "    <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sRet = sRet & vbCrLf & "      <tr>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Project ID</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Project Name</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Status</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Actual Start Date</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Planned End Date</strong></font></td>"
				sRet = sRet & vbCrLf & "      </tr>"
								
				rsToDo.MoveFirst				
				Do
					If Not IsNull(rsToDo("ProjNum")) Then					
						sLink = "<a href='../../ProjectManagement/ProjectInformation.aspx?SID=" & Session("SI") & "&PID=" & rsToDo("ProjNum") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"						
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("ProjNum") & "</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ProjName") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Status") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ActualStart") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("PlannedFinish") & "</font></td>"
						sRet = sRet & vbCrLf & "      </tr>"					
					End If					
					rsToDo.MoveNext
				Loop Until rsToDo.EOF				
				sRet = sRet & vbCrLf & "    </table>"
				sRet = sRet & vbCrLf & "    </td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			Else
				sRet = "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Projects Assigned</font></td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			End If			
			rsToDo.Close			
				
		    '=============================
			'List Tasks assigned
			'=============================
			sSQL = "SELECT TaskID, Priority, TaskDesc, BFinish, ResourceName FROM ViewTasks "
			sSQL = sSQL & "WHERE (TaskStatus <> 'CLS') AND (TaskCostType <> 'P') AND "
			sSQL = sSQL & "(ResourceName = '" & curUN & "') ORDER BY BFinish, TaskID"
			
			Set rsToDo = GetADORecordset(sSQL, Nothing)
			If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Assigned Tasks</font></strong></td>"
				sRet = sRet & vbCrLf & "    </tr>"
				sRet = sRet & vbCrLf & "    <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sRet = sRet & vbCrLf & "      <tr>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Task ID</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
				sRet = sRet & vbCrLf & "      </tr>"
								
				rsToDo.MoveFirst				
				Do
					If Not IsNull(rsToDo("TaskID")) Then					
						sLink = "<a href='../../TaskManagement/TaskInformation.aspx?SID=" & Session("SI") & "&TID=" & rsToDo("TaskID") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"						
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("TaskID") & "</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("BFinish") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("TaskDesc") & "</font></td>"
						sRet = sRet & vbCrLf & "      </tr>"					
					End If					
					rsToDo.MoveNext
				Loop Until rsToDo.EOF				
				sRet = sRet & vbCrLf & "    </table>"
				sRet = sRet & vbCrLf & "    </td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			Else
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Tasks Assigned</font></td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			End If			
			rsToDo.Close
			
			'=============================
			'List Workflow tasks assigned
			'=============================
			If NOT ISNULL(curEID) AND curEID <> "" THEN
			 sSQL = "SELECT WATID, TaskID, RefType, RefNum, Priority, TaskDesc, BFinish, WATType, WFAssnTo FROM ViewWFTasks WHERE (WFActive <> 0) AND (WATActive <> 0) AND (WFAssnTo = " & curEID & ") ORDER BY BFinish, TaskID"
			ELSE
			 sSQL = "SELECT WATID, TaskID, RefType, RefNum, Priority, TaskDesc, BFinish, WATType, WFAssnTo FROM ViewWFTasks WHERE (WFActive <> 0) AND (WATActive <> 0) ORDER BY BFinish, TaskID"
			END IF
			
			Set rsToDo = GetADORecordset(sSQL, Nothing)			
			If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then			
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Assigned Workflow Tasks</font></strong></td>"
				sRet = sRet & vbCrLf & "  </tr>"
				sRet = sRet & vbCrLf & "  <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sRet = sRet & vbCrLf & "      <tr>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Task ID</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
				sRet = sRet & vbCrLf & "      </tr>"
								
				rsToDo.MoveFirst				
				Do				
					If Not IsNull(rsToDo("TaskID")) Then											
						sLink = "<a href='../../WorkFlowManagement/WFTaskInformation.aspx?SID=" & Session("SI") & "&RFTP=" & rsToDo("RefType") &  "&RFID=" & rsToDo("RefNum") & "&TID=" & rsToDo("WATID") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"					
						sLink =  sLink & vbCrLf & "<a href='../../WorkFlowManagement/WFTaskInformationReview.aspx?SID=" & Session("SI") & "&RFTP=" & rsToDo("RefType") &  "&RFID=" & rsToDo("RefNum") & "&TID=" & rsToDo("WATID") & "' target='_top'><img src='../graphics/clock.gif' alt='Update' border='0' WIDTH='18' HEIGHT='18'></a>"						
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("TaskID") & "</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("BFinish") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("TaskDesc") & "</font></td>"
						sRet = sRet & vbCrLf & "      </tr>"						
					End If					
					rsToDo.MoveNext
				Loop Until rsToDo.EOF				
				sRet = sRet & vbCrLf & "    </table>"
				sRet = sRet & vbCrLf & "    </td>"
				sRet = sRet & vbCrLf & "  </tr>"
			Else
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Workflow Tasks Assigned</font></td>"
				sRet = sRet & vbCrLf & "  </tr>"
			End If
			rsToDo.Close
			
			'=============================
			'List Changes assigned
			'=============================
			sSQL = "SELECT CO, ChDue, Priority, ChangeDesc FROM ViewChanges "
			sSQL = sSQL & "WHERE (ChStatus <> 'CLS') AND (ChStatus <> 'REL') AND (ChStatus <> 'REJ') "
			sSQL = sSQL & "AND (ChAssignTo = '" & curUN & "')"
			
			Set rsToDo = GetADORecordset(sSQL, Nothing)
			If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then			
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Assigned Changes</font></strong></td>"
				sRet = sRet & vbCrLf & "  </tr>"
				sRet = sRet & vbCrLf & "  <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sRet = sRet & vbCrLf & "      <tr>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Change Num</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
				sRet = sRet & vbCrLf & "      </tr>"
				
				rsToDo.MoveFirst				
				Do
					If Not IsNull(rsToDo("CO")) Then					
					sLink = "<a href='../../ChangeManagement/ChangeOrders.aspx?SID=" & Session("SI") & "&COID=" & rsToDo("CO") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"					
					'sLink = sLink & "<a href='req_change1.asp?RT=CR&CR=" & rsToDo("CO") & "' target='_top'><img src='../graphics/open.gif' width='18' height='18' alt='Edit' border='0'></a>"
					    sRet = sRet & vbCrLf & "      <tr>"
					    sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
					    sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("CO") & "</strong></font></td>"
					    sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ChDue") & "</font></td>"
					    sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>"
					    sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ChangeDesc") & "</font></td>"
					    sRet = sRet & vbCrLf & "      </tr>"
					End If
					rsToDo.MoveNext
				Loop Until rsToDo.EOF				
				sRet = sRet & vbCrLf & "    </table>"
				sRet = sRet & vbCrLf & "    </td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			Else			
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "<tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Changes Assigned</font></td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			End If
			rsToDo.Close
			
			'=============================
			'List Documents Requested
			'=============================
			'Add a list for documents requested.
            'Show Document number, description, project number, requested date, status 
            
            sSQL = "SELECT DocID, DocDesc, ProjNum, DocReqDate, Status FROM ViewDocs "
			sSQL = sSQL & "WHERE (DocStatus = 'CREQ') AND (DocReqBy = '" & curUN & "')"
			
			Set rsToDo = GetADORecordset(sSQL, Nothing)
			If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then			
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & " <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Documents Requested</font></strong></td>"
				sRet = sRet & vbCrLf & "  </tr>"
				sRet = sRet & vbCrLf & "  <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sRet = sRet & vbCrLf & "      <tr>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Document ID</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Project ID</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Requested Date</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Status</strong></font></td>"
				sRet = sRet & vbCrLf & "      </tr>"
				
				rsToDo.MoveFirst				
				Do
					If Not IsNull(rsToDo("DocID")) Then											
						sLink = "<a href='../../DocumentManagement/DocInformation.aspx?SID=" & Session("SI") & "&DOCID=" & rsToDo("DocID") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"						
						'sLink = sLink & "<a href='../../DocumentManagement/DocInformation.aspx?SID=" & Session("SI") & "&DOCID=" & rsToDo("DocID") & "' target='_top'><img src='../graphics/open.gif' width='18' height='18' alt='Edit' border='0'></a>"             														
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("DocID") & "</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("DocDesc") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ProjNum") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("DocReqDate") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Status") & "</font></td>"
						sRet = sRet & vbCrLf & "      </tr>"						
					End If
					rsToDo.MoveNext
				Loop Until rsToDo.EOF				
				sRet = sRet & vbCrLf & "    </table>"
				sRet = sRet & vbCrLf & "    </td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			Else
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Documents Requested</font></td>"
				sRet = sRet & vbCrLf & "  </tr>"
			End If			
			rsToDo.Close
            
            
			'=============================
			'List Changes requested
			'=============================
			sSQL = "SELECT CO, ChDue, Priority, ChangeDesc FROM ViewChanges "
			sSQL = sSQL & "WHERE (ChStatus = 'CREQ') AND (ChReqBy = '" & curUN & "')"
			
			Set rsToDo = GetADORecordset(sSQL, Nothing)
			If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then			
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & " <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Changes Requested</font></strong></td>"
				sRet = sRet & vbCrLf & "  </tr>"
				sRet = sRet & vbCrLf & "  <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
				sRet = sRet & vbCrLf & "      <tr>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Change Num</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>"
				sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
				sRet = sRet & vbCrLf & "      </tr>"
				
				rsToDo.MoveFirst				
				Do
					If Not IsNull(rsToDo("CO")) Then											
						sLink = "<a href='../../ChangeManagement/ChangeOrders.aspx?SID=" & Session("SI") & "&COID=" & rsToDo("CO") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"						
						'sLink = sLink & "<a href='../../ChangeManagement/ChangeOrders.aspx?SID=" & Session("SI") & "&COID=" & rsToDo("CO") & "' target='_top'><img src='../graphics/open.gif' width='18' height='18' alt='Edit' border='0'></a>"             														
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("CO") & "</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ChDue") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>"
						sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ChangeDesc") & "</font></td>"
						sRet = sRet & vbCrLf & "      </tr>"						
					End If
					rsToDo.MoveNext
				Loop Until rsToDo.EOF				
				sRet = sRet & vbCrLf & "    </table>"
				sRet = sRet & vbCrLf & "    </td>"
				sRet = sRet & vbCrLf & "  </tr>"				
			Else
				sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
				sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Changes Requested</font></td>"
				sRet = sRet & vbCrLf & "  </tr>"
			End If			
			rsToDo.Close
			
			
			'=============================
			' Removed as per : Chuck Request
		    '=============================
			If isAdmin Then
			
			  Select Case curSG
				Case 1, 3, 8, 9
				
					'=============================
					'List Open Tasks
					'=============================
					sSQL = "SELECT TaskID, Priority, TaskDesc, BFinish, ResourceName FROM ViewTasks "
					sSQL = sSQL & "WHERE (TaskStatus <> 'CLS') AND (ResourceName <> '" & curUN & "') "
					sSQL = sSQL & "ORDER BY BFinish, TaskID"
			
					Set rsToDo = GetADORecordset(sSQL, Nothing)
					If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then
						sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Open Tasks</font></strong></td>"
						sRet = sRet & vbCrLf & "  </tr>"
						sRet = sRet & vbCrLf & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Task ID</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Assigned To</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
						sRet = sRet & vbCrLf & "      </tr>"
						
						rsToDo.MoveFirst
						Do
							If Not IsNull(rsToDo("TaskID")) Then
														
							sLink = "<a href='../../TaskManagement/TaskInformation.aspx?SID=" & Session("SI") & "&TID=" & rsToDo("TaskID") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"								
								
								sRet = sRet & vbCrLf & "      <tr>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("TaskID") & "</strong></font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("BFinish") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ResourceName") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("TaskDesc") & "</font></td>"
								sRet = sRet & vbCrLf & "      </tr>"
							End If
							rsToDo.MoveNext
						Loop Until rsToDo.EOF
						
						sRet = sRet & vbCrLf & "    </table>"
						sRet = sRet & vbCrLf & "    </td>"
						sRet = sRet & vbCrLf & "  </tr>"
					Else
						sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Open Tasks found</font></td>"
						sRet = sRet & vbCrLf & "  </tr>"
					End If
					rsToDo.Close
										
					'=============================
					'List Open Workflow tasks
					'=============================
					sSQL = "SELECT TaskID, WATID, RefType, RefNum, Priority, TaskDesc, BFinish, WATType, WFAssnTo, ULNF FROM ViewWFTasks "
					sSQL = sSQL & "WHERE ((WFActive <> 0) AND (WATActive <> 0)) AND (WFAssnTo <> " & curEID & ") ORDER BY BFinish, TaskID"
			
					Set rsToDo = GetADORecordset(sSQL, Nothing)
					
					If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then
					
						sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Open Workflow Tasks</font></strong></td>"
						sRet = sRet & vbCrLf & "  </tr>"
						sRet = sRet & vbCrLf & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Task ID</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Assigned To</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
						sRet = sRet & vbCrLf & "      </tr>"
						
						rsToDo.MoveFirst
						
						Do
							If Not IsNull(rsToDo("TaskID")) Then
							
							
							sLink = "<a href='../../WorkFlowManagement/WFTaskInformation.aspx?SID=" & Session("SI") & "&RFTP=" & rsToDo("RefType") &  "&RFID=" & rsToDo("RefNum") & "&TID=" & rsToDo("WATID") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"
									
							'sLink = sLink & vbCrLf & "<a href='../../WorkFlowManagement/WFTaskInformationReview.aspx?SID=" & Session("SI") & "&RFTP=" & rsToDo("RefType") &  "&RFID=" & rsToDo("RefNum") & "&TID=" & rsToDo("WATID") & "' target='_top'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
							
							sLink = sLink & vbCrLf & "<a href='../../WorkFlowManagement/WFTaskInformationReview.aspx?SID=" & Session("SI") & "&RFTP=" & rsToDo("RefType") &  "&RFID=" & rsToDo("RefNum") & "&TID=" & rsToDo("WATID") & "' target='_top'><img src='../graphics/clock.gif' alt='Update' border='0' WIDTH='18' HEIGHT='18'></a>"
																
								sRet = sRet & vbCrLf & "      <tr>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("TaskID") & "</strong></font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("BFinish") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ULNF") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("TaskDesc") & "</font></td>"
								sRet = sRet & vbCrLf & "      </tr>"
								
							End If
							rsToDo.MoveNext
						Loop Until rsToDo.EOF
						
						sRet = sRet & vbCrLf & "    </table>"
						sRet = sRet & vbCrLf & "    </td>"
						sRet = sRet & vbCrLf & "  </tr>"
					Else
						sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Open Workflow Tasks found</font></td>"
						sRet = sRet & vbCrLf & "  </tr>"
					End If
					rsToDo.Close
					
					
					
					'=============================
					'List Open Changes
					'=============================
					sSQL = "SELECT CO, ChDue, ChAssignTo, Priority, ChangeDesc FROM ViewChanges "
					sSQL = sSQL & "WHERE (ChStatus <> 'CLS') AND (ChStatus <> 'REL') AND (ChStatus <> 'REJ') "
					sSQL = sSQL & "AND (ChAssignTo <> '" & curUN & "')"
			
					Set rsToDo = GetADORecordset(sSQL, Nothing)
					
					If Not ((rsToDo.BOF = True) And (rsToDo.EOF = True)) Then
					
						sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%' align='center' bgcolor='#C0C0C0'><strong><font face='Verdana'>Open Changes</font></strong></td>"
						sRet = sRet & vbCrLf & "  </tr>"
						sRet = sRet & vbCrLf & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%'><table border='0' cellpadding='2' width='100%'>"
						sRet = sRet & vbCrLf & "      <tr>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1'></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Change Num</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Due</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Assigned To</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Priority</strong></font></td>"
						sRet = sRet & vbCrLf & "        <td bgcolor='#C0C0C0'><font face='Verdana' size='1' color='#FFFFFF'><strong>Description</strong></font></td>"
						sRet = sRet & vbCrLf & "      </tr>"
						
						rsToDo.MoveFirst
						Do
							If Not IsNull(rsToDo("CO")) Then
							
							sLink = "<a href='../../ChangeManagement/ChangeOrders.aspx?SID=" & Session("SI") & "&COID=" & rsToDo("CO") & "' target='_top'><img src='../graphics/find.gif' width='18' height='18' alt='Open' border='0'></a>"
							
							
								
								
								'sLink = sLink & "<a href='req_change1.asp?RT=CR&CR=" & rsToDo("CO") & "' target='_top'><img src='../graphics/open.gif' width='18' height='18' alt='Edit' border='0'></a>"
								
								
								sRet = sRet & vbCrLf & "      <tr>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & sLink & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><strong>" & rsToDo("CO") & "</strong></font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ChDue") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ChAssignTo") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("Priority") & "</font></td>"
								sRet = sRet & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & rsToDo("ChangeDesc") & "</font></td>"
								sRet = sRet & vbCrLf & "      </tr>"
							End If
							rsToDo.MoveNext
						Loop Until rsToDo.EOF
						
						sRet = sRet & vbCrLf & "    </table>"
						sRet = sRet & vbCrLf & "    </td>"
						sRet = sRet & vbCrLf & "  </tr>"
					Else
						sRet = IIf(sRet <> "", sRet & vbCrLf, "") & "  <tr>"
						sRet = sRet & vbCrLf & "    <td width='100%' bgcolor='#C0C0C0'><font face='Verdana'>No Open Changes found </font></td>"
						sRet = sRet & vbCrLf & "  </tr>"
					End If
					rsToDo.Close
			  End Select
			End If			
			'=============================
			'No Records found
			'=============================
			If (sRet <> "") Then
				sRet = "<table border='0' cellpadding='2' width='635' cellspacing='2'>" & vbCrLf & sRet & vbCrLf & "</table>"
			Else
				sRet = "<p><font face='Verdana' size='3'><strong>NO CURRENT RECORDS AVAILABLE</strong></font></p>"
				sRet = sRet & "<p><font face='Verdana' size='2'>This resource cannot be provided at the present time.</font></p>"
			End If
			
			Set rsToDo = Nothing
		Case Else
			sRet = "<p><font face='Verdana' size='3'><strong>NOT CURRENTLY AVAILABLE</strong></font></p>"
			sRet = sRet & "<p><font face='Verdana' size='2'>This resource cannot be provided at the present time.</font></p>"
	End Select
	
	GetRpt = sRet
End Function


'--------------------------------------
'GetReport
'--------------------------------------
Function GetReport(vItem, sItemVal)
	Dim sBody
	Dim nSessID
	Dim rsItem
	
	'If (SVars = "") Then
	'	If (Request.QueryString <> "") Then
	'		SVars = "SI=" & Request.QueryString("SI") & "&M=" & Request.QueryString("M")
	'	End If
	'End If
	
	Select Case vItem
		Case "List"
			nSessID = IIf(Session("SI") <> "", Session("SI"), "0")
            Set rsItem = GetADORecordset("SELECT * FROM QReports WHERE ProfileID = " & curSG & " ORDER BY Name", Nothing)
            'Set rsItem = GetADORecordset("SELECT * FROM QReports ORDER BY Name", Nothing)

            If Not ((rsItem.BOF = True) And (rsItem.EOF = True)) Then
				sBody  = "    <table width='500' cellpadding='0' cellspacing='0' border='0'>"
				sBody  = sBody & vbCrLf & "      <tr>"    		
				sBody  = sBody & vbCrLf & "        <td>"
				sBody  = sBody & vbCrLf & "        <ul>"
				While Not (rsItem.EOF = True)
					sBody = sBody & vbCrLf & "        <li><a href='view_reports.asp?A=S&ReportID=" & rsItem("ReportID") & "'>" & rsItem("Name") & "</a></li>"
					rsItem.MoveNext
				Wend
				sBody  = sBody & vbCrLf & "        </ul>"
				sBody  = sBody & vbCrLf & "        </td>"
				sBody  = sBody & vbCrLf & "      </tr>"    		
				sBody  = sBody & vbCrLf & "    </table>"    		
			End If
		Case "Search"
			sBody = "    <div align='center'><form method='post' action='view_reports.asp?A=G'>"
			sBody = sBody & vbCrLf & "      <input type='hidden' name='ReportID' value='" & sItemVal & "'>"
            Set rsFields = GetADORecordset("SELECT * FROM ReportFields WHERE ReportID = " & sItemVal & " ORDER BY LongName", Nothing)           
            If Not ((rsFields.BOF = True) And (rsFields.EOF = True)) Then
				sBody = sBody & vbCrLf & "    <table width='300' cellpadding='5' cellspacing='0' border='0'>"
				While Not (rsFields.EOF = True)
					sBody = sBody & vbCrLf & "      <tr>"    		
					sBody = sBody & vbCrLf & "        <td align='right'>" & rsFields("LongName") & ":</td>"
					sBody = sBody & vbCrLf & "        <td align='left'>"
					sBody = sBody & vbCrLf & "        <select name='" & rsFields("Field") & "'>"
					Set rsValues = GetADORecordset("SELECT * FROM ReportValues WHERE FieldID = " & rsFields("FieldID") & " ORDER BY LongName", Nothing)			   
					While Not (rsValues.EOF = True)
						sBody = sBody & vbCrLf & "        <option value='" & rsValues("Value") & "'>" & rsValues("LongName") & "</option>"
						rsValues.MoveNext
					Wend
					sBody = sBody & vbCrLf & "        </select>"
					sBody = sBody & vbCrLf & "        </td>"
					sBody = sBody & vbCrLf & "      </tr>"    		
					rsFields.MoveNext
				Wend
				sBody = sBody & vbCrLf & "    </table>"    		
			Else
				sBody = "<font face='Verdana, Arial, Helvetica, sans-serif'>No search fields are available for this report.</font>"   
			End If		  		
			'sBody = sBody & "    <br><input type='submit' name='Submit' value='View Online'> <input type='submit' name='Submit' value='Download CSV'>"
			sBody = sBody & vbCrLf & "    <br><input type='submit' name='Submit' value='Download CSV'>"
			sBody = sBody & vbCrLf & "    </form></div>"    		
	End Select
		
	GetReport = sBody
End Function







'--------------------------------------
'GetHTMLBody
'--------------------------------------
Function GetHTMLBody(vTag)
    Dim sBody
    
    Select Case vTag
        Case "SuppCont", "SuppLinks"
            sBody = "    <hr noshade color='#808000'>" 
			sBody = sBody & "    <p align='center'><font face='Verdana' size='6'><strong>ERMS</strong><em>Web</em></font><font face='Verdana' size='2'><br>" 
			sBody = sBody & "    <strong>Engineering Resource Management System - Version 4.2<br>" 
			sBody = sBody & "    </strong></font><font face='Verdana' size='1'>©2001-2005, Desktop Devices. All Rights Reserved.</font></p>" 
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



'--------------------------------------
'GetSelItemInfo
'--------------------------------------
Function GetSelItemInfo(vItem, sItemVal, vOpt)
    Dim sItem
    Dim sList
    Dim sLink
    Dim rsItem
    Dim rsItemDetail
    Dim sSQL
    
    Dim curID
    Dim val1, val2, val3, val4, val5, val6, val7, val8, val9, val10
    Dim val11, val12, val13, val14, val15, val16, val17, val18, val19, val20
    Dim aVals
    Dim x, y
    
    Select Case vItem
        Case "Doc"
			val3 = GetDataValue("SELECT EmpID AS RetVal FROM EWebSessions WHERE (SessionID = " & Session("SI") & ")", Nothing)
			val1 = VerifyRec(vItem, sItemVal)
			If (val1 = True) Then
				val4 = GetDataValue("SELECT DocType AS RetVal FROM Documents WHERE (DocID='" & sItemVal & "')", Nothing)
				If (Application("Company") = "Micropac") Then
					val6 = GetDataValue("SELECT Tabulated AS RetVal FROM Documents WHERE (DocID='" & sItemVal & "')", Nothing)
					If (val6 = "True") Then
						val6 = "<a href='glov_bomview.asp?BP=" & sItemVal & "' target='_blank'>DISPLAY BILLS OF MATERIAL REPORT</a>"
					Else
						val6 = ""
					End If
				Else
					val6 = ""
				End If
				
				sItem = "<div><table border='0' width='635' cellpadding='2' cellspacing='1'>"
				sItem = sItem & vbCrLf & GetInfoSection("DocRestrictions", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("DocInfo", sItemVal, "", "")
				If (val6 <> "") Then
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & val6 & "</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
				End If
				sItem = sItem & vbCrLf & GetInfoSection("DocFiles", sItemVal, "", val3)
				sItem = sItem & vbCrLf & GetInfoSection("DocProc", sItemVal, "", "")
				
				If (vOpt = "") Then
					'sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=1000'>DISPLAY RELATED PARTS</a>"
					'sItem = sItem & vbCrLf & "      <tr>"
					'sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
					'sItem = sItem & vbCrLf & "      </tr>"
					sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=0100'>DISPLAY DOCUMENT HISTORY</a>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=0010'>DISPLAY NOTES</a>"
					sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
					sItem = sItem & vbCrLf & "      </tr>"
					Select Case val4
						Case "484", "485", "486"
							val4 = GetDataValue("SELECT RefID AS RetVal FROM CustomUDF WHERE (RefType = 'DOC') AND (RefID = '" & sItemVal & "') AND (UDF7 = True)", Nothing)
							If (val4 <> "") Then
								sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=0001'>PART NUMBERS AND PHYSICAL PARAMETERS</a>"
								sItem = sItem & vbCrLf & "      <tr>"
								sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
								sItem = sItem & vbCrLf & "      </tr>"
							End If
					End Select
				Else
					'If (Left(vOpt, 1) = "0") Then
					'	val2 =  "1" & Right(vOpt, Len(vOpt) - 1)
					'	sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=" & val2 & "'>DISPLAY RELATED PARTS</a>"
					'	sItem = sItem & vbCrLf & "      <tr>"
					'	sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
					'	sItem = sItem & vbCrLf & "      </tr>"
					'Else
					'	sItem = sItem & vbCrLf & GetInfoSection("DocParts", sItemVal, "", "")
					'End If
					If (Mid(vOpt, 2,1) = "0") Then
						val2 = Left(vOpt, 1) & "1" & Right(vOpt, Len(vOpt) - 2)
						sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=" & val2 & "'>DISPLAY DOCUMENT HISTORY</a>"
						sItem = sItem & vbCrLf & "      <tr>"
						sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
						sItem = sItem & vbCrLf & "      </tr>"
					Else
						sItem = sItem & vbCrLf & GetInfoSection("DocHistory", sItemVal, vOpt, "")
					End If
					'If (Mid(vOpt, 3,1) = "0") Then
					'	val2 = Left(vOpt, 2) & "1" & Right(vOpt, Len(vOpt) - 3)
					'	sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=" & val2 & "'>DISPLAY NOTES</a>"
					'	sItem = sItem & vbCrLf & "      <tr>"
					'	sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
					'	sItem = sItem & vbCrLf & "      </tr>"
					'Else
						sItem = sItem & vbCrLf & GetInfoSection("Notes", sItemVal, "DOC", "")
					'End If
					Select Case val4
						Case "484", "485", "486"
							val5 = GetDataValue("SELECT RefID AS RetVal FROM CustomUDF WHERE (RefType = 'DOC') AND (RefID = '" & sItemVal & "') AND (UDF7 = True)", Nothing)
							If (val5 <> "") Then
								If (Mid(vOpt, 4,1) = "0") Then
									val2 = Left(vOpt, 3) & "1"
									sLink = "<a href='ret_selitem.asp?Listing=Doc&Item=" & sItemVal & "&Opt=" & val2 & "'>PART NUMBERS AND PHYSICAL PARAMETERS</a>"
									sItem = sItem & vbCrLf & "      <tr>"
									sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
									sItem = sItem & vbCrLf & "      </tr>"
								Else
									sItem = sItem & vbCrLf & GetInfoSection("DocElem", sItemVal, val4, "")
								End If
							End If
					End Select
				End If
				
				sItem = sItem & vbCrLf & GetInfoSection("Workflow", sItemVal, "DOC", "")
				
				'val2 = GetDataValue("SELECT DocType AS RetVal FROM Documents WHERE (DocID='" & sItemVal & "')", Nothing)
				'Select Case val2
				'	Case "484", "485", "486"
				'		val2 = GetDataValue("SELECT RefID AS RetVal FROM CustomUDF WHERE (RefType = 'DOC') AND (RefID = '" & sItemVal & "') AND (UDF7 = True)", Nothing)
				'		If (val2 <> "") Then
				'			'sLink = "<a href='ret_doc_info.asp?Item=" & sItemVal & "'>Click here for more document information...</a>"
				'			sLink = "<a href='ret_doc_info.asp?Item=" & sItemVal & "'>Part Numbers And Physical Parameters</a>"
				'			sItem = sItem & vbCrLf & "      <tr>"
				'			sItem = sItem & vbCrLf & "        <td width='100%'><font face='Verdana' size='2'><strong>" & sLink & "</strong></font></td>"
				'			sItem = sItem & vbCrLf & "      </tr>"
				'		End If
				'End Select
				sItem = sItem & vbCrLf & "</table></div>"
			Else
				sItem = "<p><font face='Verdana' size='3'>NO DATA RETURNED</font></p>"
			End If
        'Case "DocElement"
		'	val1 = GetDataValue("SELECT DocType AS RetVal FROM Documents WHERE (DocID='" & sItemVal & "')", Nothing)
		'	Set rsItem = GetADORecordset("SELECT * FROM PartPar WHERE (DocID = '" & sItemVal & "') ORDER BY PartNo", Nothing)
		'	UserProfileID = GetUserInfoItem(curSID, "ProfileID")	
				
		'	sItem = sItem & vbCrLf & "<br>"
		'	sItem = sItem & "<div><table border='0' width='625' cellpadding='2' cellspacing='0'>"
		'	sItem = sItem & vbCrLf & "  <tr>"
		'	sItem = sItem & vbCrLf & "    <td><table border='0' width='100%' cellpadding='2'>"
		'	sItem = sItem & vbCrLf & "      <tr>"
		'	sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='4'><strong><span style='text-decoration: underline'>Part Numbers And Physical Parameters</span></strong></font></td>"
		'	sItem = sItem & vbCrLf & "      </tr>"
		'	sItem = sItem & vbCrLf & "    </table>"
		'	sItem = sItem & vbCrLf & "    </td>"
		'	sItem = sItem & vbCrLf & "  </tr>"
		'	sItem = sItem & vbCrLf & "  <tr>"
		'	sItem = sItem & vbCrLf & "    <td><table border='0' width='100%' cellpadding='2' cellspacing='0'>"
		'	sItem = sItem & vbCrLf & "      <tr bgcolor='#D7D7D7'>"
		'	sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>Part No.</strong></font></td>"
		'	sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>Thick w/ Barr.</strong></font></td>"
		'	sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>" & IIf((val1 = "485") Or (val1 = "486"), "Wafer P/N", "Ingot P/N") & "</strong></font></td>"			
		'	sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>Qty</strong></font></td>"
		'	If (val1 = "484") Then
		'		sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>Wafer Dia</strong></font></td>"
		'	End If
		'	sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>" & IIf((val1 = "485") Or (val1 = "486"), "Size", "Slice Form.") & "</strong></font></td>"			
		'	If ((val1 = "485") Or (val1 = "486")) Then			
		'		sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>Traveler</strong></font></td>"
		'	End If
			'If (UserProfileID = 5) Then ' Document Control User
			'	sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='1'><strong>Delete?</strong></font></td>"
			'End If
		'	sItem = sItem & vbCrLf & "      </tr>"
			'sItem = sItem & vbCrLf & "      <tr><td colspan='5'>&nbsp;</td></tr>"
		
		'	SVars = "Item=" & Request.QueryString("Item")
			
		'	While Not rsItem.EOF
		'		sItem = sItem & vbCrLf & "      <tr>"
		'		sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("PartNo") & "</font></td>"
		'		Thickness = Mid(rsItem("Par5"), InStr(rsItem("Par5"), ".") + 1)
		'		Thickness = "." + Thickness + String(4 - Len(Thickness), "0")
		'		sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & Thickness & " +/- " & rsItem("Par6") & "</font></td>"
		'		sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("MatlPn") & "</font></td>"
		'		sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("Par7") & "</font></td>"
		'		If (val1 = "484") Then
		'			sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & rsItem("Par10") & "</font></td>"
		'		End If
		'		sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='2'>" & IIf((val1 = "485") Or (val1 = "486"), rsItem("Par1") & " x " & rsItem("Par3"), rsItem("Par11")) & "</font></td>"
		'		If ((val1 = "485") Or (val1 = "486")) Then							
		'			sItem = sItem & vbCrLf & "        <td align='center'>" & IIf(Not rsItem("Par1") = "0", "<font face='Verdana' size='2'><a href='#' onClick=""window.open('pnt_traveler.asp?PartID=" & rsItem("PartID") & "', 'wndTraveler' ,'width=770,height=500,menubar=yes,scrollbars=yes'); return false;"">View</a></font>", "&nbsp;") & "</td>"
		'		End If
				'If (UserProfileID = 5) Then ' Document Control User
				'	sItem = sItem & vbCrLf & "        <td align='center'><font face='Verdana' size='2'><strong><a href='ret_doc_info.asp?A=D&PartID=" & rsItem("PartID") & "'>Delete</a></strong></font></td>"
				'End If
		'		sItem = sItem & vbCrLf & "      </tr>"
		'		rsItem.MoveNext
		'	Wend
				
		'	sItem = sItem & vbCrLf & "    </table>"
		'	sItem = sItem & vbCrLf & "    </td>"
		'	sItem = sItem & vbCrLf & "  </tr>"
			
		'	If (UserProfileID = 5) Then ' Document Control User
				'sItem = sItem & vbCrLf & "  <tr><td colspan='5'><p>&nbsp;</p></td></tr>"
		'		sItem = sItem & vbCrLf & "  <tr>"
		'		sItem = sItem & vbCrLf & "    <td align='center'>"
		'		If (val1 = "484") Then
					'sItem = sItem & vbCrLf & "      <input type='button' name='AddWafer' value='Add Wafer' onClick='window.open(""mod_wafer.asp?DocID=" & Request.QueryString("Item") & """, ""wndWafer"", ""menubar=no, width=600, height=250"")'> "
		'			sItem = sItem & vbCrLf & "      <input type='button' name='AddWafer' value='Add Wafer' onClick=""window.open('mod_wafer.asp?DocID=" & Request.QueryString("Item") & "', 'wndWafer', 'menubar=no, width=600, height=250')""> "
		'		ElseIf ((val1 = "485") Or (val1 = "486")) Then
					'sItem = sItem & vbCrLf & "      <input type='button' name='AddElement' value='Add Element' onClick='window.open(""mod_element.asp?DocID=" & Request.QueryString("Item") & """, ""wndWafer"", ""menubar=no, width=600, height=250"")'> "
		'			sItem = sItem & vbCrLf & "      <input type='button' name='AddElement' value='Add Element' onClick=""window.open('mod_element.asp?DocID=" & Request.QueryString("Item") & "', 'wndWafer', 'menubar=no, width=600, height=250')""> "
		'		End If
		'		sItem = sItem & vbCrLf & "    </td>"
		'		sItem = sItem & vbCrLf & "  </tr>"
		'	End If
				
		'	sItem = sItem & vbCrLf & "    </table>"
		'	sItem = sItem & vbCrLf & "    </td>"
		'	sItem = sItem & vbCrLf & "  </tr>"
		'	sItem = sItem & vbCrLf & "</table></div>"
		'	rsItem.Close
        Case "Change"
			val3 = GetDataValue("SELECT EmpID AS RetVal FROM EWebSessions WHERE (SessionID = " & Session("SI") & ")", Nothing)
			val1 = VerifyRec(vItem, sItemVal)
			If (val1 = True) Then
				sItem = "<div><table border='0' width='635' cellpadding='2' cellspacing='1'>"
				sItem = sItem & vbCrLf & GetInfoSection("ChangeInfo", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("ChangeProc", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("ChangeDocs", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("Att", sItemVal, "COA", val3)
				sItem = sItem & vbCrLf & GetInfoSection("ChangeMDisp", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("Notes", sItemVal, "CO", "")
				sItem = sItem & vbCrLf & GetInfoSection("Workflow", sItemVal, "CO", "")
				sItem = sItem & vbCrLf & "</table></div>"
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case "Order"
			val1 = VerifyRec(vItem, sItemVal)
			If (val1 = True) Then
				sItem = "<div><table border='0' width='635' cellpadding='2' cellspacing='1'>"
				sItem = sItem & vbCrLf & GetInfoSection("OrderInfo", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("OrderSched", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("OrderLines", sItemVal, "", "")
				sItem = sItem & vbCrLf & "</table></div>"
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
						val4 = "<a href='../../DocumentManagement/DocInformation.aspx?SID=" & Session("SI") & "&DOCID=" & rsItem("DocID") & "' target='_top'>" & rsItem("DocID") & "</a>" 
					End If
					val5 = IIf(IsNull(rsItem("FileID")), "-", rsItem("FileID"))
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
					If (sLink <> "") Then
						val5 = sLink & val5 & "</a>"
					End If
					val6 = IIf(rsItem("FAI") = 0, "COMPLETED", "REQUESTED")
					val7 = IIf(IsNull(rsItem("FAIDate")), "-", rsItem("FAIDate"))
					val8 = IIf(IsNull(rsItem("EffDate")), "-", rsItem("EffDate"))
					If (rsItem("PLoc") = "LAN") Then
						val9 = ""
					Else
						val9 = "<a href='q_printreq.asp?FID=" & rsItem("FileID") & "'>"
					End If
					val10 = IIf(IsNull(rsItem("RType")), "-", rsItem("RType"))
					If (IsNull(rsItem("ParentPartNo"))) Then
						val11 = "-"
					Else
						val11 = "<a href='ret_selitem.asp?Listing=Part&Item=" & rsItem("ParentPartNo") & "'>" & rsItem("ParentPartNo") & "</a>"
					End If
					val12 = IIf(IsNull(rsItem("PartDesc")), "-", rsItem("PartDesc"))
					val13 = IIf(IsNull(rsItem("FileName")), "-", rsItem("FileName"))
					val14 = IIf(IsNull(rsItem("PrintSize")), "-", rsItem("PrintSize"))
					
					sItem = "<div><table border='0' width='635' cellpadding='2' cellspacing='1'>"
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
								val15 = "<a href='ret_selitem.asp?Listing=Order&Item=" & rsItemDetail("OrderID") & "'>" & IIf(IsNull(rsItemDetail("OrderNum")), "-", rsItemDetail("OrderNum")) & "</a>"
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
					'val2 = IIf(IsNull(rsItem("MSProjFile")), "", rsItem("MSProjFile"))
					'If (val2 <> "") Then
					'	sLink = val2
					'	sLink = Replace(sLink, "\", "/", 1, -1, vbTextCompare)
					'	sLink = "<a href='FILE:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink & "' target = '_blank'>"
					'Else
					'	sLink = ""
					'	val2 = "-"
					'End If
					'If (sLink <> "") Then
					'	val2 = sLink & val2 & "</a>"
					'End If
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
					
					sItem = "<div><table border='0' width='635' cellpadding='2' cellspacing='1'>"
					sItem = sItem & vbCrLf & "  <tr>"
					sItem = sItem & vbCrLf & "    <td width='100%' bgcolor='#808000'><font face='Verdana' color='#FFFF00'><strong>Project:</strong> " & IIf(IsNull(rsItem("Project")), "-", rsItem("Project")) & "&nbsp;</font></td>"
					sItem = sItem & vbCrLf & "  </tr>"
					sItem = sItem & vbCrLf & "  <tr>"
					'sItem = sItem & vbCrLf & "    <td width='100%'><table border='0' width='100%' cellpadding='2'>"
					'sItem = sItem & vbCrLf & "      <tr>"
					sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Status:</strong> " & val1 & "&nbsp;</font></td>"
					'sItem = sItem & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Project DB:</strong> " & val2 & "&nbsp;</font></td>"
					'sItem = sItem & vbCrLf & "      </tr>"
					'sItem = sItem & vbCrLf & "    </table>"
					'sItem = sItem & vbCrLf & "    </td>"
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
					sItem = "<div><table border='0' width='635' cellpadding='2' cellspacing='1'>"
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
            val3 = GetDataValue("SELECT EmpID AS RetVal FROM EWebSessions WHERE (SessionID = " & Session("SI") & ")", Nothing)
			val1 = VerifyRec(vItem, sItemVal)
			If (val1 = True) Then
				sItem = "<div><table border='0' width='635' cellpadding='2' cellspacing='1'>"
				sItem = sItem & vbCrLf & GetInfoSection("TaskInfo", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("TaskAssn", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("TaskSched", sItemVal, "", "")
				sItem = sItem & vbCrLf & GetInfoSection("Att", sItemVal, "TA", val3)
				sItem = sItem & vbCrLf & GetInfoSection("Notes", sItemVal, "TASK", "")
				sItem = sItem & vbCrLf & "</table></div>"
			Else
				sItem = "<p><font face='Verdana' size='3'><strong>NO DATA RETURNED</strong></font></p>"
			End If
        Case Else
            sItem = ""
    End Select
    
    'rsItem.Close
    Set rsItem = Nothing
    
    GetSelItemInfo = sItem
End Function

%>

