using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;

public partial class DatabaseSetting_DBSetting : System.Web.UI.Page
{
    string testDBPath = System.Configuration.ConfigurationManager.AppSettings["TestDBPath"];
    string prodDBPath = System.Configuration.ConfigurationManager.AppSettings["ProdDBPath"];

    #region "Current DB"
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string isProdDB = Utils.GetIsProdDBValue();
            if (isProdDB == "true")
                chkIsProd.Checked = true;
            else
                chkIsProd.Checked = false;

        }
    }
    protected void chkIsProd_CheckedChanged(object sender, EventArgs e)
    {
        string isProdDB = chkIsProd.Checked.ToString().ToLower();
        Response.Cookies["isProdDB"].Value = isProdDB;
        Session.Abandon();
        Response.Redirect("~/Login.aspx");
    }
    #endregion

    #region "Select Database"
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string server = rblServer.SelectedValue;
        string path = string.Empty;
        if(server == "test")
            path = testDBPath;
        else
            path = prodDBPath;

        if (fuDatabase.HasFile)
        {
            Utils.DeleteFilesFromDirectory(Server.MapPath(path));
            fuDatabase.SaveAs(Server.MapPath(path + fuDatabase.FileName));
            lblMessage.Text = "Upload Successfully.";
            lblMessage.Visible = true; 
        }
    }

    protected void lbtnDownload_Click(object sender, EventArgs e)
    {
        string server = rblServer.SelectedValue;
        string path = string.Empty;
        if (server == "test")
            path = testDBPath;
        else
            path = prodDBPath;

        string[] files = Directory.GetFiles(Server.MapPath(path));
        if (files.Length > 0)
        {
            string fileName = Path.GetFileName(files.FirstOrDefault());
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName + "");
            Response.TransmitFile(Server.MapPath(path + fileName));
            Response.End();
        }
    }
    #endregion
}