<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AssociateOrders.aspx.cs" Inherits="DocumentManagement_AssociateOrders" Title="Associate Orders" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="AssociateOrders" ContentPlaceHolderID="PageContent" Runat="Server">


    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Associate Orders		
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
                                <!--  card-->
                                <div class="card mb-4">
                                    <div class="card-header">Associate an Order</div>                                     
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
        	
     <!-- Change Request Information -->			
	 <table class="Table">		
       <tr>  
		    <td class="TabSubHeader">               
               <asp:Button ID="btnFind" runat="server" Text="Find" OnClick="btnFind_Click" CssClass="btn btn-primary-soft"/> 
		        &nbsp;&nbsp;
		        <asp:Button ID="btnAttach" runat="server" Text="Attach To Order" Visible="False" OnClick="btnAttach_Click" CssClass="btn btn-primary-soft"/>
                &nbsp;&nbsp;  
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" Visible="False" CssClass="btn btn-primary-soft"/>
                &nbsp;&nbsp;                      
            </td>				
		</tr>		
	 </table>	
	 <table class="Table">
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Order Number:</td>		    
		    <td class="FieldContent">
                <asp:TextBox CssClass="form-control" ID="txtCOID" runat="server"></asp:TextBox>                
            </td>            
		     <td class="FieldHeader" style="background-color: #FFFFFF">
		        Current Status:</td>
		    <td class="FieldContent">
		        <asp:HiddenField ID="hdnDocStatus" runat="server" />		    
                <asp:TextBox CssClass="form-control" ID="txtCurrentStatus" runat="server">
                </asp:TextBox></td>  
		</tr>	
		<tr>
		     <td class="FieldHeader" style="background-color: #FFFFFF">
		        Document's Current Revision:</td>
		     <td class="FieldContent">
                 <asp:TextBox CssClass="form-control" ID="txtCurrentRevision" runat="server">
                 </asp:TextBox></td>
             <td class="FieldHeader" style="background-color: #FFFFFF">		    
		        Document's New Revision:</td>
		    <td class="FieldContent">		       
               <asp:TextBox CssClass="form-control" ID="txtNewRevision" runat="server">
               </asp:TextBox></td>
		</tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td  class="FieldContent" colspan="3">	              
               <asp:TextBox CssClass="form-control" ID="txtCODescription" runat="server">
               </asp:TextBox></td>
		</tr>	               
	</table>
	
	<!-- Current Available Orderss -->
	<table  class="Table">
		<tr> 
		    <td class="TabHeader">
	            &nbsp;Current List of Orders
	        </td>
	    </tr>	    
        <tr>
          <td class="FieldContent">
            <asp:GridView ID="gvCOSearchResults" 
              OnRowDataBound="gvCOSearchResults_RowDataBound"
                 CssClass="table table-bordered table-condensed table-responsive table-hover"
              OnPageIndexChanging="gvCOSearchResults_PageIndexChanging" 
              OnSelectedIndexChanging="gvCOSearchResults_SelectedIndexChanging"
              AllowPaging="True" runat="server">                 
            </asp:GridView>    
          </td>                      
        </tr>
        <tr>
          <td class="FieldContent">
           <asp:HyperLink ID="hlnkReturnLink" CssClass="btn btn-link" runat="server">Return to Document</asp:HyperLink>      
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

