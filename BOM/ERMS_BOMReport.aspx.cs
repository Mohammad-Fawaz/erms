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

public partial class ERMS_BOMReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;
        this.frameERMSBOM.Attributes["src"] = "../Legacy/SecWeb/bom_rpts.asp?SID=" + _SID;
        this.frameERMSBOM.Attributes["width"] = "100%";
        this.frameERMSBOM.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameERMSBOM.Attributes["frameborder"] = "0";
        this.frameERMSBOM.Attributes["scrolling"] = "no";  
    }
}
