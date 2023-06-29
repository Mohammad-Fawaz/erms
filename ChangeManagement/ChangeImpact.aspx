<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ChangeImpact.aspx.cs" Inherits="ChangeManagement_ChangeImpact" Title="Change Impacts" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="ChangeImpacts" ContentPlaceHolderID="PageContent" Runat="Server">
 
<main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Change Impacts	
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
                                <!-- card-->
                                <div class="card mb-4">
                                    <div class="card-header">Change Impact</div>                                     
                                    <div class="card-body">
                                       <table class="Table">
 <tr>
  <td>  
     <!-- Header -->
     <table class="Table"> 
      <tr>  
         <td class="FieldContent" colspan="2">
            <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
         </td> 
      </tr>  
     </table>   
        	
     <!-- Impact Information -->			
	 <table class="Table">		
		<tr>
		    <td class="TabSubHeader"> 
		        <asp:Button ID="btnRebuild" runat="server" CssClass="btn btn-primary-soft" Text="Re-Build" OnClick="btnRebuild_Click" /> 
		        &nbsp;&nbsp; 
		        <asp:Button ID="btnSave" runat="server" CssClass="btn btn-primary-soft" Text="Save" OnClick="btnSave_Click"/> 
		        &nbsp;&nbsp; 
            </td>	
        </tr>		
	 </table>	
	 <table class="Table">
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Order ID:</td>		    
		    <td class="FieldContent">
                <asp:TextBox CssClass="form-control"  ID="txtOrderID" runat="server">
                </asp:TextBox></td> 
            <td class="FieldHeader" bgcolor="White" style="background-color: #FFFFFF">
		        Order Line:</td>
		    <td class="FieldContent">
                 <asp:TextBox CssClass="form-control"  ID="txtOrderLine" runat="server">
                 </asp:TextBox></td>                      
		    
		</tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Order Type:</td>
		    <td class="FieldContent">		    
                <asp:TextBox CssClass="form-control"  ID="txtOrderType" runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Part Number:</td>
		    <td class="FieldContent">		        
                <asp:TextBox CssClass="form-control"  ID="txtPartNumber" runat="server">
                </asp:TextBox></td>          
		</tr>
        <tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
                Status:</td>
		    <td class="FieldContent">
                <asp:TextBox CssClass="form-control"  ID="txtStatus" runat="server">
                </asp:TextBox></td>     
            <td class="FieldHeader" bgcolor="White" style="background-color: #FFFFFF">
		        Quantity:</td>
		    <td class="FieldContent">		      
                <asp:TextBox CssClass="form-control"  ID="txtQty" runat="server">
                </asp:TextBox></td>                          
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Revision:</td>
		    <td class="FieldContent">		        
                <asp:TextBox CssClass="form-control"  ID="txtRevision" runat="server">
                </asp:TextBox></td>           
            <td class="FieldHeader" style="background-color: #FFFFFF">		    
		        Unit:</td>
		    <td class="FieldContent">
                <asp:TextBox CssClass="form-control"  ID="txtUnit" runat="server">
                </asp:TextBox></td>
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Revision Status:</td>
		    <td class="FieldContent">		       
                <asp:TextBox CssClass="form-control"  ID="txtRevisionStatus" runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Cost:</td>
		    <td class="FieldContent">		       
                <asp:TextBox CssClass="form-control"  ID="txtCost" runat="server">
                </asp:TextBox></td>                  
		</tr>   
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td class="FieldContent" colspan="3">		
                <asp:TextBox CssClass="form-control"  ID="txtDescription" runat="server">
                </asp:TextBox></td>
		</tr>		
	  </table>
	  	  	 
	  <!-- Current Available List of Impacts-->		  
	  <table class="Table">
		<tr> 
		    <td class="TabHeader">
	           <h1>Current List of Impacts</h1>
	        </td>
	    </tr>	    
         <tr>
            <td class="FieldContent">
                <asp:GridView ID="gvImpacts" runat="server" AllowPaging="True" 
                  OnRowDataBound="gvImpacts_RowDataBound"
                    CssClass="table table-bordered table-condensed table-responsive table-hover"
                  OnPageIndexChanging="gvImpacts_PageIndexChanging"
                  OnRowDeleting="gvImpacts_RowDeleting"
                  OnSelectedIndexChanging="gvImpacts_SelectedIndexChanging">
                </asp:GridView>                          
            </td>    
         </tr>
         <tr>
           <td class="FieldContent">
            <asp:HyperLink ID="hlnkReturnLink" CssClass="btn btn-link" runat="server">Return to Order Request</asp:HyperLink> 
            </td>
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

