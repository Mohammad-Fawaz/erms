<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>
<head>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Document Information</title>
</head>
<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">
<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2">     
    </td>
  </tr>
  <tr>
    
    <td width="635" valign="top"><font face="Verdana" size="5">Elements/Wafers</font>
      <p><center> </p>
      <table width="500" border="0" cellpadding="5" cellspacing="0">
        <tr>
          <td> <table width="100%" border="1" cellspacing="0" cellpadding="0">
              <tr>
                <td><form method="POST" action="ret_search.asp" name="SearchForm">
					<input type="hidden" name="SearchBase" value="DocElement">
					<input type="hidden" name="A" value="QSearch">
					<input type="hidden" name="V" value="N/A">
                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                      <tr>
                        <td> <p align="center"><span style="text-decoration: underline"><font face="Verdana" size="2"><strong>Search
                            by Base Document Number:</strong></font></span><font size="1">
                            </font></p>
                          <p align="center">
                            <input name="DocID1" type="text" size="2" onKeyUp="if(this.value.length == 3) document.SearchForm.DocID2.focus()">
                            -
                            <input type="text" name="DocID2" size="6">
                          </p>
                          <p align="center">
                            <input name="B1" type="submit" value="Submit">
                          </p></td>
                      </tr>
                    </table>
                  </form></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td><table width="100%" border="1" cellspacing="0" cellpadding="0">
              <tr>
                <td><form name="F2" method="POST" action="ret_search.asp">
					<input type="hidden" name="Searchbase" value="DocElement">
					<input type="hidden" name="A" value="QSearch">
					<input type="hidden" name="V" value="N/A">
					<input name="B2" type="hidden" value="Submit">
                    <table width="100%" border="0" cellspacing="0" cellpadding="3">
                      <tr>
                        <td> <p align="center"><span style="text-decoration: underline"><font face="Verdana" size="2"><strong>Select
                            from List:</strong></font></span><font size="1"> </font></p>
                          <p align="center">
                            <select name="DocID" onChange="if(this.options[this.selectedIndex].value.length &gt; 0) { document.F2.submit(); }">
                              <option></option>
                              <% = GetSelect("DocElement", "") %>
                            </select>
                          </p></td>
                      </tr>
                    </table>
                  </form></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td align="right"><form method="POST" action="ret_search.asp">
              <input type="hidden" name="SearchBase" value="DocElement">
	    	<input type="hidden" name="A" value="QSearch"><input type="hidden" name="V" value="N/A"><table width="100%" border="1" cellspacing="0" cellpadding="0">
              <tr>
                <td><table width="100%" border="0" cellspacing="0" cellpadding="5">
                  <tr>
                    <td colspan="2"> <div align="left">
                            <p align="center"><span style="text-decoration: underline"><font face="Verdana" size="2"><strong>Query
                              / Search Criteria:</strong></font></span></p>
                      </div></td>
        </tr>
        <tr>
          <td align="right"><div align="left"><font size="1">Search for:
              <input name="Wafer" type="checkbox" value="1">
              Wafer(s)
              <input name="Element" type="checkbox" value="1">
              Element(s) </font></div></td>
          <td align="right"><div align="left"><font size="1">Search Operator:
              <select name="SearchOperator">
                <option>AND</option>
                <option>OR</option>
              </select>
              </font></div></td>
        </tr>
        <tr>
          <td colspan="2" align="right"><div align="left"><font size="1">Search
              in Description for:
              <input name="Description" type="text" size="20">
              </font></div></td>
        </tr>
        <tr>
          <td colspan="2" align="right"><div align="left"><font size="1">Find
              Thickness:
              <input name="Thickness" type="text" size="5">
              &nbsp;&nbsp;&nbsp; +
              <input name="RangePlus" type="text" value="0" size="3">
              / -
              <input name="RangeMinus" type="text" value="0" size="3">
              (Range) </font></div></td>
        </tr>
        <tr>
          <td colspan="2" align="right"><div align="left"><font size="1">--- Additional
              Search Criteria Specifically for Elements ---</font></div></td>
        </tr>
        <tr>
          <td align="right"><div align="left"><font size="1">Width (Dim A):
              <input name="ElementWidth" type="text" size="3">
              </font></div></td>
          <td align="right"><div align="left"><font size="1">Length</font><font size="1">
              (Dim B):
              <input name="ElementLength" type="text" size="3">
              </font></div></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input name="B3" type="submit" value="Submit"></td>
        </tr>
      </table></td>
  </tr>
</table></form>
</td> </tr> </table></center> </div>
<div align="center"></div>
<p>&nbsp;</td> </tr>
<tr>
  <td width="100%" colspan="2">   
  </td>
</tr></table>
</body>
</html>
