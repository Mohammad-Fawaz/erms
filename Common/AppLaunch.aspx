<%@ Page Language="C#" MasterPageFile="~/Default.master" AutoEventWireup="true" CodeFile="AppLaunch.aspx.cs" Inherits="Actions_AppLaunch" Title="Launch External Application" %>
<%@ MasterType VirtualPath="~/Default.master"%>


<asp:Content ID="AppLaunch" ContentPlaceHolderID="PageContent" Runat="Server">
 <script type="text/javascript"> 
  //Adjust FrameHeight to Content
  function AdjustFrameHeight(objframe)
  {
   objframe.style.height = objframe.contentWindow.document.body.scrollHeight + "px";
   //alert(objframe.style.height);
  } 
 </script>

 <script type="text/javascript">
  function launchApp()
  {
    var userselect = confirm("Do you like to launch VB Application ?");
    if(userselect)
    {
     var strCmdLine = document.getElementById('ctl00_PageContent_hdnVBAppPath').value;
     var myLauncher = new ActiveXObject("LaunchinIE.Launch");
     myLauncher.LaunchApplication(strCmdLine);     
    }    
  }
 </script>

   <asp:HiddenField ID="hdnVBAppPath" runat="server" />    
   <iframe id="frameAppLaunch" runat="server">    
   </iframe>
   
</asp:Content>

