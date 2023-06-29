<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AddRole.aspx.cs" Inherits="AddRole" Title="Role Module" %>

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
                                            <div class="col-md-2" style="display:none">
                                             <asp:DropDownList ID="AppSecProfile" AutoPostBack="true" OnSelectedIndexChanged="AppSecProfile_SelectedIndexChanged" CssClass="form-select"  runat="server">  
                                        </asp:DropDownList>  
                                               

                                                 
                                            </div>
                                              
                                        </div>
                                        <br />
                                        <div class="row">
                                             <div class="col-md-4">
                                     
                                               
                                                <asp:TextBox runat="server" ID="txtbox_AddRole"  CssClass="form-control" Placeholder="Add Role"></asp:TextBox>
                                                

                                                 
                                            </div>
                                              <div class="col-md-0">
                                                 <asp:Button  runat="server" ID="btn_AddRole" Text="Add Role" OnClick="btn_AddRole_Click"  CssClass="btn btn-outline-primary m-1" />
                                                  <asp:Button  runat="server" ID="btn_update" Text="Update Role" OnClick="btn_update_Click" Visible="false"  CssClass="btn btn-outline-primary m-1" />
                                                 <br />
                                           <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>

                                            </div>
                                          
                                            </div>
                                             <div class="row">
                                           
                                        </div>
                                   <br />
                                        <asp:HiddenField  runat="server" ID="Hfd_Roleid"/>
                                        <h4>Roles</h4>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <asp:GridView ID="GridView1"  runat="server" OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound" AutoGenerateColumns="False" DataKeyNames="ProfileId" CssClass="table table-bordered table-condensed table-responsive table-hover">
    <Columns>
        <asp:TemplateField HeaderText="RoleID">
            <ItemTemplate>
                <asp:Label ID="lbl_RoleId" runat="server" Text='<%#Bind("ProfileId") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Role Name">
            <ItemTemplate>
                <asp:Label ID="lbl_RoleName" runat="server" Text='<%#Bind("ProfileDesc") %>'></asp:Label>
                 <%--<asp:HiddenField  runat="server" ID="hfd_childId" Value='<%#Bind("CId") %>'/>
                  <asp:HiddenField  runat="server" ID="hfdHasChildernMenu" Value='<%#Bind("HasChildernMenu") %>'/>--%>
            </ItemTemplate>
        </asp:TemplateField>
        
       
        <asp:TemplateField HeaderText="Edit">
            <ItemTemplate>
                <asp:LinkButton runat="server" ID="lnkbtn_AddSubChild" OnClick="lnkbtn_AddSubChild_Click" Text="Edit" ToolTip='<%#Bind("ProfileDesc") %>' CommandArgument='<%#Bind("ProfileId") %>'></asp:LinkButton>
               
            </ItemTemplate>
        </asp:TemplateField>
          <asp:TemplateField HeaderText="Delete">
            <ItemTemplate>
                <asp:LinkButton runat="server" ID="lnkbtn_dltRole" OnClick="lnkbtn_dltRole_Click" Text="Delete" OnClientClick="return confirmationDelete()" ToolTip='<%#Bind("ProfileDesc") %>' CommandArgument='<%#Bind("ProfileId") %>'></asp:LinkButton>
               
            </ItemTemplate>
        </asp:TemplateField>
      <asp:TemplateField  Visible="false">
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
                                            <div class="col-md-2">
                                                <asp:Button ID="saveBtn" runat="server"    CssClass="btn btn-outline-primary m-1" onclick="Button1_Click"   
        Text="Save" /> 
                                                                          <asp:Button ID="btn_dlt" runat="server"  Visible="false"   CssClass="btn btn-outline-primary m-1" onclick="btn_dlt_Click"   
        Text="Delete" />

                        </div>
</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                

                            </div>
                             
        </main>
    <script type="text/javascript">
        function confirmationDelete() {
            if (confirm('Are you sure you want to delete Package ?')) {
                return true;
            } else {
                return false;
            }
        }
    </script>
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
