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

public partial class Custom_ElementsWafer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameEW.Attributes["src"] = "../Legacy/SecWeb/view_element_wafer.asp?SID=" + _SID;
        this.frameEW.Attributes["width"] = "100%";
        this.frameEW.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameEW.Attributes["frameborder"] = "0";
        this.frameEW.Attributes["scrolling"] = "no";  
    }
}
