<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AssignDropDowns.aspx.cs" Inherits="AssignDropDowns" Title="Role Module" %>

<%@ Register Src="../App_Controls/ERMSCalendar.ascx" TagName="ERMSCalendar" TagPrefix="ucCalendar" %>

<%@ MasterType VirtualPath="~/Default.master" %>

<asp:Content ID="RoleModule" ContentPlaceHolderID="PageContent" runat="Server">
    <main>
  <header class="page-header page-header-compact page-header-light border-bottom bg-white mb-4">
                        <div class="container-xl px-4">
                            <div class="page-header-content">
                                <div class="row align-items-center justify-content-between pt-3">
                                    <div class="col-auto mb-3">
                                        <h1 class="page-header-title">
                                            <div class="page-header-icon"><i data-feather="user"></i></div>
                                            Role Module
                                        </h1>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </header>
        <div class="container-xl px-4 mt-4">                                               
                        <div class="row">                          
                            <div class="col-xl-12">
                                <!-- Task Document card-->
                                <div class="card mb-4">
                                    <div class="card-header">Role Module</div>                                     
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                Role Profile
                                             <asp:DropDownList ID="AppSecProfile" AutoPostBack="true" OnSelectedIndexChanged="AppSecProfile_SelectedIndexChanged" CssClass="form-select"  runat="server">  
                                        </asp:DropDownList>  
                                               

                                                 
                                            </div>
                                             <div class="col-md-4">
                                                Main Modules
                                             <asp:DropDownList ID="ddl_Main_Modules" CssClass="form-select"  runat="server" OnSelectedIndexChanged="ddl_Main_Modules_SelectedIndexChanged" AutoPostBack="true">  
                                        </asp:DropDownList>  
                                           <asp:Label ID="Label4" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>

                                                 
                                            </div>
                                              
                                        </div>
                                        <br />
                                  
        
                                         <div class="row">
                                           
                                        </div>
                                         <div class="row">
                                            <div class="col-md-4">
                                                Pages
                                             <asp:DropDownList ID="ddlPages" CssClass="form-select"  runat="server" OnSelectedIndexChanged="ddlPages_SelectedIndexChanged" AutoPostBack="true">  
                                        </asp:DropDownList>  
                                           <asp:Label ID="Label2" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>

                                                 
                                            </div>
                                               <div class="col-md-4">
                                                Security Mode
                                             <asp:DropDownList ID="ddlSecurityMode" CssClass="form-select"  runat="server" OnSelectedIndexChanged="ddlSecurityMode_SelectedIndexChanged" AutoPostBack="true">
                                              <asp:ListItem Value="1">View</asp:ListItem>
                                                 <%--<asp:ListItem Value="1">Visible</asp:ListItem>--%>
                                                <%-- <asp:ListItem Value="2">View</asp:ListItem>--%>
                                                 <asp:ListItem Value="3">Editable</asp:ListItem>
                                        </asp:DropDownList>  
                                           <asp:Label ID="Label3" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>

                                                 
                                            </div>
                                        </div>
                                       
                                         <div class="row">
                                          
                                        </div>
                                        <h4>Assign Pages</h4>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <asp:GridView ID="GridView1"  runat="server" OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound" AutoGenerateColumns="False" DataKeyNames="ID" CssClass="table table-bordered table-condensed table-responsive table-hover">
    <Columns>
        <asp:TemplateField HeaderText="ID">
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%#Bind("ID") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Master Field Desc">
            <ItemTemplate>
                <asp:Label ID="lblMasterFieldDesc" runat="server" Text='<%#Bind("MasterFieldDesc") %>'></asp:Label>
                 <asp:HiddenField  runat="server" ID="hfd_MasterFieldID" Value='<%#Bind("MasterFieldID") %>'/>
                  <asp:HiddenField  runat="server" ID="hfdSubFieldID" Value='<%#Bind("SubFieldID") %>'/>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Childern Name">
            <ItemTemplate>
                <asp:Label ID="lblSubFieldDesc" runat="server" Text='<%#Bind("SubFieldDesc") %>'></asp:Label>
                 <asp:HiddenField  runat="server" ID="hfd_Checked" Value='<%#Bind("Checked") %>'/>
            </ItemTemplate>
        </asp:TemplateField>
        <%-- <asp:TemplateField HeaderText="Checked Name">
            <ItemTemplate>
                <asp:Label ID="lblChecked" runat="server" Text='<%#Bind("Checked") %>'></asp:Label>
                 <%--<asp:HiddenField  runat="server" ID="hfd_Checked" Value='<%#Bind("Checked") %>'/>--%>
