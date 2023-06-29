<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="PrintRequest.aspx.cs" Inherits="Common_PrintRequest" Title="Print Request" %>
<%@ MasterType VirtualPath="~/Default.master"%>


<asp:Content ID="PrintRequest" ContentPlaceHolderID="PageContent" Runat="Server">
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
   <iframe id="framePrintRequest" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>
</asp:Content>

