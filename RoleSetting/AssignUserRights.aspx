﻿<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AssignUserRights.aspx.cs" Inherits="AssignUserRights" Title="Role Module" %>

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
                                Pages Field Module
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
                        <div class="card-header">Pages Field Module</div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    Select Role
                                             <asp:DropDownList ID="AppSecProfile" CssClass="form-select" OnSelectedIndexChanged="AppSecProfile_SelectedIndexChanged" AutoPostBack="true" runat="server">
                                             </asp:DropDownList>
                                    <asp:Button Visible="false" runat="server" ID="btn_AddRole" Text="Add Role" OnClick="btn_AddRole_Click" />
                                    <asp:TextBox Visible="false" runat="server" ID="txtbox_AddRole"></asp:TextBox>
                                    <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>


                                </div>
                                <div class="col-md-6">
                                    Main Modules
                                             <asp:DropDownList ID="ddl_Main_Modules" CssClass="form-select" runat="server" OnSelectedIndexChanged="ddl_Main_Modules_SelectedIndexChanged" AutoPostBack="true">
                                             </asp:DropDownList>
                                    <asp:Label ID="Label4" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>


                                </div>
                            </div>
                            <br />

                            <div class="row">

                                <div class="col-md-6">
                                    Sub Modules
                                             <asp:DropDownList ID="ddl_Asssign_Pages" CssClass="form-select" runat="server" OnSelectedIndexChanged="ddl_Asssign_Pages_SelectedIndexChanged" AutoPostBack="true">
                                             </asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    Sub Sub Modules
                                            <asp:DropDownList runat="server" CssClass="form-select" ID="ddl_SubModules" AutoPostBack="true" OnSelectedIndexChanged="ddl_SubModules_SelectedIndexChanged" Visible="false"></asp:DropDownList>
                                </div>
                            </div>


                            <h4>Sub Pages</h4>
                            <div class="row">
                                <div class="col-md-12">
                                    <asp:GridView ID="GridView1" runat="server" OnRowDataBound="GridView1_RowDataBound" AutoGenerateColumns="False" DataKeyNames="ControlId" CssClass="table table-bordered table-condensed table-responsive table-hover">
                                        <Columns>
                                            <asp:TemplateField HeaderText="ID">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbl" runat="server" Text='<%#Bind("ControlId") %>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Field Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblControlName" runat="server" Text='<%#Bind("ControlName") %>'></asp:Label>
                                                    <asp:HiddenField runat="server" ID="hfd_ID" Value='<%#Bind("ID") %>' />
                                                    <%--     <asp:HiddenField  runat="server" ID="hfdHasChildernMenu" Value='<%#Bind("HasChildernMenu") %>'/>--%>
                                                </ItemTemplate>
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="Mark Sub Menu" Visible="false">
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" ID="lnkbtn_AddSubChild" OnClick="lnkbtn_AddSubChild_Click" Text="Mark SubMenu" CommandArgument='<%#Bind("PageId") %>'></asp:LinkButton>

                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <HeaderTemplate>
                                                    &nbsp;&nbsp;
                                                    <asp:CheckBox ID="chkCheckAll" runat="server" onclick="SelectAllCheckboxes(this);" />

                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    &nbsp;&nbsp;<asp:CheckBox ID="chkCheck" runat="server" onclick="javascript:CheckedCheckboxes(this)" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>

                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-2">
                                    <asp:Button ID="saveBtn" runat="server" CssClass="btn btn-outline-primary m-1" OnClick="Button1_Click"
                                        Text="Save" />

                                    <asp:Button ID="btn_dlt" runat="server" Visible="false" CssClass="btn btn-outline-primary m-1" OnClick="btn_dlt_Click"
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
