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

public partial class QSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;

        this.frameQSearch.Attributes["src"] = "Legacy/SecWeb/view_qsearch.asp?SID=" + _SID;
        this.frameQSearch.Attributes["width"] = "100%";
        this.frameQSearch.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameQSearch.Attributes["frameborder"] = "0";
        this.frameQSearch.Attributes["scrolling"] = "no";  
    }
}
