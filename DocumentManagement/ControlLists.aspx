<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ControlLists.aspx.cs" Inherits="DocumentManagement_ControlLists" Title="Set Control List" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="SetControlList" ContentPlaceHolderID="PageContent" Runat="Server">


    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Control Lists			
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
                                    <div class="card-header"> Set Document Control</div>                                     
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
        	
     <!-- Document Control Lists Information -->			
	 <table  class="Table">
		
		<tr>
		    <td class="TabSubHeader">               
                <asp:Button ID="btnEditSave" runat="server"  CssClass="btn btn-primary-soft" Text="Save" OnClick="btnEditSave_Click"/>
                &nbsp;&nbsp;
                <asp:Button ID="btnCancel" runat="server"  CssClass="btn btn-primary-soft" Text="Cancel" OnClick="btnCancel_Click"/>
                &nbsp;&nbsp;                   
            </td>				
		</tr>	         
	 </table>	
      <br />
	 <table  class="Table">		
		<tr>		               
             <td class="FieldHeader" style="background-color: #FFFFFF">
		        Control List:</td>
		     <td class="FieldContent">
                <asp:DropDownList ID="ddlControlList" CssClass="form-select" runat="server">
                </asp:DropDownList></td>    
		</tr>		
	</table>
	
	<!-- List of Control Lists -->
	<table  class="Table">
		<tr> 
		    <td class="TabHeader">
	            <p><h1>Current Control Lists</h1></p>
	        </td>
	    </tr>	    
        <tr>
          <td class="FieldContent">
            <asp:GridView ID="gvControlList" CssClass="table table-bordered table-condensed table-responsive table-hover" runat="server" OnRowDataBound="gvControlList_RowDataBound" OnRowDeleting="gvControlLists_RowDeleting">
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

