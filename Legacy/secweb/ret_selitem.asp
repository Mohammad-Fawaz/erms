<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<%
Dim sHead
Dim sList
Dim vOpt
Dim sTitle
Dim bDel
Dim sDelCmd
Dim sQS

If (Request.QueryString("M") = "D") Then
	If (Request.QueryString("PartNo") <> "") Then
		sDelCmd = "DELETE * FROM PartPar WHERE (PartNo = '" & Request.QueryString("PartNo") & "')"
		bDel = RunSQLCmd(sDelCmd, Nothing)
		If Not bDel Then
			sDelCmd = "An unexpected error occurred while attempting to delete the record."
		Else
			sDelCmd = ""
		End If
	End If
End If

sQS = "Listing=" & Request.QueryString("Listing") & "&Item=" & Request.QueryString("Item") & "&Opt=&" & Request.QueryString("Opt")

Select Case Request.QueryString("Listing")
	Case "Change"
		sTitle = "Change Order Information"
		sHead = "<table border='0' cellpadding='2' width='100%'>"
		sHead = sHead & "  <tr>"
		sHead = sHead & "    <td><font face='Verdana' size='5'>Change Order Information</font></td>"
		sHead = sHead & "    <td align='right'><a class='print-link' href='#' onclick='window.print();return false;' target='_blank'><strong><font face='Verdana' size='2'>Print</font></strong></a><br>"
		'sHead = sHead & "    <td align='right'><a href='pnt_selitem.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='2'>View Printable Format</font></strong></a><br>"
		'sHead = sHead & "    <a href='pnt_chgreq.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='1'>Printable Change Request Form</font></strong></a><br>"
		'sHead = sHead & "    <a href='pnt_dev.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='1'>Printable Waiver/Deviation Form</font></strong></a></td>"
		sHead = sHead & "  </tr>"
		sHead = sHead & "</table>"
		
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Change", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Change", "0", "")
		End If
	Case "Doc"
		sTitle = "Document Information"
		sHead = "<table border='0' cellpadding='2' width='100%'>"
		sHead = sHead & "  <tr>"
		sHead = sHead & "    <td><font face='Verdana' size='5'>Document Information</font></td>"
		'sHead = sHead & "    <td align='right'><a href='pnt_selitem.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='2'>View Printable Format</font></strong></a></td>"
		sHead = sHead & "    <td align='right'><a class='print-link' href='#' onclick='window.print();return false;' target='_blank'><strong><font face='Verdana' size='2'>Print</font></strong></a></td>"
		sHead = sHead & "  </tr>"
		sHead = sHead & "</table>"
		'If (Request.QueryString("Opt") <> "") Then
		'	vOpt = Request.QueryString("Opt")
		'Else
		'	vOpt = ""
		'End If
		
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Doc", CStr(Request.QueryString("Item")), IIf(Request.QueryString("Opt") <> "", Request.QueryString("Opt"), "0000"))
		Else
			sList = GetHTML("SelItem", "Doc", "0", IIf(Request.QueryString("Opt") <> "", Request.QueryString("Opt"), "0000"))
		End If
	Case "Order"
		sTitle = "Order Information"
		sHead = "<table border='0' cellpadding='2' width='100%'>"
		sHead = sHead & "  <tr>"
		sHead = sHead & "    <td><font face='Verdana' size='5'>Order Information</font></td>"
		'sHead = sHead & "    <td align='right'><a href='pnt_selitem.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='2'>View Printable Format</font></strong></a></td>"
		sHead = sHead & "    <td align='right'><a class='print-link' href='#' onclick='window.print();return false;' target='_blank'><strong><font face='Verdana' size='2'>Print</font></strong></a></td>"
		sHead = sHead & "  </tr>"
		sHead = sHead & "</table>"
		
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Order", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Order", "0", "")
		End If
	Case "Part"
		sTitle = "Part Information"
		sHead = "<table border='0' cellpadding='2' width='100%'>"
		sHead = sHead & "  <tr>"
		sHead = sHead & "    <td><font face='Verdana' size='5'>Part Information</font></td>"
		'sHead = sHead & "    <td align='right'><a href='pnt_selitem.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='2'>View Printable Format</font></strong></a></td>"
		sHead = sHead & "    <td align='right'><a class='print-link' href='#' onclick='window.print();return false;' target='_blank'><strong><font face='Verdana' size='2'>Print</font></strong></a></td>"
		sHead = sHead & "  </tr>"
		sHead = sHead & "</table>"
		
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Part", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Part", "0", "")
		End If
	Case "Project"
		sTitle = "Project Information"
		sHead = "<table border='0' cellpadding='2' width='100%'>"
		sHead = sHead & "  <tr>"
		sHead = sHead & "    <td><font face='Verdana' size='5'>Project Information</font></td>"
		sHead = sHead & "    <td align='right'><a href='pnt_selitem.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='2'>View Printable Format</font></strong></a></td>"
		sHead = sHead & "  </tr>"
		sHead = sHead & "</table>"
		
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Project", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Project", "0", "")
		End If
	Case "QAction"
		sTitle = "Quality Action Information"
		sHead = "<table border='0' cellpadding='2' width='100%'>"
		sHead = sHead & "  <tr>"
		sHead = sHead & "    <td><font face='Verdana' size='5'>Quality Action Information</font></td>"
		sHead = sHead & "    <td align='right'><a href='pnt_selitem.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='2'>View Printable Format</font></strong></a></td>"
		sHead = sHead & "  </tr>"
		sHead = sHead & "</table>"
		
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "QAction", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "QAction", "0", "")
		End If
	Case "Task"
		sTitle = "Task Information"
		sHead = "<table border='0' cellpadding='2' width='100%'>"
		sHead = sHead & "  <tr>"
		sHead = sHead & "    <td><font face='Verdana' size='5'>Task Information</font></td>"
		sHead = sHead & "    <td align='right'><a href='pnt_selitem.asp?" & sQS & "' target='_blank'><strong><font face='Verdana' size='2'>View Printable Format</font></strong></a></td>"
		sHead = sHead & "  </tr>"
		sHead = sHead & "</table>"
		
		If (Request.QueryString("Item") <> "") Then
			sList = GetHTML("SelItem", "Task", CStr(Request.QueryString("Item")), "")
		Else
			sList = GetHTML("SelItem", "Task", "0", "")
		End If
	Case Else
		sTitle = "Item Information"
		sHead = "Item Information"
		sList = ""
