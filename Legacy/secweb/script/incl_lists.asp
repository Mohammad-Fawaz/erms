<script type="text/javascript">
    function openDocInfo(url) {
        var frameQ = top.document.getElementById("PageContent_frameQSearch");
        if (frameQ != null) {
            top.document.getElementById("PageContent_frameQSearch").style.display = "none";
		}
        var frameA = top.document.getElementById("PageContent_frameAdvanceSearch");
        if (frameA != null) {
            top.document.getElementById("PageContent_frameAdvanceSearch").style.display = "none";
        }
        window.top.location.href = url;
    }
</script>
<%

Function GetSelect(vList, vVal)
    Dim sSelect
    Dim sSQL
    Dim bSearchList
    Dim rsList
    Dim sTemp
    Dim nTemp
    
    bSearchList = False
    
    Select Case vList
        Case "BOMItem"
			nTemp = Len(vVal)
			sSQL = "SELECT DISTINCT PartNo AS OptVal, PartNo AS OptText FROM ViewBOMParts " & IIf(vVal <> "", "WHERE (Left(PartNo, " & nTemp & ") = '" & vVal &"') ", "")
			
		Case "BOMItem1"
			nTemp = Len(vVal)
			sSQL = "SELECT DISTINCT PartNo + ': ' + IIf(IsNull(CurRev), '-', CurRev) AS OptText, PartID AS OptVal FROM ViewBOMParts " & IIf(vVal <> "", "WHERE (Left(PartNo, " & nTemp & ") = '" & vVal & "')", "")
			
		Case "CItem"
			sSQL = "SELECT DISTINCT PartNo + ': ' + IIf(IsNull(CurRev), '-', CurRev) AS OptText, PartID AS OptVal FROM ViewBOMParts"
			
		Case "BItemInfo"
			nTemp = Len(vVal)
			sSQL = "SELECT DISTINCT ItemNum + ': ' + IIf(IsNull(ItemRev), '-', ItemRev) + ': ' + IIf(IsNull(BType), '', BType) AS OptText, BItemID AS OptVal FROM BOMHdr " & IIf(vVal <> "", "WHERE (Left(ItemNum, " & nTemp & ") = '" & vVal & "')", "")
			
		Case "ItemRevHist"
			If (InStr(1, vVal, "|", 1) > 0) Then
				nTemp = InStr(1, vVal, "|", 1)
				sTemp = Left(vVal, nTemp - 1)
				vVal = Right(vVal, Len(vVal) - nTemp)
			Else
				sTemp = vVal
			End If
			sSQL = "SELECT DISTINCT IIf(IsNull(CurRev), '-', CurRev) AS OptVal, IIf(IsNull(CurRev), '-', CurRev) AS OptText FROM ViewBOMParts WHERE (PartNo = '" & sTemp & "')"
		Case "PartUOM"
			sSQL = "SELECT OptCode AS OptVal, OptCode AS OptText FROM StdOptions WHERE (OptType = 'UOM') ORDER BY OptCode"
        Case "PartStatus"
			sSQL = "SELECT OptDesc AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'DocStatus') ORDER BY OptDesc"
        Case "WTemplate"
			sSQL = "SELECT WTID AS OptVal, WTName AS OptText FROM WFlowTemplate ORDER BY WTName"
        Case "WActions"
			sSQL = "SELECT WAID AS OptVal, WAName AS OptText FROM WFlowActions ORDER BY WAName"
        Case "PSize"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'PrintSize') ORDER BY OptDesc"
        Case "PLoc"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'PrintLoc') ORDER BY OptDesc"
		Case "NoteType"
			sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'NoteType') ORDER BY OptDesc"
        Case "Project"
            sSQL = "SELECT ProjNum AS OptVal, Project AS OptText FROM QProject ORDER BY ProjNum"
        Case "Project1"
            sSQL = "SELECT ProjNum AS OptVal, Project AS OptText FROM QProject WHERE ((ProjStatus = 'ACT') OR (ProjStatus = 'PLN')) ORDER BY ProjNum"
            
            
        Case "EmpList"
            sSQL = "SELECT EmpID AS OptVal, ULNF AS OptText FROM UserXRef ORDER BY ULNF"
            
            
        Case "Discipline"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'Discipline') ORDER BY OptDesc"
            
        Case "DocStatus"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'DocStatus') ORDER BY OptDesc"
            
        Case "DocType"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'DocType') ORDER BY OptDesc"
		Case "DocElement"
		
	    	sSQL = "SELECT Documents.DocID AS OptVal, Documents.DocID + ' ' + Documents.DocDesc AS OptText FROM CustomUDF INNER JOIN Documents ON "
	    	sSQL = sSQL & "CustomUDF.RefID = Documents.DocID WHERE (CustomUDF.RefType='DOC') AND (CustomUDF.UDF7 = True) ORDER BY Documents.DocID"
	    	
	    	'sSQL = "SELECT DISTINCT DocID AS OptVal, DocID + ' ' + DocDesc AS OptText FROM ViewListWafElem"
	    	
		Case "DocIngot"
	    	sSQL = "SELECT DISTINCT PartNo AS OptVal, PartNo + ' [Dia. ' + Par10 + ']' AS OptText FROM PartPar WHERE (Left(DocID, 3) = '483') AND (CDbl(Par10) > 0)"
	    	'ERROR: NO RECORDS - sSQL = "SELECT DISTINCT PartNo AS OptVal, PartNo + ' [Dia. ' + Par10 + ']' AS OptText FROM ViewListWafElem WHERE (Left(DocID, 3) = '483')"
	    Case "Wafer"
			'sSQL = "SELECT DISTINCT DocID AS OptVal, DocID + ' [Dia. ' + Par10 + ']' AS OptText FROM PartPar WHERE (Left(DocID, 3) = '484')"
			sSQL = "SELECT DISTINCT DocID AS OptVal, DocID + ' [Dia. ' + Par10 + ']' AS OptText FROM ViewListWafElem WHERE (Left(DocID, 3) = '484')"
		Case "SliceForm"
			sSQL = "SELECT OptDesc AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'SliceForm') ORDER BY OptCode"
			
        Case "ChStatus"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'ChStatus') ORDER BY OptDesc"
            
        Case "ChClass"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'ChClass') ORDER BY OptDesc"
        Case "ChType"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'ChangeType') ORDER BY OptDesc"
        Case "ChPriority"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'Priority') ORDER BY OptDesc"
        Case "ChJustification"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'Justification') ORDER BY OptDesc"
        Case "AType"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'AType') ORDER BY OptDesc"
            
        Case "TaskStatus"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'TaskStatus') ORDER BY OptDesc"
        Case "TaskPriority"
            sSQL = "SELECT OptCode AS OptVal, OptDesc AS OptText FROM StdOptions WHERE (OptType = 'TaskPriority') ORDER BY OptDesc"
            
        Case "StdTask"
            sSQL = "SELECT StdTaskID AS OptVal, TaskDesc AS OptText FROM StdTasks ORDER BY TaskDesc"
            
        Case "SearchChanges"
            bSearchList = True
            sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Changes') ORDER BY FieldName"
        Case "SearchDocs"
            bSearchList = True
            sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Documents') ORDER BY FieldName"
			
		Case "SearchOrders"
            bSearchList = True
            sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Orders') ORDER BY FieldName"
        Case "SearchParts"
            bSearchList = True
            sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Parts') ORDER BY FieldName"
        Case "SearchProjects"
            bSearchList = True
            sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Projects') ORDER BY FieldName"
        Case "SearchActions"
            bSearchList = True
            sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Actions') ORDER BY FieldName"
        Case "SearchTasks"
            bSearchList = True
            sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Tasks') ORDER BY FieldName"
		Case "SearchReports"
			bSearchList = True
			sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Reports') ORDER BY FieldName"
	    Case "SearchControlLists"
			bSearchList = True
			sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'ControlL') ORDER BY FieldName"
	    Case "SearchRestrictions"
			bSearchList = True
			sSQL = "SELECT SearchField, FieldName, FieldType, Search FROM SearchFields WHERE (Search = 'Restrict') ORDER BY FieldName"
    End Select

	'Set fso = CreateObject("Scripting.FileSystemObject")
    'Set qfile = fso.OpenTextFile("D:\qtptest.txt",2,True)
    'qfile.WriteLine "Query--" + sSQL
    
    If (Trim(sSQL) <> "") Then
        Set rsList = GetADORecordset(sSQL, Nothing)
        
        If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
            Do
                If bSearchList Then
					If Not IsNull(rsList("SearchField")) Then
					    sSelect = IIf(Trim(sSelect) <> "", sSelect & vbCrLf, "") & "<option value='" & rsList("SearchField") & "'>" & rsList("FieldName") & " (" & rsList("FieldType") & ")</option>"
					End If
				Else
					If Not IsNull(rsList("OptText")) Then
						If ((vList = "Project") Or (vList = "Project1") Or (vList = "DocElement")) Then
							sTemp = rsList("OptText")
							sTemp = IIf(Len(sTemp) > 54, Left(sTemp, 51) & "...", sTemp)
							sSelect = IIf(Trim(sSelect) <> "", sSelect & vbCrLf, "") & "<option value='" & rsList("OptVal") & "'" & IIf(vVal = rsList("OptVal"), " SELECTED", "") & ">" & sTemp & "</option>"
						Else
							sSelect = IIf(Trim(sSelect) <> "", sSelect & vbCrLf, "") & "<option value='" & rsList("OptVal") & "'" & IIf(vVal = rsList("OptVal"), " SELECTED", "") & ">" & rsList("OptText") & "</option>"
						End If
					End If
                End If
                
                If Not (rsList.EOF) Then
					rsList.MoveNext
                End If
            Loop Until rsList.EOF
        Else
            sSelect = ""
        End If
        
        rsList.Close
        Set rsList = Nothing
    Else
        sSelect = ""
    End If
    
    GetSelect = sSelect
