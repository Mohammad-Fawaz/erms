<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="BOMReport.aspx.cs" Inherits="BOMReport" Title="BOM Report" %>
<%@ MasterType VirtualPath="~/Default.master"%>


<asp:Content ID="BOMReport" ContentPlaceHolderID="PageContent" Runat="Server">
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
   <iframe id="frameBOM" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>
</asp:Content>

