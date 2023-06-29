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

public partial class AdvanceSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        //comment test

        this.frameAdvanceSearch.Attributes["src"] = "Legacy/SecWeb/view_syssearch.asp?SID=" + _SID;
        this.frameAdvanceSearch.Attributes["width"] = "100%";
        this.frameAdvanceSearch.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameAdvanceSearch.Attributes["frameborder"] = "0";
        this.frameAdvanceSearch.Attributes["scrolling"] = "no";  
    }
}
