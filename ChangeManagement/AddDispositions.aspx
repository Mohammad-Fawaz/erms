<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AddDispositions.aspx.cs" Inherits="ChangeManagement_AddDisposition" Title="Material Dispositions" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="MaterialDispositions" ContentPlaceHolderID="PageContent" Runat="Server">
 
    
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
                                <!-- Task Document card-->
                                <div class="card mb-4">
                                    <div class="card-header">Material Disposition Information</div>                                     
                                    <div class="card-body">
                                       <table class="Table">
 <tr>
  <td>  
     <!-- Header -->
     <table class="Table">
      <tr>    
        <td class="LSGrayXLargeText">Material Disposition</td>
        <td></td>	
      </tr>
      <tr>  
         <td class="FieldContent" colspan="2">
           <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
         </td> 
      </tr>  
     </table>   
        	
     <!-- Change Request Information -->			
	 <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		        &nbsp;Material Disposition Information              
            </td>				
		</tr>	
		<tr>
		    <td class="TabSubHeader">
		        <asp:Button ID="btnNewEditSave" runat="server" Text="Add Item" CssClass="btn btn-primary-soft" OnClick="btnNewEditSave_Click"/>
                &nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-primary-soft" Visible="false" OnClick="btnCancel_Click"/>
                &nbsp;&nbsp;                        
            </td>				
		</tr>		
	 </table>	
	 <table  class="Table">	 
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Part/Lot/Serial ID:</td>		    
		    <td class="FieldContent">
                <asp:TextBox CssClass="form-control"  ID="txtPartID" runat="server"></asp:TextBox>
                <asp:HiddenField ID="hdnMDID" runat="server" /></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Disposition Status:</td>
		    <td class="FieldContent">	
		        <asp:DropDownList CssClass="form-select"  ID="ddlDispStatus" runat="server">
                </asp:DropDownList>	
                <asp:TextBox CssClass="form-control"  ID="txtDispStatus" runat="server">
                </asp:TextBox></td>                
		</tr> 		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Effective Date:</td>
		    <td class="FieldContent">		
		        <ucCalendar:ERMSCalendar ID="ucDateStart" runat="server" />    
                <asp:TextBox CssClass="form-control"  ID="txtStartDate"  runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">                
		        Due Date:</td>
		    <td class="FieldContent">
		         <ucCalendar:ERMSCalendar ID="ucDateEnd" CssClass="form-control" runat="server" />
                 <asp:TextBox CssClass="form-control"  ID="txtEndDate" runat="server">
                 </asp:TextBox></td>
		</tr>
        <tr>
		     
            <td class="FieldHeader" style="background-color: #FFFFFF">		    
		        Impact Area:</td>
		    <td class="FieldContent">		
		        <asp:DropDownList CssClass="form-select"  ID="ddlImpactArea" runat="server">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control"  ID="txtImpactArea" runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Disposition Type:</td>
		    <td class="FieldContent">
		        <asp:DropDownList CssClass="form-select"  ID="ddlDispType" runat="server">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control"  ID="txtDispType" runat="server">
                </asp:TextBox></td>
		</tr>
		<tr>
		    <td class="FieldHeader" style="height: 53px; background-color: #FFFFFF;">
		        Assigned To:</td>
		    <td class="FieldContent" style="height: 53px">
		        <asp:DropDownList CssClass="form-select"  ID="ddlAssigned" runat="server">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control"  ID="txtAssigned" runat="server">
                </asp:TextBox></td>                
            <td class="FieldHeader" style="height: 53px; background-color: #FFFFFF;">
		     Disposition Cost:</td>
		    <td class="FieldContent" style="height: 53px">
                <asp:TextBox CssClass="form-control"  ID="txtDispCost" runat="server">
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
	  	  	 
	     
    <!-- Currrent List -->		  
    <table class="Table">
    <tr> 
        <td class="TabHeader">
            <h1>Current List of Materials</h1>
        </td>
    </tr>	    
     <tr>
        <td class="FieldContent">
            <asp:GridView ID="gvAddDispositionInfo" runat="server" 
                  OnRowDataBound="gvAddDispositionInfo_RowDataBound"
                  CssClass="table table-bordered table-condensed table-responsive table-hover"
                  OnSelectedIndexChanging="gvAddDispositionInfo_SelectedIndexChanging">
            </asp:GridView>     
         </td>                     
     </tr>
      <tr>
        <td class="FieldContent">
            <asp:HyperLink ID="hlnkReturnLink" CssClass="hLinkXSmall" runat="server">Return to Order Request</asp:HyperLink> 
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

