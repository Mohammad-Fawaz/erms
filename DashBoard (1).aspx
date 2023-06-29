<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="DashBoard.aspx.cs"
    Inherits="DashBoard" %>

<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .thumbnail {
            background-color: #ffffff;
            padding: 2%;
            border-radius: 20%;

        }

        .heading {
            text-align: center;
            font-weight: 700;
            padding-top: 1%;
        }

        .imageWrapper {
            width: 100%;
            height: 50%;
            text-align: center;
            margin-top: 2%;
        }

        .countLabel {
            text-align: center;
            font-weight: 700;
            display: block;
            margin-top: 6%;
        }

        .imgStyle {
            width: 30%;
        }
        @media screen and (max-width :600px) 
        {
             .accordion-body{
            overflow:scroll auto;
        }
        }

        .linkbtn {
            color:inherit;
        }


      /* a, a:hover, a:focus, a:active {
      text-decoration: none;
      color: inherit;
}*/
      a:link{
	color: green;
}
/*a link the user has visited*/
a:visited{
	color: purple;
}
/*a link when the user mouses over it*/
a:hover{
	color: yellow;
}
/*a link the moment it is clicked*/
a:active{
	color: brown;
}
    </style>
</asp:Content>

<asp:Content ID="DashBoard" ContentPlaceHolderID="PageContent" runat="Server">
    <div style="text-align: center; margin-top: 1%;">
        <h2>My Work Space</h2>
    </div>
    <div class="row">
        <div class="col-lg-2"></div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a id="lnkInBox" class="linkbtn" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne"   aria-expanded="false" aria-controls="panelsStayOpen-collapseOne">
                <div class="heading">
                    <label>In-Box</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/Inbox.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblInBoxCount" runat="server" Text="24"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a id="lnkChangeOrders" class="linkbtn" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAttachedFiles" class="a" aria-expanded="false" aria-controls="panelsStayOpen-collapseAttachedFiles">
                <div class="heading">
                    <label>Change Orders</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/ChangeOrdrer.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblChangeOrders" runat="server" Text="24"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a id="lnkDocuments" class="linkbtn" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAddedNotes" class="a" aria-expanded="false" aria-controls="panelsStayOpen-collapseAddedNotes">
                <div class="heading">
                    <label>Documents</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/Document.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblDocuuments" runat="server" Text="24"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a id="lnkReports" class="linkbtn" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseChangeImpact" aria-expanded="false" aria-controls="panelsStayOpen-collapseChangeImpact">
                <div class="heading">
                    <label>Reports</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/Reports.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblReports" runat="server" Text="0"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-lg-2"></div>
    </div>
    <br />
    <div class="row">
        <div class="col-lg-2"></div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a id="lnkProjects" class="linkbtn" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseMaterialDisposition" aria-expanded="false" aria-controls="panelsStayOpen-collapseMaterialDisposition">
                <div class="heading">
                    <label>Projects</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/Projects.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblProjects" runat="server" Text="24"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a id="lnkHelpTicktes" class="linkbtn" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseThree" aria-expanded="false" aria-controls="panelsStayOpen-collapseThree">
                <div class="heading">
                    <label>Help Tickets</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/helpticket.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblHelpTickets" runat="server" Text="0"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a>
                <div class="heading">
                    <label>Eng/Item BOM</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/Eng.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblEngItemsBom" runat="server" Text="0"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-3 col-sm-3 col-md-3 col-lg-2">
            <div class="thumbnail">
                <a>
                <div class="heading">
                    <label>Quality Actions</label>
                </div>
                <div class="imageWrapper">
                    <img src="/images/qualityactions.png" alt="#" class="imgStyle" />
                </div>
                <div class="countLabel">
                    <asp:Label ID="lblQualityActions" runat="server" Text="0"></asp:Label>
                </div>
                    </a>
            </div>

        </div>
        <div class="col-lg-2"></div>
    </div>
    <br />
    <div class="container-xl px-4 mt-4">
        <div class="row">
            <div class="col-xl-12">
                <!-- Task Document card-->
                <div class="card mb-4">
                    <div class="card-header">To Do List</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="accordion" id="accordionPanelsStayOpen">
                                <%--      9   List of Associated Documents --%>
                                <div class="accordion-item" runat="server" id="divhlnkAssocDoc" visible="true">
                                    <h2 class="accordion-header" id="panelsStayOpen-headingOne">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseOne" aria-expanded="false" aria-controls="panelsStayOpen-collapseOne">
                                           Assigned Workflow Tasks
                                        </button>
                                    </h2>
                                    <div id="panelsStayOpen-collapseOne" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingOne">
                                        <div class="accordion-body">
                                            <asp:GridView ID="grdMyTasks" runat="server" 
                         CssClass="table dataTable-table table-responsive" 
                        OnRowDataBound="grdMyTasks_RowDataBound" AutoGenerateColumns="false">
                                                            <Columns>
                                               
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                       <asp:HyperLink ID="hlkAction" runat="server">
                                                                           <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                       </asp:HyperLink>
                                                                        <asp:HyperLink ID="hlkView" runat="server">
                                                                           <img src='Legacy/graphics/clock.gif' alt='Update' border='0' width='18' height='18'></a>
                                                                       </asp:HyperLink>
                                                                        <asp:HiddenField ID="HfRefType" runat="server" Value='<%# Eval("RefType") %>'/>
                                                                        <asp:HiddenField ID="HfRefNum" runat="server" Value='<%# Eval("RefNum") %>'/>
                                                                        <asp:HiddenField ID="HfWATID" runat="server" Value='<%# Eval("WATID") %>'/>
                                                                        <%--<a href="WorkFlowManagement/WFTaskInformation.aspx?SID=" + <%# _SID %>+ "&RFTP="+ '<%# Eval("RefType") %>' +  "&RFID=" + '<%# Eval("RefNum") %>' +  "&TID="+ '<%# Eval("WATID") %>' +  "" target="_top">
                                                                             <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                        </a>--%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="TaskID" HeaderText="Task ID"/>
                                                                <asp:BoundField DataField="BFinish" HeaderText="Due Date"/>
                                                                <asp:BoundField DataField="Priority" HeaderText="Priority"/>
                                                                <asp:BoundField DataField="TaskDesc" HeaderText="Description"/>
                                                            </Columns>
            </asp:GridView>      
                                                    
                                          
                                        </div>
                                    </div>
                                </div>
                                <%--10 List of Attached Files --%>
                                <div class="accordion-item" runat="server" id="divhlnkAttachFiles" visible="true">
                                    <h2 class="accordion-header" id="panelsStayOpen-headingAttachedFiles">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAttachedFiles" aria-expanded="false" aria-controls="panelsStayOpen-collapseAttachedFiles">
                                            Changes Orders
                                        </button>
                                    </h2>
                                    <div id="panelsStayOpen-collapseAttachedFiles" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAttachedFiles">
                                        <div class="accordion-body">
                                              <asp:GridView ID="grdChangeOrders" runat="server" 
                         CssClass="table table-bordered table-condensed table-responsive table-hover" 
                        OnRowDataBound="grdChangeOrders_RowDataBound" AutoGenerateColumns="false">
                                                            <Columns>
                                               
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                       <asp:HyperLink ID="hlkAction" runat="server">
                                                                           <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                       </asp:HyperLink>
                                   
                                                                        <asp:HiddenField ID="HfCOID" runat="server" Value='<%# Eval("CO") %>'/>
                                                                       
                                                                        <%--<a href="WorkFlowManagement/WFTaskInformation.aspx?SID=" + <%# _SID %>+ "&RFTP="+ '<%# Eval("RefType") %>' +  "&RFID=" + '<%# Eval("RefNum") %>' +  "&TID="+ '<%# Eval("WATID") %>' +  "" target="_top">
                                                                             <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                        </a>--%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="CO" HeaderText="Change Num"/>
                                                                <asp:BoundField DataField="ChDue" HeaderText="Due Date"/>
                                                                <asp:BoundField DataField="Priority" HeaderText="Priority"/>
                                                                <asp:BoundField DataField="ChangeDesc" HeaderText="Description"/>
                                                            </Columns>
            </asp:GridView>      

                                        </div>
                                    </div>
                                </div>
                                <%-- 11 --%>
                                <div class="accordion-item" runat="server" id="divhlnkNotes" visible="true">
                                    <h2 class="accordion-header" id="panelsStayOpen-headingAddedNotes">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseAddedNotes" aria-expanded="false" aria-controls="panelsStayOpen-collapseAddedNotes">
                                            Documents
                                        </button>
                                    </h2>
                                    <div id="panelsStayOpen-collapseAddedNotes" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingAddedNotes">
                                        <div class="accordion-body">
                                             <asp:GridView ID="grdDocuments" runat="server" 
                         CssClass="table table-bordered table-condensed table-responsive table-hover" 
                        OnRowDataBound="grdDocuments_RowDataBound" AutoGenerateColumns="false">
                                                            <Columns>
                                               
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                       <asp:HyperLink ID="hlkAction" runat="server">
                                                                           <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                       </asp:HyperLink>
                                   
                                                                        <asp:HiddenField ID="HfDocID" runat="server" Value='<%# Eval("DocID") %>'/>
                                                                       
                                                                        <%--<a href="WorkFlowManagement/WFTaskInformation.aspx?SID=" + <%# _SID %>+ "&RFTP="+ '<%# Eval("RefType") %>' +  "&RFID=" + '<%# Eval("RefNum") %>' +  "&TID="+ '<%# Eval("WATID") %>' +  "" target="_top">
                                                                             <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                        </a>--%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="DocID" HeaderText="Document ID"/>
                                                                <asp:BoundField DataField="DocDesc" HeaderText="Description"/>
                                                                <asp:BoundField DataField="ProjNum" HeaderText="Project ID"/>
                                                                <asp:BoundField DataField="DocReqDate" HeaderText="Requested Date"/>
                                                                <asp:BoundField DataField="Status" HeaderText="Status"/>
                                                            </Columns>
            </asp:GridView>      


                                        </div>
                                    </div>
                                </div>
                                <%-- 12 --%>
                                <div class="accordion-item" runat="server" id="divhlnkChangeImpact" visible="true">
                                    <h2 class="accordion-header" id="panelsStayOpen-headingChangeImpact">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseChangeImpact" aria-expanded="false" aria-controls="panelsStayOpen-collapseChangeImpact">
                                            Reports
                                        </button>
                                    </h2>
                                    <div id="panelsStayOpen-collapseChangeImpact" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingChangeImpact">
                                        <div class="accordion-body">
                                            <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                                                        <asp:GridView Cssclass="table" ID="gvReports" runat="server" 
                        OnRowDataBound="gvReports_RowDataBound" 
                        OnSelectedIndexChanging = "gvReports_SelectedIndexChanging" 
                        OnRowDeleting="gvReports_RowDeleting" AllowPaging="true">
            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                                <%-- 13 --%>
                                <div class="accordion-item" runat="server" id="divhlnkMaterialDisposition" visible="true">
                                    <h2 class="accordion-header" id="panelsStayOpen-headingMaterialDisposition">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseMaterialDisposition" aria-expanded="false" aria-controls="panelsStayOpen-collapseMaterialDisposition">
                                            Projects
                                        </button>
                                    </h2>
                                    <div id="panelsStayOpen-collapseMaterialDisposition" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingMaterialDisposition">
                                        <div class="accordion-body">
                                               <asp:GridView ID="grdProjects" runat="server" 
                         CssClass="table table-bordered table-condensed table-responsive table-hover" 
                        OnRowDataBound="grdProjects_RowDataBound" AutoGenerateColumns="false">
                                                            <Columns>
                                               
                                                                <asp:TemplateField>
                                                                    <ItemTemplate>
                                                                       <asp:HyperLink ID="hlkAction" runat="server">
                                                                           <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                       </asp:HyperLink>
                                   
                                                                        <asp:HiddenField ID="HfProjNum" runat="server" Value='<%# Eval("ProjNum") %>'/>
                                                                       
                                                                        <%--<a href="WorkFlowManagement/WFTaskInformation.aspx?SID=" + <%# _SID %>+ "&RFTP="+ '<%# Eval("RefType") %>' +  "&RFID=" + '<%# Eval("RefNum") %>' +  "&TID="+ '<%# Eval("WATID") %>' +  "" target="_top">
                                                                             <img src='Legacy/graphics/find.gif' width='18' height='18' alt='Open' border='0'>
                                                                        </a>--%>
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="ProjNum" HeaderText="Project ID"/>
                                                                <asp:BoundField DataField="ProjName" HeaderText="Project Name"/>
                                                                <asp:BoundField DataField="Status" HeaderText="Status"/>
                                                                <asp:BoundField DataField="ActualStart" HeaderText="Actual Start Date"/>
                                                                <asp:BoundField DataField="PlannedFinish" HeaderText="Planned End Date"/>
                                                            </Columns>
            </asp:GridView>      
                                        </div>
                                    </div>
                                </div>
                                <%-- 14 --%>
                                <div class="accordion-item" runat="server" id="divhlnkWFTasks" visible="true">
                                    <h2 class="accordion-header" id="panelsStayOpen-headingThree">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseThree" aria-expanded="false" aria-controls="panelsStayOpen-collapseThree">
                                            Help Tickets
                                        </button>
                                    </h2>
                                    <div id="panelsStayOpen-collapseThree" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingThree">
                                        <div class="accordion-body" style="overflow:hidden;overflow:scroll auto;">
                                           <asp:GridView ID="gvNotes" runat="server" 
                                     CssClass="table table-bordered table-condensed table-responsive table-hover">
          </asp:GridView>     
                                        </div>
                                    </div>
                                </div>
                                <%-- 15 --%>
                                <div class="accordion-item" runat="server" id="divhlnkWFCustom" visible="true" style="display:none;">
                                    <h2 class="accordion-header" id="panelsStayOpen-headingFour">
                                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#panelsStayOpen-collapseFour" aria-expanded="false" aria-controls="panelsStayOpen-collapseFour">
                                            Custom Fields
                                        </button>
                                    </h2>
                                    <div id="panelsStayOpen-collapseFour" class="accordion-collapse collapse" aria-labelledby="panelsStayOpen-headingFour">
                                        <div class="accordion-body">
                                                                                                <asp:Literal ID="CustomLiteral" runat="server" />

                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


    </div>

    <asp:HiddenField ID="HfActionType" runat="server" />
     <script type="text/javascript">
         $("#lnkInBox").toggle(function () {
             $("#lnkInBox").css("color", "#0061f2");
         }, function () {
             $("#lnkInBox").css("color", "inherit");
         });
         $("#lnkChangeOrders").toggle(function () {
             $("#lnkChangeOrders").css("color", "#0061f2");

         }, function () {
             $("#lnkChangeOrders").css("color", "inherit");

         });
         $("#lnkDocuments").toggle(function () {
             $("#lnkDocuments").css("color", "#0061f2");

         }, function () {
             $("#lnkDocuments").css("color", "inherit");

         });
         $("#lnkReports").toggle(function () {
             $("#lnkReports").css("color", "#0061f2");

         }, function () {
             $("#lnkReports").css("color", "inherit");

         });
         $("#lnkProjects").toggle(function () {
             $("#lnkProjects").css("color", "#0061f2");

         }, function () {
             $("#lnkProjects").css("color", "inherit");

         });
         $("#lnkHelpTicktes").toggle(function () {
             $("#lnkHelpTicktes").css("color", "#0061f2");

         }, function () {
             $("#lnkHelpTicktes").css("color", "inherit");

         });
     </script>
</asp:Content>
