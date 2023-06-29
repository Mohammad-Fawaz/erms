<%
Dim vNewNum

Function GetUpDir(sRef)
	Dim sSQL
	Dim sTemp
	
	If (sRef <> "") Then
		sSQL = "SELECT AttDir AS RetVal FROM AttDefs WHERE (AttRef = 'EWEB') AND (AttType = '" & sRef & "')"
		sTemp = GetDataValue(sSQL, Nothing)
	Else
		sTemp = ""
	End If
	
	GetUpDir = sTemp
End Function

Function WriteRec(vRec, sParam1, sParam2)
	Dim sSQL
    Dim sFields
    Dim sVals
    Dim bRet
    Dim iRet
    Dim i
    Dim sRefs
    Dim sRetText
    Dim sRetRec
    Dim sRecVal
    Dim sRec
    Dim vTemp
    Dim val1, val2, val3, val4, val5, val6, val7, val8, val9
    
    sSQL = ""
    sFields = ""
    sVals = ""

    
    Select Case vRec
        Case "Element"
			If (Request.Form("W1") <> "") And (Request.Form("Thick") <> "") And (Request.Form("WPN") <> "") Then
				'val1 = WaferDiameter(Request.Form("WPN"))
				val1 = GetDataValue("SELECT FIRST(Par10) AS RetVal FROM PartPar WHERE (DocID = '" & Request.Form("WPN") & "')", Nothing)			
			    
				val2 = ElementQty(Request.Form("Thick"), val1, Request.Form("W1"))
			
				If (val2 = "") Then
					sSQL = ""
					sRetText = "The [Quantity] could not be properly determined. No lookup record was found."										
				Else						   
			
					If (sParam1 = "A") Then
						'PartID (Auto-Number)
						'PartNo
						'DocID
						sFields = "PartNo, DocID"
						sVals = "'" & Request.Form("PartNo") & "', '" & Request.QueryString("DocID") & "'"
						'MatlPn	-	[WPN]
						sFields = sFields & ", MatlPn"
				 
						If (Request.Form("WPN") <> "") And (Request.Form("Thick") <> "") Then
							'vTemp = WaferPart(Request.Form("WPN"), Request.Form("Thick"))
			    
							If (vTemp = "") Then vTemp = NewWafer(Request.QueryString("DocID"), Request.Form("Thick"))
							If (vTemp <> "") Then
								sVals = sVals & ", '" & vTemp & "'"
							Else
								sVals = sVals & ", NULL"								
							End If
						Else
							sVals = sVals & ", NULL"
						End If
						vTemp = ""
						'ProcPn	-	Unused
						'RefInfo	-	Unused
						'Par1	-	[W1]
						'Par2	-	If ([W1] < 0.050) Then 0.001 Else 0.002
						sFields = sFields & ", Par1, Par2"
						If (Request.Form("W1") <> "") Then
							sVals = sVals & ", '" & Request.Form("W1") & "'"
							If (CDbl(Request.Form("W1")) < 0.050) Then sVals = sVals & ", '0.001'" Else sVals = sVals & ", '0.002'"
						Else
							sVals = sVals & ", '0', '0'"
						End If
						'Par3	-	[W2]
						'Par4	-	If ([W2] < 0.050) Then 0.001 Else 0.002
						sFields = sFields & ", Par3, Par4"
						If (Request.Form("W2") <> "") Then
							sVals = sVals & ", '" & Request.Form("W2") & "'"
							If (CDbl(Request.Form("W2")) < 0.050) Then sVals = sVals & ", '0.001'" Else sVals = sVals & ", '0.002'"
						Else
							sVals = sVals & ", '0', '0'"
						End If
						'Par5	-	[Thick]
						sFields = sFields & ", Par5"
						If (Request.Form("Thick") <> "") Then
							sVals = sVals & ", '" & Request.Form("Thick") & "'"
						Else
							sVals = sVals & ", '0'"
						End If
						'Par7	-	ElementQty(Thickness, WaferDiameter, WidthA)
						sFields = sFields & ", Par7"
						If (val2 <> "") Then
							sVals = sVals & ", '" & val2 & "'"
						Else
							sVals = sVals & ", '0'"
						End If
						'Par8	-	0
						'Par9	-	0
						sFields = sFields & ", Par8, Par9"
						sVals = sVals & ", '0', '0'"
						'Par10	-	(Diameter)
						sFields = sFields & ", Par10"
						'If (Request.Form("WPN") <> "") Then
						'	vTemp = WaferDiameter(Request.Form("WPN"))
						'Else
						'	vTemp = WaferDiameter(Request.QueryString("DocID"))
						'End If
						If (val1 <> "") Then
							sVals = sVals & ", '" & val1 & "'"
						Else
							sVals = sVals & ", '0'"
						End If
						'Par11	-	(Slice Formula)
						sFields = sFields & ", Par11"
						If (Request.Form("WPN") <> "") Then
							'vTemp = SliceFormula(Request.Form("WPN"))
							vTemp = GetDataValue("SELECT FIRST(Par11) AS RetVal FROM PartPar WHERE (Par1 = '0') AND (DocID = '" & Request.Form("WPN") & "')", Nothing)
						Else
							'vTemp = SliceFormula(Request.QueryString("DocID"))
							vTemp = GetDataValue("SELECT FIRST(Par11) AS RetVal FROM PartPar WHERE (Par1 = '0') AND (DocID = '" & Request.QueryString("DocID") & "')", Nothing)
						End If
						If (vTemp <> "") Then
							sVals = sVals & ", '" & vTemp & "'"
						Else
							sVals = sVals & ", '0'"
						End If
						'Par6	-	0.0005 (Determined by slice formula)
						sFields = sFields & ", Par6"
						Select Case vTemp
							Case "-.006", "-0.006"
								sVals = sVals & ", '0.003'"
							Case "/2 - .006", "/2 - 0.006", "/2-.006"
								sVals = sVals & ", '0.006'"
							Case Else
								sVals = sVals & ", '0.0005'"
						End Select
						
						sSQL = "INSERT INTO PartPar (" & sFields & ") VALUES (" & sVals & ")"
					Else
						'PartID (Auto-Number)
						'PartNo
						sVals = "(PartNo = '" & Request.QueryString("Item") & "')"
						If (Request.Form("PartNo") <> Request.QueryString("Item")) Then
							sFields = "PartNo = '" & Request.Form("PartNo") & "'"
						End If
						'MatlPn	-	[WPN]
						If (Request.Form("WPN") <> "") And (Request.Form("Thick") <> "") Then
							vTemp = WaferPart(Request.Form("WPN"), Request.Form("Thick"))
							If (vTemp = "") Then vTemp = NewWafer(Request.QueryString("DocID"), Request.Form("Thick"))
							If (vTemp <> "") Then
								sFields = IIf(sFields <> "", sFields & ", ", "") & "MatlPn = '" & vTemp & "'"
							End If
						End If
						vTemp = ""
						'ProcPn	-	Unused
						'RefInfo	-	Unused
						'Par1	-	[W1]
						'Par2	-	If ([W1] < 0.050) Then 0.001 Else 0.002
						If (Request.Form("W1") <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "Par1 = '" & Request.Form("W1") & "'"
							If (CDbl(Request.Form("W1")) < 0.050) Then sFields = sFields & ", Par2 = '0.001'" Else sFields = sFields & ", Par2 = '0.002'"
						End If
						'Par3	-	[W2]
						'Par4	-	If ([W2] < 0.050) Then 0.001 Else 0.002
						If (Request.Form("W2") <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "Par3 = '" & Request.Form("W1") & "'"
							If (CDbl(Request.Form("W2")) < 0.050) Then sFields = sFields & ", Par4 = '0.001'" Else sFields = sFields & ", Par4 = '0.002'"
						End If
						'Par5	-	[Thick]
						If (Request.Form("Thick") <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "Par5 = '" & Request.Form("Thick") & "'"
						End If
						'Par7	-	ElementQty(Thickness, WaferDiameter, WidthA)
						If (val2 <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "Par7 = '" & val2 & "'"
						End If
						'Par10	-	(Diameter)
						'If (Request.Form("WPN") <> "") Then
						'	vTemp = WaferDiameter(Request.Form("WPN"))
						'Else
						'	vTemp = WaferDiameter(Request.QueryString("DocID"))
						'End If
						If (val1 <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "Par10 = '" & val1 & "'"
						End If
						'Par11	-	(Slice Formula)
						If (Request.Form("WPN") <> "") Then
							'vTemp = SliceFormula(Request.Form("WPN"))
							vTemp = GetDataValue("SELECT FIRST(Par11) AS RetVal FROM PartPar WHERE (Par1 = '0') AND (DocID = '" & Request.Form("WPN") & "')", Nothing)
						Else
							'vTemp = SliceFormula(Request.QueryString("DocID"))
							vTemp = GetDataValue("SELECT FIRST(Par11) AS RetVal FROM PartPar WHERE (Par1 = '0') AND (DocID = '" & Request.QueryString("DocID") & "')", Nothing)
						End If
						If (vTemp <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "Par11 = '" & vTemp & "'"
						End If
						'Par6	-	0.0005 (Determined by slice formula)
						Select Case vTemp
							Case "-.006", "-0.006"
								sFields = IIf(sFields <> "", sFields & ", ", "") & "Par6 = '0.003'"
							Case "/2 - .006", "/2 - 0.006", "/2-.006"
								sFields = IIf(sFields <> "", sFields & ", ", "") & "Par6 = '0.006'"
							Case Else
								sFields = IIf(sFields <> "", sFields & ", ", "") & "Par6 = '0.0005'"
						End Select
						
						If (sFields <> "") Then
							'DocID
							'Par8	-	0
							'Par9	-	0
							sFields = sFields & ", DocID = '" & Request.QueryString("DocID") & "', Par8 = '0', Par9 = '0'"
							sSQL = "UPDATE PartPar SET " & sFields & " WHERE " & sVals
						Else
							sSQL = ""
						End If
					End If
				End If
			Else
				sSQL = ""
				sRetText = "Some required information was not included. The record could not be saved."
			End If
			
	
        Case "Wafer"
			If (sParam1 = "A") Then
				'PartID (Auto-Number)
				'PartNo
				'DocID
				sFields = "PartNo, DocID"
				sVals = "'" & Request.Form("PartNo") & "', '" & Request.QueryString("DocID") & "'"
				'MatlPn	-	[IPN]
				sFields = sFields & ", MatlPn"
				If (Request.Form("IPN") <> "") Then
					sVals = sVals & ", '" & Request.Form("IPN") & "'"
				Else
					sVals = sVals & ", '0'"
				End If
				'ProcPn	-	Unused
				'RefInfo	-	Unused
				'Par1	-	0
				'Par2	-	0
				'Par3	-	0
				'Par4	-	0
				sFields = sFields & ", Par1, Par2, Par3, Par4"
				sVals = sVals & ", '0', '0', '0', '0'"
				'Par5	-	[Thick]
				sFields = sFields & ", Par5"
				If (Request.Form("Thick") <> "") Then
					sVals = sVals & ", '" & Request.Form("Thick") & "'"
				Else
					sVals = sVals & ", '0'"
				End If
				'Par7	-	[Thick] + 0.013
				sFields = sFields & ", Par7"
				If (Request.Form("Thick") <> "") Then
					sVals = sVals & ", '" & CDbl(Request.Form("Thick")) + 0.013 & "'"
				Else
					sVals = sVals & ", '0.013'"
				End If
				'Par8	-	0
				'Par9	-	0
				sFields = sFields & ", Par8, Par9"
				sVals = sVals & ", '0', '0'"
				'Par10	-	[Diam]
				sFields = sFields & ", Par10"
	
				If (Request.Form("IPN") <> "") Then
				  'vTemp = IngotDiam(Request.Form("IPN"))
				End If
				If (vTemp <> "") Then
					sVals = sVals & ", '" & vTemp & "'"
				Else
					sVals = sVals & ", '0'"
				End If
				
   
				'Par11	-	[SForm]
				sFields = sFields & ", Par11"
				If (Request.Form("SForm") <> "") Then
					vTemp = Request.Form("SForm")
					sVals = sVals & ", '" & vTemp & "'"
				Else
					If (Request.Form("IPN") <> "") Then
						vTemp = SliceFormula(Request.Form("IPN"))
					Else
						vTemp = SliceFormula(Request.QueryString("DocID"))
					End If
					If (vTemp <> "") Then
						sVals = sVals & ", '" & vTemp & "'"
					Else
						sVals = sVals & ", '0'"
					End If
				End If
   
   
				'Par6	-	0.0005 (Determined by slice formula)
				sFields = sFields & ", Par6"
				Select Case vTemp
					Case "-.006", "-0.006"
						sVals = sVals & ", '0.003'"
					Case "/2 - .006", "/2 - 0.006", "/2-.006"
						sVals = sVals & ", '0.006'"
					Case Else
						sVals = sVals & ", '0.0005'"
				End Select
				
				sSQL = "INSERT INTO PartPar (" & sFields & ") VALUES (" & sVals & ")"
			Else
				'PartID (Auto-Number)
				'PartNo
				sVals = "(PartNo = '" & Request.QueryString("Item") & "')"
				If (Request.Form("PartNo") <> Request.QueryString("Item")) Then
					sFields = "PartNo = '" & Request.Form("PartNo") & "'"
				End If
				'MatlPn	-	[IPN]
				If (Request.Form("IPN") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "MatlPn = '" & Request.Form("IPN") & "'"
				End If
				'ProcPn	-	Unused
				'RefInfo	-	Unused
				'Par5	-	[Thick]
				If (Request.Form("Thick") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "Par5 = '" & Request.Form("Thick") & "'"
				End If
				'Par7	-	[Thick] + 0.013
				If (Request.Form("Thick") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "Par7 = '" & CDbl(Request.Form("Thick")) + 0.013 & "'"
				Else
					sFields = IIf(sFields <> "", sFields & ", ", "") & "Par7 = '0.013'"
				End If
				'Par10	-	[Diam]
				If (Request.Form("IPN") <> "") Then
					'vTemp = IngotDiam(Request.Form("IPN"))
					If (vTemp <> "") Then
						sFields = IIf(sFields <> "", sFields & ", ", "") & "Par10 = '" & vTemp & "'"
					Else
						sFields = IIf(sFields <> "", sFields & ", ", "") & "Par10 = '0'"
					End If
				End If
				'Par11	-	[SForm]
				If (Request.Form("SForm") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "Par11 = '" & Request.Form("SForm") & "'"
				End If
				'Par6	-	0.0005 (Determined by slice formula)
				Select Case Request.Form("SForm")
					Case "-.006", "-0.006"
						sFields = IIf(sFields <> "", sFields & ", ", "") & "Par6 = '0.003'"
					Case "/2 - .006", "/2 - 0.006", "/2-.006"
						sFields = IIf(sFields <> "", sFields & ", ", "") & "Par6 = '0.006'"
					Case Else
						sFields = IIf(sFields <> "", sFields & ", ", "") & "Par6 = '0.0005'"
				End Select
				
				If (sFields <> "") Then
					'DocID
					'Par1	-	0
					'Par2	-	0
					'Par3	-	0
					'Par4	-	0
					'Par8	-	0
					'Par9	-	0
					sFields = sFields & ", DocID = '" & Request.QueryString("DocID") & "', Par1 = '0', Par2 = '0', Par3 = '0', Par4 = '0', Par8 = '0', Par9 = '0'"
					sSQL = "UPDATE PartPar SET " & sFields & " WHERE " & sVals
				Else
					sSQL = ""
				End If
			End If
        Case "Change"
			If (sParam1 = "") Then sParam1 = "A"
			If (sParam1 = "E") Then
				vNewNum = sParam2
				sVals = "CO = " & vNewNum
				
				If (Request.Form("ChReqBy") <> "") And (Request.Form("ChReqBy") <> "SELECT") Then
					If IsNumeric(Request.Form("ChReqBy")) Then
						vTemp = GetDataValue("SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("ChReqBy") & ")", Nothing)
					Else
						vTemp = Request.Form("ChReqBy")
					End If
				Else
					vTemp = "ERMSWeb Request"
				End If
				'sFields = "ChReqBy = '" & vTemp & "', ChReqDate = #" & Date & "#, LastModBy = '" & vTemp & "', LastModDate = #" & Date & "#"
				sFields = "ChReqBy = '" & vTemp & "', LastModBy = '" & vTemp & "', LastModDate = #" & Date & "#"
				
				If (Request.Form("ChType") <> "") And (Request.Form("ChType") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeType = '" & Request.Form("ChType") & "'"
				End If
				
				If (Request.Form("ChClass") <> "") And (Request.Form("ChClass") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeClass = '" & Request.Form("ChClass") & "'"
				End If
			
				If (Request.Form("ChProj") <> "") And (Request.Form("ChProj") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ProjNum = '" & Request.Form("ChProj") & "'"
				End If
			
				If (Request.Form("ChPrior") <> "") And (Request.Form("ChPrior") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChPriority = '" & Request.Form("ChPrior") & "'"
				End If
			
				If (Request.Form("ChJust") <> "") And (Request.Form("ChJust") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChJustification = '" & Request.Form("ChJust") & "'"
				End If
			
				If (Request.Form("ChEff") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChEffDate = #" & Request.Form("ChEff") & "#"
				Else
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChEffDate = #" & Date & "#"
				End If
			
				If (Request.Form("ChDue") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChDue = #" & Request.Form("ChDue") & "#"
				End If
			
				If (Request.Form("ChDesc") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeDesc = '" & CheckString(Request.Form("ChDesc")) & "'"
				End If
			
				sSQL = "UPDATE Changes SET " & sFields & " WHERE (RefType = 'CO') AND (CO = " & vNewNum & ")"
				
				'Set UDF record
				If (Request.Form("Acct") <> "") Then
					bRet = RunSQLCmd(sSQL, Nothing)
					vTemp = GetDataValue("SELECT RefID AS RetVal FROM CustomUDF WHERE (RefType = 'CO') AND (RefID = '" & vNewNum & "')", Nothing)
					If (vTemp <> "") Then
						sSQL = "UPDATE CustomUDF SET UDF1 = '" & Request.Form("Acct") & "' WHERE (RefType = 'CO') AND (RefID = '" & vNewNum & "')"
					Else
						sSQL = "INSERT INTO CustomUDF (RefType, RefID, UDF1) VALUES ('CO', '" & vNewNum & "', '" & Request.Form("Acct") & "')"
					End If
				End If
			Else
				vNewNum = GetNewID("CO")
				sFields = "CO, ChStatus, RefType"
				sVals = vNewNum & ", 'CREQ', 'CO'"
			
				If (Request.Form("ChReqBy") <> "") And (Request.Form("ChReqBy") <> "SELECT") Then
					If IsNumeric(Request.Form("ChReqBy")) Then
						vTemp = GetDataValue("SELECT ULNF AS RetVal FROM UserXRef WHERE (EmpID = " & Request.Form("ChReqBy") & ")", Nothing)
					Else
						vTemp = Request.Form("ChReqBy")
					End If
				Else
					vTemp = "ERMSWeb Request"
				End If
				sFields = IIf(sFields <> "", sFields & ", ", "") & "ChReqBy, ChReqDate, LastModBy, LastModDate"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "', #" & Date & "#, '" & vTemp & "', #" & Date & "#"
			
				If (Request.Form("ChType") <> "") And (Request.Form("ChType") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeType"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & Request.Form("ChType") & "'"
				End If
			
				If (Request.Form("ChClass") <> "") And (Request.Form("ChClass") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeClass"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & Request.Form("ChClass") & "'"
				End If
			
				If (Request.Form("ChProj") <> "") And (Request.Form("ChProj") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ProjNum"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & Request.Form("ChProj") & "'"
				End If
			
				If (Request.Form("ChPrior") <> "") And (Request.Form("ChPrior") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChPriority"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & Request.Form("ChPrior") & "'"
				End If
			
				If (Request.Form("ChJust") <> "") And (Request.Form("ChJust") <> "SELECT") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChJustification"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & Request.Form("ChJust") & "'"
				End If
			
				If (Request.Form("ChEff") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChEffDate"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "#" & Request.Form("ChEff") & "#"
				Else
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChEffDate"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "#" & Date & "#"
				End If
			
				If (Request.Form("ChDue") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChDue"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "#" & Request.Form("ChDue") & "#"
				End If
			
				If (Request.Form("ChDesc") <> "") Then
					sFields = IIf(sFields <> "", sFields & ", ", "") & "ChangeDesc"
					sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("ChDesc")) & "'"
				End If
			
				sSQL = "INSERT INTO Changes (" & sFields & ") VALUES (" & sVals & ")"
				'Response.Write "<p>" & sSQL & "</p>"
			
				'Set UDF record
				If (Request.Form("Acct") <> "") Then
					bRet = RunSQLCmd(sSQL, Nothing)
					sSQL = "INSERT INTO CustomUDF (RefType, RefID, UDF1) VALUES ('CO', '" & vNewNum & "', '" & Request.Form("Acct") & "')"
				End If
			End If
		Case "AssDoc"
			If (Request.Form("ADNum") <> "") Then
				'Verify appropriate status
				vTemp = GetDataValue("SELECT DocStatus AS RetVal FROM Documents WHERE (DocID = '" & Request.Form("ADNum") & "')", Nothing)
				Select Case vTemp
					Case "ARC", "REL"
						'Create [Revisions] record
						'DocID, CO
						sFields = "DocID, CO"
						sVals = "'" & Request.Form("ADNum") & "', " & Request.Form("CR")
						'RevFrom
						vTemp = GetDataValue("SELECT CurrentRev AS RetVal FROM Documents WHERE (DocID = '" & Request.Form("ADNum") & "')", Nothing)
						If (vTemp <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "RevFrom"
							sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
						End If
						'RevTo
						If (Request.Form("ADRev") <> "") Then
							sFields = IIf(sFields <> "", sFields & ", ", "") & "RevTo"
							sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & Request.Form("ADRev") & "'"
						End If
						
						sSQL = "INSERT INTO Revisions (" & sFields & ") VALUES (" & sVals & ")"
						bRet = RunSQLCmd(sSQL, Nothing)
						
						'Update [Documents] record
						'DocStatus
						sFields = "DocStatus = 'CREQ'"
						'DocID
						sVals = "DocID = '" & Request.Form("ADNum") & "'"
			
						sSQL = "UPDATE Documents SET " & sFields & " WHERE (" & sVals & ")"
					Case Else
						sSQL = ""
						sRetText =  "<p><font face='Verdana' size='2'>A current Change Request is pending for Document Number [<strong>" & Request.Form("ADNum") & "</strong>].</font></p>"
				End Select
			Else
				sSQL = ""
				sRetText =  "<p><font face='Verdana' size='2'>No Document Number was specified.</font></p>"
			End If
		Case "Note"
			'NoteID (Auto-Number)
			'RefType
			'RefID
			'NoteDT
			sFields = "RefType, RefID, NoteDT"
			sVals = "'" & sParam1 & "', " & Request.Form("CR") & ", #" & Now() & "#"
			'UID
			If (sParam2 <> "") Then
				vTemp = GetDataValue("SELECT UID AS RetVal FROM UserXRef WHERE (EmpID = " & sParam2 & ")", Nothing)
				If (vTemp = "") Then vTemp = "ERMSWeb User"
				sFields = IIf(sFields <> "", sFields & ", ", "") & "UID"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & vTemp & "'"
			End If
			'NoteType
			If (Request.Form("NType") <> "") And (Request.Form("NType") <> "SELECT") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "NoteType"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & Request.Form("NType") & "'"
			End If
			'NoteSubj
			If (Request.Form("NSubj") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "NoteSubj"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("NSubj")) & "'"
			End If
			'NoteTxt
			If (Request.Form("NText") <> "") Then
				sFields = IIf(sFields <> "", sFields & ", ", "") & "NoteTxt"
				sVals = IIf(sVals <> "", sVals & ", ", "") & "'" & CheckString(Request.Form("NText")) & "'"
			End If
			
			sSQL = "INSERT INTO Notes (" & sFields & ") VALUES (" & sVals & ")"
	End Select
			
    If (sSQL <> "") Then
		bRet = RunSQLCmd(sSQL, Nothing)
		'bRet = True
    Else
		bRet = False
    End If


		    
    If (bRet = False) Then
		If (vRec <> "AssDoc") And (sRetText = "")  Then
			sRetText = "<p><font face='Verdana' size='2'>An unexpected error occurred.</font></p>"
			'sRetText = sRetText & "<p><font face='Verdana' size='2'>sSQL = " & sSQL & "</font></p>"
		End If
    Else
        'sRetText = "<p><font face='Verdana' size='2'>The record has been successfully added to the database.</font></p>"
        sRetText = ""
    End If
    
    WriteRec = sRetText
    
End Function

Function GetNewID(sID)
    Dim vRet
    
    vRet = 0
    
    Select Case sID
        Case "CO"
            vRet = GetDataValue("SELECT MAX(CO) AS RetVal FROM ViewChanges", Nothing)
        Case ""
            'vRet = GetDataValue("SELECT MAX(TaskID) AS RetVal FROM Tasks", Nothing)
            vRet = ""
    End Select
    
    If (vRet = "") Then
        vRet = 1
    Else
		vRet = CLng(vRet) + 1
    End If
    
    GetNewID = vRet
End Function

Function GetProcInfo(sRef, vCurID, sParam1)
	Dim sRetInfo
	Dim sTemp
	Dim rsInfo
	Dim sSQL
	Dim sLink
	
	Select Case sRef
		Case "Change"
			If (vCurID <> "") Then
				sSQL = "SELECT CO, ChClass, ChType, ChReqBy, ChEffDate, ChDue, Priority, Justification, Project, ChangeDesc FROM ViewChanges WHERE (CO = " & vCurID & ")"
				Set rsInfo = GetADORecordset(sSQL, Nothing)
				If Not ((rsInfo.BOF = True) And (rsInfo.EOF = True)) Then
					sRetInfo = "    <table border='0' cellpadding='2' width='100%'>"
					sRetInfo = sRetInfo & vbCrLf & "      <tr>"
					sRetInfo = sRetInfo & vbCrLf & "        <td colspan='4' bgcolor='#808000'><font face='Verdana' color='#FFFFFF'><strong>Change Request Information</strong></font></td>"
					sRetInfo = sRetInfo & vbCrLf & "      </tr>"
					sRetInfo = sRetInfo & vbCrLf & "      <tr>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Change Number:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & vCurID & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Requested By:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("ChReqBy")), "", rsInfo("ChReqBy")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "      </tr>"
					sRetInfo = sRetInfo & vbCrLf & "      <tr>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Eff / Start Date:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("ChEffDate")), "", rsInfo("ChEffDate")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Change Class:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("ChClass")), "", rsInfo("ChClass")) & "</font><td>"
					sRetInfo = sRetInfo & vbCrLf & "      </tr>"
					sRetInfo = sRetInfo & vbCrLf & "      <tr>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Due / End Date:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("ChDue")), "", rsInfo("ChDue")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Change Type:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("ChType")), "", rsInfo("ChType")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "      </tr>"
					sRetInfo = sRetInfo & vbCrLf & "      <tr>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Priority:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("Priority")), "", rsInfo("Priority")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Justification:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("Justification")), "", rsInfo("Justification")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "      </tr>"
					sRetInfo = sRetInfo & vbCrLf & "      <tr>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Project:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top' colspan='3'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("Project")), "", rsInfo("Project")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "      </tr>"
					sRetInfo = sRetInfo & vbCrLf & "      <tr>"
					sRetInfo = sRetInfo & vbCrLf & "        <td align='right' valign='top' bgcolor='#C0C0C0'><strong><font face='Verdana' size='2'>Description:</font></strong></td>"
					sRetInfo = sRetInfo & vbCrLf & "        <td valign='top' colspan='3'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("ChangeDesc")), "", rsInfo("ChangeDesc")) & "</font></td>"
					sRetInfo = sRetInfo & vbCrLf & "      </tr>"
					sRetInfo = sRetInfo & vbCrLf & "    </table>"
				Else
					sRetInfo = ""
				End If
			Else
				sRetInfo = ""
			End If
		Case "Att1"
			If (vCurID <> "") And (sParam1 <> "") Then
				sSQL = "SELECT AttFName, AttFDesc, AttFLoc, AttFLink, WebView FROM ViewAttach WHERE (RefType = '" & sParam1 & "') AND (RefID = '" & vCurID & "')"
				Set rsInfo = GetADORecordset(sSQL, Nothing)
				If Not ((rsInfo.BOF = True) And (rsInfo.EOF = True)) Then
					rsInfo.MoveFirst
					Do
						sLink = ""
						If (rsInfo("WebView") = True) Then
							If Not IsNull(rsInfo("AttFLink")) Then
								sLink = "<a href=" & Chr(34) & "javascript:iPop('" & rsInfo("AttFLink") & "', '2')" & Chr(34) & " onMouseOver=" & Chr(34) & "window.status = 'View File'; return true;" & Chr(34) & ">"
							Else
								If Not IsNull(rsInfo("AttFLoc")) Then
									sLink = Replace(rsInfo("AttFLoc"), "\", "/", 1, -1, vbTextCompare)
									sLink = "http:" & IIf(Left(sLink, 2) <> "//", "//", "") & sLink
									sLink = "<a href=" & Chr(34) & "javascript:iPop('" & sLink & "', '2')" & Chr(34) & " onMouseOver=" & Chr(34) & "window.status = 'View File'; return true;" & Chr(34) & ">"
								End If
							End If
						End If
						sRetInfo = sRetInfo & vbCrLf & "        <tr>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & sLink & IIf(IsNull(rsInfo("AttFName")), "UNKNOWN", rsInfo("AttFName")) & IIf(sLink <> "", "</a>", "") & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("AttFDesc")), "", rsInfo("AttFDesc")) & "</font></td>"
						'sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><strong><font face='Verdana' size='2'>Delete</font></strong></td>"
						sRetInfo = sRetInfo & vbCrLf & "        </tr>"
						rsInfo.MoveNext
					Loop Until rsInfo.EOF
				Else
					sRetInfo = ""
				End If
			Else
				sRetInfo = ""
			End If
		Case "Att2"
			If (vCurID <> "") And (sParam1 <> "") Then
				sSQL = "SELECT AttFName, AttFDesc FROM ViewAttach WHERE (RefType = '" & sParam1 & "') AND (RefID = '" & vCurID & "')"
				Set rsInfo = GetADORecordset(sSQL, Nothing)
				If Not ((rsInfo.BOF = True) And (rsInfo.EOF = True)) Then
					rsInfo.MoveFirst
					Do
						sRetInfo = sRetInfo & vbCrLf & "        <tr>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("AttFName")), "UNKNOWN", rsInfo("AttFName")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("AttFDesc")), "", rsInfo("AttFDesc")) & "</font></td>"
						'sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><strong><font face='Verdana' size='2'>Delete</font></strong></td>"
						sRetInfo = sRetInfo & vbCrLf & "        </tr>"
						rsInfo.MoveNext
					Loop Until rsInfo.EOF
				Else
					sRetInfo = ""
				End If
			Else
				sRetInfo = ""
			End If
		Case "Note"
			If (vCurID <> "") And (sParam1 <> "") Then
				sSQL = "SELECT NoteDT, ULNF, NType, NoteSubj FROM ViewNotes WHERE (RefType = '" & sParam1 & "') AND (RefID = '" & vCurID & "')"
				Set rsInfo = GetADORecordset(sSQL, Nothing)
				If Not ((rsInfo.BOF = True) And (rsInfo.EOF = True)) Then
					rsInfo.MoveFirst
					Do
						sRetInfo = sRetInfo & vbCrLf & "        <tr>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("NoteDT")), "", rsInfo("NoteDT")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("ULNF")), "", rsInfo("ULNF")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("NType")), "", rsInfo("NType")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("NoteSubj")), "", rsInfo("NoteSubj")) & "</font></td>"
						'sRetInfo = sRetInfo & vbCrLf & "          <td valign='top'><strong><font face='Verdana' size='2'>Delete</font></strong></td>"
						sRetInfo = sRetInfo & vbCrLf & "        </tr>"
						rsInfo.MoveNext
					Loop Until rsInfo.EOF
				Else
					sRetInfo = ""
				End If
			Else
				sRetInfo = ""
			End If
		Case "AssDoc1"
			If (vCurID <> "") Then
				sSQL = "SELECT DocID, CurrentRev, RevTo, Status FROM ViewAssocDocs WHERE (CO = " & vCurID & ")"
				Set rsInfo = GetADORecordset(sSQL, Nothing)
				If Not ((rsInfo.BOF = True) And (rsInfo.EOF = True)) Then
					rsInfo.MoveFirst
					Do
						sLink = IIf(IsNull(rsInfo("DocID")), "", "<a href='pnt_selitem.asp?Listing=Doc&Item=" & rsInfo("DocID") & "&Opt=False' target='_blank'>")
						sRetInfo = sRetInfo & vbCrLf & "        <tr>"
						sRetInfo = sRetInfo & vbCrLf & "          <td><font face='Verdana' size='2'>" & sLink & IIf(IsNull(rsInfo("DocID")), "", rsInfo("DocID")) & IIf(sLink <> "", "</a>", "") & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td align='center'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("CurrentRev")), "", rsInfo("CurrentRev")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td align='center'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("RevTo")), "", rsInfo("RevTo")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("Status")), "", rsInfo("Status")) & "</font></td>"
						'sRetInfo = sRetInfo & vbCrLf & "          <td><strong><font face='Verdana' size='2'>Delete</font></strong></td>"
						sRetInfo = sRetInfo & vbCrLf & "        </tr>"
						rsInfo.MoveNext
					Loop Until rsInfo.EOF
				Else
					sRetInfo = ""
				End If
			Else
				sRetInfo = ""
			End If
		Case "AssDoc2"
			If (vCurID <> "") Then
				sSQL = "SELECT DocID, CurrentRev, RevTo, Status FROM ViewAssocDocs WHERE (CO = " & vCurID & ")"
				Set rsInfo = GetADORecordset(sSQL, Nothing)
				If Not ((rsInfo.BOF = True) And (rsInfo.EOF = True)) Then
					rsInfo.MoveFirst
					Do
						sRetInfo = sRetInfo & vbCrLf & "        <tr>"
						sRetInfo = sRetInfo & vbCrLf & "          <td><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("DocID")), "", rsInfo("DocID")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td align='center'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("CurrentRev")), "", rsInfo("CurrentRev")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td align='center'><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("RevTo")), "", rsInfo("RevTo")) & "</font></td>"
						sRetInfo = sRetInfo & vbCrLf & "          <td><font face='Verdana' size='2'>" & IIf(IsNull(rsInfo("Status")), "", rsInfo("Status")) & "</font></td>"
						'sRetInfo = sRetInfo & vbCrLf & "          <td><strong><font face='Verdana' size='2'>Delete</font></strong></td>"
						sRetInfo = sRetInfo & vbCrLf & "        </tr>"
						rsInfo.MoveNext
					Loop Until rsInfo.EOF
				Else
					sRetInfo = ""
				End If
			Else
				sRetInfo = ""
			End If
	End Select
	
	GetProcInfo = sRetInfo
End Function

Sub DelProcRec(sRef, vID, RetPage, RefID)
	
	Select Case sRef
	
	End Select
	
End Sub

Function GetAlertInfo(sRec, vID)
	Dim sAlertTxt
	Dim sSQL
	Dim rsAlert
	
	Select Case sRec
		Case "AssDoc"
			sSQL = "SELECT DocID, DocStatus, Status, CurrentRev, DocDesc FROM ViewDocs WHERE (DocID = '" & vID & "')"
			Set rsAlert = GetADORecordset(sSQL, Nothing)
			If Not ((rsAlert.BOF = True) And (rsAlert.EOF = True)) Then
				Select Case rsAlert("DocStatus")
					Case "REQ", "CREQ", "PND", "WIP": sAlertTxt = "2"
					Case "OBS": sAlertTxt = "3"
					Case Else
						sAlertTxt = "        <tr>" & vbCrLf
						sAlertTxt = sAlertTxt & "          <td align='right'><font face='Verdana' size='2'><strong>Current Status:</strong></font></td>" & vbCrLf
						sAlertTxt = sAlertTxt & "          <td><font face='Verdana' size='2'>" & IIf(IsNull(rsAlert("Status")), "NONE", rsAlert("Status")) & "</font></td>" & vbCrLf
						sAlertTxt = sAlertTxt & "        </tr>" & vbCrLf
						sAlertTxt = sAlertTxt & "        <tr>" & vbCrLf
						sAlertTxt = sAlertTxt & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>Description:</strong></font></td>" & vbCrLf
						sAlertTxt = sAlertTxt & "          <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsAlert("DocDesc")), "NONE", rsAlert("DocDesc")) & "</font></td>" & vbCrLf
						sAlertTxt = sAlertTxt & "        </tr>" & vbCrLf
						sAlertTxt = sAlertTxt & "        <tr>" & vbCrLf
						sAlertTxt = sAlertTxt & "          <td align='right'><font face='Verdana' size='2'><strong>Current Revision:</strong></font></td>" & vbCrLf
						sAlertTxt = sAlertTxt & "          <td><font face='Verdana' size='2'>" & IIf(IsNull(rsAlert("CurrentRev")), "NONE", rsAlert("CurrentRev")) & "</font></td>" & vbCrLf
						sAlertTxt = sAlertTxt & "        </tr>" & vbCrLf
				End Select
			Else
				sAlertTxt = "1"
			End If
			rsAlert.Close
	End Select
	
	Set rsAlert = Nothing
	GetAlertInfo = sAlertTxt
End Function

%>
