using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Actions_ToDo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameToDo.Attributes["src"] = "../Legacy/SecWeb/act_todo.asp?SID=" + _SID;
        this.frameToDo.Attributes["width"] = "100%";
        this.frameToDo.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameToDo.Attributes["frameborder"] = "0";
        this.frameToDo.Attributes["scrolling"] = "no";  
    }
}
