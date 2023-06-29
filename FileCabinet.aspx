<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="FileCabinet.aspx.cs" Inherits="FileCabinet" Title="File Cabinet" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="FileCabinet" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameFileCabinet" runat="server">  
   </iframe>
  </td>
 </tr>    			

 </table>

</asp:Content> 