<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="MyReports.aspx.cs" Inherits="Reports_MyReports" Title="My Reports" %>
<%@ MasterType VirtualPath="~/Default.master"%> 

<asp:Content ID="MyReports" ContentPlaceHolderID="PageContent" Runat="Server">
    <main>
          <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-auto mb-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Reports	
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
                                <!-- Task Document card-->
                                <div class="card mb-4">
                                    <div class="card-header">My Reports  </div>                                     
                                    <div class="card-body">
                                                     <asp:Button ID="btnNewEditSave" runat="server" Text="Add New Report" CssClass="btnStyle btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click"/>
                                        <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                                         <asp:GridView Cssclass="table" ID="gvReports" runat="server" 
                        OnRowDataBound="gvReports_RowDataBound" 
                        OnSelectedIndexChanging = "gvReports_SelectedIndexChanging" 
                        OnRowDeleting="gvReports_RowDeleting" OnPageIndexChanging="gvReports_PageIndexChanging" AllowPaging="true">
            </asp:GridView>
                                        		      
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

    </main>
<!-- My Reports Section -->			
    <%--<table class="Table">
        <tr>
            <td class="TabHeaderCenter">		  
            My Reports              
            </td>				
        </tr>
        <tr>
		    <td class="TabSubHeader" style="background-color: #FFFFFF">               
                &nbsp;&nbsp;                                        
            </td>				
		</tr>
        <tr>
            <td class="FieldContent">
            </td>
        </tr>
    </table>--%>
    
    

</asp:Content>