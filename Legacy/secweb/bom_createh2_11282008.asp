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
		sForm = sForm & vbCrLf & "    <input type='hidden' name='Mode' value='R'>"
		sForm = sForm & vbCrLf & "      <div align='center'><center><table border='0' cellpadding='2' cellspacing='0'>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><strong><font face='Verdana' size='2'>Item Number:</font></strong></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BOMItem' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("BOMItem1", sItem)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' value='Refresh Item Info' name='B1'> <input type='reset' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
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
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BOMItem' size='20' value='" & sItem & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item Revision:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BItemRev' size='5' value='" & sRev & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>BOM Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' name='BOMDesc' cols='45' wrap='physical'>" & sDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Type:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BOMType' size='1'>"
		sForm = sForm & vbCrLf & "            <option value='Engineering'>Engineering</option>"
		sForm = sForm & vbCrLf & "            <option value='Production'>Production</option>"
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Item Status:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BItemStatus' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("PartStatus", sStatus)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Effective Date:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BItemEff' size='15' value='" & sEff & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>Item Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' name='BItemDesc' cols='45' wrap='physical'>" & sDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' value='Continue' name='B1'> <input type='reset' value='Reset' name='B2'></td>"
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
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BOMItem' size='20' value='" & sItem & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Item Revision:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BItemRev' size='5' value='" & sRev & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>BOM Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' name='BOMDesc' cols='45' wrap='physical'>" & sDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Type:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BOMType' size='1'>"
		sForm = sForm & sType
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>BOM Item Status:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><select name='BItemStatus' size='1'>"
		sForm = sForm & vbCrLf & GetSelect("PartStatus", sStatus)
		sForm = sForm & vbCrLf & "          </select></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right'><font face='Verdana' size='2'><strong>Effective Date:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><input type='text' name='BItemEff' size='15' value='" & sEff & "'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='right' valign='top'><font face='Verdana' size='2'><strong>Item Description:</strong></font></td>"
		sForm = sForm & vbCrLf & "          <td><textarea rows='3' name='BItemDesc' cols='45' wrap='physical'>" & sItemDesc & "</textarea></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "        <tr>"
		sForm = sForm & vbCrLf & "          <td align='center' colspan='2'><input type='submit' value='Continue' name='B1'> <input type='reset' value='Reset' name='B2'></td>"
		sForm = sForm & vbCrLf & "        </tr>"
		sForm = sForm & vbCrLf & "      </table>"
		sForm = sForm & vbCrLf & "      </center></div>"
		sForm = sForm & vbCrLf & "    </form>"
End Select

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Create BOM Header</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" startspan -->

<table border="0" cellpadding="0" cellspacing="0" width="820" height="80">
  <tr>
    <td valign="bottom" height="47" width="718"><font face="Verdana" size="6"><a href="ermsw_index.asp"><strong>ERMS</strong><em>Web</a></font><font face="Verdana" size="6" color="#000080"><br>
    </font></em><font face="Verdana" size="2"><strong>Engineering Resource Management System</strong></font></td>
    <td valign="bottom" align="right" nowrap colspan="3" height="47">
    
<font size="3"><strong>

<p></strong></font>
<img src="../graphics/mar_logo_320.gif" alt="Micropac Industries, Inc.®" width="291" height="48"></p>

</td>
  </tr>
  <tr>
    <td valign="bottom" height="12" width="718"></td>
    <td valign="bottom" align="right" nowrap height="12" width="275">
    <p align="left"><font face="Verdana" size="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </font> </td>
    <td valign="bottom" align="right" nowrap height="12">
    <p><font face="Verdana" size="1"><a href="ermsw_index.asp"><b>
    My Home</b></a><b>&nbsp; </b></font></td>
    <td valign="bottom" align="right" nowrap height="12" width="80">
    

<p><strong><font face="Verdana" size="1">&nbsp;<a href="http://intranet">Intranet</a></font></strong></p>
</td>
  </tr>
  <tr>
    <td width="938" colspan="4" height="4"><hr noshade size="3" color="#808000">
    </td>
  </tr>
</table>
<!--webbot bot="Include" endspan i-checksum="42909" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %>
</td>
    <td width="635" valign="top"><font face="Verdana" size="5">Create BOM Header</font><p><strong><font face="Verdana" size="3">Enter BOM Header Information</font></strong></p>
<% =sForm %>
    <p>&nbsp;</td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" startspan -->

<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td width="100%"><hr noshade size="3" color="#808000">
    </td>
  </tr>
  <tr>
    <td width="100%" align="center">
    <p style="margin-top: 0; margin-bottom: 0"><font face="Verdana" size="1" color="#808000">
    <a href="supp_contact.asp">Contact Information</a>&nbsp;&nbsp;&nbsp;
    <a href="supp_links.asp">Support Links</a></font><font face="Verdana" size="2" color="#808000">&nbsp;
    </font><font face="Verdana" color="#808000" size="1">&nbsp;<a href="supp_docs.asp">Help 
    Information</a></font></p>
    <p style="margin-top: 0; margin-bottom: 0"><font color="#808000" face="Verdana" size="2"><strong>ERMS</strong><em>Web</em><br>
    Engineering Resource Management System<br>
    Version 4.2.1</font></p>
    <p style="margin-top: 0; margin-bottom: 0"><font face="Verdana" size="1" color="#808000">©2000-2004, Desktop
    Devices<br>
    All Rights Reserved</font></td>
  </tr>
</table>
<!--webbot bot="Include" endspan i-checksum="18164" -->
</td>
  </tr>
</table>
</body>
</html>
