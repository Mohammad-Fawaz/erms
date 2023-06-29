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
using System.Data.OleDb;
using System.Drawing;

/// <summary>
/// Associate Documents Class
/// </summary>
public partial class ChangeManagement_AssociateDocs : System.Web.UI.Page
{    
    public String _SID;    
    public String _SessionUser;
    public Int32 _COID;
      
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

            if (Request.QueryString["COID"] != null)
            {
                _COID = Convert.ToInt32(Request.QueryString["COID"]);
            }

            String _docID = null;
            if (!String.IsNullOrEmpty(this.txtDocID.Text))
            {
                _docID = this.txtDocID.Text;
            }

            if (!IsPostBack)
            {               
               InitializeFormFields();
               SetForm(FORM_ON.View);               
               this.txtDocID.ReadOnly = false;
               this.txtDocID.Focus();               
            }

            GetAssociatedDocs(_COID);
            GetDocumentsToAssociate(_docID);
            this.hlnkReturnLink.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + _COID;
        }      
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }             
    }     
          
    /// <summary>
    ///  validate, Insert Revisions  and Update Status   
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAttach_Click(object sender, EventArgs e)
    {        
        try
        {
            String _docID = this.txtDocID.Text;
            String _docStatusUpdate = "PND";
            String _lastModifiedBy = "ADDITION TO CO:" + _COID + " By " + _SessionUser;
            DateTime _lastModifiedDate = DateTime.Now;

            String _currentRevision = this.txtCurrentRevision.Text;
            if (String.IsNullOrEmpty(_currentRevision))
            {
                _currentRevision = "-";
            }
            
            //Validate New Revision           
            String _InvalidChars = null;
            Char[] _InvalidCharArray = null;

            _InvalidChars = Utils.GetSystemConfigurationReturnValue("ERMSProg", "DISALLOWREVS");
            if (!String.IsNullOrEmpty(_InvalidChars))
            {
                _InvalidCharArray = _InvalidChars.ToCharArray();
            }
  
            String _newRevision = this.txtNewRevision.Text;
            Boolean _IsRevisionValid = false;
            if (!String.IsNullOrEmpty(_newRevision))
            {
                Char[] _userCharArray = null;
                _userCharArray = _newRevision.ToCharArray();

                _IsRevisionValid = true;
                for (int k = 0; k <= _userCharArray.Length - 1; k++)
                {
                    for (int i = 0; i <= _InvalidCharArray.Length - 1; i++)
                    {
                        if (_userCharArray[k] == _InvalidCharArray[i])
                        {
                            _IsRevisionValid = false;
                        }
                    }
                }
            }
            else
            {              
              throw new Exception("The [New Revision] could not be located. The record will not be saved.");
            }

            if (_IsRevisionValid)
            {
                //DataAccess.ModifyRecords(DataQueries.InsertRevisionsDoc(_docID, _COID, _newRevision, _currentRevision));
                //DataAccess.ModifyRecords(DataQueries.UpdateDocumentByID(_docID, _docStatusUpdate, _currentRevision, _lastModifiedBy, _lastModifiedDate));
                DataAccess.ModifyRecords(DataQueries.InsertRevisionsDoc(_docID, _COID, _currentRevision, _newRevision));
                DataAccess.ModifyRecords(DataQueries.UpdateDocumentByID(_docID, _docStatusUpdate, _newRevision, _lastModifiedBy, _lastModifiedDate));





                lblStatus.Text = "Success ! The Document (" + _docID + ") was successfully attached to the Order " + _COID;
            }
            else
            {
                throw new Exception("The [Revision] you've provided contains illegal character(s). " +
                                    "Please provide a revision which does not contain any of the " +
                                    "following characters: " + _InvalidChars);
            }

            InitializeFormFields();
            SetForm(FORM_ON.View);            
            this.txtDocID.ReadOnly = false;
            this.txtDocID.Focus();

            this.btnAttach.Visible = false;
            this.btnCancel.Visible = false;
            this.btnFind.Visible = true;

            
            GetAssociatedDocs(_COID);
            GetDocumentsToAssociate(null);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }  
    }

    /// <summary>
    /// Find and Validate
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnFind_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnFind.Text == "Find")
            {
                String _docID = this.txtDocID.Text;
                if (GetRecord(_docID) > 0)
                {
                    ValidateDocStatus();                    
                }
                
                GetAssociatedDocs(_COID);

                Int32 _rowCount = GetDocumentsToAssociate(_docID);
                if (_rowCount == 0)
                {
                    lblStatus.Text = "No Document Exists !";
                    GetDocumentsToAssociate(null);
                }
            }

            if (this.btnFind.Text == "Find New Document")
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);                
                this.txtDocID.ReadOnly = false;
                this.txtDocID.Focus();
                
                this.btnFind.Text = "Find"; 
                this.btnAttach.Visible = false;
                this.btnCancel.Visible = false;

                GetAssociatedDocs(_COID);                
                GetDocumentsToAssociate(null);
            }            
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }

    /// <summary>
    /// Cancel to Prior Settings
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            InitializeFormFields();
            SetForm(FORM_ON.View);            
            this.txtDocID.ReadOnly = false;
            this.txtDocID.Focus();
            
            this.btnAttach.Visible = false;            
            this.btnCancel.Visible = false;            
            this.btnFind.Visible = true;

            GetAssociatedDocs(_COID);
            GetDocumentsToAssociate(null);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }       
    }
       
    /// <summary>
    /// Get Record Values
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetRecord(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewDocs = DataAccess.GetRecords(DataQueries.GetViewDocsByID(DOCID)))
            {
                _rowCount = _tempViewDocs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtDocID.Text = _tempViewDocs.Rows[0]["Document ID"].ToString();
                    this.txtDocDescription.Text = _tempViewDocs.Rows[0]["Document Description"].ToString();
                    this.txtCurrentRevision.Text = _tempViewDocs.Rows[0]["Current Revision"].ToString();
                    this.txtCurrentStatus.Text = _tempViewDocs.Rows[0]["Status"].ToString();
                    this.hdnDocStatus.Value = _tempViewDocs.Rows[0]["Document Status"].ToString();
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
    /// Get Associated Doc 
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetAssociatedDocs(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {            
            this.gvAssociatedDocs.AutoGenerateDeleteButton = true;
            this.gvAssociatedDocs.EnableViewState = false;
            this.gvAssociatedDocs.Controls.Clear();

            using (DataTable _tempAssocDocs = DataAccess.GetRecords(DataQueries.GetViewAssocDocsByID(COID)))
            {
                _rowCount = _tempAssocDocs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvAssociatedDocs.DataSource = _tempAssocDocs;
                    this.gvAssociatedDocs.DataBind();
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
    ///  Associated Doc Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAssociatedDocs_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 ChangeID = 0;
        String _ChangeID = _COID.ToString() ; 
        if (!String.IsNullOrEmpty(_ChangeID))
        {
            ChangeID = Convert.ToInt32(_ChangeID);
        }

        GetAssociatedDocs(ChangeID);
        
        if (gvAssociatedDocs.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            String _Revision = null;
            Int32 _StatusCheck = 0;
            String DocumentID = gvAssociatedDocs.Rows[e.RowIndex].Cells[1].Text;

            //Get Revision
            using (DataTable _dtRevisions = DataAccess.GetRecords(DataQueries.GetRevisionsByID(ChangeID, DocumentID)))
            {
                _Revision = _dtRevisions.Rows[0]["Old Revision"].ToString();
                if (String.IsNullOrEmpty(_Revision))
                {
                    using (DataTable _dtDocRevision = DataAccess.GetRecords(DataQueries.GetDocumentsByID(DocumentID)))
                    {
                        _Revision = _dtDocRevision.Rows[0]["Current Revision"].ToString();
                    }
                }
            }

            //Check Revision and Remove
            if (!String.IsNullOrEmpty(_Revision))
            {
                String _docStatus = "REL";
                String _LastModifiedBy = "REMOVED FROM CO :" + ChangeID;

                _StatusCheck = DataAccess.ModifyRecords(DataQueries.RemoveRevisionsByID(ChangeID, DocumentID));
                if (_StatusCheck > 0)
                {
                    this.lblStatus.Text = "Success ! Document " + ChangeID + " removed from Change Order " + ChangeID;
                }

                _StatusCheck = DataAccess.ModifyRecords(DataQueries.UpdateDocumentByID(DocumentID, _docStatus, _Revision,
                                                                                        _LastModifiedBy, DateTime.Now));
            }
        }

        GetAssociatedDocs(ChangeID);
        GetDocumentsToAssociate(null);
    }

    /// <summary>
    /// Associated Doc Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAssociatedDocs_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Get Column Indexes
            DataRowView drvADocs = (DataRowView)e.Row.DataItem;
            Int32 _colDocIDIndex = drvADocs.DataView.Table.Columns["Document ID"].Ordinal + 1;
            Int32 _colORevIndex = drvADocs.DataView.Table.Columns["Old Revision"].Ordinal + 1;
            Int32 _colCRevIndex = drvADocs.DataView.Table.Columns["Current Revision"].Ordinal + 1;
            Int32 _colNRevIndex = drvADocs.DataView.Table.Columns["New Revision"].Ordinal + 1;
            Int32 _colStatusIndex = drvADocs.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colDescriptionIndex = drvADocs.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colDocTypeIndex = drvADocs.DataView.Table.Columns["Document Type"].Ordinal + 1;
            Int32 _colLastModifiedByIndex = drvADocs.DataView.Table.Columns["Last Modified By"].Ordinal + 1;
            Int32 _colDateModifiedIndex = drvADocs.DataView.Table.Columns["Date Modified"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "1<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Format            
            String _ModDate = e.Row.Cells[_colDateModifiedIndex].Text;
            if (!String.IsNullOrEmpty(_ModDate))
            {
                e.Row.Cells[_colDateModifiedIndex].Text = Convert.ToDateTime(_ModDate).ToShortDateString();
            }

            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDocIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colORevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colCRevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colNRevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDocTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colLastModifiedByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDateModifiedIndex].HorizontalAlign = HorizontalAlign.Center;
        }
    }
   
    /// <summary>
    /// Get all Open Documents to Associate
    /// </summary>
    /// <param name="DOCID"></param>
    private Int32 GetDocumentsToAssociate(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {           
            this.gvDocSearchResults.EnableViewState = false;
            this.gvDocSearchResults.AutoGenerateSelectButton = true;            
            this.gvDocSearchResults.Controls.Clear();

            using (DataTable _tempAssocDocs = DataAccess.GetRecords(DataQueries.GetViewDocsByIDandStatus(DOCID)))
            {
                _rowCount = _tempAssocDocs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvDocSearchResults.DataSource = _tempAssocDocs;
                    this.gvDocSearchResults.DataBind();
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
    /// Pagination
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvDocSearchResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            this.gvDocSearchResults.PageIndex = e.NewPageIndex;
            this.gvDocSearchResults.DataBind();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Selected Document
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvDocSearchResults_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        if (gvDocSearchResults.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;
            String _docID = gvDocSearchResults.Rows[_selectedRowIndex].Cells[1].Text;

            if (GetRecord(_docID) > 0)
            {
                ValidateDocStatus();
            }

            GetAssociatedDocs(_COID);
            GetDocumentsToAssociate(_docID);
        }
    }

    /// <summary>
    /// Row Data Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvDocSearchResults_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colSelectIndex = 0;
        Int32 _colIDIndex = 1;

        if (e.Row.RowType == DataControlRowType.Header)
        {               
            e.Row.Cells[_colIDIndex].Visible = false;
            e.Row.Cells[_colSelectIndex].Text = e.Row.Cells[_colIDIndex].Text;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {            
            e.Row.Cells[_colIDIndex].Visible = false;
                          
            DataRowView drvSearchResults = (DataRowView)e.Row.DataItem; 
            Int32 _colCRevIndex = drvSearchResults.DataView.Table.Columns["Current Revision"].Ordinal + 1;
            Int32 _colStatusIndex = drvSearchResults.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colTypeDescIndex = drvSearchResults.DataView.Table.Columns["Type Description"].Ordinal + 1;
            Int32 _colDiscIndex = drvSearchResults.DataView.Table.Columns["Discipline"].Ordinal + 1;
            Int32 _colDescIndex = drvSearchResults.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colLastModByIndex = drvSearchResults.DataView.Table.Columns["Last Modified By"].Ordinal + 1;
            Int32 _colLastModDateIndex = drvSearchResults.DataView.Table.Columns["Last Modified Date"].Ordinal + 1;
           
            //Select Button
            LinkButton lbSelect = (LinkButton)e.Row.Cells[_colSelectIndex].Controls[0];
            lbSelect.Text = e.Row.Cells[_colIDIndex].Text;

            //Format            
            e.Row.Cells[_colLastModDateIndex].Text = DateTime.Parse(e.Row.Cells[_colLastModDateIndex].Text).ToShortDateString();

            //Align    
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCRevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colTypeDescIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDiscIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDescIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colLastModByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colLastModDateIndex].HorizontalAlign = HorizontalAlign.Center;            
        }       
    }
       
    /// <summary>
    /// Validate Document Status
    /// </summary>
    private void ValidateDocStatus()
    {        
        try
        {            
            String _docID = this.txtDocID.Text;
            String docStatus = this.hdnDocStatus.Value;

            switch (docStatus)
            {
                case "REQ":                
                case "PND":
                case "WIP":
                case "APR":
                case "CLS":
                case "CREQ":                    
                    String[] _checkStatus = new String[] { "REQ", "PND", "WIP", "APR", "CLS"};
                  

                    Int32 _rowCount = 0;
                    using (DataTable _tempAssocCount = DataAccess.GetRecords(DataQueries.GetViewDocHistoryCount(_docID, _checkStatus)))
                    {
                        _rowCount = Convert.ToInt32(_tempAssocCount.Rows[0]["RecordCount"].ToString());

                        if (_rowCount > 0)
                        {
                            lblStatus.Text = "The Document " + _docID + " is already associated with another " +
                                                "incomplete Change Order and cannot be changed again at this time.";
                        }
                    }

                    SetForm(FORM_ON.View);
                    this.btnAttach.Visible = false;
                    this.btnCancel.Visible = false;
                    this.btnFind.Visible = true;
                    this.btnFind.Text = "Find New Document";
                    break;
                case "OBS":
                    SetForm(FORM_ON.View);
                    this.btnAttach.Visible = false;
                    this.btnCancel.Visible = false;
                    this.btnFind.Visible = true;
                    this.btnFind.Text = "Find New Document";
                    lblStatus.Text = "The Document " + _docID + " is Obsolete and cannot be changed again at this time.";
                    break;
                case "ARC": 
                case "REL":
                    SetForm(FORM_ON.Edit);
                    this.btnAttach.Visible = true;
                    this.btnCancel.Visible = true;
                    this.btnFind.Visible = false;
                    this.btnFind.Text = "Find";
                    break;                    
                default:
                    this.btnFind.Text = "Find New Document";
                    lblStatus.Text = "The Document " + _docID + " has unknown status.Please Check !";
                    break;
            }               
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }      
    
    /// <summary>
    /// Initialize 
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            //Reset        
            this.txtDocID.Text = null;
            this.txtCurrentRevision.Text = null;            
            this.txtNewRevision.Text = null;
            this.txtCurrentStatus.Text = null;
            this.txtDocDescription.Text = null;

            this.txtDocDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDocDescription.Height = 50;
            
            this.gvDocSearchResults.EnableViewState = false;            
            this.gvDocSearchResults.Controls.Clear();

            this.txtDocID.Focus();  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }  
    }

    /// <summary>
    /// Set Page 
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {               
                //Set Read Only
                this.txtDocID.ReadOnly = true;
                this.txtNewRevision.ReadOnly = true;
                this.txtCurrentRevision.ReadOnly = true;
                this.txtCurrentStatus.ReadOnly = true;
                this.txtDocDescription.ReadOnly = true;
            }

            if (EditView == FORM_ON.Edit)
            {                
                this.txtNewRevision.ReadOnly = false;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }        
    }

}