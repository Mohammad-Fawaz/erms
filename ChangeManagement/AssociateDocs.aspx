<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AssociateDocs.aspx.cs" Inherits="ChangeManagement_AssociateDocs" Title="Associate Documents" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="AssociateDocuments" ContentPlaceHolderID="PageContent" Runat="Server">

    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Associate Documents		
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
                                    <div class="card-header">Associate Documents</div>                                     
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
		    <td class="TabSubHeader" style="background-color: #FFFFFF">               
               <asp:Button ID="btnFind" runat="server" Text="Find" OnClick="btnFind_Click" CssClass="btn btn-primary-soft" /> 
		        &nbsp;&nbsp;
		        <asp:Button ID="btnAttach" runat="server" Text="Attach To Order" Visible="False" OnClick="btnAttach_Click" CssClass="btn btn-primary-soft" />
                &nbsp;&nbsp;  
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" Visible="False" CssClass="btn btn-primary-soft" />
                &nbsp;&nbsp;                      
            </td>				
		</tr>		
	 </table>	
	 <table class="Table">
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Document Number:</td>		    
		    <td class="FieldContent">
                <asp:TextBox CssClass="form-control" ID="txtDocID" runat="server"></asp:TextBox>               
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
		        Current Revision:</td>
		     <td class="FieldContent">
                 <asp:TextBox CssClass="form-control" ID="txtCurrentRevision" runat="server">
                 </asp:TextBox></td>
             <td class="FieldHeader" style="background-color: #FFFFFF">		    
		        New Revision:</td>
		    <td class="FieldContent">		       
               <asp:TextBox CssClass="form-control" ID="txtNewRevision" runat="server">
               </asp:TextBox></td>
		</tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td  class="FieldContent" colspan="3">	              
               <asp:TextBox CssClass="form-control" ID="txtDocDescription" runat="server">
               </asp:TextBox></td>
		</tr>	               
	</table>
	
	<!-- Associated Documents -->		  
	<table  class="Table">
      <tr >
        <td class="TabHeader">
            <h1>List of Associated Documents</h1>
         </td>         
      </tr>
      <tr>
        <td class="FieldContent">
            <asp:GridView ID="gvAssociatedDocs" runat="server" 
                        OnRowDeleting="gvAssociatedDocs_RowDeleting"
                        CssClass="table table-bordered table-condensed table-responsive table-hover"
                        OnRowDataBound="gvAssociatedDocs_RowDataBound">
            </asp:GridView>      
        </td>
      </tr>                         
    </table>
      
	<!-- Current Available Documents -->
	<table  class="Table">
		<tr> 
		    <td class="TabHeader">
	           <h1>List of Documents</h1>
	        </td>
	    </tr>	    
        <tr>
          <td class="FieldContent">
            <asp:GridView ID="gvDocSearchResults" 
              OnRowDataBound="gvDocSearchResults_RowDataBound"
              OnPageIndexChanging="gvDocSearchResults_PageIndexChanging" 
                CssClass="table table-bordered table-condensed table-responsive table-hover"
              OnSelectedIndexChanging="gvDocSearchResults_SelectedIndexChanging"
              AllowPaging="True" runat="server">                 
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

