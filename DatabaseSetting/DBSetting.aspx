<%@ Page Title="" Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="DBSetting.aspx.cs" Inherits="DatabaseSetting_DBSetting" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="Server">
    <div class="container-xl px-4 mt-4">
        <div class="row">
            <div class="col-xl-12">
                <div class="card mb-4">
                    <div class="card-header">Database Setting</div>
                    <div class="card-body">
                        <div class="row gx-3 mb-3">
                            <div class="col-md-6">
                                <label class="small mb-1" for="lbtnDownload">IsProduction ?</label>

                                <label class="switch">
                                    <asp:CheckBox ID="chkIsProd" runat="server" Checked="true" OnCheckedChanged="chkIsProd_CheckedChanged" AutoPostBack="true" />
                                    <span class="slider round"></span>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="card-header border-0">Upload/Download Database</div>
                    <div class="card-body">
                        <div class="row gx-3 mb-3">
                            <div class="col-md-6">
                                <asp:RadioButtonList ID="rblServer" CssClass="database" runat="server">
                                    <asp:ListItem Value="test" Selected="True">Test Database</asp:ListItem>
                                    <asp:ListItem Value="prod">Production Database</asp:ListItem>
                                </asp:RadioButtonList>
                                <label class="small mb-1" for="btnSave">File Upload</label>
                                <div class="d-flex align-items-center">
                                    <asp:FileUpload ID="fuDatabase" CssClass="form-control" runat="server" />
                                    <asp:Button CssClass="btn btn-outline-primary m-1" ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" />
                                </div>
                            </div>
                        </div>
                        <div class="row gx-3 mb-3">
                            <label class="small mb-1" for="lbtnDownload">File Download</label>
                            <asp:LinkButton ID="lbtnDownload" runat="server" OnClick="lbtnDownload_Click">Download</asp:LinkButton>
                            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

