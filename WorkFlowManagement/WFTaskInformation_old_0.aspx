<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="WFTaskInformation.aspx.cs" Inherits="WFManagement_TaskInformation" Title="Workflow Task" %>
<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master"%> 

<asp:Content ID="WFTask" ContentPlaceHolderID="PageContent" Runat="Server">

<table class="Table">
 <tr>
  <td>  
     <!-- Header -->
     <table class="Table">
      <tr>    
        <td class="LSGrayXLargeText">Workflow Task</td>
        <td align="right">         
         <a href='ret_selitem.asp?Listing=WF&Item=" & curRec & "' class="hLinkSmallBold" >View Workflow Task</a> | 
         <a href='pnt_selitem.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkSmallBold">Printable Format</a><br/>
         <a href='pnt_chgreq.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Workflow Task Form</a><br/>
         <a href='pnt_dev.asp?Listing=WF&Item=" & curRec & "' target='_blank' class="hLinkXSmallBold">Printable Waiver/Deviation Form</a>         
	    </td>	
      </tr>
      <tr>  
         <td class="FieldContent" colspan="2">           
            <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label></td> 
      </tr>  
     </table>   
        	
     <!-- WF Request Information -->			
	 <table class="Table">
		<tr>
		    <td class="TabHeaderCenter">		  
		        Workflow Task Information              
            </td>				
		</tr>	
		<tr>
		    <td class="TabSubHeader" style="background-color: #FFFFFF">                               		                 
		        <asp:Button ID="btnNewEditSave" runat="server" Text="New WorkFlow Task" CssClass="btnStyle" OnClick="btnNewEditSave_Click"/>                               
                <asp:Button ID="btnAddSaveTask" runat="server" Text="Add Task" CssClass="btnStyle" Visible="False" OnClick="btnAddSaveTask_Click"/>                
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btnStyle"  Visible="False" OnClick="btnCancel_Click" />
                &nbsp;&nbsp;                                        
            </td>				
		</tr>		
	 </table>	
	 
	 <!-- WorkFlow Header -->	 
	 <table class="Table">
	  <tr >
          <td class="TabHeader" colspan="4">
            &nbsp;Workflow Task Header
          </td>         
        </tr>
     </table> 
	 <table class="Table">	 
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Template Name:</td>		    
		    <td class="FieldContent">
                <asp:TextBox ID="txtTemplateName" runat="server">
                </asp:TextBox>               
                <asp:HiddenField ID="hdnWFTemplateID" runat="server"/></td>	
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Template Type:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtTemplateType" runat="server">
                </asp:TextBox></td>                
		</tr> 
		<tr> 
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Reference Type:</td>		    
		    <td class="FieldContent">
                <asp:TextBox ID="txtHeaderRefType" runat="server">
                </asp:TextBox>               
                <asp:HiddenField ID="hdnHeaderRefTypeCode" runat="server"/></td>	
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Reference ID:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtHeaderRefID" runat="server">
                </asp:TextBox></td>                
		</tr> 
		<tr>		    	
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Number of Steps:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtStepCount" runat="server">
                </asp:TextBox></td>                
		</tr> 
		<tr>
            <td class="FieldHeader" style="background-color: #FFFFFF">
                Number of Tasks:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtTaskCount" runat="server">
                </asp:TextBox></td> 
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Created On:</td>		    
		    <td class="FieldContent">
                <asp:TextBox ID="txtCreatedOn" runat="server">
                </asp:TextBox></td>               
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
		        <asp:Label ID="lblTID" runat="server">
                </asp:Label></td>		    
		    <td class="FieldContent">
                <asp:TextBox ID="txtTID" runat="server">
                </asp:TextBox>
                <asp:DropDownList ID="ddlAction" runat="server" OnSelectedIndexChanged="ddlAction_SelectedIndexChanged">
                </asp:DropDownList></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
                <asp:Label ID="lblTaskStatus" runat="server">
                </asp:Label></td>
		    <td class="FieldContent">	
		        <asp:DropDownList ID="ddlStatus" runat="server">
                </asp:DropDownList>	
                <asp:TextBox ID="txtStatus" runat="server">
                </asp:TextBox>
                <asp:DropDownList ID="ddlTemplateStep" runat="server" OnSelectedIndexChanged="ddlTemplateStep_SelectedIndexChanged">
                </asp:DropDownList>
                <asp:HiddenField ID="hdnWFTemplateItemID" runat="server"/></td>                
		</tr>	
		<tr>		    			 	                  
            <td class="FieldHeader" style="background-color: #FFFFFF">
		         Priority:</td>
		     <td class="FieldContent" colspan="3">
		        <asp:DropDownList ID="ddlPriority" runat="server">
                </asp:DropDownList>
                <asp:TextBox ID="txtPriority" runat="server">
                </asp:TextBox></td>
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Project:</td>
		    <td class="FieldContent" colspan="3">		       
		        <asp:DropDownList ID="ddlProject" runat="server">
                </asp:DropDownList>
                <asp:TextBox ID="txtProject" runat="server">
                </asp:TextBox></td>             
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Description:</td>
		    <td class="FieldContent" colspan="3">		
                <asp:TextBox ID="txtTaskDescription" runat="server">
                </asp:TextBox></td>
		</tr>	
        <tr>        
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Step Number:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtStepNumber" runat="server">
                </asp:TextBox></td>    
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Action Type:</td>
		    <td class="FieldContent">		        
                <asp:TextBox ID="txtActionType" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnActionTypeCode" runat="server"/></td>           
		</tr>
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Ref. Control:</td>
		    <td class="FieldContent">		       
		        <asp:DropDownList ID="ddlRefControl" runat="server"
		            OnSelectedIndexChanged="ddlRefControl_SelectedIndexChanged">
                </asp:DropDownList>
                <asp:TextBox ID="txtRefControl" runat="server">
                </asp:TextBox>                
                <sup><asp:CheckBox ID="cbUpdateCRef" runat="server" />
		        <asp:CheckBox ID="cbAllowAddCRef" runat="server" /></sup>
                <asp:HiddenField ID="hdnControlReferenceCode" runat="server"/></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Ref. ID:</td>
            <td class="FieldContent">
                <asp:TextBox ID="txtRefControlID" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnWFTaskID" runat="server"/></td>                               
		</tr>					
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Back Step:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtBackStep" runat="server">
                </asp:TextBox></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Back Step Status:</td>
            <td class="FieldContent">                                          
		        <asp:DropDownList ID="ddlBackStatus" runat="server">
                </asp:DropDownList>	
                <asp:TextBox ID="txtBackStatus" runat="server">
                </asp:TextBox></td>
         </tr>             
         <tr>    
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Next Step:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtNextStep" runat="server">
                </asp:TextBox></td>                   
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Next Step Status:</td>
		    <td class="FieldContent">		       
		        <asp:DropDownList ID="ddlNextStatus" runat="server">
                </asp:DropDownList>
                <asp:TextBox ID="txtNextStatus" runat="server">
                </asp:TextBox></td>  
		</tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		       Instructions :</td>
		    <td class="FieldContent" colspan="3">		
                <asp:TextBox ID="txtStepDescription" runat="server">
                </asp:TextBox></td>
		</tr>		
		<tr>
		     <td class="FieldHeader" style="background-color: #FFFFFF">
                 Assigner Type:</td>
		     <td class="FieldContent">		            
                <asp:TextBox ID="txtAssignerType" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnAssignerType" runat="server"/></td> 
		     <td class="FieldHeader" style="background-color: #FFFFFF">
                 Assigned By:</td>
		     <td class="FieldContent">	
	            <asp:DropDownList ID="ddlAssignedBy" runat="server">
                </asp:DropDownList>	
                <asp:TextBox ID="txtAssignedBy" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnAssignedByID" runat="server"/></td>              
        </tr>
        <tr>
             <td class="FieldHeader" style="background-color: #FFFFFF">
                 Assignee Type:</td>
		     <td class="FieldContent">		            
                <asp:TextBox ID="txtAssigneeType" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnAssigneeType" runat="server"/></td> 
		     <td class="FieldHeader" style="background-color: #FFFFFF">
                 Assigned To:</td>
		     <td class="FieldContent">	
	            <asp:DropDownList ID="ddlAssignedTo" runat="server">
                </asp:DropDownList>	
                <asp:TextBox ID="txtAssignedTo" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnAssignedToID" runat="server"/>
                <asp:CheckBox ID="cbNotifyByEmail" runat="server" /></td>
        </tr>		
		<tr>
		    <td class="FieldHeader" style="background-color: #FFFFFF">
		        Charge Account:</td>
		    <td class="FieldContent">
		        <asp:TextBox ID="txtChargeAccount" runat="server">
                </asp:TextBox>
                <asp:HiddenField ID="hdnStdTaskCode" runat="server"/></td>
            <td class="FieldHeader" style="background-color: #FFFFFF">
		        Standard Task:</td>
            <td class="FieldContent">
                <asp:TextBox ID="txtStandardTask" runat="server">
                </asp:TextBox></td>
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
                <ucCalendar:ERMSCalendar ID="ucPlanDateStart" runat="server"/>
                <asp:TextBox ID="txtPlanDateStart" runat="server">
                </asp:TextBox></td>
             <td class="FieldContentCenter">
                <ucCalendar:ERMSCalendar ID="ucPlanDateEnd" runat="server"/>
                <asp:TextBox ID="txtPlanDateEnd" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
                <asp:TextBox ID="txtPlanHours" runat="server">
                </asp:TextBox></td>		     
             <td class="FieldContentCenter">
                <asp:TextBox ID="txtPlanCost" runat="server">
                </asp:TextBox></td> 
          </tr>
          <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	              Adj. Plan:</td>          
		     <td class="FieldContentCenter">
                <ucCalendar:ERMSCalendar ID="ucAdjPlanDateStart" runat="server"/>
                <asp:TextBox ID="txtAdjPlanDateStart" runat="server">
                </asp:TextBox></td>
             <td class="FieldContentCenter">
                <ucCalendar:ERMSCalendar ID="ucAdjPlanDateEnd" runat="server"/>
                <asp:TextBox ID="txtAdjPlanDateEnd" runat="server">
                </asp:TextBox></td>	
             <td class="FieldContentCenter">                
               &nbsp;</td>
             <td class="FieldContentCenter">                
               &nbsp;</td>	     
          </tr>
          <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	               Overrun:</td>          
		     <td class="FieldContentCenter">                
               &nbsp;</td>
             <td class="FieldContentCenter">
                <ucCalendar:ERMSCalendar ID="ucOverrunDateEnd" runat="server"/>
                <asp:TextBox ID="txtOverrunDateEnd" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
                <asp:TextBox ID="txtOverrunHours" runat="server">
                </asp:TextBox></td>		    
             <td class="FieldContentCenter">
                <asp:TextBox ID="txtOverrunCost" runat="server">
                </asp:TextBox></td> 
          </tr>
           <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	              Adj. Overrun:</td> 
             <td class="FieldContentCenter">                
               &nbsp;</td>	          
             <td class="FieldContentCenter">
                <ucCalendar:ERMSCalendar ID="ucAdjOverrunDateEnd" runat="server"/>
                <asp:TextBox ID="txtAdjOverrunDateEnd" runat="server">
                </asp:TextBox></td>
             <td class="FieldContentCenter">                
               &nbsp;</td>	     
             <td class="FieldContentCenter">                
               &nbsp;</td>	
          </tr>
          <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	               Actual:</td>          
		     <td class="FieldContentCenter">    
		        <ucCalendar:ERMSCalendar ID="ucActualDateStart" runat="server"/>            
                <asp:TextBox ID="txtActualDateStart" runat="server">
                </asp:TextBox></td>
             <td class="FieldContentCenter">                
                <ucCalendar:ERMSCalendar ID="ucActualDateEnd" runat="server"/>
                <asp:TextBox ID="txtActualDateEnd" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
                <asp:TextBox ID="txtActualHours" runat="server">
                </asp:TextBox></td>		    
             <td class="FieldContentCenter">
                <asp:TextBox ID="txtActualCost" runat="server">
                </asp:TextBox></td> 
          </tr>   
          <tr>
	         <td class="FieldHeader" style="background-color: #FFFFFF">
	               Adj. Actual:</td>          
		     <td class="FieldContentCenter">    
		        <ucCalendar:ERMSCalendar ID="ucAdjActualDateStart" runat="server"/>            
                <asp:TextBox ID="txtAdjActualDateStart" runat="server">
                </asp:TextBox></td>
             <td class="FieldContentCenter">                
                <ucCalendar:ERMSCalendar ID="ucAdjActualDateEnd" runat="server"/>
                <asp:TextBox ID="txtAdjActualDateEnd" runat="server">
                </asp:TextBox></td>
		     <td class="FieldContentCenter">                 
               &nbsp;</td>		    
             <td class="FieldContentCenter">
                &nbsp;</td> 
          </tr>   
          <tr>                                                             
            <td class="FieldHeader" colspan="5" style="background-color: #FFFFFF">		        
            <asp:TextBox ID="txtPercent" runat="server">
            </asp:TextBox>        
            <asp:Label ID="lblPercent" runat="server">
            </asp:Label></td> 
	    </tr>          
      </table>       
     
	 
      <!-- WorkFlow Tasks -->		  
	  <table  class="Table">
      <tr >
        <td class="TabHeader">
            &nbsp;Current Workflow Tasks           
         </td>         
      </tr>
      <tr>
        <td class="FieldContentCenter">
            <asp:GridView ID="gvWFTasks" runat="server"
                        OnSelectedIndexChanging = "gvWFTasks_SelectedIndexChanging"
                        OnRowDeleting="gvWFTasks_RowDeleting" 
                        OnRowDataBound="gvWFTasks_RowDataBound">
            </asp:GridView>     
            <asp:Label ID="lblWFTasks" runat="server" CssClass="CtrlWideValueView"></asp:Label> 
        </td>
      </tr>  
      <tr>
       <td class="FieldContent">  
          <asp:HyperLink ID="hlnkGoBack" CssClass="hLinkSmall" runat="server">
          Back to Reference Item</asp:HyperLink>  
       </td>
      </tr>    
      </table>  
      
      
      
    
        
    
       
                
    </td>
 </tr>    			
</table> 


</asp:Content>

