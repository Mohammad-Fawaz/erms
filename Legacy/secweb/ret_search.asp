<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
    <%

Dim sItem
Dim nPgSz
Dim sL, sA, sV, sR
Dim bPageChange
Dim sRetText
Dim i, x
Dim sID, sName, sDesc
Dim MyReportID


MyReportID = Request.QueryString("RepID")

bPageChange = False
		    
If (Request.Form.Count > 0) Then
	If (Request.Form("PageSize") <> "") Then
		nPgSz = "1:" & Request.Form("PageSize")
	Else
		If (Request.QueryString("PS") <> "") Then
			nPgSz = Request.QueryString("PS")
		End If
	End If
	If (Request.Form("A") <> "") Then
		sA = Request.Form("A")
	End If
	If (Request.Form("R") <> "") Then
		sR = Request.Form("R")
	End If
	If (Request.Form("SearchBase") <> "") Then
		sL = Request.Form("SearchBase")
		sV = ""
	Else
		If (Request.QueryString("Listing") <> "") Then
			sL = Request.QueryString("Listing")
			sV = IIf(Request.QueryString("V") <> "", Request.QueryString("V"), "")
		End If
	End If
Else
	sL = Request.QueryString("Listing")
	sV = IIf(Request.QueryString("V") <> "", Request.QueryString("V"), "")
	If (Request.QueryString("PS") <> "") Then
		nPgSz = Request.QueryString("PS")
		bPageChange = True
	Else
		If (Request.Form("PageSize") <> "") Then
			nPgSz = Request.Form("PageSize")
		End If
	End If
	sA = "Search"
End If

If (InStr(1, sV, Chr(37), 1) > 0) Then sV = Replace(CStr(sV), Chr(37), "*", 1, -1, 1)
If (InStr(1, sV, "#", 1) > 0) Then sV = Replace(sConst, "#", "@", 1, -1, 1)
If (InStr(1, sV, "'", 1) > 0) Then sV = Replace(sConst, "'", "||", 1, -1, 1)

If (nPgSz = "") Then
	nPgSz = "1:50"
End If

If bPageChange Then
    If MyReportID > 0 Then
     'Get SQL 
     sSQL = "SELECT Category, Query FROM MyReports WHERE ReportID = " & MyReportID
     Set QuerySQL = GetADORecordset(sSQL, Nothing)
     ReportCategory = QuerySQL("Category")
     ReportQuery = QuerySQL("Query")
     'call 
     sRetText = GetListingForQuery(ReportCategory, "", vPagePos, ReportQuery)     
    Else
	 sRetText = GetListing(sL, CStr(sV), CStr(nPgSz))
	End If 
