<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ChangeOrders.aspx.cs" Inherits="ChangeManagement_ChangeOrders" Title="Change Management" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="ChangeManagement" ContentPlaceHolderID="PageContent" runat="Server">
    <asp:HiddenField runat="server" ID="hfd_gvAssociatedDocs" />
    <main>
        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            <div class="container-xl px-4">
                <div class="page-header-content">
                    <div class="row align-items-center justify-content-between pt-3">
                        <div class="col-3">
                            <h1 class="page-header-title">
                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                Change Management	
                            </h1>
                        </div>
                        <div class="col-9">
                            <%--<a href='/Legacy/secweb/ret_selitem.asp?Listing=Change&Item=" & curRec & "' class="hLinkSmallBold" >View Change</a> | --%>
                            <%--<a href='/Legacy/secweb/ret_selitem.asp?Listing=Change&Item=" & curRec & "' class="hLinkSmallBold">View Change</a> | 
                                         <a href='/Legacy/secweb/pnt_selitem.asp?Listing=Change&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a> |
                                         <a href='/Legacy/secweb/pnt_chgreq.asp?Listing=Change&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Change Request Form</a> |
                                         <a href='/Legacy/secweb/pnt_dev.asp?Listing=Change&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Waiver/Deviation Form</a>--%>

                            <asp:HyperLink ID="hlnkViewChange" runat="server" Target="_blank">View Change</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableFormate" runat="server" Target="_blank">Printable Format</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableChangeRequest" runat="server" Target="_blank">Printable Change Request Form</asp:HyperLink>
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
                    <!-- Task Document card-->
                    <div class="card mb-4">
                        <div class="card-header">Change Order Information</div>
                        <div class="card-body">
                            <p class="alert-danger-soft">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </p>
                            <form>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <div class="btn-group" role="group">

                                            <%--<asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" Visible="false" />--%>

                                            <asp:Button ID="btnNew" runat="server" Text="New Change Request" CssClass="btn btn-outline-primary m-1" OnClick="btnNew_Click" Visible="false" />
                                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-outline-primary m-1" OnClick="btnEdit_Click" Visible="false" />
                                            <%--<asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-outline-primary m-1" OnClick="btnSave_Click" Visible="false" />
                                            <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-outline-primary m-1" OnClick="btnUpdate_Click" Visible="false" />--%>

                                           <%-- <asp:Button ID="btnNewEditSave" runat="server" Text="New Change Request" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" Visible="false" />--%>
                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false" />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1" Visible="false" OnClick="btnDelete_Click" />
                                            <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />
                                        </div>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Change Number)-->
                                    <div class="col-md-6" runat="server" id="divtxtChangeID" visible="false">
                                        <label class="small mb-1" for="txtChangeID">Change Number<span class="red" style='display: <%=Utils.IsRequiredField("Changes","CO") ? "inline-block": "none" %>'>*</span></label>
                                        <div class="d-flex">
                                            <asp:TextBox ID="txtChangeID" runat="server" CssClass="form-control">                                                  
                                            </asp:TextBox>
                                            <asp:ImageButton ID="btnFind" runat="server" AlternateText="Find" CssClass="btn btn-outline-primary ms-2" ImageUrl="~/images/search-icon.png" OnClick="btnFind_Click" Visible="false" />
                                        </div>
                                    </div>
                                    <!-- Form Group (Status)-->
                                    <div class="col-md-6" runat="server" id="divtxtStatus" visible="false">
                                        <label class="small mb-1" for="txtStatus">Status <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChStatus") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlStatus" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtStatus" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Change Type)-->
                                    <div class="col-md-6" runat="server" id="divtxtChangeType" visible="false">
                                        <label class="small mb-1" for="txtChangeType">Change Type <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChangeType") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList CssClass="form-select" ID="ddlChangeType" AutoPostBack="true" OnSelectedIndexChanged="ddlChangeType_OnSelectedIndexChanged" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtChangeType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Change Class)-->
                                    <div class="col-md-6" runat="server" id="divtxtChangeClass" visible="false">
                                        <label class="small mb-1" for="txtChangeClass">Change Class <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChangeClass") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlChangeClass" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtChangeClass" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Group (Requested Date)-->

                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Requested By)-->
                                    <div class="col-md-6" runat="server" id="divtxtRequestedBy" visible="false">
                                        <label class="small mb-1" for="txtRequestedBy">Requested By <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChReqBy") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlRequestedBy" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtRequestedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Requested Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateRequestedBy" visible="false">
                                        <label class="small mb-1" for="txtDateRequestedBy">Requested Date<span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChReqDate") ? "inline-block": "none" %>'>*</span></label>
                                        <%--  <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucDateRequestedBy" runat="server"/>--%>
                                        <asp:TextBox ID="txtDateRequestedBy" type="text" placeholder="MM/DD/YYYY" CssClass="form-control datepicker" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Effective/Start Date)-->
                                    <div class="col-md-6" visible="false" runat="server" id="divtxtStartDate">
                                        <label class="small mb-1" for="txtStartDate">Effective/Start Date<span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChEffDate") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:TextBox ID="txtStartDate" type="text" runat="server" placeholder="MM/DD/YYYY" CssClass="form-control datepicker">                                                  
                                        </asp:TextBox>
                                        <%--<ucCalendar:ERMSCalendar ID="ucDateStart" CssClass="form-control" runat="server" />--%>
                                    </div>
                                    <!-- Form Group (Due Date)-->
                                    <div class="col-md-6">
                                        <label class="small mb-1" for="txtEndDate">Due Date <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChDue") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:TextBox ID="txtEndDate" CssClass="form-control datepicker" placeholder="MM/DD/YYYY" type="text" runat="server">
                                        </asp:TextBox>
                                        <%--  <ucCalendar:ERMSCalendar ID="ucDateEnd" CssClass="form-control" runat="server" />--%>
                                    </div>
                                </div>

                                <!-- Form Row        -->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Priority)-->
                                    <div class="col-md-6" runat="server" id="divtxtPriority" visible="false">
                                        <label class="small mb-1" for="txtPriority">Priority <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChPriority") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList CssClass="form-select" ID="ddlPriority" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtPriority" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Justification)-->
                                    <div class="col-md-6" runat="server" id="divtxtJustification" visible="false">
                                        <label class="small mb-1" for="txtJustification">Justification <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChJustification") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlJustification" runat="server" CssClass="form-select">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtJustification" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <%--  --%>
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Project)-->
                                    <div class="col-md-6" runat="server" id="divChargeNumber" visible="false">
                                        <label class="small mb-1" for="inputProject">Charge Number </label>

                                        <asp:TextBox ID="TextBox1" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <div class="col-md-6" runat="server" id="divtxtProject" visible="false">
                                        <label class="small mb-1" for="inputProject">Project <span class="red" style='display: <%=Utils.IsRequiredField("Changes","ProjNum") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlProject" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtProject" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>

                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Project)-->

                                </div>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-12" runat="server" id="divtxtDescription" visible="false">
                                        <label class="small mb-1" for="inputDescription">Description of Changes<span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChangeDesc") ? "inline-block": "none" %>'>*</span></label>
                                        <CKEditor:CKEditorControl ID="txtDescription" BasePath="../ckeditor/" runat="server" ToolbarStartupExpanded="false">
                                        </CKEditor:CKEditorControl>
                                        <%--<asp:TextBox ID="txtDescription" CssClass="form-control" runat="server"></asp:TextBox>--%>
                                    </div>
                                </div>
                                <!-- Form Row-->


                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Approved By)-->
                                    <div class="col-md-6" runat="server" id="divtxtApprovedBy" visible="false">
                                        <label class="small mb-1" for="txtCreatedBy">Approved By </label>
                                        <asp:DropDownList ID="ddlApprovedBy" CssClass="form-select" runat="server"
                                            OnSelectedIndexChanged="ddlApprovedBy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtApprovedBy" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Approved Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateApprovedBy" visible="false">
                                        <label class="small mb-1" for="txtDateApprovedBy">Approved Date</label>
                                        <%--  <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucDateApprovedBy" runat="server"/>--%>
                                        <asp:TextBox placeholder="MM/DD/YYYY" CssClass="form-control datepicker" ID="txtDateApprovedBy" type="text" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Assigned By)-->
                                    <div class="col-md-6" runat="server" id="divtxtAssignedTo" visible="false">
                                        <label class="small mb-1" for="txtAssignedBy">Assigned To<span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChAssignTo") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlAssignedTo" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlAssignedTo_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtAssignedTo" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Assigned Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateAssignedTo" visible="false">
                                        <label class="small mb-1" for="txtDateAssignedTo">Assigned Date<span class="red" style='display: <%=Utils.IsRequiredField("Changes","ChAssignDate") ? "inline-block": "none" %>'>*</span></label>
                                        <%--  <ucCalendar:ERMSCalendar ID="ucDateAssignedTo" CssClass="form-control" runat="server"/>--%>
                                        <asp:TextBox placeholder="MM/DD/YYYY" CssClass="form-control datepicker" ID="txtDateAssignedTo" type="text" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Completed By)-->
                                    <div class="col-md-6" runat="server" id="divtxtCompletedBy" visible="false">
                                        <label class="small mb-1" for="txtCompletedBy">Completed By</label>
                                        <asp:DropDownList ID="ddlCompletedBy" CssClass="form-select" runat="server"
                                            OnSelectedIndexChanged="ddlCompletedBy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtCompletedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Completed Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateCompletedBy" visible="false">
                                        <label class="small mb-1" for="txtDateCompletedBy">Completed Date</label>
                                        <%--   <ucCalendar:ERMSCalendar ID="ucDateCompletedBy" CssClass="form-control" runat="server"/>--%>
                                        <asp:TextBox ID="txtDateCompletedBy" Type="text" placeholder="MM/DD/YYYY" CssClass="form-control datepicker" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Released By)-->
                                    <div class="col-md-6" runat="server" id="divtxtReleasedBy" visible="false">
                                        <label class="small mb-1" for="txtReleasedBy">Released By</label>
                                        <asp:DropDownList ID="ddlReleasedBy" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlReleasedBy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtReleasedBy" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Released Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateReleasedBy" visible="false">
                                        <label class="small mb-1" for="txtDateReleasedBy">Released Date</label>
                                        <%-- <ucCalendar:ERMSCalendar ID="ucDateReleasedBy" CssClass="form-control" runat="server"/>--%>
                                        <asp:TextBox ID="txtDateReleasedBy" type="text" placeholder="MM/DD/YYYY" CssClass="form-control datepicker" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Last Modified By)-->
                                    <div class="col-md-6" runat="server" id="divtxtLastModifiedBy" visible="false">
                                        <label class="small mb-1" for="txtReviewedBy">Last Modified By</label>
                                        <asp:TextBox ID="txtLastModifiedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Last Modified Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateLastModifiedBy" visible="false">
                                        <label class="small mb-1" for="txtDateReviewedBy">Last Modified Date</label>
                                        <asp:TextBox ID="txtDateLastModifiedBy" type="text" placeholder="MM/DD/YYYY" CssClass="form-control datepicker" runat="server">
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
                    <%--      9   List of Associated Documents --%>
                    <div class="accordion-item" runat="server" id="divhlnkAssocDoc" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingOne">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="false" aria-controls="panelsStayOpen-collapseOne">
                                List of Associated Documents
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingOne">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:GridView ID="gvAssociatedDocs" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDeleting="gvAssociatedDocs_RowDeleting"
                                                OnRowDataBound="gvAssociatedDocs_RowDataBound">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkAssocDoc" CssClass="hLinkSmall" Text="Associate Documents" Enabled="false" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%--10 List of Attached Files --%>
                    <div class="accordion-item" runat="server" id="divhlnkAttachFiles" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingAttachedFiles">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAttachedFiles" aria-expanded="false" aria-controls="panelsStayOpen-collapseAttachedFiles">
                                List of Attached Files
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseAttachedFiles" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAttachedFiles">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <!--
          <div id="divgvScroll" style="overflow: scroll">-->
                                            <asp:HiddenField runat="server" ID="hfd_gvAttachedFiles" />
                                            <asp:GridView ID="gvAttachedFiles" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvAttachedFiles_RowDataBound"
                                                OnRowDeleting="gvAttachedFiles_RowDeleting">
                                            </asp:GridView>
                                            <!--</div>-->
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
                    <%-- 11 --%>
                    <div class="accordion-item" runat="server" id="divhlnkNotes" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingAddedNotes">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAddedNotes" aria-expanded="false" aria-controls="panelsStayOpen-collapseAddedNotes">
                                List of Added Notes
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseAddedNotes" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAddedNotes">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HiddenField runat="server" ID="hfd_gvNotes" />
                                            <asp:GridView ID="gvNotes" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvNotes_RowDataBound"
                                                OnRowDeleting="gvNotes_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkNotes" CssClass="hLinkSmall" Enabled="false" Text="Add Notes" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%-- 12 --%>
                    <div class="accordion-item" runat="server" id="divhlnkChangeImpact" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingChangeImpact">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseChangeImpact" aria-expanded="false" aria-controls="panelsStayOpen-collapseChangeImpact">
                                Change Impact
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseChangeImpact" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingChangeImpact">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HiddenField runat="server" ID="hfd_gvChangeImpact" />
                                            <asp:GridView ID="gvChangeImpact" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvChangeImpact_RowDataBound"
                                                OnRowDeleting="gvChangeImpact_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkChangeImpact" CssClass="hLinkSmall" Text="Impact Build/Rebuild" Enabled="false" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%-- 13 --%>
                    <div class="accordion-item" runat="server" id="divhlnkMaterialDisposition" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingMaterialDisposition">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseMaterialDisposition" aria-expanded="false" aria-controls="panelsStayOpen-collapseMaterialDisposition">
                                Material Disposition
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseMaterialDisposition" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingMaterialDisposition">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HiddenField runat="server" ID="hfd_gvMaterialDispositionInfo" />
                                            <asp:GridView ID="gvMaterialDispositionInfo" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvMaterialDispositionInfo_RowDataBound"
                                                OnRowDeleting="gvMaterialDispositionInfo_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkMaterialDisposition" CssClass="hLinkSmall" Text="Material Disposition" Enabled="false" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%-- 14 --%>
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
                                            <asp:HiddenField runat="server" ID="hfd_gvWFTasks" />
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
                                            <asp:HyperLink ID="hlnkWFTasks" Text="Assign Workflow" Enabled="false" CssClass="hLinkSmall" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <%-- 15 --%>
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
    </main>

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

        function GetChangeDeleteUserConf() {
            var userselect = confirm("This action will also remove other associated records!\n" +
                "  • Associated Document References\n" +
                "  • Associated Attachments\n" +
                "  • Associated Notes\n" +
                "  • Associated Custom Fields\n" +
                "  Are you sure you want to continue?");

            document.getElementById('hdnDeleteUserPref').value = userselect;
        }
        var str = document.getElementById("PageContent_hfd_gvAssociatedDocs").value;
        if (str == "") {
            var arr = $('#PageContent_gvAssociatedDocs tr').find('td:first').map(function () {
                return $(this).children().attr("href", "javscript:void(0)");
            }).get()
        }
    </script>
    <style>
        .cell {
            cursor: text;
        }

        .red {
            color: red;
        }
    </style>
</asp:Content>
