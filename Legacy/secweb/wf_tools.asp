<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1a.asp" -->
<html>

<head>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>ERMS Workflow</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2">
    <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %>
</td>
    <td width="635" valign="top"><font face="Verdana" size="5">ERMS Workflow</font>
    <dl>
      <dt><font face="Verdana" size="4"><a href="wf_rtgroups.asp">Workflow Routing Groups</a></font></dt>
      <dd><font face="Verdana" size="2">Workflow routing groups provide a rich basis for action
        assignment. Create or modify groups and add or remove members all from a single interface.</font></dd>
    </dl>
    <dl>
      <dt><font face="Verdana" size="4"><a href="wf_add_act.asp">Create Workflow Actions</a>
        &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a></font></dt>
      <dd><font face="Verdana" size="2">Assign default values and parameters to standard actions
        which are used in the creation of workflow tasks.</font></dd>
    </dl>
    <dl>
      <dt><font face="Verdana" size="4"><a href="wf_add_temp.asp">Create Workflow Template</a>
        &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a></font></dt>
      <dd><font face="Verdana" size="2">Create a reusable template to assign specific actions as
        process steps used in the creation of workflow tasks. When adding Reject 
      steps place them at the end of the workflow sequence and make the first 
      word of the description Rework-.</font></dd>
    </dl>
    <dl>
      <dt><font face="Verdana" size="4"><a href="wf_gen_tasks.asp">Add Workflow </a></font>
      <a href="wf_gen_tasks.asp"><font face="Verdana" size="4">to Request</font></a></dt>
      <dd><font face="Verdana" size="2">Select an available template and 
      associate it to an existing request (Change, Document etc..).</font></dd>
    </dl>
    <dl>
      <dt><font face="Verdana" size="4"><a href="wf_help.asp">Help Files and Instructions</a></font></dt>
      <dd><font face="Verdana" size="2">Basic information covering the steps involved in creating
        all the pieces and instructional information on what should be included where.</font></dd>
    </dl>
    <p>&nbsp;</td>
  </tr>
  <tr>
    <td width="100%" colspan="2">
    <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>