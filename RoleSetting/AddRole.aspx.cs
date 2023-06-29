using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AddRole : System.Web.UI.Page
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
              
              
                BindGridview();
                
            }
         
        }
        catch (Exception ex)
        {

            throw;
            Response.Write(ex);
        }

    }

  
    //}
    public void BindGridview()
    {

        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        //int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());
        //Int32 Main_ModuleID = Convert.ToInt32(ddl_Main_Modules.SelectedValue);
        int RoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());

        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.SelectAllRolesForGridview(Convert.ToInt32(AppSecProfile.SelectedValue))))
        {


            this.GridView1.DataSource = _PagesGrid;
            this.GridView1.DataBind();
            //SetCheckedItems();
        }

    }
    public void BindRole()
    {
        DataTable _tempDispType = new DataTable();
        //_tempDispType.Columns.Add("RoleID", Type.GetType("System.String"));
        //_tempDispType.Columns.Add("RoleName", Type.GetType("System.String"));
        //_tempDispType.Rows.Add("0", "-Select Profile-");
        _tempDispType.Merge(DataAccess.GetRecords(DataQueries.GetAllRoles()), true);
        this.AppSecProfile.DataSource = _tempDispType;
        this.AppSecProfile.DataTextField = "ProfileDesc";
        this.AppSecProfile.DataValueField = "ProfileId";
        this.AppSecProfile.DataBind();
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
            //int Main_ModuleID = Int32.Parse(ddl_Main_Modules.SelectedValue.ToString());
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
                    
                  //  DataAccess.ModifyRecords(DataQueries.InsertRolePages(RoleID,Profile_ID, Main_ModuleID,Child_ModuleID));
                }
                else
                {
                   // DataAccess.ModifyRecords(DataQueries.deletePageRoles(RoleID, Main_ModuleID, Child_ModuleID));
                }
            }
           

        }
    }


   

    protected void btn_AddRole_Click(object sender, EventArgs e)
    {
        if(txtbox_AddRole.Text!="")
        {
            //DataAccess.ModifyRecords(DataQueries.AddRoles(txtbox_AddRole.Text.Trim(), txtbox_Desc.Text.Trim()));
            DataTable dt = DataAccess.GetRecords(DataQueries.checkexistingRoles(txtbox_AddRole.Text.Trim()));
            if (dt.Rows.Count != 1)
            {
                DataAccess.ModifyRecords(DataQueries.AddRoles(txtbox_AddRole.Text.Trim()));
                lblStatus.Text = "Succesfully Save";
                lblStatus.ForeColor = System.Drawing.Color.Green;
                BindGridview();
            }
            else
            {
                lblStatus.Text = "Already Exist";
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
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
        //    if(AppSecProfile.SelectedValue !="" )
        //{
        GridViewRow clickedRow = ((LinkButton)sender).NamingContainer as GridViewRow;
      
        LinkButton btn = sender as LinkButton;
            string RoleId = btn.CommandArgument;
            String RoleName = btn.ToolTip;
            txtbox_AddRole.Text = RoleName;
        Hfd_Roleid.Value = RoleId;


          String _ProfileId = Convert.ToString(Session["_ProfileId"]);
              btn_update.Visible = true;
              btn_AddRole.Visible = false;
        
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
           // Int32 Main_ModuleID = Convert.ToInt32(ddl_Main_Modules.SelectedValue);
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
                    //DataAccess.ModifyRecords(DataQueries.deletePageRoles(RoleID, Main_ModuleID, Child_ModuleID));
                    //lblStatus.Text = "Sccesfully Delete";
                    //lblStatus.ForeColor = System.Drawing.Color.Green;
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
        //    HiddenField hfd_Checked = (e.Row.FindControl("hfd_Checked") as HiddenField);
        //    CheckBox chkCheck = (e.Row.FindControl("chkCheck") as CheckBox);
            
        //    if (hfdHasChildernMenu.Value == "1")
        //    {
            
        //        lnkbtn_AddSubChild.Visible = false;
        //    }
        //    if (hfd_Checked.Value == "0")
        //    {
        //        chkCheck.Checked = true;
        //    }
        //    else
        //    {
        //        hfd_allcheck.Value = "False";
        //    }
        //}
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

    protected void btn_update_Click(object sender, EventArgs e)
    {
        DataAccess.ModifyRecords(DataQueries.UpdateRoles(txtbox_AddRole.Text.Trim(), Convert.ToInt32(Hfd_Roleid.Value)));
        btn_AddRole.Visible = true;
        btn_update.Visible = false;
        lblStatus.Text = "Succesfully Update";
        txtbox_AddRole.Text = "";
      
        lblStatus.ForeColor = System.Drawing.Color.Green;
        BindGridview();
    }

    protected void lnkbtn_dltRole_Click(object sender, EventArgs e)
    {
        GridViewRow clickedRow = ((LinkButton)sender).NamingContainer as GridViewRow;

        LinkButton btn = sender as LinkButton;
        string RoleId = btn.CommandArgument;
        Hfd_Roleid.Value = RoleId;
        DataAccess.ModifyRecords(DataQueries.DeleteRoles(Convert.ToInt32(Hfd_Roleid.Value)));
        btn_AddRole.Visible = true;
        btn_update.Visible = false;
        lblStatus.Text = "Succesfully Deleted";
        lblStatus.ForeColor = System.Drawing.Color.Green;
        txtbox_AddRole.Text = "";
        BindGridview();
    }
}
