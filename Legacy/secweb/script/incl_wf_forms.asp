<%

Function GetUTaskForm(sM, nTask, sType)
	Dim sRForm
	Dim oRS
	Dim sCMD
	Dim sTemp
	Dim sLink
	
	Select Case sM
		Case "R"
			Select Case sType
				Case "APPR"
					'===========================================================================================
					'=		Provides a single step interface for approval processes. 
					'=		All date information handled automatically. 
					'=		Provide automatic status and completion updates.
					'===========================================================================================
					'=		• Approve - Move forward
					'=		• Deny - Move back (pre-approval) to make changes
					'=		• Reject - Verify rejection with parallel approvals before updating or purging associated tasks
					'===========================================================================================
					sCMD = "SELECT TaskID, RefType, RefNum, TaskStatus, Status, TaskDesc, WATID "
					sCMD = sCMD & "FROM ViewWFTasks WHERE (TaskID = " & nTask & ")"
					
					Set oRS = GetADORecordset(sCMD, Nothing)
					If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
						oRS.MoveFirst
						sRForm = "    <form method='POST' action='wf_upd_task.asp'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='S'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='AType' value='A'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & nTask & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WATID' value='" & oRS("WATID") & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WFR' value='" & oRS("RefType") & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WFRID' value='" & oRS("RefNum") & "'>"
						sRForm = sRForm & vbCrLf & "      <div align='center'><center><table class='mt-4' border='1' cellpadding='2' cellspacing='0' width='100%'>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Task Information</strong></font></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td valign='top'><table border='0' cellpadding='2' width='100%'>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Task ID:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & nTask & "</font></td>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
						'sRForm = sRForm & vbCrLf & "              <td><select name='D1' size='1'>"
						'sRForm = sRForm & vbCrLf & "              </select></td>"
						sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & oRS("Status") & "</font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sTemp = ""
						Select Case oRS("RefType")
							Case "CO"
								sTemp = "<a href='pnt_selitem.asp?Listing=Change&Item=" & oRS("RefNum") & "' target='_blank'>Change Order: " & oRS("RefNum") & "</a>"
							Case "DOC"
								sTemp = "<a href='pnt_selitem.asp?Listing=Doc&Item=" & oRS("RefNum") & "' target='_blank'>Document: " & oRS("RefNum") & "</a>"
							Case "MDISP"
								'sTemp = "<a href='pnt_selitem.asp?Listing=MDisp&Item=" & oRS("RefNum") & "' target='_blank'>Material Disposition: " & oRS("RefNum") & "</a>"
								sTemp = "Material Disposition: " & oRS("RefNum")
							Case "TASK"
								sTemp = "<a href='pnt_selitem.asp?Listing=Task&Item=" & oRS("RefNum") & "' target='_blank'>Task: " & oRS("RefNum") & "</a>"
							Case "PROJ"
								sTemp = "<a href='pnt_selitem.asp?Listing=Project&Item=" & oRS("RefNum") & "' target='_blank'>Project: " & oRS("RefNum") & "</a>"
							Case "CAR"
								sTemp = "<a href='pnt_selitem.asp?Listing=QAction&Item=" & oRS("RefType") & ";" & oRS("RefNum") & "' target='_blank'>Corrective Action: " & oRS("RefNum") & "</a>"
							Case "NCR"
								sTemp = "<a href='pnt_selitem.asp?Listing=QAction&Item=" & oRS("RefType") & ";" & oRS("RefNum") & "' target='_blank'>Non-Conformance Report: " & oRS("RefNum") & "</a>"
						End Select
						If (sTemp <> "") Then
							sRForm = sRForm & vbCrLf & "            <tr>"
							sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Workflow Ref.:</strong></font></td>"
							sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font></td>"
							sRForm = sRForm & vbCrLf & "            </tr>"
						End If
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Approval:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'><strong><input type='radio' name='WFA' value='APP' checked>Approve<br>"
						sRForm = sRForm & vbCrLf & "              <input type='radio' class='my-2' name='WFA' value='REJ'>Reject<br>"
						sRForm = sRForm & vbCrLf & "              <input type='radio' name='WFA' value='BAK'>Deny</strong> <em>(Changes required)</em><strong></strong></font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Notes:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><textarea rows='4' name='TNotes' cols='45' wrap='physical'></textarea></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='center' colspan='4'><input type='submit' class='save-btn' value='Update Task' name='B1'> <input  class='save-btn' type='submit' value='Cancel' name='B1'></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "          </table>"
						sRForm = sRForm & vbCrLf & "          </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "      </table>"
						sRForm = sRForm & vbCrLf & "      </center></div>"
						sRForm = sRForm & vbCrLf & "    </form>"
						oRS.Close
					End If
					Set oRS = Nothing
				Case "REVW"
					sCMD = "SELECT TaskID, RefType, RefNum, TaskStatus, Status, TaskDesc, WATID "
					sCMD = sCMD & "FROM ViewWFTasks WHERE (TaskID = " & nTask & ")"
					
					Set oRS = GetADORecordset(sCMD, Nothing)
					If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
						oRS.MoveFirst
						sRForm = "    <form method='POST' action='wf_upd_task.asp'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='S'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='AType' value='R'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & nTask & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WATID' value='" & oRS("WATID") & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WFR' value='" & oRS("RefType") & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WFRID' value='" & oRS("RefNum") & "'>"
						sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='1' cellpadding='2' cellspacing='0' width='100%'>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Task Information</strong></font></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td valign='top'><table border='0' cellpadding='2' width='100%'>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='right'><font face='Verdana' size='2'><strong>Task ID:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & nTask & "</font></td>"
						sRForm = sRForm & vbCrLf & "              <td align='right'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
						'sRForm = sRForm & vbCrLf & "              <td><select name='D1' size='1'>"
						'sRForm = sRForm & vbCrLf & "              </select></td>"
						sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & oRS("Status") & "</font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='right'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sTemp = ""
						Select Case oRS("RefType")
							Case "CO"
								sTemp = "<a href='pnt_selitem.asp?Listing=Change&Item=" & oRS("RefNum") & "' target='_blank'>Change Order: " & oRS("RefNum") & "</a>"
							Case "DOC"
								sTemp = "<a href='pnt_selitem.asp?Listing=Doc&Item=" & oRS("RefNum") & "' target='_blank'>Document: " & oRS("RefNum") & "</a>"
							Case "MDISP"
								'sTemp = "<a href='pnt_selitem.asp?Listing=MDisp&Item=" & oRS("RefNum") & "' target='_blank'>Material Disposition: " & oRS("RefNum") & "</a>"
								sTemp = "Material Disposition: " & oRS("RefNum")
							Case "TASK"
								sTemp = "<a href='pnt_selitem.asp?Listing=Task&Item=" & oRS("RefNum") & "' target='_blank'>Task: " & oRS("RefNum") & "</a>"
							Case "PROJ"
								sTemp = "<a href='pnt_selitem.asp?Listing=Project&Item=" & oRS("RefNum") & "' target='_blank'>Project: " & oRS("RefNum") & "</a>"
							Case "CAR"
								sTemp = "<a href='pnt_selitem.asp?Listing=QAction&Item=" & oRS("RefType") & ";" & oRS("RefNum") & "' target='_blank'>Corrective Action: " & oRS("RefNum") & "</a>"
							Case "NCR"
								sTemp = "<a href='pnt_selitem.asp?Listing=QAction&Item=" & oRS("RefType") & ";" & oRS("RefNum") & "' target='_blank'>Non-Conformance Report: " & oRS("RefNum") & "</a>"
						End Select
						If (sTemp <> "") Then
							sRForm = sRForm & vbCrLf & "            <tr>"
							sRForm = sRForm & vbCrLf & "              <td align='right'><font face='Verdana' size='2'><strong>Workflow Ref.:</strong></font></td>"
							sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font></td>"
							sRForm = sRForm & vbCrLf & "            </tr>"
						End If
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='right'><font face='Verdana' size='2'><strong>Review:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'><strong><input type='radio' name='WFA' value='APP' checked>Approve<br>"
						sRForm = sRForm & vbCrLf & "              <input type='radio' name='WFA' value='BAK'>Deny</strong> <em>(Changes required)</em><strong></strong></font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='right'><font face='Verdana' size='2'><strong>Notes:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><textarea rows='4' name='TNotes' cols='45' wrap='physical'></textarea></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='center' colspan='4'><input type='submit' value='Update Task' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "          </table>"
						sRForm = sRForm & vbCrLf & "          </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "      </table>"
						sRForm = sRForm & vbCrLf & "      </center></div>"
						sRForm = sRForm & vbCrLf & "    </form>"
						oRS.Close
					End If
					Set oRS = Nothing
				Case "TASK"
					sCMD = "SELECT TaskID, RefType, RefNum, TaskStatus, Status, TaskDesc, WATID, "
					sCMD = sCMD & "PlannedStart, PlannedFinish, ActualStart, ActualFinish, OverrunEstFinish, BFinish, PcntComplete, "
					sCMD = sCMD & "WATSchedAdj, WATAdjPStart, WATAdjPFinish, WATAdjAStart, WATAdjAFinish, WATAdjOFinish, "
					sCMD = sCMD & "EstHours, OverrunHrs, BHrs, ActualHours, EstCost, OvrCost, BMCost, ActualCost "
					sCMD = sCMD & "FROM ViewWFTasks WHERE (TaskID = " & nTask & ")"
					
					Set oRS = GetADORecordset(sCMD, Nothing)
					If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
						oRS.MoveFirst
						sRForm = "    <form method='POST' action='wf_upd_task.asp'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='S'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='AType' value='T'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & nTask & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WATID' value='" & oRS("WATID") & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WFR' value='" & oRS("RefType") & "'>"
						sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WFRID' value='" & oRS("RefNum") & "'>"
						sRForm = sRForm & vbCrLf & "      <div align='center'><center><table class='mt-3' border='1' cellpadding='2' cellspacing='0' width='100%'>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Task Information</strong></font></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td valign='top'><table border='0' cellpadding='2' width='100%'>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Task ID:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & nTask & "</font></td>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
						'sRForm = sRForm & vbCrLf & "              <td><select name='D1' size='1'>"
						'sRForm = sRForm & vbCrLf & "              </select></td>"
						sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & oRS("Status") & "</font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sTemp = ""
						Select Case oRS("RefType")
							Case "CO"
								sTemp = "<a href='pnt_selitem.asp?Listing=Change&Item=" & oRS("RefNum") & "' target='_blank'>Change Order: " & oRS("RefNum") & "</a>"
							Case "DOC"
								sTemp = "<a href='pnt_selitem.asp?Listing=Doc&Item=" & oRS("RefNum") & "' target='_blank'>Document: " & oRS("RefNum") & "</a>"
							Case "MDISP"
								'sTemp = "<a href='pnt_selitem.asp?Listing=MDisp&Item=" & oRS("RefNum") & "' target='_blank'>Material Disposition: " & oRS("RefNum") & "</a>"
								sTemp = "Material Disposition: " & oRS("RefNum")
							Case "TASK"
								sTemp = "<a href='pnt_selitem.asp?Listing=Task&Item=" & oRS("RefNum") & "' target='_blank'>Task: " & oRS("RefNum") & "</a>"
							Case "PROJ"
								sTemp = "<a href='pnt_selitem.asp?Listing=Project&Item=" & oRS("RefNum") & "' target='_blank'>Project: " & oRS("RefNum") & "</a>"
							Case "CAR"
								sTemp = "<a href='pnt_selitem.asp?Listing=QAction&Item=" & oRS("RefType") & ";" & oRS("RefNum") & "' target='_blank'>Corrective Action: " & oRS("RefNum") & "</a>"
							Case "NCR"
								sTemp = "<a href='pnt_selitem.asp?Listing=QAction&Item=" & oRS("RefType") & ";" & oRS("RefNum") & "' target='_blank'>Non-Conformance Report: " & oRS("RefNum") & "</a>"
						End Select
						If (sTemp <> "") Then
							sRForm = sRForm & vbCrLf & "            <tr>"
							sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Workflow Ref.:</strong></font></td>"
							sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font></td>"
							sRForm = sRForm & vbCrLf & "            </tr>"
						End If
						'sLink = ""
						'sRForm = sRForm & vbCrLf & "            <tr>"
						'sRForm = sRForm & vbCrLf & "              <td align='right'><font face='Verdana' size='2'><strong>Controlled Ref.:</strong></font></td>"
						'sRForm = sRForm & vbCrLf & "              <td colspan='3'><font face='Verdana' size='2'>" & oRS("") & " <input type='text' name='T8' size='15'> &#149; <strong>Go to Reference</strong></font></td>"
						'sRForm = sRForm & vbCrLf & "            </tr>"
						
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><table border='0' width='100%'>"
						sRForm = sRForm & vbCrLf & "                <tr>"
						sRForm = sRForm & vbCrLf & "                  <td><strong><font face='Verdana' size='2'>Due: <font color='#FF0000'>" & oRS("BFinish") & "</font></font></strong></td>"
						sRForm = sRForm & vbCrLf & "                  <td bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Planned</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                  <td bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Actual</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                  <td bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Update</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                </tr>"
						sRForm = sRForm & vbCrLf & "                <tr>"
						sRForm = sRForm & vbCrLf & "                  <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Start:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("PlannedStart") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("ActualStart") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td align='left'><font face='Verdana' size='2'><input type='text' name='T1' size='12'></font></td>"
						sRForm = sRForm & vbCrLf & "                </tr>"
						sRForm = sRForm & vbCrLf & "                <tr>"
						sRForm = sRForm & vbCrLf & "                  <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Finish:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("PlannedFinish") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("ActualFinish") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td align='left'><font face='Verdana' size='2'><input type='text' name='T2' size='12'></font></td>"
						sRForm = sRForm & vbCrLf & "                </tr>"
						sRForm = sRForm & vbCrLf & "                <tr>"
						sRForm = sRForm & vbCrLf & "                  <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Overrun:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>&nbsp;</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("OverrunEstFinish") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td align='left'><font face='Verdana' size='2'><input type='text' name='T3' size='12'></font></td>"
						sRForm = sRForm & vbCrLf & "                </tr>"
						sRForm = sRForm & vbCrLf & "                <tr>"
						sRForm = sRForm & vbCrLf & "                  <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Hours:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("EstHours") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("ActualHours") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td align='left'><strong><font face='Verdana' size='1'>Hrs:</font></strong><input type='text' name='T4' size='5'> <font face='Verdana' size='1'><strong>Min:</strong></font><input type='text' name='T6' size='5'></td>"
						sRForm = sRForm & vbCrLf & "                </tr>"
						sRForm = sRForm & vbCrLf & "                <tr>"
						sRForm = sRForm & vbCrLf & "                  <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Cost:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("EstCost") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td><font face='Verdana' size='2'>" & oRS("ActualCost") & "</font></td>"
						sRForm = sRForm & vbCrLf & "                  <td align='left'><font face='Verdana' size='2'><strong>$</strong><input type='text' name='T5' size='12'></font></td>"
						sRForm = sRForm & vbCrLf & "                </tr>"
						sRForm = sRForm & vbCrLf & "              </table>"
						sRForm = sRForm & vbCrLf & "              </td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='left'><font face='Verdana' size='2'><strong>Completion:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "              <td colspan='3'><table border='0'>"
						sRForm = sRForm & vbCrLf & "                <tr>"
						sRForm = sRForm & vbCrLf & "                  <td align='left' bgcolor='#D7D7D7'><strong><font face='Verdana' size='2'>Completed:</font></strong></td>"
						sRForm = sRForm & vbCrLf & "                  <td><input type='checkbox' name='TComplete1' value='Y'><font face='Verdana' size='2'><input type='text' name='T7' size='5'>%</font></td>"
						sRForm = sRForm & vbCrLf & "                </tr>"
						'sRForm = sRForm & vbCrLf & "                <tr>"
						'sRForm = sRForm & vbCrLf & "                  <td align='right' bgcolor='#D7D7D7'><strong><font face='Verdana' size='2'>Send:</font></strong></td>"
						'sRForm = sRForm & vbCrLf & "                  <td><select name='WSend1' size='1'>"
						'sRForm = sRForm & vbCrLf & "                    <option value='SELECT'>SELECT</option>"
						'sRForm = sRForm & vbCrLf & "                    <option value='FORWARD'>FORWARD</option>"
						'sRForm = sRForm & vbCrLf & "                    <option value='BACK'>BACK</option>"
						'sRForm = sRForm & vbCrLf & "                  </select></td>"
						'sRForm = sRForm & vbCrLf & "                </tr>"
						sRForm = sRForm & vbCrLf & "              </table>"
						sRForm = sRForm & vbCrLf & "              </td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "            <tr>"
						sRForm = sRForm & vbCrLf & "              <td align='center' colspan='4'><input type='submit' class='save-btn' value='Update Task' name='B1'> <input class='save-btn' type='submit' value='Cancel' name='B1'></td>"
						sRForm = sRForm & vbCrLf & "            </tr>"
						sRForm = sRForm & vbCrLf & "          </table>"
						sRForm = sRForm & vbCrLf & "          </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "      </table>"
						sRForm = sRForm & vbCrLf & "      </center></div>"
						sRForm = sRForm & vbCrLf & "    </form>"
						oRS.Close
					End If
					Set oRS = Nothing
			End Select
	End Select
	
	GetUTaskForm = sRForm
