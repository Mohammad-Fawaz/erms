<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_html.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<html>

<head>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>New Document/Drawing Number Request</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %></td>
    <td width="635" valign="top"><font face="Verdana" size="5">New Document/Drawing Number
    Request</font><p><font face="Verdana" size="2">Please provide the following information to
    create the record. You will have an opportunity to attach file(s) after submitting this
    portion of the data.</font></p>
    <form method="POST" action="proc_req.asp">
      <input type="hidden" name="Request" value="Doc">
      <input type="hidden" name="Mode" value="Add">
      <div align="center"><center><table border="0" cellpadding="2" cellspacing="0">
        <tr>
          <td align="right" valign="top"><strong><font face="Verdana" size="2">Requested By:</font></strong></td>
          <td valign="top"><select name="DocReqBy" size="1">
            <option selected><% =curUN %></option>
<% =GetSelect("EmpList", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Discipline:</strong></font></td>
          <td valign="top"><select name="DocDisc" size="1">
          <option selected>SELECT</option>
<% =GetSelect("Discipline", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
          <td valign="top"><select name="DocProj" size="1">
          <option selected>SELECT</option>
<% =GetSelect("Project", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Document Type:</strong></font></td>
          <td valign="top"><select name="DocType" size="1">
          <option selected>SELECT</option>
<% =GetSelect("DocType", "") %>
          </select></td>
        </tr>
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Description:</strong></font></td>
          <td valign="top"><textarea rows="3" name="DocDesc" cols="40" wrap="physical"></textarea></td>
        </tr>
        <!-- <tr>          <td align="right" valign="top"><font face="Verdana" size="2"><strong>Additional Notes:</strong></font></td>          <td valign="top"><textarea rows="3" name="DocNotes" cols="40" wrap="physical"></textarea></td>        </tr> -->
        <tr>
          <td align="right" valign="top"><font face="Verdana" size="2"><strong><em>{Document Number}</em>:</strong></font></td>
          <td valign="top"><input type="text" name="DocID" size="20" value="(Number Pending)"> <font face="Verdana" size="1"><em>(Default Provided on Save...)</em></font></td>
        </tr>
        <tr>
          <td align="right" valign="top"></td>
          <td valign="top"><input type="submit" value="Continue Request" name="B1"> <input type="reset" value="Reset Form" name="B2"></td>
        </tr>
      </table>
      </center></div>
    </form>
    <p>&nbsp;</td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
