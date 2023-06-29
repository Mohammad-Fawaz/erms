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
public partial class DocumentManagement_AssociateOrders : System.Web.UI.Page
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

            Int32 _COID = 0;
            if (!String.IsNullOrEmpty(this.txtCOID.Text))
            {
                _COID = Convert.ToInt32(this.txtCOID.Text);
            }

            if (!IsPostBack)
            {   
               InitializeFormFields();
               SetForm(FORM_ON.View);               
               this.txtCOID.ReadOnly = false;
               this.txtCOID.Focus();

               //Get Revision and Status of the Document 
               Int32 _rowCount = 0;
               using (DataTable _tempViewDocs = DataAccess.GetRecords(DataQueries.GetViewDocsByID(_DOCID)))
               {
                   _rowCount = _tempViewDocs.Rows.Count;

                   if (_rowCount > 0)
                   {                       
                       this.txtCurrentRevision.Text = _tempViewDocs.Rows[0]["Current Revision"].ToString();                       
                       this.hdnDocStatus.Value = _tempViewDocs.Rows[0]["Document Status"].ToString();
                   }
               }

               GetCOToAssociate(0);
            }
            
            this.hlnkReturnLink.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + _DOCID;
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
        Int32 _rowCount = 0;
        
        try
        {
            Int32 _COID = 0;
            if (!String.IsNullOrEmpty(this.txtCOID.Text))
            {
                _COID = Convert.ToInt32(this.txtCOID.Text);
            }
            
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
            using (DataTable _tempValidateRev = DataAccess.GetRecords(DataQueries.GetSysSettingsBySectParam("ERMSProg", "DISALLOWREVS")))
            {
                _rowCount = _tempValidateRev.Rows.Count;

                if (_rowCount > 0)
                {
                    _InvalidChars = _tempValidateRev.Rows[0]["Return Value"].ToString();
                    _InvalidCharArray = _InvalidChars.ToCharArray();
                }
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
                DataAccess.ModifyRecords(DataQueries.InsertRevisionsDoc(_DOCID, _COID, _newRevision, _currentRevision));
                DataAccess.ModifyRecords(DataQueries.UpdateDocumentByID(_DOCID, _docStatusUpdate, _currentRevision,
                                                                        _lastModifiedBy, _lastModifiedDate));

                lblStatus.Text = "Success ! The Document (" + _DOCID + ") was successfully attached to the Order " + _COID;
            }
            else
            {
                throw new Exception("The [Revision] you've provided contains illegal character(s). " +
                                    "Please provide a revision which does not contain any of the " +
                                    "following characters: " + _InvalidChars);
            }

            InitializeFormFields();
            SetForm(FORM_ON.View);
            
            this.txtCOID.ReadOnly = false;
            this.txtCOID.Focus();

            this.btnAttach.Visible = false;
            this.btnCancel.Visible = false;
            this.btnFind.Visible = true;

            GetCOToAssociate(0);
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
                Int32 _COID = 0;
                if(!String.IsNullOrEmpty(this.txtCOID.Text))
                {
                    _COID = Convert.ToInt32(this.txtCOID.Text);                 
                }

                if (GetRecord(_COID) > 0)
                {
                    ValidateDocStatus();                    
                }

                Int32 _rowCount = GetCOToAssociate(_COID);
                if (_rowCount == 0)
                {
                    lblStatus.Text = "No Change Order Exists !";
                    GetCOToAssociate(0);
                }               
            }

            if (this.btnFind.Text == "Find New Change Order")
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);
                
                this.txtCOID.ReadOnly = false;
                this.txtCOID.Focus();
                
                this.btnFind.Text = "Find"; 
                this.btnAttach.Visible = false;
                this.btnCancel.Visible = false;
                                
                GetCOToAssociate(0);
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
            
            this.txtCOID.ReadOnly = false;
            this.txtCOID.Focus();
            
            this.btnAttach.Visible = false;            
            this.btnCancel.Visible = false;            
            this.btnFind.Visible = true;
            GetCOToAssociate(0);
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
    private Int32 GetRecord(Int32 COID)
    {
        Int32 _rowCount = 0;
        
        try
        {
            using (DataTable _tempViewCO = DataAccess.GetRecords(DataQueries.GetViewChangesByID(COID)))
            {
                _rowCount = _tempViewCO.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtCOID.Text = _tempViewCO.Rows[0]["Change ID"].ToString();
                    this.txtCODescription.Text = _tempViewCO.Rows[0]["Change Description"].ToString();                    
                    this.txtCurrentStatus.Text = _tempViewCO.Rows[0]["Change Status"].ToString();
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
    /// Get all Open Documents to Associate
    /// </summary>
    /// <param name="DOCID"></param>
    private Int32 GetCOToAssociate(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
           
            this.gvCOSearchResults.EnableViewState = false;
            this.gvCOSearchResults.AutoGenerateSelectButton = true;            
            this.gvCOSearchResults.Controls.Clear();

            String[] _COInvalidStatus = new String[] { "REJ", "CLS", "REL" };
            using (DataTable _tempAssocOrders = DataAccess.GetRecords(DataQueries.GetViewChangesByIDStatus(COID,_COInvalidStatus)))
            {
                _rowCount = _tempAssocOrders.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvCOSearchResults.DataSource = _tempAssocOrders;
                    this.gvCOSearchResults.DataBind();
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
    protected void gvCOSearchResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {            
            this.gvCOSearchResults.PageIndex = e.NewPageIndex;
            this.gvCOSearchResults.DataBind();
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
    protected void gvCOSearchResults_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GetCOToAssociate(0);

        if (gvCOSearchResults.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;
            Int32 _COrderID = Convert.ToInt32(gvCOSearchResults.Rows[_selectedRowIndex].Cells[1].Text);

            if (GetRecord(_COrderID) > 0)
            {
                ValidateDocStatus();
            }

            GetCOToAssociate(_COrderID);
        }
    }

    /// <summary>
    /// Row Data Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvCOSearchResults_RowDataBound(object sender, GridViewRowEventArgs e)
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
            Int32 _colProjNumberIndex = drvSearchResults.DataView.Table.Columns["Project Number"].Ordinal + 1;
            Int32 _colStatusIndex = drvSearchResults.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colEffDateIndex = drvSearchResults.DataView.Table.Columns["Effective Date"].Ordinal + 1;
            Int32 _colReqByIndex = drvSearchResults.DataView.Table.Columns["Requested By"].Ordinal + 1;
            Int32 _colReqDateIndex = drvSearchResults.DataView.Table.Columns["Requested Date"].Ordinal + 1;
            Int32 _colChTypeIndex = drvSearchResults.DataView.Table.Columns["Change Type"].Ordinal + 1;
            Int32 _colChDescIndex = drvSearchResults.DataView.Table.Columns["Description"].Ordinal + 1;
           
            //Select Button
            LinkButton lbSelect = (LinkButton)e.Row.Cells[_colSelectIndex].Controls[0];
            lbSelect.Text = e.Row.Cells[_colIDIndex].Text;
            lbSelect.Attributes.Add("Onclick", "javascript:window.open('../ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + e.Row.Cells[_colIDIndex].Text + "')");
            
            //Format            
            e.Row.Cells[_colEffDateIndex].Text = DateTime.Parse(e.Row.Cells[_colEffDateIndex].Text).ToShortDateString();
            e.Row.Cells[_colReqDateIndex].Text = DateTime.Parse(e.Row.Cells[_colReqDateIndex].Text).ToShortDateString();
            
            //Align    
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colProjNumberIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colEffDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colReqByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colReqDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colChTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colChDescIndex].HorizontalAlign = HorizontalAlign.Left;            
        }       
    }
       
    /// <summary>
    /// Validate Document Status
    /// </summary>
    private void ValidateDocStatus()
    {        
        try
        {
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
                    using (DataTable _tempAssocCount = DataAccess.GetRecords(DataQueries.GetViewDocHistoryCount(_DOCID, _checkStatus)))
                    {
                        _rowCount = Convert.ToInt32(_tempAssocCount.Rows[0]["RecordCount"].ToString());

                        if (_rowCount > 0)
                        {
                            lblStatus.Text = "The Document " + _DOCID + " is already associated with another " +
                                                "incomplete Change Order and cannot be changed again at this time.";
                        }
                    }

                    SetForm(FORM_ON.View);
                    this.btnAttach.Visible = false;
                    this.btnCancel.Visible = false;
                    this.btnFind.Visible = true;
                    this.btnFind.Text = "Find New Change Order";
                    break;
                case "OBS":
                    SetForm(FORM_ON.View);
                    this.btnAttach.Visible = false;
                    this.btnCancel.Visible = false;
                    this.btnFind.Visible = true;
                    this.btnFind.Text = "Find New Change Order";
                    lblStatus.Text = "The Document " + _DOCID + " is Obsolete and cannot be changed again at this time.";
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
                    this.btnFind.Text = "Find New Change Order";
                    lblStatus.Text = "The Document " + _DOCID + " has unknown status.Please Check !";
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
            this.txtCOID.Text = null; 
            this.txtCurrentStatus.Text = null;
            this.txtCODescription.Text = null;
            this.txtCODescription.TextMode = TextBoxMode.MultiLine;
            this.txtCODescription.Height = 50;

            this.txtNewRevision.Text = null;
            
            this.gvCOSearchResults.EnableViewState = false;            
            this.gvCOSearchResults.Controls.Clear();

            this.txtCOID.Focus();  
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
                this.txtCOID.ReadOnly = true;
                this.txtNewRevision.ReadOnly = true;
                this.txtCurrentRevision.ReadOnly = true;
                this.txtCurrentStatus.ReadOnly = true;
                this.txtCODescription.ReadOnly = true;
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