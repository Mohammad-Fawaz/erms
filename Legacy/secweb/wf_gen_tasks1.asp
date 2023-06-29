<%@  language="VBScript" %>
<!-- #INCLUDE FILE="script/incl_pgdef1.asp" -->
<!-- #INCLUDE FILE="script/incl_lists.asp" -->
<!-- #INCLUDE FILE="script/incl_wkflow.asp" -->
<html>

<head>
    <%
Dim sMode
Dim sForm
Dim sTitle
Dim sInst
Dim sWFInfo
Dim sTaskList
Dim nModTask
Dim nNStep
Dim sRT, sRID

sForm = ""
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	Select Case Request.Form("B1")
		Case "Cancel": sMode = "M"
		Case "Skip": sMode = Request.Form("NextMode"): nNStep = IIf(Request.Form("SkipStep") <> "", Request.Form("SkipStep"), Request.Form("NextStep"))
		Case Else: sMode = Request.Form("Mode"): nNStep = IIf(Request.Form("NextStep") <> "", Request.Form("NextStep"), "")
	End Select
	
	
	sRT = Request.Form("RT")
	sRID = Request.Form("RID")
	Select Case sMode
		Case "GT"		'Generate task(s)
			GenWFTask
			sMode = Request.Form("NextMode")
			
		Case "ST"		'Save Task(s)
		
			SaveWFTask
			sMode = "M"
			
		Case "UT"		'Update task
			ModWFTask Request.Form("WATID")
			sMode = "M"
			
	End Select
Else
	If (Request.QueryString <> "") Then
		If (Request.QueryString("M") <> "") Then sMode = Request.QueryString("M")
		sRT = Request.QueryString("RT")
		sRID = Request.QueryString("R")
		If (Request.QueryString("WT") <> "") Then nModTask = Request.QueryString("WT")
		Select Case sMode
			Case "DT"		'Delete task
				'DeleteItem "WFTask", nModTask
				DeleteItem "WFTask", Request.QueryString("WT")
				sMode = "M"
		End Select
	End If
End If

Select Case sMode
	Case "SS", "RS"
		sTitle = "Select Step(s)"
		sInst = "Please provide all required information in order to generate task(s) for this step, or you may skip the step without creating task(s) if it is unnecessary."
		sForm = GetGenForm(sMode, nNStep)
	Case "M"
		sTitle = "Modify Workflow Tasks"
		sInst = "Please modify these tasks as necessary. You may also <strong><a href='wf_gen_tasks1.asp?M=NT&RT=" & sRT & "&R=" & sRID & "'>add additional tasks</a></strong> if necessary."
		sWFInfo = GetWFInfo(sRT, sRID)
		sTaskList = GetWFTaskList(sRT, sRID)
		
		
		
	Case "MT"
		sTitle = "Modify Workflow Task"
		sInst = "Please provide all necessary information in order to complete the record."
		sForm = GetMTaskForm(sMode, nModTask, sRT, sRID)
		sWFInfo = GetWFInfo(sRT, sRID)
		sTaskList = GetWFTaskList(sRT, sRID)
		
		
		
	Case "NT", "R1", "R2", "R3"
		sTitle = "Add Workflow Task(s)"
		sInst = "Please provide all necessary information in order to complete the record."
		sForm = GetMTaskForm(sMode, "", sRT, sRID)
		sWFInfo = GetWFInfo(sRT, sRID)
		sTaskList = GetWFTaskList(sRT, sRID)
End Select

    %>
	 <link rel="stylesheet" type="text/css" href="../pg_style.css">
    <link href="/css/styles.css" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/feather-icons/4.28.0/feather.min.js"></script>
    <title>Generate Workflow Tasks</title>
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
            <td width="635" valign="top"><font face="Verdana" size="5"><% =sTitle %></font>
                <p><font face="Verdana" size="2"><% =sInst %></font></p>
                <% =sWFInfo %>
                <% =sForm %>
                <% =sTaskList %>
                <p>&nbsp;</p>
                <p align="center">
                    <font face="Verdana" size="2"><strong>
                        <a href="wf_rtgroups.asp">Workflow Routing Groups</a> &#149; <a href="wf_gen_tasks.asp">Generate Workflow Tasks</a><br>
                        <a href="wf_add_temp.asp">Create New Workflow Template</a> &#149; <a href="wf_sel_modtemp.asp">Open/Modify Workflow Template</a><br>
                        <a href="wf_add_act.asp">Create New Workflow Action</a> &#149; <a href="wf_sel_modact.asp">Open/Modify Workflow Action</a><br>
                        <a href="wf_help.asp">Help Files and Instructions</a></strong></font>
                </p>
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
