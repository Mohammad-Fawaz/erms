<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="DocInformation.aspx.cs" Inherits="DocumentManagement_DocInformation" Title="Document Management" %>

<%@ Register Src="~/App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="DocumentManagement" ContentPlaceHolderID="PageContent" runat="Server">


    <main>
        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            <div class="container-xl px-4">
                <div class="page-header-content">
                    <div class="row align-items-center justify-content-between pt-3">
                        <div class="col-4">
                            <h1 class="page-header-title">
                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                Document Management	
                            </h1>
                        </div>
                        <div class="col-8">
                            <%-- <a href='../Legacy/secweb/ret_selitem.asp?SID=fasskxzrpvk3jdlfa30ljpw1&Listing=Doc&Item="10081-000"' target='_blank' class="hLinkSmallBold">View Document</a> |
                                <a href='../Legacy/secweb/pnt_selitem.asp?Listing=Doc&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a> |
                                <a href='../Legacy/secweb/pnt_chgreq.asp?Listing=Doc&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Document Form</a> |
                                <a href='../Legacy/secweb/pnt_dev.asp?Listing=Doc&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Waiver/Deviation Form</a>
                            --%>
                            <asp:HyperLink ID="hlnkViewDocument" runat="server" Target="_blank">View Document</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableFormate" runat="server" Target="_blank">Printable Format</asp:HyperLink>
                            <%-- |<asp:HyperLink ID="hlnkPrintableDocument" runat="server" Target="_blank">Printable Document Form</asp:HyperLink> 
                            |<asp:HyperLink ID="hlnkPrintableWaiver" runat="server" Target="_blank">Printable Waiver/Deviation Form</asp:HyperLink>--%>
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
                        <div class="card-header">Document Information</div>
                        <div class="card-body">
                            <p class="alert-danger-soft">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </p>
                            <form>
                                <div class="row gx-3 mb-3">
                                    <div class="col-md-6">
                                        <div class="btn-group" role="group">
                                            <%--<asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" Visible="false" />--%>
                                            <asp:Button ID="btnFindNew" runat="server" Text="Find New Document" CssClass="btn btn-outline-primary m-1" OnClick="btnFindNew_Click" Visible="false" />

                                            <%--  <asp:Button ID="btnNewEditSave" runat="server" Text="New Document" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click" Visible="false" />--%>
                                            <asp:Button ID="btnNew" runat="server" Text="New Document" CssClass="btn btn-outline-primary m-1" OnClick="btnNew_Click" Visible="false" />
                                            <asp:Button ID="btnEdit" runat="server" Text="Edit" CssClass="btn btn-outline-primary m-1" OnClick="btnEdit_Click" Visible="false" />

                                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false" />
                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1" Visible="false" OnClick="btnDelete_Click" />
                                            <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />
                                        </div>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Doc Number)-->
                                    <div class="col-md-6" runat="server" id="divtxtDocID" visible="false">
                                        <label class="small mb-1" for="txtDocID">Doc Number</label>
                                        <div class="d-flex">
                                            <asp:TextBox ID="txtDocID" runat="server" CssClass="form-control">                                                  
                                            </asp:TextBox>
                                            <asp:ImageButton ID="btnFind" runat="server" AlternateText="Find" CssClass="btn btn-outline-primary ms-2" ImageUrl="~/images/search-icon.png" OnClick="btnFind_Click" Visible="false" />
                                        </div>
                                    </div>
                                    <!-- Form Group (Status)-->
                                    <div class="col-md-6" runat="server" id="divStatus" visible="false">
                                        <label class="small mb-1" for="txtStatus">Status <span class="red" style='display: <%=Utils.IsRequiredField("Documents","DocStatus") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlStatus" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtStatus" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Revision)-->
                                    <div class="col-md-6" runat="server" id="divRevision" visible="false">
                                        <label class="small mb-1" for="txtRevision">Revision <span class="red" style='display: <%=Utils.IsRequiredField("Documents","CurrentRev") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:TextBox ID="txtRevision" runat="server" CssClass="form-control">                                                  
                                        </asp:TextBox>

                                    </div>
                                    <!-- Form Group (Expires)-->
                                    <div class="col-md-6" runat="server" id="divExpires" visible="false">
                                        <label class="small mb-1" for="txtExpiryDate">Expires</label>
                                        <asp:TextBox ID="txtExpiryDate" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                        <ucCalendar:ERMSCalendar ID="ucDateExpiry" CssClass="form-control" runat="server" />
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Discipline)-->
                                    <div class="col-md-6" runat="server" id="divtxtDiscipline" visible="false">
                                        <label class="small mb-1" for="txtDiscipline">Discipline <span class="red" style='display: <%=Utils.IsRequiredField("Documents","Discipline") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlDiscipline" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlDiscipline_SelectedIndexChanged" Enabled="false">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtDiscipline" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Doc Type)-->
                                    <div class="col-md-6" runat="server" id="divtxtDocType" visible="false">
                                        <label class="small mb-1" for="txtDocType">Document Type<span class="red" style='display: <%=Utils.IsRequiredField("Documents","DocType") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlDocType" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlDocType_SelectedIndexChanged" Enabled="false">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtDocType" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row        -->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (GridView Description)-->
                                    <div class="col-md-6" runat="server" id="divddlNumSchemes" visible="false">
                                        <label class="small mb-1" for="ddlNumSchemes">Number Scheme </label>
                                        <asp:GridView CssClass="table table-bordered table-condensed table-responsive table-hover" ID="gvNumSchemes" runat="server" OnRowDataBound="gvNumSchemes_RowDataBound"
                                            OnSelectedIndexChanging="gvNumSchemes_SelectedIndexChanging"
                                            OnPageIndexChanging="gvNumSchemes_PageIndexChanging" AllowPaging="true" Visible="false">
                                        </asp:GridView>
                                        <asp:DropDownList ID="ddlNumSchemes" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlNumSchemes_SelectedIndexChanged" Enabled="false"></asp:DropDownList>
                                        <asp:TextBox ID="txtNumSchemes" CssClass="form-control" Visible="false" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Tabulated)-->
                                    <div class="col-md-6" runat="server" id="divcbTabulated" visible="false">
                                        <br />
                                        <div class="form-check">
                                            <asp:CheckBox ID="cbTabulated" CssClass="form-check-input" runat="server"></asp:CheckBox>
                                            <label class="form-check-label" for="cbTabulated">
                                                Tabulated <span class="red" style='display: <%=Utils.IsRequiredField("Documents","Tabulated") ? "inline-block": "none" %>'>*</span>
                                            </label>
                                        </div>
                                    </div>

                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Project)-->
                                    <div class="col-md-6" runat="server" id="divtxtProject" visible="false">
                                        <label class="small mb-1" for="inputProject">Project <span class="red" style='display: <%=Utils.IsRequiredField("Documents","ProjNum") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlProject" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtProject" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <div class="col-md-6" runat="server" id="divtxtDescription" visible="false">
                                        <!-- Form Group (Description)-->
                                        <label class="small mb-1" for="inputDescription">Description <span class="red" style='display: <%=Utils.IsRequiredField("Documents","DocDesc") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:TextBox ID="txtDescription" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Requested By)-->
                                    <div class="col-md-6" runat="server" id="divtxtRequestedBy" visible="false">
                                        <label class="small mb-1" for="txtRequestedBy">Requested By <span class="red" style='display: <%=Utils.IsRequiredField("Documents","DocReqBy") ? "inline-block": "none" %>'>*</span></label>
                                        <asp:DropDownList ID="ddlRequestedBy" CssClass="form-select" runat="server">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtRequestedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Requested Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateRequestedBy" visible="false">
                                        <label class="small mb-1" for="txtDateRequestedBy">Requested Date<span class="red" style='display: <%=Utils.IsRequiredField("Documents","DocReqDate") ? "inline-block": "none" %>'>*</span></label>
                                        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucDateRequestedBy" runat="server" />
                                        <asp:TextBox ID="txtDateRequestedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Created By)-->
                                    <div class="col-md-6" runat="server" id="divtxtCreatedBy" visible="false">
                                        <label class="small mb-1" for="txtCreatedBy">Created By</label>
                                        <asp:DropDownList ID="ddlCreatedBy" CssClass="form-select" runat="server"
                                            OnSelectedIndexChanged="ddlCreatedBy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtCreatedBy" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Created Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateCreatedBy" visible="false">
                                        <label class="small mb-1" for="inputAssignedDate">Created Date</label>
                                        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucDateCreatedBy" runat="server" />
                                        <asp:TextBox CssClass="form-control" ID="txtDateCreatedBy" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Reviewed By)-->
                                    <div class="col-md-6" runat="server" id="divtxtReviewedBy" visible="false">
                                        <label class="small mb-1" for="txtReviewedBy">Reviewed By</label>
                                        <asp:DropDownList ID="ddlReviewedBy" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlReviewedBy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtReviewedBy" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Reviewed Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateReviewedBy" visible="false">
                                        <label class="small mb-1" for="txtDateReviewedBy">Reviewed Date</label>
                                        <ucCalendar:ERMSCalendar ID="ucDateReviewedBy" CssClass="form-control" runat="server" />
                                        <asp:TextBox CssClass="form-control" ID="txtDateReviewedBy" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <!-- Form Row-->
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Released By)-->
                                    <div class="col-md-6" runat="server" id="divtxtReleasedBy" visible="false">
                                        <label class="small mb-1" for="txtReleasedBy">Released By</label>
                                        <asp:DropDownList ID="ddlReleasedBy" CssClass="form-select" runat="server"
                                            OnSelectedIndexChanged="ddlReleasedBy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox ID="txtReleasedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Released Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateReleasedBy" visible="false">
                                        <label class="small mb-1" for="txtDateReleasedBy">Released Date</label>
                                        <ucCalendar:ERMSCalendar ID="ucDateReleasedBy" CssClass="form-control" runat="server" />
                                        <asp:TextBox ID="txtDateReleasedBy" CssClass="form-control" runat="server">
                                        </asp:TextBox>
                                    </div>
                                </div>
                                <div class="row gx-3 mb-3">
                                    <!-- Form Group (Obsoleted By)-->
                                    <div class="col-md-6" runat="server" id="divtxtObsoletedBy" visible="false">
                                        <label class="small mb-1" for="txtObsoletedBy">Obsoleted By</label>
                                        <asp:DropDownList ID="ddlObsoletedBy" runat="server" CssClass="form-select"
                                            OnSelectedIndexChanged="ddlObsoletedBy_SelectedIndexChanged">
                                        </asp:DropDownList>
                                        <asp:TextBox CssClass="form-control" ID="txtObsoletedBy" runat="server">
                                        </asp:TextBox>
                                    </div>
                                    <!-- Form Group (Obsoleted Date)-->
                                    <div class="col-md-6" runat="server" id="divtxtDateObsoletedBy" visible="false">
                                        <label class="small mb-1" for="txtDateObsoletedBy">Obsoleted Date</label>
                                        <ucCalendar:ERMSCalendar ID="ucDateObsoletedBy" CssClass="form-control" runat="server" />
                                        <asp:TextBox ID="txtDateObsoletedBy" CssClass="form-control" runat="server">
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
                                        <asp:TextBox ID="txtDateLastModifiedBy" CssClass="form-control" runat="server">
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
                    <div class="accordion-item" runat="server" visible="false" id="divListofAttachedFiles">
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
                                            <asp:HiddenField runat="server" ID="hfd_gvAttachedFiles" />
                                            <asp:GridView ID="gvAttachedFiles" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvAttachedFiles_RowDataBound">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkAttachFiles" Text=" Attach Files" CssClass="hLinkSmall" runat="server" Enabled="false">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" visible="false" id="divListofAddedParts">
                        <h2 class="accordion-header" id="panelsStayOpen-headingAddedParts">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAddedParts" aria-expanded="false" aria-controls="panelsStayOpen-collapseAddedParts">
                                List of Added Parts
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseAddedParts" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAddedParts">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HiddenField runat="server" ID="hfd_gvAddParts" />
                                            <asp:GridView ID="gvAddParts" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDeleting="gvAddParts_RowDeleting"
                                                OnRowDataBound="gvAddParts_RowDataBound"
                                                OnSelectedIndexChanging="gvAddParts_SelectedIndexChanging">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkAddParts" CssClass="hLinkSmall" Text="Add Parts" runat="server" Enabled="false">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" id="divChangeOrderHistory" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingOrderHistory">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOrderHistory" aria-expanded="false" aria-controls="panelsStayOpen-collapseOrderHistory">
                                Change Order History
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseOrderHistory" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingOrderHistory">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HiddenField runat="server" ID="hfd_gvDocHistory" />
                                            <asp:GridView ID="gvDocHistory" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvDocHistory_RowDataBound"
                                                OnRowDeleting="gvDocHistory_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkDocHistory" CssClass="hLinkSmall" Enabled="false" runat="server">
            Add Document to an Existing Change Order</asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" id="divCurrentControlList" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingControlList">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseControlList" aria-expanded="false" aria-controls="panelsStayOpen-collapseControlList">
                                Current Control List
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseControlList" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingControlList">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HiddenField runat="server" ID="hfd_gvControlLists" />
                                            <asp:GridView ID="gvControlLists" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvControlLists_RowDataBound"
                                                OnRowDeleting="gvControlLists_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkControlLists" CssClass="hLinkSmall" Enabled="false" runat="server">
          Set Control List</asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" id="divListofAppliedRestrictions" visible="false">
                        <h2 class="accordion-header" id="panelsStayOpen-headingAppliedRestrictions">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAppliedRestrictions" aria-expanded="false" aria-controls="panelsStayOpen-collapseAppliedRestrictions">
                                List of Applied Restrictions
                            </button>
                        </h2>
                        <div id="panelsStayOpen-collapseAppliedRestrictions" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAppliedRestrictions">
                            <div class="accordion-body">
                                <table class="Table">
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HiddenField runat="server" ID="hfd_gvRestrictions" />
                                            <asp:GridView ID="gvRestrictions" runat="server"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDataBound="gvRestrictions_RowDataBound"
                                                OnRowDeleting="gvRestrictions_RowDeleting">
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkRestrictions" CssClass="hLinkSmall" Text="Set Special Restrictions" Enabled="false" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" id="divListofAddedNotes" visible="false">
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
                                            <asp:HyperLink ID="hlnkNotes" CssClass="hLinkSmall" Text="Add Notes" Enabled="false" runat="server">
                                            </asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" id="divWorkflowTasks" visible="false">
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
                                                OnSelectedIndexChanging="gvWFTasks_SelectedIndexChanging"
                                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                OnRowDeleting="gvWFTasks_RowDeleting"
                                                OnRowDataBound="gvWFTasks_RowDataBound">
                                            </asp:GridView>
                                            <asp:Label ID="lblWFTasks" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldContent">
                                            <asp:HyperLink ID="hlnkWFTasks" CssClass="hLinkSmall" Enabled="false" runat="server">
          Assign Workflow</asp:HyperLink>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item" runat="server" id="divCustomFields" visible="false">
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
                                            <asp:HyperLink ID="hlnkWFCustom" CssClass="hLinkSmall" Visible="false" runat="server">
                                                <asp:Label ID="lblAssign" runat="server" Text="Assign Custom Field Values" Enabled="false"></asp:Label>
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

        <style type="text/css">
            .modalBackground {
                background-color: #212529;
                filter: alpha(opacity=90);
                opacity: 0.8;
            }

            .modalPopup {
                background-color: #fff;
                border: 1px solid rgba(0, 0, 0, 0.2);
                border-radius: 0.5rem;
            }

            .btn-primary {
                padding: 10px 25px !important;
            }

            modal-header h5 {
                font-weight: 600 !important;
            }
        </style>
        <cc1:ToolkitScriptManager runat="server">
        </cc1:ToolkitScriptManager>
        <asp:Button ID="btnShow" runat="server" Text="Show Modal Popup" Style="display: none" />
        <!-- ModalPopupExtender -->
        <cc1:ModalPopupExtender ID="mp1" runat="server" PopupControlID="Panel1" TargetControlID="btnShow"
            CancelControlID="btnSave" BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" align="center" Style="display: none">
            <div class="modal-header">
                <h5 class="modal-title">Document</h5>
            </div>
            <div class="col-md-11 text-start mt-3">
                <label class="small mb-1" for="txtDiscipline">Discipline</label>
                <asp:DropDownList ID="ddlDisciplinePop" runat="server" CssClass="form-select" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlDisciplinePop_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="col-md-11 text-start my-3">
                <label class="small mb-1" for="txtDocType">Document Type</label>
                <asp:DropDownList ID="ddlDocTypePop" runat="server" CssClass="form-select" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlDocTypePop_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="col-md-11 mb-3 text-start">
                <label class="small mb-1" for="ddlNumSchemes">Number Scheme </label>
                <asp:DropDownList ID="ddlNumSchemesPop" runat="server" CssClass="form-select"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlNumSchemesPop_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div class="modal-footer">
                <asp:Button ID="btnSave" class="btn btn-primary" runat="server" Text="Save" />
            </div>
        </asp:Panel>
        <script type="text/javascript">
            $(document).ready(function () {
                $("#PageContent_txtStatus").removeAttr('disabled');

            })
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

            function GetDocDeleteUserConf() {
                var userselect = confirm("This action will also remove other associated records!\n" +
                    "  • Related Files\n" +
                    "  • Related Parts\n" +
                    "  • Associated Control List References\n" +
                    "  • Associated Restriction References\n" +
                    "  • Associated Notes\n" +
                    "  • Associated Custom Fields\n" +
                    "  Are you sure you want to continue?");

                document.getElementById('hdnDeleteUserPref').value = userselect;
            }

        </script>
        <style>
            .red {
                color: red;
            }
        </style>
    </main>
</asp:Content>

