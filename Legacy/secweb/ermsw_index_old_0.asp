
<%@ Language=VBScript %>

<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->

<% Application("Company") = "Micropac" %>

<html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns="http://www.w3.org/TR/REC-html40">
<head>
<link rel="File-List" href="ermsw_index_files/filelist.xml">
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMSWeb</title>
    <!--[if !mso]>
    <style>
    v\:*         { behavior: url(#default#VML) }
    o\:*         { behavior: url(#default#VML) }
    .shape       { behavior: url(#default#VML) }
    </style>
    <![endif]--><!--[if gte mso 9]>
    <xml><o:shapedefaults v:ext="edit" spidmax="1027"/>
    </xml><![endif]-->
</head>
<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">
<table border="0" cellpadding="2" cellspacing="0" width="780" height="622">
  <!--<tr>
    <td width="100%" colspan="2" height="90">
    <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" startspan
    <!--webbot bot="Include" i-checksum="42909" endspan 
    </td>
  </tr>-->
  <tr>
    <!--<td width="145" valign="top" bgcolor="#FFFFC8" height="391"><%' =sMenu %></td>-->
    <td width="635" valign="top" height="391"><b><font face="Verdana" size="5">My Home</font></b>
        <blockquote>
        <p><font face="Verdana" size="2">Select from the options available in the menu to the
        left. This menu will be available from all points within ERMSWeb.</font></p>
        </blockquote>
    <form method="POST" action="ret_search.asp">
      <input type="hidden" name="A" value="QSearch">
      <input type="hidden" name="PageSize" value="50">
      <table border="0" cellpadding="2" width="100%" height="326">
        <tr>
          <td width="100%" colspan="2" height="22">
          <font face="Verdana" size="4">Quick Search
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </font>
          <!--<a href="view_syssearch.asp">
              <input type="button" value="Advanced Search" name="B2" tabindex="2"></a>&nbsp;
          <a href="view_fcab.asp">
              <input type="button" value="File Cabinet" name="B3" tabindex="3"></a>--></td>
        </tr>
        <tr>
              <td align="right" height="29"><select name="SearchBase" size="1">
                <option value="Documents">Documents (Document Number)</option>
                <option value="Change Orders">Change Orders (Change Number)</option>
                <option value="Orders">Orders (Order Number)</option>
                <option value="Parts">Parts (Part Number)</option>
                <option value="Projects">Projects (Project Number)</option>
                <option value="Tasks">Tasks (Task ID Number)</option>
              </select></td>
              <td height="29"><input type="text" name="V" size="30" maxlength="50">
              <input type="submit" value="GO" name="B1" tabindex="1"></td>
            </tr>
        <tr>
              <td align="right" height="17" colspan="2"><!--[if gte vml 1]><v:line id="_x0000_s1027"
 alt="" style='position:relative;left:0;text-align:left;top:0;z-index:1'
 from="123.75pt,209.25pt" to="594.75pt,209.25pt" strokecolor="olive"
 strokeweight="1.5pt"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:1;left:161px;top:263px;width:630px;height:2px'><img
width=630 height=2 src="ermsw_index_files/image001.gif" v:shapes="_x0000_s1027"></span><![endif]></td>
            </tr>
        <tr>
              <td align="right" height="46">
              <p align="left"><font size="4">My Information</font></td>
              <td height="46">&nbsp;</td>
            </tr>
        <tr>
              <td align="left" height="18">
              <p style="text-indent: 40"><b><font size="2">
              <a href="act_todo.asp">Action Listings</a></font></b></td>
              <td height="18"><b><font size="2">
              <a href="file://../../../ERMS/ERMS42.exe">Administration Tool Set</a></font></b></td>
            </tr>
        <tr>
              <td align="left" height="18">
              <p style="text-indent: 40"><b><font size="2"><a href="upd_pw.asp">
              Change Password</a></font></b></td>
              <td height="18"></td>
            </tr>
        <tr>
              <td align="left" height="18">
              <p style="text-indent: 40"><font size="2">
              <a href="view_syssearch.asp">My Reports</a></font></td>
              <td height="18"></td>
            </tr>
        <tr>
              <td align="left" height="80" colspan="2">
              &nbsp;</td>
            </tr>
        <tr>
              <td align="left" height="20" colspan="2">
              <p><!--[if gte vml 1]><v:line
 id="_x0000_s1029" alt="" style='position:relative;left:0;text-align:left;
 top:0;z-index:1' from="121.5pt,303pt" to="592.5pt,303pt" strokecolor="olive"
 strokeweight="1.5pt"/><![endif]--><![if !vml]><span style='mso-ignore:vglayout;
position:absolute;z-index:1;left:161px;top:473px;width:630px;height:2px'><img
width=630 height=2 src="ermsw_index_files/image001.gif" v:shapes="_x0000_s1029"></span><![endif]></td>
            </tr>
        <tr>
              <td align="right" colspan="2" height="87"><blockquote>
      <p align="left" style="margin-top: 0; margin-bottom: -5">
      <span style="vertical-align: bottom">
      <font face="Verdana" size="2">If need help using the system, please contact
      Document Control.</font></span></p>
      <p align="left" style="margin-top: 0; margin-bottom: -5">&nbsp;</p>
      <p align="left" style="margin-top: 0; margin-bottom: -5">
      <span style="vertical-align: bottom">
      <font face="Verdana" size="2">If you need help with a specific technical problem, see
      the <a href="supp_links.asp"><strong>Support Links</strong></a> area to
      contact the ERMS System Support Team</font><font face="Verdana" size="3">.</font></span></p>
    </blockquote>
              </td>
            </tr>
      </table>
    </form>
    </td>
  </tr>
  <tr>
    <td width="100%" colspan="2" height="120">
    <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" startspan -->
    <!--webbot bot="Include" i-checksum="18164" endspan -->
    </td>
  </tr>
</table>
<!-- <p>Session ID = <% =Session("SI") %></p> -->
</body>
</html>