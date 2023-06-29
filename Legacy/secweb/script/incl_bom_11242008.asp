<%
Function WriteBOMHdr(bNew)
	Dim sFields
	Dim sVals
	Dim sCMD
	Dim vTest
	Dim nRet
	Dim sTemp
	
	If (bNew =True) Then
		sFields = "ItemNum"
		sVals = "'" & Request.Form("BOMItem") & "'"
		If (Request.Form("BItemRev") <> "") Then
			sFields = sFields & ", ItemRev"
			sVals = sVals & ", '" & Request.Form("BItemRev") & "'"
		End If
		If (Request.Form("BOMDesc") <> "") Then
			sFields = sFields & ", BDesc"
			sVals = sVals & ", '" & CheckString(Request.Form("BOMDesc")) & "'"
		End If
		If (Request.Form("BOMType") <> "") Then
			sFields = sFields & ", BType"
			sVals = sVals & ", '" & Request.Form("BOMType") & "'"
		End If
		If (Request.Form("BItemStatus") <> "") Then
			sFields = sFields & ", ItemStatus"
			sVals = sVals & ", '" & Request.Form("BItemStatus") & "'"
		End If
		If (Request.Form("BItemEff") <> "") Then
			sFields = sFields & ", EffDate"
			sVals = sVals & ", #" & Request.Form("BItemEff") & "#"
		End If
		If (Request.Form("BItemDesc") <> "") Then
			sFields = sFields & ", BItemDesc"
			sVals = sVals & ", '" & CheckString(Request.Form("BItemDesc")) & "'"
		End If
		
		sCMD = "INSERT INTO BOMHdr (" & sFields & ") VALUES (" & sVals & ")"
	Else
		If (Request.Form("BItemID") <> "") Then
			sVals = "(BItemID = " & Request.Form("BItemID") & ")"
		Else
			sVals = "(BItemID = " & Request.QueryString("ITEM") & ")"
		End If
		
		sFields = "ItemNum = '" & Request.Form("BOMItem") & "'"
		If (Request.Form("BItemRev") <> "") Then sFields = sFields & ", ItemRev = '" & Request.Form("BItemRev") & "'"
		If (Request.Form("BOMDesc") <> "") Then sFields = sFields & ", BDesc = '" & CheckString(Request.Form("BOMDesc")) & "'"
		If (Request.Form("BOMType") <> "") Then sFields = sFields & ", BType = '" & Request.Form("BOMType") & "'"
		If (Request.Form("BItemStatus") <> "") Then sFields = sFields & ", ItemStatus = '" & Request.Form("BItemStatus") & "'"
		If (Request.Form("BItemEff") <> "") Then sFields = sFields & ", EffDate = #" & Request.Form("BItemEff") & "#"
		If (Request.Form("BItemDesc") <> "") Then sFields = sFields & ", BItemDesc = '" & CheckString(Request.Form("BItemDesc")) & "'"
		
		sCMD = "UPDATE BOMHdr SET " & sFields & " WHERE " & sVals
		If (Request.Form("BItemID") <> "") Then
			nRet = Request.Form("BItemID")
		Else
			nRet = Request.QueryString("ITEM")
		End If
	End If
	
	vTest = RunSQLCmd(sCMD, Nothing)
	If (bNew =True) Then
		nRet = GetDataValue("SELECT MAX(BItemID) AS RetVal FROM BOMHdr", Nothing)
	End If
	
	WriteBOMHdr = nRet
End Function