Else
	Select Case sA
		Case "Search"	   
			For i = 1 To 6
				If ((Request.Form("F" & i) <> "Select Field") And (Request.Form("F" & i) <> "")) Then
					If (sItem <> "") Then
						sItem = sItem & IIf(Request.Form("QMode" & i) = "OR", " OR ", " AND ") & GetConstraint(Request.Form("F" & i), Request.Form("M" & i), Request.Form("V" & i))
					Else
						sItem = GetConstraint(Request.Form("F" & i), Request.Form("M" & i), Request.Form("V" & i))
					End If			
				End If
			Next			 
			
			'Response.Write "sItem=" & sItem & "<br>"
						 
             Session("ReportName") = ""
		     Session("ReportDesc") = ""
		     Session("SaveReport") = "false"
            If sR = "Save" And Request.Form("txtRName") <> "" Then		     
		     sName = Request.Form("txtRName")
		     sDesc = Request.Form("txtRDesc")	
		     Session("ReportName") = sName
		     Session("ReportDesc") = sDesc
		     Session("SaveReport") = "true"
	        End If
			
			If MyReportID > 0 Then
                'Get SQL 
                sSQL = "SELECT Category, Query FROM MyReports WHERE ReportID = " & MyReportID
                Set QuerySQL = GetADORecordset(sSQL, Nothing)
                ReportCategory = QuerySQL("Category")
                ReportQuery = QuerySQL("Query")
                'call 
                sRetText = GetListingForQuery(ReportCategory, "", vPagePos, ReportQuery)
            Else
                'sRetText = GetHTML("Search", Request.Form("SearchBase"), CStr(sItem))
			    sRetText = GetListing(sL, CStr(sItem), CStr(nPgSz))
			End If			
		Case "QSearch"
			If (Request.Form("V") <> "") Then
				Select Case sL
					'Case "Change Orders": sItem = "(Left(CO, " & Len(Request.Form("V")) & ") = " & Request.Form("V") & ")"
                    Case "Change Orders": sItem = "(CO LIKE ||" & CStr(Request.Form("V")) & "*||)"
					Case "Documents": sItem = "(DocID LIKE ||" & CStr(Request.Form("V")) & "*||)"
					Case "Orders": sItem = "(OrderNum LIKE ||" & CStr(Request.Form("V")) & "*||)"
					Case "Parts": sItem = "(PartNo LIKE ||" & CStr(Request.Form("V")) & "*||)"
					Case "Projects": sItem = "(ProjNum LIKE ||" & CStr(Request.Form("V")) & "*||)"
					'Case "Quality Actions"
					'Case "Tasks": sItem = "(Left(TaskID, " & Len(Request.Form("V")) & ") = " & Request.Form("V") & ")"
                    Case "Tasks": sItem = "(TaskID LIKE ||" & CStr(Request.Form("V")) & "*||)"
                    Case "Help": sItem = "(RequestNo LIKE ||" & CStr(Request.Form("V")) & "*||)"
					Case "Reports": sItem = "(Left(ReportID, " & Len(Request.Form("V")) & ") = " & Request.Form("V") & ")"
                    Case "ControlLists": sItem = "(OptCode LIKE ||" & CStr(Request.Form("V")) & "*||)"
                    Case "Restrictions": sItem = "(RNotID LIKE ||" & CStr(Request.Form("V")) & "*||)"
					Case "DocElement":
						If (Request.Form("B1") = "Submit") Then ' Search by DocID
							'sV = "(DocID LIKE '" & Request.Form("DocID1") & "-" & Request.Form("DocID2") & "*')"
							Response.Redirect("ret_selitem.asp?Listing=Doc&Item=" & Request.Form("DocID1") & "-" & Request.Form("DocID2"))
						ElseIf (Request.Form("B3") = "Submit") Then ' Complex Search
							If (Request.Form("Description") <> "") Then
								sV2 = sV2 & "(DocDesc LIKE '*" & Request.Form("Description") & "*') " & Request.Form("SearchOperator") & " "
							End If
							If (Request.Form("Thickness") <> "") Then
								RangePlus = IIf(Request.Form("RangePlus") <> "", Request.Form("RangePlus"), 0)
								RangeMinus = IIf(Request.Form("RangeMinus") <> "", Request.Form("RangeMinus"), 0)
								sV2 = sV2 & "("
								sV2 = sV2 & "(CDbl(Par5) >= " & Request.Form("Thickness") & " AND CDbl(Par5) - " & Request.Form("Thickness") & " <= " & RangePlus & ") OR "
								sV2 = sV2 & "(" & Request.Form("Thickness") & " >= CDbl(Par5) AND " & Request.Form("Thickness") & " - CDbl(Par5) <= " & RangeMinus & ")"
								sV2 = sV2 & ") " & Request.Form("SearchOperator") & " "
							End If
							If (Request.Form("ElementWidth") <> "") Then
								sV2 = sV2 & "(NOT IsNull(Par1) AND NOT IsNull(Par2) AND Abs(CDbl(Par1) - " & Request.Form("ElementWidth") & ") <= CDbl(Par2)) " & Request.Form("SearchOperator") & " "
							End If
							If (Request.Form("ElementLength") <> "") Then
								sV2 = sV2 & "(NOT IsNull(Par3) AND NOT IsNull(Par4) AND Abs(CDbl(Par3) - " & Request.Form("ElementLength") & ") <= CDbl(Par4)) " & Request.Form("SearchOperator") & " "
							End If

							If (sV2 <> "") Then
								sV2 = " AND (" & Left(sV2, Len(sV2) - Len(Request.Form("SearchOperator")) - 2) & ")"
							End If
							If (Request.Form("Wafer") = "1" And Not Request.Form("Element") = "1") Then ' Wafer Only
								sV = "(NOT IsNull(PartID) AND DocType = '484') " & sV2
							ElseIf (Request.Form("Element") = "1" And Not Request.Form("Wafer") = "1") Then ' Element Only
								sV = "(NOT IsNull(PartID) AND (DocType='485' OR DocType='486')) " & sV2
							Else ' Both - elements or wafer, but make sure to get documents with at least one part
								sV = "(NOT IsNull(PartID)) " & sV2
							End If
						ElseIf (Request.Form("B2") = "Submit") Then ' Selected from list
							Response.Redirect("ret_selitem.asp?Listing=Doc&Item=" & Request.Form("DocID"))
						End If
						sItem = sV
				End Select
			Else
				sItem = ""
			End If
			sRetText = GetListing(sL, CStr(sItem), CStr(nPgSz))
		Case "Set"
			Select Case sL
				Case "Change Orders"
					sItem = "SearchChanges"
                Case "ControlLists"
					sItem = "SearchControlLists"
				Case "Documents"
					sItem = "SearchDocs"
				Case "Orders"
					sItem = "SearchOrders"
				Case "Parts"
					sItem = "SearchParts"
				Case "Projects"
					sItem = "SearchProjects"
				Case "Quality Actions"
					sItem = "SearchActions"
                Case "Reports"
					sItem = "SearchReports"
                Case "Restrictions"
					sItem = "SearchRestrictions"
				Case "Tasks"
					sItem = "SearchTasks"
				
			End Select

	End Select
		
