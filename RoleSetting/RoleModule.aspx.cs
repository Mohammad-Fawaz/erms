using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class RoleSetting_RoleModule : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;
            if (!Page.IsPostBack)
            {

                hfd_allcheck.Value = "True";
                int A = Convert.ToInt16(Session["ProfileID"]);
                int B = Convert.ToInt16(Session["_ProfileId"]);
                BindRole();
                BinddropdownMainModules();
              
                BindGridview();
                
            }
         
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

        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        //int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());
        Int32 Main_ModuleID = Convert.ToInt32(ddl_Main_Modules.SelectedValue);
        int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());

        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.NewGetAppPagesForRoleModuleGrid(Convert.ToInt32(ddl_Main_Modules.SelectedValue), RoleID)))
        {


            this.GridView1.DataSource = _PagesGrid;
            this.GridView1.DataBind();
            SetCheckedItems(); 
        }

    }
    public void BindRole()
    {
        DataTable _tempDispType = new DataTable();
        //_tempDispType.Columns.Add("ProfileID", Type.GetType("System.String"));
        //_tempDispType.Columns.Add("ProfileDesc", Type.GetType("System.String"));
        //_tempDispType.Rows.Add("0", "-Select Profile-");
        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetAppProfile()), true);
        this.AppSecProfile.DataSource = _tempDispType;
        this.AppSecProfile.DataTextField = "ProfileDesc";
        this.AppSecProfile.DataValueField = "ProfileID";
        this.AppSecProfile.DataBind();
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

        string Selected = "";
        String Val = AppSecProfile.SelectedItem.Value;
        if (Val == "")
        {
            lblStatus.Text = "Select DropDown Value";
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
                int Child_ModuleID = Convert.ToInt32(hfd_childId.Value);
                if (cb != null && cb.Checked)
                {
                    
                    DataAccess.ModifyRecords(DataQueries.InsertRolePages(RoleID,Profile_ID, Main_ModuleID,Child_ModuleID));
                }
                else
                {
                    DataAccess.ModifyRecords(DataQueries.deletePageRoles(RoleID, Main_ModuleID, Child_ModuleID));
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
            lblStatus.Text = "Select Role";
            lblStatus.ForeColor = System.Drawing.Color.Red;
        }
    }

    protected void lnkbtn_AddSubChild_Click(object sender, EventArgs e)
    {
            if(AppSecProfile.SelectedValue !="")
        {
            LinkButton btn = sender as LinkButton;
            string a = btn.CommandArgument;
            String _ProfileId = Convert.ToString(Session["_ProfileId"]);
            Response.Redirect("AddSub_RoleModule.aspx?SID=" + _SID + "&SubMenuId=" + a + "&MainMenuId=" + ddl_Main_Modules.SelectedValue + "&ProfileID=" + AppSecProfile.SelectedValue + "");
          
        }
        else
        {
            lblStatus.Text = "Select Role";
            lblStatus.ForeColor = System.Drawing.Color.Red;
        }
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
            int Profile_ID = 12;
           

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
            HiddenField hfdHasChildernMenu = (e.Row.FindControl("hfdHasChildernMenu") as HiddenField);
            LinkButton lnkbtn_AddSubChild = (e.Row.FindControl("lnkbtn_AddSubChild") as LinkButton);
            HiddenField hfd_Checked = (e.Row.FindControl("hfd_Checked") as HiddenField);
            CheckBox chkCheck = (e.Row.FindControl("chkCheck") as CheckBox);
            
            if (hfdHasChildernMenu.Value == "1")
            {
            
                lnkbtn_AddSubChild.Visible = false;
            }
            if (hfd_Checked.Value == "0")
            {
                chkCheck.Checked = true;
            }
            else
            {
                hfd_allcheck.Value = "False";
            }
        }
    }

    protected void AppSecProfile_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGridview();
    }

    protected void GridView1_DataBound(object sender, EventArgs e)
    {

        //CheckBox chkall = (CheckBox)GridView1.row.FindControl("chkCheck");
        //if (hfd_allcheck.Value == "False")
        //{
        //    chkall.Checked = false;
        //}
        //else
        //{
        //    chkall.Checked = true;
        //}
    }
    private void SetCheckedItems()
    {
        Int32 countgridviewRows = GridView1.Rows.Count;

        Int32 countValues=0;
      if(countgridviewRows>0)
        { 
            CheckBox chkall = (CheckBox)GridView1.HeaderRow.FindControl("chkCheckAll");
            foreach (GridViewRow dgr in GridView1.Rows)
            {
                CheckBox cb = (dgr.FindControl("chkCheck") as CheckBox);
                HiddenField hfd_ID = (HiddenField)dgr.FindControl("hfd_ID");
               if(cb.Checked==true)
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

    }
}
