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
using System.Collections.Generic;

public partial class DefaultPage : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        //String _SID = this.Master.SID;

        Response.Redirect("DashBoard.aspx");

        //    this.frameHome.Attributes["src"] = "Legacy/SecWeb/ermsw_index.asp?SID=" + _SID;
        //this.frameHome.Attributes["width"] = "100%";
        //this.frameHome.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        //this.frameHome.Attributes["frameborder"] = "0";
        //this.frameHome.Attributes["scrolling"] = "no";

    }
}
