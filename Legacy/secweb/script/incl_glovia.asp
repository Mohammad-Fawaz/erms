<%
Function TestDB(sParam)
	Dim CN
	Dim sSQL
	Dim x
	Dim nRecs
	
	On Error Resume Next
	
	sSQL = GetGloviaSQL("BOM1", sParam)
	Set CN = GetGloviaConn()
	If (CN Is Nothing) Then
		TestDB = "<p><font face='Verdana' size='2'><strong>Connection:</strong> FAILED</font></p>"
	Else
		TestDB = "<p><font face='Verdana' size='2'><strong>Connection:</strong> OPEN</font></p>"
		sSQL = Replace( sSQL, "*", Chr(37), 1, -1, 1)
		TestDB = TestDB & vbCrLf & "<p><font face='Verdana' size='2'><strong>SQL:</strong> " & sSQL & "</font></p>"
		CN.Execute sSQL, nRecs
		If (CN.Errors.Count > 0) Then
			For x = 0 To (CN.Errors.Count - 1)
				TestDB = TestDB & vbCrLf & "<p><font face='Verdana' size='2'><strong>ERROR:</strong> " & CN.Errors(x).Number & "<br>" & vbCrLf & CN.Errors(x).Description & "</font></p>"
			Next
			CN.Errors.Clear
		Else
			TestDB = TestDB & vbCrLf & "<p><font face='Verdana' size='2'><strong>Records Returned:</strong> " & nRecs & "</font></p>"
		End If
		CN.Close
	End If
	Set CN = Nothing
End Function

