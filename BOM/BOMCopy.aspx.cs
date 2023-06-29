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

public partial class BOM_BOMCopy : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameCopyBOM.Attributes["src"] = "../Legacy/SecWeb/bom_copy.asp?SID=" + _SID;
        this.frameCopyBOM.Attributes["width"] = "100%";
        this.frameCopyBOM.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameCopyBOM.Attributes["frameborder"] = "0";
        this.frameCopyBOM.Attributes["scrolling"] = "no"; 
    }
}
