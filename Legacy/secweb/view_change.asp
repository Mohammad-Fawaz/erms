<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Change Order Information</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %></td>
    <td width="635" valign="top"><font face="Verdana" size="5">Change Order Information</font><p><font face="Verdana" size="2">Change Order information is gathered using a [LIKE] search. You
    may use a partial number or wildcard characters for your search (see below).</font></p>
    <form method="POST" action="ret_listing.asp">
    <input type="hidden" name="Listing" value="Changes">
      <div align="center"><center><table border="0" cellpadding="2" cellspacing="0">
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>CO Num (LIKE*):</strong></font></td>
          <td><strong><font face="Verdana" size="2"><input type="text" name="CO" size="20"></font></strong></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Change Type:</strong></font></td>
          <td><strong><font face="Verdana" size="2"><select name="ChTypeMod" size="1">
            <option selected value="=">= (Equal To)</option>
            <option value="NotEqual">&lt;&gt; (Not Equal To)</option>
          </select><select name="ChType" size="1">
            <option>SELECT</option>
<% =GetSelect("ChType", "") %>
          </select></font></strong></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Status:</strong></font></td>
          <td><strong><font face="Verdana" size="2"><select name="ChStatusMod" size="1">
            <option selected value="=">= (Equal To)</option>
            <option value="NotEqual">&lt;&gt; (Not Equal To)</option>
          </select><select name="ChStatus" size="1">
            <option>SELECT</option>
<% =GetSelect("ChStatus", "") %>          </select></font></strong></td>
        </tr>
        <tr>
          <td align="right"><font face="Verdana" size="2"><strong>Eff. Date:</strong></font></td>
          <td><strong><font face="Verdana" size="2"><select name="ChEffDateMod" size="1">
            <option selected value="GT">&gt; (Greater Than)</option>
            <option value="LT">&lt; (Less Than)</option>
          </select><input type="text" name="ChEffDate" size="15"></font></strong></td>
        </tr>
        <tr>
          <td colspan="2" align="center"><input type="submit" value="Get Change Order Listing" name="B1"></td>
        </tr>
      </table>
      </center></div>
    </form>
    <p><font face="Verdana" size="2"><u><strong>* Valid Search String Examples</strong></u></font></p>
    <div align="center"><center><table border="2" cellpadding="4" cellspacing="1" width="70%">
      <tr>
        <td bgcolor="#000000" align="center"><font face="Verdana" size="2" color="#FFFFFF"><strong>Search
        String</strong></font></td>
        <td bgcolor="#000000" align="center"><font face="Verdana" size="2" color="#FFFFFF"><strong>Example
        Returns</strong></font></td>
      </tr>
      <tr>
        <td align="center" valign="top"><strong><font face="Verdana" size="2">01034</font></strong></td>
        <td valign="top"><ul>
          <li><font face="Verdana" size="2"><strong>01034</strong></font><font face="Verdana" size="2" color="#808080">8</font></li>
          <li><font face="Verdana" size="2"><strong>01034</strong></font><font face="Verdana" size="2" color="#808080">29</font></li>
          <li><font face="Verdana" size="2"><strong>01034</strong></font><font face="Verdana" size="2" color="#808080">942</font></li>
        </ul>
        </td>
      </tr>
      <tr>
        <td align="center" valign="top"><font face="Verdana" size="2"><strong>*013*</strong></font></td>
        <td valign="top"><ul>
          <li><font face="Verdana" size="2" color="#808080">9</font><font face="Verdana" size="2"><strong>013</strong></font><font face="Verdana" size="2" color="#808080">862</font></li>
          <li><font face="Verdana" size="2" color="#808080">624</font><font face="Verdana" size="2"><strong>013</strong></font><font face="Verdana" size="2" color="#808080">2</font></li>
        </ul>
        </td>
      </tr>
      <tr>
        <td align="center" valign="top"><font face="Verdana" size="2"><strong>*97*8</strong></font></td>
        <td valign="top"><ul>
          <li><font face="Verdana" size="2" color="#808080">68</font><font face="Verdana" size="2"><strong>97</strong></font><font face="Verdana" size="2" color="#808080">22</font><font face="Verdana" size="2"><strong>8</strong></font></li>
          <li><font face="Verdana" size="2" color="#808080">26</font><font face="Verdana" size="2"><strong>97</strong></font><font face="Verdana" size="2" color="#808080">0</font><font face="Verdana" size="2"><strong>8</strong></font></li>
          <li><font face="Verdana" size="2" color="#808080">0</font><font face="Verdana" size="2"><strong>97</strong></font><font face="Verdana" size="2" color="#808080">642</font><font face="Verdana" size="2"><strong>8</strong></font></li>
        </ul>
        </td>
      </tr>
    </table>
    </center></div><p>&nbsp; </td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