End Function

Function GetMTaskForm(sM, nTask, sRT, sRID)
	Dim sRForm
	Dim oRS
	Dim sCMD
	Dim sTemp
	Dim sNewMode
	Dim bRefresh
	Dim sList
	
	bRefresh = False
	Select Case sM
	
	
		Case "NT"
			sTemp = GetDataValue("SELECT DISTINCT WTID AS RetVal FROM ViewWFTasks WHERE ((RefType = '" & sRT & "') AND (RefNum = '" & sRID & "'))", Nothing)
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='R1'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRT & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & sRID & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & sTemp & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>New Workflow Task</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Select Action:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='WAID' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("WActions", "", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>or, Select Template Item:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='WTIID' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("WTItems", "", sTemp)
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
		Case "R1"
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRT & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & sRID & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & Request.Form("TID") & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>New Workflow Task</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			'sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
			'sRForm = sRForm & vbCrLf & "          <td><select name='TaskStatus' size='1'>"
			'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			'sRForm = sRForm & vbCrLf & GetSelect("TaskStatus", "HOLD")
			'sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='TaskPriority' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sTemp = GetDataValue("SELECT TaskPriority AS RetVal FROM ViewWFTasks WHERE ((RefType = '" & sRT & "') AND (RefNum = '" & sRID & "')) AND (WFActive <> 0)", Nothing)
			sRForm = sRForm & vbCrLf & GetSelect("TaskPriority", sTemp)
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' align='right'><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='ProjNum' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sTemp = GetDataValue("SELECT ProjNum AS RetVal FROM ViewWFTasks WHERE ((RefType = '" & sRT & "') AND (RefNum = '" & sRID & "')) AND (WFActive <> 0)", Nothing)
			sRForm = sRForm & vbCrLf & GetSelect("Project1", sTemp)
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			sTemp = ""
			If ((Request.Form("WTIID") <> "") And (Request.Form("WTIID") <> "SELECT")) Then
				sTemp = "SelItem"
			Else
				If ((Request.Form("WAID") <> "") And (Request.Form("WAID") <> "SELECT")) Then
					sTemp = "SelAction"
				End If
			End If
			
			If (sTemp <> "") Then
				Select Case sTemp
					Case "SelAction"
						sNewMode = "R3"
						sCMD = "SELECT WAName AS WName, WAType AS WType, WADesc AS WDesc, WAStdTaskID AS WST, WAChgAcct AS WCA, "
						sCMD = sCMD & "WADur AS WDur, WAHrs AS WHrs, WAMins AS WMin, WACost AS WCost, WAAByType AS WByType, WAAssnBy AS WBy, "
						sCMD = sCMD & "WAAToType AS WToType, WAAssnTo AS WTo, WACtrlRef AS WCR, WAParams AS WParams "
						sCMD = sCMD & "FROM WFlowActions WHERE (WAID = " & Request.Form("WAID") & ")"
					Case "SelItem"
						sNewMode = "R3"
						sCMD = "SELECT WTIName AS WName, WTIType AS WType, WTIDesc AS WDesc, WTIStdTaskID AS WST, WTIChgAcct AS WCA, "
						sCMD = sCMD & "WTIStep AS WStep, WTINext AS WNext, WTINextStatus AS WNStatus, WTIBack AS WBack, WTIBackStatus AS WBStatus, "
						sCMD = sCMD & "WTIDur AS WDur, WTIHrs AS WHrs, WTIMins AS WMin, WTICost AS WCost, WTIAByType AS WByType, WTIAssnBy AS WBy, "
						sCMD = sCMD & "WTIAToType AS WToType, WTIAssnTo AS WTo, WTICtrlRef AS WCR, WTIParams AS WParams "
						sCMD = sCMD & "FROM WFlowTempItems WHERE (WTIID = " & Request.Form("WTIID") & ")"
				End Select
				
				Set oRS = GetADORecordset(sCMD, Nothing)
				If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
					oRS.MoveFirst
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Task Description:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='TaskDesc' size='54' value='" & oRS("WName") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Step Number:</strong></font></td>"
					If (sTemp = "SelItem") Then
						sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATStep' size='5' value='" & oRS("WStep") & "'></td>"
					Else
						sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATStep' size='5' value='0'></td>"
					End If
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & GetDataValue("SELECT OptDesc AS RetVal FROM QWFActType WHERE (OptCode = '" & oRS("WType") & "')", Nothing) & "</font><input type='hidden' name='WATType' value='" & oRS("WType") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					
					If Not IsNull(oRS("WCR")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
						If (sTemp = "SelItem") Then
							sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATNext' size='5' value='" & oRS("WNext") & "'></td>"
						Else
							sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATNext' size='5' value='0'></td>"
						End If
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WATNextStatus' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						If (sTemp = "SelItem") Then
							sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WCR"), oRS("WNStatus"))
						Else
							sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WCR"), "")
						End If
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
						If (sTemp = "SelItem") Then
							sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATBack' size='5' value='" & oRS("WBack") & "'></td>"
						Else
							sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATBack' size='5' value='0'></td>"
						End If
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WATBackStatus' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						If (sTemp = "SelItem") Then
							sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WCR"), oRS("WBStatus"))
						Else
							sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WCR"), "")
						End If
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
						If (sTemp = "SelItem") Then
							sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATNext' size='5' value='" & oRS("WNext") & "'></td>"
						Else
							sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATNext' size='5' value='0'></td>"
						End If
						sRForm = sRForm & vbCrLf & "        </tr>"
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
						If (sTemp = "SelItem") Then
							sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATBack' size='5' value='" & oRS("WBack") & "'></td>"
						Else
							sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATBack' size='5' value='0'></td>"
						End If
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
					
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
					sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='TaskDetail' cols='54' wrap='physical'>" & oRS("WDesc") & "</textarea></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					
					If Not IsNull(oRS("WByType")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
						sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & oRS("WByType") & "')", Nothing)
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAByType' value='" & oRS("WByType") & "'></td>"
						If Not IsNull(oRS("WBy")) Then
							If (oRS("WByType") = "EMP") Then
								sList = GetSelect("EmpList", oRS("WBy"))
							Else
								sList = GetWFSelect("RtGroup", oRS("WBy"), oRS("WByType"))
							End If
						Else
							If (oRS("WByType") = "EMP") Then
								sList = GetSelect("EmpList", "")
							Else
								sList = GetWFSelect("RtGroup", "", oRS("WByType"))
							End If
						End If
						sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnBy' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & sList
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAByType' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
						sRForm = sRForm & vbCrLf & "          </select> </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
					
					If Not IsNull(oRS("WToType")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
						sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & oRS("WToType") & "')", Nothing)
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAToType' value='" & oRS("WToType") & "'></td>"
						If Not IsNull(oRS("WTo")) Then
							If (oRS("WToType") = "EMP") Then
								sList = GetSelect("EmpList", oRS("WTo"))
							Else
								sList = GetWFSelect("RtGroup", oRS("WTo"), oRS("WToType"))
							End If
						Else
							If (oRS("WToType") = "EMP") Then
								sList = GetSelect("EmpList", "")
							Else
								sList = GetWFSelect("RtGroup", "", oRS("WToType"))
							End If
						End If
						sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnTo' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & sList
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAToType' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
						sRForm = sRForm & vbCrLf & "          </select> </td>"
					End If
					
					If Not IsNull(oRS("WCR")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
						If (oRS("WCR") <> sRT) Then
							sRForm = sRForm & vbCrLf & "          <td><select name='WATCtrlRef' size='1'>"
							sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
							sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WCR"), "")
							sRForm = sRForm & vbCrLf & "          </select></td>"
							sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. ID:</strong></font></td>"
							sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATRefID' size='20'></td>"
						Else
							sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
							sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
							sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WCR"), "")
							sRForm = sRForm & vbCrLf & "          </select></td>"
						End If
						sRForm = sRForm & vbCrLf & "        </tr>"
						If Not IsNull(oRS("WParams")) Then
							sRForm = sRForm & vbCrLf & "        <tr>"
							sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
							sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
							sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(Left(oRS("WParams"), 1) = "1", " checked", "") & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
							sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(Right(oRS("WParams"), 1) = "1", " checked", "") & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
							sRForm = sRForm & vbCrLf & "        </tr>"
						Else
							sRForm = sRForm & vbCrLf & "        <tr>"
							sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
							sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
							sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'><font face='Verdana' size='2'>Updates controlled reference</font><br>"
							sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
							sRForm = sRForm & vbCrLf & "        </tr>"
						End If
					End If
					
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChargeAcct' size='15'" & IIf(IsNull(oRS("WCA")), "", " value='" & oRS("WCA") & "'") & "></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					
					If Not IsNull(oRS("WST")) Then
						sTemp = GetDataValue("SELECT TaskDesc AS RetVal FROM StdTasks WHERE (StdTaskID = '" & oRS("WST") & "')", Nothing)
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='StdTaskID' value='" & oRS("WST") & "'></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTaskID' value=''></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
					
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
					sRForm = sRForm & vbCrLf & "            <tr>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
					sRForm = sRForm & vbCrLf & "            </tr>"
					sTemp = GetPFinish(Date(), oRS("WDur"))
					sRForm = sRForm & vbCrLf & "            <tr>"
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedStart' size='15' value='" & Date() & "'></td>"
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedFinish' size='15' value='" & sTemp & "'></td>"
					sTemp = oRS("WHrs") + (oRS("WMin") / 60)
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='EstHours' size='5' value='" & sTemp & "'></td>"
					sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='EstCost' size='12' value='" & oRS("WCost") & "'></td>"
					sRForm = sRForm & vbCrLf & "            </tr>"
					sRForm = sRForm & vbCrLf & "          </table>"
					sRForm = sRForm & vbCrLf & "          </td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					oRS.Close
				End If
				Set oRS = Nothing
			Else
				sNewMode = "R2"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Task Description:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='TaskDesc' size='54'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Step Number:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATStep' size='5' value='0'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='WATType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("ActType", "", "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATNext' size='5' value='0'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATBack' size='5' value='0'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
				sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='TaskDetail' cols='54' wrap='physical'></textarea></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAByType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "          </select> </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAToType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "          </select> </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", "", "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
				sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'><font face='Verdana' size='2'>Updates controlled reference</font><br>"
				sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChargeAcct' size='15'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='StdTaskID' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetSelect("StdTask", "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='4' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'>"
			sRForm = sRForm & vbCrLf & "          <input type='hidden' name='Mode' value='" & sNewMode & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
			
			
			
			
		Case "R2"
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='R3'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRT & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & sRID & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & Request.Form("TID") & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>New Workflow Task</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			'sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
			'sRForm = sRForm & vbCrLf & "          <td><select name='TaskStatus' size='1'>"
			'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			'sRForm = sRForm & vbCrLf & GetSelect("TaskStatus", Request.Form("TaskStatus"))
			'sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='TaskPriority' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetSelect("TaskPriority", Request.Form("TaskPriority"))
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' align='right'><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='ProjNum' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetSelect("Project1", Request.Form("ProjNum"))
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Task Description:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='TaskDesc' size='54' value='" & Request.Form("TaskDesc") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Step Number:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATStep' size='5' value='" & Request.Form("WATStep") & "'></td>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
			If ((Request.Form("WATType") <> "") And (Request.Form("WATType") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFActType WHERE (OptCode = '" & Request.Form("WATType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WATType' value='" & Request.Form("WATType") & "'></td>"
			Else
				sRForm = sRForm & vbCrLf & "          <td><select name='WATType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("ActType", "", "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
			End If
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("WATCtrlRef") <> "") And (Request.Form("WATCtrlRef") <> "SELECT")) Then
				sTemp = GetRStatusList(Request.Form("WATCtrlRef"), "")
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATNext' size='5' value='" & Request.Form("WATNext") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='WATNextStatus' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sTemp
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATBack' size='5' value='" & Request.Form("WATBack") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='WATBackStatus' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sTemp
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATNext' size='5' value='" & Request.Form("WATNext") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATBack' size='5' value='" & Request.Form("WATBack") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
			sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='TaskDetail' cols='54' wrap='physical'>" & Request.Form("TaskDetail") & "</textarea></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("WAAByType") <> "") And (Request.Form("WAAByType") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WAAByType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAByType' value='" & Request.Form("WAAByType") & "'></td>"
				If (Request.Form("WAAByType") = "EMP") Then
					sList = GetSelect("EmpList", "")
				Else
					sList = GetWFSelect("RtGroup", "", Request.Form("WAAByType"))
				End If
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnBy' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAByType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "          </select> </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			If ((Request.Form("WAAToType") <> "") And (Request.Form("WAAToType") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WAAToType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAToType' value='" & Request.Form("WAAToType") & "'></td>"
				If (Request.Form("WAAToType") = "EMP") Then
					sList = GetSelect("EmpList", "")
				Else
					sList = GetWFSelect("RtGroup", "", Request.Form("WAAToType"))
				End If
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnTo' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAToType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "          </select> </td>"
			End If
			
			'If ((Request.Form("WATCtrlRef") <> "") And (Request.Form("WATCtrlRef") <> "SELECT")) Then
			'	sTemp = GetWFSelect("TaskRefType", Request.Form("WATCtrlRef"), "")
			'Else
			'	sTemp = GetWFSelect("TaskRefType", "", "")
			'End If
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
			If (Request.Form("WATCtrlRef") <> sRT) Then
				sRForm = sRForm & vbCrLf & "          <td><select name='WATCtrlRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", Request.Form("WATCtrlRef"), "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. ID:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATRefID' size='20' value='" & Request.Form("WATRefID") & "'></td>"
			Else
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", Request.Form("WATCtrlRef"), "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
			End If
			'sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
			'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			'sRForm = sRForm & vbCrLf & sTemp
			'sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
			sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(Request.Form("P1") = "Y", " checked", "") & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
			sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(Request.Form("P2") = "Y", " checked", "") & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChargeAcct' size='15' value='" & Request.Form("ChargeAcct") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("StdTaskID") <> "") And (Request.Form("StdTaskID") <> "SELECT")) Then
				Set oRS = GetADORecordset("SELECT TaskDesc, TaskStdHrs, TaskStdDur FROM StdTasks WHERE (StdTaskID = '" & Request.Form("StdTaskID") & "')", Nothing)
				If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
					oRS.MoveFirst
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font><input type='hidden' name='StdTaskID' value='" & Request.Form("StdTaskID") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
					sRForm = sRForm & vbCrLf & "            <tr>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
					sRForm = sRForm & vbCrLf & "            </tr>"
					sTemp = GetPFinish(Date(), oRS("TaskStdDur"))
					sRForm = sRForm & vbCrLf & "            <tr>"
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedStart' size='15' value='" & Date() & "'></td>"
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedFinish' size='15' value='" & sTemp & "'></td>"
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='EstHours' size='5' value='" & oRS("TaskStdHrs") & "'></td>"
					sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='EstCost' size='12' value='0'></td>"
					sRForm = sRForm & vbCrLf & "            </tr>"
					sRForm = sRForm & vbCrLf & "          </table>"
					sRForm = sRForm & vbCrLf & "          </td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					oRS.Close
				End If
				Set oRS = Nothing
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTaskID' value=''></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedStart' size='15' value='" & Date() & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedFinish' size='15' value='" & Date() & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='EstHours' size='5' value='0'></td>"
				sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='EstCost' size='12' value='0'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "          </table>"
				sRForm = sRForm & vbCrLf & "          </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
			
			
			
		Case "R3"
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='ST'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRT & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & sRID & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & Request.Form("TID") & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>New Workflow Task</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			'sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
			'sRForm = sRForm & vbCrLf & "          <td><select name='TaskStatus' size='1'>"
			'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			'sRForm = sRForm & vbCrLf & GetSelect("TaskStatus", Request.Form("TaskStatus"))
			'sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='TaskPriority' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetSelect("TaskPriority", Request.Form("TaskPriority"))
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' align='right'><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='ProjNum' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetSelect("Project1", Request.Form("ProjNum"))
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
'=================================v== CONTINUE MODIFICATION ==v=================================
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Task Description:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='TaskDesc' size='54' value='" & Request.Form("TaskDesc") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Step Number:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATStep' size='5' value='" & Request.Form("WATStep") & "'></td>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
			If ((Request.Form("WATType") <> "") And (Request.Form("WATType") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFActType WHERE (OptCode = '" & Request.Form("WATType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WATType' value='" & Request.Form("WATType") & "'></td>"
			Else
				sRForm = sRForm & vbCrLf & "          <td><select name='WATType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("ActType", "", "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
			End If
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("WATCtrlRef") <> "") And (Request.Form("WATCtrlRef") <> "SELECT")) Then
				sTemp = GetRStatusList(Request.Form("WATCtrlRef"), Request.Form("WATNextStatus"))
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATNext' size='5' value='" & Request.Form("WATNext") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='WATNextStatus' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sTemp
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sTemp = GetRStatusList(Request.Form("WATCtrlRef"), Request.Form("WATBackStatus"))
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATBack' size='5' value='" & Request.Form("WATBack") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='WATBackStatus' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sTemp
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATNext' size='5' value='" & Request.Form("WATNext") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATBack' size='5' value='" & Request.Form("WATBack") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
			sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='TaskDetail' cols='54' wrap='physical'>" & Request.Form("TaskDetail") & "</textarea></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("WAAByType") <> "") And (Request.Form("WAAByType") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WAAByType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAByType' value='" & Request.Form("WAAByType") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
				If ((Request.Form("WAAssnBy") <> "") And (Request.Form("WAAssnBy") <> "SELECT")) Then
					'If (Request.Form("WAAByType") = "EMP") Then
					'	sList = GetSelect("EmpList", Request.Form("WAAssnBy"))
					'Else
					'	sList = GetWFSelect("RtGroup", Request.Form("WAAssnBy"), Request.Form("WAAByType"))
					'End If
					sTemp = GetDataValue("SELECT WFGroup AS RetVal FROM WFGroups WHERE (WFGID = " & Request.Form("WAAssnBy") & ")", Nothing)
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAssnBy' value='" & Request.Form("WAAssnBy") & "'></td>"
				Else
					If (Request.Form("WAAByType") = "EMP") Then
						sList = GetSelect("EmpList", "")
					Else
						sList = GetWFSelect("RtGroup", "", Request.Form("WAAByType"))
					End If
					sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnBy' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
				End If
				'sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAByType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "          </select> </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			If ((Request.Form("WAAssnTo") <> "") And (Request.Form("WAAssnTo") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WAAToType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAToType' value='" & Request.Form("WAAToType") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
				If (Request.Form("WAAToType") = "EMP") Then
					sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetSelect("EmpList", Request.Form("WAAssnTo"))
					sRForm = sRForm & vbCrLf & "          </select></td>"
				Else
					sTemp = GetDataValue("SELECT WFGroup AS RetVal FROM WFGroups WHERE (WFGID = " & Request.Form("WAAssnTo") & ")", Nothing)
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAssnTo' value='" & Request.Form("WAAssnTo") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3' align='right' nowrap><font face='Verdana' size='2'><strong>Individual Assignee:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='AssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sTemp = "SELECT WFMEmpID AS OptVal, WFMName AS OptText FROM WFGroupMembs "
					sTemp = sTemp & "WHERE (WFGID = " & Request.Form("WAAssnTo") & ") "
					sTemp = sTemp & "AND (WFMEmpID IS NOT NULL) ORDER BY WFMName"
					sRForm = sRForm & vbCrLf & GetWFSelect("SQL", "", sTemp)
					sRForm = sRForm & vbCrLf & "          </select></td>"
				End If
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				If ((Request.Form("WAAToType") <> "") And (Request.Form("WAAToType") <> "SELECT")) Then
					sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WAAToType") & "')", Nothing)
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAToType' value='" & Request.Form("WAAToType") & "'></td>"
					If ((Request.Form("WAAssnTo") <> "") And (Request.Form("WAAssnTo") <> "SELECT")) Then
						If (Request.Form("WAAToType") = "EMP") Then
							sList = GetSelect("EmpList", Request.Form("WAAssnTo"))
						Else
							sList = GetWFSelect("RtGroup", Request.Form("WAAssnTo"), Request.Form("WAAToType"))
						End If
					Else
						If (Request.Form("WAAToType") = "EMP") Then
							sList = GetSelect("EmpList", "")
						Else
							sList = GetWFSelect("RtGroup", "", Request.Form("WAAToType"))
						End If
					End If
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAToType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "          </select> </td>"
				End If
			End If
			
			'If ((Request.Form("WATCtrlRef") <> "") And (Request.Form("WATCtrlRef") <> "SELECT")) Then
			'	sTemp = GetWFSelect("TaskRefType", Request.Form("WATCtrlRef"), "")
			'Else
			'	sTemp = GetWFSelect("TaskRefType", "", "")
			'End If
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
			If (Request.Form("WATCtrlRef") <> sRT) Then
				sRForm = sRForm & vbCrLf & "          <td><select name='WATCtrlRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", Request.Form("WATCtrlRef"), "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. ID:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATRefID' size='20' value='" & Request.Form("WATRefID") & "'></td>"
			Else
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", Request.Form("WATCtrlRef"), "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
			End If
			'sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
			'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			'sRForm = sRForm & vbCrLf & sTemp
			'sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
			sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(Request.Form("P1") = "Y", " checked", "") & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
			sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(Request.Form("P2") = "Y", " checked", "") & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChargeAcct' size='15' value='" & Request.Form("ChargeAcct") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("StdTaskID") <> "") And (Request.Form("StdTaskID") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT TaskDesc AS RetVal FROM StdTasks WHERE (StdTaskID = '" & Request.Form("StdTaskID") & "')", Nothing)
				If (sTemp <> "") Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='StdTaskID' value='" & Request.Form("StdTaskID") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTaskID' value=''></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedStart' size='15' value='" & Request.Form("PlannedStart") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedFinish' size='15' value='" & Request.Form("PlannedFinish") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='EstHours' size='5' value='" & Request.Form("EstHours") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='EstCost' size='12' value='" & Request.Form("EstCost") & "'></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "          </table>"
			sRForm = sRForm & vbCrLf & "          </td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
'==================================^== FINISH MODIFICATIONS ==^==================================
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input type='submit' value='Save Task(s)' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
			
			
			
			
			
		Case "MT"
		
		
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='UT'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRT & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & sRID & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WATID' value='" & nTask & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Task Tanmay</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			sCMD = "SELECT TaskID, TaskStatus, Status, TaskPriority, ChargeAcct, StdTaskID, StdTask, RType, RefNum, ProjNum, DateAssigned, AssignWkgrp, Workgroup, "
			sCMD = sCMD & "TaskDesc, TaskDetail, PlannedStart, PlannedFinish, OverrunEstFinish, ActualStart, ActualFinish, EstHours, OverrunHrs, BHrs, ActualHours, "
			sCMD = sCMD & "PcntComplete, EstCost, OvrCost, BMCost, ActualCost, WTID, WATActive, WATStatus, WATType, AType, WATStep, WATNext, WATNextStatus, "
			sCMD = sCMD & "WATBack, WATBackStatus, WAAByType, AByType, WAAssnBy, WAAToType, AToType, WAAssnTo, WFAssnTo, WATCtrlRef, WATRefID, WATParams, "
			sCMD = sCMD & "WATSchedAdj, WATAdjPStart, WATAdjPFinish, WATAdjOFinish, WATAdjAStart, WATAdjAFinish "
			sCMD = sCMD & "FROM ViewWFTasks WHERE (WATID = " & nTask & ")"
			'<input type='hidden' name='TID' value='" & oRS("WTID") & "'>
			Set oRS = GetADORecordset(sCMD, Nothing)
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='left'><font face='Verdana' size='2'><strong>Task ID:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskID") & "</font><input type='hidden' name='TaskID' value='" & oRS("TaskID") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='left'><font face='Verdana' size='2'><strong>Status:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='TaskStatus' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetSelect("TaskStatus", oRS("TaskStatus"))
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "          <td align='left'><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='TaskPriority' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetSelect("TaskPriority", oRS("TaskPriority"))
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' align='left'><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='ProjNum' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetSelect("Project1", oRS("ProjNum"))
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' align='left'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='TaskDesc' size='57' value='" & oRS("TaskDesc") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='left'><font face='Verdana' size='2'><strong>Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WATStep") & "</font></td>"
				sRForm = sRForm & vbCrLf & "          <td align='left'><font face='Verdana' size='2'><strong>Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AType") & "</font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WATCtrlRef")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATNext' size='8' value='" & oRS("WATNext") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='WATNextStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					If IsNull(oRS("WATNextStatus")) Then
						sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WATCtrlRef"), "")
					Else
						sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WATCtrlRef"), oRS("WATNextStatus"))
					End If
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATBack' size='8' value='" & oRS("WATBack") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='WATBackStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					If IsNull(oRS("WATBackStatus")) Then
						sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WATCtrlRef"), "")
					Else
						sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WATCtrlRef"), oRS("WATBackStatus"))
					End If
					sRForm = sRForm & vbCrLf & "          </select></td>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATNext' size='8' value='" & oRS("WATNext") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WATBack' size='8' value='" & oRS("WATBack") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' align='left'><font face='Verdana' size='2'><strong>Task Detail/<br>Assignment/<br>Instructions:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><textarea rows='3' name='TaskDetail' cols='54' wrap='physical'>" & oRS("TaskDetail") & "</textarea></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If IsNull(oRS("WAAssnBy")) Then
					If IsNull(oRS("WAAByType")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAByType' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
						sRForm = sRForm & vbCrLf & "          </select> </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						If (oRS("WAAByType") = "EMP") Then
							sTemp = GetSelect("EmpList", "")
						Else
							sTemp = GetWFSelect("RtGroup", "", oRS("WAAByType"))
						End If
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AByType") & "</font><input type='hidden' name='WAAByType' value='" & oRS("WAAByType") & "'></td>"
						sRForm = sRForm & vbCrLf & "          <td nowrap align='left'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnBy' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & sTemp
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
				Else
					If (oRS("WAAByType") = "EMP") Then
						sTemp = GetSelect("EmpList", oRS("WAAssnBy"))
					Else
						sTemp = GetWFSelect("RtGroup", oRS("WAAssnBy"), oRS("WAAByType"))
					End If
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AByType") & "</font><input type='hidden' name='WAAByType' value='" & oRS("WAAByType") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td nowrap align='left'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnBy' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sTemp
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				If IsNull(oRS("WFAssnTo")) Then
					If IsNull(oRS("WAAToType")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WAAToType' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
						sRForm = sRForm & vbCrLf & "          </select> </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						If (oRS("WAAToType") = "EMP") Then
							sTemp = GetSelect("EmpList", "")
						Else
							sTemp = GetWFSelect("RtGroup", "", oRS("WAAToType"))
						End If
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AToType") & "</font><input type='hidden' name='WAAToType' value='" & oRS("WAAToType") & "'></td>"
						sRForm = sRForm & vbCrLf & "          <td nowrap align='left'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WAAssnTo' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & sTemp
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
				Else
					'If (oRS("WAAToType") = "EMP") Then
					'	sTemp = GetSelect("EmpList", oRS("WFAssnTo"))
					'Else
					'	sTemp = GetWFSelect("RtGroup", oRS("WAAssnTo"), oRS("WAAToType"))
					'End If
					sTemp = ""
					'If (IsNull(oRS("WAAToType") = False) And IsNull(oRS("WAAssnTo") = False)) Then
					'sTemp = GetAssignInfo(oRS("WAAToType"), oRS("WAAssnTo"))
					'End If
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					'sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AToType") & IIf(sTemp <> "", " - " & sTemp, "") & "</font><input type='hidden' name='WAAToType' value='" & oRS("WAAToType") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AToType") & "</font><input type='hidden' name='WAAToType' value='" & oRS("WAAToType") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td nowrap align='left'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					'sRForm = sRForm & vbCrLf & "          <td><select name='WFAssnTo' size='1'>"
					'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					'sRForm = sRForm & vbCrLf & GetSelect("EmpList", oRS("WFAssnTo"))
					'sRForm = sRForm & vbCrLf & "          </select></td>"
					'sRForm = sRForm & vbCrLf & "        </tr>"
					sTemp = GetDataValue("SELECT WFGroup AS RetVal FROM WFGroups WHERE (WFGID = " & oRS("WAAssnTo") & ")", Nothing)
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WAAssnTo' value='" & oRS("WAAssnTo") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td colspan='1' align='left' nowrap><font face='Verdana' size='2'><strong>Individual Assignee:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='WFAssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sTemp = "SELECT WFMEmpID AS OptVal, WFMName AS OptText FROM WFGroupMembs "
					sTemp = sTemp & "WHERE (WFGID = " & oRS("WAAssnTo") & ") "
					sTemp = sTemp & "AND (WFMEmpID IS NOT NULL) ORDER BY WFMName"
					sRForm = sRForm & vbCrLf & GetWFSelect("SQL", oRS("WFAssnTo"), sTemp)
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				If Not IsNull(oRS("WATCtrlRef")) Then
					'sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QTaskRefType WHERE (OptCode = '" & oRS("WATCtrlRef") & "')", Nothing)
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
					If (oRS("WATCtrlRef") <> sRT) Then
						sRForm = sRForm & vbCrLf & "          <td><select name='WATCtrlRef' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WATCtrlRef"), "")
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Ref. ID:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><input type='text' name='WATRefID' size='20' value='" & oRS("WATRefID") & "'></td>"
					Else
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WATCtrlRef"), "")
						sRForm = sRForm & vbCrLf & "          </select></td>"
					End If
					'sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WATCtrlRef' size='1'>"
					'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					'sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WATCtrlRef"), "")
					'sRForm = sRForm & vbCrLf & "          </select></td>"
					'sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WATCtrlRef' value='" & oRS("WATCtrlRef") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					If Not IsNull(oRS("WATParams")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='left' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong></font><input type='hidden' name='WATParams' value='" & oRS("WATParams") & "'></td>"
						sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(Left(oRS("WATParams"), 1) = "1", " checked", "") & "><font face='Verdana' size='2'> Updates controlled reference</font>"
						sRForm = sRForm & vbCrLf & "          <br><input type='checkbox' name='P2' value='Y'" & IIf(Right(oRS("WATParams"), 1) = "1", " checked", "") & "><font face='Verdana' size='2'> Allow additions to controlled reference</font></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChargeAcct' size='15' value='" & oRS("ChargeAcct") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("StdTaskID")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("StdTask") & "</font><input type='hidden' name='StdTaskID' value='" & oRS("StdTaskID") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>% Complete:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='PcntComplete' size='3' value='" & oRS("PcntComplete") & "'> <font face='Verdana' size='2'>%</font></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>NONE</font></td>"
					sRForm = sRForm & vbCrLf & "          <td align='left' nowrap><font face='Verdana' size='2'><strong>% Complete:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='PcntComplete' size='3' value='" & oRS("PcntComplete") & "'> <font face='Verdana' size='2'>%</font></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='left' valign='top' width='20%'><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3' width='80%'><table border='0' cellpadding='2' width='100%'>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hrs</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Planned:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedStart' size='15' value='" & oRS("PlannedStart") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PlannedFinish' size='15' value='" & oRS("PlannedFinish") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='EstHours' size='5' value='" & oRS("EstHours") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>$ </font><input type='text' name='EstCost' size='15' value='" & oRS("EstCost") & "'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				If (oRS("WATSchedAdj") <> 0) Then
					sRForm = sRForm & vbCrLf & "            <tr>"
					sRForm = sRForm & vbCrLf & "              <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Adj. Planned:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='WATAdjPStart' size='15' value='" & oRS("WATAdjPStart") & "'></td>"
					sRForm = sRForm & vbCrLf & "              <td colspan='3'><input type='text' name='WATAdjPFinish' size='15' value='" & oRS("WATAdjPFinish") & "'></td>"
					sRForm = sRForm & vbCrLf & "            </tr>"
				End If
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Overrun:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'></font></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='OverrunEstFinish' size='15' value='" & oRS("OverrunEstFinish") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='OverrunHrs' size='5' value='" & oRS("OverrunHrs") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>$ </font><input type='text' name='OvrCost' size='15' value='" & oRS("OvrCost") & "'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				If (oRS("WATSchedAdj") <> 0) Then
					sRForm = sRForm & vbCrLf & "            <tr>"
					sRForm = sRForm & vbCrLf & "              <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Adj. Overrun:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'></font></td>"
					sRForm = sRForm & vbCrLf & "              <td colspan='3'><input type='text' name='WATAdjOFinish' size='15' value='" & oRS("WATAdjOFinish") & "'></td>"
					sRForm = sRForm & vbCrLf & "            </tr>"
				End If
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td align='left' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Actual:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ActualStart' size='15' value='" & oRS("ActualStart") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ActualFinish' size='15' value='" & oRS("ActualFinish") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ActualHours' size='5' value='" & oRS("ActualHours") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>$ </font><input type='text' name='ActualCost' size='15' value='" & oRS("ActualCost") & "'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				If (oRS("WATSchedAdj") <> 0) Then
					sRForm = sRForm & vbCrLf & "            <tr>"
					sRForm = sRForm & vbCrLf & "              <td align='right' bgcolor='#D7D7D7'><font face='Verdana' size='2'><strong>Adj. Actual:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "              <td><input type='text' name='WATAdjAStart' size='15' value='" & oRS("WATAdjAStart") & "'></td>"
					sRForm = sRForm & vbCrLf & "              <td colspan='3'><input type='text' name='WATAdjAFinish' size='15' value='" & oRS("WATAdjAFinish") & "'></td>"
					sRForm = sRForm & vbCrLf & "            </tr>"
				End If
				sRForm = sRForm & vbCrLf & "          </table>"
				sRForm = sRForm & vbCrLf & "          </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				oRS.Close
			End If
			Set oRS = Nothing
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input class='save-btn' type='submit' value='Save Task' name='B1'> <input type='submit' class='save-btn' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
	End Select
	
	GetMTaskForm = sRForm
End Function

Function GetGenTaskForm(sM, sRType, sRID)
	Dim sRForm
	Dim sTemp
	Dim oRS
	Dim sCMD
	
	Select Case sM
	
		Case "NR", "N1A"		'No reference supplied or found
			sRForm = "    <form method='POST' action='wf_gen_tasks.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='N1'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Select Reference Item</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Reference Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='RT' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", "", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td></td>"
			sRForm = sRForm & vbCrLf & "          <td><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
			
		Case "N1"
			sRForm = "    <form method='POST' action='wf_gen_tasks.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='N2'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRType & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Select Reference Item</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QTaskRefType WHERE (OptCode = '" & sRType & "')", Nothing)
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Reference Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Select Item:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><input type='text' name='RID' size='25'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
			
		Case "N2"
			sRForm = "    <form method='POST' action='wf_gen_tasks.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='SR'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRType & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Select Reference Item</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QTaskRefType WHERE (OptCode = '" & sRType & "')", Nothing)
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Reference Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Select Item:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='RID' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetGenRefList(sRType, sRID)
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
		Case "SR"		'Select referenced workflow
			sRForm = "    <form method='POST' action='wf_gen_tasks.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='S1'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRType & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & sRID & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Select Workflow Template</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Workflow Template:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='TID' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			'Template selection can be limited to allowable listings:
			'	GetWFSelect("WTemplate", "", "WTType <> 'TEST'")
			'	GetWFSelect("WTemplate", "", "(WTType <> 'TEST') AND (WTType <> 'EST')")
			sRForm = sRForm & vbCrLf & GetWFSelect("WTemplate", "", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' align='center'><input type='submit' value='Retrieve Template' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
		Case "S1"
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='SS'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & sRType & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & sRID & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & Request.Form("TID") & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Template</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QTaskRefType WHERE (OptCode = '" & sRType & "')", Nothing)
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Reference:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & " - " & sRID & "</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			Set oRS = GetADORecordset("SELECT WTName, TType, WTDesc FROM ViewWFTemp WHERE (WTID = " & Request.Form("TID") & ")", Nothing)
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("TType") & "<input type='hidden' name='TType' value='" & oRS("TType") & "'></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Template:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WTName") & "<input type='hidden' name='TName' value='" & oRS("WTName") & "'></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WTDesc") & "<input type='hidden' name='TDesc' value='" & oRS("WTDesc") & "'></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			oRS.Close
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Include Default Values</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='2'><font face='Verdana' size='1'>Please provide default values for the tasks to be created. These "
			sRForm = sRForm & vbCrLf & "          values will be utilized on each individual task created unless they are overriden by values specific to the action "
			sRForm = sRForm & vbCrLf & "          creating the task.</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><input type='text' name='DefAcct' size='15'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Priority:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='DefPrior' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetSelect("TaskPriority", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Project:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='DefProj' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetSelect("Project1", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Steps</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='1'>The following steps are included in the workflow template. Each of the "
			sRForm = sRForm & vbCrLf & "          following process steps will  be provided to you in order, you will have the opportunity to create task(s) for the step or "
			sRForm = sRForm & vbCrLf & "          skip the step without creating task(s).</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>STEP</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>NAME</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>TYPE</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sCMD = "SELECT WTIID, WTIStep, WTIName, TIType FROM ViewWFTItems WHERE (WTID = " & Request.Form("TID") & ") ORDER BY WTIStep"
			Set oRS = GetADORecordset(sCMD, Nothing)
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
				sTemp = oRS("WTIStep")
				Do
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td valign='top' align='center'><font face='Verdana' size='2'>" & oRS("WTIStep") & "</font>" & IIf(sTemp <> "", "<input type='hidden' name='NextStep' value='" & sTemp & "'>", "") & "</td>"
					sRForm = sRForm & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & oRS("WTIName") & "</font></td>"
					sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap><font face='Verdana' size='2'>" & oRS("TIType") & "</font></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					If (sTemp <> "") Then sTemp = ""
					oRS.MoveNext
				Loop Until oRS.EOF
				oRS.Close
			End If
			Set oRS = Nothing
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
	End Select
	
	GetGenTaskForm = sRForm
