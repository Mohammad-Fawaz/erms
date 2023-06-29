<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="HelpDesk - Copy.aspx.cs" Inherits="HelpDesk" Title="HelpDesk" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>
<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="ChangeManagement" ContentPlaceHolderID="PageContent" runat="Server">

    <script type="text/javascript">

        function toggleDiv(divid, linkid) {
            var linktext = '';
            if (document.getElementById(divid).style.display == 'none') {
                document.getElementById(divid).style.display = 'block';
                linktext = '-';
            }
            else {
                document.getElementById(divid).style.display = 'none';
                linktext = '+';
            }
            var link = document.getElementById(linkid);
            if (document.all) { //IS IE 4 or 5 or later 
                link.innerText = linktext;
            }
            //IS NETSCAPE 4 or below
            if (document.layers) {
                link.innerText = linktext;
            }
            //Mozilla/Netscape6+ and all the other Gecko-based browsers
            if (document.getElementById && !document.all) {
                link.firstChild.nodeValue = linktext;
            }
        }

        function GetChangeDeleteUserConf() {
            var userselect = confirm("This action will also remove other associated records!\n" +
                "  • Associated Document References\n" +
                "  • Associated Attachments\n" +
                "  • Associated Notes\n" +
                "  • Associated Custom Fields\n" +
                "  Are you sure you want to continue?");

            document.getElementById('hdnDeleteUserPref').value = userselect;
        }

