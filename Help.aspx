<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="Help.aspx.cs" Inherits="Help" Title="Help" %>
<%@ MasterType VirtualPath="~/Default.master"%>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<asp:Content ID="Help" ContentPlaceHolderID="PageContent" Runat="Server">

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
   <iframe id="frameHelp" runat="server">  
   </iframe>
  </td>
 </tr>    			
 </table>

</asp:Content> 