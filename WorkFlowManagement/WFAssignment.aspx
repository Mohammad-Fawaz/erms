<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="WFAssignment.aspx.cs" Inherits="WFManagement_WFAssignment" Title="Workflow Assignment" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="WFAssignment" ContentPlaceHolderID="PageContent" runat="Server">


    <main>
        <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
            <div class="container-xl px-4">
                <div class="page-header-content">
                    <div class="row align-items-center justify-content-between pt-3">
                        <div class="col-3">
                            <h1 class="page-header-title">
                                <div class="page-header-icon"><i data-feather="user"></i></div>
                                Workflow Assignment		
                            </h1>
                        </div>
                        <div class="col-9">
                            <%--<a href='ret_selitem.asp?Listing=WF&Item=" & curRec & "' class="hLinkSmallBold">View Assignment</a> | 
         <a href='pnt_selitem.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a>| 
         <a href='pnt_chgreq.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Assignment Form</a>| 
         <a href='pnt_dev.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Waiver/Deviation Form</a>--%>

                             <asp:HyperLink ID="hlnkViewAssignment" runat="server" Target="_blank">View Assignment</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableFormate" runat="server" Target="_blank">Printable Format</asp:HyperLink>
                            |
                            <asp:HyperLink ID="hlnkPrintableAssignmentForm" runat="server" Target="_blank">Printable Assignment Form</asp:HyperLink>
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
                        <div class="card-header">Workflow Assignment Information </div>
                        <div class="card-body">

                            <table class="Table">
                                <tr>
                                    <td>
                                        <!-- Header -->
                                        <table class="Table">

                                            <tr>
                                            </tr>
                                        </table>

                                        <!-- WF Information -->
                                        <table class="Table">

                                            <tr>
                                            </tr>
                                            <tr>
                                            </tr>
                                        </table>
                                        <!-- WorkFlow Task Header -->
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="FieldContent">
                                                    <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="col-12 mb-4">
                                                <div class="TabSubHeader">
                                                    <asp:Button ID="btnFind" runat="server" Text="Find" CssClass="btn btn-primary-soft" OnClick="btnFind_Click" />
                                                    <asp:Button ID="btnAssign" runat="server" Text="Assign Template Tasks" CssClass="btn btn-primary-soft" OnClick="btnAssign_Click" Visible="False" />
                                                    &nbsp;&nbsp;                                        
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="TabHeader">
                                                    <h1>Reference Header</h1>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-6">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">
                                                    Ref. Type:
                                                </lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlRefControlHeader" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtRefControlHeader" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF;">
                                                    Ref. ID:
                                                </lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtRefControlID" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row mt-5">
                                            <div class="col-12">
                                                <div class="TabHeader">
                                                    <h1>Workflow Template Header</h1>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Template Name:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtTemplateName" runat="server">
                                                    </asp:TextBox>
                                                    <asp:DropDownList CssClass="form-select" ID="ddlTemplateName" runat="server"
                                                        OnSelectedIndexChanged="ddlTemplateName_SelectedIndexChanged">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Template Type:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtTemplateType" runat="server">
                                                    </asp:TextBox>
                                                    <asp:DropDownList CssClass="form-select" ID="ddlTemplateType" runat="server">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Description:</lable>
                                                <div class="FieldContent" colspan="3">
                                                    <asp:TextBox CssClass="form-control" ID="txtDescription" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Priority:</lable>
                                                <div class="FieldContent">
                                                    <asp:DropDownList CssClass="form-select" ID="ddlPriority" runat="server">
                                                    </asp:DropDownList>
                                                    <asp:TextBox CssClass="form-control" ID="txtPriority" runat="server">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <lable class="FieldHeader small mb-1" style="background-color: #FFFFFF">Charge Account:</lable>
                                                <div class="FieldContent">
                                                    <asp:TextBox CssClass="form-control" ID="txtChargeAccount" runat="server">
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
                                            <div class="col-12  mb-3">
                                                <div class="TabHeader">
                                                    Workflow Template Steps           
                                                </div>
                                                <div class="FieldContentCenter">
                                                    <asp:GridView ID="gvWFSteps" CssClass="table table-bordered table-condensed table-responsive table-hover" runat="server" OnRowDataBound="gvWFSteps_RowDataBound">
                                                    </asp:GridView>
                                                    <asp:Label ID="lblWFSteps" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="TabHeader">
                                                    Current Tasks / Steps         
                                                </div>
                                                <div class="FieldContentCenter" colspan="4">
                                                    <asp:GridView ID="gvWFTasks" runat="server"
                                                        CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                        OnSelectedIndexChanging="gvWFTasks_SelectedIndexChanging"
                                                        OnRowDeleting="gvWFTasks_RowDeleting"
                                                        OnRowDataBound="gvWFTasks_RowDataBound">
                                                    </asp:GridView>
                                                    <asp:Label ID="lblWFTasks" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                                                </div>
                                            </div>
                                            <table class="Table">
                                                <tr>
                                                    <td class="FieldContent">
                                                        <asp:HyperLink ID="hlnkGoBack" CssClass="btn btn-link" runat="server"> Back to Reference Item</asp:HyperLink>
                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                        <table class="Table">
                                            <tr>
                                            </tr>
                                            <tr>
                                            </tr>
                                        </table>

                                        <!-- Workflow Template Header -->
                                        <table class="Table">
                                            <tr>
                                            </tr>
                                            <tr>
                                            </tr>
                                            <tr>
                                            </tr>
                                            <tr>
                                            </tr>
                                        </table>

                                        <!-- WorkFlow Steps -->
                                        <table class="Table">
                                            <tr>
                                            </tr>
                                            <tr>
                                            </tr>
                                        </table>

                                        <!-- Current Tasks -->
                                        <table class="Table">
                                            <tr>
                                            </tr>
                                            <tr>
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