Function GetBOMRpt(sParam)
	Dim sBOM
	Dim rsBOM1
	Dim rsBOM2
	Dim sSQL
	Dim sRef
	Dim CN
	Dim x
	Dim nRecs
	
	If (sParam <> "") Then
		Set CN = GetGloviaConn()
		
		If Not (CN Is Nothing) Then
			sBOM = ""
			sSQL = GetGloviaSQL("BOM1", UCase(sParam))
			sSQL = Replace( sSQL, "*", Chr(37), 1, -1, 1)
			Set rsBOM1 = CN.Execute(sSQL, nRecs, 1)
			'CN.ExecuteComplete
			If (CN.Errors.Count > 0) Then
				sBOM = "    <p><font face='Verdana' size='5'>Bills of Material Report</font></p>"
				For x = 0 To (CN.Errors.Count - 1)
					sBOM = sBOM & vbCrLf & "<p><font face='Verdana' size='2'><strong>ERROR:</strong> " & CN.Errors(x).Number & "<br>"
					sBOM = sBOM & vbCrLf & CN.Errors(x).Description & "</font></p>"
				Next
				CN.Errors.Clear
			Else
				'Create report output
				sBOM = "    <font face='Verdana' size='5'>Bills of Material Report</font>"
				sBOM = sBOM & vbCrLf & "    <table border='0' cellpadding='2'>"
				sRef = ""
				Do
					If (IsNull(rsBOM1("ITEM")) = False) And (rsBOM1("ITEM") <> sRef) Then
						sRef = IIf(IsNull(rsBOM1("ITEM")), "-", rsBOM1("ITEM"))
						sBOM = sBOM & vbCrLf & "      <tr>"
						sBOM = sBOM & vbCrLf & "        <td align='right'><strong><font face='Verdana' size='2'>Assembly:</font></strong></td>"
						sBOM = sBOM & vbCrLf & "        <td><font face='Verdana' size='2'>" & sRef & "</font></td>"
						sBOM = sBOM & vbCrLf & "        <td align='right'><strong><font face='Verdana' size='2'>Rev:</font></strong></td>"
						sBOM = sBOM & vbCrLf & "        <td><font face='Verdana' size='2'>" & IIf(IsNull(rsBOM1("DRAW_REV")), "-", rsBOM1("DRAW_REV")) & "</font></td>"
						sBOM = sBOM & vbCrLf & "      </tr>"
						sBOM = sBOM & vbCrLf & "      <tr>"
						sBOM = sBOM & vbCrLf & "        <td><font face='Verdana' size='2'></font></td>"
						sBOM = sBOM & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'>" & IIf(IsNull(rsBOM1("DESCRIPTION")), "-", rsBOM1("DESCRIPTION")) & "</font></td>"
						sBOM = sBOM & vbCrLf & "      </tr>"
						sBOM = sBOM & vbCrLf & "    </table>"
						sBOM = sBOM & vbCrLf & "    <table border='0' cellpadding='2'>"
						sBOM = sBOM & vbCrLf & "      <tr>"
						sBOM = sBOM & vbCrLf & "        <td valign='top' align='center' nowrap><strong><font face='Verdana' size='2'>Useq</font></strong></td>"
						sBOM = sBOM & vbCrLf & "        <td valign='top' nowrap><strong><font face='Verdana' size='2'>Component</font></strong></td>"
						sBOM = sBOM & vbCrLf & "        <td valign='top' align='right' nowrap><strong><font face='Verdana' size='2'>Qty. Per</font></strong></td>"
						sBOM = sBOM & vbCrLf & "        <td valign='top' align='center' nowrap><font face='Verdana' size='2'><strong> UM </strong></font></td>"
						sBOM = sBOM & vbCrLf & "        <td valign='top' nowrap><strong><font face='Verdana' size='2'>Description</font></strong></td>"
						sBOM = sBOM & vbCrLf & "      </tr>"
					
						If (sRef <> "") And (sRef <> "-") Then
							sSQL = GetGloviaSQL("BOM2", UCase(sRef))
							sSQL = Replace( sSQL, "*", Chr(37), 1, -1, 1)
							Set rsBOM2 = CN.Execute(sSQL, nRecs, 1)
							If (CN.Errors.Count > 0) Then
								For x = 0 To (CN.Errors.Count - 1)
									sBOM = sBOM & vbCrLf & "      <tr>"
									sBOM = sBOM & vbCrLf & "        <td colspan='5'><font face='Verdana' size='2'><strong>ERROR:</strong> " & CN.Errors(x).Number & "<br>" & vbCrLf & CN.Errors(x).Description & "</font></td>"
									sBOM = sBOM & vbCrLf & "      </tr>"
								Next
								CN.Errors.Clear
							Else
								Do
									sBOM = sBOM & vbCrLf & "      <tr>"
									sBOM = sBOM & vbCrLf & "        <td valign='top' align='center'><font face='Verdana' size='2'>" & IIf(IsNull(rsBOM2("BOM_USEQ")), "-", rsBOM2("BOM_USEQ")) & "</font></td>"
									sBOM = sBOM & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsBOM2("COMP_ITEM")), "-", rsBOM2("COMP_ITEM")) & "</font></td>"
									sBOM = sBOM & vbCrLf & "        <td valign='top' align='right'><font face='Verdana' size='2'>" & IIf(IsNull(rsBOM2("COMP_QTY")), "-", rsBOM2("COMP_QTY")) & "</font></td>"
									sBOM = sBOM & vbCrLf & "        <td valign='top' align='center'><font face='Verdana' size='2'>" & IIf(IsNull(rsBOM2("STOCK_UM")), "-", rsBOM2("STOCK_UM")) & "</font></td>"
									sBOM = sBOM & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsBOM2("DESCRIPTION")), "-", rsBOM2("DESCRIPTION")) & "</font></td>"
									sBOM = sBOM & vbCrLf & "      </tr>"
									rsBOM2.MoveNext
								Loop Until rsBOM2.EOF
								rsBOM2.Close
							End If
						End If
					'Else
					'	sBOM = sBOM & vbCrLf & "      <tr>"
					'	sBOM = sBOM & vbCrLf & "        <td colspan='5'><font face='Verdana' size='2'><strong>ERROR:</strong> NO DATA WAS RETURNED</font></td>"
					'	sBOM = sBOM & vbCrLf & "      </tr>"
					End If
					
					sBOM = sBOM & vbCrLf & "    </table>"
					rsBOM1.MoveNext
				Loop Until rsBOM1.EOF
			End If
			
			rsBOM1.Close
			Set rsBOM1 = Nothing
			Set rsBOM2 = Nothing
			CN.Close
		Else
			sBOM = "    <font face='Verdana' size='5'>Bills of Material Report</font><br><font face='Verdana' size='3'>DATA CONNECTION ERROR: A database connection could not be established.</font>"
		End If
		
		Set CN = Nothing
	Else
		sBOM = "    <font face='Verdana' size='5'>Bills of Material Report</font><br><font face='Verdana' size='3'>NO PARAMETER SET: You must provide a partial [Assembly] number to view BOM Report information.</font>"
	End If
	
	GetBOMRpt = sBOM
End Function

