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
/// Notes Class
/// </summary>
public partial class ChangeManagement_Notes : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    public Int32 _COID;    
         
    protected void Page_Load(object sender, EventArgs e)
    {       
        this.lblStatus.Text = null;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            if (Request.QueryString["COID"] != null)
            {
                _COID = Convert.ToInt32(Request.QueryString["COID"]);
            }
            
            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.Edit);
                GetAddedNotes(_COID);
            }

            this.hlnkReturnLink.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + _COID;
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
        GetAddedNotes(_COID);
    }

    /// <summary>
    /// Save the Note
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnEditSave_Click(object sender, EventArgs e)
    {
        try
        {
            String _userID = null;
            if (this.ddlCreatedBy.SelectedItem.Text != "-NONE-")
            {
                _userID = this.ddlCreatedBy.SelectedItem.Value;
            }
            else
            {
                throw new Exception("The person [Created By] could not be located or created. The record will not be saved.");
            }

            String _noteType = null;
            if (this.ddlNoteType.SelectedItem.Text != "-NONE-")
            {
                _noteType = this.ddlNoteType.SelectedValue;
            }
            else
            {
                throw new Exception("The [Note Type] could not be located or created. The record will not be saved.");
            }

            String _tempDate = null;
            if (String.IsNullOrEmpty(this.ucDateCreatedBy.SelectedDate))
            {
                _tempDate = DateTime.Now.ToShortDateString();
            }
            else
            {
                _tempDate = this.ucDateCreatedBy.SelectedDate;
            }
            DateTime _CreatedDate = Convert.ToDateTime(_tempDate);

            String _noteSubject = this.txtSubject.Text;
            String _noteText = this.txtNoteText.Text;

            DataAccess.ModifyRecords(DataQueries.InsertNotes(Constants.ChangeReferenceType, _COID.ToString(), _CreatedDate, _userID, _noteType, _noteSubject, _noteText));
            InitializeFormFields();
            SetForm(FORM_ON.Edit);
            GetAddedNotes(_COID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }

    /// <summary>
    /// Get Added Notes
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetAddedNotes(int COID)
    {
        Int32 _rowCount = 0;            

        try
        {            
            this.gvNotes.EnableViewState = false;
            this.gvNotes.Controls.Clear();

            using (DataTable _tempAddedNotes = DataAccess.GetRecords(DataQueries.GetViewNotesByTypeAndID(Constants.ChangeReferenceType, COID.ToString())))
            {
                _rowCount = _tempAddedNotes.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvNotes.DataSource = _tempAddedNotes;
                    this.gvNotes.DataBind();
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
    protected void gvNotes_RowDataBound(object sender, GridViewRowEventArgs e)
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
            DataRowView drvNotes = (DataRowView)e.Row.DataItem;            
            _colIDIndex = drvNotes.DataView.Table.Columns["Note ID"].Ordinal;
            Int32 _colDateIndex = drvNotes.DataView.Table.Columns["Date"].Ordinal;
            Int32 _colTypeIndex = drvNotes.DataView.Table.Columns["Type"].Ordinal;
            Int32 _colCreatedByIndex = drvNotes.DataView.Table.Columns["Created By"].Ordinal;
            Int32 _colSubjectIndex = drvNotes.DataView.Table.Columns["Subject"].Ordinal;

            //Format            
            e.Row.Cells[_colDateIndex].Text = DateTime.Parse(e.Row.Cells[_colDateIndex].Text).ToShortDateString();

            //Align            
            e.Row.Cells[_colIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCreatedByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colSubjectIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }
    
    /// <summary>
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {                        
            this.txtSubject.Text = null;
            this.ucDateCreatedBy.SelectedDate = null;    
            
            this.txtNoteText.Text = null;
            this.txtNoteText.TextMode = TextBoxMode.MultiLine;
            this.txtNoteText.Height = 50;
                                  
            DataTable _tempNoteTypes = new DataTable();
            _tempNoteTypes.Columns.Add("ID", Type.GetType("System.String"));
            _tempNoteTypes.Columns.Add("Description", Type.GetType("System.String"));
            _tempNoteTypes.Rows.Add("-NONE-", "-NONE-");
            _tempNoteTypes.Merge(DataAccess.GetRecords(DataQueries.GetQNoteTypes()), true);
            this.ddlNoteType.DataSource = _tempNoteTypes;
            this.ddlNoteType.DataTextField = "Description";
            this.ddlNoteType.DataValueField = "Code";
            this.ddlNoteType.DataBind();

            DataTable _tempCreatedBy = new DataTable();
            _tempCreatedBy.Columns.Add("User ID", Type.GetType("System.String"));
            _tempCreatedBy.Columns.Add("User Name", Type.GetType("System.String"));
            _tempCreatedBy.Rows.Add("-NONE-", "-NONE-");
            _tempCreatedBy.Merge(DataAccess.GetRecords(DataQueries.GetQUserInfo()), true);
            this.ddlCreatedBy.DataSource = _tempCreatedBy;
            this.ddlCreatedBy.DataTextField = "User Name";
            this.ddlCreatedBy.DataValueField = "User ID";
            this.ddlCreatedBy.DataBind();

            this.gvNotes.EnableViewState = false;
            this.gvNotes.Controls.Clear();
            
            this.txtSubject.Focus();
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
                
                this.ucDateCreatedBy.SelectedDate = DateTime.Now.ToShortDateString();    

                ListItem liSelectedItem = null;
                liSelectedItem = this.ddlCreatedBy.Items.FindByText(_SessionUser);
                this.ddlCreatedBy.SelectedIndex = this.ddlCreatedBy.Items.IndexOf(liSelectedItem);
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }    
}
