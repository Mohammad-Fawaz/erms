<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<%
Dim sMode
Dim sItem
Dim sRev
Dim sDesc
Dim sStatus
Dim sEff
Dim sCMD
Dim sForm
Dim oRS
Dim sItemList
Dim sInfo

'Verify page retrieval method and fill variables
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	sMode = Request.Form("Mode")
Else
	sMode = Request.QueryString("M")
End If
If (sMode = "") Then sMode = "C2"

'Provide form containing appropriate information
Select Case sMode
	Case "C1"
		sInfo = "<p><font face='Verdana' size='2'>Provide Item Number to copy from:<br><i>(Do not use wildcard characters)</i></font></p>"
		sInfo = sInfo & vbCrLf & "<p><font face='Verdana' size='2'>Partial or unmatched numbers will return a selectable listing of item "
		sInfo = sInfo & vbCrLf & "numbers to choose from. If no information is provided a complete listing of available item numbers will "
		sInfo = sInfo & vbCrLf & "be returned, but this may lead to slower loading of the page.</font></p>"
		
		sForm = "    <form method='POST' action='bom_copy.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='C2'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><strong><font face='Verdana' size='3'>Copy From...</font></strong></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BItem' size='20'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' value='Continue' name='B1'><input type='reset' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
	Case "C2"
		sInfo = "<p><font face='Verdana' size='2'>Select BOM item to copy from:</font></p>"
		
		If (Request.Form("BItem") <> "") Then
			sItem = Request.Form("BItem")
		End If
		
		sForm = "    <form method='POST' action='bom_copy.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='C3'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><strong><font face='Verdana' size='3'>Copy From...</font></strong></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Information:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BItemID' class='form-select' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("BItemInfo", sItem)
		sForm = sForm & vbCrLf & "          </select></td>"		
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' class='btn btn-primary-soft' value='Continue' name='B1'><input type='reset' class='btn btn-primary-soft ms-1' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
	Case "C3"
		sInfo = "<p><font face='Verdana' size='2'>Provide Item Number to copy to:<br><i>(Do not use wildcard characters)</i></font></p>"
		sInfo = sInfo & vbCrLf & "<p><font face='Verdana' size='2'>Partial or unmatched numbers will return a selectable listing of item "
		sInfo = sInfo & vbCrLf & "numbers to choose from. If no information is provided a complete listing of available item numbers will "
		sInfo = sInfo & vbCrLf & "be returned, but this may lead to slower loading of the page.</font></p>"
		
		If (Request.Form("BItemID") <> "") Then
			Set oRS = GetADORecordset("SELECT ItemNum, ItemRev, BType FROM BOMHdr WHERE (BItemID = " & Request.Form("BItemID") & ")", Nothing)
		End If
		
		sForm = "    <form method='POST' action='bom_copy.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='C4'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='BItemID' value='" & Request.Form("BItemID") & "'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><strong><font face='Verdana' size='3'>Copy From...</font></strong></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("ItemNum") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Revision:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("ItemRev") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Type:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("BType") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><font face='Verdana' size='3'><strong>Copy To...</strong></font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BOMItem' class='form-control' size='20'></td>"	
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' class='btn btn-primary-soft' value='Continue' name='B1'><input type='reset' class='btn btn-primary-soft' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
	Case "C4"
		sInfo = "<p><font face='Verdana' size='2'>Select item to copy BOM information to:</font></p>"
		
		If (Request.Form("BItemID") <> "") Then
			Set oRS = GetADORecordset("SELECT ItemNum, ItemRev, BType FROM BOMHdr WHERE (BItemID = " & Request.Form("BItemID") & ")", Nothing)
		End If
		
		sForm = "    <form method='POST' action='bom_copy.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='C5'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='BItemID' value='" & Request.Form("BItemID") & "'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><strong><font face='Verdana' size='3'>Copy From...</font></strong></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("ItemNum") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Revision:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("ItemRev") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Type:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("BType") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><font face='Verdana' size='3'><strong>Copy To...</strong></font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BOMItem' class='form-select' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("BOMItem1", Request.Form("BOMItem"))
		sForm = sForm & vbCrLf & "          </select></td>"		
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' class='btn btn-primary-soft' value='Continue' name='B1'><input type='reset' class='btn btn-primary-soft' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
	Case "C5"
		sInfo = "<p><font face='Verdana' size='2'>Provide BOM header information:</font></p>"
		
		If (Request.Form("BItemID") <> "") Then
			Set oRS = GetADORecordset("SELECT ItemNum, ItemRev, BType FROM BOMHdr WHERE (BItemID = " & Request.Form("BItemID") & ")", Nothing)
		End If
		
		sForm = "    <form method='POST' action='bom_addedit.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='HC'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='BItem' value='" & Request.Form("BItemID") & "'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='PartID' value='" & Request.Form("BOMItem") & "'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><strong><font face='Verdana' size='3'>Copy From...</font></strong></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("ItemNum") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Revision:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("ItemRev") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Type:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><font face='Verdana' size='2'>" & oRS("BType") & "</font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		oRS.Close
		
		Set oRS = GetADORecordset("SELECT PartNo, PartDesc, CurRev, PStatus, EffDate FROM ViewBOMParts WHERE (PartID = " & Request.Form("BOMItem") & ")", Nothing)
		sItem = IIf(IsNull(oRS("PartNo")), "", oRS("PartNo"))
		sRev = IIf(IsNull(oRS("CurRev")), "-", oRS("CurRev"))
		sDesc = IIf(IsNull(oRS("PartDesc")), "", oRS("PartDesc"))
		sStatus = IIf(IsNull(oRS("PStatus")), "", oRS("PStatus"))
		sEff = IIf(IsNull(oRS("EffDate")), Date(), IIf(oRS("EffDate") > Date(), oRS("EffDate"), Date()))
		
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><font face='Verdana' size='3'><strong>Copy To...</strong></font></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td colspan='2'><hr noshade color='#808000'>"
		sForm = sForm & vbCrLf & "          </td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' class='form-control' name='BOMItem' size='20' value='" & sItem & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item Revision:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' class='form-control' name='BItemRev' size='5' value='" & sRev & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>BOM Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' class='form-control' name='BOMDesc' cols='35' wrap='physical'></textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Item Status:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select class='form-select' name='BItemStatus' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("PartStatus", sStatus)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Type:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select class='form-select' name='BOMType' size='1'>"
		sForm = sForm & vbCrLf & "            <option value='Engineering'>Engineering</option>"
		sForm = sForm & vbCrLf & "            <option value='Production'>Production</option>"
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Effective Date:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' class='form-control' name='BItemEff' size='15' value='" & sEff & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>Item Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' class='form-control' name='BItemDesc' cols='35' wrap='physical'>" & sDesc & "</textarea></td>"		
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' class='btn btn-primary-soft' value='Continue' name='B1'><input type='reset' class='btn btn-primary-soft' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
End Select

%>

  <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
<title>Copy BOM</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">


<!--webbot bot="Include" endspan i-checksum="42909" -->

	<div id="layoutSidenav_content">
        <main>
            <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                <div class="container-xl px-4">
                    <div class="page-header-content">
                        <div class="row align-items-center justify-content-between pt-3">
                            <div class="col-auto mb-3">
                                <h1 class="page-header-title">
                                    <div class="page-header-icon"><i data-feather="user"></i></div>
                                    Bill of Material
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
                            <div class="card-header">Copy Bill of Material</div>
                            <div class="card-body">                               
                                           <table>
  <tr>
    <!--<td width="145" valign="top" bgcolor="#FFFFC8"><% '=sMenu %>-->
    <td width="635" valign="top"><% =sInfo %>
<% =sForm %>
    <p>&nbsp;</p></td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
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