End Function

Function GetGenForm(sM, nStep)
	Dim sRForm
	Dim bRefresh
	Dim nNextStep, sNextMode
	Dim sTemp
	Dim oRS
	Dim sCMD
	
	bRefresh = False
	Select Case sM
		Case "SS"
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & Request.Form("TID") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & Request.Form("RT") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & Request.Form("RID") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='DefAcct' value='" & Request.Form("DefAcct") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='DefPrior' value='" & Request.Form("DefPrior") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='DefProj' value='" & Request.Form("DefProj") & "'>"
			
			sCMD = "SELECT WTIID, WTIName, WTIType, TIType, WTIStep, WTINext, WTINextStatus, WTIBack, WTIBackStatus, WTIDesc, WTIStdTaskID, TaskDesc, "
			sCMD = sCMD & "WTIChgAcct, WTIDur, WTIHrs, WTIMins, WTICost, WTIAByType, AByType, WTIAssnBy, WTIAToType, AToType, WTIAssnTo, WTICtrlRef, "
			sCMD = sCMD & "CRef, WTIParams FROM ViewWFTItems WHERE (WTID = " & Request.Form("TID") & ") AND (WTIStep = '" & nStep & "')"
			
			Set oRS = GetADORecordset(sCMD, Nothing)
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
				'Verify data in order to determine if this step will require a refresh cycle or if it will be able to generate tasks
				If IsNull(oRS("WTIAssnBy")) Then If IsNull(oRS("WTIAByType")) Then bRefresh = True
				If IsNull(oRS("WTIAssnTo")) Then If IsNull(oRS("WTIAToType")) Then bRefresh = True
				
				If (oRS("WTINext") > 0) Then
					sTemp = GetDataValue("SELECT WTIID AS RetVal FROM ViewWFTItems WHERE (WTID = " & Request.Form("TID") & ") AND (WTIStep = '" & oRS("WTINext") & "')", Nothing)
					If (sTemp = "") Then
						nNextStep = "0"
						sNextMode = "M"
					Else
						nNextStep = oRS("WTINext")
						sNextMode = "SS"
					End If
				End If
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WTIID' value='" & oRS("WTIID") & "'>"
				'NextStep:		Retrieve from data
				'NextMode:		SS - Select/Skip Step		M - Modify Task List (when completed with available steps)
				If (bRefresh = True) Then
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='RS'>"
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextStep' value='" & nStep & "'>"
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='SkipStep' value='" & oRS("WTINext") & "'>"
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextMode' value='" & sNextMode & "'>"
				Else
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='GT'>"
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextStep' value='" & nNextStep & "'>"
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='SkipStep' value='" & oRS("WTINext") & "'>"
					sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextMode' value='" & sNextMode & "'>"
				End If
				
				sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Step</strong></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td colspan='4'><font face='Verdana' size='1'>Please provide all required information to create task(s) for the "
				sRForm = sRForm & vbCrLf & "          step or skip the step without creating task(s).</font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & nStep & "</font><input type='hidden' name='WTIStep' value='" & nStep & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("TIType") & "</font><input type='hidden' name='WTIType' value='" & oRS("WTIType") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' align='right'><font face='Verdana' size='2'><strong>Name:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("WTIName") & "</font><input type='hidden' name='WTIName' value='" & oRS("WTIName") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WTICtrlRef")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WTINext") & "</font><input type='hidden' name='WTINext' value='" & oRS("WTINext") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
					If IsNull(oRS("WTINextStatus")) Then
						sRForm = sRForm & vbCrLf & "          <td><select name='WTINextStatus' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WTICtrlRef"), "")
						sRForm = sRForm & vbCrLf & "          </select></td>"
					Else
						'Task References
						sTemp = GetRStatusVal(oRS("WTICtrlRef"), oRS("WTINextStatus"))
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTINextStatus' value='" & oRS("WTINextStatus") & "'></td>"
					End If
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WTIBack") & "</font><input type='hidden' name='WTIBack' value='" & oRS("WTIBack") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
					If IsNull(oRS("WTIBackStatus")) Then
						sRForm = sRForm & vbCrLf & "          <td><select name='WTIBackStatus' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetRStatusList(oRS("WTICtrlRef"), "")
						sRForm = sRForm & vbCrLf & "          </select></td>"
					Else
						'Task References
						sTemp = GetRStatusVal(oRS("WTICtrlRef"), oRS("WTIBackStatus"))
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIBackStatus' value='" & oRS("WTIBackStatus") & "'></td>"
					End If
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("WTINext") & "</font><input type='hidden' name='WTINext' value='" & oRS("WTINext") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("WTIBack") & "</font><input type='hidden' name='WTIBack' value='" & oRS("WTIBack") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' align='right'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("WTIDesc") & "</font><input type='hidden' name='WTIDesc' value='" & oRS("WTIDesc") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If IsNull(oRS("WTIAssnBy")) Then
					If IsNull(oRS("WTIAByType")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WTIAByType' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
						sRForm = sRForm & vbCrLf & "          </select> </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						If (oRS("WTIAByType") = "EMP") Then
							sTemp = GetSelect("EmpList", "")
						Else
							sTemp = GetWFSelect("RtGroup", "", oRS("WTIAByType"))
						End If
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AByType") & "</font><input type='hidden' name='WTIAByType' value='" & oRS("WTIAByType") & "'></td>"
						sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WTIAssnBy' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & sTemp
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
				Else
					sTemp = GetAssignInfo(oRS("WTIAByType"), oRS("WTIAssnBy"))
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AByType") & "</font><input type='hidden' name='WTIAByType' value='" & oRS("WTIAByType") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAssnBy' value='" & oRS("WTIAssnBy") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				If IsNull(oRS("WTIAssnTo")) Then
					If IsNull(oRS("WTIAToType")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WTIAToType' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
						sRForm = sRForm & vbCrLf & "          </select> </td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						If (oRS("WTIAToType") = "EMP") Then
							sTemp = GetSelect("EmpList", "")
						Else
							sTemp = GetWFSelect("RtGroup", "", oRS("WTIAToType"))
						End If
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AToType") & "</font><input type='hidden' name='WTIAToType' value='" & oRS("WTIAToType") & "'></td>"
						sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
						sRForm = sRForm & vbCrLf & "          <td><select name='WTIAssnTo' size='1'>"
						sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
						sRForm = sRForm & vbCrLf & sTemp
						sRForm = sRForm & vbCrLf & "          </select></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
				Else
					sTemp = GetAssignInfo(oRS("WTIAToType"), oRS("WTIAssnTo"))
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AToType") & "</font><input type='hidden' name='WTIAToType' value='" & oRS("WTIAToType") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAssnTo' value='" & oRS("WTIAssnTo") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				If Not IsNull(oRS("WTICtrlRef")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("CRef") & "</font><input type='hidden' name='WTICtrlRef' value='" & oRS("WTICtrlRef") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					If Not IsNull(oRS("WTIParams")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong></font><input type='hidden' name='WTIParams' value='" & oRS("WTIParams") & "'></td>"
						sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><font face='Verdana' size='2'>" & IIf(Left(oRS("WTIParams"), 1) = "1", "<strong>X</strong>", "<font color='#FFFFFF'><strong>X</strong></font>") & " Updates controlled reference</font><br>"
						sRForm = sRForm & vbCrLf & "          <font face='Verdana' size='2'>" & IIf(Right(oRS("WTIParams"), 1) = "1", "<strong>X</strong>", "<font color='#FFFFFF'><strong>X</strong></font>") & " Allow additions to controlled reference</font></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WTIChgAcct' size='15' value='" & oRS("WTIChgAcct") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WTIStdTaskID")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font><input type='hidden' name='WTIStdTaskID' value='" & oRS("WTIStdTaskID") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='WTIStdTaskID' value=''></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' width='20%'><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3' width='80%'><table border='0' cellpadding='2' width='100%'>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hrs</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Min</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sTemp = IIf(Request.Form("PFinish") <> "", Request.Form("PFinish"), Date())
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PStart' size='15' value='" & sTemp & "'><input type='hidden' name='WTIDur' value='" & oRS("WTIDur") & "'></td>"
				sTemp = GetPFinish(sTemp, oRS("WTIDur"))
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PFinish' size='15' value='" & sTemp & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & oRS("WTIHrs") & "</font><input type='hidden' name='WTIHrs' value='" & oRS("WTIHrs") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & oRS("WTIMins") & "</font><input type='hidden' name='WTIMins' value='" & oRS("WTIMins") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>$ " & oRS("WTICost") & "</font><input type='hidden' name='WTICost' value='" & oRS("WTICost") & "'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "          </table>"
				sRForm = sRForm & vbCrLf & "          </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If (bRefresh = True) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input type='submit' value='Refresh' name='B1'> <input type='submit' value='Skip' name='B1'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input type='submit' value='Generate Task(s)' name='B1'> <input type='submit' value='Skip' name='B1'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				oRS.Close
			End If
			Set oRS = Nothing
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
		Case "RS"
			sRForm = "    <form method='POST' action='wf_gen_tasks1.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='TID' value='" & Request.Form("TID") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RT' value='" & Request.Form("RT") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='RID' value='" & Request.Form("RID") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='DefAcct' value='" & Request.Form("DefAcct") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='DefPrior' value='" & Request.Form("DefPrior") & "'>"
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='DefProj' value='" & Request.Form("DefProj") & "'>"
			
			'Verify data in order to determine if this step will require a refresh cycle or if it will be able to generate tasks
			If ((Request.Form("WTIAssnBy") = "") Or (Request.Form("WTIAssnBy") = "SELECT")) Then
				If ((Request.Form("WTIAByType") = "") Or (Request.Form("WTIAByType") = "SELECT")) Then bRefresh = True
			End If
			If ((Request.Form("WTIAssnTo") = "") Or (Request.Form("WTIAssnTo") = "SELECT")) Then
				If ((Request.Form("WTIAToType") = "") Or (Request.Form("WTIAToType") = "SELECT")) Then bRefresh = True
			End If
			
			sTemp = GetDataValue("SELECT WTIID AS RetVal FROM ViewWFTItems WHERE (WTID = " & Request.Form("TID") & ") AND (WTIStep = '" & Request.Form("WTINext") & "')", Nothing)
			If (sTemp = "") Then
				nNextStep = "0"
				sNextMode = "M"
			Else
				nNextStep = Request.Form("WTINext")
				sNextMode = "SS"
			End If
			sRForm = sRForm & vbCrLf & "    <input type='hidden' name='WTIID' value='" & Request.Form("WTIID") & "'>"
			'NextStep:		Retrieve from data
			'NextMode:		SS - Select/Skip Step		M - Modify Task List (when completed with available steps)
			If (bRefresh = True) Then
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='RS'>"
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextStep' value='" & nStep & "'>"
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='SkipStep' value='" & Request.Form("WTINext") & "'>"
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextMode' value='" & sNextMode & "'>"
			Else
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='Mode' value='GT'>"
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextStep' value='" & nNextStep & "'>"
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='SkipStep' value='" & Request.Form("WTINext") & "'>"
				sRForm = sRForm & vbCrLf & "    <input type='hidden' name='NextMode' value='" & sNextMode & "'>"
			End If
			
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Step</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td colspan='4'><font face='Verdana' size='1'>Please provide all required information to create task(s) for the "
			sRForm = sRForm & vbCrLf & "          step or skip the step without creating task(s).</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Step:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("WTIStep") & "</font><input type='hidden' name='WTIStep' value='" & nStep & "'></td>"
			sRForm = sRForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Type:</strong></font></td>"
			sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFActType WHERE (OptCode = '" & Request.Form("WTIType") & "')", Nothing)
			sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIType' value='" & Request.Form("WTIType") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' align='right'><font face='Verdana' size='2'><strong>Name:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & Request.Form("WTIName") & "</font><input type='hidden' name='WTIName' value='" & Request.Form("WTIName") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("WTICtrlRef") <> "") And (Request.Form("WTICtrlRef") <> "SELECT")) Then
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("WTINext") & "</font><input type='hidden' name='WTINext' value='" & Request.Form("WTINext") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
				If ((Request.Form("WTINextStatus") = "") Or (Request.Form("WTINextStatus") = "SELECT")) Then
					sRForm = sRForm & vbCrLf & "          <td><select name='WTINextStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetRStatusList(Request.Form("WTICtrlRef"), "")
					sRForm = sRForm & vbCrLf & "          </select></td>"
				Else
					'Task References
					sTemp = GetRStatusVal(Request.Form("WTICtrlRef"), Request.Form("WTINextStatus"))
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTINextStatus' value='" & Request.Form("WTINextStatus") & "'></td>"
				End If
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("WTIBack") & "</font><input type='hidden' name='WTIBack' value='" & Request.Form("WTIBack") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
				If ((Request.Form("WTIBackStatus") = "") Or (Request.Form("WTIBackStatus") = "SELECT")) Then
					sRForm = sRForm & vbCrLf & "          <td><select name='WTIBackStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetRStatusList(Request.Form("WTICtrlRef"), "")
					sRForm = sRForm & vbCrLf & "          </select></td>"
				Else
					'Task References
					sTemp = GetRStatusVal(Request.Form("WTICtrlRef"), Request.Form("WTIBackStatus"))
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIBackStatus' value='" & Request.Form("WTIBackStatus") & "'></td>"
				End If
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & Request.Form("WTINext") & "</font><input type='hidden' name='WTINext' value='" & Request.Form("WTINext") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & Request.Form("WTIBack") & "</font><input type='hidden' name='WTIBack' value='" & Request.Form("WTIBack") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' align='right'><font face='Verdana' size='2'><strong>Description:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & Request.Form("WTIDesc") & "</font><input type='hidden' name='WTIDesc' value='" & Request.Form("WTIDesc") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("WTIAssnBy") = "") Or (Request.Form("WTIAssnBy") = "SELECT")) Then
				If ((Request.Form("WTIAByType") = "") Or (Request.Form("WTIAByType") = "SELECT")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WTIAByType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "          </select> </td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WTIAByType") & "')", Nothing)
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAByType' value='" & Request.Form("WTIAByType") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
					If (Request.Form("WTIAByType") = "EMP") Then
						sTemp = GetSelect("EmpList", "")
					Else
						sTemp = GetWFSelect("RtGroup", "", Request.Form("WTIAByType"))
					End If
					sRForm = sRForm & vbCrLf & "          <td><select name='WTIAssnBy' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sTemp
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROMQWFGroupType WHERE (OptCode = '" & Request.Form("WTIAByType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAByType' value='" & Request.Form("WTIAByType") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
				sTemp = GetAssignInfo(Request.Form("WTIAByType"), Request.Form("WTIAssnBy"))
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAssnBy' value='" & Request.Form("WTIAssnBy") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			If ((Request.Form("WTIAssnTo") = "") Or (Request.Form("WTIAssnTo") = "SELECT")) Then
				If ((Request.Form("WTIAToType") = "") Or (Request.Form("WTIAToType") = "SELECT")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='WTIAToType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "          </select> </td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WTIAToType") & "')", Nothing)
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAToType' value='" & Request.Form("WTIAToType") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					If (Request.Form("WTIAToType") = "EMP") Then
						sTemp = GetSelect("EmpList", "")
					Else
						sTemp = GetWFSelect("RtGroup", "", Request.Form("WTIAToType"))
					End If
					sRForm = sRForm & vbCrLf & "          <td><select name='WTIAssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sTemp
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("WTIAToType") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAToType' value='" & Request.Form("WTIAToType") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
				sTemp = GetAssignInfo(Request.Form("WTIAToType"), Request.Form("WTIAssnTo"))
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIAssnTo' value='" & Request.Form("WTIAssnTo") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			If ((Request.Form("WTICtrlRef") <> "") And (Request.Form("WTICtrlRef") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QTaskRefType WHERE (OptCode = '" & Request.Form("WTICtrlRef") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTICtrlRef' value='" & Request.Form("WTICtrlRef") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				If (Request.Form("WTIParams") <> "") Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong></font><input type='hidden' name='WTIParams' value='" & Request.Form("WTIParams") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><font face='Verdana' size='2'>" & IIf(Left(Request.Form("WTIParams"), 1) = "1", "<strong>X</strong>", "<font color='#FFFFFF'><strong>X</strong></font>") & " Updates controlled reference</font><br>"
					sRForm = sRForm & vbCrLf & "          <font face='Verdana' size='2'>" & IIf(Right(Request.Form("WTIParams"), 1) = "1", "<strong>X</strong>", "<font color='#FFFFFF'><strong>X</strong></font>") & " Allow additions to controlled reference</font></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='WTIChgAcct' size='15' value='" & Request.Form("WTIChgAcct") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("WTIStdTaskID") <> "") And (Request.Form("WTIStdTaskID") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT TaskDesc AS RetVal FROM StdTasks WHERE (StdTaskID = '" & Request.Form("WTIStdTaskID") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='WTIStdTaskID' value='" & Request.Form("WTIStdTaskID") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='WTIStdTaskID' value=''></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' width='20%'><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3' width='80%'><table border='0' cellpadding='2' width='100%'>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Start</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Finish</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hrs</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Min</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PStart' size='15' value='" & Request.Form("PStart") & "'><input type='hidden' name='WTIDur' value='" & Request.Form("WTIDur") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='PFinish' size='15' value='" & Request.Form("PFinish") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & Request.Form("WTIHrs") & "</font><input type='hidden' name='WTIHrs' value='" & Request.Form("WTIHrs") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>" & Request.Form("WTIMins") & "</font><input type='hidden' name='WTIMins' value='" & Request.Form("WTIMins") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><font face='Verdana' size='2'>$ " & Request.Form("WTICost") & "</font><input type='hidden' name='WTICost' value='" & Request.Form("WTICost") & "'></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "          </table>"
			sRForm = sRForm & vbCrLf & "          </td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If (bRefresh = True) Then
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input type='submit' value='Refresh' name='B1'> <input type='submit' value='Skip' name='B1'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td colspan='4' align='center'><input type='submit' value='Generate Task(s)' name='B1'> <input type='submit' value='Skip' name='B1'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
	End Select
	
	GetGenForm = sRForm
End Function

Function GetGForm(sM, nGID)
	Dim sRText
	Dim sTemp
	Dim oRS
	
	Select Case sM
	
	
		Case "G"
			sRText = "    <form method='POST' action='wf_rtgroups.asp' id=form1 name=form1>"
			sRText = sRText & vbCrLf & "      <input type='hidden' name='Mode' value='GN'>"
			sRText = sRText & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Header Information</font></strong></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td colspan='2'><font face='Verdana' size='1'>During the assignment selection process in"
			sRText = sRText & vbCrLf & "          creating workflow actions, the <strong>Group Type</strong> will initially be selected. The"
			sRText = sRText & vbCrLf & "          resulting listing will provide the ability to select a specific group.</font></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Type:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><select name='GType' size='1'>"
			sRText = sRText & vbCrLf & "            <option>SELECT</option>"
			sRText = sRText & vbCrLf & GetWFSelect("WFGType", "", "(OptCode <> 'EMP')")
			sRText = sRText & vbCrLf & "          </select></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Name:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><input type='text' name='GName' size='45'></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='center' valign='top' colspan='2'><input type='submit' value='Continue' name='B1'> <input type='submit' value='New Group' name='B1'></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "      </table>"
			sRText = sRText & vbCrLf & "      </center></div>"
			sRText = sRText & vbCrLf & "    </form>"
			
			
		Case "GU"
			sTemp = Request.QueryString("G")
			sRText = "    <form method='POST' action='wf_rtgroups.asp' id=form1 name=form1>"
			sRText = sRText & vbCrLf & "      <input type='hidden' name='Mode' value='GU'>"
			sRText = sRText & vbCrLf & "      <input type='hidden' name='GID' value='" & sTemp & "'>"
			sRText = sRText & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Header Information</font></strong></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td colspan='2'><font face='Verdana' size='1'>During the assignment selection process in"
			sRText = sRText & vbCrLf & "          creating workflow actions, the <strong>Group Type</strong> will initially be selected. The"
			sRText = sRText & vbCrLf & "          resulting listing will provide the ability to select a specific group.</font></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			Set oRS = GetADORecordset("SELECT WFGroup, WFGroupType FROM WFGroups WHERE (WFGID = " & sTemp & ")", Nothing)
			oRS.MoveFirst
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Type:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><select name='GType' size='1'>"
			sRText = sRText & vbCrLf & "            <option>SELECT</option>"
			sRText = sRText & vbCrLf & GetWFSelect("WFGType", IIf(IsNull(oRS("WFGroupType")), "", oRS("WFGroupType")), "(OptCode <> 'EMP')")
			sRText = sRText & vbCrLf & "          </select></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Name:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><input type='text' name='GName' size='45'" & IIf(IsNull(oRS("WFGroup")), "", " value='" & oRS("WFGroup") & "'") & "></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			oRS.Close
			Set oRS = Nothing
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='center' valign='top' colspan='2'><input type='submit' value='Continue' name='B1'> <input type='submit' value='New Group' name='B1'></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "      </table>"
			sRText = sRText & vbCrLf & "      </center></div>"
			sRText = sRText & vbCrLf & "    </form>"
			
			
		Case "M"
			If (Request.QueryString("G") <> "") Then
				sTemp = Request.QueryString("G")
				sRText = "    <form method='POST' action='wf_rtgroups.asp' id=form1 name=form1>"
				sRText = sRText & vbCrLf & "      <input type='hidden' name='Mode' value='MN'>"
				sRText = sRText & vbCrLf & "      <input type='hidden' name='GID' value='" & sTemp & "'>"
				sRText = sRText & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Header Information</font></strong></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				Set oRS = GetADORecordset("SELECT WFGroup, WFGroupType FROM WFGroups WHERE (WFGID = " & sTemp & ")", Nothing)
				oRS.MoveFirst
				If IsNull(oRS("WFGroupType")) Then
					sTemp = ""
				Else
					sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & oRS("WFGroupType") & "')", Nothing)
				End If
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Type:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "<input type='hidden' name='GType' value='" & oRS("WFGroupType") & "'></font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Name:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WFGroup") & "<input type='hidden' name='GName'" & IIf(IsNull(oRS("WFGroup")), "", " value='" & oRS("WFGroup") & "'") & "></font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Members</font></strong></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				oRS.Close
				Set oRS = Nothing
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td colspan='2'><font face='Verdana' size='1'>Members of a group, depending on the type of"
				sRText = sRText & vbCrLf & "          group created, may be employees or various default values (i.e.: departments or processes)."
				sRText = sRText & vbCrLf & "          Utilizing both fields allows tasks assigned to a specific default name to be routed to a specific"
				sRText = sRText & vbCrLf & "          individual for forwarding (i.e.: routed to a supervisor) or completion of the task.</font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Select Employee:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><select name='EmpID' size='1'>"
				sRText = sRText & vbCrLf & "            <option>SELECT</option>"
				sRText = sRText & vbCrLf & GetSelect("EmpList", "")
				sRText = sRText & vbCrLf & "          </select></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>and/or, Provide Default:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><input type='text' name='MName' size='45'></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'>E-Mail:<br></font><font face='Verdana' size='1'><em>(if applicable)</em></font></td>"
				sRText = sRText & vbCrLf & "          <td><input type='text' name='MEmail' size='45'><br><font face='Verdana' size='1'><em>No input is necessary if an employee has been selected.</em></font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='center' valign='top' colspan='2'><input type='submit' value='Continue' name='B1'> <input type='submit' value='New Group' name='B1'></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "      </table>"
				sRText = sRText & vbCrLf & "      </center></div>"
				sRText = sRText & vbCrLf & "    </form>"
			Else
				sRText = "    <form method='POST' action='wf_rtgroups.asp' id=form1 name=form1>"
				sRText = sRText & vbCrLf & "      <input type='hidden' name='Mode' value='MN'>"
				sRText = sRText & vbCrLf & "      <input type='hidden' name='GID' value='" & IIf(Request.Form("GID") <> "", Request.Form("GID"), nG) & "'>"
				sRText = sRText & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Header Information</font></strong></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & Request.Form("GType") & "')", Nothing)
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Type:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "<input type='hidden' name='GType' value='" & Request.Form("GType") & "'></font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Name:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("GName") & "<input type='hidden' name='GName' value='" & Request.Form("GName") & "'></font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Members</font></strong></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td colspan='2'><font face='Verdana' size='1'>Members of a group, depending on the type of"
				sRText = sRText & vbCrLf & "          group created, may be employees or various default values (i.e.: departments or processes)."
				sRText = sRText & vbCrLf & "          Utilizing both fields allows tasks assigned to a specific default name to be routed to a specific"
				sRText = sRText & vbCrLf & "          individual for forwarding (i.e.: routed to a supervisor) or completion of the task.</font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Select Employee:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><select name='EmpID' size='1'>"
				sRText = sRText & vbCrLf & "            <option>SELECT</option>"
				sRText = sRText & vbCrLf & GetSelect("EmpList", "")
				sRText = sRText & vbCrLf & "          </select></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>and/or, Provide Default:</strong></font></td>"
				sRText = sRText & vbCrLf & "          <td><input type='text' name='MName' size='45'></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'>E-Mail:<br></font><font face='Verdana' size='1'><em>(if applicable)</em></font></td>"
				sRText = sRText & vbCrLf & "          <td><input type='text' name='MEmail' size='45'><br><font face='Verdana' size='1'><em>No input is necessary if an employee has been selected.</em></font></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "        <tr>"
				sRText = sRText & vbCrLf & "          <td align='center' valign='top' colspan='2'><input type='submit' value='Continue' name='B1'> <input type='submit' value='New Group' name='B1'></td>"
				sRText = sRText & vbCrLf & "        </tr>"
				sRText = sRText & vbCrLf & "      </table>"
				sRText = sRText & vbCrLf & "      </center></div>"
				sRText = sRText & vbCrLf & "    </form>"
			End If
		Case "MU"
			sTemp = Request.QueryString("GM")
			sRText = "    <form method='POST' action='wf_rtgroups.asp' id=form1 name=form1>"
			sRText = sRText & vbCrLf & "      <input type='hidden' name='Mode' value='MU'>"
			sRText = sRText & vbCrLf & "      <input type='hidden' name='GID' value='" & Request.QueryString("G") & "'>"
			sRText = sRText & vbCrLf & "      <input type='hidden' name='MID' value='" & sTemp & "'>"
			sRText = sRText & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Header Information</font></strong></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			Set oRS = GetADORecordset("SELECT WFGroup, WFGroupType FROM WFGroups WHERE (WFGID = " & Request.QueryString("G") & ")", Nothing)
			oRS.MoveFirst
			If IsNull(oRS("WFGroupType")) Then
				sTemp = ""
			Else
				sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFGroupType WHERE (OptCode = '" & oRS("WFGroupType") & "')", Nothing)
			End If
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Type:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><font face='Verdana' size='2'>" & sTemp & "<input type='hidden' name='GType' value='" & oRS("WFGroupType") & "'></font></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Group Name:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WFGroup") & "<input type='hidden' name='GName'" & IIf(IsNull(oRS("WFGroup")), "", " value='" & oRS("WFGroup") & "'") & "></font></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			oRS.Close
			Set oRS = GetADORecordset("SELECT WFMEmpID, WFMName, WFMEmail FROM WFGroupMembs WHERE (WFMID = " & Request.QueryString("GM") & ")", Nothing)
			oRS.MoveFirst
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td colspan='2' bgcolor='#D7D7D7'><strong><font face='Verdana' size='3'>Group Members</font></strong></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td colspan='2'><font face='Verdana' size='1'>Members of a group, depending on the type of"
			sRText = sRText & vbCrLf & "          group created, may be employees or various default values (i.e.: departments or processes)."
			sRText = sRText & vbCrLf & "          Utilizing both fields allows tasks assigned to a specific default name to be routed to a specific"
			sRText = sRText & vbCrLf & "          individual for forwarding (i.e.: routed to a supervisor) or completion of the task.</font></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Select Employee:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><select name='EmpID' size='1'>"
			sRText = sRText & vbCrLf & "            <option>SELECT</option>"
			sRText = sRText & vbCrLf & GetSelect("EmpList", IIf(IsNull(oRS("WFMEmpID")), "", oRS("WFMEmpID")))
			sRText = sRText & vbCrLf & "          </select></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>and/or, Provide Default:</strong></font></td>"
			sRText = sRText & vbCrLf & "          <td><input type='text' name='MName' size='45'" & IIf(IsNull(oRS("WFMName")), "", " value='" & oRS("WFMName") & "'") & "></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'>E-Mail:<br></font><font face='Verdana' size='1'><em>(if applicable)</em></font></td>"
			sRText = sRText & vbCrLf & "          <td><input type='text' name='MEmail' size='45'" & IIf(IsNull(oRS("WFMEmpID")), IIf(IsNull(oRS("WFMEmail")), "", " value='" & oRS("WFMEmail") & "'"), "") & "><br><font face='Verdana' size='1'><em>No input is necessary if an employee has been selected.</em></font></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			oRS.Close
			Set oRS = Nothing
			sRText = sRText & vbCrLf & "        <tr>"
			sRText = sRText & vbCrLf & "          <td align='center' valign='top' colspan='2'><input type='submit' value='Continue' name='B1'> <input type='submit' value='New Group' name='B1'></td>"
			sRText = sRText & vbCrLf & "        </tr>"
			sRText = sRText & vbCrLf & "      </table>"
			sRText = sRText & vbCrLf & "      </center></div>"
			sRText = sRText & vbCrLf & "    </form>"
	End Select
	
	GetGForm = sRText
