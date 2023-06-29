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

public partial class Common_PrintRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.framePrintRequest.Attributes["src"] = "../Legacy/SecWeb/q_printreq.asp?SID=" + _SID;
        this.framePrintRequest.Attributes["width"] = "100%";
        this.framePrintRequest.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.framePrintRequest.Attributes["frameborder"] = "0";
        this.framePrintRequest.Attributes["scrolling"] = "no";  
    }
}
