<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef2.asp" -->
<!-- #INCLUDE FILE="script/incl_elements.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_proc.asp" -->
<%
Dim sForm
Dim sFields
Dim sPN
Dim sTest
Dim sWPN
Dim sQty
Dim sProc
Dim nMode
Dim nThick
Dim vWrite

'Set default
nMode = 1


'Is this a save action
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then

	'Validate record information
	If (Request.Form("PartNo") <> "") And (Request.Form("WPN") <> "") And (Request.Form("Thick") <> "") And (Request.Form("W1") <> "") And (Request.Form("W2") <> "") Then
	
	    '	nThick = FmtThickness(Request.Form("Thick"))
	    nThick=Request.Form("Thick")
		
		'nThick = InStr(1, StrReverse(Request.Form("Thick")), ".", 1)
		'nThick = IIf(nThick <= 3, Request.Form("Thick"), Left(Request.Form("Thick"), (Len(Request.Form("Thick")) + 3) - nThick))
		
		'=============================================================
		'Updates - Nov, 2005 - Allow duplicate dimensions with different part numbers.
		'=============================================================
		'Check for distinct [PartNo] first.    
		sTest = "SELECT PartNo AS RetVal FROM PartPar WHERE (DocID = '" & Request.QueryString("DocID") & "') AND (PartNo = '" & Request.Form("PartNo") & "')"
		sTest = GetDataValue(sTest, Nothing)
		'Set testable variable
		If (sTest <> "") Then
			'Duplicate Part No detected
			sProc = "<b>ERROR:</b> The Part Number you selected [" & sTest & "] already exists."
			vWrite = False
		Else
			vWrite = True
		End If
		    
		'Check variable to see whether or not to proceed.
		If (vWrite = True) Then
			If IsNumeric(Right(Request.Form("PartNo"), 1)) Then
				'Check for [PartNo] with the same dimensions for this Document.
				sTest = "SELECT PartNo AS RetVal FROM PartPar WHERE (DocID = '" & Request.QueryString("DocID") & "') AND (CDbl(Par1) = " & Request.Form("W1") & ") AND (CDbl(Par3) = " & Request.Form("W2") & ") AND (CDbl(Par5) = " & nThick & ")"
				sTest = GetDataValue(sTest, Nothing)
			Else
				sTest = ""
			End If
			'Check variable to see whether or not to proceed.
			If (sTest <> "") Then
				'Set variables for verification form mode
				sProc = "<b>ERROR:</b> Part Number [" & sTest & "] with the selected dimensions already exists. Would you like to continue saving this part?"
				vWrite = False
			Else
				vWrite = True
			End If
		    
			'Check variable to see whether or not to proceed.
			If (vWrite = True) Then
				'Save the record
				sTest = WriteRec("Element", Request.QueryString("M"), nThick)
    
				If (sTest <> "") Then
					'Save error
					sProc = "<b>ERROR:</b> " & sTest
				Else
					'Save successful
					sProc = "The record was successfully saved."
				End If
				Select Case Request.QueryString("M")
					Case "A": nMode = 1	'Add
					Case "E": nMode = 0	'Edit
				End Select
			End If
		Else
			nMode = 1	'Add
		End If
		'===========================================================
		
		'If (sTest <> "") Then
		'	sProc = "<b>ERROR:</b> Part Number [" & sTest & "] with the selected dimensions already exists."
		'Else
			'Save the record
		'	sTest = WriteRec("Element", Request.QueryString("M"), nThick)
		'	If (sTest <> "") Then
				'Save error
		'		sProc = "<b>ERROR:</b> " & sTest
		'	Else
				'Save successful
		'		sProc = "The record was successfully saved."
		'	End If
		'	Select Case Request.QueryString("M")
		'		Case "A": nMode = 1	'Add
		'		Case "E": nMode = 0	'Edit
		'	End Select
		'End If
	Else
		sProc = "<b>ERROR:</b> Some required information was not included. The record could not be saved."
	End If
End If

