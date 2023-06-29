using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class RoleSetting_DataViewt : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindMenu();
        }
    }
    public void BindMenu()
    {
        DataTable _tempDispType = DataAccess.GetRecords(DataQueries.GetAllPagesWherePageIdiSnOTnULL());


        dlcategory.DataSource = _tempDispType;
        dlcategory.DataBind();
    }

    //protected void dlcategory_ItemDataBound(object sender, DataListItemEventArgs e)
    //{
       
    //    int id = Convert.ToInt32(dlcategory.DataKeys[e.Item.ItemIndex].ToString());

    //    DataTable _tempLogin = DataAccess.GetRecords(DataQueries.getPageIdByRoleId(id));

    //     DataList dlsubcat = (DataList)e.Item.FindControl("dlsubcategory");
    //    dlsubcat.DataSource = _tempLogin;
    //    dlsubcat.DataBind();
    //}
}