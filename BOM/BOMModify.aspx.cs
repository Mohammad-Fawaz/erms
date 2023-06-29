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

public partial class BOM_BOMModify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameModifyBOM.Attributes["src"] = "../Legacy/SecWeb/bom_mod.asp?SID=" + _SID;
        this.frameModifyBOM.Attributes["width"] = "100%";
        this.frameModifyBOM.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameModifyBOM.Attributes["frameborder"] = "0";
        this.frameModifyBOM.Attributes["scrolling"] = "no"; 
    }
}
