<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AdvanceSearch.aspx.cs" Inherits="AdvanceSearch" Title="Advanced Search" %>
<%@ MasterType VirtualPath="~/Default.master"%>

<asp:Content ID="AdvanceSearch" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameAdvanceSearch" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 

