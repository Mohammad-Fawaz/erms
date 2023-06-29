<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ProjectInformation.aspx.cs" Inherits="ProjectManagement_ProjectInformation" Title="Project Management" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="ProjectManagement" ContentPlaceHolderID="PageContent" runat="Server">

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

        function GetProjectDeleteUserConf() {
            var userselect = confirm("This action will delete Project and remove its associations!\n" +
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
                                Project Management &nbsp <%--<a href='pnt_chgreq.asp?Listing=Change&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Project Form</a>--%>
                                <asp:HyperLink ID="hlnkPrintableFormate" runat="server" Target="_blank">Printable Project Form</asp:HyperLink>
                                <br />
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
                        <div class="card-header">Project Information</div>
                        <div class="card-body">
                            <p class="alert-danger-soft">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </p>
                            <form>
                                <!-- Form Group (Task ID)-->
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <div class="btn-group" role="group">
                                            <%--<asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" />--%>
                                            <%--<asp:Button ID="btnNewEditSave" runat="server" Text="New Project" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" />--%>
                                            <asp:Button ID="btnNew" runat="server" Text="New Project" CssClass="btn btn-outline-primary m-1" OnClick="btnNew_Click" Visible="true" />
                                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-outline-primary m-1" OnClick="btnEdit_Click" Visible="false" />

                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false" />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1" Visible="false" OnClick="btnDelete_Click" />
                                            <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6" runat="server" id="divtxtPID" visible="false">
                                        <label class="small mb-1" for="txtPID">Project Number</label>
                                        <div class="input-group">
                                            <asp:TextBox ID="txtPID" runat="server" CssClass="form-control">                                                  
                                            </asp:TextBox>
                                            <asp:ImageButton ID="btnFind" runat="server" AlternateText="Find" CssClass="btn btn-outline-primary ms-2" ImageUrl="~/images/search-icon.png" OnClick="btnFind_Click" />
                                            <div class="input-group-append">
                                                <asp:Button ID="btnListToggle" CssClass="btn btn-outline-secondary" runat="server" OnClick="btnListToggle_Click" Visible="false" />
                                            </div>
                                            
                                        </div>
                                    </div>
                                    <div class="col-md-6" runat="server" id="divtxtStatus" visible="false">
                                        <label class="small mb-1" for="inputTaskID">Status <span class="red">*</span></label>
                                        <asp:DropDownList ID="ddlStatus" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtStatus" CssClass="form-control" runat="server">
                                        </asp:TextBox>
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
                                    <!-- Form Group (Project Name)-->
                                    <div class="col-md-6" runat="server" id="divtxtProject" visible="false">
                                        <label class="small mb-1" for="txtProject">Project Name <span class="red">*</span></label>
                                        <asp:TextBox ID="txtProject" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <div class="col-md-6" runat="server" id="divAssignTo" visible="false">
                                        <label class="small mb-1" for="ddlAssignTo">Assign To <span class="red">*</span></label>
                                         <asp:DropDownList ID="ddlAssignTo" runat="server" CssClass="form-select">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <!-- Form Row        -->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Customer)-->
                                    <div class="col-md-6" runat="server" id="divtxtCustomer" visible="false">
                                        <label class="small mb-1" for="txtCustomer">Customer <span class="red">*</span></label>
                                        <asp:DropDownList CssClass="form-select" ID="ddlCustomer" runat="server"
                                            OnSelectedIndexChanged="ddlCustomer_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtCustomer" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Contact)-->
                                    <div class="col-md-6" runat="server" id="divtxtContact" visible="false">
                                        <label class="small mb-1" for="txtContact">Contact</label>
                                        <asp:DropDownList ID="ddlContact" runat="server" CssClass="form-select">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtContact" runat="server" CssClass="form-control">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Project DB)-->
                                    <div class="col-md-6" runat="server" id="divctrlUploadProjectLoc" visible="false">
                                        <label class="small mb-1" for="inputTaskType">Project DB</label>
                                        <asp:TextBox ID="txtProjectLoc" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <asp:FileUpload ID="ctrlUploadProjectLoc" class="form-control" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row Planned-->
                                <div class="row gx-3 mb-3">
                                    <label class="small mb-1" for="inputPlanned"><b><u>Planned</u></b></label>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Start Date)-->
                                    <div class="col-md-3" runat="server" id="divtxtPlanDateStart" visible="false">
                                        <label class="small mb-1" for="txtPlanDateStart">Start Date</label>
                                        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucPlanDateStart" runat="server" />
                                        <asp:TextBox ID="txtPlanDateStart" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (End Date)-->
                                    <div class="col-md-3" runat="server" id="divtxtPlanDateEnd" visible="false">
                                        <label class="small mb-1" for="inputEndDate">End Date</label>
                                        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucPlanDateEnd" runat="server" />
                                        <asp:TextBox CssClass="form-control" ID="txtPlanDateEnd" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Hours)-->
                                    <div class="col-md-2" runat="server" id="divtxtPlanHours" visible="false">
                                        <label class="small mb-1" for="inputHours">Labor(Hours)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtPlanHours" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Material(Cost))-->
                                    <div class="col-md-2" runat="server" id="divtxtPlanCost" visible="false">
                                        <label class="small mb-1" for="inputDuration">Material(Cost)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtPlanCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Total Cost)-->
                                    <div class="col-md-2" runat="server" id="divtxtPlanTotalCost" visible="false">
                                        <label class="small mb-1" for="inputCosts">Total Cost</label>
                                        <asp:TextBox CssClass="form-control" ID="txtPlanTotalCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row Actual-->
                                <div class="row gx-3 mb-3">
                                    <label class="small mb-1" for="inputOverrun"><b><u>Actual</u></b></label>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Start Date)-->
                                    <div class="col-md-3" runat="server" id="divtxtActualDateStart" visible="false">
                                        <label class="small mb-1" for="txtActualDateStart">Start Date</label>
                                        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucActualDateStart" runat="server" />
                                        <asp:TextBox ID="txtActualDateStart" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (End Date)-->
                                    <div class="col-md-3" runat="server" id="divtxtActualDateEnd" visible="false">
                                        <label class="small mb-1" for="txtOverrunDateEnd">End Date</label>
                                        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucActualDateEnd" runat="server" />
                                        <asp:TextBox CssClass="form-control" ID="txtActualDateEnd" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Labor(Hours))-->
                                    <div class="col-md-2" runat="server" id="divtxtActualHours" visible="false">
                                        <label class="small mb-1" for="txtActualHours">Labor(Hours)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtActualHours" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Material(Cost))-->
                                    <div class="col-md-2" runat="server" id="divtxtActualCost" visible="false">
                                        <label class="small mb-1" for="txtActualCost">Material(Cost)</label>
                                        <asp:TextBox CssClass="form-control" ID="txtActualCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Total Costs)-->
                                    <div class="col-md-2" runat="server" id="divtxtActualTotalCost" visible="false">
                                        <label class="small mb-1" for="txtActualTotalCost">Total Cost</label>
                                        <asp:TextBox CssClass="form-control" ID="txtActualTotalCost" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="accordion" id="accordionPanelsStayOpen">
                    <div class="accordion-item" id="divhlnkWFTasks" runat="server" visible="false">
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
                                            <asp:GridView ID="gvWFTasks" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnSelectedIndexChanging="gvWFTasks_SelectedIndexChanging"
                                                OnRowDeleting="gvWFTasks_RowDeleting"
                                                OnRowDataBound="gvWFTasks_RowDataBound">
                                            </asp:GridView>
                                            <asp:Label ID="lblWFTasks" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkWFTasks" CssClass="hLinkSmall" Text="Assign Workflow" Enabled="false" runat="server"></asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </main>

</asp:Content>

