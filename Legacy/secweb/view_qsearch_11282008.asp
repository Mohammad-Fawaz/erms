<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<html>

<head>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Quick Search Tools</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <!--<td width="145" valign="top" bgcolor="#FFFFC8"><%' =sMenu %></td>-->
    <td width="635" valign="top"><p><font face="Verdana" size="5">Quick Search Tools="635" valign="top"><p><font face="Verdana" size="5">Quick Search Tools</font></p>
    <p><form method="POST" action="ret_search.asp">
          <input type="hidden" name="A" value="QSearch">
          <input type="hidden" name="PageSize" value="50">
          <table border="0" cellpadding="2" width="100%">
            <tr>
              <td align="right"><select name="SearchBase" size="1">
                <option value="Documents">Documents (Document Number)</option>
                <option value="Change Orders">Change Orders (Change Number)</option>
                <option value="Orders">Orders (Order Number)</option>
                <option value="Parts">Parts (Part Number)</option>
                <option value="Projects">Projects (Project Number)</option>
                <option value="Tasks">Tasks (Task ID Number)</option>
              </select></td>
              <td><input type="text" name="V" size="30" maxlength="50">
              <input type="submit" value="GO" name="B1"></td>
            </tr>
          </table>
        </form></p>
    </td>
  </tr>
  <tr>
    <td width="100%" colspan="2">
        <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" startspan -->                    
    </td>
  </tr>
</table>
</body>
</html>