End Function

Function GetListing(vList, vVal, vPagePos)
    Dim sSQL
    Dim sListing
    Dim sConst
    Dim rsList
    Dim nPage
    Dim nPageCount
    Dim nPageSize
    Dim sPgPos
    Dim nRecPos
    Dim nRecCount
    Dim sPrev
    Dim sPos
    Dim sNext
    Dim nPgPrev
    Dim nPgNext
    Dim sFmtPos
    Dim x
    Dim bPageEnd
    Dim nLastRec
    Dim sNewVars
    
    Dim sFmtHead
    Dim sListHead1
    Dim sListHead2
    Dim sList
    
    'Response.Write vList & "<br>"  & vVal & "<br>"  & vPagePos
            
    sConst = IIf(vVal = "", "", vVal)
    sList = ""
    
    If (vPagePos <> "") Then
		If (InStr(1, vPagePos, ":", 1) > 0) Then
			nPage = CLng(Left(vPagePos, InStr(1, vPagePos, ":", 1) - 1))
			nPageSize = CLng(Right(vPagePos, Len(vPagePos) - InStr(1, vPagePos, ":", 1)))
			
			If Not (nPageSize > 1) Then
				nPageSize = 50
			End If
			
			If (nPage > 1) Then
				nRecPos = ((nPage - 1) * nPageSize) + 1
			Else
				nPage = 1
				nRecPos = 1
			End If
		Else
			nPage = 1
			nRecPos = 1
			nPageSize = 50
		End If
	Else
		nPage = 1
		nRecPos = 1
		nPageSize = 50
    End If
    
    If Not (nPageSize > 1) Then
		nPageSize = 50
	End If
	If Not (nPage > 0) Then
		nPage = 1
	End If
	
	If (InStr(1, sConst,  "*", 1) > 0) Then sConst = Replace(sConst, "*", Chr(37), 1, -1, 1)
	If (InStr(1, sConst,  "@", 1) > 0) Then sConst = Replace(sConst, "@", "#", 1, -1, 1)
	If (InStr(1, sConst, "||", 1) > 0) Then sConst = Replace(sConst, "||", "'", 1, -1, 1)
	
    Select Case vList
        Case "Doc", "Docs", "Documents"
			sSQL = "SELECT DISTINCT DocID, DocStatus, Status, CurrentRev, "
            sSQL = sSQL & "DocType, DType, DocDesc, DocRelDate "
            sSQL = sSQL & "FROM ViewDocs"
            sSQL = sSQL & IIf(sConst <> "", " WHERE " & sConst, "")
            sSQL = sSQL & " ORDER BY DocID"
        Case "DocElement", "DocsElement", "DocumentsElement"
			sSQL = "SELECT DISTINCT DocID, DocStatus, Status, CurrentRev, "
            sSQL = sSQL & "DocType, DType, DocDesc, DocRelDate "
            sSQL = sSQL & "FROM ViewDocsPartPar"
            sSQL = sSQL & IIf(sConst <> "", " WHERE " & sConst, "")
            sSQL = sSQL & " ORDER BY DocID"
        Case "Change", "Changes", "Change Orders"
            sSQL = "SELECT DISTINCT CO, ChStatus, Status, ChPriority, Priority, ChJustification, Justification, " 
            sSQL = sSQL & "ProjNum, ProjName, ChangeType, ChType, ChangeDesc, ChEffDate FROM ViewChanges" 
            sSQL = sSQL & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY CO"
        Case "Order", "Orders"
            sSQL = "SELECT DISTINCT OrderID, OrderType, OrderNum, OrderStatus, " 
            sSQL = sSQL & "ProjNum, ProjName, VendCustID, VCName, OrderDate, PlannedEndDate FROM ViewOrders" 
            sSQL = sSQL & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY OrderType, OrderNum"
        Case "Part", "Parts"
            sSQL = "SELECT DISTINCT PartID, PartNo, DocID, RType, RStatus, CurRev, FileLink, PartDesc FROM ViewParts" 
            sSQL = sSQL & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY PartNo"
        Case "Project", "Projects"
            sSQL = "SELECT DISTINCT ProjNum, ProjName, ProjStatus, VendCustID, VCName, PlannedStart, PlannedFinish, ActualStart, " 
            sSQL = sSQL & "ActualFinish, BudgetLabor, ActualLabor FROM ViewProjects" & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY ProjNum"
        Case "QAction", "QActions", "Quality Actions"
            sSQL = "SELECT DISTINCT RefType, RefNum, Status, Priority, ProjNum, ProjName, DateRequired, IssueDesc " 
            sSQL = sSQL & "FROM ViewActions" & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY RefType, RefNum"
        Case "Task", "Tasks"
            sSQL = "SELECT DISTINCT TaskID, Status, Priority, Project, Workgroup, ResourceName, TaskDesc, PlannedStart, PlannedFinish, " 
            sSQL = sSQL & "ActualStart, ActualFinish, EstHours, ActualHours FROM ViewTasks" & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY TaskID"
		Case "Reports"
			sSQL = "SELECT ReportId, Name, ReportDesc " 
			sSQL = sSQL & "FROM QReports" & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY ReportID"
		Case "ControlLists"
			sSQL = "SELECT OptCode, OptDesc " 
			sSQL = sSQL & "FROM QControlList" & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY OptCode"
		Case "Restrictions"
			sSQL = "SELECT RNotID, RNDesc, RNText1 " 
			sSQL = sSQL & "FROM ResNotice" & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY RNotID"
		Case "Help"
			sSQL = "SELECT RequestNo, Status, RequestType, Priority, RequestBy, RequestDate " 
			sSQL = sSQL & "FROM HelpDesk" & IIf(sConst <> "", " WHERE " & sConst, "") & " ORDER BY RequestNo"
    End Select
	
	'Set fso = CreateObject("Scripting.FileSystemObject")
	'Set qfile = fso.OpenTextFile("D:\qtptest.txt",2,True)
	'qfile.WriteLine "Query--" & sSQL
	'qfile.WriteLine "list--" & vList

	If (InStr(1, sConst, Chr(37), 1) > 0) Then sConst = Replace(sConst, Chr(37), "*", 1, -1, 1)
	If (InStr(1, sConst, "#", 1) > 0) Then sConst = Replace(sConst, "#", "@", 1, -1, 1)
	If (InStr(1, sConst, "'", 1) > 0) Then sConst = Replace(sConst, "'", "||", 1, -1, 1)
	sNewVars = "Listing=" & vList & "&V=" & sConst
	
	'Response.Write "===========================================<br>"
	'Response.Write "vList=" & vList & "<br>"
	'Response.Write "vVal=" & vVal & "<br>"
	'Response.Write "vPagePos=" & vPagePos & "<br>"
	'Response.Write "sSQL=" & sSQL & "<br>"
	'Response.Write "sConst=" & sConst & "<br>"
	'Response.Write "sNewVars=" & sNewVars & "<br>"
	'Response.Write "===========================================<br>"
		  
    If (sSQL <> "") Then
           		
		If Session("SaveReport") = "true" then           
          SaveMyReports GetUserInfoItem(Session("SI"), "ProfileID"), Session("ReportName"), Session("ReportDesc"), vList ,sSQL, GetUserInfoItem(Session("SI"), "EmpID")		    	    				 
        End If
        
		Set rsList = GetADORecordset(sSQL, Nothing)
		nRecCount = 0
		
		If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
			Do
				nRecCount = nRecCount + 1
				rsList.MoveNext
			Loop Until rsList.EOF
			
			rsList.MoveFirst
			If (nRecPos > nRecCount) Then
				nRecPos = nRecCount
			End If
			If (nRecPos > 1) Then
				'rsList.MoveNext
				If (nRecPos = nRecCount) Then
					rsList.MoveLast
				Else
					For x = 1 To nRecPos
						rsList.MoveNext
					Next
				End If
			End If
			            
			If (nRecCount > 0) Then
				If ((nRecCount / nPageSize) > CLng(nRecCount / nPageSize)) Then
					nPageCount = CLng(nRecCount / nPageSize) + 1
				Else
					nPageCount = CLng(nRecCount / nPageSize)
				End If
				If (nPageCount < 1) Then
					nPageCount = 1
				End If
				If (nPage > 1) Then
					If (nPage <= nPageCount) Then
						If (nRecPos > 0) Then
							nLastRec = nRecPos + (nPageSize - 1)
							If (nLastRec > nRecCount) Then
								nLastRec = nRecCount
							End If
							sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
						Else
							If (nPage >= nPageCount) Then
								nPage = nPageCount
							End If
							nLastRec = nRecPos + (nPageSize - 1)
							If (nLastRec > nRecCount) Then
								nLastRec = nRecCount
							End If
							nRecPos = ((nPage * nPageSize) + 1) - nPageSize
							sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
						End If
					Else
						nPage = nPageCount
						nLastRec = nRecPos + (nPageSize - 1)
						If (nLastRec > nRecCount) Then
							nLastRec = nRecCount
						End If
						nRecPos = ((nPage * nPageSize) + 1) - nPageSize
						sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
					End If
				Else
					nPage = 1
					nRecPos = 1
					nLastRec = nRecPos + (nPageSize - 1)
					If (nLastRec > nRecCount) Then
						nLastRec = nRecCount
					End If
					sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
				End If
			Else
				nPageCount = 1
				nPage = 1
				nRecPos = 0
				nRecCount = 0
				sPos = "Record 0 of 0"
			End If '---- nRecCount > 0
					
			sPgPos = "Page " & CStr(nPage) & " of " & CStr(nPageCount)
			nPgPrev = IIf(nPage <= 1, nPage, nPage - 1)
			nPgNext = IIf(nPage >= nPageCount, nPage, nPage + 1)
			x = 1
			bPageEnd = False
			
			Select Case vList
			    Case "Doc", "Docs", "Documents", "DocElement", "DocsElement", "DocumentsElement"
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						sFmtHead = "      <tr>" 
						sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='4'><font face='Verdana' size='2'><strong>"  
					
						'Set table headers
						'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
						sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
					
						sListHead2 = vbCrLf & "      <tr>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>DocID [Rev]</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status [Rel Date]<br>Doc Type</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
						'sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' color='#FFFF00'><strong>Notes</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "      </tr>"
						
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("DocID")) Then
									Listing = "Doc" ' all "special doc types" (e.g. elements) handled the same from here on (for gui display)
									sList = IIf(sList <> "", sList, "") & vbCrLf & "      <tr>" 																		
									'sList = sList & vbCrLf & "  <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp1?Listing=Doc&Item=" & rsList("DocID") & "'>" & rsList("DocID") & "</a>" & IIf(rsList("CurrentRev") <> "", " [" & rsList("CurrentRev") & "]", "") & "</font></td>" 																		
	
									'sList = sList & vbCrLf & "  <td valign='top'><font face='Verdana' size='2'><a href='javascript:window.top.location.href=""/DocumentManagement/DocInformation.aspx?DOCID=" & rsList("DocID") & "&SID=" & Session("SI") & """'>" & rsList("DocID") & "</a>" & IIf(rsList("CurrentRev") <> "", " [" & rsList("CurrentRev") & "]", "") & "</font></td>" 																		
									sList = sList & vbCrLf & "  <td valign='top'><font face='Verdana' size='2'><a href='javascript:openDocInfo(""/DocumentManagement/DocInformation.aspx?DOCID=" & rsList("DocID") & "&SID=" & Session("SI") & """)'>" & rsList("DocID") & "</a>" & IIf(rsList("CurrentRev") <> "", " [" & rsList("CurrentRev") & "]", "") & "</font></td>" 																		
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Status")), "(NONE)", rsList("Status")) & IIf(IsNull(rsList("DocRelDate")), "", " [" & rsList("DocRelDate") & "]") & "<br>" & rsList("DType") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("DocDesc")), "(NO DESCRIPTION)", rsList("DocDesc")) & "</font></td>" 
									'sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("DocNotes")), "(NONE)", rsList("DocNotes")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"									
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							rsList.MoveNext
						Loop Until (rsList.EOF = True) Or (bPageEnd = True)
					End If
				Case "Change", "Changes", "Change Orders"
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						sFmtHead = "      <tr>" 
						sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='4'><font face='Verdana' size='2'><strong>"  
						
						'Set table headers
						'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
						sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
						sListHead2 = vbCrLf & "      <tr>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Change Num [Eff]</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status [Priority]<br>Justif [Ch Type]<br>Project</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
						'sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' color='#FFFF00'><strong>Notes</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "      </tr>"
						
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("CO")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../ChangeManagement/ChangeOrders.aspx?SID=" & Session("SI") & "&COID=" & rsList("CO") & "' target='_top'>" & rsList("CO") & "</a>" & IIf(IsNull(rsList("ChEffDate")), "", " [" & rsList("ChEffDate") & "]") & "</font></td>"
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ChStatus")), "NONE", rsList("ChStatus")) & " [" & IIf(IsNull(rsList("ChPriority")), "NONE", rsList("ChPriority")) & "]<br>" 
									sList = sList & IIf(IsNull(rsList("ChJustification")), "NONE", rsList("ChJustification"))
									sList = sList & " [" & IIf(IsNull(rsList("ChangeType")), "NONE", rsList("ChangeType")) & "]<br>" 
									sList = sList & IIf(IsNull(rsList("ProjNum")), "NONE", rsList("ProjNum") & IIf(IsNull(rsList("ProjName")), "", " - " & rsList("ProjName"))) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ChangeDesc")), "(NO DESCRIPTION)", rsList("ChangeDesc")) & "</font></td>" 
									'sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("AddNotes")), "(NONE)", rsList("AddNotes")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"									
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							
							rsList.MoveNext
						Loop Until rsList.EOF
					End If					
				Case "Order", "Orders"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='3'><font face='Verdana' size='2'><strong>"  
					
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
					
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Order Type - Num</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status<br>Order Date - Est Finish</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Project<br>Customer</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
								
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("OrderID")) Then
									sList = sList & vbCrLf & "      <tr>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=Order&Item=" & CStr(rsList("OrderID")) & "'>" & IIf(IsNull(rsList("OrderType")), "NONE", rsList("OrderType")) & " - " & IIf(IsNull(rsList("OrderNum")), "(NONE)", rsList("OrderNum")) & "</a></font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OrderStatus")), "NONE", rsList("OrderStatus")) & "<br>" & IIf(IsNull(rsList("OrderDate")), "NONE", rsList("OrderDate")) & " - " & IIf(IsNull(rsList("PlannedEndDate")), "NONE", rsList("PlannedEndDate")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ProjNum")), "NONE", rsList("ProjNum") & IIf(IsNull(rsList("ProjName")), "", " - " & rsList("ProjName"))) & "<br>" & IIf(IsNull(rsList("VendCustID")), "NONE", rsList("VendCustID")) & IIf(IsNull(rsList("VCName")), "", " - " & rsList("VCName")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"
									
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Part", "Parts"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='3'><font face='Verdana' size='2'><strong>"  
					
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
					
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Part Num [Rev]</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Rev Type - Status<br>Doc ID</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records	
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("PartID")) Then
									sList = sList & vbCrLf & "      <tr>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=Part&Item=" & rsList("PartID") & "'>" & IIf(IsNull(rsList("PartNo")), "NONE", rsList("PartNo")) & "[" & IIf(IsNull(rsList("CurRev")), "NONE", rsList("CurRev")) & "]</a></font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RType")), "NONE", rsList("RType")) & " - " & IIf(IsNull(rsList("RStatus")), "NONE", rsList("RStatus")) & "<br>" & IIf(IsNull(rsList("FileLink")), "", "<a href='" & rsList("FileLink") & "' target = '_blank'>") & IIf(IsNull(rsList("DocID")), "NONE", rsList("DocID")) & IIf(IsNull(rsList("FileLink")), "", "</a>") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("PartDesc")), "NO DESCRIPTION", rsList("PartDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"
										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Project", "Projects"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='5'><font face='Verdana' size='2'><strong>"  
						
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Project</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status<br>Customer</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong> </strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Estimated</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Actual</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
			        
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("ProjNum")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../ProjectManagement/ProjectInformation.aspx?SID=" & Session("SI") & "&PID=" & rsList("ProjNum") & "' target='_top'>" & rsList("ProjNum") & IIf(IsNull(rsList("ProjName")), "", " - " & rsList("ProjName")) &  "</a></font></td>"									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ProjStatus")), "NONE", rsList("ProjStatus")) & "<br>" & IIf(IsNull(rsList("VendCustID")), "NONE", rsList("VendCustID") & IIf(IsNull(rsList("VCName")), "", " - " & rsList("VCName"))) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top' align='right'><font face='Verdana' size='2'>Start:<br>Finish:<br>Hours:</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("PlannedStart")), "-", rsList("PlannedStart")) & "<br>" & IIf(IsNull(rsList("PlannedFinish")), "-", rsList("PlannedFinish")) & "<br>" & IIf(IsNull(rsList("BudgetLabor")), "0", rsList("BudgetLabor")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ActualStart")), "-", rsList("ActualStart")) & "<br>" & IIf(IsNull(rsList("ActualFinish")), "-", rsList("ActualFinish")) & "<br>" & IIf(IsNull(rsList("ActualLabor")), "0", rsList("ActualLabor")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "      </tr>"										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "QAction", "QActions", "Quality Actions"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='4'><font face='Verdana' size='2'><strong>"  
						
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Action - Num</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status [Date Due]</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Priority<br>Project</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("RefNum")) Then
									sList = sList & vbCrLf & "      <tr>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=QAction&Item=" & IIf(IsNull(rsList("RefType")), "NONE", rsList("RefType")) & ";" & IIf(IsNull(rsList("RefNum")), "NONE", rsList("RefNum")) & "'>" & IIf(IsNull(rsList("RefType")), "NONE", rsList("RefType")) & " - " & IIf(IsNull(rsList("RefNum")), "NONE", rsList("RefNum")) & "</a></font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Status")), "NONE", rsList("Status")) & IIf(IsNull(rsList("DateRequired")), "", " [" & rsList("DateRequired") & "]") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Priority")), "NONE", rsList("Priority")) & "<br>" & IIf(rsList("ProjNum") <> "", rsList("ProjNum") & " - " & IIf(rsList("ProjName") <> "", rsList("ProjName"), ""), "") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("IssueDesc")), "NO DESCRIPTION", rsList("IssueDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"
										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Task", "Tasks"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Task ID</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status<br>Priority<br>Project<br>Workgroup<br>Assigned</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong></strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Estimated</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Actual</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("TaskID")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../TaskManagement/TaskInformation.aspx?SID=" & Session("SI") & "&TID=" & rsList("TaskID") & "' target='_top'>" & rsList("TaskID") &  "</a></font></td>"
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Status")), "NONE", rsList("Status")) & "<br>" & IIf(IsNull(rsList("Priority")), "NONE", rsList("Priority")) & "<br>" & IIf(IsNull(rsList("Project")), "NONE", rsList("Project")) & "<br>" & IIf(IsNull(rsList("Workgroup")), "NONE", rsList("Workgroup")) & "<br>" & IIf(IsNull(rsList("ResourceName")), "NONE", rsList("ResourceName")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("TaskDesc")), "NO DESCRIPTION", rsList("TaskDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top' align='right'><font face='Verdana' size='2'>Start:<br>Finish:<br>Hours:</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("PlannedStart")), "-", rsList("PlannedStart")) & "<br>" & IIf(IsNull(rsList("PlannedFinish")), "-", rsList("PlannedFinish")) & "<br>" & IIf(IsNull(rsList("EstHours")), "0", rsList("EstHours")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ActualStart")), "-", rsList("ActualStart")) & "<br>" & IIf(IsNull(rsList("ActualFinish")), "-", rsList("ActualFinish")) & "<br>" & IIf(IsNull(rsList("ActualHours")), "0", rsList("ActualHours")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "      </tr>"										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If

				Case "Reports"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Report Name</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Report Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("ReportId")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../MyReports/MyReports.aspx?SID=" & Session("SI") & "&ReportID=" & rsList("ReportId") & "' target='_top'>" & rsList("Name") &  "</a></font></td>"
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ReportDesc")), "NO DESCRIPTION", rsList("ReportDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"	
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "ControlLists"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Control Code</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Control Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("OptCode")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OptCode")), "NO DESCRIPTION", rsList("OptCode")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OptDesc")), "NO DESCRIPTION", rsList("OptDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"	
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "ControlLists"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Control Code</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Control Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("OptCode")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OptCode")), "NO CODE", rsList("OptCode")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OptDesc")), "NO DESCRIPTION", rsList("OptDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"	
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Restrictions"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Restriction ID</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Restrictions Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Restrictions Text</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("RNotID")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RNotID")), "NO CODE", rsList("RNotID")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RNDesc")), "NO DESCRIPTION", rsList("RNDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RNText1")), "NO DESCRIPTION", rsList("RNText1")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"	
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Help"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Request No</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Request Type</strong></font></td>"
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Priority</strong></font></td>"
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Request By</strong></font></td>"
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Request Date</strong></font></td>"
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("RequestNo")) Then
									sList = sList & vbCrLf & "      <tr>" 	
									'sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RequestNo")), "NO Request No", rsList("RequestNo")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../ChangeManagement/HelpDesk.aspx?SID=" & Session("SI") & "&COID=" & rsList("RequestNo") & "' target='_top'>" & IIf(IsNull(rsList("RequestNo")), "NO Request No", rsList("RequestNo")) & "</a></font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Status")), "NO Status", rsList("Status")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RequestType")), "NO Request Type", rsList("RequestType")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Priority")), "NO Priority", rsList("Priority")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RequestBy")), "NO Request By", rsList("RequestBy")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RequestDate")), "NO Request Date", rsList("RequestDate")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"	
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
			End Select
		Else
			sList = "NO RECORDS RETURNED"
		End If '------ Not ((rsList.BOF = True) And (rsList.EOF = True))
	Else
		sList = "NO RECORDS RETURNED"
    End If '------ (sSQL <> "")
    
    
    
    If ((sList <> "") And (sList <> "NO RECORDS RETURNED")) Then
		If (nRecCount > 0) And (nPageSize > 0) Then
			If (nPage = 1) Then
				sPrev = "&lt;&lt;First&nbsp;&nbsp;&nbsp;&nbsp;"
				sPrev = sPrev & "&lt;Previous&nbsp;&nbsp;&nbsp;&nbsp;"
				If (nPage >= nPageCount) Then
					sNext = "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
					sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
				Else
					sNext = "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
					sNext = sNext & "&PS=" & CStr(nPgNext) & ":" & CStr(nPageSize)
					sNext = sNext & "'>Next&gt;</a>"
					sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
					sNext = sNext & "&PS=" & CStr(nPageCount) & ":" & CStr(nPageSize)
					sNext = sNext & "'>Last&gt;&gt;</a>"
				End If
			Else
				If (nPage > 1) Then
					sPrev = "<a href='ret_search.asp?" & SVars & sNewVars
					sPrev = sPrev & "&PS=1:" & CStr(nPageSize)
					sPrev = sPrev & "'>&lt;&lt;First</a>&nbsp;&nbsp;&nbsp;&nbsp;"
					sPrev = sPrev & "<a href='ret_search.asp?" & sNewVars
					sPrev = sPrev & "&PS=" & CStr(nPgPrev) & ":" & CStr(nPageSize)
					sPrev = sPrev & "'>&lt;Previous</a>&nbsp;&nbsp;&nbsp;&nbsp;"
					If (nPage >= nPageCount) Then
						sNext =  "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
						sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
					Else
						sNext = "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
						sNext = sNext & "&PS=" & CStr(nPgNext) & ":" & CStr(nPageSize)
						sNext = sNext & "'>Next&gt;</a>"
						sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
						sNext = sNext & "&PS=" & CStr(nPageCount) & ":" & CStr(nPageSize)
						sNext = sNext & "'>Last&gt;&gt;</a>"
					End If
				Else
					sPrev = "&lt;&lt;First&nbsp;&nbsp;&nbsp;&nbsp;"
					sPrev = sPrev & "&lt;Previous&nbsp;&nbsp;&nbsp;&nbsp;"
					sNext = "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
					sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
				End If '--- nPage > 1
			End If '--- nPage = 1
		Else
			sPrev = "&lt;&lt;First&nbsp;&nbsp;&nbsp;&nbsp;"
			sPrev = sPrev & "&lt;Previous&nbsp;&nbsp;&nbsp;&nbsp;"
			sNext = "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
			sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
		End If '--- nRecCount > 0) And (nPageSize > 0
	
		sFmtPos = sFmtHead
		sFmtPos = sFmtPos & sPgPos & "<br>"
		sFmtPos = sFmtPos & sPrev
		sFmtPos = sFmtPos & sPos
		sFmtPos = sFmtPos & sNext
		sFmtPos = sFmtPos & "</strong></font></td>"
		sFmtPos = sFmtPos & vbCrLf & "      </tr>"
		
		sListing = sListHead1
		sListing = sListing & vbCrLf & sFmtPos
		sListing = sListing & vbCrLf & sListHead2
		sListing = sListing & vbCrLf & sList
		sListing = sListing & vbCrLf & sFmtPos
		sListing = sListing & vbCrLf & "    </table>"
	Else
		sListing = "<p><font face='Verdana' size='4'>NO RECORDS RETURNED</font></p>" & vbCrLf
	End If '------- (sList <> "") And (sList <> "NO RECORDS RETURNED")) 
		
    Set rsList = Nothing    
    GetListing = sListing
End Function







Function GetListingForQuery(vList, vVal, vPagePos, sSQL)
    
    Dim sListing
    Dim sConst
    Dim rsList
    Dim nPage
    Dim nPageCount
    Dim nPageSize
    Dim sPgPos
    Dim nRecPos
    Dim nRecCount
    Dim sPrev
    Dim sPos
    Dim sNext
    Dim nPgPrev
    Dim nPgNext
    Dim sFmtPos
    Dim x
    Dim bPageEnd
    Dim nLastRec
    Dim sNewVars
    
    Dim sFmtHead
    Dim sListHead1
    Dim sListHead2
    Dim sList
    
    sList = ""
    
    If (vPagePos <> "") Then
		If (InStr(1, vPagePos, ":", 1) > 0) Then
			nPage = CLng(Left(vPagePos, InStr(1, vPagePos, ":", 1) - 1))
			nPageSize = CLng(Right(vPagePos, Len(vPagePos) - InStr(1, vPagePos, ":", 1)))
			
			If Not (nPageSize > 1) Then
				nPageSize = 50
			End If
			
			If (nPage > 1) Then
				nRecPos = ((nPage - 1) * nPageSize) + 1
			Else
				nPage = 1
				nRecPos = 1
			End If
		Else
			nPage = 1
			nRecPos = 1
			nPageSize = 50
		End If
	Else
		nPage = 1
		nRecPos = 1
		nPageSize = 50
    End If
    
    If Not (nPageSize > 1) Then
		nPageSize = 50
	End If
	If Not (nPage > 0) Then
		nPage = 1
	End If
	
	sNewVars = "Listing=" & vList & "&V=" & sConst
		  
    If (sSQL <> "") Then          		
		
		Set rsList = GetADORecordset(sSQL, Nothing)
		nRecCount = 0
		
		If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
			Do
				nRecCount = nRecCount + 1
				rsList.MoveNext
			Loop Until rsList.EOF
			
			rsList.MoveFirst
			If (nRecPos > nRecCount) Then
				nRecPos = nRecCount
			End If
			If (nRecPos > 1) Then
				'rsList.MoveNext
				If (nRecPos = nRecCount) Then
					rsList.MoveLast
				Else
					For x = 1 To nRecPos
						rsList.MoveNext
					Next
				End If
			End If
			            
			If (nRecCount > 0) Then
				If ((nRecCount / nPageSize) > CLng(nRecCount / nPageSize)) Then
					nPageCount = CLng(nRecCount / nPageSize) + 1
				Else
					nPageCount = CLng(nRecCount / nPageSize)
				End If
				If (nPageCount < 1) Then
					nPageCount = 1
				End If
				If (nPage > 1) Then
					If (nPage <= nPageCount) Then
						If (nRecPos > 0) Then
							nLastRec = nRecPos + (nPageSize - 1)
							If (nLastRec > nRecCount) Then
								nLastRec = nRecCount
							End If
							sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
						Else
							If (nPage >= nPageCount) Then
								nPage = nPageCount
							End If
							nLastRec = nRecPos + (nPageSize - 1)
							If (nLastRec > nRecCount) Then
								nLastRec = nRecCount
							End If
							nRecPos = ((nPage * nPageSize) + 1) - nPageSize
							sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
						End If
					Else
						nPage = nPageCount
						nLastRec = nRecPos + (nPageSize - 1)
						If (nLastRec > nRecCount) Then
							nLastRec = nRecCount
						End If
						nRecPos = ((nPage * nPageSize) + 1) - nPageSize
						sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
					End If
				Else
					nPage = 1
					nRecPos = 1
					nLastRec = nRecPos + (nPageSize - 1)
					If (nLastRec > nRecCount) Then
						nLastRec = nRecCount
					End If
					sPos = "Records " & nRecPos & " through " & nLastRec & " of " & nRecCount
				End If
			Else
				nPageCount = 1
				nPage = 1
				nRecPos = 0
				nRecCount = 0
				sPos = "Record 0 of 0"
			End If '---- nRecCount > 0
					
			sPgPos = "Page " & CStr(nPage) & " of " & CStr(nPageCount)
			nPgPrev = IIf(nPage <= 1, nPage, nPage - 1)
			nPgNext = IIf(nPage >= nPageCount, nPage, nPage + 1)
			x = 1
			bPageEnd = False
			
			Select Case vList
			    Case "Doc", "Docs", "Documents", "DocElement", "DocsElement", "DocumentsElement"
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						sFmtHead = "      <tr>" 
						sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='4'><font face='Verdana' size='2'><strong>"  
					
						'Set table headers
						'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
						sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
					
						sListHead2 = vbCrLf & "      <tr>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>DocID [Rev]</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Status [Rel Date]<br>Doc Type</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Description</strong></font></td>" 
						'sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' color='#FFFF00'><strong>Notes</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "      </tr>"
						
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("DocID")) Then
									Listing = "Doc" ' all "special doc types" (e.g. elements) handled the same from here on (for gui display)
									sList = IIf(sList <> "", sList, "") & vbCrLf & "      <tr>" 																		
									sList = sList & vbCrLf & "  <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=Doc&Item=" & rsList("DocID") & "'>" & rsList("DocID") & "</a>" & IIf(rsList("CurrentRev") <> "", " [" & rsList("CurrentRev") & "]", "") & "</font></td>" 																		
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Status")), "(NONE)", rsList("Status")) & IIf(IsNull(rsList("DocRelDate")), "", " [" & rsList("DocRelDate") & "]") & "<br>" & rsList("DType") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("DocDesc")), "(NO DESCRIPTION)", rsList("DocDesc")) & "</font></td>" 
									'sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("DocNotes")), "(NONE)", rsList("DocNotes")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"									
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							rsList.MoveNext
						Loop Until (rsList.EOF = True) Or (bPageEnd = True)
					End If
				Case "Change", "Changes", "Change Orders"
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						sFmtHead = "      <tr>" 
						sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='4'><font face='Verdana' size='2'><strong>"  
						
						'Set table headers
						'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
						sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
						sListHead2 = vbCrLf & "      <tr>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Change Num [Eff]</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status [Priority]<br>Justif [Ch Type]<br>Project</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
						'sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' color='#FFFF00'><strong>Notes</strong></font></td>" 
						sListHead2 = sListHead2 & vbCrLf & "      </tr>"
						
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("CO")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../ChangeManagement/ChangeOrders.aspx?SID=" & Session("SI") & "&COID=" & rsList("CO") & "' target='_top'>" & rsList("CO") & "</a>" & IIf(IsNull(rsList("ChEffDate")), "", " [" & rsList("ChEffDate") & "]") & "</font></td>"
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ChStatus")), "NONE", rsList("ChStatus")) & " [" & IIf(IsNull(rsList("ChPriority")), "NONE", rsList("ChPriority")) & "]<br>" 
									sList = sList & IIf(IsNull(rsList("ChJustification")), "NONE", rsList("ChJustification"))
									sList = sList & " [" & IIf(IsNull(rsList("ChangeType")), "NONE", rsList("ChangeType")) & "]<br>" 
									sList = sList & IIf(IsNull(rsList("ProjNum")), "NONE", rsList("ProjNum") & IIf(IsNull(rsList("ProjName")), "", " - " & rsList("ProjName"))) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ChangeDesc")), "(NO DESCRIPTION)", rsList("ChangeDesc")) & "</font></td>" 
									'sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("AddNotes")), "(NONE)", rsList("AddNotes")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"									
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							
							rsList.MoveNext
						Loop Until rsList.EOF
					End If					
				Case "Order", "Orders"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='3'><font face='Verdana' size='2'><strong>"  
					
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
					
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Order Type - Num</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status<br>Order Date - Est Finish</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Project<br>Customer</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
								
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("OrderID")) Then
									sList = sList & vbCrLf & "      <tr>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=Order&Item=" & CStr(rsList("OrderID")) & "'>" & IIf(IsNull(rsList("OrderType")), "NONE", rsList("OrderType")) & " - " & IIf(IsNull(rsList("OrderNum")), "(NONE)", rsList("OrderNum")) & "</a></font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OrderStatus")), "NONE", rsList("OrderStatus")) & "<br>" & IIf(IsNull(rsList("OrderDate")), "NONE", rsList("OrderDate")) & " - " & IIf(IsNull(rsList("PlannedEndDate")), "NONE", rsList("PlannedEndDate")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ProjNum")), "NONE", rsList("ProjNum") & IIf(IsNull(rsList("ProjName")), "", " - " & rsList("ProjName"))) & "<br>" & IIf(IsNull(rsList("VendCustID")), "NONE", rsList("VendCustID")) & IIf(IsNull(rsList("VCName")), "", " - " & rsList("VCName")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"
									
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Part", "Parts"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='3'><font face='Verdana' size='2'><strong>"  
					
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
					
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Part Num [Rev]</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Rev Type - Status<br>Doc ID</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records	
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("PartID")) Then
									sList = sList & vbCrLf & "      <tr>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=Part&Item=" & rsList("PartID") & "'>" & IIf(IsNull(rsList("PartNo")), "NONE", rsList("PartNo")) & "[" & IIf(IsNull(rsList("CurRev")), "NONE", rsList("CurRev")) & "]</a></font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("RType")), "NONE", rsList("RType")) & " - " & IIf(IsNull(rsList("RStatus")), "NONE", rsList("RStatus")) & "<br>" & IIf(IsNull(rsList("FileLink")), "", "<a href='" & rsList("FileLink") & "' target = '_blank'>") & IIf(IsNull(rsList("DocID")), "NONE", rsList("DocID")) & IIf(IsNull(rsList("FileLink")), "", "</a>") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("PartDesc")), "NO DESCRIPTION", rsList("PartDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"
										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Project", "Projects"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='5'><font face='Verdana' size='2'><strong>"  
						
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Project</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Status<br>Customer</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong> </strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>	</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2' ><strong>Actual</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
			        
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("ProjNum")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../ProjectManagement/ProjectInformation.aspx?SID=" & Session("SI") & "&PID=" & rsList("ProjNum") & "' target='_top'>" & rsList("ProjNum") & IIf(IsNull(rsList("ProjName")), "", " - " & rsList("ProjName")) &  "</a></font></td>"									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ProjStatus")), "NONE", rsList("ProjStatus")) & "<br>" & IIf(IsNull(rsList("VendCustID")), "NONE", rsList("VendCustID") & IIf(IsNull(rsList("VCName")), "", " - " & rsList("VCName"))) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top' align='right'><font face='Verdana' size='2'>Start:<br>Finish:<br>Hours:</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("PlannedStart")), "-", rsList("PlannedStart")) & "<br>" & IIf(IsNull(rsList("PlannedFinish")), "-", rsList("PlannedFinish")) & "<br>" & IIf(IsNull(rsList("BudgetLabor")), "0", rsList("BudgetLabor")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ActualStart")), "-", rsList("ActualStart")) & "<br>" & IIf(IsNull(rsList("ActualFinish")), "-", rsList("ActualFinish")) & "<br>" & IIf(IsNull(rsList("ActualLabor")), "0", rsList("ActualLabor")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "      </tr>"										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "QAction", "QActions", "Quality Actions"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='4'><font face='Verdana' size='2'><strong>"  
						
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Action - Num</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status [Date Due]</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Priority<br>Project</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("RefNum")) Then
									sList = sList & vbCrLf & "      <tr>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='ret_selitem.asp?Listing=QAction&Item=" & IIf(IsNull(rsList("RefType")), "NONE", rsList("RefType")) & ";" & IIf(IsNull(rsList("RefNum")), "NONE", rsList("RefNum")) & "'>" & IIf(IsNull(rsList("RefType")), "NONE", rsList("RefType")) & " - " & IIf(IsNull(rsList("RefNum")), "NONE", rsList("RefNum")) & "</a></font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Status")), "NONE", rsList("Status")) & IIf(IsNull(rsList("DateRequired")), "", " [" & rsList("DateRequired") & "]") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Priority")), "NONE", rsList("Priority")) & "<br>" & IIf(rsList("ProjNum") <> "", rsList("ProjNum") & " - " & IIf(rsList("ProjName") <> "", rsList("ProjName"), ""), "") & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("IssueDesc")), "NO DESCRIPTION", rsList("IssueDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"
										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "Task", "Tasks"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					'Set table headers
					'sListHead1 = "    <p>Constraints = " & sConst & "</p><div align='center'><center><table border='2' cellpadding='2' cellspacing='1' width='625'>"
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Task ID</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Status<br>Priority<br>Project<br>Workgroup<br>Assigned</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong></strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Estimated</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Actual</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("TaskID")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../TaskManagement/TaskInformation.aspx?SID=" & Session("SI") & "&TID=" & rsList("TaskID") & "' target='_top'>" & rsList("TaskID") &  "</a></font></td>"
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("Status")), "NONE", rsList("Status")) & "<br>" & IIf(IsNull(rsList("Priority")), "NONE", rsList("Priority")) & "<br>" & IIf(IsNull(rsList("Project")), "NONE", rsList("Project")) & "<br>" & IIf(IsNull(rsList("Workgroup")), "NONE", rsList("Workgroup")) & "<br>" & IIf(IsNull(rsList("ResourceName")), "NONE", rsList("ResourceName")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("TaskDesc")), "NO DESCRIPTION", rsList("TaskDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top' align='right'><font face='Verdana' size='2'>Start:<br>Finish:<br>Hours:</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("PlannedStart")), "-", rsList("PlannedStart")) & "<br>" & IIf(IsNull(rsList("PlannedFinish")), "-", rsList("PlannedFinish")) & "<br>" & IIf(IsNull(rsList("EstHours")), "0", rsList("EstHours")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ActualStart")), "-", rsList("ActualStart")) & "<br>" & IIf(IsNull(rsList("ActualFinish")), "-", rsList("ActualFinish")) & "<br>" & IIf(IsNull(rsList("ActualHours")), "0", rsList("ActualHours")) & " hrs.</font></td>" 
									sList = sList & vbCrLf & "      </tr>"										
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If

				Case "Reports"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Report Name</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Report Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("ReportId")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'><a href='../../MyReports/MyReports.aspx?SID=" & Session("SI") & "&ReportID=" & rsList("ReportId") & "' target='_top'>" & rsList("Name") &  "</a></font></td>"
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("ReportDesc")), "NO DESCRIPTION", rsList("ReportDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"	
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
				Case "ControlLists"
					sFmtHead = "      <tr>" 
					sFmtHead = sFmtHead & vbCrLf & "        <td align='center' colspan='6'><font face='Verdana' size='2'><strong>"  
						
					sListHead1 = "    <div align='center'><center><table class='dataTable-table'>"
						
					sListHead2 = vbCrLf & "      <tr>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Control Code</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "        <td bgcolor='#808000' valign='bottom'><font face='Verdana' size='2'><strong>Control Description</strong></font></td>" 
					sListHead2 = sListHead2 & vbCrLf & "      </tr>"
					
					If Not ((rsList.BOF = True) And (rsList.EOF = True)) Then
						'Set table records
						Do
							If (x <= nPageSize) Then
								If Not IsNull(rsList("OptCode")) Then
									sList = sList & vbCrLf & "      <tr>" 									
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OptCode")), "NO DESCRIPTION", rsList("OptCode")) & "</font></td>" 
									sList = sList & vbCrLf & "        <td valign='top'><font face='Verdana' size='2'>" & IIf(IsNull(rsList("OptDesc")), "NO DESCRIPTION", rsList("OptDesc")) & "</font></td>" 
									sList = sList & vbCrLf & "      </tr>"	
									x = x + 1
								End If
							Else
								bPageEnd = True
							End If
							    
							rsList.MoveNext
						Loop Until rsList.EOF
					End If
			End Select
		Else
			sList = "NO RECORDS RETURNED"
		End If '------ Not ((rsList.BOF = True) And (rsList.EOF = True))
	Else
		sList = "NO RECORDS RETURNED"
    End If '------ (sSQL <> "")
    
    
    
    If ((sList <> "") And (sList <> "NO RECORDS RETURNED")) Then
		If (nRecCount > 0) And (nPageSize > 0) Then
			If (nPage = 1) Then
				sPrev = "&lt;&lt;First&nbsp;&nbsp;&nbsp;&nbsp;"
				sPrev = sPrev & "&lt;Previous&nbsp;&nbsp;&nbsp;&nbsp;"
				If (nPage >= nPageCount) Then
					sNext = "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
					sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
				Else
					sNext = "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
					sNext = sNext & "&PS=" & CStr(nPgNext) & ":" & CStr(nPageSize)
					sNext = sNext & "'>Next&gt;</a>"
					sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
					sNext = sNext & "&PS=" & CStr(nPageCount) & ":" & CStr(nPageSize)
					sNext = sNext & "'>Last&gt;&gt;</a>"
				End If
			Else
				If (nPage > 1) Then
					sPrev = "<a href='ret_search.asp?" & SVars & sNewVars
					sPrev = sPrev & "&PS=1:" & CStr(nPageSize)
					sPrev = sPrev & "'>&lt;&lt;First</a>&nbsp;&nbsp;&nbsp;&nbsp;"
					sPrev = sPrev & "<a href='ret_search.asp?" & sNewVars
					sPrev = sPrev & "&PS=" & CStr(nPgPrev) & ":" & CStr(nPageSize)
					sPrev = sPrev & "'>&lt;Previous</a>&nbsp;&nbsp;&nbsp;&nbsp;"
					If (nPage >= nPageCount) Then
						sNext =  "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
						sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
					Else
						sNext = "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
						sNext = sNext & "&PS=" & CStr(nPgNext) & ":" & CStr(nPageSize)
						sNext = sNext & "'>Next&gt;</a>"
						sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;<a href='ret_search.asp?" & sNewVars
						sNext = sNext & "&PS=" & CStr(nPageCount) & ":" & CStr(nPageSize)
						sNext = sNext & "'>Last&gt;&gt;</a>"
					End If
				Else
					sPrev = "&lt;&lt;First&nbsp;&nbsp;&nbsp;&nbsp;"
					sPrev = sPrev & "&lt;Previous&nbsp;&nbsp;&nbsp;&nbsp;"
					sNext = "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
					sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
				End If '--- nPage > 1
			End If '--- nPage = 1
		Else
			sPrev = "&lt;&lt;First&nbsp;&nbsp;&nbsp;&nbsp;"
			sPrev = sPrev & "&lt;Previous&nbsp;&nbsp;&nbsp;&nbsp;"
			sNext = "&nbsp;&nbsp;&nbsp;&nbsp;Next&gt;"
			sNext = sNext & "&nbsp;&nbsp;&nbsp;&nbsp;Last&gt&gt;"
		End If '--- nRecCount > 0) And (nPageSize > 0
	
		sFmtPos = sFmtHead
		sFmtPos = sFmtPos & sPgPos & "<br>"
		sFmtPos = sFmtPos & sPrev
		sFmtPos = sFmtPos & sPos
		sFmtPos = sFmtPos & sNext
		sFmtPos = sFmtPos & "</strong></font></td>"
		sFmtPos = sFmtPos & vbCrLf & "      </tr>"
		
		sListing = sListHead1
		sListing = sListing & vbCrLf & sFmtPos
		sListing = sListing & vbCrLf & sListHead2
		sListing = sListing & vbCrLf & sList
		sListing = sListing & vbCrLf & sFmtPos
		sListing = sListing & vbCrLf & "    </table>"
	Else
		sListing = "<p><font face='Verdana' size='4'>NO RECORDS RETURNED</font></p>" & vbCrLf
	End If '------- (sList <> "") And (sList <> "NO RECORDS RETURNED")) 
		
    Set rsList = Nothing    
    GetListingForQuery = sListing
End Function






'Function GetFCab(sSelection, CN)
Function GetFCab(sSelection)
	Dim sRet
	Dim sRetList
	Dim sListStart
	Dim sListEnd
	Dim sCurPos
	Dim sPos
	Dim sPosKey
	Dim sPosFC
	Dim sNewFC
	Dim sDep
	Dim sSQL
	Dim aLevel
	Dim x, y, z
	Dim bLevelSet
	Dim vTemp
	
	Select Case sSelection
		Case "START"
			'Provide base selection list
			sRetList = "    <ul>" & vbCrLf
			sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=P'>PROJECTS</a></strong></font></li>" & vbCrLf
			sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=D'>DOCUMENTS</strong></font></li>" & vbCrLf
			sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=C'>CHANGE ORDERS</strong></font></li>" & vbCrLf
			sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=T'>TASKS</strong></font></li>" & vbCrLf
			sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=M'>MATERIAL DISPOSITIONS</strong></font></li>" & vbCrLf
			sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=Q'>QUALITY ACTIONS</strong></font></li>" & vbCrLf
			sRetList = sRetList & "    </ul>&nbsp;"
		Case Else
			'Evaluate selection and return appropriate listing
			'Open DB connection
			'If (CN Is Nothing) Then
			'	Set CN = GetConn()
			'End If
			
			'Initiate variables
			x = 0
			y = 1
			z = 0
			
			x = InStr(1, sSelection, ":", 1)
			If (x > 0) Then
				aLevel = Array(6)
				bLevelSet = False
				sPosFC = sSelection
				
				'Evaluate current selection (right to left)
				Do
					x = Len(sPosFC)
					Do
						If (x > 0) Then
							If (Mid(sPosFC, x, 1) = ":") Then
								sPosKey = Right(sPosFC, Len(sPosFC) - x)
								sNewFC = Left(sPosFC, x)
								bLevelSet = True
							Else
								x = x - 1
							End If
						Else
							sPosKey = sPosFC
							sNewFC = ""
							bLevelSet = True
						End If
					Loop Until bLevelSet
					
					sSQL = GetFCSQL(sPosFC, sPosKey)
					
					If (x > 0) Then
						'=============================================
						Response.Write "Key = " & sPosKey & "<br>"
						Response.Write "FC = " & sPosFC & "<br>"
						Response.Write "FC2 = " & sNewFC & "<br>"
						Response.Write "SQL = " & sSQL & "<br>"
						'=============================================
						'aLevel(y) = Array(sPosKey, sPosFC, sNewFC, sSQL)
						y = y + 1
					End If
					
					sPosFC = Left(sPosFC, x)
				Loop Until (x < 1)
			Else
				aLevel = Array(0)
				sPosFC = sSelection
				sPosKey = sPosFC
				sNewFC = ""
				sSQL = GetFCSQL(sPosFC, sPosKey)
				'=============================================
				Response.Write "Key = " & sPosKey & "<br>"
				Response.Write "FC = " & sPosFC & "<br>"
				Response.Write "FC2 = " & sNewFC & "<br>"
				Response.Write "SQL = " & sSQL & "<br>"
				'=============================================
				aLevel(0) = Array(sPosKey, sPosFC, sNewFC, sSQL)
			End If
			
			'Format return information
			'For z = UBound(aLevel) To LBound(aLevel)
			If IsArray(aLevel) Then
			z = UBound(aLevel)
			Do
				'=============================================
				'Response.Write "Key = " & IIf(aLevel(z)(0) <> "", aLevel(z)(0), "") & "<br>"
				'Response.Write "FC = " & IIf(aLevel(z)(1) <> "", aLevel(z)(1), "") & "<br>"
				'Response.Write "FC2 = " & IIf(aLevel(z)(2) <> "", aLevel(z)(2), "") & "<br>"
				'Response.Write "SQL = " & IIf(aLevel(z)(3) <> "", aLevel(z)(3), "") & "<br>"
				'=============================================
				If IsArray(aLevel(z)) Then
					If (aLevel(z)(3) <> "") Then		'[sSQL]
						'Create recordset listing
						sRetList = sRetList & "<p>Key = " & IIf(aLevel(z)(0) <> "", aLevel(z)(0), "") & "<br>" & vbCrLf
						sRetList = sRetList & "FC = " & IIf(aLevel(z)(1) <> "", aLevel(z)(1), "") & "<br>" & vbCrLf
						sRetList = sRetList & "FC2 = " & IIf(aLevel(z)(2) <> "", aLevel(z)(2), "") & "<br>" & vbCrLf
						sRetList = sRetList & "SQL = " & IIf(aLevel(z)(3) <> "", aLevel(z)(3), "") & "</p>" & vbCrLf
					Else
						'Create standard listing
						Select Case aLevel(z)(1)		'[sPosFC]
							Case "D"
								sRetList = sRetList & "    <ul>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=P'>PROJECTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=D'>DOCUMENTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <ul><li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=D:DREL'>Released</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=D:DNR'>Not Released</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><strong><font face='Verdana' size='2'><a href='view_fcab.asp?FC=D:DH'>Historical</a></font></strong></li>" & vbCrLf
								sRetList = sRetList & "          <li><strong><font face='Verdana' size='2'><a href='view_fcab.asp?FC=D:DDT'>Document Type</a></font></strong></li>" & vbCrLf
								sRetList = sRetList & "            </ul>" & vbCrLf
								sRetList = sRetList & "          </li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=C'>CHANGE ORDERS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=T'>TASKS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=M'>MATERIAL DISPOSITIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=Q'>QUALITY ACTIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "    </ul>&nbsp;"
							Case "C"
								sRetList = sRetList & "    <ul>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=P'>PROJECTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=D'>DOCUMENTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=C'>CHANGE ORDERS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <ul><li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=C:CREL'>Released</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=C:CNR'>Not Released</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><strong><font face='Verdana' size='2'><a href='view_fcab.asp?FC=C:CCT'>Change Type</a></font></strong></li>" & vbCrLf
								sRetList = sRetList & "            </ul>" & vbCrLf
								sRetList = sRetList & "          </li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=T'>TASKS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=M'>MATERIAL DISPOSITIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=Q'>QUALITY ACTIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "    </ul>&nbsp;"
							Case "T"
								sRetList = sRetList & "    <ul>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=P'>PROJECTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=D'>DOCUMENTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=C'>CHANGE ORDERS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=T'>TASKS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <ul><li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=T:TOPEN'>Open</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=T:TNO'>Not Open</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><strong><font face='Verdana' size='2'><a href='view_fcab.asp?FC=T:TTT'>Standard Task Type</a></font></strong></li>" & vbCrLf
								sRetList = sRetList & "            </ul>" & vbCrLf
								sRetList = sRetList & "          </li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=M'>MATERIAL DISPOSITIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=Q'>QUALITY ACTIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "    </ul>&nbsp;"
							Case "M"
								sRetList = sRetList & "    <ul>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=P'>PROJECTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=D'>DOCUMENTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=C'>CHANGE ORDERS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=T'>TASKS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=M'>MATERIAL DISPOSITIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <ul><li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=M:MOPEN'>Open</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=M:MNO'>Not Open</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><strong><font face='Verdana' size='2'><a href='view_fcab.asp?FC=M:MDT'>Disposition Type</a></font></strong></li>" & vbCrLf
								sRetList = sRetList & "            </ul>" & vbCrLf
								sRetList = sRetList & "          </li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=Q'>QUALITY ACTIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "    </ul>&nbsp;"
							Case "Q"
								sRetList = sRetList & "    <ul>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=P'>PROJECTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=D'>DOCUMENTS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=C'>CHANGE ORDERS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=T'>TASKS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=M'>MATERIAL DISPOSITIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=Q'>QUALITY ACTIONS</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <ul><li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=Q:QS'>Action Status</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><font face='Verdana' size='2'><strong><a href='view_fcab.asp?FC=Q:QREJ'>Rejected</a></strong></font></li>" & vbCrLf
								sRetList = sRetList & "          <li><strong><font face='Verdana' size='2'><a href='view_fcab.asp?FC=Q:QAT'>Action Type</a></font></strong></li>" & vbCrLf
								sRetList = sRetList & "            </ul>" & vbCrLf
								sRetList = sRetList & "          </li>" & vbCrLf
								sRetList = sRetList & "    </ul>&nbsp;"
							Case Else
								'Project listing
								sRetList = sRetList & "<p>Key = " & IIf(aLevel(z)(0) <> "", aLevel(z)(0), "") & "<br>" & vbCrLf
								sRetList = sRetList & "FC = " & IIf(aLevel(z)(1) <> "", aLevel(z)(1), "") & "<br>" & vbCrLf
								sRetList = sRetList & "FC2 = " & IIf(aLevel(z)(2) <> "", aLevel(z)(2), "") & "<br>" & vbCrLf
								sRetList = sRetList & "SQL = " & IIf(aLevel(z)(3) <> "", aLevel(z)(3), "") & "</p>" & vbCrLf
						End Select
					End If
				'Else
				'	sRetList = sRetList & "<p>Key = " & IIf(aLevel(z)(0) <> "", aLevel(z)(0), "") & "<br>" & vbCrLf
				'	sRetList = sRetList & "FC = " & IIf(aLevel(z)(1) <> "", aLevel(z)(1), "") & "<br>" & vbCrLf
				'	sRetList = sRetList & "FC2 = " & IIf(aLevel(z)(2) <> "", aLevel(z)(2), "") & "<br>" & vbCrLf
				'	sRetList = sRetList & "SQL = " & IIf(aLevel(z)(3) <> "", aLevel(z)(3), "") & "</p>" & vbCrLf
				End If
				
				'sRetList = sListStart & sRetList & sListEnd
			'Next
				z = z - 1
			Loop Until (z < 1)
			End If
	End Select
	
	sCurPos = "<a href='view_fcab.asp?FC=" & sPosFC & "'>" & [Desc] & "</a>" & vbCrLf & sCurPos
	
	sRet = sRet & "    <strong><font face='Verdana' size='2'>Current Position: " & vbCrLf & sCurPos
	sRet = sRet & "    <hr noshade color='#808000'>" & vbCrLf
	sRet = sRet & sRetList
	'sRet = sRet & "    <hr noshade color='#808000'>" & vbCrLf
	
	'sRet = sRet & "    <ul>" & vbCrLf
	'sRet = sRet & "      <li><font face='Verdana'><strong><a href='view_fcab.asp?FC=P'>PROJECTS</a></strong></font><ul>" & vbCrLf
	'sRet = sRet & "          <li><font face='Verdana' size='2'><a href='view_fcab.asp?FC=P:ACT'>ACT - ACTIVE</a></font><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>Project <strong>[INFO]</strong></font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><strong><font face='Verdana' size='2'>Documents</font></strong><ul>" & vbCrLf
	'sRet = sRet & "                      <li><font face='Verdana' size='2'>[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                    </ul>" & vbCrLf
	'sRet = sRet & "                  </li>" & vbCrLf
	'sRet = sRet & "                  <li><strong><font face='Verdana' size='2'>Change Orders</font></strong><ul>" & vbCrLf
	'sRet = sRet & "                      <li><font face='Verdana' size='2'>[CO] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                    </ul>" & vbCrLf
	'sRet = sRet & "                  </li>" & vbCrLf
	'sRet = sRet & "                  <li><strong><font face='Verdana' size='2'>Tasks</font></strong><ul>" & vbCrLf
	'sRet = sRet & "                      <li><font face='Verdana' size='2'>[TaskID] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                    </ul>" & vbCrLf
	'sRet = sRet & "                  </li>" & vbCrLf
	'sRet = sRet & "                  <li><strong><font face='Verdana' size='2'>Material Dispositions</font></strong><ul>" & vbCrLf
	'sRet = sRet & "                      <li><font face='Verdana' size='2'>[MDispID] - Desc... [INFO]</font></li>" & vbCrLf
	'sRet = sRet & "                    </ul>" & vbCrLf
	'sRet = sRet & "                  </li>" & vbCrLf
	'sRet = sRet & "                  <li><strong><font face='Verdana' size='2'>Quality Actions</font></strong><ul>" & vbCrLf
	'sRet = sRet & "                      <li><font face='Verdana' size='2'>[ActionType] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                        <li><font face='Verdana' size='2'>[RefNum] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                        </ul>" & vbCrLf
	'sRet = sRet & "                      </li>" & vbCrLf
	'sRet = sRet & "                    </ul>" & vbCrLf
	'sRet = sRet & "                  </li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "        </ul>" & vbCrLf
	'sRet = sRet & "      </li>" & vbCrLf
	'sRet = sRet & "      <li><font face='Verdana'><strong>DOCUMENTS</strong></font><ul>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Released</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><font face='Verdana' size='2'><strong>Not Released</strong></font><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[DocStatus] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Document Type</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[DocType] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[DocID] - Desc... <strong>[INFO]</strong> <strong>[VIEW]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "        </ul>" & vbCrLf
	'sRet = sRet & "      </li>" & vbCrLf
	'sRet = sRet & "      <li><font face='Verdana'><strong>CHANGE ORDERS</strong></font><ul>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Released</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[CO] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Not Released</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[ChStatus] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[CO] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Change Type</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[ChType] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[CO] - Desc... [INFO]</font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "        </ul>" & vbCrLf
	'sRet = sRet & "      </li>" & vbCrLf
	'sRet = sRet & "      <li><font face='Verdana'><strong>TASKS</strong></font><ul>" & vbCrLf
	'sRet = sRet & "          <li><font face='Verdana' size='2'><strong>Open</strong></font><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[TaskID] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><font face='Verdana' size='2'><strong>Not Open</strong></font><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[TaskStatus] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[TaskID] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Task Type</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[TaskType] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[TaskID] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "        </ul>" & vbCrLf
	'sRet = sRet & "      </li>" & vbCrLf
	'sRet = sRet & "      <li><font face='Verdana'><strong>MATERIAL DISPOSITIONS</strong></font><ul>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Open</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[MDispID] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Not Open</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[DispStatus] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[MDispID] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Disposition Type</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[DispType] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[MDispID] - Desc... [INFO]</font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "        </ul>" & vbCrLf
	'sRet = sRet & "      </li>" & vbCrLf
	'sRet = sRet & "      <li><font face='Verdana'><strong>QUALITY ACTIONS</strong></font><ul>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Open</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[ActionType][RefNum] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>Not Open</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[ActionStatus] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[ActionType][RefNum] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "          <li><strong><font face='Verdana' size='2'>ActionType</font></strong><ul>" & vbCrLf
	'sRet = sRet & "              <li><font face='Verdana' size='2'>[ActionType] - Desc.</font><ul>" & vbCrLf
	'sRet = sRet & "                  <li><font face='Verdana' size='2'>[RefNum] - Desc... <strong>[INFO]</strong></font></li>" & vbCrLf
	'sRet = sRet & "                </ul>" & vbCrLf
	'sRet = sRet & "              </li>" & vbCrLf
	'sRet = sRet & "            </ul>" & vbCrLf
	'sRet = sRet & "          </li>" & vbCrLf
	'sRet = sRet & "        </ul>" & vbCrLf
	'sRet = sRet & "      </li>" & vbCrLf
	'sRet = sRet & "    </ul>&nbsp;"
	
	GetFCab = sRet
End Function

Function GetPosDesc(sFC)
	Dim sDesc
	
	Select Case sFC
		Case "P"
			sDesc = "Projects"
		Case "P:ACT"
			sDesc = "Active"
		Case "D"
			sDesc = "Documents"
		Case "C"
			sDesc = "Change Orders"
		Case "T"
			sDesc = "Tasks"
		Case "M"
			sDesc = "Material Dispositions"
		Case "Q"
			sDesc = "Quality Actions"
		Case Else
			sDesc = ""
	End Select
	
	GetPosDesc = sDesc
End Function

Function GetFCSQL(sFC, sKey)
	Dim sRetSQL
	Dim sEval
	
	sRetSQL = ""
	
	sEval = sFC
	If (Left(sEval, 5) = "D:DH:") Or (Left(sEval, 5) = "Q:QS:") Then
		sEval = Left(sEval, 5) & "X"
	End If
	If (Left(sEval, 6) = "D:DNR:") Or (Left(sEval, 6) = "D:DDT:") Or (Left(sEval, 6) = "C:CNR:") Or (Left(sEval, 6) = "C:CCT:") Then
		sEval = Left(sEval, 6) & "X"
	End If
	If (Left(sEval, 6) = "T:TNO:") Or (Left(sEval, 6) = "T:TTT:") Or (Left(sEval, 6) = "M:MNO:") Or (Left(sEval, 6) = "M:MDT:") Or (Left(sEval, 6) = "Q:QAT:") Then
		sEval = Left(sEval, 6) & "X"
	End If
	
	Select Case sEval
		Case "P"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'ProjStatus')"
		'Case ""
		'	If (sKey <> "") Then
		'		sRetSQL = "SELECT * FROM ViewProjects WHERE (ProjStatus = '" & sKey & "')"
		'	End If
		'Case ""
		'	If (sKey <> "") Then
		'		sRetSQL = "SELECT * FROM ViewDocs WHERE (CurProj = '" & [ProjNum] & "')"
		'		sRetSQL = "SELECT * FROM ViewChanges WHERE (ProjNum = '" & [ProjNum] & "')"
		'		sRetSQL = "SELECT * FROM ViewTasks WHERE (ProjNum = '" & [ProjNum] & "')"
		'		sRetSQL = "SELECT * FROM ViewMatDisp WHERE (ProjNum = '" & [ProjNum] & "')"
		'		sRetSQL = "SELECT * FROM ViewActions WHERE (ProjNum = '" & [ProjNum] & "')"
		'	End If
		Case D:DNR""
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'DocStatus') AND (OptCode <> 'REL') AND (OptCode <> 'ARC') AND (OptCode <> 'OBS')"
		Case D:DH""
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'DocStatus') AND ((OptCode = 'ARC') OR (OptCode = 'OBS'))"
		Case "D:DDT"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'DocType')"
		Case "D:DREL"
			sRetSQL = "SELECT * FROM ViewDocs WHERE (DocStatus = 'REL')"
		Case "D:DNR:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewDocs WHERE (DocStatus = '" & sKey & "')"
			End If
		Case "D:DH:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewDocs WHERE (DocStatus = '" & sKey & "')"
			End If
		Case "D:DDT:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewDocs WHERE (DocType = '" & sKey & "')"
			End If
		Case "C:CNR"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'ChStatus') AND (OptCode <> 'REL')"
		Case "C:CCT"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'ChangeType')"
		Case "C:CREL"
			sRetSQL = "SELECT * FROM ViewChanges WHERE (ChStatus = 'REL')"
		Case "C:CNR:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewChanges WHERE (ChStatus = '" & sKey & "')"
			End If
		Case "C:CCT:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewChanges WHERE (ChangeType = '" & sKey & "')"
			End If
		Case "T:TNO"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'TaskStatus') AND (OptCode <> 'OPEN')"
		Case "T:TTT"
			sRetSQL = "SELECT StdTaskID, TaskDesc FROM StdTasks"
		Case "T:TOPEN"
			sRetSQL = "SELECT * FROM ViewTasks WHERE (TaskStatus = 'OPEN')"
		Case "T:TNO:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewTasks WHERE (TaskStatus = '" & sKey & "')"
			End If
		Case "T:TTT:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewTasks WHERE (StdTaskID = '" & sKey & "')"
			End If
		Case "M:MNO"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'DispStatus') AND (OptCode <> 'OPEN')"
		Case "M:MDT"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'DispositionType')"
		Case "M:MOPEN"
			sRetSQL = "SELECT * FROM ViewMatDisp WHERE (DispStatus = 'OPEN')"
		Case "M:MNO:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewMatDisp WHERE (DispStatus = '" & sKey & "')"
			End If
		Case "M:MDT:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewMatDisp WHERE (DispositionType = '" & sKey & "')"
			End If
		Case "Q:QS"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'ChStatus') AND (OptCode <> 'REJ')"
		Case "Q:QAT"
			sRetSQL = "SELECT OptCode, OptDesc FROM StdOptions WHERE (OptType = 'AType')"
		Case "Q:QREJ"
			sRetSQL = "SELECT * FROM ViewActions WHERE (AStatus = 'REJ')"
		Case "Q:QS:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewActions WHERE (AStatus = '" & sKey & "')"
			End If
		Case "Q:QAT:X"
			If (sKey <> "") Then
				sRetSQL = "SELECT * FROM ViewActions WHERE (AType = '" & sKey & "')"
			End If
		Case Else
			sRetSQL = ""
	End Select
	
	GetFCSQL = sRetSQL
End Function

Function SaveMyReports(nProfileId, sName, sDesc, sCategory, sQuery,UserID)
	
	Dim sCMD		
	sCMD = "INSERT INTO MyReports(ProfileID, ReportName, ReportDesc, Category, Query, Empid ) " &_
	       "VALUES (" & nProfileId & ",'" & sName & "','" &  sDesc & "','" & sCategory & "','" &  Replace(sQuery, "'", "''")  & "'," & UserID & ")"
	
	RunSQLCmd sCMD, Nothing
	SaveMyReports = nProfileId

End Function

'++++++++++++++++++++++++++++++++++++++++++++++++++++
'						REPLACEABLE CODE SNIPETS
'++++++++++++++++++++++++++++++++++++++++++++++++++++
Sub XCodeRep()

End Sub

%>
