<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="TaskInformation.aspx.cs" Inherits="TaskManagement_TaskInformation" Title="Task Management" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="TaskManagement" ContentPlaceHolderID="PageContent" runat="Server">

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

        function GetTaskDeleteUserConf() {
            var userselect = confirm("This action will also remove other associated records!\n" +
                "  • Associated Attachments\n" +
                "  • Associated Notes\n" +
                "  • Associated Custom Fields\n" +
                "  Are you sure you want to continue?");

            document.getElementById('hdnDeleteUserPref').value = userselect;
        }

    </script>
    <main>
        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            <div class="container-xl px-4">
                <div class="page-header-content">
                    <div class="row align-items-center justify-content-between pt-3">
                        <div class="col-auto mb-3">
                            <h1 class="page-header-title">
                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                Task Management	
                            </h1>
                        </div>
                    </div>
                </div>
            </div>
        </header>
        <!-- Main page content-->
        <div class="container-xl px-4 mt-4">
            <div class="row">
                <div class="col-xl-12">
                    <!-- Task information card-->
                    <div class="card mb-4">
                        <div class="card-header">Task Information</div>
                        <div class="card-body">
                            <p class="alert-danger-soft">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </p>
                            <form>
                                <!-- Form Group (Task ID)-->
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <div class="btn-group" role="group">
                                            <%--<asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" Visible="false" />--%>
                                            <%--<asp:Button ID="btnNewEditSave" runat="server" Text="New Task" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" Visible="false" />--%>

                                            <asp:Button ID="btnNew" runat="server" Text="New Task" CssClass="btn btn-outline-primary m-1" OnClick="btnNew_Click" Visible="false" />
                                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-outline-primary m-1" OnClick="btnEdit_Click" Visible="false" />

                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false" />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1" Visible="false" OnClick="btnDelete_Click" />
                                            <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtTID">
                                        <label class="small mb-1" for="inputTaskID">Task ID</label>
                                        <div class="input-group">
                                            <asp:TextBox ID="txtTID" runat="server" CssClass="form-control">                                                  
                                            </asp:TextBox>
                                            <asp:ImageButton ID="btnFind" runat="server" AlternateText="Find" CssClass="btn btn-outline-primary ms-2" ImageUrl="~/images/search-icon.png" OnClick="btnFind_Click"  Visible="false"/>
                                            <div class="input-group-append">
                                                <asp:Button ID="btnTaskToggle" CssClass="btn btn-outline-secondary" runat="server" OnClick="btnTaskToggle_Click" Visible="false" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtStatus">
                                        <label class="small mb-1" for="inputTaskID">Status <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","TaskStatus") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlStatus" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtStatus" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvTaskList" runat="server"
                                            CssClass="table table-bordered table-condensed table-responsive table-hover"
                                            OnRowDataBound="gvTaskList_RowDataBound"
                                            OnSelectedIndexChanging="gvTaskList_SelectedIndexChanging"
                                            OnPageIndexChanging="gvTaskList_PageIndexChanging" AllowPaging="True">
                                        </asp:GridView>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Charge Account)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtChargeAccount">
                                        <label class="small mb-1" for="inputChargeAccount">Charge Account <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","ChargeAcct") ? "inline-block": "none" %>'>*</span></label>
                                       <%-- <asp:DropDownList ID="ddlChargeAccount" CssClass="form-select" runat="server">
                                        </asp:DropDownList>--%>
                                        <asp:TextBox ID="txtChargeAccount" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Cost Type)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtCostType">
                                        <label class="small mb-1" for="inputLastName">Cost Type<span class="red" style='display: <%=Utils.IsRequiredField("Tasks","TaskCostType") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlCostType" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtCostType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row        -->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Ref Type)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtRefType">
                                        <label class="small mb-1" for="inputRefType">Ref Type </label>
                                        <asp:DropDownList ID="ddlRefType" CssClass="form-select" runat="server" OnSelectedIndexChanged="ddlRefType_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtRefType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Ref ID)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtRefID">
                                        <label class="small mb-1" for="inputRefID">Ref ID</label>
                                        <div class="input-group">
                                            <asp:TextBox ID="txtRefID" runat="server" CssClass="form-control">
                                            </asp:TextBox>
                                            <div class="input-group-append">
                                                <asp:Button ID="btnListToggle" CssClass="btn btn-outline-secondary" runat="server" OnClick="btnListToggle_Click" Visible="false" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvReferenceType" runat="server"
                                            CssClass="table table-bordered table-condensed table-responsive table-hover"
                                            OnRowDataBound="gvReferenceType_RowDataBound"
                                            OnSelectedIndexChanging="gvReferenceType_SelectedIndexChanging"
                                            OnPageIndexChanging="gvReferenceType_PageIndexChanging" AllowPaging="True">
                                        </asp:GridView>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Task Type)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtTaskType">
                                        <label class="small mb-1" for="inputTaskType">Task Type </label>
                                        <asp:DropDownList ID="ddlTaskType" runat="server" CssClass="form-select">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtTaskType" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <!-- Form Group (Project)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtProject">
                                        <label class="small mb-1" for="inputProject">Project <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","ProjNum") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlProject" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtProject" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Description)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtDescription">
                                        <label class="small mb-1" for="inputDescription">Description <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","TaskDesc") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:TextBox ID="txtDescription" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Assigned By)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtAssignedBy">
                                        <label class="small mb-1" for="inputAssignedBy">Assigned By <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","AssignBy") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlAssignedBy" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtAssignedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Priority)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtPriority">
                                        <label class="small mb-1" for="inputPriority">Priority <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","TaskPriority") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList CssClass="form-select" ID="ddlPriority" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtPriority" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Assigned To)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtAssignedTo">
                                        <label class="small mb-1" for="inputAssignedTo">Assigned To <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","AssignTo") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlAssignedTo" CssClass="form-select" runat="server"
                                            OnSelectedIndexChanged="ddlAssignedTo_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtAssignedTo" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Assigned Date)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtDateAssignedTo">
                                        <label class="small mb-1" for="inputAssignedDate">Assigned Date<span class="red" style='display: <%=Utils.IsRequiredField("Tasks","DateAssigned") ? "inline-block": "none" %>'>*</span></label>
                                        <ucCalendar:ERMSCalendar ID="ucDateAssignedTo" runat="server" />
                                        <asp:TextBox ID="txtDateAssignedTo" type="text" CssClass="form-control datepicker" placeholder="MM/DD/YYYY" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Assigned WorkGroup)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtAssignedWG">
                                        <label class="small mb-1" for="inputAssignedWorkGroup">Assigned WorkGroup <span class="red" style='display: <%=Utils.IsRequiredField("Tasks","AssignWkgrp") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlAssignedWG" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtAssignedWG" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Assignment)-->
                                    <div class="col-md-6" runat="server" visible="false" id="divtxtAssignment">
                                        <label class="small mb-1" for="inputAssignment">Assignment</label>
                                        <asp:TextBox ID="txtAssignment" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <hr class="mt-0 mb-4" />
                                <!-- Form Row Planned-->
                                <div class="row gx-3 mb-3">
                                    <label class="small mb-1" for="inputPlanned"><b><u>Planned</u></b></label>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3" runat="server" visible="true" id="div">
                                    <!-- Form Group (Start Date)-->
                                    <div class="col-md-3" runat="server" visible="false" id="divtxtPlanDateStart">
                                        <label class="small mb-1" for="inputStartDate">Start Date<span class="red" style='display: <%=Utils.IsRequiredField("Tasks","PlannedStart") ? "inline-block": "none" %>'>*</span></label>
                                        <ucCalendar:ERMSCalendar ID="ucPlanDateStart" runat="server" />
                                        <asp:TextBox ID="txtPlanDateStart" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (End Date)-->
                                    <div class="col-md-3" runat="server" visible="false" id="divtxtPlanDateEnd">
                                        <label class="small mb-1" for="inputEndDate">End Date<span class="red" style='display: <%=Utils.IsRequiredField("Tasks","PlannedFinish") ? "inline-block": "none" %>'>*</span></label>
                                        <ucCalendar:ERMSCalendar ID="ucPlanDateEnd" runat="server" />
                                        <asp:TextBox CssClass="form-control" ID="txtPlanDateEnd" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Hours)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtPlanHours">
                                        <label class="small mb-1" for="inputHours">Hours<span class="red" style='display: <%=Utils.IsRequiredField("Tasks","EstHours") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:TextBox CssClass="form-control" ID="txtPlanHours" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Duration (in Days))-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtPlanDurationDays">
                                        <label class="small mb-1" for="inputDuration">Duration (in Days)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtPlanDurationDays" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Costs)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtPlanCost">
                                        <label class="small mb-1" for="inputCosts">Costs<span class="red" style='display: <%=Utils.IsRequiredField("Tasks","EstCost") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:TextBox CssClass="form-control" ID="txtPlanCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row Overrun-->
                                <div class="row gx-3 mb-3">
                                    <label class="small mb-1" for="inputOverrun"><b><u>Overrun</u></b></label>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Start Date)-->
                                    <div class="col-md-3">
                                    </div>
                                    <!-- Form Group (End Date)-->
                                    <div class="col-md-3" runat="server" visible="false" id="divtxtOverrunDateEnd">
                                        <label class="small mb-1" for="txtOverrunDateEnd">End Date</label>
                                        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucOverrunDateEnd" runat="server" />
                                        <asp:TextBox CssClass="form-control" ID="txtOverrunDateEnd" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Hours)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtOverrunHours">
                                        <label class="small mb-1" for="txtOverrunHours">Hours</label>
                                        <asp:TextBox CssClass="form-control" ID="txtOverrunHours" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Duration (in Days))-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtOverrunDurationDays">
                                        <label class="small mb-1" for="txtOverrunDurationDays">Duration (in Days)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtOverrunDurationDays" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Costs)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtOverrunCost">
                                        <label class="small mb-1" for="txtOverrunCost">Costs</label>
                                        <asp:TextBox CssClass="form-control" ID="txtOverrunCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row Actual-->
                                <div class="row gx-3 mb-3">
                                    <label class="small mb-1" for="inputActual"><b><u>Actual</u></b></label>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Start Date)-->
                                    <div class="col-md-3" runat="server" visible="false" id="divtxtActualDateStart">
                                        <label class="small mb-1" for="txtActualDateStart">Start Date</label>
                                        <asp:TextBox ID="txtActualDateStart" placeholder="MM/DD/YYYY" CssClass="form-control datepicker" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (End Date)-->
                                    <div class="col-md-3" runat="server" visible="false" id="divtxtActualDateEnd">
                                        <label class="small mb-1" for="txtActualDateEnd">End Date</label>
                                        <asp:TextBox CssClass="form-control datepicker" placeholder="MM/DD/YYYY" ID="txtActualDateEnd" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Hours)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtActualHours">
                                        <label class="small mb-1" for="txtActualHours">Hours</label>
                                        <asp:TextBox CssClass="form-control" ID="txtActualHours" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Duration (in Days))-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtActualDurationDays">
                                        <label class="small mb-1" for="txtActualDurationDays">Duration (in Days)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtActualDurationDays" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Costs)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtActualCosts">
                                        <label class="small mb-1" for="txtActualCost">Costs</label>
                                        <asp:TextBox CssClass="form-control" ID="txtActualCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row Variance-->
                                <div class="row gx-3 mb-3">
                                    <label class="small mb-1" for="inputVariance"><b><u>Variance</u></b></label>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Start Date)-->
                                    <div class="col-md-3">
                                    </div>
                                    <!-- Form Group (End Date)-->
                                    <div class="col-md-3">
                                    </div>
                                    <!-- Form Group (txtVarianceHours)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtVarianceHours">
                                        <label class="small mb-1" for="txtVarianceHours">Hours</label>
                                        <asp:TextBox CssClass="form-control" ID="txtVarianceHours" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Duration (in Days))-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtVarianceDurationDays">
                                        <label class="small mb-1" for="txtVarianceDurationDays">Duration (in Days)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtVarianceDurationDays" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Costs)-->
                                    <div class="col-md-2" runat="server" visible="false" id="divtxtVarianceCost">
                                        <label class="small mb-1" for="txtVarianceCost">Costs</label>
                                        <asp:TextBox CssClass="form-control" ID="txtVarianceCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (% Complete)-->
                                    <div class="col-md-3" runat="server" visible="false" id="divtxtPercent">
                                        <label class="small mb-1" for="txtPercent">% Complete (in Days)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtPercent" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Check to make schedule visible)-->
                                    <div class="col-md-3">
                                        <label class="small mb-1" for="cbSchedule">&nbsp</label>
                                        <div class="form-check">
                                            <asp:CheckBox ID="cbSchedule" CssClass="form-check-input" runat="server"></asp:CheckBox>
                                            <label class="form-check-label" for="cbSchedule">
                                                Check to make schedule visible
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="accordion" id="accordionPanelsStayOpen">
                    <div class="accordion-item" runat="server" id="divhlnkAttachFiles" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingOne">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="false" aria-controls="panelsStayOpen-collapseOne">
                                List of Attached Files
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingOne">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:GridView ID="gvAttachedFiles" runat="server" CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvAttachedFiles_RowDataBound"
                                                OnRowDeleting="gvAttachedFiles_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkAttachFiles" CssClass="hLinkSmall" Text="Attach Files" Enabled="false" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%--  --%>
                    <div class="accordion-item" runat="server" id="divhlnkNotes" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingTwo">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseTwo" aria-expanded="false" aria-controls="panelsStayOpen-collapseTwo">
                                List of Added Notes
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseTwo" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingTwo">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:GridView ID="gvNotes" runat="server" CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvNotes_RowDataBound"
                                                OnRowDeleting="gvNotes_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkNotes" CssClass="hLinkSmall" Text="Add Notes" Enabled="false" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%--  --%>
                    <div class="accordion-item" runat="server" id="divhlnkWFTasks" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingThree">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseThree" aria-expanded="false" aria-controls="panelsStayOpen-collapseThree">
                                Workflow Tasks
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseThree" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingThree">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContentCenter">
                                            <asp:GridView ID="gvWFTasks" runat="server" CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnSelectedIndexChanging="gvWFTasks_SelectedIndexChanging"
                                                OnRowDeleting="gvWFTasks_RowDeleting"
                                                OnRowDataBound="gvWFTasks_RowDataBound">
                                            </asp:GridView>
                                            <asp:Label ID="lblWFTasks" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkWFTasks" CssClass="hLinkSmall" Text="Assign Workflow" runat="server" Enabled="false">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" id="divhlnkWFCustom" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingFour">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseFour" aria-expanded="false" aria-controls="panelsStayOpen-collapseFour">
                                Custom Fields
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseFour" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingFour">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <!--- Table to List Custom Field Info--->
                                        <asp:Literal ID="CustomLiteral" runat="server" />
                                        <!---- Table to List Custom Field Info Ends--->

                                        <table class="Table" cellspacing="0" cellpadding="2" border="1">
                                            <asp:HyperLink ID="hlnkWFCustom" CssClass="hLinkSmall" runat="server" Text="Assign Custom Field Values" Enabled="false">
                                                <asp:Label ID="lblAssign" runat="server"></asp:Label>
                                            </asp:HyperLink>
                                        </table>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            //$("#PageContent_ucPlanDateStart_uctxtDate").addClass('form-control');
            //$("#PageContent_ucPlanDateEnd_uctxtDate").addClass('form-control');
            //$(document).ready(function () {
            //    debugger;
            //    $("input[id*='ucbtnDate']").hide();
            //    $("input[id*='uctxtDate']").datepicker({
            //        dateFormat: 'mm/dd/yyyy'
            //    });
            //    $('.datepicker').datepicker({
            //        dateFormat: 'mm/dd/yyyy'
            //    });
            //})
        </script>
    </main>
</asp:Content>

