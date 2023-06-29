using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Control List Class
/// </summary>
public partial class DocumentManagement_Restrictions : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    public String _DOCID;    
     
    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {       
        this.lblStatus.Text = null;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            if (Request.QueryString["DOCID"] != null)
            {
                _DOCID = Request.QueryString["DOCID"];
            }
            
            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.Edit);
                GetRestrictions(_DOCID);
            }

            this.hlnkReturnLink.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + _DOCID;
        }        
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Clear Form Fields
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        InitializeFormFields();
        SetForm(FORM_ON.Edit);
        GetRestrictions(_DOCID);
    }

    /// <summary>
    /// Save the Restrictions
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnEditSave_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _RestrictionID = 0;
            if (this.ddlRestrictions.SelectedItem.Text != "-NONE-")
            {
                _RestrictionID = Convert.ToInt32(this.ddlRestrictions.SelectedValue);
            }
            else
            {
                throw new Exception("The [Restrictions ID] could not be located or created. The record will not be saved.");
            }

            DataAccess.ModifyRecords(DataQueries.InsertResNoticeRefs(Constants.DocReferenceType, _DOCID, _RestrictionID));

            InitializeFormFields();
            SetForm(FORM_ON.Edit);
            GetRestrictions(_DOCID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }

    /// <summary>
    /// Get Restrictions
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetRestrictions(String DOCID)
    {
        Int32 _rowCount = 0;
        
        try
        {
           
            this.gvRestrictions.EnableViewState = false;
            this.gvRestrictions.Controls.Clear();

            using (DataTable _tempRestrictions = DataAccess.GetRecords(DataQueries.GetViewResNotice(Constants.DocReferenceType, DOCID)))
            {
                _rowCount = _tempRestrictions.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvRestrictions.DataSource = _tempRestrictions;
                    this.gvRestrictions.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
        
        return _rowCount;
    }

    /// <summary>
    /// Data Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvRestrictions_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
        Int32 _colIDIndex = 0;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvRestrictions = (DataRowView)e.Row.DataItem;
            Int32 _colDescIndex = drvRestrictions.DataView.Table.Columns["Description"].Ordinal;
                  
            //Align               
            e.Row.Cells[_colDescIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }
    
    /// <summary>
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            DataTable _tempRestrictions = new DataTable();
            _tempRestrictions.Columns.Add("ID", Type.GetType("System.Int32"));
            _tempRestrictions.Columns.Add("Description", Type.GetType("System.String"));
            _tempRestrictions.Rows.Add(0, "-NONE-");
            _tempRestrictions.Merge(DataAccess.GetRecords(DataQueries.GetResNotice()), true);
            this.ddlRestrictions.DataSource = _tempRestrictions;
            this.ddlRestrictions.DataTextField = "Description";
            this.ddlRestrictions.DataValueField = "ID";
            this.ddlRestrictions.DataBind();
            
            this.gvRestrictions.EnableViewState = false;
            this.gvRestrictions.Controls.Clear();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Set Page to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.Edit)
            {
                //Apply Edit Style                              
               
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }    

}
