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

public partial class ContactInfo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String _SID = this.Master.SID;
        
       // this.frameContactInfo.Attributes["src"] = "http://localhost:3696/Legacy/secweb/ret_selitem.asp?SID=" + _SID;
        this.frameContactInfo.Attributes["src"] = "../Legacy/SecWeb/supp_contact.asp?SID=" + _SID;
        this.frameContactInfo.Attributes["width"] = "100%";
        this.frameContactInfo.Attributes.Add("onload", "return AdjustFrameHeight(this);"); //Set Dynamic Height
        this.frameContactInfo.Attributes["frameborder"] = "0";
        this.frameContactInfo.Attributes["scrolling"] = "no";  
    }
}



