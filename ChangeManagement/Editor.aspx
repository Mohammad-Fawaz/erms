<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Editor.aspx.cs" Inherits="TextEditorWeb.Editor" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Text Editor With JQuery</title>
    <link href="CSS/demo.css" rel="stylesheet" type="text/css" />
    <link href="CSS/jquery-te-1.4.0.css" rel="stylesheet" type="text/css" />
</head>s
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="txtEditor" TextMode="MultiLine" runat="server" CssClass="textEditor"
            onblur="Test()"></asp:TextBox>
        <asp:Button ID="btnText" runat="server" Text="Show Text" OnClick="btnText_Click" />
        <asp:HiddenField ID="hdText" runat="server" />
        <asp:TextBox ID="txtReText" TextMode="MultiLine" runat="server" CssClass="textEditor1"></asp:TextBox>
    </div>
    </form>
</body>
<script src="JS/jquery-1.10.2.min.js" type="text/javascript"></script>
<script src="JS/jquery-te-1.4.0.min.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
    $('.textEditor1').jqte();
    $(".textEditor").jqte({ blur: function () {
        document.getElementById('<%=hdText.ClientID %>').value = document.getElementById('<%=txtEditor.ClientID %>').value;
    }
    });
</script>
</html>
