<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AddElementWafer.aspx.cs" Inherits="DocumentManagement_AddElementWafer" Title="Add Element Wafer" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="AddElementWafer" ContentPlaceHolderID="PageContent" Runat="Server">
 
    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Document Management	
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
                                    <div class="card-header">Add a Element</div>                                     
                                    <div class="card-body">
                                       <table class="Table">
 <tr>
  <td>  
     <!-- Header -->
     <table class="Table">
      <tr>    
        <td class="LSGrayXLargeText">Part Numbers and Physical Parameters</td>        	
      </tr>
      <tr>  
         <td class="FieldContent">
           <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
         </td> 
      </tr>  
     </table>   
        	
     <!-- Change Request Information -->			
	 <table  class="Table">
		<tr>
		    <td class="TabHeader">		  
		      &nbsp;Add a Part              
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
	 	
	 <table class="Table">	 
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Part Number:</td>		    
		    <td class="FieldContent">
		       <asp:HiddenField Id="hdnPartID" runat="server" />  
		      <asp:TextBox CssClass="form-control" ID="txtPartNumber" runat="server"></asp:TextBox></td>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Wafer P/N:</td>
		    <td class="FieldContent">		        
               <asp:TextBox CssClass="form-control" ID="txtWaferPartNumber" runat="server">
                </asp:TextBox></td>                         
		</tr> 		
        <tr>
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Revision:</td>
		    <td class="FieldContent">		        	
               <asp:TextBox CssClass="form-control" ID="txtRevision" runat="server">
                </asp:TextBox></td>  
            <td class="FieldHeader" style="background-color: #FFFFFF">		    
		        Revision Status:</td>
		    <td class="FieldContent">		
		        <asp:DropDownList CssClass="form-select" ID="ddlRevisionStatus" runat="server">
                </asp:DropDownList>
               <asp:TextBox CssClass="form-control" ID="txtRevisionStatus" runat="server">
                </asp:TextBox></td>
		</tr>
		<tr>
		    <td class="FieldHeader" style="height: 46px; background-color: #FFFFFF;">
		        FAI:</td>
            <td class="FieldContent" style="height: 46px">
		        <asp:CheckBox ID="cbFAI" runat="server" /></td>	            		     
		    <td class="FieldHeader" style="height: 46px; background-color: #FFFFFF;">
		        FAI Date:</td>
		    <td class="FieldContent" style="height: 46px">		
		        <ucCalendar:ERMSCalendar ID="ucFAIDate" CssClass="form-control" runat="server" />    
               <asp:TextBox CssClass="form-control" ID="txtFAIDate"  runat="server">
                </asp:TextBox></td>
        </tr>
        <tr>   
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Start Date:</td>
		    <td class="FieldContent">		
		        <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucDateStart" runat="server" />    
               <asp:TextBox CssClass="form-control" ID="txtStartDate"  runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">                
		        Expire Date:</td>
		    <td class="FieldContent">
		         <ucCalendar:ERMSCalendar ID="ucExpiryDate" runat="server" />
                <asp:TextBox CssClass="form-control" ID="txtExpiryDate" runat="server">
                 </asp:TextBox></td>
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Related File: </td>
		    <td class="FieldContent" colspan="3">		       
               <asp:TextBox CssClass="form-control" ID="txtRelatedFile" runat="server">
                </asp:TextBox></td>                
		</tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td class="FieldContent" colspan="3">		
               <asp:TextBox CssClass="form-control" ID="txtDescription" runat="server">
                </asp:TextBox></td>
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