</script>


    <main>
                    <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                           Service Management	
                                        </h1>
                                    </div>
                                    <div class="col-9">
                                                                                     
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
                                    <div class="card-header">Service Request Information</div>                                     
                                    <div class="card-body">
                                        <p class="alert-danger-soft">
                                        <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                                            </p>
                                        <form>                                            
                                            <div class="row gx-3 mb-3" >
                                                <div class="col-md-6">
                                                <div class="btn-group" role="group">

                                                    <asp:Button ID="btnFinds" runat="server"  Text="Find" CssClass="btn btn-outline-primary m-1" OnClick="btnFind_Click" visible="false" />
                                                    <asp:Button ID="btnNewEditSaves" runat="server" Text="New Request" CssClass="btn btn-outline-primary m-1" OnClick="btnNewEditSave_Click"  visible="false"/>
                                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-outline-primary m-1" OnClick="btnCancel_Click" visible="false" />
                                                    <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-outline-danger m-1"  OnClick="btnDelete_Click" visible="false"/>                                                    
                                                    <input id="hdnDeleteUserPref" type="hidden" name="hdnDeleteUserPref" />   
                                                </div>
                                               </div>
                                             </div>
                                             <!-- Form Row-->
                                            <div class="row gx-3 mb-3">
                                                 <!-- Form Group (Change Number)-->
                                                <div class="col-md-6"  runat="server" id="divRequest" visible="false">
                                                <label class="small mb-1" for="txtChangeID">Request</label>                                                   
                                                 <asp:TextBox ID="txtRequest" runat="server"  CssClass="form-control">                                                  
                                            </asp:TextBox>                                                                                                                  
                                                    </div>
                                                 <!-- Form Group (Status)-->
                                                 <div class="col-md-6" runat="server" id="divtxtStatus" visible="false">
                                                <label class="small mb-1" for="txtStatus">Status</label>
                                                  
                                                    <asp:TextBox ID="txtStatus" CssClass="form-control" runat="server">
                                                    </asp:TextBox>
                                                    </div>                                               
                                            </div>           
                                             <!-- Form Row-->
                                            <div class="row gx-3 mb-3">
                                                 <!-- Form Group (Effective/Start Date)-->
                                                <div class="col-md-6"  runat="server" id="divRequestType"  visible="false">
                                                <label class="small mb-1" for="txtStartDate" >Request Type</label>  
                                                    <asp:DropDownList runat="server" ID="ddlRequestType" CssClass="form-select" >
                                                       <%-- <asp:ListItem Value="0">Create Profile in New System</asp:ListItem>
                                                        <asp:ListItem Value="1">Create Help Desk WorkFlows</asp:ListItem>--%>
                                                        <asp:ListItem Value="2">General Help Desk Support</asp:ListItem>
                                                        <asp:ListItem Value="3">Hardware-Software Procurement</asp:ListItem>
                                                        <asp:ListItem Value="4">ERP-EPICOR</asp:ListItem>
                                                        <asp:ListItem Value="5">Cyber Incident Report</asp:ListItem>
                                                        <asp:ListItem Value="6">New User</asp:ListItem>
                                                         <asp:ListItem Value="7">Remove User</asp:ListItem>
                                                    </asp:DropDownList>
                                                 <asp:TextBox ID="txtRequestType" Visible="false"  runat="server"  CssClass="form-control">                                                  
                                            </asp:TextBox>                                                          
                                                      
                                                    </div>
                                                 <!-- Form Group (Due Date)-->
                                                 <div class="col-md-6"  runat="server" id="divPriority" visible="false">
                                                <label class="small mb-1" for="txtEndDate">Priority</label>                                                 
                                                    <asp:TextBox ID="txtPriority" CssClass="form-control"  runat="server">
                                                </asp:TextBox>
                                             
                                                    </div>                                               
                                            </div>                                           
                                            <!-- Form Row-->
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (Change Class)-->
                                                <div class="col-md-6"  runat="server" id="divtxtRequestBy" visible="false" >
                                                    <label class="small mb-1" for="txtChangeClass">Request By</label>                                                                                                         
                                                     
                                                        <asp:TextBox ID="txtRequestBy" CssClass="form-control" runat="server">
                                                        </asp:TextBox>
                                                </div>              
                                                 <!-- Form Group (Change Type)-->
                                                <div class="col-md-6"  runat="server" id="divucDateStart" visible="false">      
                                                    <label class="small mb-1" for="txtChangeType">Request Date</label>
                                                   
                                                 <asp:TextBox runat="server" ID="ucDateStart" CssClass="form-control" type="Date"></asp:TextBox>
                                                       <%--<ucCalendar:ERMSCalendar ID="ucDateStart" CssClass="form-control" runat="server" />--%>
                                                      <%-- <ucCalendar:ERMSCalendar ID="ucDateEnd" CssClass="form-control" runat="server" />--%>
                                                </div>
                                            </div>
                                            <!-- Form Row        -->
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (Priority)-->
                                                <div class="col-md-6"  runat="server" id="divDepartment" visible="false">      
                                                    <label class="small mb-1" for="txtPriority">Department</label>
                                                  
                                                    <asp:TextBox ID="txtboxDepartment" CssClass="form-control" runat="server">
                                                    </asp:TextBox>
                                                 
                                                </div>
                                                <!-- Form Group (Justification)-->
                                                <div class="col-md-6"  runat="server" id="divSupervisor" visible="false">
                                                 <label class="small mb-1" for="txtPriority">Supervisor</label>
                                                            <asp:TextBox CssClass="form-control" ID="txtSupervisor" runat="server">
                                                            </asp:TextBox>
                                                </div>
                                            </div>      
                                            <%--  --%>
                                          
                                            <div class="row gx-3 mb-3">                                              
                                                <!-- Form Group (Project)-->
                                                <div class="col-md-6"  runat="server" id="divtxtDueDate" visible="false">
                                                    <label class="small mb-1" for="inputProject">Due Date</label>
                                                     
                                                      <asp:TextBox runat="server" ID="txtDueDate" CssClass="form-control" type="Date"></asp:TextBox>
                                                        <%--<ucCalendar:ERMSCalendar ID="txtDueDate" CssClass="form-control" runat="server" />--%>
                                                </div>
                                                <div class="col-md-6"  runat="server" id="divProject" visible="false">
                                                    <label class="small mb-1" for="inputDescription">Project</label>
                                                    <asp:TextBox ID="txtProject" CssClass="form-control" runat="server"></asp:TextBox>
                                                </div>   
                                            </div>
                                            <!-- Form Row-->
                                                  
                                                <!-- Form Group (Requested Date)-->
                                                                        
                                               <!-- Form Row-->
                                            <div class="row gx-3 mb-3">
                                                <!-- Form Group (Requested By)-->
                                                 <div class="col-md-6"  runat="server" id="divtxtDescription"  visible="false">
                                                <label class="small mb-1" for="txtRequestedBy">Description Of Request/Issue</label>
                                               
                                                    <asp:TextBox ID="txtDescription" TextMode="MultiLine" Height="100px" Width="100%" CssClass="form-control" runat="server">
                                                    </asp:TextBox>
                                                     </div>
                                                <!-- Form Group (Requested Date)-->
                                                                                           
                                                </div>
                                               <!-- Form Row-->
                                               
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
             <div class="row">
