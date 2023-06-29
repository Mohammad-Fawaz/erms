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

public partial class MyReportsResults : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        String _ReportID = Request.QueryString["RepID"];

        this.frameMyReportsResults.Attributes["src"] = "Legacy/SecWeb/ret_search.asp?SID=" + _SID + "&RepID=" + _ReportID;
        this.frameMyReportsResults.Attributes["width"] = "100%";
        this.frameMyReportsResults.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameMyReportsResults.Attributes["frameborder"] = "0";
        this.frameMyReportsResults.Attributes["scrolling"] = "no";  
    }
}
