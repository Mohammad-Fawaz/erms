<%--    <script type="text/javascript" src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/@tinymce/tinymce-jquery@1/dist/tinymce-jquery.min.js"></script>--%>


<%@ Page Title="" ValidateRequest="false" Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="HTMLTemplate_Default" %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="Server">
    <div class="container-xl px-4 mt-4">
        <div class="row">
            <div class="col-xl-12">
                <div class="card mb-4">
                    <div class="card-header">HTML Templates</div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <asp:HiddenField ID="hdnTemplateId" runat="server"></asp:HiddenField>
                                <label class="small mb-1" for="txtTemplateName">Templatate Name<span class="red">*</span></label>
                                <asp:TextBox runat="server" ID="txtTemplateName" CssClass="form-control" Placeholder="Template Name"></asp:TextBox>
                            </div>
                            <div class="col-md-4" >
                                <label class="small mb-1" for="drpRequestPage">Templatate Request Page<span class="red">*</span></label>
                                <asp:DropDownList ID="drpRequestPage" AutoPostBack="true" CssClass="form-select" runat="server" OnSelectedIndexChanged="MainRequstChange">
                                </asp:DropDownList>
                                <asp:TextBox runat="server" ID="txtPageName" CssClass="form-control" disabled="true" Visible="false" Placeholder="Page Name"></asp:TextBox>
                            </div>
                            <div class="col-md-4" id="divRequestType">
                                <label class="small mb-1" ID="lblRequestType" runat="server" for="drpRequestPage">Sub Request Type<span class="red">*</span></label>
                                <asp:DropDownList ID="ddlRequestType" AutoPostBack="true" CssClass="form-select" runat="server">
                                </asp:DropDownList>
                                <asp:TextBox runat="server" ID="txtRequestType" CssClass="form-control" disabled="true" Visible="false" Placeholder="Page Name"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">
                            <div class="row gx-3 mb-3">
                                <div class="col-lg-12" runat="server">
                                    <label class="small mb-1" for="txtRequestedBy">Templatate Data<span class="red">*</span></label>
                                    <CKEditor:CKEditorControl ID="txtTemplateData" BasePath="../ckeditor/" runat="server" ToolbarStartupExpanded="true">
                                    </CKEditor:CKEditorControl>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-0">
                            <asp:Button runat="server" ID="btn_AddTempalte" Text="Add Template" OnClick="btn_Add_Template_Click" CssClass="btn btn-outline-primary m-1" />
                            <asp:Button runat="server" ID="btn_UpdateTempalte" Text="Update Template" OnClick="btn_Update_Template_Click" Visible="false" CssClass="btn btn-outline-primary m-1" />
                            <br />
                            <asp:Label ID="lblStatus" runat="server" CssClass="CtrlWideValueViewRed"></asp:Label>
                        </div>

                        <div class="row gx-3 mb-3">
                            <div class="col-md-12">
                                <asp:GridView 
                                    ID="gvHtmlTemplate" 
                                    runat="server" 
                                    AutoGenerateColumns="False" 
                                    DataKeyNames="ID" 
                                    CssClass="table table-bordered table-condensed table-responsive table-hover">
                                    <Columns>
                                        <asp:TemplateField HeaderText="ID">
                                            <ItemTemplate>
                                                <asp:Label ID="lblId" runat="server" Text='<%#Bind("ID") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblName" runat="server" Text='<%#Bind("Name") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Resquest Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPageName" runat="server" Text='<%#Bind("PageName") %>'></asp:Label>
                                                <asp:HiddenField ID="HiddenField1" runat="server" Value='<%#Bind("PageId") %>'></asp:HiddenField>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Resquest Desc">
                                            <ItemTemplate>
                                                <asp:Label ID="lblRequestdesc" runat="server" Text='<%#Bind("Description") %>'></asp:Label>
                                                <asp:HiddenField ID="HiddenRequestCode" runat="server" Value='<%#Bind("RequestCode") %>'></asp:HiddenField>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Action">
                                            <ItemTemplate>
                                                <asp:LinkButton runat="server" ID="lnkbtn_Edit"
                                                    OnCommand="lnkbtn_Edit_Click"
                                                    Text="Edit"
                                                    CommandArgument='<%# Eval("ID") + "," + Eval("Name") + "," + Eval("PageName") %>'></asp:LinkButton>
                                                <asp:LinkButton runat="server" Text="Delete" OnClientClick="return confirmationDelete()" ID="lnkbtn_Delete" OnCommand="lnkbtn_Delete_Click" CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function confirmationDelete() {
            if (confirm('Are you sure you want to delete Template ?')) {
                return true;
            } else {
                return false;
            }
        }
    </script>
    <script language="javascript" type="text/javascript">
        //$('textarea#PageContent_tiny').tinymce({
        //    height: 500,
        //    menubar: false,
        //    plugins: [
        //        'a11ychecker', 'advlist', 'advcode', 'advtable', 'autolink', 'checklist', 'export',
        //        'lists', 'link', 'image', 'charmap', 'preview', 'anchor', 'searchreplace', 'visualblocks',
        //        'powerpaste', 'fullscreen', 'formatpainter', 'insertdatetime', 'media', 'table', 'help', 'wordcount'
        //    ],
        //    toolbar: 'undo redo | a11ycheck casechange blocks | bold italic backcolor | alignleft aligncenter alignright alignjustify | bullist numlist checklist outdent indent | removeformat | code table help'
        //});
    </script>
</asp:Content>