End Select

    %>
    <script language="JavaScript">
<!--
    // begin - Info PopUp Window
    function iPop(url) {
        window.open(url, "InfoPop", "toolbar=no,width=800,height=600,status=no,scrollbars=yes,resize=yes,menubar=yes");
    }

    // begin - Traveler PopUp Window
    function tPop(url) {
        window.open(url, "TravPop", "toolbar=no,width=770,height=500,status=no,scrollbars=yes,resize=yes,menubar=yes");
    }

    // begin - Add/Edit PopUp Window
    function fPop(url) {
        window.open(url, "FormPop", "toolbar=no,width=640,height=250,status=no,scrollbars=no,resize=no,menubar=no");
    }
// -->
    </script>
    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>ERMSWeb - <% =sTitle %></title>
</head>

<body>
    <div id="layoutSidenav_content">

        <main>
            <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            </header>
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <table border="0" cellpadding="0" cellspacing="0" width="820">
                                    <tr>
                                        <td width="100%" colspan="2">
                                            <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--<td width="145" valign="top" bgcolor="#FFFFC8"><%' =sMenu %></td>-->
                                        <td width="635" valign="top"><font face="Verdana" size="5"><% =sHead %></font>
                                            <% 
If (sList <> "") Then
	Response.Write sList
	If (sDelCmd <> "") Then Response.Write "<p align='center'><font face='Verdana' size='3' color='#C10000'><b>" & sDelCmd & "</b></font></p>"
Else
                                            %>
                                            <div align="center">
                                                <div align="center">
                                                    <center>
                                                        <table class="table table-responsive table-borderless" border="0" cellpadding="0" cellspacing="0" width="780">
                                                            <tr>
                                                                <td width="100%" bgcolor="#000000"><font face="Verdana" size="2" color="#FFFFFF"><strong>No
        Records Returned</strong></font></td>
                                                            </tr>
                                                            <tr>
                                                                <td width="100%"><font face="Verdana" size="2">No Data</font></td>
                                                            </tr>
                                                        </table>
                                                    </center>
                                                </div>
                                                <%
End If
                                                %>
                                            </div>
                                            <p>
                                                &nbsp;</td>
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
    <style>
    	iframe#PageContent_frameQSearch {
    		height: 780px !important;
    	}

    	table {
    		width: 100% !important;
    		border: none !important;
    	}
    </style>
</body>
</html>