Function WriteBOMItem(bNew)
	Dim sFields
	Dim sVals
	Dim sCMD
	Dim vTest
	Dim nRet
	Dim sTemp
	
	If (bNew =True) Then
		sFields = "CItemNum, BItemID"
		sVals = "'" & Request.Form("ItemNo") & "', " & Request.Form("BItemID")
		If (Request.Form("SeqNo") <> "") Then
			sFields = sFields & ", SeqNum"
			sVals = sVals & ", " & Request.Form("SeqNo")
		End If
		If (Request.Form("ItemRev") <> "") Then
			sFields = sFields & ", CItemRev"
			sVals = sVals & ", '" & Request.Form("ItemRev") & "'"
		End If
		If (Request.Form("ItemQty") <> "") Then
			sFields = sFields & ", CItemQty"
			sVals = sVals & ", " & Request.Form("ItemQty")
		End If
		If (Request.Form("ItemUOM") <> "") Then
			sFields = sFields & ", CItemUOM"
			sVals = sVals & ", '" & Request.Form("ItemUOM") & "'"
		End If
		If (Request.Form("EffDate") <> "") Then
			sFields = sFields & ", CItemEff"
			sVals = sVals & ", #" & Request.Form("EffDate") & "#"
		End If
		If (Request.Form("ItemDesc") <> "") Then
			sFields = sFields & ", CItemDesc"
			sVals = sVals & ", '" & CheckString(Request.Form("ItemDesc")) & "'"
		End If
		If (Request.Form("RefDes") <> "") Then
			sFields = sFields & ", RefDes"
			sVals = sVals & ", '" & CheckString(Request.Form("RefDes")) & "'"
		End If
		
		'Compute line cost for insert
		sTemp = GetItemCost(Request.Form("ItemNo"), Request.Form("ItemUOM"), Request.Form("ItemQty"))
		If (sTemp <> "") Then
			sFields = sFields & ", CItemCost"
			sVals = sVals & ", " & sTemp
		End If
		
		sCMD = "INSERT INTO BOMItems (" & sFields & ") VALUES (" & sVals & ")"
		nRet = Request.Form("BItemID")
	Else
		If (Request.Form("CItem") <> "") Then
			sVals = "(CItemID = " & Request.Form("CItem") & ")"
		Else
			sVals = "(CItemID = " & Request.QueryString("CITEM") & ")"
		End If
		
		sFields = "CItemNum = '" & Request.Form("ItemNo") & "'"
		If (Request.Form("SeqNo") <> "") Then sFields = sFields & ", SeqNum = " & Request.Form("SeqNo")
		If (Request.Form("ItemRev") <> "") Then sFields = sFields & ", CItemRev = '" & Request.Form("ItemRev") & "'"
		If (Request.Form("ItemQty") <> "") Then sFields = sFields & ", CItemQty = " & Request.Form("ItemQty")
		If (Request.Form("ItemUOM") <> "") Then sFields = sFields & ", CItemUOM = '" & Request.Form("ItemUOM") & "'"
		If (Request.Form("EffDate") <> "") Then sFields = sFields & ", CItemEff = #" & Request.Form("EffDate") & "#"
		If (Request.Form("RefDes") <> "") Then sFields = sFields & ", RefDes = '" & CheckString(Request.Form("RefDes")) & "'"
		
		'Compute line cost for insert
		sTemp = GetItemCost(Request.Form("ItemNo"), Request.Form("ItemUOM"), Request.Form("ItemQty"))
		If (sTemp <> "") Then
			sFields = sFields & ", CItemCost = " & sTemp
		End If
		
		sCMD = "UPDATE BOMItems SET " & sFields & " WHERE " & sVals
		nRet = Request.QueryString("ITEM")
	End If
	
	vTest = RunSQLCmd(sCMD, Nothing)
	WriteBOMItem = nRet
End Function

Function GetItemCost(sItem, sUOM, nQty)
	Dim nCost
	Dim oRS
	Dim sCMD
	Dim nTemp
	Dim nPos
	
	sCMD = "SELECT ItemUOM, ItemStdQty, ItemSQCost FROM BItemOpts WHERE (ItemNum = '" & sItem & "')"
	Set oRS = GetADORecordset(sCMD, Nothing)
	
	If (sUOM = oRS("ItemUOM")) And (nQty = oRS("ItemStdQty")) Then
		nCost = oRS("ItemSQCost")
	Else
		If (oRS("ItemStdQty") > 1) Then nTemp = oRS("ItemSQCost") / oRS("ItemStdQty") Else nTemp = oRS("ItemSQCost")
		nCost = nTemp * nQty
		nPos = InStr(1, nCost, ".", 1)
		If (Len(nCost) > (nPos + 2)) Then nCost = Left(nCost, nPos + 2): nCost = nCost
	End If
	
	oRS.Close
	Set oRS = Nothing
	
	GetItemCost = nCost
End Function

