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

public partial class BOM_BOMCreate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameCreateBOM.Attributes["src"] = "../Legacy/SecWeb/bom_createh1.asp?SID=" + _SID;
        this.frameCreateBOM.Attributes["width"] = "100%";
        this.frameCreateBOM.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameCreateBOM.Attributes["frameborder"] = "0";
        this.frameCreateBOM.Attributes["scrolling"] = "no"; 
    }
}
