<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="CopyRoles.aspx.cs" Inherits="CopyRoles" Title="Role Module" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>

<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="RoleModule" ContentPlaceHolderID="PageContent" runat="Server">
    <main>
  <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-auto mb-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Role Module
                                        </h1>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </header>
        <div class="container-xl px-4 mt-4">                                               
                        <div class="row">                          
                            <div class="col-xl-12">
                                <!-- Task Document card-->
                                <div class="card mb-4">
                                    <div class="card-header">Transfer Role </div>                                     
                                    <div class="card-body">
                                        <div class="row">
                                              
                                            <div class="col-md-4">
                                                From Role
                                             <asp:DropDownList ID="AppSecProfile"   CssClass="form-select"  runat="server">  
                                        </asp:DropDownList>  
                                               

                                                 
                                            </div>
                                              
                                        </div>
                                        

                                         <div class="row">
                                            <div class="col-md-4">
                                                To Role
                                             <asp:DropDownList ID="ddl_ToRole" CssClass="form-select"  runat="server">  
                                        </asp:DropDownList>  
                                           <asp:Label ID="Label4" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>

                                                 
                                            </div>
                                        </div>
                                       <%-- <h4>Assign Pages</h4>--%>
                                        <div class="row">
                                            <div class="col-md-12">
                                                
                                                <asp:HiddenField runat="server" ID="hfd_allcheck" Value="True"/>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-2">
                                                <asp:Button ID="saveBtn" runat="server"    CssClass="btn btn-outline-primary m-1" onclick="Button1_Click"   
        Text="Save" /> 
                                                <br />
            <asp:Label runat="server" ID="lblStatus"></asp:Label>

                        </div>
</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                

                            </div>
                             
        </main>
   
</asp:Content>
