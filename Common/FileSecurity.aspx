<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="FileSecurity.aspx.cs" Inherits="Common_FileSecurity" Title="Set File Security" %>

<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="SetFileSecurity" ContentPlaceHolderID="PageContent" runat="Server">
    <div class="container-xl px-4 mt-4">
        <div class="row">
            <div class="col-xl-12">
                <!-- Attach a File card-->
                <div class="card mb-4">
                    <div class="card-header">File</div>
                    <div class="card-body">
                        <!-- Form Row-->
                        <div class="row gx-3 mb-3">
                            <div class="col-md-12">
                                <label class="small mb-1" for="lblStatus">File Security</label>
                            </div>
                            <div class="col-md-12">
                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                            </div>
                        </div>
                        <div class="row gx-3 mb-3">
                            <div class="col-md-12">
                                <label class="small mb-1" for="btnEditSave">File Security Settings</label>
                            </div>
                            <div class="col-md-12">
                                <asp:Button ID="btnEditSave" runat="server" CssClass="btnStyle btn btn-outline-primary m-1" Text="Save" OnClick="btnEditSave_Click" />
                                &nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server" CssClass="btnStyle btn btn-outline-primary m-1" Text="Cancel" OnClick="btnCancel_Click" />
                                &nbsp;&nbsp;  
                            </div>
                        </div>
                        <div class="row gx-3 mb-12">
                            <div class="col-md-12">
                                <label class="small mb-1" for="ddlFileSecurity">Security Class</label>
                            </div>
                            <div class="col-md-6">
                                <asp:DropDownList ID="ddlFileSecurity" runat="server" CssClass="form-select">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row gx-3 mb-3">
                            <div class="col-md-12">
                                <label class="small mt-3 mb-1" for="btnEditSave">Current List</label>
                            </div>
                            <div class="col-md-12">
                                <asp:GridView ID="gvFileSecurity" runat="server"
                                    OnRowDataBound="gvFileSecurity_RowDataBound"
                                    OnRowDeleting="gvFileSecurity_RowDeleting">
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--<table class="Table">
 <tr>
  <td>  
     <!-- Header -->
     <table class="Table">
      <tr>    
        <td class="LSGrayXLargeText">File Security</td>
        <td></td>	
      </tr>
      <tr>  
         <td class="FieldContent" colspan="2">
            <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
         </td> 
      </tr>  
     </table>   
        	
     <!-- Document Control Lists Information -->			
	 <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		        &nbsp;File Security Settings            
            </td>				
		</tr>		
		<tr>
		    <td class="TabSubHeader" style="background-color: #FFFFFF">               
                <asp:Button ID="btnEditSave" runat="server"  CssClass="btnStyle" Text="Save" OnClick="btnEditSave_Click"/>
                &nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server"  CssClass="btnStyle" Text="Cancel" OnClick="btnCancel_Click"/>
                &nbsp;&nbsp;                   
            </td>				
		</tr>		
	 </table>	
	 <table  class="Table">		
		<tr>		               
             <td class="FieldHeader" style="background-color: #FFFFFF">
		        Security Class:</td>
		     <td class="FieldContent">
                <asp:DropDownList ID="ddlFileSecurity" runat="server">
                </asp:DropDownList></td>    
		</tr>		
	</table>
	
	<!-- List of Control Lists -->
	<table  class="Table">
		<tr> 
		    <td class="TabHeader">
	            &nbsp;Current List
	        </td>
	    </tr>	    
        <tr>
          <td class="FieldContent">
            <asp:GridView ID="gvFileSecurity" runat="server" 
                OnRowDataBound="gvFileSecurity_RowDataBound"
                OnRowDeleting="gvFileSecurity_RowDeleting">
            </asp:GridView>  
          </td>                        
        </tr>         
     </table>
          
  </td>
 </tr>     
</table>--%>
</asp:Content>