End If
    %>

    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>System Search</title>

    <script type="text/javascript">
        function isNotEmpty(textField) {
            var blnStatus = true;
            if (textField != null && trim(textField.value).length == 0) {
                blnStatus = false;
            }

            return blnStatus;
        }

        function trim(strvalue) {
            var str = strvalue;
            while (str.substring(0, 1) == ' ') {
                str = str.substring(1, str.length);
            }
            while (str.substring(str.length - 1, str.length) == ' ') {
                str = str.substring(0, str.length - 1);
            }

            return str;
        }

        function fnValidateReport(form) {
            var status = true;
            if (form != null) {
                if (form.txtRName != null && form.txtRName != undefined && !isNotEmpty(form.txtRName)) {
                    alert("Please enter the Report Name");
                    status = false;
                    form.txtRName.focus();
                }
                else if (form.txtRDesc != null && form.txtRDesc != undefined && !isNotEmpty(form.txtRDesc)) {
                    alert("Please enter the Report Description");
                    status = false;
                    form.txtRDesc.focus();
                }
                else if (form.F1 != null && form.F1[form.F1.selectedIndex].value == "Select Field") {
                    alert("Please choose the Search Field");
                    status = false;
                    form.F1.focus();
                }
                else if (form.V1 != null && form.V1 != undefined && !isNotEmpty(form.V1)) {
                    alert("Please enter the Search Value");
                    status = false;
                    form.V1.focus();
                }
            }

            return status;
        }
    </script>

</head>

<body>


    <div id="layoutSidenav_content">
        <main>
            <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                <div class="container-xl px-4">
                    <div class="page-header-content">
                        <div class="row align-items-center justify-content-between pt-3">
                            <div class="col-auto mb-3">
                                <h1 class="page-header-title">
                                    <div class="page-header-icon"><i data-feather="user"></i></div>
                                    System Search
                                </h1>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <!-- Main page content-->
            <div class="container-xl px-4 mt-4">
                <div class="row">
                    <div class="col-xl-12">
                        <!-- System Search Tools card-->
                        <div class="card mb-4">
                            <div class="card-header">
                                Search For : [<% =ReportCategory %>]
                            </div>
                            <div class="card-body">
                                <table class="table table-responsive">
                                    <tr>
                                        <td width="100%" colspan="2">
                                            <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--<td width="145" valign="top" bgcolor="#FFFFC8"><%' =sMenu %></td>-->
                                        <td width="635" valign="top">

                                            <%
                                                    
