<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<%
Dim sMode
Dim sItem
Dim sCMD
Dim oRS
Dim sForm
Dim sRev
Dim sDesc
Dim sItemDesc
Dim sStatus
Dim sEff

'Set variable defaults
sMode = ""
sItem = ""

'Verify page retrieval method and fill variables
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	sMode = Request.Form("Mode")
	sItem = Request.Form("BOMItem")
Else
	sMode = Request.QueryString("M")
	sItem = GetDataValue("SELECT ItemNum AS RetVal FROM BOMHdr WHERE (BItemID = " & Request.QueryString("ITEM") & ")", Nothing)
End If

'Provide form containing appropriate information
Select Case sMode
	Case "HN"
		'Retrieve item listing
		sForm = "    <form method='POST' action='bom_createh2.asp' id=form1 name=form1>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='R'/>"
		sForm = sForm & vbCrLf & "      <div class='row'><div class='col-md-6'>"
		sForm = sForm & vbCrLf & "         <label class='small mb-1' for='BOMItem'>Item Number</label>"		
		sForm = sForm & vbCrLf & "          <select name='BOMItem' size='1' class='form-select'>"
		sForm = sForm & vbCrLf & GetSelect("BOMItem1", sItem)
		sForm = sForm & vbCrLf & "          </select></div>"
		sForm = sForm & vbCrLf & "        </div>"
		sForm = sForm & vbCrLf & "         <div class='row mt-2'><div class='col-md-6'>"
		sForm = sForm & vbCrLf & "          <input type='submit' class='btn btn-primary-soft' value='Refresh Item Info' name='B1'> <input type='reset' class='btn btn-primary-soft' value='Reset' name='B2'>"
		sForm = sForm & vbCrLf & "        </div>"		
		sForm = sForm & vbCrLf & "      </div>"
		sForm = sForm & vbCrLf & "    </form>"
	Case "R", "D"
		'sCMD = "SELECT PartNo, PartDesc, CurRev, RStatus, EffDate FROM ViewParts WHERE (PartNo = '" & sItem & "')"
		sCMD = "SELECT PartNo, PartDesc, CurRev, PStatus, EffDate FROM ViewBOMParts WHERE (PartID = " & sItem & ")"
		Set oRS = GetADORecordset(sCMD, Nothing)
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			sItem = IIf(IsNull(oRS("PartNo")), "", oRS("PartNo"))
			sRev = IIf(IsNull(oRS("CurRev")), "-", oRS("CurRev"))
			sDesc = IIf(IsNull(oRS("PartDesc")), "", oRS("PartDesc"))
			sStatus = IIf(IsNull(oRS("PStatus")), "", oRS("PStatus"))
			sEff = IIf(IsNull(oRS("EffDate")), Date(), IIf(oRS("EffDate") > Date(), oRS("EffDate"), Date()))
		Else
			sRev = "-"
			sDesc = ""
			sStatus = ""
			sEff = Date()
		End If
		oRS.Close
		Set oRS = Nothing
		
		sForm = "    <form method='POST' action='bom_addedit.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='HN'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BOMItem' class='form-control' size='20' value='" & sItem & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item Revision:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' class='form-control' name='BItemRev' size='5' value='" & sRev & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>BOM Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea class='form-control' rows='3' name='BOMDesc' cols='45' wrap='physical'>" & sDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Type:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BOMType' size='1' class='form-select'>"
		sForm = sForm & vbCrLf & "            <option value='Engineering'>Engineering</option>"
		sForm = sForm & vbCrLf & "            <option value='Production'>Production</option>"
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Item Status:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BItemStatus' size='1' class='form-select'>"
		sForm = sForm & vbCrLf & GetSelect("PartStatus", sStatus)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Effective Date:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' class='form-control' name='BItemEff' size='15' value='" & sEff & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>Item Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' class='form-control' name='BItemDesc' cols='45' wrap='physical'>" & sDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td></td><td><input type='submit' class='btn btn-primary-soft' value='Continue' name='B1'> <input type='reset' class='btn btn-primary-soft' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
	Case "HU"
		sCMD = "SELECT ItemNum, ItemRev, BType, BDesc, ItemStatus, EffDate, BItemDesc FROM BOMHdr WHERE (BItemID = " & Request.QueryString("ITEM") & ")"
		Set oRS = GetADORecordset(sCMD, Nothing)
		
		If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
			oRS.MoveFirst
			sRev = IIf(IsNull(oRS("ItemRev")), "-", oRS("ItemRev"))
			sDesc = IIf(IsNull(oRS("BDesc")), "", oRS("BDesc"))
			sItemDesc = IIf(IsNull(oRS("BItemDesc")), "", oRS("BItemDesc"))
			If Not IsNull(oRS("BType")) Then
				If (oRS("BType") = "Engineering") Then
					sType = vbCrLf & "            <option selected value='Engineering'>Engineering</option>"
					sType = sType & vbCrLf & "            <option value='Production'>Production</option>"
				Else
					sType = vbCrLf & "            <option selected value='Engineering'>Engineering</option>"
					sType = sType & vbCrLf & "            <option selected value='Production'>Production</option>"
				End If
			Else
				sType = vbCrLf & "            <option value='Engineering'>Engineering</option>"
				sType = sType & vbCrLf & "            <option value='Production'>Production</option>"
			End If
			sStatus = IIf(IsNull(oRS("ItemStatus")), "", oRS("ItemStatus"))
			sEff = IIf(IsNull(oRS("EffDate")), Date(), IIf(oRS("EffDate") > Date(), oRS("EffDate"), Date()))
		
			oRS.Close
		End If
		Set oRS = Nothing
		
		sForm = "    <form method='POST' action='bom_addedit.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='HU'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='BItemID' value='" & Request.QueryString("ITEM") & "'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' class='form-control' name='BOMItem' size='20' value='" & sItem & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item Revision:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BItemRev' class='form-control' size='5' value='" & sRev & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>BOM Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' class='form-control' name='BOMDesc' cols='45' wrap='physical'>" & sDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Type:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BOMType' size='1' class='form-select'>"
		sForm = sForm & sType
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Item Status:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BItemStatus' size='1' class='form-select'>"
		sForm = sForm & vbCrLf & GetSelect("PartStatus", sStatus)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Effective Date:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' class='form-control' name='BItemEff' size='15' value='" & sEff & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>Item Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' class='form-control' name='BItemDesc' cols='45' wrap='physical'>" & sItemDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td></td><td><input type='submit' class='btn btn-primary-soft' value='Continue' name='B1'> <input type='reset' class='btn btn-primary-soft' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
End Select

%>

<title>Create BOM Header</title>
	<link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
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
                        <!-- Task information card-->
                        <div class="card mb-4">
                            <div class="card-header">Create Bill of Material</div>
                            <div class="card-body">                       
<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>

    <td width="635" valign="top"><p><strong><font face="Verdana" size="3">Enter BOM Header Information</font></strong></p>
<% =sForm %>
    <p>&nbsp;</td>
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
