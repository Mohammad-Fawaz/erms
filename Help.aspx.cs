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

public partial class Help : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameHelp.Attributes["src"] = "Legacy/SecWeb/supp_docs.asp?SID=" + _SID;
        this.frameHelp.Attributes["width"] = "100%";
        this.frameHelp.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameHelp.Attributes["frameborder"] = "0";
        this.frameHelp.Attributes["scrolling"] = "no"; 
    }
}
