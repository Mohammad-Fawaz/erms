<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Printing Request</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %></td>
    <td width="635" valign="top"><font face="Verdana" size="5">Printing Request</font><p><font face="Verdana" size="2">Please provide the following information. You will have an
    opportunity to attach file(s) after submitting this portion of the data.</font></p>
    <form method="POST" action="proc_req.asp">
    <input type="hidden" name="Request" value="Print">
    <input type="hidden" name="Mode" value="Add">
    <input type="hidden" name="PRID" value="(Number Pending)">
      <div align="center"><center><table border="0" cellpadding="2" cellspacing="0">
        <tr>
          <td align="right" valign="top"><strong><font face="Verdana" size="2">Requested By:</font></strong></td>
          <td valign="top"><select name="PRReqBy" size="1">
          <option selected><% =curUN %></option>
<% =GetSelect("EmpList", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
          <td valign="top"><select name="PRProj" size="1">
          <option selected>SELECT</option>
<% =GetSelect("Project", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Priority:</strong></font></td>
          <td valign="top"><select name="PRPrior" size="1">
          <option selected>SELECT</option>
<% =GetSelect("TaskPriority", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Date Due:</strong></font></td>
          <td valign="top"><input type="text" name="PRDue" size="15"></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong></strong></font></td>
          <td valign="top"><input type="submit" value="Continue Request" name="B1"> <input type="reset" value="Reset Form" name="B2"></td>
        </tr>
      </table>
      </center></div>
    </form>
    <p><font face="Verdana">&nbsp;</font></td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
