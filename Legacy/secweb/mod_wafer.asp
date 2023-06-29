<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_cmnfunc.asp" -->
<!-- #INCLUDE FILE="script/incl_elements.asp" -->
<!-- #INCLUDE FILE="script/incl_ado.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Wafer Information</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
function UpdateQty() {
	if (document.WaferInfo.Thickness.value.length != 0) {
		Qty = parseFloat(document.WaferInfo.Thickness.value) + 0.013		 
		rlength = 3;
		Qty = Math.round(Qty*Math.pow(10,rlength))/Math.pow(10,rlength);
		document.WaferInfo.Qty.value = Qty
	}
}	
function FormCheck() {
	if (document.WaferInfo.Thickness.value.length == 0) {
		alert("Please enter a thickness.")
		return false;
	}
	else {
		return true;
	}
}
</script>
</head>

<body>
<p><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><span style="text-decoration: underline">Wafer 
  Information</span></font></p>
<% 

If (Request.Form("PostBack") <> "") Then
	Set rsWafer = GetADORecordset("SELECT * FROM PartPar WHERE Par1 = '0' AND CDbl(Par5)=" & Request.Form("Thickness") & " AND DocID='" & Request.QueryString("DocID") & "' And Not PartNo='" & Request.Form("PartNo") & "'", Nothing)
	If Not (rsWafer.BOF = True And rsWafer.EOF = True) Then
		ProcessError = "Error: wafer with thickness of " & Request.Form("Thickness") & " exists"
	Else 
		sVals = "'" & Request.QueryString("DocID") & "', "
		sVals = sVals & "'" & Request.Form("PartNo") & "', "
		sVals = sVals & "'" & Request.Form("Ingot") & "', "
		sVals = sVals & "'" & Request.Form("Thickness") & "', "
		sVals = sVals & "'" & ".0005" & "', "
		sVals = sVals & "'" & Request.Form("Qty") & "', "
		sVals = sVals & "'" & Request.Form("Diameter") & "', "
		sVals = sVals & "'" & Request.Form("SliceFormula") & "'"
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
		sParSQL = "INSERT INTO PartPar (DocID, PartNo, MatlPn, Par5, Par6, Par7, Par10, Par11) VALUES (" & sVals & ")"		
		'sPartSQL = "INSERT INTO PartsXRef (DocID, PartNo, PartID, PartDesc) SELECT DocID, PartNo, PartID, ""Thickness: "" & Par5 & ""+/-"" & Par6 & "". Quantity: "" & Par7 & "". Dia: "" & Par10 & "". Slice Formula: "" & Par11 & ""."" FROM PartPar WHERE PartNo = '" & Request.Form("PartNo") & "'"
		Saved = RunSQLCmd("DELETE FROM PartPar WHERE PartNo='" & Request.Form("PartNo") & "'", Nothing) And RunSQLCmd(sParSQL, Nothing) 'And RunSQLCmd("DELETE FROM PartsXRef WHERE PartNo='" & Request.Form("PartNo") & "'", Nothing) And RunSQLCmd(sPartSQL, Nothing)
'======================================================
'======================================================
	End If
'======================================================
'Objects MUST be explicitly destroyed in order to free system resources.
	rsWafer.Close
	Set rsWafer = Nothing
'======================================================
End If

sPartNo = NextPartNumber(Request.QueryString("DocID"))
sIngotNo = IngotNumber(Request.QueryString("DocID"))
sWaferDiameter = WaferDiameter(Request.QueryString("DocID"))
sSliceFormula = SliceFormula(Request.QueryString("DocID"))
%>
<p><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Enter New Part 
  Number Information:</font> &nbsp;&nbsp;&nbsp;<font size='2' face='Verdana, Arial, Helvetica, sans-serif' color='#FF0000'>
  <% 
  If (ProcessError <> "") Then 
  	Response.Write(ProcessError) 
  ElseIf (Saved) Then 
  	Response.Write("(Data Saved - " & Time() & ")")
  End If %></font></p>
