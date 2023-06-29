<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="WFTaskInformationReview.aspx.cs" Inherits="WFManagement_TaskInformationReview" Title="Deny/Approval Workflow Task" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%> 

<asp:Content ID="WFTaskDenyApproval" ContentPlaceHolderID="PageContent" Runat="Server">
 
    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Workflow Task			
                                        </h1>
                                    </div>   
                                    <div class="col-9">
                                        <a href='ret_selitem.asp?Listing=WF&Item=" & curRec & "' class="hLinkSmallBold" >View Workflow Task</a> | 
         <a href='pnt_selitem.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a> |
         <a href='pnt_chgreq.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Workflow Task Form</a> |
         <a href='pnt_dev.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Waiver/Deviation Form</a>         
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
                                    <div class="card-header">Workflow Task Information</div>                                     
                                    <div class="card-body">
                                       <table class="Table">
 <tr>
  <td>  
     <!-- Header -->
     <table class="Table">
      
      <tr>  
         <td class="FieldContent" colspan="2">           
            <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label></td> 
      </tr>  
     </table>   
        	
     <!-- WF Request Information -->			
	 <table class="Table">
			
		<tr>
		    <td class="TabSubHeader" >                               		                 
		        <asp:Button ID="btnApprove" runat="server" Text="Reviewed & Approved" Visible="False" CssClass="btn btn-primary-soft" OnClick="btnApproved_Click"/>
		        <asp:Button ID="btnUpdateProgress" runat="server" Text="Update Progress" CssClass="btn btn-primary-soft"  Visible="False" OnClick="btnUpdateProgress_Click" />                                               
                <asp:Button ID="btnDeny" runat="server" Text="Denied" CssClass="btn btn-primary-soft" Visible="False" OnClick="btnDeny_Click"/>                
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-primary-soft"  Visible="False" OnClick="btnCancel_Click" />
                <asp:Button ID="btnReview" runat="server" Text="Review Completed" CssClass="btn btn-primary-soft"  Visible="False" OnClick="btnReview_Click" />                
                &nbsp;&nbsp;                                        
            </td>				
		</tr>		
	 </table>	
  
	  <!-- Workflow Task -->	  
	  <table class="Table">
	   <tr>
          <td class="TabHeader">
            &nbsp;Workflow Task
          </td>   
       </tr>      
      </table>        
	  <table class="Table">	 
	    <tr>            
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Task ID:</td>
            <td class="FieldContent">
                <asp:TextBox CssClass="form-control" ID="txtTaskID" runat="server">
                </asp:TextBox></td>  
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Task Status:</td>
		    <td class="FieldContent">
		        <asp:TextBox CssClass="form-control" ID="txtTaskStatus" runat="server">
                </asp:TextBox></td>                                     
		</tr>			
		 <tr>            
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Ref. ID:</td>
            <td class="FieldContent">
                <asp:TextBox CssClass="form-control" ID="txtRefControlID" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnRefControlTypeCode" runat="server"/>
                <asp:HiddenField ID="hdnWFTaskID" runat="server"/>                
                <asp:HiddenField ID="hdnWFTaskTypeCode" runat="server"/>
                <asp:HyperLink ID="hlnkReferenceItem" CssClass="hLinkSmall" runat="server">
                 View</asp:HyperLink>  </td>  
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Step Number:</td>
		    <td class="FieldContent">
		        <asp:TextBox CssClass="form-control" ID="txtStepNumber" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnNextStepNumber" runat="server"/>                
                <asp:HiddenField ID="hdnNextStepStatusCode" runat="server"/>                
                <asp:HiddenField ID="hdnBackStepNumber" runat="server"/>                
                <asp:HiddenField ID="hdnBackStepStatusCode" runat="server"/></td>                                     
		</tr>			
		<tr>		    			 	                  
            <td class="FieldHeader" style="background-color: #FFFFFF">
		         Priority:</td>
		     <td class="FieldContent" colspan="3">
		        <asp:DropDownList CssClass="form-select" ID="ddlPriority" runat="server">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control" ID="txtPriority" runat="server">
                </asp:TextBox></td>
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Project:</td>
		    <td class="FieldContent" colspan="3">		       
		        <asp:DropDownList CssClass="form-select" ID="ddlProject" runat="server">
                </asp:DropDownList>
                <asp:TextBox CssClass="form-control" ID="txtProject" runat="server">
                </asp:TextBox></td>             
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td class="FieldContent" colspan="3">		
                <asp:TextBox CssClass="form-control" ID="txtTaskDescription" runat="server">
                </asp:TextBox></td>
		</tr>       		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Instructions :</td>
		    <td class="FieldContent" colspan="3">		
                <asp:TextBox CssClass="form-control" ID="txtStepDescription" runat="server">
                </asp:TextBox></td>
		</tr>		
	 </table>    
      
     <asp:Panel ID="pnlProcessTask" runat="server">
     <table class="Table">
	   <tr>
          <td class="TabHeader">
            &nbsp;Task Progress
          </td>   
       </tr>      
      </table>
      <table  class="TableMtrx">            
	      <tr>
	         <td class="FieldHeaderCenter" style="background-color: #FFFFFF">
	             Schedule</td>          
		     <td class="FieldHeaderCenter" style="background-color: #FFFFFF">
                 Start Date</td>
             <td class="FieldHeaderCenter" style="background-color: #FFFFFF">
                 End Date</td>
		     <td class="FieldHeaderCenter" style="background-color: #FFFFFF">
                 Hours</td>		    
             <td class="FieldHeaderCenter" style="background-color: #FFFFFF">
                 Costs</td> 
          </tr>
           <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	               Planned:</td>          
		     <td class="FieldContentCenter">                
                <asp:TextBox CssClass="form-control" ID="txtPlanDateStart" runat="server">
                </asp:TextBox></td>
             <td class="FieldContentCenter">                
                <asp:TextBox CssClass="form-control" ID="txtPlanDateEnd" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
                <asp:TextBox CssClass="form-control" ID="txtPlanHours" runat="server">
                </asp:TextBox></td>		     
             <td class="FieldContentCenter">
                <asp:TextBox CssClass="form-control" ID="txtPlanCost" runat="server">
                </asp:TextBox></td> 
          </tr>                     
          <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	               Actual:</td>          
		     <td class="FieldContentCenter">		                   
                <asp:TextBox CssClass="form-control" ID="txtActualDateStart" runat="server">
                </asp:TextBox></td>
             <td class="FieldContentCenter">                
                <asp:TextBox CssClass="form-control" ID="txtActualDateEnd" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
                <asp:TextBox CssClass="form-control" ID="txtActualHours" runat="server">
                </asp:TextBox></td>		    
             <td class="FieldContentCenter">
                <asp:TextBox CssClass="form-control" ID="txtActualCost" runat="server">
                </asp:TextBox></td> 
          </tr>   
          <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	               Est. Overrun:</td>          
		     <td class="FieldContentCenter">                
               &nbsp;</td>
             <td class="FieldContentCenter">                
                <asp:TextBox CssClass="form-control" ID="txtOverrunDateEnd" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
                <asp:TextBox CssClass="form-control" ID="txtOverrunHours" runat="server">
                </asp:TextBox></td>		    
             <td class="FieldContentCenter">
                <asp:TextBox CssClass="form-control" ID="txtOverrunCost" runat="server">
                </asp:TextBox></td> 
          </tr>  
          <tr>  
           <td class="FieldHeaderCenter" colspan="5" style="background-color: #FFFFFF">Update Progress</td> 
	      </tr> 
          <tr>
	        <td class="FieldHeader" style="background-color: #FFFFFF">
	           Actual:</td>          
		    <td class="FieldContentCenter">    
		       <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucActualDateStartProgress" runat="server"/>            
               <asp:TextBox CssClass="form-control" ID="txtActualDateStartProgress" runat="server">
               </asp:TextBox></td>
            <td class="FieldContentCenter">                
               <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucActualDateEndProgress" runat="server"/>
               <asp:TextBox CssClass="form-control" ID="txtActualDateEndProgress" runat="server">
               </asp:TextBox></td>
		    <td class="FieldContentCenter">                 
               <asp:TextBox CssClass="form-control" ID="txtActualHoursProgress" runat="server">
               </asp:TextBox></td>		    
            <td class="FieldContentCenter">
               <asp:TextBox CssClass="form-control" ID="txtActualCostProgress" runat="server">
               </asp:TextBox></td> 
          </tr>   
          <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	               Est. Overrun:</td>          
		     <td class="FieldContentCenter">                
               &nbsp;</td>
             <td class="FieldContentCenter">
                <ucCalendar:ERMSCalendar CssClass="form-control" ID="ucOverrunDateEndProgress" runat="server"/>
                <asp:TextBox CssClass="form-control" ID="txtOverrunDateEndProgress" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
                <asp:TextBox CssClass="form-control" ID="txtOverrunHoursProgress" runat="server">
                </asp:TextBox></td>		    
             <td class="FieldContentCenter">
                <asp:TextBox CssClass="form-control" ID="txtOverrunCostProgress" runat="server">
                </asp:TextBox></td> 
          </tr>                                    
          <tr>                                                             
            <td class="FieldHeader" colspan="5" style="background-color: #FFFFFF">
            <asp:CheckBox ID="cbCompleted" runat="server">
            </asp:CheckBox> 
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:TextBox CssClass="form-control" ID="txtPercent" runat="server">
            </asp:TextBox>        
            <asp:Label ID="lblPercent" runat="server">
            </asp:Label></td> 
	     </tr>          
       </table>             
     </asp:Panel>
      
     <!-- Attached Files -->    
     <table  class="Table">
      <tr>
        <td class="TabHeader">
            <p><h1>List of Attached Files</h1></p>            
         </td>
      </tr>
      <tr>
        <td class="FieldContent">
          <%//<asp:GridView ID="gvAttachedFiles" CssClass="table table-bordered table-condensed table-responsive table-hover" runat="server" OnRowDataBound="gvAttachedFiles_RowDataBound" OnRowDeleting="gvAttachedFiles_RowDeleting"></asp:GridView>  %>
        </td>
      </tr>     
      <tr>
        <td class="FieldContent">  
          <asp:HyperLink ID="hlnkAttachFiles" CssClass="hLinkSmall" runat="server">
          Attach Files</asp:HyperLink>  
         </td>
      </tr>       
    </table>
         
    <!-- Attach Notes -->            
    <table  class="Table">
      <tr>
        <td class="TabHeader">
            <p><h1>List of Added Notes</h1></p>
         </td>
      </tr>
      <tr>
        <td class="FieldContent">
          <% //<asp:GridView ID="gvNotes" CssClass="table table-bordered table-condensed table-responsive table-hover" runat="server" OnRowDataBound="gvNotes_RowDataBound" OnRowDeleting="gvNotes_RowDeleting"></asp:GridView>%>      
        </td>
      </tr>     
      <tr>
        <td class="FieldContent">  
          <asp:HyperLink ID="hlnkNotes" CssClass="hLinkSmall" runat="server">
          Add Notes</asp:HyperLink> 
          <br /><br />
          <asp:HyperLink ID="hlnkToDo" CssClass="btn btn-link" runat="server">Return to List</asp:HyperLink> 
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