Select Case sA
	Case "Search", "QSearch"
		Response.Write sRetText	
	Case "Set"
                                            %>

                                            <form method="POST" action="ret_search.asp">
                                                <input type="hidden" name="R" value="Save">
                                                <input type="hidden" name="A" value="Search">
                                                <input type="hidden" name="SearchBase" value="<% =sL %>">
                                                <div>
                                                    <table class="table table-responsive table-borderless">
                                                        <tr>
                                                            <td valign="top" align="right">Where...</td>
                                                            <td valign="top">
                                                                <select class="form-select" name="F1" size="1">
                                                                    <option selected value="Select Field">Select Field</option>
                                                                    <% =GetSelect(sItem, "") %>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="M1" size="1">
                                                                    <option selected value="E">[=]EQUAL TO</option>
                                                                    <option value="LT">[<]less THAN</option>
                                                                    <option value="GT">[&gt;]MORE THAN</option>
                                                                    <option value="N">[<>]NOT</option>
                                                                    <option value="L">LIKE(*)</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <input type="text" class="form-control" name="V1" size="30"></td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" align="right">
                                                                <select class="form-select" name="QMode2" size="1">
                                                                    <option selected value="AND">AND</option>
                                                                    <option value="OR">OR</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="F2" size="1">
                                                                    <option selected value="Select Field">Select Field</option>
                                                                    <% =GetSelect(sItem, "") %>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="M2" size="1">
                                                                    <option selected value="E">[=]EQUAL TO</option>
                                                                    <option value="LT">[<]less THAN</option>
                                                                    <option value="GT">[&gt;]MORE THAN</option>
                                                                    <option value="N">[<>]NOT</option>
                                                                    <option value="L">LIKE(*)</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <input type="text" class="form-control" name="V2" size="30"></td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" align="right">
                                                                <select class="form-select" name="QMode3" size="1">
                                                                    <option selected value="AND">AND</option>
                                                                    <option value="OR">OR</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="F3" size="1">
                                                                    <option selected value="Select Field">Select Field</option>
                                                                    <% =GetSelect(sItem, "") %>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="M3" size="1">
                                                                    <option selected value="E">[=]EQUAL TO</option>
                                                                    <option value="LT">[<]less THAN</option>
                                                                    <option value="GT">[&gt;]MORE THAN</option>
                                                                    <option value="N">[<>]NOT</option>
                                                                    <option value="L">LIKE(*)</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <input type="text" class="form-control" name="V3" size="30"></td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" align="right">
                                                                <select class="form-select" name="QMode4" size="1">
                                                                    <option selected value="AND">AND</option>
                                                                    <option value="OR">OR</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="F4" size="1">
                                                                    <option selected value="Select Field">Select Field</option>
                                                                    <% =GetSelect(sItem, "") %>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="M4" size="1">
                                                                    <option selected value="E">[=]EQUAL TO</option>
                                                                    <option value="LT">[<]less THAN</option>
                                                                    <option value="GT">[&gt;]MORE THAN</option>
                                                                    <option value="N">[<>]NOT</option>
                                                                    <option value="L">LIKE(*)</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <input type="text" class="form-control" name="V4" size="30"></td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" align="right">
                                                                <select class="form-select" name="QMode5" size="1">
                                                                    <option selected value="AND">AND</option>
                                                                    <option value="OR">OR</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="F5" size="1">
                                                                    <option selected value="Select Field">Select Field</option>
                                                                    <% =GetSelect(sItem, "") %>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="M5" size="1">
                                                                    <option selected value="E">[=]EQUAL TO</option>
                                                                    <option value="LT">[<]less THAN</option>
                                                                    <option value="GT">[&gt;]MORE THAN</option>
                                                                    <option value="N">[<>]NOT</option>
                                                                    <option value="L">LIKE(*)</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <input type="text" class="form-control" name="V5" size="30"></td>
                                                        </tr>
                                                        <tr>
                                                            <td valign="top" align="right">
                                                                <select class="form-select" name="QMode6" size="1">
                                                                    <option selected value="AND">AND</option>
                                                                    <option value="OR">OR</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="F6" size="1">
                                                                    <option selected value="Select Field">Select Field</option>
                                                                    <% =GetSelect(sItem, "") %>
                                                                </select></td>
                                                            <td valign="top">
                                                                <select class="form-select" name="M6" size="1">
                                                                    <option selected value="E">[=]EQUAL TO</option>
                                                                    <option value="LT">[<]less THAN</option>
                                                                    <option value="GT">[&gt;]MORE THAN</option>
                                                                    <option value="N">[<>]NOT</option>
                                                                    <option value="L">LIKE(*)</option>
                                                                </select></td>
                                                            <td valign="top">
                                                                <input type="text" class="form-control" name="V6" size="30"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <p class="mt-3 float-end">Provide</p>
                                                            </td>
                                                            <td>
                                                                <select class="form-select" style="width: 100%" name="PageSize" size="1">
                                                                    <option value="25">25</option>
                                                                    <option selected value="50">50</option>
                                                                    <option value="100">100</option>
                                                                    <option value="250">250</option>
                                                                </select></td>
                                                            <td>
                                                                <p class="mt-3">listings per page.</p>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <input type="submit" class="btn btn-primary-soft" value="Search" name="B1"></td>
                                                            <td>
                                                                <input type="reset" class="btn btn-primary-soft float-start" value="Reset Form" name="B2"></td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <!--</form>-->
                                                <%
