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

public partial class Actions_AppLaunch : System.Web.UI.Page
{    
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;
        this.hdnVBAppPath.Value = ConfigurationManager.AppSettings["VBAppPath"];       
        this.frameAppLaunch.Attributes["width"] = "100%";
        this.frameAppLaunch.Attributes.Add("onload", "return launchApp();");
        this.frameAppLaunch.Attributes["frameborder"] = "0";
        this.frameAppLaunch.Attributes["scrolling"] = "no";         
    }
}
