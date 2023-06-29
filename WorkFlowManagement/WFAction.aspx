<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="WFAction.aspx.cs" Inherits="WFManagement_WFAction" Title="Workflow Action" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="WFAction" ContentPlaceHolderID="PageContent" runat="Server">
    <main>
        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            <div class="container-xl px-4">
                <div class="page-header-content">
                    <div class="row align-items-center justify-content-between pt-3">
                        <div class="col-3">
                            <h1 class="page-header-title">
                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                WorkFlow Management	
                            </h1>
                        </div>
                        <div class="col-9">
                            <a href='ret_selitem.asp?Listing=WF&Item=" & curRec & "' class="hLinkSmallBold">View Action</a> | 
                     <a href='pnt_selitem.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a> | 
                     <a href='pnt_chgreq.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Action Form</a> | 
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
                    <!-- Task Document card-->
                    <div class="card mb-4">
                        <div class="card-header">Workflow Action Information</div>
                        <div class="card-body">
                            <p class="alert-danger-soft">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </p>
                            <form>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <div class="btn-group" role="group">
                                           <%-- <asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" Visible="false" />--%>
                                            <asp:Button ID="btnNewEditSave" runat="server" Text="New Action" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" Visible="false" />
                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false" />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1" Visible="false" OnClick="btnDelete_Click" />
                                            <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />
                                        </div>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Action)-->
                                    <div id="divAction" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtAction">Action</label>
                                        <div class="d-flex">
                                            <asp:DropDownList ID="ddlAction" CssClass="form-select" runat="server">
                                            </asp:DropDownList>
                                            <asp:TextBox ID="txtAction" CssClass="form-control" runat="server">
                                            </asp:TextBox>
                                            <asp:HiddenField ID="hdnActionID" runat="server" />
                                             <asp:ImageButton ID="btnFind" runat="server" AlternateText="Find" CssClass="btn btn-outline-primary ms-2" ImageUrl="~/images/search-icon.png" OnClick="btnFind_Click" Visible="false" />
                                        </div>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Action Type)-->
                                    <div id="divActionType" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtAction">Action Type</label>
                                        <asp:DropDownList CssClass="form-select" ID="ddlActionType" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtActionType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnActionTypeCode" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Description)-->
                                    <div id="divActionDescription" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtActionDescription">Description</label>
                                        <asp:TextBox ID="txtActionDescription" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Ref. Controlled)-->
                                    <div id="divRefControl" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="txtRefControl">Ref. Controlled</label>
                                        <asp:DropDownList ID="ddlRefControl" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtRefControl" CssClass="form-control" runat="server">
                                        </asp:TextBox>
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
                                    <!-- Form Group (Assigner Type)-->
                                    <div id="divAssignerType" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtAssignerType">Assigner Type</label>
                                        <asp:TextBox ID="txtAssignerType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:DropDownList CssClass="form-select" ID="ddlAssignerType" runat="server" OnSelectedIndexChanged="ddlAssignerType_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:HiddenField ID="hdnAssignerType" runat="server" />
                                    </div>
                                    <!-- Form Group (Assigned By)-->
                                    <div id="divAssignedBy" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtDocType">Assigned By</label>
                                        <asp:TextBox ID="txtAssignedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:DropDownList CssClass="form-select" ID="ddlAssignedBy" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Assignee Type)-->
                                    <div id="divAssigneType" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="txtRevision">Assignee Type</label>
                                        <asp:TextBox ID="txtAssigneeType" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:DropDownList CssClass="form-select" ID="ddlAssigneeType" runat="server" OnSelectedIndexChanged="ddlAssigneeType_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:HiddenField ID="hdnAssigneeType" runat="server" />
                                    </div>
                                    <!-- Form Group (Assigned To)-->
                                    <div id="divAssignedTo" runat="server" visible="false" class="col-md-4">
                                        <label class="small mb-1" for="cbUpdateCRef">Assigned To</label>
                                        <asp:DropDownList CssClass="form-select" ID="ddlAssignedTo" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtAssignedTo" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (cbNotifyByEmail)-->
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
                                    <!-- Form Group (Standard Task)-->
                                    <div id="divStandardTask" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtChargeAccount">Standard Task</label>
                                        <asp:DropDownList ID="ddlStandardTask" CssClass="form-select" runat="server" OnSelectedIndexChanged="ddlStandardTask_SelectedIndexChanged">
                                        </asp:DropDownList>
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
                                    <div id="divDurationDays" runat="server" visible="false" class="col-md-3">
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
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>

