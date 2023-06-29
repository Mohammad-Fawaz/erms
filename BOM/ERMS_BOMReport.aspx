<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ERMS_BOMReport.aspx.cs" Inherits="ERMS_BOMReport" Title="ERMS BOM Report" %>
<%@ MasterType VirtualPath="~/Default.master"%>


<asp:Content ID="ERMS_BOMReport" ContentPlaceHolderID="PageContent" Runat="Server">
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
   <iframe id="frameERMSBOM" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>
</asp:Content>

