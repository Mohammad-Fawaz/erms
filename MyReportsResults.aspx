<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="MyReportsResults.aspx.cs" Inherits="MyReportsResults" Title="MyReports Results" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="MyReportsResults" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameMyReportsResults" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 

