<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AttachFiles.aspx.cs" Inherits="ChangeManagement_AttachFiles" Title="Attach Files" %>

<%@ MasterType VirtualPath="~/Default.master" %>
<asp:Content ID="AttachFiles" ContentPlaceHolderID="PageContent" runat="Server">

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
                                    <div class="card-header">Attach a File</div>                                     
                                    <div class="card-body">
                                        <p class="alert-danger-soft">
                                        <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>                                        
                                           </p>
                                        <p class="alert-danger-soft">
                                        <asp:Label ID="lblfUploadStatus" CssClass="CtrlWideValueViewRed" runat="server"></asp:Label>
                                           </p>
                                        <form>           
                                           <%-- <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                      <h1> Attach a File</h1>
                                                </div>                                                                                             
                                                </div>--%>
                                            <div class="row gx-3 mb-3">                                                
                                                <div class="col-md-6" >
                                                <div class="btn-group" role="group">
                                                    <asp:Button ID="btnAddEditSave" runat="server" Text="Add File" CssClass="btn btn-outline-primary m-1"  OnClick="btnAddEditSave_Click"/>
                                                     <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" Visible="false"/>                                                    
                                                </div>
                                               </div>
                                             </div>

                                            <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                <label class="small mb-1" for="txtFileLocation">File Location</label>
                                                    <asp:HiddenField ID="hdnFileID" runat="server" />   		    
		                                    <asp:TextBox ID="txtFileLocation" CssClass="form-control" runat="server"></asp:TextBox> 
                                            <asp:FileUpload ID="ctrlFileUpload" CssClass="form-control" runat="server" OnPreRender="ctrlFileUpload_PreRender"/>                                                        
                                                        
                                                    </div>                                                                                             
                                            </div>                                            
                                            <!-- Form Row-->
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (Print Size)-->
                                                <div class="col-md-6">
                                                    <label class="small mb-1" for="txtEmployee">Print Size</label>
                                                       <asp:TextBox CssClass="form-control" ID="txtPrintSize" runat="server">
                                                       </asp:TextBox>       
                                                       <asp:DropDownList ID="ddlPrintSize" CssClass="form-select" runat="server">
                                                       </asp:DropDownList>
                                                </div>
                                                <!-- Form Group ()-->
                                                <div class="col-md-3" id="divHlnkFileSecurity" visible="false" runat="server">
                                                     <asp:HyperLink ID="hlnkFileSecurity" runat="server" Visible="false">
                                                            File Security</asp:HyperLink>                                            
                                                </div>  
                                                <!-- Form Group (checkbox)-->
                                                <div class="col-md-3">
                                                    <label class="small mb-1" for="cbAFWView"><br /><br /><br /></label>                                                  
                                                         <asp:CheckBox ID="cbAFWView" runat="server" />
                                                </div>
                                            </div>
                                            <!-- Form Row        -->
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (Print Locatio)-->
                                                <div class="col-md-6">
                                                    <label class="small mb-1" for="txtEmail">Print Location</label>    
                                                              <asp:TextBox CssClass="form-select" ID="txtPrintLocation" runat="server">
                                                       </asp:TextBox> 
                                                       <asp:DropDownList CssClass="form-control" ID="ddlPrintLocation" runat="server">
                                                       </asp:DropDownList>                                          
                                                </div>       
                                                <div class="col-md-6">
                                                    <label class="small mb-1" for="cbOverwrite"><br /><br /><br /></label>    
                                                     <asp:CheckBox ID="cbOverwrite" runat="server" />
                                                </div>                                                
                                            </div>           
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (Desc)-->
                                                <div class="col-md-6">
                                                    <label class="small mb-1" for="txtFileDescription">Description</label>    
                                                              <asp:TextBox ID="txtFileDescription" CssClass="form-control" runat="server">
                                                               </asp:TextBox>                                     
                                                </div>                                                                                                   
                                            </div>           
                                             <div class="row gx-3 mb-3">
                                                <div class="col-md-6">
                                                      <h1>List of Attached Files </h1>
                                                </div>
                                                </div>
                                            <div class="row gx-3 mb-3">
                                                 <div class="col-md-12">                                                                      
                                                      <asp:GridView ID="gvFileResults" runat="server" 
                                                          CssClass="table table-bordered table-condensed table-responsive table-hover"
                                                            OnRowDataBound="gvFileResults_RowDataBound"
                                                            OnSelectedIndexChanging="gvFileResults_SelectedIndexChanging">
                                                        </asp:GridView>                                        
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

