<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="WFTaskInformation.aspx.cs" Inherits="WFManagement_TaskInformation" Title="Workflow Task" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="WFTask" ContentPlaceHolderID="PageContent" runat="Server">

    <script type="text/javascript">

        function toggleDiv(divid, linkid) {
            var linktext = '';
            if (document.getElementById(divid).style.display == 'none') {
                document.getElementById(divid).style.display = 'block';
                linktext = '-';
            }
            else {
                document.getElementById(divid).style.display = 'none';
                linktext = '+';
            }
            var link = document.getElementById(linkid);
            if (document.all) { //IS IE 4 or 5 or later 
                link.innerText = linktext;
            }
            //IS NETSCAPE 4 or below
            if (document.layers) {
                link.innerText = linktext;
            }
            //Mozilla/Netscape6+ and all the other Gecko-based browsers
            if (document.getElementById && !document.all) {
                link.firstChild.nodeValue = linktext;
            }
        }

    </script>

    <main>
        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            <div class="container-xl px-4">
                <div class="page-header-content">
                    <div class="row align-items-center justify-content-between pt-3">
                        <div class="col-3">
                            <h1 class="page-header-title">
                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                Workflow Task		
                            </h1>
                        </div>
                        <div class="col-9">
                            <%--<a href='/Legacy/secweb/ret_selitem.asp?Listing=WF&Item=" & curRec & "' class="hLinkSmallBold">View Workflow Task</a> | 
                                     <a href='/Legacy/secweb/pnt_selitem.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a> |
                                     <a href='/Legacy/secweb/pnt_chgreq.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Workflow Task Form</a> |
                                     <a href='/Legacy/secweb/pnt_dev.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Waiver/Deviation Form</a>--%>

                             <asp:HyperLink ID="hlnkViewWorkflowTask" runat="server" Target="_blank">View Workflow Task</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableFormate" runat="server" Target="_blank">Printable Format</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableWorkflowTaskForm" runat="server" Target="_blank">Printable Workflow Task Form</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableWaiver" runat="server" Target="_blank">Printable Waiver/Deviation Form</asp:HyperLink>
                        </div>
                    </div>
                </div>
            </div>
        </header>
        <!-- Main page content-->
        <div class="container-xl px-4 mt-4">
            <div class="row">
                <div class="col-xl-12">
                    <!--  card-->
                    <div class="card mb-4">
                        <div class="card-header">Workflow Task Information</div>
                        <div class="card-body">
                            <table class="Table">
                                <tr>
                                    <td>
                                        <!-- Header -->
                                        <table class="Table">

                                            <tr>
                                                <td class="FieldContent" colspan="2">
                                                    <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label></td>
                                            </tr>
                                        </table>

                                        <!-- WF Request Information -->
                                        <table class="Table">

                                            <tr>
                                                <td class="TabSubHeader">
                                                    <asp:Button ID="btnNewEditSave" runat="server" Text="New WorkFlow Task" CssClass="btn btn-primary-soft" OnClick="btnNewEditSave_Click" />
                                                    <asp:Button ID="btnAddSaveTask" runat="server" Text="Add Task" CssClass="btn btn-primary-soft" Visible="False" OnClick="btnAddSaveTask_Click" />
                                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-primary-soft" Visible="False" OnClick="btnCancel_Click" />
                                                    &nbsp;&nbsp;                                        
                                                </td>
                                            </tr>
                                        </table>

                                        <!-- WorkFlow Header -->
                                        <div class="row">
                                            <div class="col-12 my-4">
                                                <div class="TabHeader">
                                                    <h1>Workflow Task Header</h1>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Template Name:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtTemplateName" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnWFTemplateID" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Template Type:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtTemplateType" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Reference Type:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtHeaderRefType" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnHeaderRefTypeCode" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Reference ID:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtHeaderRefID" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Number of Steps:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtStepCount" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Number of Tasks:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtTaskCount" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Created On:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtCreatedOn" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-12 my-4">
                                                <div class="TabHeader">
                                                    <h1>Workflow Task</h1>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">
                                                    <asp:Label ID="lblTID" runat="server">
                                                    </asp:Label></lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtTID" runat="server">
                                                    </asp:TextBox>
                                                    <asp:DropDownList CssClass="form-select" ID="ddlAction" runat="server" OnSelectedIndexChanged="ddlAction_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">
                                                    <asp:Label ID="lblTaskStatus" runat="server">
                                                    </asp:Label></lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlStatus" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtStatus" runat="server">
                                                    </asp:TextBox>
                                                    <asp:DropDownList CssClass="form-select" ID="ddlTemplateStep" runat="server" OnSelectedIndexChanged="ddlTemplateStep_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                    <asp:HiddenField ID="hdnWFTemplateItemID" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Priority:</lable>
                                                <div class="FieldContent" colspan="3">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlPriority" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtPriority" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Project:</lable>
                                                <div class="FieldContent" colspan="3">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlProject" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtProject" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Description:</lable>
                                                <div class="FieldContent" colspan="3">
                                                    <asp:TextBox CssClass="form-control" ID="txtTaskDescription" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Step Number:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtStepNumber" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Action Type:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtActionType" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnActionTypeCode" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Ref. Control:</lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlRefControl" runat="server"
                                                        OnSelectedIndexChanged="ddlRefControl_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtRefControl" runat="server">
                                                    </asp:TextBox>
                                                    <sup style="top: 8px">
                                                        <asp:CheckBox ID="cbUpdateCRef" runat="server" />
                                                        <asp:CheckBox ID="cbAllowAddCRef" runat="server" /></sup>
                                                    <asp:HiddenField ID="hdnControlReferenceCode" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Ref. ID:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtRefControlID" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnWFTaskID" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Back Step:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtBackStep" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Back Step Status:</lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlBackStatus" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtBackStatus" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Next Step:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtNextStep" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Next Step Status:</lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlNextStatus" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtNextStatus" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Instructions </lable>
                                                <div class="FieldContent" colspan="3">
                                                    <asp:TextBox CssClass="form-control" ID="txtStepDescription" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Assigner Type:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtAssignerType" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnAssignerType" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Assigned By:</lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlAssignedBy" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtAssignedBy" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnAssignedByID" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Assignee Type:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtAssigneeType" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnAssigneeType" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Assigned To:</lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlAssignedTo" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtAssignedTo" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnAssignedToID" runat="server" />
                                                    <asp:CheckBox ID="cbNotifyByEmail" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Charge Account:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtChargeAccount" runat="server">
                                                    </asp:TextBox>
                                                    <asp:HiddenField ID="hdnStdTaskCode" runat="server" />
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Standard Task:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtStandardTask" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                            </div>
                                            <div class="col-6 mb-3">
                                            </div>
                                        </div>
                                        <table class="TableMtrx" style="width: 100%;">
                                            <tr>
                                                <td class="FieldHeaderCenter" style="background-color: #FFFFFF">Schedule</td>
                                                <td class="FieldHeaderCenter" style="background-color: #FFFFFF">Start Date</td>
                                                <td class="FieldHeaderCenter" style="background-color: #FFFFFF">End Date</td>
                                                <td class="FieldHeaderCenter" style="background-color: #FFFFFF">Hours</td>
                                                <td class="FieldHeaderCenter" style="background-color: #FFFFFF">Costs</td>
                                            </tr>
                                            <tr>
                                                <td class="FieldHeader" style="background-color: #FFFFFF">Planned:</td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucPlanDateStart" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtPlanDateStart" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucPlanDateEnd" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtPlanDateEnd" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <asp:TextBox CssClass="form-control" ID="txtPlanHours" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <asp:TextBox CssClass="form-control" ID="txtPlanCost" runat="server">
                                                    </asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="FieldHeader" style="background-color: #FFFFFF">Adj. Plan:</td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucAdjPlanDateStart" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtAdjPlanDateStart" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucAdjPlanDateEnd" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtAdjPlanDateEnd" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="FieldHeader" style="background-color: #FFFFFF">Overrun:</td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucOverrunDateEnd" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtOverrunDateEnd" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <asp:TextBox CssClass="form-control" ID="txtOverrunHours" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <asp:TextBox CssClass="form-control" ID="txtOverrunCost" runat="server">
                                                    </asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="FieldHeader" style="background-color: #FFFFFF">Adj. Overrun:</td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucAdjOverrunDateEnd" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtAdjOverrunDateEnd" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="FieldHeader" style="background-color: #FFFFFF">Actual:</td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucActualDateStart" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtActualDateStart" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucActualDateEnd" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtActualDateEnd" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <asp:TextBox CssClass="form-control" ID="txtActualHours" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <asp:TextBox CssClass="form-control" ID="txtActualCost" runat="server">
                                                    </asp:TextBox></td>
                                            </tr>
                                            <tr>
                                                <td class="FieldHeader" style="background-color: #FFFFFF">Adj. Actual:</td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucAdjActualDateStart" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtAdjActualDateStart" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">
                                                    <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucAdjActualDateEnd" runat="server" />
                                                    <asp:TextBox CssClass="form-control" ID="txtAdjActualDateEnd" runat="server">
                                                    </asp:TextBox></td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                                <td class="FieldContentCenter">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                                <td class="FieldHeader" colspan="1" style="background-color: #FFFFFF">
                                                    <asp:TextBox CssClass="form-control" ID="txtPercent" runat="server">
                                                    </asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblPercent" runat="server">
                                                    </asp:Label></td>
                                            </tr>
                                        </table>
                                        <br />

                                        <!-- WorkFlow Tasks -->
                                        <div class="row">
                                            <div class="accordion" id="accordionPanelsStayOpen">
                                                <div class="accordion-item">
                                                    <h2 class="accordion-header" id="panelsStayOpen-headingOne">
                                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="false" aria-controls="panelsStayOpen-collapseOne">
                                                            Current Workflow Tasks
                                                        </button>
                                                    </h2>
                                                    <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingOne">
                                                        <div class="accordion-body">
                                                            <table class="Table">
                                                                <tr>
                                                                    <td class="FieldContentCenter">
                                                                        <asp:GridView ID="gvWFTasks" runat="server"
                                                                            OnSelectedIndexChanging="gvWFTasks_SelectedIndexChanging"
                                                                            CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                                            OnRowDeleting="gvWFTasks_RowDeleting"
                                                                            OnRowDataBound="gvWFTasks_RowDataBound">
                                                                        </asp:GridView>
                                                                        <asp:Label ID="lblWFTasks" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>


                                        <table class="Table">
                                            <tr>
                                                <td class="FieldContent">
                                                    <asp:HyperLink ID="hlnkGoBack" CssClass="btn btn-link" runat="server">
          Back to Reference Item</asp:HyperLink>
                                                </td>
                                            </tr>
                                        </table>

                                    </td>
                                </tr>
                            </table>

                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>

</asp:Content>