Sub DeleteItem(nItemID)
	Dim sCMD
	
	If (nItemID <> "") Then
		sCMD = "DELETE * FROM BOMItems WHERE (CItemID = " & nItemID & ")"
		RunSQLCmd sCMD, Nothing
	End If
End Sub

Sub TransferItems(nFrom, nTo)
	Dim oRS
	Dim sCMD
	Dim sFields
	Dim sVals
	
	If (nFrom <> "") And (nTo <> "") Then
		sCMD = "SELECT CItemNum, CItemRev, SeqNum, CItemQty, CItemUOM, CItemEff, RefDes, CItemCost, CItemDesc FROM BOMItems WHERE (BItemID = " & nFrom & ")"
		Set oRS = GetADORecordset(sCMD, Nothing)
		
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			Do
				sCMD = ""
				If Not IsNull(oRS("CItemNum")) Then
					sFields = "CItemNum, BItemID"
					sVals = "'" & oRS("CItemNum") & "', " & nTo
					If Not IsNull(oRS("CItemRev")) Then sFields = sFields & ", CItemRev": sVals = sVals & ", '" & oRS("CItemRev") & "'"
					If Not IsNull(oRS("SeqNum")) Then sFields = sFields & ", SeqNum": sVals = sVals & ", " & oRS("SeqNum")
					If Not IsNull(oRS("CItemQty")) Then sFields = sFields & ", CItemQty": sVals = sVals & ", " & oRS("CItemQty")
					If Not IsNull(oRS("CItemUOM")) Then sFields = sFields & ", CItemUOM": sVals = sVals & ", '" & oRS("CItemUOM") & "'"
					If Not IsNull(oRS("CItemEff")) Then sFields = sFields & ", CItemEff": sVals = sVals & ", #" & oRS("CItemEff") & "#"
					If Not IsNull(oRS("RefDes")) Then sFields = sFields & ", RefDes": sVals = sVals & ", '" & oRS("RefDes") & "'"
					If Not IsNull(oRS("CItemCost")) Then sFields = sFields & ", CItemCost": sVals = sVals & ", " & oRS("CItemCost")
					If Not IsNull(oRS("CItemDesc")) Then sFields = sFields & ", CItemDesc": sVals = sVals & ", '" & oRS("CItemDesc") & "'"
					sCMD = "INSERT INTO BOMItems (" & sFields & ") VALUES (" & sVals & ")"
					RunSQLCmd sCMD, Nothing
				End If
				oRS.MoveNext
			Loop Until oRS.EOF
		End If
		oRS.Close
		Set oRS = Nothing
	End If
End Sub

