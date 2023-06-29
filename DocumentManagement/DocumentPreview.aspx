<%@ Page Title="" Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="DocumentPreview.aspx.cs" Inherits="DocumentManagement_DocumentPreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageContent" runat="Server">
    <asp:Label ID="lblMessage" runat="server">

    </asp:Label>
    <iframe runat="server" title="Demo pdf" id="MyIframe" scrolling="auto" width="100%" height="768px" frameborder="0"></iframe>
</asp:Content>

