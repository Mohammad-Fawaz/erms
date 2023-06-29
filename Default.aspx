<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="DefaultPage" Title="My Home" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="MyHome" ContentPlaceHolderID="PageContent" Runat="Server">

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
      Default
   <iframe id="frameHome" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 

