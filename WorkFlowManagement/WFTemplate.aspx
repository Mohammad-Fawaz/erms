<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="WFTemplate.aspx.cs" Inherits="WFManagement_WFTemplate" Title="Workflow Management" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="WFManagement" ContentPlaceHolderID="PageContent" runat="Server">

    <script type="text/javascript">

        function GetWFDeleteUserConf() {
            var userselect = confirm("This action will also remove associated workflow steps!\n" +
                "Are you sure you want to continue?");

            document.getElementById('hdnDeleteUserPref').value = userselect;
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
                                Workflow Template
                            </h1>
                        </div>
                        <div class="col-9">
                            <a href='ret_selitem.asp?Listing=WF&Item=" & curRec & "' class="hLinkSmallBold">View Template</a> | 
                                         <a href='pnt_selitem.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a> |
                                         <a href='pnt_chgreq.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Template Form</a> |
                                         <a href='pnt_dev.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Waiver/Deviation Form</a>
                        </div>
                    </div>
                </div>
            </div>
        </header>
        <!-- Main page content-->
        <div class="container-xl px-4 mt-4">
            <div class="row">
                <div class="col-xl-12">
                    <!-- Workflow Template card-->
                    <div class="card mb-4">
                        <div class="card-header">Workflow Template Information</div>
                        <div class="card-body">
                            <p class="alert-danger-soft">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </p>
                            <form>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <div class="btn-group" role="group">
                                            <%--<asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" Visible="false" />--%>
                                            <%--<asp:Button ID="btnNewEditSave" runat="server" Text="New Template" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" Visible="false" />--%>
                                            <asp:Button ID="btnNewEditSave" runat="server" Text="New WorkFlow" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" Visible="false" />
                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false" />
                                            <asp:Button ID="btnAddSaveStep" runat="server" Text="Add Step" CssClass="btn btn-outline-primary m-1" Visible="False" OnClick="btnAddSaveStep_Click" />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1" Visible="false" OnClick="btnDelete_Click" />
                                            <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />
                                        </div>
                                    </div>
                                </div>
                                <!-- Form Row WorkFlow Header-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (WorkFlow Header)-->
                                    <div class="col-md-6">
                                        <h1>Workflow Header</h1>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Template Name)-->
                                    <div id="divTemplateName" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtTemplateName">Template Name</label>
                                        <div class="d-flex">
                                            <asp:DropDownList ID="ddlTemplateName" CssClass="form-select" runat="server">
                                            </asp:DropDownList>
                                            <asp:TextBox ID="txtTemplateName" CssClass="form-control" runat="server">
                                            </asp:TextBox>
                                            <asp:HiddenField ID="hdnWFTemplateID" runat="server" />
                                            <asp:ImageButton ID="btnFind" runat="server" AlternateText="Find" CssClass="btn btn-outline-primary ms-2" ImageUrl="~/images/search-icon.png" OnClick="btnFind_Click" Visible="false" />
                                        </div>
                                    </div>
                                    <!-- Form Group (Template Type)-->
                                    <div id="divTemplateType" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="hdnWFTemplateTypeCode">Template Type</label>
                                        <asp:TextBox ID="txtTemplateType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:DropDownList ID="ddlTemplateType" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:HiddenField ID="hdnWFTemplateTypeCode" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Description)-->
                                    <div id="divDescription" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtDescription">Description</label>
                                        <asp:TextBox ID="txtDescription" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row Workflow Step-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (WorkFlow Header)-->
                                    <div class="col-md-6">
                                        <h1>Workflow Step (Action)</h1>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Action)-->
                                    <div id="divAction" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtAction">Action</label>
                                        <asp:DropDownList ID="ddlAction" CssClass="form-select" runat="server"
                                            OnSelectedIndexChanged="ddlAction_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtAction" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnWFStepID" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Action Type)-->
                                    <div id="divActionType" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtActionType">Action Type</label>
                                        <asp:TextBox ID="txtActionType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnActionTypeCode" runat="server" />
                                    </div>
                                    <!-- Form Group (Step Number)-->
                                    <div id="divStepNumber" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtStepNumber">Step Number</label>
                                        <asp:TextBox ID="txtStepNumber" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnStepMaxNumber" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Ref. Controlled)-->
                                    <div id="divRevision" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="txtRevision">Ref. Controlled</label>
                                        <asp:DropDownList ID="ddlRefControl" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlRefControl_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtRefControl" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnControlReferenceCode" runat="server" />
                                    </div>
                                    <!-- Form Group (cbUpdateCRef)-->
                                    <div id="divUpdateCRef" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="cbUpdateCRef">
                                            <br />
                                            <br />
                                            <br />
                                        </label>
                                        <asp:CheckBox ID="cbUpdateCRef" runat="server" />
                                    </div>
                                    <!-- Form Group (cbAllowAddCRef)-->
                                    <div id="divAllowAddCRef" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="cbAllowAddCRef">
                                            <br />
                                            <br />
                                            <br />
                                        </label>
                                        <asp:CheckBox ID="cbAllowAddCRef" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Back Step)-->
                                    <div id="divBackStep" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtBackStep">Back Step</label>
                                        <%--<asp:TextBox CssClass="form-control" ID="txtBackStep" runat="server">
                                        </asp:TextBox>--%>
                                        <asp:DropDownList ID="ddlBackStep" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                    <!-- Form Group (Back Step Status)-->
                                    <div id="divBackStatus" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtChargeAccount">Back Step Status</label>
                                        <asp:DropDownList ID="ddlBackStatus" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtBackStatus" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Next Step)-->
                                    <div id="divNextStep" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtNextStep">Next Step</label>
                                        <%--<asp:TextBox CssClass="form-control" ID="txtNextStep" runat="server">
                                        </asp:TextBox>--%>
                                        <asp:DropDownList ID="ddlNextStep" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                    <!-- Form Group (Next Step Status)-->
                                    <div id="divNextStatus" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtChargeAccount">Next Step Status</label>
                                        <asp:DropDownList ID="ddlNextStatus" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtNextStatus" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Description)-->
                                    <div id="divStepDescription" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtStepDescription">Description</label>
                                        <asp:TextBox ID="txtStepDescription" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Assigner Type)-->
                                    <div id="divAssignerType" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtAssignerType">Assigner Type</label>
                                        <asp:TextBox CssClass="form-control" ID="txtAssignerType" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnAssignerType" runat="server" />
                                    </div>
                                    <!-- Form Group (Assigned By)-->
                                    <div id="divAssignedBy" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtAssignedBy">Assigned By</label>
                                        <asp:DropDownList ID="ddlAssignedBy" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtAssignedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Assignee Type)-->
                                    <div id="divAssigneeType" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="txtAssigneeType">Assignee Type</label>
                                        <asp:TextBox CssClass="form-control" ID="txtAssigneeType" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnAssigneeType" runat="server" />
                                    </div>
                                    <!-- Form Group (Assigned To)-->
                                    <div id="divAssignedTo" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="txtChargeAccount">Assigned To</label>
                                        <asp:DropDownList ID="ddlAssignedTo" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtAssignedTo" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Notify By Email)-->
                                    <div id="divNotifyByEmail" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="cbNotifyByEmail">
                                            <br />
                                            <br />
                                            <br />
                                        </label>
                                        <asp:CheckBox ID="cbNotifyByEmail" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Charge Account)-->
                                    <div id="divChargeAmount" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtChargeAccount">Charge Account</label>
                                        <asp:TextBox CssClass="form-control" ID="txtChargeAccount" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnStdTaskCode" runat="server" />
                                    </div>
                                    <!-- Form Group (txtStandardTask)-->
                                    <div id="divStandardTask" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtStandardTask">txtStandardTask</label>
                                        <asp:TextBox ID="txtStandardTask" CssClass="form-control" runat="server">
                                        </asp:TextBox>

                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <label class="small mb-1" for="">Schedule:</label>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Duration (Days))-->
                                    <div id="divPlanDuration" runat="server" visible="false" class="col-md-3">
                                        <label class="small mb-1" for="inputDescription">Duration (Days)</label>
                                        <asp:TextBox ID="txtPlanDuration" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <!-- Form Group (Hours)-->
                                    <div id="divPlanHours" runat="server" visible="false" class="col-md-3">
                                        <label class="small mb-1" for="txtPlanHours">Hours</label>
                                        <asp:TextBox ID="txtPlanHours" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <!-- Form Group (Minutes)-->
                                    <div id="divPlanMinutes" runat="server" visible="false" class="col-md-3">
                                        <label class="small mb-1" for="txtPlanMinutes">Minutes</label>
                                        <asp:TextBox ID="txtPlanMinutes" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <!-- Form Group (Cost)-->
                                    <div id="divPlanCost" runat="server" visible="false" class="col-md-3">
                                        <label class="small mb-1" for="txtPlanCost">Cost</label>
                                        <asp:TextBox ID="txtPlanCost" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row Workflow Step-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (WorkFlow Header)-->
                                    <div class="col-md-6">
                                        <h1>Current Workflow Steps </h1>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (WorkFlow Header)-->
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvWFSteps" runat="server"
                                            OnSelectedIndexChanging="gvWFSteps_SelectedIndexChanging"
                                            OnRowDeleting="gvWFSteps_RowDeleting"
                                            CssClass="table table-bordered table-condensed table-responsive table-hover"
                                            OnRowDataBound="gvWFSteps_RowDataBound">
                                        </asp:GridView>
                                        <asp:Label ID="lblWFSteps" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>


</asp:Content>

