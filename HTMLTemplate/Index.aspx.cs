using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class HTMLTemplate_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindGridview();
            BindRequestNames();
            SubRequestType();
        }
    }
    public void BindGridview()
    {
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetHtmlTemplates()))
        {
            this.gvHtmlTemplate.DataSource = _PagesGrid;
            this.gvHtmlTemplate.DataBind();
        }
    }

    public void ClearForm()
    {
        txtTemplateName.Text = string.Empty;
        drpRequestPage.Visible = true;
        txtPageName.Visible = false;
        txtPageName.Text = string.Empty;
        txtTemplateData.Text = string.Empty;
        btn_UpdateTempalte.Visible = false;
        btn_AddTempalte.Visible = true;
        txtRequestType.Visible = false;
        txtRequestType.Text = string.Empty;

    }
    public void BindRequestNames()
    {
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetRequestChildData()))
        {
            this.drpRequestPage.DataSource = _PagesGrid;
            this.drpRequestPage.DataTextField = "PageName";
            this.drpRequestPage.DataValueField = "PageId";
            this.drpRequestPage.DataBind();
        }
    }

    public void BindSubRequestType(string OptType)
    {
        using (DataTable _tempChangeType = new DataTable())
        {
            _tempChangeType.Columns.Add("Code", Type.GetType("System.String"));
            _tempChangeType.Columns.Add("Description", Type.GetType("System.String"));
            _tempChangeType.Rows.Add("-NONE-", "-NONE-");
            _tempChangeType.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByTypeForSubRequest(OptType)), true);
            this.ddlRequestType.DataSource = _tempChangeType;
            this.ddlRequestType.DataTextField = "Description";
            this.ddlRequestType.DataValueField = "Code";
            this.ddlRequestType.DataBind();
        }
    }

    protected void btn_Add_Template_Click(object sender, EventArgs e)
    {
        if (drpRequestPage.SelectedIndex < 0)
        {
            lblStatus.Text = "Please select page";
            lblStatus.ForeColor = System.Drawing.Color.Green;
        }
        else
        {
            var asd = this.txtTemplateData.Text;
            var requestType = ddlRequestType.SelectedValue.Split('|');
            DataAccess.ModifyRecords(DataQueries.AddTemplate(txtTemplateName.Text.Trim(), txtTemplateData.Text, Convert.ToInt32(drpRequestPage.SelectedValue), requestType[0], requestType[1]));
            lblStatus.Text = "Succesfully Save";
            lblStatus.ForeColor = System.Drawing.Color.Green;
            BindGridview();
            BindRequestNames();
            SubRequestType();
            ClearForm();
        }
    }

    protected void btn_Update_Template_Click(object sender, EventArgs e)
    {
        DataAccess.ModifyRecords(DataQueries.UpdateTemplate(txtTemplateName.Text.Trim(), txtTemplateData.Text, Convert.ToInt32(hdnTemplateId.Value)));
        lblStatus.Text = "Succesfully Save";
        lblStatus.ForeColor = System.Drawing.Color.Green;
        BindGridview();
        BindRequestNames();
        SubRequestType();
        ClearForm();
    }
    protected void lnkbtn_Edit_Click(object sender, CommandEventArgs e)
    {
        string[] args = e.CommandArgument.ToString().Split(',');
        hdnTemplateId.Value = args[0];

        var recordTable = DataAccess.GetRecords(DataQueries.GetHtmlTemplates(Convert.ToInt32(args[0])));
        if (recordTable.Rows.Count > 0)
        {
            var data = recordTable.Rows[0];
            txtTemplateName.Text = data.Field<string>("Name");
            drpRequestPage.Visible = false;
            txtPageName.Visible = true;
            txtPageName.Text = data.Field<string>("PageName");
            txtTemplateData.Text = data.Field<string>("TemplateData");
            btn_UpdateTempalte.Visible = true;
            btn_AddTempalte.Visible = false;
            ddlRequestType.Visible = false;
            txtRequestType.Visible = true;
            txtRequestType.Text = data.Field<string>("Description");
        }

    }
    protected void lnkbtn_Delete_Click(object sender, CommandEventArgs e)
    {
        string[] args = e.CommandArgument.ToString().Split(',');
        DataAccess.ModifyRecords(DataQueries.DeleteTemplate(Convert.ToInt32(args[0])));
        BindGridview();
        BindRequestNames();
        SubRequestType();
    }

    protected void MainRequstChange(object sender, EventArgs e)
    {
        SubRequestType();
    }

    public void SubRequestType()
    {
        string requestPage = drpRequestPage.SelectedItem.Text.ToLower();
        string OptType = "";
        if (requestPage == "changes")
        {
            OptType = "ChangeType";
            BindSubRequestType(OptType);
            ddlRequestType.Visible = true;
            lblRequestType.Visible = true;
        }
        else
        {
            ddlRequestType.Visible = false;
            lblRequestType.Visible = false;
        }
    }
    //    {
    //        case "changes":
    //            OptType = "ChangeType";
    //            BindSubRequestType(OptType);
    //            break;
    //        case "helpdesk tickets":
    //            OptType = "ChangeType";
    //            break;
    //        case "projects":
    //            OptType = "ChangeType";
    //            break;
    //        case "tasks":
    //            DataTable _tempTaskType = new DataTable();
    //            _tempTaskType.Columns.Add("Code", Type.GetType("System.String"));
    //            _tempTaskType.Columns.Add("Description", Type.GetType("System.String"));
    //            _tempTaskType.Rows.Add("-NONE-", "-NONE-");
    //            _tempTaskType.Merge(DataAccess.GetRecords(DataQueries.GetStdTasks()), true);
    //            this.ddlRequestType.DataSource = _tempTaskType;
    //            this.ddlRequestType.DataTextField = "Description";
    //            this.ddlRequestType.DataValueField = "Code";
    //            this.ddlRequestType.DataBind();

    //            break;
    //        case "document":
    //            OptType = "DocType";
    //            break;
    //        default: break;
    //    }


    //}
}