End Function

Function GetActForm(sM)
	Dim sRForm
	Dim sTemp
	Dim oRS
	
	sTemp = ""
	'Format form contents including applicable values.
	
	
	Select Case sM
	
		Case "N"
		
			sRForm = "    <form method='POST' action='wf_add_act.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='R1'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Action Information</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Name:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='AName' size='54'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AType' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("ActType", "", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
			sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='ADesc' cols='54' wrap='physical'></textarea></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssignerType' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
			sRForm = sRForm & vbCrLf & "          </select> </td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssigneeType' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
			sRForm = sRForm & vbCrLf & "          </select> </td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='CRef' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", "", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
			sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'><font face='Verdana' size='2'>Updates controlled reference</font><br>"
			sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChgAcct' size='15'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='StdTask' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetSelect("StdTask", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
		Case "R1"
			sRForm = "    <form method='POST' action='wf_add_act.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='S'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Action Information</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			If (Request.Form("AName") <> "") Then sTemp = " value='" & CheckStrData(Request.Form("AName"), "DISPLAY") & "'" Else sTemp = ""
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Name:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='AName' size='54'" & sTemp & "></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			If (Request.Form("AType") <> "") Then sTemp = GetDataValue("SELECT OptDesc AS RetVal FROM QWFActType WHERE (OptCode = '" & Request.Form("AType") & "')", Nothing) Else sTemp = ""
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='AType' value='" & Request.Form("AType") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			If (Request.Form("ADesc") <> "") Then sTemp = CheckStrData(Request.Form("ADesc"), "DISPLAY") Else sTemp = ""
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
			sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='ADesc' cols='54' wrap='physical'>" & sTemp & "</textarea></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("AssignerType") <> "") And (Request.Form("AssignerType") <> "SELECT")) Then
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("AssignerType") & "</font><input type='hidden' name='AssignerType' value='" & Request.Form("AssignerType") & "'></td>"
				If (Request.Form("AssignerType") = "EMP") Then
					sList = GetSelect("EmpList", "")
				Else
					sList = GetWFSelect("RtGroup", "", Request.Form("AssignerType"))
				End If
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='AssnBy' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssignerType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "          </select> </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			If ((Request.Form("AssigneeType") <> "") And (Request.Form("AssigneeType") <> "SELECT")) Then
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("AssigneeType") & "</font><input type='hidden' name='AssigneeType' value='" & Request.Form("AssigneeType") & "'></td>"
				If (Request.Form("AssigneeType") = "EMP") Then
					sList = GetSelect("EmpList", "")
				Else
					sList = GetWFSelect("RtGroup", "", Request.Form("AssigneeType"))
				End If
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='AssnTo' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssigneeType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "          </select> </td>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='CRef' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", Request.Form("CRef"), "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
			sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(Request.Form("P1") = "Y", " checked", "") & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
			sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(Request.Form("P2") = "Y", " checked", "") & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChgAcct' size='15' value='" & Request.Form("ChgAcct") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If (Request.Form("StdTask") <> "") And (Request.Form("StdTask") <> "SELECT") Then
				Dim nDur, nHrs, nMin
				Set oRS = GetADORecordset("SELECT TaskDesc, TaskStdDur, TaskStdHrs FROM StdTasks WHERE (StdTaskID = '" & Request.Form("StdTask") & "')", Nothing)
				If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
					oRS.MoveFirst
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("TaskDesc")), "", oRS("TaskDesc")) & "</font><input type='hidden' name='StdTask' value='" & Request.Form("StdTask") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					nDur = IIf(IsNull(oRS("TaskStdDur")), 0, oRS("TaskStdDur"))
					nHrs = IIf(IsNull(oRS("TaskStdHrs")), 0, IIf(oRS("TaskStdHrs") = CInt(oRS("TaskStdHrs")), oRS("TaskStdHrs"), CInt(oRS("TaskStdHrs"))))
					nMin = IIf(IsNull(oRS("TaskStdHrs")), 0, IIf(oRS("TaskStdHrs") = CInt(oRS("TaskStdHrs")), 0, CInt((oRS("TaskStdHrs") - CInt(oRS("TaskStdHrs"))) * 60)))
					oRS.Close
				Else
					sTemp = GetDataValue("SELECT TaskDesc AS RetVal FROM StdTasks WHERE (StdTaskID = '" & Request.Form("StdTask") & "')", Nothing)
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='StdTask' value='" & Request.Form("StdTask") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					nDur = 0
					nHrs = 0
					nMin = 0
				End If
				Set oRS = Nothing
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTask' value=''></td>"
				'sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='StdTask' size='1'>"
				'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				'sRForm = sRForm & vbCrLf & GetSelect("StdTask", Request.Form("StdTask"))
				'sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				nDur = 0
				nHrs = 0
				nMin = 0
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Duration (days)</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Minutes</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ADur' size='5' value='" & nDur & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AHrs' size='5' value='" & nHrs & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AMin' size='5' value='" & nMin & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='ACost' size='12' value='0'></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "          </table>"
			sRForm = sRForm & vbCrLf & "          </td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='submit' value='Save Action' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
		Case "RU"
			If (Request.QueryString("A") <> "") Then
				sTemp = Request.QueryString("A")
			Else
				sTemp = Request.Form("AID")
			End If
			Set oRS = GetADORecordset("SELECT * FROM ViewWFActions WHERE (WAID = " & sTemp & ")", Nothing)
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
				sRForm = "    <form method='POST' action='wf_add_act.asp' id=form1 name=form1>"
				sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='U'>"
				sRForm = sRForm & vbCrLf & "      <input type='hidden' name='AID' value='" & sTemp & "'>"
				sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Workflow Action Information</strong></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Name:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='AName' size='54'" & IIf(IsNull(oRS("WAName")), "", " value='" & oRS("WAName") & "'") & "></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("AType") & "</font><input type='hidden' name='AType' value='" & oRS("WAType") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
				sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='ADesc' cols='54' wrap='physical'>" & oRS("WADesc") & "</textarea></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WAAByType")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AByType") & "</font><input type='hidden' name='AssignerType' value='" & oRS("WAAByType") & "'></td>"
					If Not IsNull(oRS("WAAssnBy")) Then
						If (oRS("WAAByType") = "EMP") Then
							sList = GetSelect("EmpList", oRS("WAAssnBy"))
						Else
							sList = GetWFSelect("RtGroup", oRS("WAAssnBy"), oRS("WAAByType"))
						End If
					Else
						If (oRS("WAAByType") = "EMP") Then
							sList = GetSelect("EmpList", "")
						Else
							sList = GetWFSelect("RtGroup", "", oRS("WAAByType"))
						End If
					End If
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='AssnBy' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssignerType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "          </select> </td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
			
				If Not IsNull(oRS("WAAToType")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AToType") & "</font><input type='hidden' name='AssigneeType' value='" & oRS("WAAToType") & "'></td>"
					If Not IsNull(oRS("WAAssnTo")) Then
						If (oRS("WAAToType") = "EMP") Then
							sList = GetSelect("EmpList", oRS("WAAssnTo"))
						Else
							sList = GetWFSelect("RtGroup", oRS("WAAssnTo"), oRS("WAAToType"))
						End If
					Else
						If (oRS("WAAToType") = "EMP") Then
							sList = GetSelect("EmpList", "")
						Else
							sList = GetWFSelect("RtGroup", "", oRS("WAAToType"))
						End If
					End If
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='AssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssigneeType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "          </select> </td>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='CRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WACtrlRef"), "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
				sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(IsNull(oRS("WAParams")), "", IIf(Left(oRS("WAParams"), 1) = "1", " checked", "")) & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
				sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(IsNull(oRS("WAParams")), "", IIf(Right(oRS("WAParams"), 1) = "1", " checked", "")) & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChgAcct' size='15' value='" & oRS("WAChgAcct") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WAStdTaskID")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font><input type='hidden' name='StdTask' value='" & oRS("WAStdTaskID") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTask' value=''></td>"
					'sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='StdTask' size='1'>"
					'sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					'sRForm = sRForm & vbCrLf & GetSelect("StdTask", Request.Form("StdTask"))
					'sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Duration (days)</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Minutes</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ADur' size='5' value='" & oRS("WADur") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AHrs' size='5' value='" & oRS("WAHrs") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AMin' size='5' value='" & oRS("WAMins") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='ACost' size='12' value='" & oRS("WACost") & "'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "          </table>"
				sRForm = sRForm & vbCrLf & "          </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='submit' value='Save Action' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "      </table>"
				sRForm = sRForm & vbCrLf & "      </center></div>"
				sRForm = sRForm & vbCrLf & "    </form>"
				oRS.Close
			Else
				sRForm = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while "
				sRForm = sRForm & vbCrLf & "attempting to build the form. The selected record could not be located.</font></p>"
			End If
			Set oRS = Nothing
	End Select
	
	GetActForm = sRForm
