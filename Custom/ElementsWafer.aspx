<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ElementsWafer.aspx.cs" Inherits="Custom_ElementsWafer" Title="Elements And Wafers" %>
<%@ MasterType VirtualPath="~/Default.master"%>


<asp:Content ID="ToDo" ContentPlaceHolderID="PageContent" Runat="Server">
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
   <iframe id="frameEW" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>
</asp:Content>

