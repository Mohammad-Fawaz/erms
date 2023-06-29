<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="QSearch.aspx.cs" Inherits="QSearch" Title="Quick Search" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="QSearch" ContentPlaceHolderID="PageContent" Runat="Server">

    <script type="text/javascript"> 
 //Adjust FrameHeight to Content
 function AdjustFrameHeight(objframe)
 {
  objframe.style.height = objframe.contentWindow.document.body.scrollHeight + "px";
  //alert(objframe.style.height);
 } 
</script>

<table class="Table">
 <tr>
  <td>
   <iframe id="frameQSearch" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 