using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AssignUserRights : System.Web.UI.Page
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
                BindAAssignPages();
                BindRole();
                BindGridview();
                SetCheckedItems();


            }
            
          
        }
        catch (Exception ex)
        {

            throw;
            Response.Write(ex);
        }

    }

  
    public void BindGridview()
    {

        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        int PageId = 0;
        if(ddl_SubModules.Items.Count == 0)
        {
            PageId = Convert.ToInt32(ddl_Asssign_Pages.SelectedValue);
        }
        else
        {
            PageId = Convert.ToInt32(ddl_SubModules.SelectedValue);
        }
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAppPagesList(PageId)))
        {


            this.GridView1.DataSource = _PagesGrid;
            this.GridView1.DataBind();

        }

    }

    private void SetCheckedItems()
    {
        int PageId = 0;
        if (ddl_SubModules.Items.Count == 0)
        {
            PageId = Convert.ToInt32(ddl_Asssign_Pages.SelectedValue);
        }
        else
        {
            PageId = Convert.ToInt32(ddl_SubModules.SelectedValue);
        }
        int RoleId =0;
        if (AppSecProfile.SelectedValue != "")
        {
            RoleId = Int32.Parse(AppSecProfile.SelectedValue.ToString());
          }
        DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAssignedFormFieldsData(PageId, RoleId));
        //using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAssignedFormFieldsData(PageId, RoleId)))
        //{
            if (_PagesGrid.Rows.Count > 0) 
            {
            CheckBox chkall = (CheckBox)GridView1.HeaderRow.FindControl("chkCheckAll");
                foreach (GridViewRow dgr in GridView1.Rows)
                {
                    CheckBox cb = (dgr.FindControl("chkCheck") as CheckBox);
                    HiddenField hfd_ID = (HiddenField)dgr.FindControl("hfd_ID");
                    foreach (DataRow dr in _PagesGrid.Rows)
                    {
                        if (dr["ID"].ToString() == hfd_ID.Value)
                        {
                            cb.Checked = true;
                        break;
                        }
                        
                        
                    }
                }
            //}

                if(GridView1.Rows.Count == _PagesGrid.Rows.Count)
            {
                chkall.Checked = true;
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
    public void BindAAssignPages()
    {
        DataTable _tempDispType = new DataTable();
        Int32 pages = Convert.ToInt32(ddl_Main_Modules.SelectedValue);
        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetSubModulePages(pages)), true);
        this.ddl_Asssign_Pages.DataSource = _tempDispType;
        this.ddl_Asssign_Pages.DataTextField = "PageName";
        this.ddl_Asssign_Pages.DataValueField = "ID";
        this.ddl_Asssign_Pages.DataBind();

    }
    public void BindSubModule()
    {
        DataTable _tempDispType = new DataTable();
        
        Int32 pages = Convert.ToInt32(ddl_Asssign_Pages.SelectedValue);
        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetSubModules3level(pages)), true);
        if(_tempDispType.Rows.Count > 0)
        {
            this.ddl_SubModules.DataSource = _tempDispType;
            this.ddl_SubModules.DataTextField = "PageName";
            this.ddl_SubModules.DataValueField = "ID";
            this.ddl_SubModules.DataBind();
            ddl_SubModules.Visible = true;
        }
        else
        {

            this.ddl_SubModules.Items.Clear();
            int count = this.ddl_SubModules.Items.Count;
            //BindGridview();
            ddl_SubModules.Visible = false;
        }
      


    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        int SubModuleId = 0;
        if (ddl_SubModules.Items.Count == 0)
        {
            SubModuleId = Convert.ToInt32(ddl_Asssign_Pages.SelectedValue);
        }
        else
        {
            SubModuleId = Convert.ToInt32(ddl_SubModules.SelectedValue);
        }

       
        String Val = AppSecProfile.SelectedItem.Value;
        if (Val == "")
        {
            lblStatus.Text = "Select DropDown Value";
        }
        else
        {
            int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());

           
            DataAccess.ModifyRecords(DataQueries.DeleteAssignFields(RoleID, SubModuleId));
            foreach (GridViewRow gr in GridView1.Rows)
            {
                

               
                CheckBox cb = (gr.Cells[3].FindControl("chkCheck") as CheckBox);
            
                HiddenField hfd_ID = (HiddenField)gr.FindControl("hfd_ID");
                int FieldId = Convert.ToInt32(hfd_ID.Value);



                if (cb != null && cb.Checked)
                {
                    
                    DataAccess.ModifyRecords(DataQueries.InsertAssignFields(RoleID,SubModuleId, FieldId, 1));
                }
                else
                {
                    //DataAccess.ModifyRecords(DataQueries.DeleteAssignFields(RoleID, SubModuleId, FieldId));
                }
                
            }
           

        }
    }

   

    protected void ddl_Main_Modules_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindAAssignPages();
        BindSubModule();
        BindGridview();
        SetCheckedItems();
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
        String _ProfileId = Convert.ToString(Session["_ProfileId"]);
        Response.Redirect("AddSub_RoleModule.aspx?SubMenuId=" + a+"&MainMenuId="+ddl_Main_Modules.SelectedValue+"&ProfileID="+ _ProfileId + "");

    }

    protected void btn_dlt_Click(object sender, EventArgs e)
    {
        int SubModuleId = 0;
        if (ddl_SubModules.Items.Count == 0)
        {
            SubModuleId = Convert.ToInt32(ddl_Asssign_Pages.SelectedValue);
        }
        else
        {
            SubModuleId = Convert.ToInt32(ddl_SubModules.SelectedValue);
        }
        string Selected = "";
        String Val = AppSecProfile.SelectedItem.Value;
        if (Val == "")
        {
            lblStatus.Text = "Select DropDown Value";
        }
        else
        {
            int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());
            //int SubModuleId = Int32.Parse(ddl_Asssign_Pages.SelectedValue.ToString());
        
            //DataAccess.ModifyRecords(DataQueries.DeleteFromRolePages(RoleID));
            foreach (GridViewRow gr in GridView1.Rows)
            {


             
                CheckBox cb = (gr.Cells[3].FindControl("chkCheck") as CheckBox);
               
                HiddenField hfd_ID = (HiddenField)gr.FindControl("hfd_ID");
                  

                if (cb != null && cb.Checked)
                {
                    int FieldId = Convert.ToInt32(hfd_ID.Value);
                    DataAccess.ModifyRecords(DataQueries.DeleteAssignFields(RoleID, SubModuleId, FieldId));
                }
            }


        }
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    HiddenField hfdHasChildernMenu = (e.Row.FindControl("hfdHasChildernMenu") as HiddenField);
        //    LinkButton lnkbtn_AddSubChild = (e.Row.FindControl("lnkbtn_AddSubChild") as LinkButton);
        //    if (hfdHasChildernMenu.Value == "1")
        //    {
            
        //        lnkbtn_AddSubChild.Visible = false;
        //    }
        //}
    }

    protected void ddl_Asssign_Pages_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubModule();
        BindGridview();
        SetCheckedItems();


    }

    protected void ddl_SubModules_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGridview();
        SetCheckedItems();
    }

    protected void AppSecProfile_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSubModule();
        BindGridview();
        SetCheckedItems();
    }
}