End Select

                                                %>
                                                <!-- Report Save Start -->
                                                <% 
if sR <> "Save" AND MyReportID = 0 AND sA <> "QSearch" then %>
                                                <table class="table table-responsive table-borderless">
                                                    <tr>
                                                        <td width="100%" height="6" colspan="2">
                                                            <hr noshade color="#800000">
                                                    </tr>
                                                    <tr>
                                                        <td><font face="Verdana" size="2">Name : </font>
                                                            <input type="text" class="form-control" name="txtRName" size="25"></td>
                                                        <td><font face="Verdana" size="2">Description : </font>
                                                            <input type="text" class="form-control" name="txtRDesc" size="45"></td>
                                                    </tr>
                                                    <tr>
                                                        <td height="5" colspan="2"></td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <input type="submit" class="btn btn-primary-soft" value="Save Report" name="S1" onclick="return fnValidateReport(this.form);"></td>
                                                    </tr>
                                                </table>
                                            </form>
                                            <% end if %>
                                            <!-- Report Save End -->
                                            <table class="table table-responsive table-borderless">
                                                <!--<tr>
                                                    <td width="100%" height="6">
                                                        <hr noshade color="#800000">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="100%"><font face="Verdana" size="4">SEARCHING THE SYSTEM</font></td>
                                                </tr>
                                                <tr>
                                                    <td width="100%" height="6">
                                                        <hr noshade color="#800000">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="100%" height="6">
                                                        <table border="0" cellpadding="4" width="100%">
                                                            <tr>
                                                                <td valign="top"><strong><font face="Verdana" size="2">BASIC SEARCH TECHNIQUES</font></strong></td>
                                                                <td valign="top">
                                                                    <ol>
                                                                        <li><font face="Verdana" size="2">Select from the fields available for your specific search.
            Please make your selections in order from the top, then down.</font></li>
                                                                        <li><font face="Verdana" size="2">The [Modifier] selection provides the allowable range of
            the search.</font></li>
                                                                        <li><font face="Verdana" size="2">Provide a value for the search. If a [<strong>LIKE*</strong>]            search is selected, <strong>wildcard</strong> searches are allowed <em>(see Performing            LIKE Searches)</em>.<br>
                                                                        </font></li>
                                                                    </ol>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top"><strong><font face="Verdana" size="2">Performing LIKE Searches</font></strong></td>
                                                                <td valign="top"><font face="Verdana" size="2">When performing [<strong>LIKE*</strong>]        searches, or ranged searches, it is best to use a partial value with a <strong>wildcard        character</strong> [<strong>*</strong>]. Wildcard characters can be used anywhere, and/or        multiple times within your search string.</font><p>
                                                                    <strong><font face="Verdana" size="3">Allowed        Wildcard Characters</font></strong><ul>
                                                                        <li><font face="Verdana" size="2"><strong>[*] Asterisk, [%] Percent</strong> - Both perform            the same function providing for any value to exist within the area it occupies in the            search string.</font></li>
                                                                        <li><font face="Verdana" size="2"><strong>[_] Underscore</strong> - Provides wildcard            functionality on a single character in the position it occupies in the search string.</font></li>
                                                                    </ul>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>-->
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="100%" colspan="2">
                                            <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>
</html>
