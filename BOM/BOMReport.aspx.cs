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

public partial class BOMReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameBOM.Attributes["src"] = "../Legacy/SecWeb/glov_bom.asp?SID=" + _SID;
        this.frameBOM.Attributes["width"] = "100%";
        this.frameBOM.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameBOM.Attributes["frameborder"] = "0";
        this.frameBOM.Attributes["scrolling"] = "no";  
    }
}
