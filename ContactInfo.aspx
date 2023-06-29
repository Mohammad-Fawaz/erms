<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ContactInfo.aspx.cs" Inherits="ContactInfo" Title="Contact Information" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="ContactInfo" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameContactInfo" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 