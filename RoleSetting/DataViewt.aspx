<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DataViewt.aspx.cs" Inherits="RoleSetting_DataViewt" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
   <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script>
    $("[src*=plus]").live("click", function () {
        $(this).closest("tr").after("<tr><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
        $(this).attr("src", "../images/minus.gif");
    });
    $("[src*=minus]").live("click", function () {
        $(this).attr("src", "../images/ig_treeMplus.gif");
        $(this).closest("tr").next().remove();
    });
</script>
<style>
.subcategory
{margin-left: 20px;}
a {text-decoration: none;}
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:DataList ID="dlcategory" runat="server" DataKeyField="ID">
        <ItemTemplate>
        <img alt = "" style="cursor: pointer" src="../images/ig_treeMplus.gif"/>      
                  <%# DataBinder.Eval(Container.DataItem, "PageName")%>
                 <%--<div style="display: none">
                    <asp:DataList ID="dlsubcategory" runat="server" >
                        <ItemTemplate>
                              <asp:HyperLink runat="server" Text='<%# Eval("PageName") %>' CssClass="subcategory"  NavigateUrl="#"></asp:HyperLink>
                        </ItemTemplate>
                    </asp:DataList>
                   </div>--%>
        </ItemTemplate>
        </asp:DataList>
        </div>
    </form>
</body>
</html>
