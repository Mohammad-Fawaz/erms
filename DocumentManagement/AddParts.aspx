<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AddParts.aspx.cs" Inherits="DocumentManagement_AddParts" Title="Add Parts" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="AddParts" ContentPlaceHolderID="PageContent" Runat="Server">

    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Material Disposition	
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
                                    <div class="card-header">Part Information</div>                                     
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
	 <table  class="Table">
		
		<tr>
		    <td class="TabSubHeader">
		        <asp:Button ID="btnNewEditSave" runat="server" Text="Add Item" CssClass="btn btn-primary-soft" OnClick="btnNewEditSave_Click"/>
                &nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-primary-soft" Visible="false" OnClick="btnCancel_Click"/>
                &nbsp;&nbsp;                        
            </td>				
		</tr>		
	 </table>
	 	
	 <table class="Table">	 
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Part Number:</td>		    
		    <td class="FieldContent" style="width: 223px">
		       <asp:HiddenField Id="hdnPartID" runat="server" />  
		       <asp:TextBox CssClass="form-control" ID="txtPartNumber" runat="server"></asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Revision:</td>
		    <td class="FieldContent">		        	
                <asp:TextBox CssClass="form-control" ID="txtRevision" runat="server">
                </asp:TextBox></td>                
		</tr> 		
        <tr>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Revision Type:</td>
		    <td class="FieldContent" style="width: 223px">
		        <asp:DropDownList CssClass="form-select" ID="ddlRevisionType" runat="server">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control" ID="txtRevisionType" runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" bgcolor="White" style="background-color: #FFFFFF">		    
		        Revision Status:</td>
		    <td class="FieldContent">		
		        <asp:DropDownList CssClass="form-select" ID="ddlRevisionStatus" runat="server">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control" ID="txtRevisionStatus" runat="server">
                </asp:TextBox></td>
		</tr>
		<tr>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Lifecycle Status:</td>
		    <td class="FieldContent" style="width: 223px">		        
                <asp:TextBox CssClass="form-control" ID="txtLifecycleStatus" runat="server">
                </asp:TextBox>
                <asp:DropDownList CssClass="form-select" ID="ddlLifecycleStatus" runat="server">
                </asp:DropDownList></td>                
            <td class="FieldHeader" style="background-color: #FFFFFF">		    
		        Cost:</td>
		    <td class="FieldContent">				        
                <asp:TextBox CssClass="form-control" ID="txtCost" runat="server">
                </asp:TextBox></td>
		</tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td class="FieldContent" colspan="3">		
                <asp:TextBox CssClass="form-control" ID="txtDescription" runat="server">
                </asp:TextBox></td>
		</tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        FAI:</td>
            <td class="FieldContent" style="width: 223px">
		        <asp:CheckBox ID="cbFAI" runat="server" /></td>	            		     
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        FAI Date:</td>
		    <td class="FieldContent">		
		        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucFAIDate" runat="server" />    
                <asp:TextBox CssClass="form-control" ID="txtFAIDate"  runat="server">
                </asp:TextBox></td>
        </tr>
        <tr>   
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Start Date:</td>
		    <td class="FieldContent" style="width: 223px">		
		        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucDateStart" runat="server" />    
                <asp:TextBox CssClass="form-control" ID="txtStartDate"  runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">                
		        Expire Date:</td>
		    <td class="FieldContent">
		         <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucExpiryDate" runat="server" />
                 <asp:TextBox CssClass="form-control" ID="txtExpiryDate" runat="server">
                 </asp:TextBox></td>
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Associated Doc: </td>
		    <td class="FieldContent" colspan="3">
		        <asp:HyperLink ID="hlnkAssociatedDoc" CssClass="btn btn-link" runat="server"></asp:HyperLink>		       
		    </td>                
		</tr>		
	  </table>
 		 	     
    <!-- Current Available List of Materials-->		  
    <table class="Table">
     <tr> 
        <td class="TabHeader">
            <h1>Current List of Parts</h1>
        </td>
     </tr>	    
     <tr>
        <td class="FieldContent">
            <asp:GridView ID="gvAddPartsInfo" runat="server" 
                  OnRowDataBound="gvAddPartsInfo_RowDataBound"      
                    CssClass="table table-bordered table-condensed table-responsive table-hover"
                  OnSelectedIndexChanging="gvAddPartsInfo_SelectedIndexChanging">
            </asp:GridView>     
         </td>                     
     </tr>     
    </table>
    
    <!-- Bill of Materials -->
    <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		      <h1>Bill of Materials</h1>
            </td>				
		</tr>	
		<tr>
		    <td class="TabSubHeader" bgcolor="White" style="background-color: #FFFFFF">
		        <asp:HyperLink ID="hlnkCopy" runat="server" CssClass="btn btn-link">[hlnkCopy]</asp:HyperLink>
                &nbsp;&nbsp;
                <asp:HyperLink ID="hlnkAdd" runat="server" CssClass="btn btn-link">[hlnkAdd]</asp:HyperLink>
                &nbsp;&nbsp;                        
                <asp:HyperLink ID="hlnkEdit" runat="server" CssClass="btn btn-link">[hlnkEdit]</asp:HyperLink>
                &nbsp;&nbsp;
            </td>				
		</tr>	
		<tr>
         <td class="FieldContent">
            <asp:GridView ID="gvBOMLineItems" runat="server"
                CssClass="table table-bordered table-condensed table-responsive table-hover"
                    OnRowDataBound="gvBOMLineItems_RowDataBound">
            </asp:GridView>     
         </td>                     
        </tr>   
	</table> 
    <!-- Current Orders -->
    <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		     <h1>Current Orders</h1>
            </td>				
		</tr>	
	</table> 
    <!-- Vendor Information -->
 	<table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		      &nbsp;Vendor Information              
            </td>				
		</tr>	
		<tr>
		    <td class="TabSubHeader" style="background-color: #FFFFFF">
		        <asp:Button ID="btnNewEditSaveVendor" runat="server" Text="Add Vendor"
		         CssClass="btn btn-primary-soft" Visible="false" OnClick="btnNewEditSaveVendor_Click"/>
                &nbsp;&nbsp;
                <asp:Button ID="btnCancelVendor" runat="server" Text="Cancel" 
                 CssClass="btn btn-primary-soft" Visible="false" OnClick="btnCancelVendor_Click"/>
                &nbsp;&nbsp;                        
            </td>				
		</tr>	
	</table> 
    <table class="Table">	
        <tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Vendor Part Number:</td>		    
		    <td class="FieldContent">		       
		       <asp:TextBox CssClass="form-control" ID="txtVendorPartNumber" runat="server"></asp:TextBox>
		       <asp:DropDownList CssClass="form-select" ID="ddlVendorPartNumber" runat="server" 
		         OnSelectedIndexChanged="ddlVendorPartNumber_SelectedIndexChanged">
               </asp:DropDownList></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Vendor Name:</td>		    
		    <td class="FieldContent">
		       <asp:HiddenField Id="hdnVendorID" runat="server" />
		       <asp:DropDownList CssClass="form-select" ID="ddlVendorName" runat="server" 
		         OnSelectedIndexChanged="ddlVendorName_SelectedIndexChanged">
               </asp:DropDownList>  
		       <asp:TextBox CssClass="form-control" ID="txtVendorName" runat="server"></asp:TextBox></td>          
		</tr>  
		<tr> 
		     <td class="FieldHeader" style="background-color: #FFFFFF">
                Contact Name:</td>
		    <td class="FieldContent">		        	
                <asp:TextBox CssClass="form-control" ID="txtVendorContactName" runat="server">
                </asp:TextBox></td>    
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Contact Phone:</td>
		    <td class="FieldContent">		        	
                <asp:TextBox CssClass="form-control" ID="txtVendorContactPhone" runat="server">
                </asp:TextBox></td>                
		</tr> 
		<tr> 		         
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Contact Email:</td>
		    <td class="FieldContent" colspan="3">		        	
                <asp:TextBox CssClass="form-control" ID="txtVendorContactEmail" runat="server">
                </asp:TextBox></td>                
		</tr> 
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td class="FieldContent" colspan="3">		
                <asp:TextBox CssClass="form-control" ID="txtVendorDescription" runat="server">
                </asp:TextBox></td>
		</tr>	
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Datasheet File:</td>
		    <td class="FieldContent" colspan="3">		
               <asp:HyperLink ID="hlnkDataSheet" runat="server"></asp:HyperLink>
               <asp:TextBox CssClass="form-control" ID="txtDataSheet" runat="server">
               </asp:TextBox></td>
		</tr>	
	 </table>	     
     <!-- Notes -->
     <!--
     <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		      &nbsp;Notes
            </td>				
		</tr>	
	</table> -->
     <!-- Attached Files -->
     <!--
     <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		      &nbsp;Attached Files
            </td>				
		</tr>	
	</table> 
	-->
     <!-- Workflow -->
     <!--
     <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		      &nbsp;Workflow              
            </td>				
		</tr>	
	</table> 
	-->
    <!-- Return Links -->                      
    <table class="Table">
      <tr>
        <td class="FieldContent">
            <asp:HyperLink ID="hlnkReturnLinkSearch" CssClass="btn btn-link" runat="server">Return to Search</asp:HyperLink> 
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