End Function








Function GetTempForm(sM, nID)
	Dim sRForm
	Dim sTemp
	Dim oRS
	
	Select Case sM
		Case "N"
			sRForm = "    <form method='POST' action='wf_addedit.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='HN'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Template Header Information</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Template Name:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top'><input type='text' name='TName' size='54'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Template Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='TType' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("TempType", "", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'>Description:</font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top'><textarea rows='2' name='TDesc' cols='54' wrap='physical'></textarea></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top'><input type='submit' value='Save Template Header' name='B1'> <input type='reset' value='Reset Form' name='B2'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
		Case "U"
			If (nID <> "") Then
				Set oRS = GetADORecordset("SELECT WTName, WTType, WTDesc FROM WFlowTemplate WHERE (WTID = " & nID & ")", Nothing)
				
				If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
					oRS.MoveFirst
					sRForm = "    <form method='POST' action='wf_addedit.asp' id=form1 name=form1>"
					sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='HU'>"
					sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TID' value='" & nID & "'>"
					sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Template Header Information</strong></font></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					If IsNull(oRS("WTName")) Then sTemp = "" Else sTemp = oRS("WTName")
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Template Name:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td valign='top'><input type='text' name='TName' size='54'" & IIf(sTemp <> "", " value='" & sTemp & "'", "") & "></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Template Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='TType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("TempType", oRS("WTType"), "")
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					If IsNull(oRS("WTDesc")) Then sTemp = "" Else sTemp = oRS("WTDesc")
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'>Description:</font></td>"
					sRForm = sRForm & vbCrLf & "          <td valign='top'><textarea rows='2' name='TDesc' cols='54' wrap='physical'>" & sTemp & "</textarea></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap></td>"
					sRForm = sRForm & vbCrLf & "          <td valign='top'><input type='submit' value='Save Template Header' name='B1'> <input type='reset' value='Reset Form' name='B2'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "      </table>"
					sRForm = sRForm & vbCrLf & "      </center></div>"
					sRForm = sRForm & vbCrLf & "    </form>"
					oRS.Close
				Else
					sRForm = "<p><font face='Verdana' size='3'><strong>ERROR:</strong> An unexpected error occurred while "
					sRForm = sRForm & vbCrLf & "attempting to load the form controls. The selected record could not be retrieved.</font></p>"
				End If
				
				Set oRS = Nothing
			End If
	End Select
	
	GetTempForm = sRForm
