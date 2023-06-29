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

public partial class FileCabinet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameFileCabinet.Attributes["src"] = "Legacy/SecWeb/view_fcab.asp?SID=" + _SID;
        this.frameFileCabinet.Attributes["width"] = "100%";
        this.frameFileCabinet.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameFileCabinet.Attributes["frameborder"] = "0";
        this.frameFileCabinet.Attributes["scrolling"] = "no";  
    }
}