<div class="accordion" id="accordionPanelsStayOpen">  

   <div class="accordion-item" runat="server" id="divhlnkNotes" visible="false">
    <h2 class="accordion-header" id="panelsStayOpen-headingAddedNotes">
      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAddedNotes" aria-expanded="false" aria-controls="panelsStayOpen-collapseAddedNotes">
         List of Added Notes
      </button>
    </h2>
    <div id="panelsStayOpen-collapseAddedNotes" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAddedNotes">
      <div class="accordion-body">
        <table class="Table">
                        <tr>
                            <td class="FieldContent">
                                  <asp:HiddenField  runat="server" ID="hfd_gvNotes"/>
                                 <asp:GridView ID="gvNotes" runat="server" 
                                     CssClass="table table-bordered table-condensed table-responsive table-hover"
                    OnRowDataBound="gvNotes_RowDataBound" 
                    >
          </asp:GridView>     
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldContent">
                                 <asp:HyperLink ID="hlnkNotes" CssClass="hLinkSmall"  Enabled="false" Text="Add Notes" runat="server">
          </asp:HyperLink>
                            </td>
                        </tr>
                    </table>
      </div>
    </div>
  </div>
    <%-- 12 --%>
     <%--10 List of Attached Files --%>
  <div class="accordion-item" runat="server" id="divhlnkAttachFiles" visible="false">
    <h2 class="accordion-header" id="panelsStayOpen-headingAttachedFiles">
      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAttachedFiles" aria-expanded="false" aria-controls="panelsStayOpen-collapseAttachedFiles">
          Attached Files
      </button>
    </h2>
    <div id="panelsStayOpen-collapseAttachedFiles" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAttachedFiles">
      <div class="accordion-body">
        <table class="Table">
      <tr>
        <td class="FieldContent">
        <!--
          <div id="divgvScroll" style="overflow: scroll">-->
                    <asp:HiddenField  runat="server" ID="hfd_gvAttachedFiles"/>
          <asp:GridView ID="gvAttachedFiles" runat="server" 
              CssClass="table table-bordered table-condensed table-responsive table-hover"
                    OnRowDataBound="gvAttachedFiles_RowDataBound" 
                    OnRowDeleting="gvAttachedFiles_RowDeleting">
          </asp:GridView>
          <!--</div>-->      
        </td>
      </tr>     
      <tr>
        <td class="FieldContent">  
          <asp:HyperLink ID="hlnkAttachFiles" CssClass="hLinkSmall" Text="Attach Files"  Enabled="false" runat="server">
           </asp:HyperLink>  
         </td>
      </tr>       
    </table>
      </div>
    </div>
  </div>
    <%-- 14 --%>
  <div class="accordion-item" runat="server" id="divhlnkWFTasks" visible="false">
    <h2 class="accordion-header" id="panelsStayOpen-headingThree">
      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseThree" aria-expanded="false" aria-controls="panelsStayOpen-collapseThree">
      Workflow Tasks
      </button>
    </h2>
    <div id="panelsStayOpen-collapseThree" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingThree">
      <div class="accordion-body">
         <table class="Table">
                        <tr>
                            <td class="FieldContentCenter">
                                 <asp:HiddenField  runat="server" ID="hfd_gvWFTasks"/>
                                <asp:GridView ID="gvWFTasks" runat="server"
                                    CssClass="table table-bordered table-condensed table-responsive table-hover"
                                    OnSelectedIndexChanging="gvWFTasks_SelectedIndexChanging"
                                    OnRowDeleting="gvWFTasks_RowDeleting"
                                    OnRowDataBound="gvWFTasks_RowDataBound">
                                </asp:GridView>
                                <asp:Label ID="lblWFTasks" runat="server" CssClass="CtrlWideValueView"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="FieldContent">
                                <asp:HyperLink ID="hlnkWFTasks" Text="Assign Workflow" Enabled="false"  CssClass="hLinkSmall" runat="server">
          </asp:HyperLink>
                            </td>
                        </tr>
                    </table>
      </div>
    </div>
  </div>
    <%-- 15 --%>
  <div class="accordion-item" runat="server" id="divhlnkWFCustom" visible="false">
    <h2 class="accordion-header" id="panelsStayOpen-headingFour">
      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseFour" aria-expanded="false" aria-controls="panelsStayOpen-collapseFour">
      Custom Fields
      </button>
    </h2>
    <div id="panelsStayOpen-collapseFour" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingFour">
      <div class="accordion-body">
        <table class="Table">
            <tr>
                <!--- Table to List Custom Field Info--->
                <asp:Literal ID="CustomLiteral" runat="server" />
                <!---- Table to List Custom Field Info Ends--->

                <table class="Table" cellspacing="0" cellpadding="2" border="1">
                    <asp:HyperLink ID="hlnkWFCustom" CssClass="hLinkSmall" runat="server" Text="Assign Custom Field Values"  Enabled="false">
                        <asp:Label ID="lblAssign" runat="server" ></asp:Label>
                    </asp:HyperLink>
                </table>
            </tr>
        </table>
      </div>
    </div>
  </div>
    </div>
 </div>             
                        
</div>
</main>
</asp:Content>
