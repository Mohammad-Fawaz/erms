<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="ToDo.aspx.cs" Inherits="Actions_ToDo" Title="To Do Listing" %>
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
<table class="table table-responsive table-borderless">
 <tr>
  <td>
   <iframe id="frameToDo" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>
</asp:Content>

