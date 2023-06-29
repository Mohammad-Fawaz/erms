<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_bom.asp" -->
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
Dim sLink
Dim sHID
Dim sRev
Dim sEff
Dim nQty
Dim sUOM
Dim sDesc

'Set variable defaults
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	sMode = Request.Form("Mode")
Else
	sMode = Request.QueryString("M")
End If

'Verify mode and take appropriate action
Select Case sMode
	Case "HN", "HC"
		sHID = WriteBOMHdr(True)
	Case "HU"
		sHID = WriteBOMHdr(False)
	Case "IN"
		sHID = WriteBOMItem(True)
	Case "IU"
		sHID = WriteBOMItem(False)
	Case "ID"
		DeleteItem Request.QueryString("CITEM")
		sHID = Request.QueryString("ITEM")
End Select

If (sMode = "HC") Then
	TransferItems Request.Form("BItem"), sHID
End If

If (sHID = "") Then
	If (Request.Form("BItemID") <> "") Then
		sHID = Request.Form("BItemID")
	Else
		sHID = Request.QueryString("ITEM")
	End If
End If

'Format header information
sCMD = "SELECT ItemNum, ItemRev, BType, ItemStatus, BDesc, EffDate, BItemDesc FROM BOMHdr "
sCMD = sCMD & "WHERE (BItemID = " & sHID & ")"
Set oRS = GetADORecordset(sCMD, Nothing)

If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
	oRS.MoveFirst
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
	sHeader = sHeader & vbCrLf & "        <td colspan='2'><font face='Verdana' size='2'><strong>BOM Item Status:</strong> " & oRS("ItemStatus") & "</font></td>"
	sHeader = sHeader & vbCrLf & "        <td><font face='Verdana' size='2'><strong>Effective Date:</strong> " & oRS("EffDate") & "</font></td>"
	sHeader = sHeader & vbCrLf & "      </tr>"
	sHeader = sHeader & vbCrLf & "      <tr>"
	sHeader = sHeader & vbCrLf & "        <td colspan='3'><font face='Verdana' size='2'><strong>Item Description:</strong> " & oRS("BItemDesc") & "</font></td>"
	sHeader = sHeader & vbCrLf & "      </tr>"
	sHeader = sHeader & vbCrLf & "      <tr>"
	sHeader = sHeader & vbCrLf & "        <td colspan='3' align='center'><font face='Verdana' size='2'><strong>[ <a href='bom_createh2.asp?M=HU&ITEM=" & sHID & "'>Edit Header Information</a> ]</strong></font></td>"
	sHeader = sHeader & vbCrLf & "      </tr>"
	sHeader = sHeader & vbCrLf & "    </table>"
	oRS.Close
Else
	sHeader = "<font face='Verdana' size='2'>NO HEADER INFORMATION RETURNED</font>"
End If

