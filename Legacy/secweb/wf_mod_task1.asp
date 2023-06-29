<%@ Language=VBScript %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
<%


%>
<link rel="stylesheet" type="text/css" href="../pg_style.css">
<title>Modify Workflow Task</title>
</head>

<body bgcolor="#FFFFFF" link="#000080" vlink="#000080" alink="#0000FF" topmargin="5" leftmargin="5">

<table border="0" cellpadding="2" cellspacing="0" width="780">
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
</td>
  </tr>
  <tr>
    <td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %>
</td>
    <td width="635" valign="top"><font face="Verdana" size="5">Modify Workflow Task</font><font face="Verdana" size="2"> &#149; <a href="wf_mod_task1.asp"><strong>Refresh View</strong></a></font>
    <form method="POST" action="wf_proc_tasks.asp">
      <div align="center"><div align="center"><center><table border="1" cellpadding="2" cellspacing="0" width="100%">
        <tr>
          <td valign="top" nowrap bgcolor="#FFFFFF"><font face="Verdana" size="3"><strong>Task
          Information</strong></font></td>
        </tr>
        <tr>
          <td valign="top"><table border="0" cellpadding="2" width="100%">
            <tr>
              <td align="right"><font face="Verdana" size="2"><strong>Task ID:</strong></font></td>
              <td><font face="Verdana" size="2">[]</font></td>
              <td align="right"><font face="Verdana" size="2"><strong>Justification:</strong></font></td>
              <td colspan="3"><font face="Verdana" size="2">[]</font></td>
            </tr>
            <tr>
              <td align="right"><font face="Verdana" size="2"><strong>Project:</strong></font></td>
              <td colspan="5"><font face="Verdana" size="2">[]</font></td>
            </tr>
            <tr>
              <td align="right"><font face="Verdana" size="2"><strong>Start:</strong></font></td>
              <td><font face="Verdana" size="2">[]</font></td>
              <td align="right"><font face="Verdana" size="2"><strong>Finish:</strong></font></td>
              <td><font face="Verdana" size="2">[]</font></td>
              <td align="right"><font face="Verdana" size="2"><strong>Due:</strong></font></td>
              <td><font face="Verdana" size="2">[]</font></td>
            </tr>
            <tr>
              <td align="right" nowrap><font face="Verdana" size="2"><strong>Hrs/Min:</strong></font></td>
              <td><input type="text" name="THrs" size="5" value="0"> / <input type="text" name="TMin" size="5" value="0"></td>
              <td align="right"><font face="Verdana" size="2"><strong>Completed:</strong></font></td>
              <td colspan="3"><input type="checkbox" name="TComplete" value="Y"><font face="Verdana" size="2"><strong>Date:</strong></font><input type="text" name="TFinishDate" size="15"></td>
            </tr>
            <tr>
              <td align="right" nowrap><font face="Verdana" size="2"><strong>Cost ($):</strong></font></td>
              <td><input type="text" name="TCost" size="12" value="0"></td>
              <td align="right"><font face="Verdana" size="2"><strong>Send:</strong></font></td>
              <td colspan="3"><input type="checkbox" name="WSend" value="Y"><select name="WSend1" size="1">
                <option selected value="FORWARD">FORWARD</option>
                <option value="BACK">BACK</option>
              </select></td>
            </tr>
            <tr>
              <td align="center" colspan="6"><input type="submit" value="Update Task" name="B4"></td>
            </tr>
          </table>
          </td>
        </tr>
      </table>
      </center></div></div>
    </form>
    <table border="1" cellpadding="2" width="100%" cellspacing="0">
      <tr>
        <td valign="top"><table border="0" cellpadding="2" width="100%">
          <tr>
            <td colspan="4"><strong><font face="Verdana" size="3">Add Notes</font></strong></td>
          </tr>
          <tr>
            <td bgcolor="#C0C0C0"><strong><font face="Verdana" size="1">Date</font></strong></td>
            <td bgcolor="#C0C0C0"><strong><font face="Verdana" size="1">From</font></strong></td>
            <td bgcolor="#C0C0C0"><strong><font face="Verdana" size="1">Note Type</font></strong></td>
            <td bgcolor="#C0C0C0"><strong><font face="Verdana" size="1">Subject</font></strong></td>
          </tr>
          <tr>
            <td valign="top"><font face="Verdana" size="2"></font></td>
            <td valign="top"><font face="Verdana" size="2"></font></td>
            <td valign="top"><font face="Verdana" size="2"></font></td>
            <td valign="top"><font face="Verdana" size="2"></font></td>
          </tr>
        </table>
        </td>
      </tr>
      <tr>
        <td><table border="0" cellpadding="2" width="100%">
          <tr>
            <td colspan="3"><font face="Verdana" size="3"><strong>Add Attachments</strong></font></td>
          </tr>
          <tr>
            <td bgcolor="#C0C0C0"><font face="Verdana" size="1"><strong>File Name</strong></font></td>
            <td bgcolor="#C0C0C0"><font face="Verdana" size="1"><strong>Description</strong></font></td>
            <td bgcolor="#C0C0C0"><font face="Verdana" size="1"><strong>Print Size</strong></font></td>
          </tr>
          <tr>
            <td valign="top"><font face="Verdana" size="2"></font></td>
            <td valign="top"><font face="Verdana" size="2"></font></td>
            <td valign="top"><font face="Verdana" size="2"></font></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    <p align="center"><font face="Verdana" size="2"><strong>
    <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
    <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
    <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
    <a href="wf_help.asp">Help Files and Instructions</a></strong></font></p>
    </td>
  </tr>
  <tr>
    <td width="100%" colspan="2"><!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
</td>
  </tr>
</table>
</body>
</html>