<!-- <form name="WaferInfo" action="mod_wafer.asp?<% =SVars %>&DocID=<%=Request.QueryString("DocID")%>" method="post" onSubmit="return FormCheck()"> -->
<form name="WaferInfo" action="mod_wafer.asp?<% =Request.QueryString %>" method="post" onSubmit="return FormCheck()">
  <table width="100%" border="0" cellspacing="0" cellpadding="5">
    <tr> 
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Part 
          No.</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Thickness</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Ingot 
          P/N </font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Qty</font></div></td>
      <td><div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Diameter</font></div></td>
      <td> <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif">Slice 
          Formula</font></div></td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="6"><hr noshade size="3" color="#0075FF"></td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="center"> 
          <input name="PartNo" type="text" size="10" readonly="true" value="<%= IIf(Saved, Request.Form("PartNo"), Request.QueryString("DocID") & "-" & sPartNo) %>">
        </div></td>
      <td><div align="center"> 
          <input name="Thickness" type="text" size="5" value="<%=Request.Form("Thickness")%>" onChange="UpdateQty()">
        </div></td>
      <td><div align="center"> 
	  		<select name="Ingot" <%=IIf(sIngotNo <> "", "onChange=""this.selectedIndex=IngotIndex; alert('Ingot has already been established for this document.');""", "")%>>
			<%=GetSelect("DocIngot", IIf(Request.Form("Ingot") <> "", Request.Form("Ingot"), sIngotNo))%>
			</select>
        </div></td>
      <td><div align="center"> 
          <input name="Qty" type="text" size="5" readonly="true" value="<%= IIf(Saved, Request.Form("Qty"), "[Auto-Calc]")%>">
        </div></td>
      <td><div align="center">
	  		<select name="Diameter" <%=IIf(sWaferDiameter <> "", "onChange=""this.selectedIndex=DiameterIndex; alert('Wafer diameter has already been established for this document.');""", "")%>>
			<option <%=IIf(sWaferDiameter = "1.25", "SELECTED", "")%>>1.25</option>
			<option <%=IIf(sWaferDiameter = "1.06", "SELECTED", "")%>>1.06</option>
			<option <%=IIf(sWaferDiameter = "0.66", "SELECTED", "")%>>0.66</option>
			</select> 
        </div></td>
      <td> <div align="center"> 
          <select name="SliceFormula" <%=IIf(sSliceFormula <> "", "onChange=""this.selectedIndex=FormulaIndex; alert('Slice formula has already been established for this document.');""", "")%>>
            <option <%=IIf(sSliceFormula = "/2", "SELECTED", "")%>>/2</option>
            <option <%=IIf(sSliceFormula = "+.006", "SELECTED", "")%>>+.006</option>
            <option <%=IIf(sSliceFormula = "/2 - .006", "SELECTED", "")%>>/2 - .006</option>
            <option <%=IIf(sSliceFormula = "-.006", "SELECTED", "")%>>-.006</option>
            <option <%=IIf(sSliceFormula = "0.0", "SELECTED", "")%>>0.0</option>
          </select>
        </div></td>
      <td><a href="#" onClick="document.WaferInfo.submit(); return false;"><font face="Verdana, Arial, Helvetica, sans-serif">Save 
        Edit</font></a></td>
    </tr>
    <tr> 
      <td colspan="7"><div align="center"> 
  	  	  <input type="hidden" name="PostBack" value="1">
          <input name="B1" type="submit" value="Submit">
          <input name="B2" type="button" value="Cancel" onClick="window.close()">
          <input name="B3" type="button" value="Finished" onClick="r = confirm('To save on screen data, make sure you SUBMIT the form first. Continue?'); if( r ) { window.close(); window.opener.location.reload(true); }">
        </div></td>
    </tr>
  </table>
</form>
<p><font size="2" face="Verdana, Arial, Helvetica, sans-serif"></font></p>
<script language="JavaScript">
	var FormulaIndex = document.WaferInfo.SliceFormula.selectedIndex
	var DiameterIndex = document.WaferInfo.Diameter.selectedIndex
	var IngotIndex = document.WaferInfo.Ingot.selectedIndex
</script>
</body>
</html>
