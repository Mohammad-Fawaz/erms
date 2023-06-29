<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
    <%
Dim sMode
Dim sForm
Dim sTask
Dim sType

sForm = ""
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	sMode = Request.Form("Mode")
	sTask = Request.Form("TID")
	sType = Request.Form("TType")
	If (Request.Form("B1") = "Cancel") Then sMode = "R"
	Select Case sMode
		Case "UT"
			
	End Select
Else
	sMode = "R"
	sTask = Request.QueryString("T")
	sType = Request.QueryString("TY")
End If

sForm = GetUTaskForm(sMode, sTask, sType)

    %>

    <link rel="stylesheet" type="text/css" href="../pg_style.css">
    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>Update Workflow Task</title>
     <style>
    	iframe#PageContent_frameQSearch {
    		height: 780px !important;
    	}

    	table {
    		width: 100% !important;
    		border: none !important;
    	}
		table .save-btn{
			margin-top:20px;
    font-size: 12px;
    padding: 4px 10px;
    font-weight: 500;
		}
		table textarea,
		table select,
		table input{
			font-size: 13px;
			padding: 4px;
		}
    </style>
</head>

<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <table border="0" cellpadding="2" cellspacing="0" width="780">
                            <tr>
                                <td width="100%" colspan="2">
                                    <!--webbot bot="Include" U-Include="web_header.htm" TAG="BODY" -->
                                </td>
                            </tr>
                            <tr>
                                <!--<td width="145" valign="top" bgcolor="#FFFFC8"><% =sMenu %>
</td>-->
                                <td width="635" valign="top"><font face="Verdana" size="5">Modify Workflow Task</font><font face="Verdana" size="2"> &#149; <a href="wf_upd_task.asp"><strong>Refresh View</strong></a></font>
                                    <% =sForm %>
                                    <table border="1" cellpadding="2" width="100%" cellspacing="0">
                                        <tr>
                                            <td valign="top">
                                                <table border="0" cellpadding="2" width="100%">
                                                    <tr>
                                                        <td colspan="4"><strong><font face="Verdana" size="3">Notes</font></strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Date</font></strong></td>
                                                        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">From</font></strong></td>
                                                        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Note Type</font></strong></td>
                                                        <td bgcolor="#D7D7D7"><strong><font face="Verdana" size="1">Subject</font></strong></td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top"></td>
                                                        <td valign="top"></td>
                                                        <td valign="top"></td>
                                                        <td valign="top"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table border="0" cellpadding="2" width="100%">
                                                    <tr>
                                                        <td colspan="3"><font face="Verdana" size="3"><strong>Attachments</strong></font></td>
                                                    </tr>
                                                    <tr>
                                                        <td bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>File Name</strong></font></td>
                                                        <td bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Description</strong></font></td>
                                                        <td bgcolor="#D7D7D7"><font face="Verdana" size="1"><strong>Print Size</strong></font></td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top"></td>
                                                        <td valign="top"></td>
                                                        <td valign="top"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                    <p align="center">
                                        <font face="Verdana" size="2"><strong><a href="wf_rtgroups.asp">Workflow
    Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
                                            <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
                                            <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify
    Workflow Action</a><br>
                                            <a href="wf_help.asp">Help Files and Instructions</a></strong></font>
                                </td>
                            </tr>
                            <tr>
                                <td width="100%" colspan="2">
                                    <!--webbot bot="Include" U-Include="web_footer.htm" TAG="BODY" -->
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