'Check whether this is an edit or a series of new additions
Select Case Request.QueryString("M")
	Case "A"	'Add
		'Test for previous records
		sTest = GetDataValue("SELECT PartID AS RetVal FROM PartPar WHERE (Par1 <> '0') AND (DocID = '" & Request.QueryString("DocID") & "')", Nothing)
		'Define new part number
		sPN = NextPartNumber(Request.QueryString("DocID"))
		sPN = Request.QueryString("DocID") & "-" & sPN
		
		'Choose proper display for first or additional record
		If (sTest <> "") Then
			'Additional record
			sWPN = WaferDocID(Request.QueryString("DocID"))
			sQty = "[Auto-Calc]"
			
			sFields = "  <input type='hidden' name='WPN' value='" & sWPN & "'>"
			sFields = sFields & vbCrLf & "  <input type='hidden' name='Qty' value='" & sQty & "'>"
			
			sForm = "    <tr>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' name='PartNo' size='12' value='" & sPN & "'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='W1' size='6'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='W2' size='6'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='Thick' size='8'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><font face='Verdana' size='2'>" & sWPN & "</font></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><font face='Verdana' size='2'>" & sQty & "</font></td>"
			sForm = sForm & vbCrLf & "    </tr>"
		Else
			'First record
			sQty = "[Auto-Calc]"
			
			sFields = "<input type='hidden' name='Qty' value='" & sQty & "'>"
			
			sForm = "    <tr>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' name='PartNo' size='12' value='" & sPN & "'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='W1' size='6'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='W2' size='6'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='Thick' size='8'></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><select name='WPN' size='1'>"
			sForm = sForm & vbCrLf & GetSelect("Wafer", "")
			sForm = sForm & vbCrLf & "      </select></td>"
			sForm = sForm & vbCrLf & "      <td align='center'><font face='Verdana' size='2'>" & sQty & "</font></td>"
			sForm = sForm & vbCrLf & "    </tr>"
		End If
	Case "E"	'Edit
		'Check current mode
		If (nMode <> 0) Then
			'If not yet saved then retrieve selected record and display
			sPN = Request.QueryString("Item")
			'Test for previous records
			sTest = GetDataValue("SELECT COUNT(PartID) AS RetVal FROM PartPar WHERE (Par1 <> '0') AND (DocID = '" & Request.QueryString("DocID") & "')", Nothing)
			
			If (CInt(sTest) = 1) Then
				'This is the only record, treat it as the first
				sWPN = WaferDocID(Request.QueryString("DocID"))
				sQty = "[Auto-Calc]"
				
				sFields = "<input type='hidden' name='Qty' value='" & sQty & "'>"
				
				sForm = "    <tr>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text'  name='PartNo' size='12' value='" & sPN & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text'onkeyup='javascript:fncheckNo(this)' name='W1' size='6' value='" & GetDataValue("SELECT Par1 AS RetVal FROM PartPar WHERE (PartNo = '" & sPN & "')", Nothing) & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='W2' size='6' value='" & GetDataValue("SELECT Par3 AS RetVal FROM PartPar WHERE (PartNo = '" & sPN & "')", Nothing) & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='Thick' size='8' value='" & GetDataValue("SELECT Par5 AS RetVal FROM PartPar WHERE (PartNo = '" & sPN & "')", Nothing) & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><select name='WPN' size='1'>"
				sForm = sForm & vbCrLf & GetSelect("Wafer", sWPN)
				sForm = sForm & vbCrLf & "      </select></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><font face='Verdana' size='2'>" & sQty & "</font></td>"
				sForm = sForm & vbCrLf & "    </tr>"
			Else
				'Multiple records exist, provide limited selections
				sWPN = WaferDocID(Request.QueryString("DocID"))
				sQty = "[Auto-Calc]"
				
				sFields = "  <input type='hidden' name='WPN' value='" & sWPN & "'>"
				sFields = sFields & vbCrLf & "  <input type='hidden' name='Qty' value='" & sQty & "'>"
				
				sForm = "    <tr>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text' name='PartNo' size='12' value='" & sPN & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='W1' size='6' value='" & GetDataValue("SELECT Par1 AS RetVal FROM PartPar WHERE (PartNo = '" & sPN & "')", Nothing) & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='W2' size='6' value='" & GetDataValue("SELECT Par3 AS RetVal FROM PartPar WHERE (PartNo = '" & sPN & "')", Nothing) & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><input type='text' onkeyup='javascript:fncheckNo(this)' name='Thick' size='8' value='" & GetDataValue("SELECT Par5 AS RetVal FROM PartPar WHERE (PartNo = '" & sPN & "')", Nothing) & "'></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><font face='Verdana' size='2'>" & sWPN & "</font></td>"
				sForm = sForm & vbCrLf & "      <td align='center'><font face='Verdana' size='2'>" & sQty & "</font></td>"
				sForm = sForm & vbCrLf & "    </tr>"
			End If
		End If
