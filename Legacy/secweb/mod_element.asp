<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="script/incl_elements.asp" -->
<!-- #INCLUDE FILE="script/incl_ado.asp" -->
<%

If (Request.Form("PostBack") <> "") Then

	If (Request.Form("WaferPN") = "[Auto-Calc]" Or Request.Form("SaveEdit") = "1") Then ' retrieve wafer P/N based on thickness
		Set rsWafer = GetADORecordset("SELECT PartNo, Par5, Par10 FROM PartPar WHERE Par1 = '0' AND CDbl(Par5)=" & Request.Form("Thickness") & " AND DocID = '" & WaferDocID(Request.QueryString("DocID")) & "'", Nothing)
	Else ' If first element, get wafer data from wafer P/N
		Set rsWafer = GetADORecordset("SELECT PartNo, Par5, Par10 FROM PartPar WHERE Par1 = '0' AND PartNo= '" & Request.Form("WaferPN") & "'", Nothing)		
	End If
	If Not (rsWafer.BOF = True And rsWafer.EOF = True) Then ' we found one
		Thickness = rsWafer("Par5")
		sWaferNo = rsWafer("PartNo")
		If Not IsNull(rsWafer("Par10")) Then
			dblWaferDiameter = CDbl(rsWafer("Par10"))
		End If	
		
	ElseIf (Request.Form("WaferPN") = "[Auto-Calc]") Then ' none found with thickness, make a new one
		Thickness = Request.Form("Thickness")
		sWaferNo = NewWafer(Request.QueryString("DocID"), Thickness)
		Set rsWaferDiameter = GetADORecordset("SELECT Par10 FROM PartPar WHERE PartNo = '" & sWaferNo & "'", Nothing)
		dblWaferDiameter = rsWaferDiameter("Par10")
		rsWaferDiameter.Close
'======================================================
'Objects MUST be explicitly destroyed in order to free system resources.
		Set rsWaferDiameter = Nothing
'======================================================
	Else ' first element, but wafer P/N not found
		ProcessError = "error: invalid wafer P/N."
	End If
	rsWafer.Close
'======================================================
'Objects MUST be explicitly destroyed in order to free system resources.
	Set rsWafer = Nothing
'======================================================
	If (Request.Form("SaveEdit") = "0" And dblWaferDiameter <> "") Then
		dblThickness = CDbl(Thickness)	
		Par7 = ElementQty(dblThickness, dblWaferDiameter, Request.Form("WidthA"))
	Else
		Par7 = Request.Form("Qty")
	End If
	
	If(Par7="") Then
	 Par7=0
	End if
	
	
	sVals = "'" & Request.QueryString("DocID") & "', "
	sVals = sVals & "'" & Request.Form("PartNo") & "', "
	sVals = sVals & "'" & sWaferNo & "', "
	sVals = sVals & "'" & Request.Form("WidthA") & "', "
	If (CDbl(Request.Form("WidthA")) < 0.050) Then
		sVals = sVals & "'.001', "
	Else
		sVals = sVals & "'.002', "
	End If
	sVals = sVals & "'" & Request.Form("WidthB") & "', "
	If (CDbl(Request.Form("WidthB")) < 0.050) Then
		sVals = sVals & "'.001', "
	Else
		sVals = sVals & "'.002', "
	End If
	sVals = sVals & "'" & Thickness & "', "
	sVals = sVals & "'.0005', "
	sVals = sVals & "'" & Par7 & "'"
'======================================================
'======================================================
'This is causing problems.
'1.	The [PartsXRef] record should be written first in irder to get a 
'		viable [PartID] to use in referencing both records properly.
'2.	The [PartID] field in the [PartPar] table should be changed to a
'		{Number} type in order to bypass automatic numbering and 
'		provide the proper reference.
'3.	Multiple saves and deletes using the [RunSQLCmd] function 
'		are not advised in order to track successful data operations.
'======================================================
	sParSQL = "INSERT INTO PartPar (DocID, PartNo, MatlPn, Par1, Par2, Par3, Par4, Par5, Par6, Par7) VALUES (" & sVals & ")"
	'sPartSQL = "INSERT INTO PartsXRef (DocID, PartNo, PartID, PartDesc) SELECT DocID, PartNo, PartID, ""Size: "" & Par1 & "" +/- "" & Par2 & "" x "" & Par3 & "" +/- "" & Par4 & "". Thickness: "" & Par5 & ""+/-"" & Par6 & "". Quantity: "" & Par7 & "". Wafer No: "" & MatlPn FROM PartPar WHERE PartNo = '" & Request.Form("PartNo") & "'"
    
	If ProcessError = "" Then    
		Saved = RunSQLCmd("DELETE FROM PartPar WHERE PartNo='" & Request.Form("PartNo") & "'", Nothing) And RunSQLCmd(sParSQL, Nothing) 'And RunSQLCmd("DELETE FROM PartsXRef WHERE PartNo='" & Request.Form("PartNo") & "'", Nothing) And RunSQLCmd(sPartSQL, Nothing)		 		
	End If
	
		