Function GetGloviaSQL(sRef, sParam1)
	Dim sSQL
	
	sSQL = ""
	Select Case sRef
		Case "BOM1"
			If (sParam1 <> "") Then
				sSQL = "SELECT DISTINCT GLOVIA_PROD40.BOM.ITEM, GLOVIA_PROD40.ITEM_CCN.DRAW_REV, GLOVIA_PROD40.ITEM.DESCRIPTION "
				sSQL = sSQL & "FROM GLOVIA_PROD40.BOM, GLOVIA_PROD40.ITEM_CCN, GLOVIA_PROD40.ITEM "
				sSQL = sSQL & "WHERE ((GLOVIA_PROD40.BOM.REVISION = GLOVIA_PROD40.ITEM_CCN.REVISION) AND "
				sSQL = sSQL & "(GLOVIA_PROD40.BOM.ITEM = GLOVIA_PROD40.ITEM_CCN.ITEM) AND "
				sSQL = sSQL & "(GLOVIA_PROD40.BOM.CCN = GLOVIA_PROD40.ITEM_CCN.CCN)) AND "
				sSQL = sSQL & "((GLOVIA_PROD40.BOM.REVISION = GLOVIA_PROD40.ITEM.REVISION) AND "
				sSQL = sSQL & "(GLOVIA_PROD40.BOM.ITEM = GLOVIA_PROD40.ITEM.ITEM)) AND "
				sSQL = sSQL & "((GLOVIA_PROD40.BOM.ITEM LIKE '" & sParam1 & "') AND ((GLOVIA_PROD40.ITEM_CCN.DRAW_REV <> 'OBS') "
				sSQL = sSQL & "AND (GLOVIA_PROD40.ITEM_CCN.DRAW_REV <> 'MOD')) AND (GLOVIA_PROD40.BOM.COMP_ITEM NOT LIKE '*ACCT*') "
				sSQL = sSQL & "AND (GLOVIA_PROD40.BOM.CCN = '01') AND (GLOVIA_PROD40.BOM.BCR_TYPE = 'CUR'))"
			End If
		Case "BOM2"
			If (sParam1 <> "") Then
				sSQL = "SELECT DISTINCT GLOVIA_PROD40.BOM.BOM_USEQ, GLOVIA_PROD40.BOM.COMP_ITEM, GLOVIA_PROD40.BOM.COMP_QTY, "
				sSQL = sSQL & "GLOVIA_PROD40.ITEM_CCN.STOCK_UM, GLOVIA_PROD40.ITEM.DESCRIPTION "
				sSQL = sSQL & "FROM GLOVIA_PROD40.BOM, GLOVIA_PROD40.ITEM, GLOVIA_PROD40.ITEM_CCN "
				sSQL = sSQL & "WHERE ((GLOVIA_PROD40.BOM.COMP_REV = GLOVIA_PROD40.ITEM.REVISION) AND "
				sSQL = sSQL & "(GLOVIA_PROD40.BOM.COMP_ITEM = GLOVIA_PROD40.ITEM.ITEM)) AND "
				sSQL = sSQL & "((GLOVIA_PROD40.BOM.CCN = GLOVIA_PROD40.ITEM_CCN.CCN) AND "
				sSQL = sSQL & "(GLOVIA_PROD40.BOM.COMP_REV = GLOVIA_PROD40.ITEM_CCN.REVISION) AND "
				sSQL = sSQL & "(GLOVIA_PROD40.BOM.COMP_ITEM = GLOVIA_PROD40.ITEM_CCN.ITEM)) AND "
				sSQL = sSQL & "((GLOVIA_PROD40.BOM.ITEM = '" & sParam1 & "') AND ((GLOVIA_PROD40.ITEM_CCN.DRAW_REV <> 'OBS') "
				sSQL = sSQL & "AND (GLOVIA_PROD40.ITEM_CCN.DRAW_REV <> 'MOD')) AND (GLOVIA_PROD40.BOM.COMP_ITEM NOT LIKE '*ACCT*') "
				sSQL = sSQL & "AND (GLOVIA_PROD40.BOM.CCN = '01') AND (GLOVIA_PROD40.BOM.BCR_TYPE = 'CUR'))"
			End If
	End Select
	
	GetGloviaSQL = sSQL
End Function

Function GetGloviaConn()
    Dim sConnect
    
    'sConnect = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="
    sConnect = "Provider=MSDASQL;DRIVER={Microsoft ODBC for Oracle};Server=PROD;UID=PRODCNTRL;Password=PLANNING;"
    Set GetGloviaConn = Server.CreateObject("ADODB.Connection")
    
	GetGloviaConn.ConnectionTimeout = 30
	GetGloviaConn.CommandTimeout = 15
	GetGloviaConn.Mode = 1
	'GetGloviaConn.DefaultDatabase = ""
	'GetGloviaConn.IsolationLevel = adXactCursorStability
	
	GetGloviaConn.Open sConnect
End Function

Function GetGloviaRS(sSQL)
    Dim CN
    
    If (sSQL <> "") Then
		sSQL = Replace( sSQL, "*", Chr(37), 1, -1, 1)
		Set CN = GetGloviaConn()
        Set GetGloviaRS = Server.CreateObject("ADODB.Recordset")
        GetGloviaRS.Open sSQL, CN
        Set CN = Nothing
    End If
End Function

%>
