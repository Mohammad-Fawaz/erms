<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<html>

<head>
<script language="JavaScript">
<!--
// begin - Info PopUp Window
function iPop(sel) { 
	window.open(sel, "InfoPop", "toolbar=yes,width=660,height=500,status=no,scrollbars=yes,resize=yes,menubar=yes");
} 
// -->
</script>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMS Workflow Help</title>
</head>

<body bgcolor="#FFFFFF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  
  <tr>  
    <td width="635" valign="top"><font face="Verdana" size="5">ERMS Workflow Help</font><ul>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#Intro')" onMouseOver="window.status = 'Get Help'; return true;">Introduction - The Workflow Process In a Nutshell</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#AboutGroups')" onMouseOver="window.status = 'Get Help'; return true;">About Workflow Groups</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#CreateGroups')" onMouseOver="window.status = 'Get Help'; return true;">Creating Workflow Groups and Adding Members</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#AboutActions')" onMouseOver="window.status = 'Get Help'; return true;">About Workflow Actions</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#CreateActions')" onMouseOver="window.status = 'Get Help'; return true;">Creating Actions</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#AboutTemp')" onMouseOver="window.status = 'Get Help'; return true;">About Workflow Templates and Items</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#CreateTemp')" onMouseOver="window.status = 'Get Help'; return true;">Creating Templates and Adding Action Items</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#AboutTaskGen')" onMouseOver="window.status = 'Get Help'; return true;">About Task Generation</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#TaskGen')" onMouseOver="window.status = 'Get Help'; return true;">Generating Workflow Tasks</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#ModTasks')" onMouseOver="window.status = 'Get Help'; return true;">Adding and Modifying Workflow Tasks</a></strong></font></li>
      <li><font face="Verdana" size="3"><strong><a href="javascript:iPop('wf_dirhelp.htm#UpdTasks')" onMouseOver="window.status = 'Get Help'; return true;">Workflow Operations - Updating Workflow Tasks</a></strong></font></li>
    </ul>
    <p>&nbsp;</p>
    <p align="center"><font face="Verdana" size="2"><strong>
    <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
    <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
    <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
    <a href="wf_help.asp">Help Files and Instructions</a></strong></font></p></td>
  </tr>  
</table>
</body>
</html>
