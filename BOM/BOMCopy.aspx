<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="BOMCopy.aspx.cs" Inherits="BOM_BOMCopy" Title="Copy BOM" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="CopyBOM" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameCopyBOM" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 

