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

public partial class Support : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameSupportLinks.Attributes["src"] = "Legacy/SecWeb/supp_links.asp?SID=" + _SID;
        this.frameSupportLinks.Attributes["width"] = "100%";
        this.frameSupportLinks.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameSupportLinks.Attributes["frameborder"] = "0";
        this.frameSupportLinks.Attributes["scrolling"] = "no";  
    }
}
