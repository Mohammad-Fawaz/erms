using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AddSubMenu : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (!Page.IsPostBack)
            {
                int A = Convert.ToInt16(Session["ProfileID"]);
                int B = Convert.ToInt16(Session["_ProfileId"]);

                BinddropdownMainModules();
                BindGridview();
                BindRole();
            }
            
            //DataTable _gridDisplay = new DataTable();
            //_gridDisplay.Columns.Add("PageName", Type.GetType("System.String"));
            //_gridDisplay.Merge(DataAccess.GetRecords(DataQueries.GetAppPagesList()), true);
            //this.GridView1.DataSource = _gridDisplay;
            //this.GridView1.DataBind();
            //this.CheckboxList1.DataSource = _tempDispType;

            //this.CheckboxList1.DataTextField = "ProfileDesc";
            //this.CheckboxList1.DataValueField = "ProfileDesc";
            //this.CheckboxList1.DataBind();
        }
        catch (Exception ex)
        {

            throw;
            Response.Write(ex);
        }

    }

    //protected void itemSelected(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        //DataTable tempDispType = new DataTable();
    //        //tempDispType.Columns.Add("ProfileID", Type.GetType("System.String"));
    //        //tempDispType.Columns.Add("ProfileDesc", Type.GetType("System.String"));
    //        //tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetAppProfile()), true);
    //        //this.GridView1.DataSource = tempDispType;
    //        //this.GridView1.DataBind();
    //        //using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetPages()))
    //        //{

    //        //    this.GridView1.DataSource = _PagesGrid;
    //        //    this.GridView1.DataBind();

    //        //}
    //    }
    //    catch (Exception ex)
    //    {

    //        throw;
    //    }


    //}
    public void BindGridview()
    {
        Int32 submenuid = Convert.ToInt32(Request.QueryString["SubMenuId"]);
        DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList(submenuid));
        using (DataTable submenugrid = DataAccess.GetRecords(DataQueries.getSubenu(submenuid)))
        {
            if(submenugrid.Rows.Count>0)
            { 

            this.grdv_SubMenu.DataSource = submenugrid;
            this.grdv_SubMenu.DataBind();
            }

        }

    }
    public void BindRole()
    {
        DataTable _tempDispType = new DataTable();
        _tempDispType.Columns.Add("ProfileID", Type.GetType("System.String"));
        _tempDispType.Columns.Add("ProfileDesc", Type.GetType("System.String"));
        _tempDispType.Rows.Add("", "-Select Profile-");
        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetAppProfile()), true);
        //this.AppSecProfile.DataSource = _tempDispType;
        //this.AppSecProfile.DataTextField = "ProfileDesc";
        //this.AppSecProfile.DataValueField = "ProfileID";
        //this.AppSecProfile.DataBind();
    }
    public void BinddropdownMainModules()
    {
        DataTable _tempDispType = new DataTable();
        //_tempDispType.Columns.Add("ID", Type.GetType("System.String"));
        //_tempDispType.Columns.Add("PageName", Type.GetType("System.String"));
        //_tempDispType.Rows.Add("0", "-Select Profile-");
        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetAllPagesWherePageIdiSnOTnULL()), true);
        this.ddl_Main_Modules.DataSource = _tempDispType;
        this.ddl_Main_Modules.DataTextField = "PageName";
        this.ddl_Main_Modules.DataValueField = "ID";
        this.ddl_Main_Modules.DataBind();
    
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        
        //String Val = AppSecProfile.SelectedItem.Value;
      
            int MainMenuId = Convert.ToInt32(Request.QueryString["SubMenuId"]);
            int SubModuleId = Convert.ToInt32(Request.QueryString["SubMenuId"]);
        string SubMenuName = txtbox_AddRole.Text.Trim();
        //DataAccess.ModifyRecords(DataQueries.DeleteFromRolePages(RoleID));
        if(SubMenuName!="")
        {
            DataAccess.ModifyRecords(DataQueries.InsertSubMenu(SubMenuName, MainMenuId, SubModuleId));
            //DataAccess.ModifyRecords(DataQueries.InsertSubMenu(SubMenuName, MainMenuId, SubModuleId));
            lblStatus.Text = "Save Succesfully";
            BindGridview();
        }
        else
        {
            lblStatus.Text = "Enter Text";
            lblStatus.ForeColor = System.Drawing.Color.Red;
        }
        
        



    }

    //[WebMethod]
    //public DataTable getDBInfo(int param)
    //{
    //    using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.getPageIdByRoleId(param)))
    //    {


    //        return _PagesGrid;

    //    }

    //}

    protected void ddl_Main_Modules_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGridview();
    }

    protected void btn_AddRole_Click(object sender, EventArgs e)
    {
        
        //if(txtbox_AddRole.Text!="")
        //{
        //    DataAccess.ModifyRecords(DataQueries.AddRole(txtbox_AddRole.Text.Trim()));
        //    BindRole();
        //}
        //else
        //{
        //    lblStatus.Text = "Enter Role";
        //    lblStatus.ForeColor = System.Drawing.Color.Red;
        //}
    }
}