End Select

'Select and create display
Select Case nMode
	Case 0	'Edit saved, close window
	
	
%>
<html>

<head>

<!--
// begin - Drop PopUp Window
function endPop() { 
	window.close(this);
} 
// -->
</script>
<meta http-equiv='refresh' content='1;URL=Javascript:endPop();'>
<title>Add Element</title>
</head>


<body bgcolor="#FFFFFF">

<p><font size="4" face="Verdana"><u>Wafer Information</u></font></p>
<p>&nbsp;</p>
<p align="center"><font size="3" face="Verdana"><b>The record was successfully saved.</b></font></p>

</body>
</html>
<%
	Case Else		'(Value = 1) - Reload window
%>
<html>


<script type="text/javascript"> 

var strnum = "0123456789.";

function fncheckNo(ctrl){
    var chrvalue = "";
    var chrvaluetemp = "";
    
    for (i=0; i < ctrl.value.length; i++) 
    {
        chrvaluetemp = ctrl.value.charAt(i);
        if (strnum.indexOf(chrvaluetemp,0) != -1)
        chrvalue += chrvaluetemp;
    }
    ctrl.value = chrvalue;

}
</script>


<head>
<title>Add Element</title>
</head>

<body bgcolor="#FFFFFF">

<font size="3" face="Verdana" color="#C10000"><b><%=sProc %></b></font>

<p><font size="4" face="Verdana"><u>Element Information</u></font><br>
<font face="Verdana" size="2">Please Enter New Part Number Information:</font> 
</p>
<form method="POST" action="add_elem.asp?<% =Request.QueryString %>">
<% =sFields %>
  <table border="0" cellpadding="2" width="100%">
    <tr>
      <td align="center"><strong><font face="Verdana" size="1">Part No.</font></strong></td>
      <td align="center"><strong><font face="Verdana" size="1">Width (A)</font></strong></td>
      <td align="center"><strong><font face="Verdana" size="1">Width (B)</font></strong></td>
      <td align="center"><strong><font face="Verdana" size="1">Thickness w/ Barr.</font></strong></td>
      <td align="center"><strong><font face="Verdana" size="1">Wafer Doc</font></strong></td>
      <td align="center"><strong><font face="Verdana" size="1">Qty.</font></strong></td>
    </tr>
<% =sForm %>
    <!-- <tr>
      <td align="center"><input type="text" name="PartNo" size="12"></td>
      <td align="center"><input type="text" name="W1" size="6"></td>
      <td align="center"><input type="text" name="W2" size="6"></td>
      <td align="center"><input type="text" name="Thick" size="6"></td>
      <td align="center"><input type="text" name="WPN" size="12"></td>
      <td align="center"><input type="text" name="Qty" size="6"></td>
    </tr> -->
    <tr>
      <td align="center" colspan="6"><input type="submit" value="Save Element" name="B1"></td>
    </tr>
  </table>
</form>

<p align="center"><strong><font face="Verdana" size="2"><a href="JavaScript:window.close(this);"  
     onclick="JavaScript:window.opener.location.reload(true);"  
    onMouseOver="window.status = 'Close Window'; return true;">Close Window</a></font></strong></p>
</body>
</html>
<%
End Select
%>