<%--            </ItemTemplate>
        </asp:TemplateField>--%>
        <asp:TemplateField HeaderText="Mark Sub Menu" Visible="false">
            <ItemTemplate>
                <asp:LinkButton runat="server" ID="lnkbtn_AddSubChild" OnClick="lnkbtn_AddSubChild_Click" Text="Mark SubMenu" CommandArgument='<%#Bind("ID") %>'></asp:LinkButton>
               
            </ItemTemplate>
        </asp:TemplateField>
      <asp:TemplateField >
            <HeaderTemplate>                   
                    &nbsp;&nbsp; <asp:CheckBox ID="chkCheckAll" runat="server"  onclick="SelectAllCheckboxes(this);"/>
            </HeaderTemplate>
            <ItemTemplate>
                &nbsp;&nbsp;<asp:CheckBox ID="chkCheck" runat="server"  onclick="javascript:CheckedCheckboxes(this)"/>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
   
</asp:GridView>
                                                <asp:HiddenField runat="server" ID="hfd_allcheck" Value="True"/>
                                            </div>
                                        </div>
                                          <div class="row">
                                            <div class="col-md-6">
                                                <asp:Button ID="Button1" runat="server"    CssClass="btn btn-outline-primary m-1" onclick="Button1_Click"  Text="Save" />   
                                                <asp:Label runat="server" ID="lblStatus"></asp:Label>
                                                                          <asp:Button ID="Button2" runat="server"  Visible="false"   CssClass="btn btn-outline-primary m-1" onclick="btn_dlt_Click"   
        Text="Delete" />

                        </div>
</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                

                            </div>
                             
        </main>
    <script language="javascript" type="text/javascript">
        function SelectAllCheckboxes(chk) {
            debugger;
            var totalRows = $("#<%=GridView1.ClientID %> tr").length;
            var selected = 0;
            $('#<%=GridView1.ClientID %>').find("input:checkbox").each(function () {
                if (this != chk) {
                    this.checked = chk.checked;
                    selected += 1;
                }
            });
        }

        function CheckedCheckboxes(chk) {
            debugger;

            if (chk.checked) {
                var totalRows = $('#<%=GridView1.ClientID %> :checkbox').length;
                var checked = $('#<%=GridView1.ClientID %> :checkbox:checked').length
                if (checked == (totalRows - 1)) {
                    $('#<%=GridView1.ClientID %>').find("input:checkbox").each(function () {
                    this.checked = true;
                });
            }
            else {
                $('#<%=GridView1.ClientID %>').find('input:checkbox:first').removeAttr('checked');
                }
            }
            else {
                $('#<%=GridView1.ClientID %>').find('input:checkbox:first').removeAttr('checked');
            }
        }
       <%-- function getDBInfo() {
            debugger;
            var mySelectedIndex = $('#<%=AppSecProfile.ClientID%>').val();
            alert(mySelectedIndex);
            $.ajax({
                type: "POST",
                url: "RoleModule.aspx/getDBInfo",
                data: '{param:"' + mySelectedIndex + '"}',
                contentType: "application / json; charset=utf - 8",
                success: function (data) {
                    debugger;
                    alert(data.d)
                }
            });

        }
        --%>
    </script>
</asp:Content>