'======================================================
'======================================================
End If

sPartNo = NextPartNumber(Request.QueryString("DocID"))

Set rsElements = GetADORecordset("SELECT * FROM PartPar WHERE NOT Par1 = '0' AND DocID = '" & Request.QueryString("DocID") & "'", Nothing)
If (rsElements.EOF = True And rsElements.BOF = True) Then
	HasElements = False
Else
	HasElements = True
End If 
'======================================================
'Objects MUST be explicitly destroyed in order to free system resources.
rsElements.Close
Set rsElements = Nothing
'======================================================
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Element Information</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function FormCheck() {
	if(document.ElementInfo.WidthA.value.length == 0) {
		alert("Please enter value for Width (A).");
		return false;
	}
	else if(document.ElementInfo.WidthB.value.length == 0) {
		alert("Please enter value for Width (B).");
		return false;
	}
	else if(document.ElementInfo.Thickness.value.length == 0) {
		alert("Please enter value for thickness.");
		return false;
	}
	return true;
}
function PageLoad() {
	WidthAChanged = false
	document.body.w
}
</script>
</head>

<body onLoad="PageLoad()">
<p><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><span style="text-decoration: underline">Element Information</span></font></p>
<p><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Enter New Part 
  Number Information:</font> &nbsp;&nbsp;&nbsp;<font size='2' face='Verdana, Arial, Helvetica, sans-serif' color='#FF0000'>
  <% 
  If (ProcessError <> "") Then 
  	Response.Write(ProcessError) 
  ElseIf (Saved) Then 
  	Response.Write("(Data Saved - " & Time() & ")")
  End If %></font></p>
<!-- <form name="ElementInfo" action="mod_element.asp?<% =SVars %>&DocID=<%=Request.QueryString("DocID")%>" method="post" onSubmit="return FormCheck();"> -->
<form name="ElementInfo" action="mod_element.asp?<% =Request.QueryString %>" method="post" onSubmit="return FormCheck();">
  <table width="100%" border="0" cellspacing="0" cellpadding="5">
    <tr> 
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Part 
          No.</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Width 
          (A)</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Width 
          (B)</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Thick 
          w/Bar</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Wafer 
          P/N</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Qty</font></div></td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="6"><hr noshade size="3" color="#0075FF"></td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="center"> 
          <input name="PartNo" type="text" size="10" readonly="true" value="<% Response.Write(IIf(Saved, Request.Form("PartNo"), Request.QueryString("DocID") & "-" & sPartNo)) %>">
        </div></td>
      <td><div align="center"> 
          <input name="WidthA" type="text" size="5" value="<%= Request.Form("WidthA") %>" onChange="if(!WidthAChanged) { document.ElementInfo.WidthB.value = this.value; WidthAChanged = true; }">
        </div></td>
      <td><div align="center"> 
          <input name="WidthB" type="text" size="5" value="<%= Request.Form("WidthB") %>">
        </div></td>
      <td><div align="center"> 
          <input name="Thickness" type="text" size="5" value="<%=IIf(Not HasElements, "[Auto-Calc]", Thickness)%>" <%=IIf(Not HasElements, "readonly='true'", "") %>>
        </div></td>
      <td><div align="center"> 
	      <input name="WaferPN" type="text" size="10" value="<%= IIf(Saved, sWaferNo, IIf(HasElements, "[Auto-Calc]", "")) %>" <%=IIf(HasElements, "readonly='true'", "") %>>
        </div></td>
      <td><div align="center"> 
          <input name="Qty" type="text" value="<% Response.Write(IIf(Saved, Par7, "[Auto-Calc]")) %>" size="5" <%=IIf(Saved, "", "readonly='true'") %>>
        </div></td>
      <td><a href="#" onClick="document.ElementInfo.submit(); return false;"><font face="Verdana, Arial, Helvetica, sans-serif">Save 
        Edit</font></a></td>
    </tr>
    <tr> 
      <td colspan="7"><div align="center"> 
	  	  <input type="hidden" name="PostBack" value="1">
          <input type="hidden" name="SaveEdit" value="<% Response.Write(IIf(Saved, "1", "0"))%>">
          <input name="B1" type="submit" value="Submit">
          <input name="B2" type="button" value="Cancel" onClick="window.close()">
          <input name="B3" type="button" value="Finished" onClick="r = confirm('To save on screen data, make sure you SUBMIT the form first. Continue?'); if( r ) { window.close(); window.opener.location.reload(true); }">
        </div></td>
    </tr>
  </table>
</form>
<p><font size="2" face="Verdana, Arial, Helvetica, sans-serif"></font></p>
</body>
</html>
