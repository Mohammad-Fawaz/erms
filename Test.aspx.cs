using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing; 
using System.Data.OleDb;

enum SType
{ 
  TYPE_DOCUMENT, 
  TYPE_CHANGE,
  TYPE_ORDERS, 
  TYPE_PARTS, 
  TYPE_PROJECTS, 
  TYPE_TASKS
};

public partial class _Default : System.Web.UI.Page 
{       
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            this.gvSearchResults.Width = 900;
            this.gvSearchResults.HeaderStyle.BackColor = Color.LightSteelBlue;
            this.gvSearchResults.HeaderStyle.ForeColor = Color.Black;
            this.gvSearchResults.HeaderStyle.VerticalAlign = VerticalAlign.Middle;
            this.gvSearchResults.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            this.gvSearchResults.HeaderStyle.Wrap = true;

            this.gvSearchResults.RowStyle.Wrap = false;
            this.gvSearchResults.RowStyle.HorizontalAlign = HorizontalAlign.Center;
            this.gvSearchResults.RowStyle.VerticalAlign = VerticalAlign.Middle;

            this.gvSearchResults.PageSize = 10;

            if (!Page.IsPostBack)
            {
                ddlStatus_Populate();
            }
        }
        catch (Exception ex)
        {            
            Console.WriteLine(ex.Message);
        }
        finally
        {
 
        }
    }
        
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            this.gvSearchResults.DataSource = GetRecords(gvSearchResults_GetQueryText());
            this.gvSearchResults.DataBind();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }
    }

    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            ddlStatus_Populate();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }
    }

    protected void gvSearchResults_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[0].ToString().Trim() != "")
                {
                    HtmlAnchor hlnk = new HtmlAnchor();
                    hlnk.HRef = "../ERMS/GetDocumentInfo.aspx";
                    hlnk.InnerHtml = e.Row.Cells[0].Text.ToString();
                    e.Row.Cells[0].Controls.Add(hlnk);
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }
    }

    protected void gvSearchResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            this.gvSearchResults.DataSource = GetRecords(gvSearchResults_GetQueryText());
            this.gvSearchResults.PageIndex = e.NewPageIndex;
            this.gvSearchResults.DataBind();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }
    }

















    public void ddlStatus_Populate()
    {
        try
        {
            this.ddlStatus.DataSource = GetRecords(ddlStatus_GetQueryText());
            this.ddlStatus.DataTextField = "Status";
            this.ddlStatus.DataValueField = "Status";
            this.ddlStatus.DataBind();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }
    }

    public  DataTable GetRecords(string queryText)
    {
        DataTable dtResultSet = new DataTable();

        try
        {
            string _connectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\\inetpub\\wwwroot\\Database\\erms42P.mdb"; //Server.MapPath("test.mdb")
            
            using (OleDbConnection conResultSet = new OleDbConnection(_connectionString))
            {
                using (OleDbCommand cmdResultSet = new OleDbCommand(queryText, conResultSet))
                {
                    conResultSet.Open();

                    using (OleDbDataReader drResultSet = cmdResultSet.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        dtResultSet.Load(drResultSet);                        
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }

        return dtResultSet;
    }







    public string ddlStatus_GetQueryText()
    {
        string _querySelect = null;

        try
        {
            int _typeSelected = Convert.ToInt32(this.ddlType.SelectedItem.Value);

            switch (_typeSelected)
            {
                case 0: //Documents
                    _querySelect = " SELECT DISTINCT STATUS FROM ViewDocs " +
                                   " WHERE STATUS IS NOT NULL";
                    break;
                case 1: //Change
                    _querySelect = " SELECT DISTINCT STATUS FROM ViewChanges " +
                                   " WHERE STATUS IS NOT NULL";
                    break;
                case 2: //Orders
                    _querySelect = " SELECT DISTINCT STATUS FROM ViewOrders " +
                                   " WHERE STATUS IS NOT NULL";
                    break;
                case 3: //Parts
                    _querySelect = " SELECT DISTINCT RSTATUS AS STATUS FROM ViewParts " +
                                   " WHERE RSTATUS IS NOT NULL";
                    break;
                case 4: //Projects
                    _querySelect = " SELECT DISTINCT STATUS FROM ViewProjects " +
                                   " WHERE STATUS IS NOT NULL";
                    break;
                case 5: //Tasks
                    _querySelect = " SELECT DISTINCT STATUS FROM ViewTasks " +
                                   " WHERE STATUS IS NOT NULL";
                    break;
                default:
                    _querySelect = null;
                    break;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }

        return _querySelect;
    }




    public string gvSearchResults_GetQueryText()
    {       
        string _querySelect = null;

        try
        {
            int _typeSelected = Convert.ToInt32(this.ddlType.SelectedItem.Value);
            string _statusSelected = this.ddlStatus.SelectedItem.Value.Trim();
            string _ID = this.txtID.Text.Trim();

            switch (_typeSelected)
            {
                case 0: //Documents
                    if (_ID.Length == 0)
                    {
                        _querySelect = " SELECT DocID as ID, CurrentRev as Revision, DocType as Type, " +
                                              " DType as Type_Description, DocDesc as Description, DocReqBy as Requested_By, " +
                                              " DocReqDate as Requested_Date " +
                                       " FROM ViewDocs " +
                                       " WHERE Status = " + "\"" + _statusSelected + "\"";

                    }
                    else
                    {
                        _querySelect = " SELECT DocID as ID, CurrentRev as Revision, DocType as Type, " +
                                              " DType as Type_Description, DocDesc as Description, DocReqBy as Requested_By, " +
                                              " DocReqDate as Requested_Date " +
                                       " FROM ViewDocs " +
                                       " WHERE DocID LIKE '%" + _ID + "%'" +
                                             " AND Status = " + "\"" + _statusSelected + "\"";
                    }
                    break;
                case 1: //Change
                    if (_ID.Length == 0)
                    {
                        _querySelect = " SELECT * FROM ViewChanges WHERE Status = " + "\"" + _statusSelected + "\"";
                    }
                    else
                    {
                        _querySelect = " SELECT * FROM ViewChanges  WHERE CO LIKE '%" + _ID + "%'";
                    }
                    break;
                case 2: //Orders
                    if (_ID.Length == 0)
                    {
                        _querySelect = " SELECT * FROM ViewOrders WHERE Status = " + "\"" + _statusSelected + "\"";
                    }
                    else
                    {
                        _querySelect = " SELECT * FROM ViewOrders WHERE OrderNum LIKE '%" + _ID + "%'";
                    }
                    break;
                case 3: //Parts
                    if (_ID.Length == 0)
                    {
                        _querySelect = " SELECT * FROM ViewParts WHERE RStatus = " + "\"" + _statusSelected + "\"";
                    }
                    else
                    {
                        _querySelect = " SELECT * FROM ViewParts WHERE PartNo LIKE '%" + _ID + "%'";
                    }
                    break;
                case 4: //Projects
                    if (_ID.Length == 0)
                    {
                        _querySelect = " SELECT * FROM ViewProjects WHERE Status = " + "\"" + _statusSelected + "\"";
                    }
                    else
                    {
                        _querySelect = " SELECT * FROM ViewProjects WHERE ProjNum LIKE '%" + _ID + "%'";
                    }
                    break;
                case 5: //Tasks
                    if (_ID.Length == 0)
                    {
                        _querySelect = " SELECT * FROM ViewTasks WHERE Status = " + "\"" + _statusSelected + "\"";
                    }
                    else
                    {
                        _querySelect = " SELECT * FROM ViewTasks WHERE TaskID LIKE '%" + _ID + "%'";
                    }
                    break;
                default:
                    _querySelect = null;
                    break;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {

        }

        return _querySelect;  
    }
    


}