End Function

Function GetTItemForm(sM, nTID)
	Dim sRForm
	Dim sTemp
	Dim oRS
	Dim sCMD
	Dim bRefresh
	Dim bRevert
	Dim sList
	
	bRefresh = False
	bRevert = False
	Select Case sM
	
		Case "N"
			sRForm = "    <form method='POST' action='wf_addedit.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='R1'>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TID' value='" & nTID & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='2' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Add/Define Workflow Step</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Select Action:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><select name='TItem' size='1'>"
			sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
			sRForm = sRForm & vbCrLf & GetWFSelect("WActions", "", "")
			sRForm = sRForm & vbCrLf & "          </select></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='2' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
		Case "R1"
		
			sTemp = Request.Form("TItem")
			sRForm = "    <form method='POST' action='wf_addedit.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TID' value='" & nTID & "'>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TItem' value='" & sTemp & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Add/Define Workflow Step</strong></font></td>"
			
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			
			
			sCMD = "SELECT WAName, WAType, WADesc, WAStdTaskID, WAChgAcct, WADur, WAHrs, WAMins, WACost, WAAByType, WAAssnBy, "
			sCMD = sCMD & "WAAToType, WAAssnTo, WACtrlRef, WAParams FROM WFlowActions WHERE (WAID = " & sTemp & ")"
			
			
			
			
			Set oRS = GetADORecordset(sCMD, Nothing)
			
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
			
				sTemp = CheckStrData(oRS("WAName"), "DISPLAY")
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Selected Action:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "<input type='hidden' name='AName' value='" & oRS("WAName") & "'></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			
			
			
			
				sTemp = GetDataValue("SELECT (MAX(WTIStep) + 1) AS RetVal FROM WFlowTempItems WHERE (WTID = " & nTID & ")", Nothing)
				If (sTemp = "") Then sTemp = 1
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Step Number:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Step' size='5' value='" & sTemp & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
				
				
				
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WAType") & "</font><input type='hidden' name='AType' value='" & oRS("WAType") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WACtrlRef")) Then
					'Task References
					sList = GetRStatusList(oRS("WACtrlRef"), "")
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Next' size='5' value='" & sTemp + 1 & "'></td>"  
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='NStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					
					
					
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Back' size='5' value='" & sTemp - 1 & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='BStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					
					
					
				Else
				
				
				
				
					sRForm = sRForm & vbCrLf & "        <tr>"
					
					
					
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='Next' size='5' value='" & sTemp + 1 & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					
					
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Back' size='5' value='" & sTemp - 1 & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					
					
					
				End If
				
				
				
				If Not IsNull(oRS("WADesc")) Then sTemp = CheckStrData(oRS("WADesc"), "DISPLAY") Else sTemp = ""
				
				
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
				sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='ADesc' cols='54' wrap='physical'>" & sTemp & "</textarea></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				
				If Not IsNull(oRS("WAAByType")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WAAByType") & "</font><input type='hidden' name='AssignerType' value='" & oRS("WAAByType") & "'></td>"
					
					If Not IsNull(oRS("WAAssnBy")) Then
						If (oRS("WAAByType") = "EMP") Then
							sList = GetSelect("EmpList", oRS("WAAssnBy"))
						Else
							sList = GetWFSelect("RtGroup", oRS("WAAssnBy"), oRS("WAAByType"))
						End If
					Else
						If (oRS("WAAByType") = "EMP") Then
							sList = GetSelect("EmpList", "")
						Else
							sList = GetWFSelect("RtGroup", "", oRS("WAAByType"))
						End If
						bRefresh = True
					End If
					
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='AssnBy' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssignerType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "          </select> </td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					bRefresh = True
				End If
				
				If Not IsNull(oRS("WAAToType")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("WAAToType") & "</font><input type='hidden' name='AssigneeType' value='" & oRS("WAAToType") & "'></td>"
					If Not IsNull(oRS("WAAssnTo")) Then
						If (oRS("WAAToType") = "EMP") Then
							sList = GetSelect("EmpList", oRS("WAAssnTo"))
						Else
							sList = GetWFSelect("RtGroup", oRS("WAAssnTo"), oRS("WAAToType"))
						End If
					Else
						If (oRS("WAAToType") = "EMP") Then
							sList = GetSelect("EmpList", "")
						Else
							sList = GetWFSelect("RtGroup", "", oRS("WAAToType"))
						End If
						bRefresh = True
					End If
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='AssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssigneeType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "          </select> </td>"
					bRefresh = True
				End If
				
				If Not IsNull(oRS("WACtrlRef")) Then
				
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
					
					'sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='CRef' value='" & sTemp & "'></td>"
					
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='CRef' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WACtrlRef"), "")
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					
					If Not IsNull(oRS("WAParams")) Then
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
						sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
						sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(Left(oRS("WAParams"), 1) = "1", " checked", "") & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
						sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(Right(oRS("WAParams"), 1) = "1", " checked", "") & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					Else
						sRForm = sRForm & vbCrLf & "        <tr>"
						sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
						sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
						sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'><font face='Verdana' size='2'>Updates controlled reference</font><br>"
						sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
						sRForm = sRForm & vbCrLf & "        </tr>"
					End If
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChgAcct' size='15'" & IIf(IsNull(oRS("WAChgAcct")), "", " value='" & oRS("WAChgAcct") & "'") & "></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WAStdTaskID")) Then
					sTemp = GetDataValue("SELECT TaskDesc AS RetVal FROM StdTasks WHERE (StdTaskID = '" & oRS("WAStdTaskID") & "')", Nothing)
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='StdTask' value='" & oRS("WAStdTaskID") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTask' value=''></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Duration (days)</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Minutes</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ADur' size='5' value='" & oRS("WADur") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AHrs' size='5' value='" & oRS("WAHrs") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AMin' size='5' value='" & oRS("WAMins") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='ACost' size='12' value='" & oRS("WACost") & "'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "          </table>"
				sRForm = sRForm & vbCrLf & "          </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				oRS.Close
			Else
				bRevert = True
			End If
			Set oRS = Nothing
			
			If (bRevert = False) Then
				If (bRefresh = False) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='4' align='center'><input type='submit' value='Save Step' name='B1'> <input type='submit' value='Cancel' name='B1'><input type='hidden' name='Mode' value='IN'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "      </table>"
					sRForm = sRForm & vbCrLf & "      </center></div>"
					sRForm = sRForm & vbCrLf & "    </form>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='4' align='center'><input type='submit' value='Continue' name='B1'> <input type='submit' value='Cancel' name='B1'><input type='hidden' name='Mode' value='R2'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "      </table>"
					sRForm = sRForm & vbCrLf & "      </center></div>"
					sRForm = sRForm & vbCrLf & "    </form>"
				End If
			Else
				sRForm = GetTItemForm("N", nTID)
				'sRForm = "<p>ERROR</p>"
			End If
			
			
			
		Case "R2"
		
		
		
			sTemp = Request.Form("TItem")
			sRForm = "    <form method='POST' action='wf_addedit.asp' id=form1 name=form1>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='IN'>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TID' value='" & nTID & "'>"
			sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TItem' value='" & sTemp & "'>"
			sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Add/Define Workflow Step</strong></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sTemp = CheckStrData(Request.Form("AName"), "DISPLAY")
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Selected Action:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "<input type='hidden' name='AName' value='" & sTemp & "'></font></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Step Number:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Step' size='5' value='" & Request.Form("Step") & "'></td>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("AType") & "</font><input type='hidden' name='AType' value='" & Request.Form("AType") & "'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("CRef") <> "") And (Request.Form("CRef") <> "SELECT")) Then
				'Task References
				sList = GetRStatusList(Request.Form("CRef"), Request.Form("NStatus"))
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Next' size='5' value='" & Request.Form("Next") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='NStatus' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sList = GetRStatusList(Request.Form("CRef"), Request.Form("BStatus"))
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Back' size='5' value='" & Request.Form("Back") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='BStatus' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='Next' size='5' value='" & Request.Form("Next") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Back' size='5' value='" & Request.Form("Back") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
			sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='ADesc' cols='54' wrap='physical'>" & Request.Form("ADesc") & "</textarea></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("AssignerType") <> "") And (Request.Form("AssignerType") <> "SELECT")) Then
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("AssignerType") & "</font><input type='hidden' name='AssignerType' value='" & Request.Form("AssignerType") & "'></td>"
				If ((Request.Form("AssnBy") <> "") And (Request.Form("AssnBy") <> "SELECT")) Then
					If (Request.Form("AssignerType") = "EMP") Then
						sList = GetSelect("EmpList", Request.Form("AssnBy"))
					Else
						sList = GetWFSelect("RtGroup", Request.Form("AssnBy"), Request.Form("AssignerType"))
					End If
				Else
					If (Request.Form("AssignerType") = "EMP") Then
						sList = GetSelect("EmpList", "")
					Else
						sList = GetWFSelect("RtGroup", "", Request.Form("AssignerType"))
					End If
				End If
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='AssnBy' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sList = GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssignerType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select> </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			If ((Request.Form("AssigneeType") <> "") And (Request.Form("AssigneeType") <> "SELECT")) Then
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & Request.Form("AssigneeType") & "</font><input type='hidden' name='AssigneeType' value='" & Request.Form("AssigneeType") & "'></td>"
				If ((Request.Form("AssnTo") <> "") And (Request.Form("AssnTo") <> "SELECT")) Then
					If (Request.Form("AssigneeType") = "EMP") Then
						sList = GetSelect("EmpList", Request.Form("AssnTo"))
					Else
						sList = GetWFSelect("RtGroup", Request.Form("AssnTo"), Request.Form("AssigneeType"))
					End If
				Else
					If (Request.Form("AssigneeType") = "EMP") Then
						sList = GetSelect("EmpList", "")
					Else
						sList = GetWFSelect("RtGroup", "", Request.Form("AssigneeType"))
					End If
				End If
				sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><select name='AssnTo' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				
				
			Else
			
			
				sList = GetWFSelect("GroupType", "", "")
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssigneeType' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & sList
				sRForm = sRForm & vbCrLf & "          </select> </td>"
				
			End If
			
			If ((Request.Form("CRef") <> "") And (Request.Form("CRef") <> "SELECT")) Then
			
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
				'sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='CRef' value='" & sTemp & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='CRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", Request.Form("CRef"), "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
				sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(Request.Form("P1") = "Y", " checked", "") & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
				sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(Request.Form("P2") = "Y", " checked", "") & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChgAcct' size='15'" & IIf(Request.Form("ChgAcct") <> "", " value='" & Request.Form("ChgAcct") & "'", "") & "></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			
			If ((Request.Form("StdTask") <> "") And (Request.Form("StdTask") <> "SELECT")) Then
				sTemp = GetDataValue("SELECT TaskDesc AS RetVal FROM StdTasks WHERE (StdTaskID = '" & Request.Form("StdTask") & "')", Nothing)
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & sTemp & "</font><input type='hidden' name='StdTask' value='" & Request.Form("StdTask") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			Else
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTask' value=''></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
			End If
			
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
			sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Duration (days)</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Minutes</strong></font></td>"
			sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "            <tr>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ADur' size='5' value='" & Request.Form("ADur") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AHrs' size='5' value='" & Request.Form("AHrs") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AMin' size='5' value='" & Request.Form("AMin") & "'></td>"
			sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='ACost' size='12' value='" & Request.Form("ACost") & "'></td>"
			sRForm = sRForm & vbCrLf & "            </tr>"
			sRForm = sRForm & vbCrLf & "          </table>"
			sRForm = sRForm & vbCrLf & "          </td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "        <tr>"
			sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='4' align='center'><input type='submit' value='Save Step' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
			sRForm = sRForm & vbCrLf & "        </tr>"
			sRForm = sRForm & vbCrLf & "      </table>"
			sRForm = sRForm & vbCrLf & "      </center></div>"
			sRForm = sRForm & vbCrLf & "    </form>"
			
			
			
			
		Case "R3"
			sTemp = Request.QueryString("TI")
			Set oRS = GetADORecordset("SELECT * FROM ViewWFTItems WHERE (WTIID = " & sTemp & ")", Nothing)
			
			If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
				oRS.MoveFirst
				sRForm = "    <form method='POST' action='wf_addedit.asp' id=form1 name=form1>"
				sRForm = sRForm & vbCrLf & "      <input type='hidden' name='Mode' value='IU'>"
				sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TID' value='" & nTID & "'>"
				sRForm = sRForm & vbCrLf & "      <input type='hidden' name='TItem' value='" & sTemp & "'>"
				sRForm = sRForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0' width='100%'>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' nowrap colspan='4' bgcolor='#D7D7D7'><font face='Verdana' size='3'><strong>Add/Define Workflow Step</strong></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Selected Action:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("WTIName") & "<input type='hidden' name='AName' value='" & oRS("WTIName") & "'></font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Step Number:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Step' size='5' value='" & oRS("WTIStep") & "'></td>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Action Type:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("TIType") & "</font><input type='hidden' name='AType' value='" & oRS("WTIType") & "'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WTICtrlRef")) Then
					'Task References
					sList = GetRStatusList(oRS("WTICtrlRef"), oRS("WTINextStatus"))
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Next' size='5' value='" & oRS("WTINext") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Status:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='NStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sList = GetRStatusList(oRS("WTICtrlRef"), oRS("WTIBackStatus"))
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Back' size='5' value='" & oRS("WTIBack") & "'></td>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Status:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='BStatus' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Next Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='Next' size='5' value='" & oRS("WTINext") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Back Step:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><input type='text' name='Back' size='5' value='" & oRS("WTIBack") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Description/<br>"
				sRForm = sRForm & vbCrLf & "          Assignment/<br>Instructions:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><textarea rows='3' name='ADesc' cols='54' wrap='physical'>" & oRS("WTIDesc") & "</textarea></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WTIAByType")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AByType") & "</font><input type='hidden' name='AssignerType' value='" & oRS("WTIAByType") & "'></td>"
					If Not IsNull(oRS("WTIAssnBy")) Then
						If (oRS("WTIAByType") = "EMP") Then
							sList = GetSelect("EmpList", oRS("WTIAssnBy"))
						Else
							sList = GetWFSelect("RtGroup", oRS("WTIAssnBy"), oRS("WTIAByType"))
						End If
					Else
						If (oRS("WTIAByType") = "EMP") Then
							sList = GetSelect("EmpList", "")
						Else
							sList = GetWFSelect("RtGroup", "", oRS("WTIAByType"))
						End If
					End If
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned By:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='AssnBy' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sList = GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assigner Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssignerType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select> </td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
			
				If Not IsNull(oRS("WTIAToType")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("AToType") & "</font><input type='hidden' name='AssigneeType' value='" & oRS("WTIAToType") & "'></td>"
					If Not IsNull(oRS("WTIAssnTo")) Then
						If (oRS("WTIAToType") = "EMP") Then
							sList = GetSelect("EmpList", oRS("WTIAssnTo"))
						Else
							sList = GetWFSelect("RtGroup", oRS("WTIAssnTo"), oRS("WTIAToType"))
						End If
					Else
						If (oRS("WTIAToType") = "EMP") Then
							sList = GetSelect("EmpList", "")
						Else
							sList = GetWFSelect("RtGroup", "", oRS("WTIAToType"))
						End If
					End If
					sRForm = sRForm & vbCrLf & "          <td nowrap align='right'><font face='Verdana' size='2'><strong>Assigned To:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td><select name='AssnTo' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sList = GetWFSelect("GroupType", "", "")
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Assignee Type:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='AssigneeType' size='1'>"
					sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
					sRForm = sRForm & vbCrLf & sList
					sRForm = sRForm & vbCrLf & "          </select> </td>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Ref. Controlled:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><select name='CRef' size='1'>"
				sRForm = sRForm & vbCrLf & "            <option>SELECT</option>"
				sRForm = sRForm & vbCrLf & GetWFSelect("TaskRefType", oRS("WTICtrlRef"), "")
				sRForm = sRForm & vbCrLf & "          </select></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' valign='top' nowrap><font face='Verdana' size='2'><strong>Parameters:</strong><br>"
				sRForm = sRForm & vbCrLf & "          <em>(Requires Ref.)</em></font></td>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='3'><input type='checkbox' name='P1' value='Y'" & IIf(IsNull(oRS("WTIParams")), "", IIf(Left(oRS("WTIParams"), 1) = "1", " checked", "")) & "><font face='Verdana' size='2'>Updates controlled reference</font><br>"
				sRForm = sRForm & vbCrLf & "          <input type='checkbox' name='P2' value='Y'" & IIf(IsNull(oRS("WTIParams")), "", IIf(Right(oRS("WTIParams"), 1) = "1", " checked", "")) & "><font face='Verdana' size='2'>Allow additions to controlled reference</font></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Charge Acct:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><input type='text' name='ChgAcct' size='15'" & IIf(IsNull(oRS("WTIChgAcct")), "", " value='" & oRS("WTIChgAcct") & "'") & "></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				
				If Not IsNull(oRS("WTIStdTaskID")) Then
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>" & oRS("TaskDesc") & "</font><input type='hidden' name='StdTask' value='" & oRS("WTIStdTaskID") & "'></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				Else
					sRForm = sRForm & vbCrLf & "        <tr>"
					sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Standard Task:</strong></font></td>"
					sRForm = sRForm & vbCrLf & "          <td colspan='3'><font face='Verdana' size='2'>NONE</font><input type='hidden' name='StdTask' value=''></td>"
					sRForm = sRForm & vbCrLf & "        </tr>"
				End If
				
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td align='right' nowrap><font face='Verdana' size='2'><strong>Schedule:</strong></font></td>"
				sRForm = sRForm & vbCrLf & "          <td colspan='3'><table border='0' cellpadding='2' width='100%'>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Duration (days)</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Hours</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Minutes</strong></font></td>"
				sRForm = sRForm & vbCrLf & "              <td bgcolor='#D7D7D7'><font face='Verdana' size='1'><strong>Cost</strong></font></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "            <tr>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='ADur' size='5' value='" & oRS("WTIDur") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AHrs' size='5' value='" & oRS("WTIHrs") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><input type='text' name='AMin' size='5' value='" & oRS("WTIMins") & "'></td>"
				sRForm = sRForm & vbCrLf & "              <td><strong><font face='Verdana' size='2'>$</font></strong><input type='text' name='ACost' size='12' value='" & oRS("WTICost") & "'></td>"
				sRForm = sRForm & vbCrLf & "            </tr>"
				sRForm = sRForm & vbCrLf & "          </table>"
				sRForm = sRForm & vbCrLf & "          </td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "        <tr>"
				sRForm = sRForm & vbCrLf & "          <td valign='top' colspan='4' align='center'><input type='submit' value='Save Action' name='B1'> <input type='submit' value='Cancel' name='B1'></td>"
				sRForm = sRForm & vbCrLf & "        </tr>"
				sRForm = sRForm & vbCrLf & "      </table>"
				sRForm = sRForm & vbCrLf & "      </center></div>"
				sRForm = sRForm & vbCrLf & "    </form>"
				oRS.Close
				Set oRS = Nothing
			End If
	End Select
	
	GetTItemForm = sRForm
End Function

%>
