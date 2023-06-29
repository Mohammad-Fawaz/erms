<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
<%
Dim sList

sList = GetWFSelect("WTemplate", "", "")

%>

<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Modify Workflow Template</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
 
  <tr>
    <td width="635" valign="top"><font face="Verdana" size="5">Edit/Modify Workflow Template</font>
    <p><font face="Verdana" size="2">Please select a template from the supplied list to open for modification.</font></p>
    <form method="POST" action="wf_addedit.asp">
      <input type="hidden" name="Mode" value="N">
      <div align="center"><center><table border="0" cellpadding="2" cellspacing="0" width="100%">
        <tr>
          <td align="right" nowrap><font face="Verdana" size="2"><strong>Template Name:</strong></font></td>
          <td><select name="TID" size="1">
            <option selected>SELECT</option>
<% =sList %>
          </select></td>
        </tr>
        <tr>
          <td align="center" valign="top" colspan="2"><input type="submit" value="Open Template" name="B1"></td>
        </tr>
      </table>
      </center></div>
    </form>
    <p align="center"><font face="Verdana" size="2"><strong>
    <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
    <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
    <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
    <a href="wf_help.asp">Help Files and Instructions</a></strong></font></p>
    <p align="center">&nbsp;</td>
  </tr>
  
</table>
</body>
</html>