Function GetEBRpt(nItemID, sRptFmt)
	Dim sRptText
	Dim oRS
	Dim sCMD
	Dim sHeader
	Dim sItemList
	Dim nTotalCost
	
	'Format header information
	sCMD = "SELECT ItemNum, ItemRev, BType, ItemStatus, BDesc, EffDate, BItemDesc FROM BOMHdr "
	sCMD = sCMD & "WHERE (BItemID = " & nItemID & ")"
	Set oRS = GetADORecordset(sCMD, Nothing)

	If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
		oRS.MoveFirst
		sHeader = "    <table border='0' cellpadding='2' cellspacing='0' width='660'>"
		sHeader = sHeader & vbCrLf & "      <tr>"
		sHeader = sHeader & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>BOM Description:</strong> " & oRS("BDesc") & "</font></td>"
		sHeader = sHeader & vbCrLf & "      </tr>"
		sHeader = sHeader & vbCrLf & "      <tr>"
		sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Item Number:</strong> " & oRS("ItemNum") & "</font></td>"
		sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Item Revision:</strong> " & oRS("ItemRev") & "</font></td>"
		sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>BOM Type:</strong> " & oRS("BType") & "</font></td>"
		sHeader = sHeader & vbCrLf & "      </tr>"
		sHeader = sHeader & vbCrLf & "      <tr>"
		sHeader = sHeader & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>BOM Item Status:</strong> " & oRS("ItemStatus") & "</font></td>"
		sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Effective Date:</strong> " & oRS("EffDate") & "</font></td>"
		sHeader = sHeader & vbCrLf & "      </tr>"
		sHeader = sHeader & vbCrLf & "      <tr>"
		sHeader = sHeader & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Item Description:</strong> " & oRS("BItemDesc") & "</font></td>"
		sHeader = sHeader & vbCrLf & "      </tr>"
		sHeader = sHeader & vbCrLf & "    </table>"
	End If
	oRS.Close
	
	sCMD = "SELECT SeqNum, CItemNum, CItemRev, CItemQty, CItemUOM, CItemEff, RefDes, "
	sCMD = sCMD & "CItemCost, CItemDesc FROM BOMItems WHERE (BItemID = " & nItemID & ")"
	Set oRS = GetADORecordset(sCMD, Nothing)
	
	If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
		oRS.MoveFirst
		'Fill table contents
		Select Case sRptFmt
			Case "StdBOM"
				'Set table header
				sItemList = "    <table border='0' width='70%'>"
				sItemList = sItemList & vbCrLf & "      <tr>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Seq. No.</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7' width='100'><strong><font face='Verdana' size='1'>Item No.</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Qty</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>UOM</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Description</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Ref Des</font></strong></td>"
				sItemList = sItemList & vbCrLf & "      </tr>"
				Do
					sItemList = sItemList & vbCrLf & "      <tr>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("SeqNum") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemNum") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemQty") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemUOM") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("CItemDesc")), "", oRS("CItemDesc")) & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("RefDes")), "", oRS("RefDes")) & "</font></td>"
					sItemList = sItemList & vbCrLf & "      </tr>"
					oRS.MoveNext
				Loop Until oRS.EOF
				'End table
				sItemList = sItemList & vbCrLf & "    </table>"
			Case "BItemEff"
				'Set table header
				sItemList = "    <table border='0' width='660'>"
				sItemList = sItemList & vbCrLf & "      <tr>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Seq. No.</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Item No.</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Rev</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Qty</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>UOM</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Description</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Eff. Date</font></strong></td>"
				sItemList = sItemList & vbCrLf & "      </tr>"
				Do
					sItemList = sItemList & vbCrLf & "      <tr>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("SeqNum") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemNum") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemRev") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemQty") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemUOM") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("CItemDesc")), "", oRS("CItemDesc")) & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(oRS("CItemEff")), "-", oRS("CItemEff")) & "</font></td>"
					sItemList = sItemList & vbCrLf & "      </tr>"
					oRS.MoveNext
				Loop Until oRS.EOF
				'End table
				sItemList = sItemList & vbCrLf & "    </table>"
			Case "CostBOM"
				'Set table header
				nTotalCost = 0
				sItemList = "    <table border='0' width='660'>"
				sItemList = sItemList & vbCrLf & "      <tr>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Seq. No.</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Item No.</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Qty</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>UOM</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Description</font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td bgcolor='#D7D7D7'><strong><font face='Verdana' size='1'>Cost</font></strong></td>"
				sItemList = sItemList & vbCrLf & "      </tr>"
				Do
					sItemList = sItemList & vbCrLf & "      <tr>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("SeqNum") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemNum") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemQty") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemUOM") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemDesc") & "</font></td>"
					sItemList = sItemList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & oRS("CItemCost") & "</font></td>"
					sItemList = sItemList & vbCrLf & "      </tr>"
					nTotalCost = nTotalCost + oRS("CItemCost")
					oRS.MoveNext
				Loop Until oRS.EOF
				'Generate total line
				sItemList = sItemList & vbCrLf & "      <tr>"
				sItemList = sItemList & vbCrLf & "        <td align='right' colspan='5' bgcolor='#D7D7D7'><strong><font face='Verdana' size='2'>Total Cost: </font></strong></td>"
				sItemList = sItemList & vbCrLf & "        <td valign='top' bgcolor='#D7D7D7'><strong><font face='Verdana' size='2'>" & nTotalCost & "</font></strong></td>"
				sItemList = sItemList & vbCrLf & "      </tr>"
				'End table
				sItemList = sItemList & vbCrLf & "    </table>"
		End Select
	End If
	oRS.Close
	Set oRS = Nothing
	
	sRptText = sHeader & vbCrLf & sItemList
	GetEBRpt = sRptText
End Function

%>
