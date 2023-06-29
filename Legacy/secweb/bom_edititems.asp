<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<%
Dim sMode
Dim sItem
Dim sCMD
Dim sHeader
Dim sForm
Dim oRS
Dim sItemList
Dim sHID
Dim sTemp

'Set variable defaults
sMode = Request.QueryString("Mode")
sItem = Request.QueryString("CITEM")

'Format header information
sCMD = "SELECT BOMHdr.BItemID, BOMHdr.ItemNum, BOMHdr.ItemRev, BOMHdr.BType, BOMHdr.ItemStatus, "
sCMD = sCMD & "BOMHdr.BDesc, BOMHdr.EffDate, BOMHdr.BItemDesc, BOMItems.CItemID FROM BOMHdr, BOMItems "
sCMD = sCMD & "WHERE (BOMHdr.BItemID = BOMItems.BItemID) AND (BOMItems.CItemID = " & sItem & ")"
Set oRS = GetADORecordset(sCMD, Nothing)

If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
	oRS.MoveFirst
	sHID = IIf(IsNull(oRS("BItemID")), "", oRS("BItemID"))
	sHeader = "    <table border='0' cellpadding='2' cellspacing='0' width='100%'>"
	sHeader = sHeader & vbCrLf & "      <tr>"
	sHeader = sHeader & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>BOM Description:</strong> " & oRS("BDesc") & "</font></td>"
	sHeader = sHeader & vbCrLf & "      </tr>"
	sHeader = sHeader & vbCrLf & "      <tr>"
	sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Item Number:</strong> " & oRS("ItemNum") & "</font></td>"
	sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Item Revision:</strong> " & oRS("ItemRev") & "</font></td>"
	sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>BOM Type:</strong> " & oRS("BType") & "</font></td>"
	sHeader = sHeader & vbCrLf & "      </tr>"
	sHeader = sHeader & vbCrLf & "      <tr>"
	sHeader = sHeader & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>Item Status:</strong> " & oRS("ItemStatus") & "</font></td>"
	sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Effective Date:</strong> " & oRS("EffDate") & "</font></td>"
	sHeader = sHeader & vbCrLf & "      </tr>"
	sHeader = sHeader & vbCrLf & "      <tr>"
	sHeader = sHeader & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Item Description:</strong> " & oRS("BItemDesc") & "</font></td>"
	sHeader = sHeader & vbCrLf & "      </tr>"
	sHeader = sHeader & vbCrLf & "    </table>"
	oRS.Close
Else
	sHeader = "<font face='Verdana' size='2'>NO HEADER INFORMATION RETURNED</font>"
End If

'Provide form containing appropriate information
sCMD = "SELECT SeqNum, CItemNum, CItemRev, CItemQty, CItemUOM, CItemEff, RefDes, CItemDesc, BItemID "
sCMD = sCMD & "FROM BOMItems WHERE (CItemID = " & sItem & ")"
Set oRS = GetADORecordset(sCMD, Nothing)

