<%

Function NextPartNumber(sDocID)
	Dim vVal
	
	vVal = GetDataValue("SELECT MAX(PartNo) AS RetVal FROM PartPar WHERE DocID='" & sDocID & "'", Nothing)
	If (vVal <> "") Then
		MaxPartNo = Mid(vVal, InStrRev(vVal, "-") + 1)
		PartEnding = Mid(MaxPartNo, 4) ' e.g.: S
		MaxPartNo = Left(MaxPartNo, 3) ' get just the num
		PartNo = CInt(MaxPartNo) + 1
		PartNoSize = 3 - Len(Int(PartNo))
		NextPartNumber = string(PartNoSize, "0") & PartNo & PartEnding
	Else
		NextPartNumber = "001"
	End If
End Function

Function IngotNumber(sDocID)
	Dim vVal
	
	vVal = GetDataValue("SELECT TOP 1 MatlPn AS RetVal FROM PartPar WHERE Par1 = '0' AND DocID='" & sDocID & "'", Nothing)
	If (vVal <> "") Then
		IngotNumber = vVal
	Else
		IngotNumber = ""
	End If
End Function

Function WaferDiameter(sDocID)
	Dim vVal
	
	vVal = GetDataValue("SELECT TOP 1 Par10 AS RetVal FROM PartPar WHERE Par1 = '0' AND DocID='" & sDocID & "'", Nothing)
	If (vVal <> "") Then
		WaferDiameter = vVal
	Else
		WaferDiameter = ""
	End If
End Function

Function SliceFormula(sDocID)
	Dim vVal
	
	vVal = GetDataValue("SELECT TOP 1 Par11 AS RetVal FROM PartPar WHERE Par1 = '0' AND DocID='" & sDocID & "'", Nothing)
	If (vVal <> "") Then
		SliceFormula = vVal
	Else
		SliceFormula = ""
	End If
End Function

Function ElementQty(Thickness, WaferDiameter, WidthA)
	Dim vVal
	
	If (Thickness >= 0.070) Then
		If (WaferDiameter = 1.25) Then
			WaferType = "1"
		ElseIf (WaferDiameter = 1.06) Then
			WaferType = "4"
		ElseIf (WaferDiameter = .66) Then
			WaferType = "7"		
		End If
	ElseIf (Thickness > 0.050) Then ' Implied, but less than 0.070
		If (WaferDiameter = 1.25) Then
			WaferType = "2"		
		ElseIf (WaferDiameter = 1.06) Then
			WaferType = "5"		
		ElseIf (WaferDiameter = .66) Then
			WaferType = "9"	' column 8 now ignored
		End If	
	Else ' Less than or equal to 0.050
		If (WaferDiameter = 1.25) Then
			WaferType = "3"		
		ElseIf (WaferDiameter = 1.06) Then
			WaferType = "6"		
		ElseIf (WaferDiameter = .66) Then
			WaferType = "9"		
		End If	
	End If
	If (WaferType <> "") Then
		vVal = GetDataValue("SELECT WaferType" & WaferType & " AS RetVal FROM ElementQtyCalc WHERE ElementDimA = " & WidthA, Nothing)
		ElementQty = vVal
	Else
		ElementQty = "ERR"
	End If
End Function

Function WaferDocID(sElementDocID)
	Dim rsElement
	
	Set rsElement = GetADORecordset("SELECT TOP 1 * FROM ViewDocsPartPar WHERE DocID = '" & sElementDocID & "'", Nothing)
	If (rsElement.EOF = True And rsElement.BOF = True) Then
		WaferDocID = "0"
		Exit Function
	End If
	WaferPartNo = rsElement("MatlPn")
	WaferDocID = Mid(rsElement("MatlPn"), 1, InStrRev(rsElement("MatlPn"), "-") - 1)
	
	rsElement.Close
	Set rsElement = Nothing
End Function

Function NewWafer(sDocID, Thickness) ' Create new wafer for doc who has wafers referenced by elements of sDocID
	Dim rsExistWafer
	
	sWaferDocID = WaferDocID(sDocID)
'	Response.Write("SELECT * FROM PartPar WHERE Par1 = '0' AND DocID='" & sWaferDocID & "'")
'	Response.End()
	Set rsExistWafer = GetADORecordset("SELECT * FROM PartPar WHERE Par1 = '0' AND DocID='" & sWaferDocID & "'", Nothing)
	
	PartNo = sWaferDocID & "-" & NextPartNumber(sWaferDocID)
	sVals = "'" & sWaferDocID & "', "
	sVals = sVals & "'" & PartNo & "', "
	sVals = sVals & "'" & rsExistWafer("MatlPn") & "', "
	sVals = sVals & "'" & Thickness & "', "
	sVals = sVals & "'" & ".0005" & "', "
	sVals = sVals & "'" & CStr(Thickness + 0.013) & "', "
	sVals = sVals & "'" & rsExistWafer("Par10") & "', "
	sVals = sVals & "'" & rsExistWafer("Par11") & "'"
	sParSQL = "INSERT INTO PartPar (DocID, PartNo, MatlPn, Par5, Par6, Par7, Par10, Par11) VALUES (" & sVals & ")"
	sPartSQL = "INSERT INTO PartsXRef (DocID, PartNo, PartID, PartDesc) SELECT DocID, PartNo, PartID, ""Thickness: "" & Par5 & ""+/-"" & Par6 & "". Quantity: "" & Par7 & "". Dia: "" & Par10 & "". Slice Formula: "" & Par11 & ""."" FROM PartPar WHERE PartNo = '" & PartNo & "'"
	Saved = RunSQLCmd(sParSQL, Nothing) And RunSQLCmd(sPartSQL, Nothing)	

	rsExistWafer.Close
	Set rsExistWafer = Nothing
	NewWafer = PartNo
End Function

%>

