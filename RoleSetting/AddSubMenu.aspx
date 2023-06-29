<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AddSubMenu.aspx.cs" Inherits="AddSubMenu" Title="Role Module" %>

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
                                          Sub MenuRole Module
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
                                    <div class="card-header">Sub Menu</div>                                     
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                           
                                          
                                                <asp:TextBox runat="server" ID="txtbox_AddRole" PlaceHolder="Add SubMenu"></asp:TextBox>
                                                <asp:Button  runat="server" ID="btn_AddRole" Text="Add SubMenu" OnClick="btn_AddRole_Click" />
                                                <br />
                                                <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed" ForeColor="Green"></asp:Label>
                                            </div>
                                        </div>
                                        <br />

                                         <div class="row" style="display:none">
                                            <div class="col-md-4">
                                                Main Modules
                                             <asp:DropDownList ID="ddl_Main_Modules" CssClass="form-select"  runat="server" OnSelectedIndexChanged="ddl_Main_Modules_SelectedIndexChanged" AutoPostBack="true">  
                                        </asp:DropDownList>  
                                           <asp:Label ID="Label4" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>

                                                 
                                            </div>
                                        </div>
                                        <h4> SubMenu</h4>
                                        <div class="row">
                                            <div class="col-md-12">
        <asp:GridView ID="grdv_SubMenu"  runat="server" AutoGenerateColumns="False" DataKeyNames="SubId" CssClass="table table-bordered table-condensed table-responsive table-hover">
    <Columns>
        <asp:TemplateField HeaderText="ID">
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" Text='<%#Bind("SubId") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Page Name">
            <ItemTemplate>
                <asp:Label ID="Label2" runat="server" Text='<%#Bind("SubmenuName") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
       
      
    </Columns>
   
</asp:GridView>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-2">
                                                <asp:Button ID="saveBtn" runat="server"    CssClass="btn btn-outline-primary m-1" onclick="Button1_Click"   
        Text="Save" />  

                        </div>
</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                

                            </div>
                             
        </main>
    <script language="javascript" type="text/javascript">
    
    </script>
</asp:Content>
