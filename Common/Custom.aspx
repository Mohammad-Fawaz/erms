<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="Custom.aspx.cs" Inherits="Common_Custom" Title="Custom Fields" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="CustomFields" ContentPlaceHolderID="PageContent" Runat="Server">
<main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Custom	
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
                                    <div class="card-header">Custom Fields</div>                                     
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
        	
     <!-- Custom Fields -->			
	 <table  class="Table">
			
		<tr>
		    <td class="TabSubHeader" bgcolor="White">               
                <asp:Button ID="btnEditSave" runat="server"  CssClass="btn btn-primary-soft" Text="Save" OnClick="btnEditSave_Click"/>
                &nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server"  CssClass="btn btn-primary-soft" Text="Cancel" OnClick="btnCancel_Click" Visible="false" />
                &nbsp;&nbsp;                   
            </td>				
		</tr>		
	 </table>	
	 <table  class="Table">		
		<tr>		    
             <td class="FieldHeader">	
             <asp:Label ID="lblCustom1" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>
		     <td class="FieldContent">		
		        <asp:TextBox CssClass="form-control" ID="txtCustom1" runat="server">
                </asp:TextBox></td>                               
		</tr>
		<tr>		    
             <td class="FieldHeader"><asp:Label ID="lblCustom2" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
		     <td class="FieldContent">		
		        <asp:TextBox CssClass="form-control" ID="txtCustom2" runat="server">
                </asp:TextBox></td>                               
		</tr>
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom3" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             		    
		     <td class="FieldContent">		
		        <asp:TextBox CssClass="form-control" ID="txtCustom3" runat="server">
                </asp:TextBox></td>                               
		</tr>
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom4" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             
		     <td class="FieldContent">		
		        <asp:TextBox CssClass="form-control" ID="txtCustom4" runat="server">
                </asp:TextBox></td>                               
		</tr>
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom5" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             
		     <td class="FieldContent">		
		        <asp:TextBox CssClass="form-control" ID="txtCustom5" runat="server">
                </asp:TextBox></td>                               
		</tr>
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom6" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             
		     <td class="FieldContent">		
		        <asp:TextBox CssClass="form-control" ID="txtCustom6" runat="server">
                </asp:TextBox></td>                               
		</tr>	    
		
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom7" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             
             		    		     
              <td class="FieldContent">	        
                <asp:CheckBox ID="cbCustom1" runat="server">
                </asp:CheckBox></td>                            
		</tr>	    
		
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom8" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             
		      <td class="FieldContent">	        
                <asp:CheckBox ID="cbCustom2" runat="server">
                </asp:CheckBox></td>                            
		</tr>	    
		
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom9" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             
		      <td class="FieldContent">	        
                <asp:CheckBox ID="cbCustom3" runat="server">
                </asp:CheckBox></td>                            
		</tr>	    
		
		<tr>		    
             <td class="FieldHeader">
             <asp:Label ID="lblCustom10" runat="server" CssClass="CtrlWideValueViewRed" BackColor="White"></asp:Label> </td>		    		     
             
		      <td class="FieldContent">	        
                <asp:CheckBox ID="cbCustom4" runat="server">
                </asp:CheckBox></td>                            
		</tr>	    
                           
	</table>
	
	<!-- For Redirecting -->
	<table  class="Table">		
         <tr>
          <td class="FieldContent">
            <asp:HyperLink ID="hlnkReturnLink" CssClass="hLinkXSmall" runat="server">Return to Task</asp:HyperLink>      
          </td>                        
         </tr>
         <tr>
          <td class="FieldContent">   
           <asp:HyperLink ID="hlnkWFTaskReturnLink" CssClass="hLinkXSmall" runat="server">Return to Workflow Task</asp:HyperLink>      
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

