<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="BOMCreate.aspx.cs" Inherits="BOM_BOMCreate" Title="Create BOM" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="CreateBOM" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameCreateBOM" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 
