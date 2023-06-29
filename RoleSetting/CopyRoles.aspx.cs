using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CopyRoles : System.Web.UI.Page
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
        this.ddl_ToRole.DataSource = _tempDispType;
        this.ddl_ToRole.DataTextField = "ProfileDesc";
        this.ddl_ToRole.DataValueField = "ProfileID";
        this.ddl_ToRole.DataBind();
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
            
            int FromRoleID = Int32.Parse(AppSecProfile.SelectedValue.ToString());
           int toRoleid= Int32.Parse(ddl_ToRole.SelectedValue.ToString());
            if (FromRoleID!= toRoleid)
            { 
                DataAccess.ModifyRecords(DataQueries.DeletePreviousRights(toRoleid));
                 DataAccess.ModifyRecords(DataQueries.CopyRolesRights(FromRoleID, toRoleid));

                DataAccess.ModifyRecords(DataQueries.DeletePreviousAssignFields(toRoleid));
                DataAccess.ModifyRecords(DataQueries.CopyAssignFields(FromRoleID, toRoleid));

                DataAccess.ModifyRecords(DataQueries.deleteDropDownRights(toRoleid));
                DataAccess.ModifyRecords(DataQueries.CopyDropdownFields(FromRoleID, toRoleid));

                lblStatus.Text = "Succesfully Transfer";
            }
            else
            {
                lblStatus.Text = "Same Roles in DropDowns";
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

    

    
  



}
