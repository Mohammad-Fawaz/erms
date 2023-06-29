<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="BOMModify.aspx.cs" Inherits="BOM_BOMModify" Title="Modify BOM" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="ModifyBOM" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameModifyBOM" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 