If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
	oRS.MoveFirst
	sForm = "    <form method='POST' action='bom_addedit.asp'>"
	sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='IU'>"
	sForm = sForm & vbCrLf & "    <input type='hidden' name='BItemID' value='" & sHID & "'>"
	sForm = sForm & vbCrLf & "    <input type='hidden' name='CItem' value='" & sItem & "'>"
	sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Sequence No:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td><input type='text' name='SeqNo' class='form-control' size='5' value='" & oRS("SeqNum") & "'></td>"
	sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item No:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td><input type='text' name='ItemNo' class='form-control' size='20' value='" & oRS("CItemNum") & "'></td>"
	'sForm = sForm & vbCrLf & "          <td><select name='ItemNo' size='1'>"
	'sForm = sForm & vbCrLf & GetSelect("CItem", oRS("CItemNum"))
	'sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Revision:</strong></font></td>"
	'sForm = sForm & vbCrLf & "          <td><input type='text' name='ItemRev' size='5' value='" & oRS("CItemRev") & "'></td>"
	sForm = sForm & vbCrLf & "          <td><select name='ItemRev' size='1' class='form-select'>"
	sForm = sForm & vbCrLf & GetSelect("ItemRevHist", oRS("CItemNum") & "|" & oRS("CItemRev"))
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Quantity:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td><input type='text' name='ItemQty class='form-control' size='10' value='" & oRS("CItemQty") & "'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>UOM:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td><select name='ItemUOM' size='1' class='form-select'>"
	sForm = sForm & vbCrLf & GetSelect("PartUOM", oRS("CItemUOM"))
	sForm = sForm & vbCrLf & "          </select></td>"
	sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Eff Date:</strong></font></td>"
	sForm = sForm & vbCrLf & "          <td><input type='text' name='EffDate' class='form-control' size='15' value='" & oRS("CItemEff") & "'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'>Item Description:<br>(Resouce Information)</font></td>"
	sForm = sForm & vbCrLf & "          <td colspan='3'><textarea rows='3' name='ItemDesc' class='form-control' cols='42' wrap='physical'>" & oRS("CItemDesc") & "</textarea></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><em>Reference Designators</em>:<br><em>(Optional)</em></font></td>"
	sForm = sForm & vbCrLf & "          <td colspan='3'><textarea rows='3' name='RefDes' class='form-control' cols='42' wrap='physical'>" & oRS("RefDes") & "</textarea></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "        <tr>"
	sForm = sForm & vbCrLf & "          <td align='center' colspan='4'><input type='submit' class='btn btn-primary-soft' value='Save Item' name='B1'> <input type='reset' class='btn btn-primary-soft' value='Reset' name='B2'></td>"
	sForm = sForm & vbCrLf & "        </tr>"
	sForm = sForm & vbCrLf & "      </table>"
	sForm = sForm & vbCrLf & "      </center></div>"
	sForm = sForm & vbCrLf & "    </form>"
	oRS.Close
End If
Set oRS = Nothing

'Format item listing
sItemList = ""
sCMD = "SELECT SeqNum, CItemNum, CItemRev, CItemQty, CItemUOM, CItemEff, CItemID FROM BOMItems "
sCMD = sCMD & "WHERE (BItemID = " & sHID & ") ORDER BY SeqNum"
Set oRS = GetADORecordset(sCMD, Nothing)

If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
	oRS.MoveFirst
	Do
		If (CLng(sItem) = oRS("CItemID")) Then sTemp = " color='#FF0000'" Else sTemp = ""
		sItemList = sItemList & vbCrLf & "      <tr>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'" & sTemp & ">" & oRS("SeqNum") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'" & sTemp & ">" & oRS("CItemNum") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'" & sTemp & ">" & oRS("CItemRev") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'" & sTemp & ">" & oRS("CItemQty") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'" & sTemp & ">" & oRS("CItemUOM") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'" & sTemp & ">" & oRS("CItemEff") & "</font></td>"
		sItemList = sItemList & vbCrLf & "      </tr>"
		oRS.MoveNext
	Loop Until oRS.EOF
	oRS.Close
Else
	sItemList = sItemList & vbCrLf & "      <tr>"
	sItemList = sItemList & vbCrLf & "        <td colspan='6'><font face='Verdana' size='2'>NO ASSOCIATED RECORDS RETURNED</font></td>"
	sItemList = sItemList & vbCrLf & "      </tr>"
End If
Set oRS = Nothing

%>
	<link href="/css/styles.css" rel="stylesheet" />

	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
<title>Edit BOM Items</title>
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
			            <div class="container-xl px-4 mt-4">
							 <div class="row">
                    <div class="col-xl-12">
                        <!--  card-->
                        <div class="card mb-4">
                            <div class="card-header">Edit BOM Item</div>
                            <div class="card-body">
								<table border="0" cellpadding="0" cellspacing="0" width="820" height="80">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <% =sMenu %>
</td>
    <td width="635" valign="top">
<% =sHeader %>
<% =sForm %>
    <table border="0" width="100%" class="table table-bordered table-condensed table-responsive table-hover">
      <tr>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Seq. No.</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Item No.</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Rev</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Qty</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">UOM</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Eff. Date</font></strong></td>
      </tr>
<% =sItemList %>
    </table>
    <p><font face="Verdana" size="2">&nbsp;</font></td>
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
						</div>
                </main>
</div>


	<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>
</html>
