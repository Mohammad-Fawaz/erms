<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="WFRoutingGroup.aspx.cs" Inherits="WFRoutingGroup_WFRoutingGroup" Title="Workflow Routing Groups" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="WFRoutingGroup" ContentPlaceHolderID="PageContent" runat="Server">

    <script type="text/javascript">

        function GetWFDeleteUserConf() {
            var userselect = confirm("This action will also remove associated members!\n" +
                "Are you sure you want to continue?");

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
                                Workflow Routing Groups	
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
                        <div class="card-header">Workflow Routing Group Information</div>
                        <div class="card-body">
                            <p class="alert-danger-soft">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </p>
                            <form>
                                <!-- Form Group (Task ID)-->
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <div class="btn-group" role="group">
                                           <%-- <asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" Visible="false" />--%>
                                            <asp:Button ID="btnNewEditSave" runat="server" Text="New Group" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" Visible="false" />
                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false" />
                                            <asp:Button ID="btnAddSaveMember" runat="server" Text="Add Member" CssClass="btn btn-outline-primary m-1" Visible="False" OnClick="btnAddSaveMember_Click" />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1" Visible="false" OnClick="btnDelete_Click" />
                                            <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <h1>Workflow Group Header</h1>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div id="divGroupName" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtGroupName">Group Name</label>
                                        <div class="d-flex">
                                            <asp:TextBox ID="txtGroupName" CssClass="form-control" runat="server">
                                            </asp:TextBox>
                                            <asp:DropDownList ID="ddlGroupName" CssClass="form-select" runat="server">
                                            </asp:DropDownList>
                                            <asp:HiddenField ID="hdnGroupID" runat="server" />
                                            <asp:ImageButton ID="btnFind" runat="server" AlternateText="Find" CssClass="btn btn-outline-primary ms-2" ImageUrl="~/images/search-icon.png" OnClick="btnFind_Click" Visible="false" />
                                        </div>
                                    </div>
                                    <div id="divGroupType" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtGroupType">Group Type</label>
                                        <asp:TextBox ID="txtGroupType" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                        <asp:DropDownList ID="ddlGroupType" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:HiddenField ID="hdnGroupTypeCode" runat="server" />
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-12">
                                        <h1>Workflow Group Members</h1>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Charge Account)-->
                                    <div id="divEmployee" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtEmployee">Employee</label>
                                        <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlEmployee_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtEmployee" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:HiddenField ID="hdnGroupMemberID" runat="server" />
                                    </div>
                                    <!-- Form Group (txtDefault)-->
                                    <div id="divNameAlias" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtDefault"><sup>(and/or)</sup> Name/Alias</label>
                                        <asp:TextBox ID="txtDefault" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row        -->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (RefEmail)-->
                                    <div id="divEmail" runat="server" visible="false" class="col-md-6">
                                        <label class="small mb-1" for="txtEmail">Email<sub>(if applicable)</sub></label>
                                        <asp:TextBox ID="txtEmail" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-12">
                                        <h1>Current Member List</h1>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-12">
                                        <asp:GridView ID="gvGroupMembers" runat="server" CssClass="table table-bordered table-condensed table-responsive table-hover"
                                            OnSelectedIndexChanging="gvGroupMembers_SelectedIndexChanging"
                                            OnRowDeleting="gvGroupMembers_RowDeleting"
                                            OnRowDataBound="gvGroupMembers_RowDataBound">
                                        </asp:GridView>
                                        <asp:Label ID="lblGroupMembers" runat="server" CssClass="CtrlWideValueView"></asp:Label>
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

