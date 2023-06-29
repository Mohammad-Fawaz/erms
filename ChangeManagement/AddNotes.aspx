<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AddNotes.aspx.cs" Inherits="ChangeManagement_Notes" Title="Add Notes" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="AddNotes" ContentPlaceHolderID="PageContent" Runat="Server">

<main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-auto mb-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Change Management
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
                                <!-- Attach a File card-->
                                <div class="card mb-4">
                                    <div class="card-header">Add a Note</div>                                     
                                    <div class="card-body">
                                        <p class="alert-danger-soft">
                                        <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>                                        
                                           </p>                                        
                                        <form>                                                   
                                            <div class="row gx-3 mb-3">                                                
                                                <div class="col-md-6">
                                                <div class="btn-group" role="group">
                                                    <asp:Button ID="btnEditSave" runat="server"  CssClass="btn btn-outline-primary m-1" Text="Save" OnClick="btnEditSave_Click" />                                                    
                                                     <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" />                                                    
                                                </div>
                                               </div>
                                             </div>

                                            <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                <label class="small mb-1" for="txtSubject">Subject</label>                                            
		                                    <asp:TextBox ID="txtSubject" CssClass="form-control" runat="server"></asp:TextBox>                                                                                                     
                                                    </div>  
                                                <div class="col-md-6">
                                                <label class="small mb-1" for="ddlNoteType">Note Type</label>                                            
		                                   <asp:DropDownList ID="ddlNoteType" CssClass="form-select" runat="server">
                                                </asp:DropDownList>                                                                                                    
                                                    </div>  
                                            </div>  
                                             <div class="row gx-3 mb-3">
                                                 <div class="col-md-6">
                                                      <label class="small mb-1"  for="txtFileDescription">Created Date</label>    
                                                     <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucDateCreatedBy" runat="server"/>                                                        
                                                </div>
                                                <div class="col-md-6">
                                                      <label class="small mb-1" for="txtCreatedBy">Created By</label>    
                                                    <asp:DropDownList ID="ddlCreatedBy" CssClass="form-select" runat="server">
                                                    </asp:DropDownList>	                                                    
                                                </div>                                                
                                                </div>                                          
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (Desc)-->
                                                <div class="col-md-6">
                                                    <label class="small mb-1" for="txtNoteText">Note Text</label>    
                                                              <asp:TextBox ID="txtNoteText" CssClass="form-control" runat="server">
                                                               </asp:TextBox>                                     
                                                </div>                                                                                                   
                                            </div>           
                                             <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                      <h1>List of Added Notes</h1>
                                                </div>
                                                </div>
                                            <div class="row gx-3 mb-3">
                                                 <div class="col-md-12">  
                                                      <asp:GridView ID="gvNotes" CssClass="table table-bordered table-condensed table-responsive table-hover" runat="server" OnRowDataBound="gvNotes_RowDataBound"></asp:GridView>                                                       
                                                </div>
                                            </div>  
                                            <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                     <asp:HyperLink ID="hlnkReturnLink" CssClass="btn btn-link" runat="server">Return to Order Request</asp:HyperLink>      
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

