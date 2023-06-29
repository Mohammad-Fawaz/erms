<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Test.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>    
    <form id="form1" runat="server">   
    <div style="text-align:center">   
        <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
			<td valign="top" align="center" class="content-header-text">
			<asp:Label ID="lblHeader" runat="server" Text="ERMSWeb" Width="889px" 
			 BackColor="#0075FF" Font-Bold="True" Font-Size="XX-Large" ForeColor="White"></asp:Label>            
			</td>
		 </tr>
		 <tr>	
			<td valign="top" align="center" class="content-header-text" bgcolor="#0075FF">

			<asp:Label ID="lblSubHeader" runat="server" Text="Engineering Resource Management System" 
             Width="889px" BackColor="White" Font-Size="Large" ForeColor="#0075FF"></asp:Label>
            </td>  
		 </tr>	
		</table> 			      
        <br /> 
        <table width="760" border="0" cellspacing="0" cellpadding="0">
         <tr>
			<td valign="top" align="center" class="content-header-text">
			 ID&nbsp;:&nbsp;
			 <asp:TextBox ID="txtID" runat="server" Width="75"></asp:TextBox>
			 &nbsp;&nbsp;Type&nbsp;:&nbsp;
			 <asp:DropDownList ID="ddlType" runat="server" OnSelectedIndexChanged="ddlType_SelectedIndexChanged" AutoPostBack="True">			 
                 <asp:ListItem Value="0">Document</asp:ListItem>
                 <asp:ListItem Value="1">Change Orders</asp:ListItem>
                 <asp:ListItem Value="2">Orders</asp:ListItem>
                 <asp:ListItem Value="3">Parts</asp:ListItem>
                 <asp:ListItem Value="4">Projects</asp:ListItem>
                 <asp:ListItem Value="5">Tasks</asp:ListItem>
			 </asp:DropDownList>
			 &nbsp;&nbsp;Status&nbsp;:&nbsp;
			 <asp:DropDownList ID="ddlStatus" runat="server"></asp:DropDownList>
             &nbsp;&nbsp;&nbsp;&nbsp;  
             <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
            </td>
		 </tr>	
		 </table> 
		 <br />
		 <table width="760" border="0" cellspacing="0" cellpadding="0">	 	       
		 <tr>
			<td valign="top" align="center" class="content-header-text">
             <asp:GridView ID="gvSearchResults" runat="server" AllowPaging="True" OnRowDataBound="gvSearchResults_RowDataBound" OnPageIndexChanging="gvSearchResults_PageIndexChanging">
             </asp:GridView> 
            </td>
         </tr>   
         </table>
       </div>    
    </form>     
</body>
</html>