'Provide form containing appropriate information
Select Case Left(sMode, 1)
	Case "H", "I", "B"
		sForm = "    <form method='POST' action='bom_addedit.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='R'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='BItemID' value='" & sHID & "'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Sequence No:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='SeqNo' size='5'></td>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item No:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='ItemNo' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("BOMItem1", "")
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='center' colspan='4'><input type='submit' value='Refresh Item Info' name='B1'> <input type='reset' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
	Case "R"
		Set oRS = GetADORecordset("SELECT PartNo, CurRev, EffDate, PartDesc, ItemUOM, ItemStdQty FROM ViewBOMParts WHERE (PartID = " & Request.Form("ItemNo") & ")", Nothing)
		sItem = IIf(IsNull(oRS("PartNo")), "", oRS("PartNo"))
		sRev = IIf(IsNull(oRS("CurRev")), "-", oRS("CurRev"))
		sDesc = IIf(IsNull(oRS("PartDesc")), "", oRS("PartDesc"))
		nQty = IIf(IsNull(oRS("ItemStdQty")), 1, oRS("ItemStdQty"))
		sUOM = IIf(IsNull(oRS("ItemUOM")), "EACH", oRS("ItemUOM"))
		sEff = IIf(IsNull(oRS("EffDate")), Date(), IIf(oRS("EffDate") > Date(), oRS("EffDate"), Date()))
		oRS.Close
		
		sForm = "    <form method='POST' action='bom_addedit.asp'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='IN'>"
		sForm = sForm & vbCrLf & "    <input type='hidden' name='BItemID' value='" & sHID & "'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Sequence No:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='SeqNo' size='5' value='" & Request.Form("SeqNo") & "'></td>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item No:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='ItemNo' size='15' value='" & sItem & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Revision:</strong></font></td>"
		'sForm = sForm & vbCrLf & "          <td><input type='text' name='ItemRev' size='5' value='" & sRev & "'></td>"
		sForm = sForm & vbCrLf & "          <td><select name='ItemRev' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("ItemRevHist", sItem & "|" & sRev)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Quantity:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='ItemQty' size='10' value='" & nQty & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>UOM:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='ItemUOM' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("PartUOM", sUOM)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Eff Date:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='EffDate' size='15' value='" & sEff & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'>Item Description:<br>(Resouce Information)</font></td>"
		sForm = sForm & vbCrLf & "          <td colspan='3'><textarea rows='3' name='ItemDesc' cols='42' wrap='physical'>" & sDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><em>Reference Designators</em>:<br><em>(Optional)</em></font></td>"
		sForm = sForm & vbCrLf & "          <td colspan='3'><textarea rows='3' name='RefDes' cols='42' wrap='physical'></textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='center' colspan='4'><input type='submit' value='Save Item' name='B1'> <input type='reset' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
End Select

'Format item listing
sItemList = ""
sCMD = "SELECT CItemID, SeqNum, CItemNum, CItemRev, CItemQty, CItemUOM, CItemEff FROM BOMItems "
sCMD = sCMD & "WHERE (BItemID = " & sHID & ") ORDER BY SeqNum"
Set oRS = GetADORecordset(sCMD, Nothing)

If Not ((oRS.BOF = True) And (oRS.EOF = True)) Then
	oRS.MoveFirst
	Do
		sLink = "<a href='bom_edititems.asp?M=IU&CITEM=" & oRS("CItemID") & "'><img src='../graphics/open.gif' alt='Edit' border='0' WIDTH='18' HEIGHT='18'></a>"
		sLink = sLink & vbCrLf & "<a href='bom_addedit.asp?M=ID&ITEM=" & sHID & "&CITEM=" & oRS("CItemID") & "'><img src='../graphics/delete.gif' alt='Delete' border='0' WIDTH='18' HEIGHT='18'></a>"
		sItemList = sItemList & vbCrLf & "      <tr>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'>" & sLink & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("SeqNum") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("CItemNum") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("CItemRev") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("CItemQty") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("CItemUOM") & "</font></td>"
		sItemList = sItemList & vbCrLf & "        <td><font face='Verdana' size='2'>" & oRS("CItemEff") & "</font></td>"
		sItemList = sItemList & vbCrLf & "      </tr>"
		oRS.MoveNext
	Loop Until oRS.EOF
	oRS.Close
Else
	sItemList = sItemList & vbCrLf & "      <tr>"
	sItemList = sItemList & vbCrLf & "        <td colspan='7'><font face='Verdana' size='2'>NO ASSOCIATED RECORDS RETURNED</font></td>"
	sItemList = sItemList & vbCrLf & "      </tr>"
End If
Set oRS = Nothing

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Add/Edit BOM Items</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2">
    <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %>
</td>
    <td width="635" valign="top"><font face="Verdana" size="5">Create Bill of Material</font><br>
<% =sHeader %>
    <p><font face="Verdana" size="3"><strong>Add/Edit BOM Items<br>
    </strong></font><font face="Verdana" size="2">You may add items to this BOM using the form
    below or edit specific items from the included listing using the corresponding buttons.</font></p>
<% =sForm %>
    <table border="0" width="100%">
      <tr>
        <td bgcolor="#D7D7D7"></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Seq. No.</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Item No.</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Rev</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Qty</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">UOM</font></strong></td>
        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Eff. Date</font></strong></td>
      </tr>
<% =sItemList %>
    </table>
    <p><font size="1"><a href="bom_rpts.asp">View Bom</a></font></td>
  </tr>
  <tr>
    <td width="100%" colspan="2">
    <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>