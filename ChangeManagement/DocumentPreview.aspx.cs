using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DocumentManagement_DocumentPreview : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.QueryString["file"] != null)
            {
                var _fPath = Request.QueryString["file"].ToString();
                if (_fPath.Contains(":"))
                {
                    _fPath = _fPath.Split(':')[1].ToString();
                }
                var fileBytes = File.ReadAllBytes(_fPath);
                string result = Convert.ToBase64String(fileBytes);

                string pdfSrc = "data:application/pdf;base64, " + result + " #toolbar=0";
                MyIframe.Attributes["Src"] = pdfSrc;
            }
        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
        }

    }
}