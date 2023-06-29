using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AddSub_RoleModule : System.Web.UI.Page
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
        Int32 SubMenuId =Convert.ToInt32( Request.QueryString["SubMenuId"]);
        Int32 ProfileID= Convert.ToInt32(Request.QueryString["ProfileID"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.getsubmenu(SubMenuId, ProfileID)))
        {


            this.GridView1.DataSource = _PagesGrid;
            this.GridView1.DataBind();
            SetCheckedItems();
        }

    }
    private void SetCheckedItems()
    {
        Int32 countgridviewRows = GridView1.Rows.Count;

        Int32 countValues = 0;

        CheckBox chkall = (CheckBox)GridView1.HeaderRow.FindControl("chkCheckAll");
        foreach (GridViewRow dgr in GridView1.Rows)
        {
            CheckBox cb = (dgr.FindControl("chkCheck") as CheckBox);
            HiddenField hfd_ID = (HiddenField)dgr.FindControl("hfd_ID");
            if (cb.Checked == true)
            {
                countValues = countValues + 1;
            }

        }
        //}

        if (GridView1.Rows.Count == countValues)
        {
            chkall.Checked = true;
        }


    }
    public void BindRole()
    {
        int A = Convert.ToInt16(Request.QueryString["ProfileID"]);
        DataTable _tempDispType = new DataTable();

        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetAppProfileForSubMenu(A)), true);
        this.AppSecProfile.DataSource = _tempDispType;
        this.AppSecProfile.DataTextField = "ProfileDesc";
        this.AppSecProfile.DataValueField = "ProfileID";
        this.AppSecProfile.DataBind();
        AppSecProfile.Enabled = false;
    }
    public void BinddropdownMainModules()
    {
        DataTable _tempDispType = new DataTable();
        //_tempDispType.Columns.Add("ID", Type.GetType("System.String"));
        //_tempDispType.Columns.Add("PageName", Type.GetType("System.String"));
        //_tempDispType.Rows.Add("0", "-Select Profile-");
        Int32 ID = Convert.ToInt32(Request.QueryString["SubMenuId"]);
        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetAllPagesWherePageIdiSnOTnULLForSubMenu(ID)), true);
        this.ddl_Main_Modules.DataSource = _tempDispType;
        this.ddl_Main_Modules.DataTextField = "PageName";
        this.ddl_Main_Modules.DataValueField = "ID";
        this.ddl_Main_Modules.DataBind();
        ddl_Main_Modules.Enabled = false;


    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        string Selected = "";
        String Val = AppSecProfile.SelectedItem.Value;
        if (Val == "")
        {
            lblStatus.Text = "Select DropDown Value";
            lblStatus.ForeColor = System.Drawing.Color.Red;
        }
        else
        {
            int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());
            int Main_ModuleID = Int32.Parse(ddl_Main_Modules.SelectedValue.ToString());
            int Profile_ID = 12;
            //DataAccess.ModifyRecords(DataQueries.DeleteFromRolePages(RoleID));
            foreach (GridViewRow gr in GridView1.Rows)
            {
                

                //CheckBox cb = (CheckBox)gr.FindControl("chkCheck");
                CheckBox cb = (gr.Cells[3].FindControl("chkCheck") as CheckBox);
                //Label Child_ModuleID = (Label)gr.FindControl("Label1");
                HiddenField hfd_childId= (HiddenField)gr.FindControl("hfd_childId");
                // You can get other value same way               

                if (cb != null && cb.Checked)
                {
                    int Child_ModuleID = Convert.ToInt32(hfd_childId.Value);
                    DataAccess.ModifyRecords(DataQueries.InsertRolePages(RoleID,Profile_ID, Main_ModuleID,Child_ModuleID));
                } 
            }

          
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
        if(txtbox_AddRole.Text!="")
        {
            DataAccess.ModifyRecords(DataQueries.AddRole(txtbox_AddRole.Text.Trim()));
            BindRole();
        }
        else
        {
            lblStatus.Text = "Enter Role";
            lblStatus.ForeColor = System.Drawing.Color.Red;
        }
    }

    protected void lnkbtn_AddSubChild_Click(object sender, EventArgs e)
    {
        LinkButton btn = sender as LinkButton;
        string a = btn.CommandArgument;
        Response.Redirect("AddSubMenu.aspx?SubMenuId="+a+"&MainMenuId="+ddl_Main_Modules.SelectedValue+"");

    }

    protected void btn_dlt_Click(object sender, EventArgs e)
    {
        string Selected = "";
        String Val = AppSecProfile.SelectedItem.Value;
        if (Val == "")
        {
            lblStatus.Text = "Select DropDown Value";
            lblStatus.ForeColor = System.Drawing.Color.Red;
        }
        else
        {
            int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());
            Int32 Main_ModuleID = Convert.ToInt32(ddl_Main_Modules.SelectedValue);
          

            foreach (GridViewRow gr in GridView1.Rows)
            {


                //CheckBox cb = (CheckBox)gr.FindControl("chkCheck");
                CheckBox cb = (gr.Cells[3].FindControl("chkCheck") as CheckBox);
                //Label Child_ModuleID = (Label)gr.FindControl("Label1");
                HiddenField hfd_childId = (HiddenField)gr.FindControl("hfd_childId");
                // You can get other value same way               

                if (cb != null && cb.Checked)
                {
                    int Child_ModuleID = Convert.ToInt32(hfd_childId.Value);
                    DataAccess.ModifyRecords(DataQueries.deletePageRoles(RoleID, Main_ModuleID, Child_ModuleID));
                    lblStatus.Text = "Sccesfully Delete";
                    lblStatus.ForeColor = System.Drawing.Color.Green;
                }
            }
        }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HiddenField hfd_Checked = (e.Row.FindControl("hfd_Checked") as HiddenField);
            CheckBox chkCheck = (e.Row.FindControl("chkCheck") as CheckBox);
            if (hfd_Checked.Value == "0")
            {
                chkCheck.Checked = true;
            }
        }
    }

    protected void btn_BackMainPage_Click(object sender, EventArgs e)
    {
        Response.Redirect("RoleModule.aspx?SID=" + Request.QueryString["SID"]);
    }
}
