using System;
using System.Data;
using System.Configuration;
using System.Web.Configuration;  
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Drawing;

public partial class DocumentManagement_AddElementWafer : System.Web.UI.Page
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

            if (Request.QueryString["DOCID"] !=null)
            {
                _DOCID = Request.QueryString["DOCID"];
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);
            }

            GetAddPartsInfo(_DOCID);
            this.hlnkReturnLink.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + _DOCID;
        }      
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }      
    }
    
    /// <summary>
    /// Cancel Order
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Edit")
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);
                this.btnNewEditSave.Text = "Add Item";
                this.btnCancel.Visible = false;
            }

            if (this.btnNewEditSave.Text == "Update")
            {
                Int32 _PartID = Convert.ToInt32(this.hdnPartID.Value);
                if (GetRecord(_PartID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnNewEditSave.Text = "Edit";
                }
            }
         
            GetAddPartsInfo(_DOCID);
        }        
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }
    
    /// <summary>
    /// Edit / Save
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnNewEditSave_Click(object sender, EventArgs e)
    {
        try
        {
            if(this.btnNewEditSave.Text == "Add Item") 
            {
                Int32 _rowCount = 0;
                Int32 _SchemeID = 0;
                String _discipline = null;
                String _docType = null;
                String SchemeDescType = WebConfigurationManager.AppSettings["Parts"];

                InitializeFormFields();

                //Get Discipline and DocType from View Documents Table               
                using (DataTable _tempViewDocs = DataAccess.GetRecords(DataQueries.GetViewDocsByID(_DOCID)))
                {
                    _rowCount = _tempViewDocs.Rows.Count;
                    if (_rowCount > 0)
                    {
                        _docType = _tempViewDocs.Rows[0]["Document Type ID"].ToString();
                        _discipline = null; //_tempViewDocs.Rows[0]["Discipline Code"].ToString();
                    }
                }

                //Get Scheme ID
                _rowCount = 0;
                using (DataTable _tempNumSchemes = DataAccess.GetRecords(DataQueries.GetQNumSchemes(_discipline, _docType, SchemeDescType)))
                {
                    _rowCount = _tempNumSchemes.Rows.Count;

                    if (_rowCount > 0)
                    {
                        _SchemeID = Convert.ToInt32(_tempNumSchemes.Rows[0]["ID"].ToString());
                    }
                }

                //Get Part Number
                if (_SchemeID > 0 && !String.IsNullOrEmpty(_DOCID))
                {
                    this.txtPartNumber.Text = Utils.GetNewID(_SchemeID, "Parts", _DOCID);
                }
                else
                {
                    lblStatus.Text = "Document number used. (No valid scheme available)";
                    this.txtPartNumber.Text = _DOCID;
                    this.txtRevision.Text = Utils.GetDocumentCurrentRevision(_DOCID); 
                    this.txtRevisionStatus.Text = "ACTIVE";
                    this.txtWaferPartNumber.Text = "CONSTANT";                    
                }
                    
                SetForm(FORM_ON.Edit);                
                this.btnNewEditSave.Text ="Save";
                this.btnCancel.Visible =true;
            }
            else if (this.btnNewEditSave.Text == "Edit")
            {                
                SetForm(FORM_ON.Edit); 
                this.btnNewEditSave.Text ="Update";
                this.btnCancel.Visible =true;  
            }
            else if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update")
            {
                if (String.IsNullOrEmpty(_DOCID))
                {
                    throw new Exception("A referencing [CO Number] could not be located. The record will not be saved.");
                }              

                Int32 _partID = 0;
                if(!String.IsNullOrEmpty(this.hdnPartID.Value))
                {
                    _partID = Convert.ToInt32(this.hdnPartID.Value); 
                }

                String _partNumber = this.txtPartNumber.Text;
                if (String.IsNullOrEmpty(_partNumber))
                {
                    if (Utils.IsRequiredField("PartsXRef", "PartNo"))
                    {
                        throw new Exception("A [Part Number] could not be located or created. The record will not be saved.");
                    }
                }

                String _currentRevision = this.txtRevision.Text;
                if (String.IsNullOrEmpty(_currentRevision))
                {
                    if (Utils.IsRequiredField("PartsXRef", "CurRev"))
                    {
                        throw new Exception("A [Revision] could not be located or created. The record will not be saved.");
                    }
                }

                String _revisionStatus = null;
                if (this.ddlRevisionStatus.SelectedItem.Text != "-NONE-")
                {
                    _revisionStatus = this.ddlRevisionStatus.SelectedItem.Value;
                }
                else
                {
                    if (Utils.IsRequiredField("PartsXRef", "RevStatus"))
                    {
                        throw new Exception("A [Revision Status] could not be located or created. The record will not be saved.");
                    }
                }

                String _revisionType = null;
                //if (this.ddlRevisionType.SelectedItem.Text != "-NONE-")
                //{
                //    _revisionType = this.ddlRevisionType.SelectedItem.Value;
                //}
                //else
                //{
                //    if (Utils.IsRequiredField("PartsXRef", "RevType"))
                //    {
                //        throw new Exception("A [Revision Type] could not be located or created. The record will not be saved.");
                //    }
                //}

                //if Constant
                if (_revisionType == "C" && String.Compare(_currentRevision,Utils.GetDocumentCurrentRevision(_DOCID)) != 0) 
                {
                    throw new Exception("A [Revision Type CONSTANT] should match document [Revision]. The record will not be saved."); 
                }

                Int32 _fileID = 0;
                //if (Utils.IsRequiredField("PartsXRef", "FileID"))
                //{
                //    throw new Exception("A [Related File] could not be located or created. The record will not be saved.");
                //}

                Boolean _cbFAIRequired = false;
                if (this.cbFAI.Checked)
                {
                    _cbFAIRequired = true;
                }

                DateTime _dateFAI;
                if (!String.IsNullOrEmpty(this.ucFAIDate.SelectedDate))
                {
                    _dateFAI = Convert.ToDateTime(this.ucFAIDate.SelectedDate);
                }
                else
                {
                    if (Utils.IsRequiredField("PartsXRef", "FAIDate"))
                    {
                        throw new Exception("An [FAI Date] could not be located or created. The record will not be saved.");
                    }
                    else
                    {
                        _dateFAI = Convert.ToDateTime(Constants.DateTimeMinimum);
                    }
                }
                
                DateTime _startDate;
                if (!String.IsNullOrEmpty(this.ucDateStart.SelectedDate))
                {
                    _startDate = Convert.ToDateTime(this.ucDateStart.SelectedDate);
                }
                else
                {
                    if (Utils.IsRequiredField("PartsXRef", "EffDate"))
                    {
                        throw new Exception("An [Effective (Start) Date] could not be located or created. The record will not be saved.");
                    }
                    else
                    {
                        _startDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                    }
                }

                DateTime _endDate;
                if (!String.IsNullOrEmpty(this.ucExpiryDate.SelectedDate))
                {
                    _endDate = Convert.ToDateTime(this.ucExpiryDate.SelectedDate);
                }
                else
                {
                    if (Utils.IsRequiredField("PartsXRef", "ExpDate"))
                    {
                        throw new Exception("An [Expiration Date] could not be located or created. The record will not be saved.");
                    }
                    else
                    {
                        _endDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                    }
                }

                String _partDescription = this.txtDescription.Text;
                if (String.IsNullOrEmpty(_partDescription))
                {
                    if (Utils.IsRequiredField("PartsXRef", "PartDesc"))
                    {
                        throw new Exception("A [Description] could not be located or created. The record will not be saved.");
                    }
                }

                Int32 _StatusID = 0;
                if (this.btnNewEditSave.Text == "Save")
                {
                    //_StatusID = DataAccess.ModifyRecords(DataQueries.InsertPartsXRef(_partNumber, _DOCID, _fileID, _partDescription,
                    //                                                                _revisionType, _currentRevision, _revisionStatus,
                    //                                                                _startDate, _endDate, _cbFAIRequired, _dateFAI));
                    if (_StatusID > 0)
                    {
                        lblStatus.Text = "New Item Added !";

                        //using (DataTable _dtIdentity = DataAccess.GetRecords(DataQueries.GetMaxMatDispID()))
                        //{
                        //    _partID = Convert.ToInt32(_dtIdentity.Rows[0]["ID"].ToString());                            
                        //}
                    }
                }

                if (this.btnNewEditSave.Text == "Update")
                {
                    //_StatusID = DataAccess.ModifyRecords(DataQueries.UpdatePartsXRef(_partNumber, _DOCID, _fileID, _partDescription,
                    //                                                                _revisionType, _currentRevision, _revisionStatus,
                    //                                                                _startDate, _endDate, _cbFAIRequired, _dateFAI, _partID));
                    if (_StatusID > 0)
                    {
                        lblStatus.Text = "Changes Updated !";
                    }
                }                
 
                InitializeFormFields();
                this.btnNewEditSave.Text = "Add Item";
                this.btnCancel.Visible = false;                
                SetForm(FORM_ON.View);                               
                
            }//if Save or Update
           
            GetAddPartsInfo(_DOCID); 
        }        
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }

    /// <summary>
    /// Get Record by Disp ID
    /// </summary>
    /// <param name="_PartID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 PartID)
    {
        Int32 _rowCount = 0;
        
        try
        {
            using (DataTable _tempMaterial = DataAccess.GetRecords(DataQueries.GetViewPartsByID(PartID)))
            {
                _rowCount = _tempMaterial.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtPartNumber.Text = _tempMaterial.Rows[0]["Part Number"].ToString();
                    this.txtRevision.Text = _tempMaterial.Rows[0]["Current Revision"].ToString();
                    this.txtWaferPartNumber.Text = _tempMaterial.Rows[0]["Revision Type"].ToString();
                    this.txtRevisionStatus.Text = _tempMaterial.Rows[0]["Status"].ToString();

                    String _fileName = _tempMaterial.Rows[0]["File Name"].ToString();
                    String _fileLocation = _tempMaterial.Rows[0]["File Location"].ToString();
                    String _fileLink = _tempMaterial.Rows[0]["File Link"].ToString();
                    
                    if(!String.IsNullOrEmpty(_fileName) && !String.IsNullOrEmpty(_fileLocation))
                    {
                        this.txtRelatedFile.Text = _fileLocation + _fileName; 
                    }

                    String _StartDate = _tempMaterial.Rows[0]["Effective Date"].ToString();
                    if (!String.IsNullOrEmpty(_StartDate) && Constants.DateTimeMinimum != _StartDate)
                    {
                        this.txtStartDate.Text = Convert.ToDateTime(_StartDate).ToShortDateString();
                    }

                    String _EndDate = _tempMaterial.Rows[0]["Expiry Date"].ToString();
                    if (!String.IsNullOrEmpty(_EndDate) && Constants.DateTimeMinimum != _EndDate)
                    {
                        this.txtExpiryDate.Text = Convert.ToDateTime(_EndDate).ToShortDateString();
                    }

                    if (!String.IsNullOrEmpty(_tempMaterial.Rows[0]["FAI"].ToString()))
                    {
                        this.cbFAI.Checked = Convert.ToBoolean(_tempMaterial.Rows[0]["FAI"].ToString());
                    }

                    String _FAIDate = _tempMaterial.Rows[0]["FAI Date"].ToString();
                    if (!String.IsNullOrEmpty(_FAIDate) && Constants.DateTimeMinimum != _FAIDate)
                    {
                        this.txtFAIDate.Text = Convert.ToDateTime(_FAIDate).ToShortDateString();
                    }

                    this.txtDescription.Text = _tempMaterial.Rows[0]["Description"].ToString();
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
    /// Material Disposition Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddPartsInfo_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        if (gvAddPartsInfo.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;
            Int32 _PartID = Convert.ToInt32(gvAddPartsInfo.Rows[_selectedRowIndex].Cells[1].Text);
            this.hdnPartID.Value = gvAddPartsInfo.Rows[_selectedRowIndex].Cells[1].Text;
            if (GetRecord(_PartID) > 0)
            {
                SetForm(FORM_ON.View);
                this.btnNewEditSave.Text = "Edit";
                this.btnCancel.Visible = true; 
            }
        }

        GetAddPartsInfo(_DOCID);      
    }    
    
    /// <summary>
    /// Material Disposition Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddPartsInfo_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colSelectIndex = 0;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {          
            //Get Column Indexes
            DataRowView drvAParts = (DataRowView)e.Row.DataItem;
            Int32 _colPartNoIndex = drvAParts.DataView.Table.Columns["Part Number"].Ordinal + 1;
            Int32 _colThickIndex = drvAParts.DataView.Table.Columns["Thick w/ Barr"].Ordinal + 1;
            Int32 _colWaferIndex = drvAParts.DataView.Table.Columns["Wafer P/N"].Ordinal + 1;
            Int32 _colQtyIndex = drvAParts.DataView.Table.Columns["Qty"].Ordinal + 1;
            Int32 _colSizeIndex = drvAParts.DataView.Table.Columns["Size"].Ordinal + 1;
                     
            //Align
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colPartNoIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colThickIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colWaferIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colQtyIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colSizeIndex].HorizontalAlign = HorizontalAlign.Center;            
        }
    }

    /// <summary>
    /// Get Material Disposition
    /// </summary>
    /// <param name="DOCID"></param>
    /// <returns></returns>
    private Int32 GetAddPartsInfo(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
                      
            this.gvAddPartsInfo.AutoGenerateSelectButton = true;
            this.gvAddPartsInfo.EnableViewState = false;
            this.gvAddPartsInfo.Controls.Clear();

            //Move this query to AppCode DataQueries            
			//val6 = CInt(CDbl(rsItem("Par5")) * 10000) / 10000


            String tempQry = "SELECT PartNo AS [Part Number], Par5 + ' +/- ' + Par6 AS [Thick w/ Barr], MatlPn AS [Wafer P/N], " +
                "Par7 AS [Qty], Par1 + ' x ' + Par3 AS [Size] FROM PartPar WHERE (DocID = '" + DOCID + "') ORDER BY PartNo";

            using (DataTable _tempMDInfo = DataAccess.GetRecords(tempQry))  //DataQueries.GetViewParts(DOCID)))
            {
                _rowCount = _tempMDInfo.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvAddPartsInfo.DataSource = _tempMDInfo;
                    this.gvAddPartsInfo.DataBind();
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
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            this.ucFAIDate.SelectedDate = null;  
            this.ucExpiryDate.SelectedDate = null;
            this.ucDateStart.SelectedDate = null;   
            this.txtPartNumber.Text = null;
            this.txtRelatedFile.Text = null;           
            this.txtRevision.Text = null;
            this.txtWaferPartNumber.Text = null;
            this.txtExpiryDate.Text = null;
            this.txtRevisionStatus.Text = null;
            this.txtStartDate.Text = null;

            this.cbFAI.Checked = false;
            this.cbFAI.Text = "(check if required)"; 
            this.txtDescription.Text = null;
            this.txtDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDescription.Height = 50;                   
          
            //Revision Type
            //DataTable _tempRevisionType = new DataTable();
            //_tempRevisionType.Columns.Add("Code", Type.GetType("System.String"));
            //_tempRevisionType.Columns.Add("Description", Type.GetType("System.String"));
            //_tempRevisionType.Rows.Add("-NONE-", "-NONE-");
            //_tempRevisionType.Merge(DataAccess.GetRecords(DataQueries.GetQRevType()), true);
            //this.ddlRevisionType.DataSource = _tempRevisionType;
            //this.ddlRevisionType.DataTextField = "Description";
            //this.ddlRevisionType.DataValueField = "Code";
            //this.ddlRevisionType.DataBind();

            //Revision Status
            DataTable _tempRevisionStatus = new DataTable();
            _tempRevisionStatus.Columns.Add("Code", Type.GetType("System.String"));
            _tempRevisionStatus.Columns.Add("Description", Type.GetType("System.String"));
            _tempRevisionStatus.Rows.Add("-NONE-", "-NONE-");
            _tempRevisionStatus.Merge(DataAccess.GetRecords(DataQueries.GetQRevStatus()), true);
            this.ddlRevisionStatus.DataSource = _tempRevisionStatus;
            this.ddlRevisionStatus.DataTextField = "Description";
            this.ddlRevisionStatus.DataValueField = "Code";
            this.ddlRevisionStatus.DataBind();
            
            this.gvAddPartsInfo.EnableViewState = false;
            this.gvAddPartsInfo.Controls.Clear();
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
            if (EditView == FORM_ON.View)
            {
              
                                
                //Set Read Only 
                this.txtPartNumber.ReadOnly = true;                
                this.txtRevision.ReadOnly =true;
                this.txtWaferPartNumber.ReadOnly =true;
                this.cbFAI.Enabled = false;
                this.txtFAIDate.ReadOnly = true; 
                this.txtStartDate.ReadOnly = true;
                this.txtExpiryDate.ReadOnly =true;
                this.txtRevisionStatus.ReadOnly =true;
                this.txtRelatedFile.ReadOnly = true;
                this.txtDescription.ReadOnly = true;
                
                //Hide Edit Controls                
                //this.ddlRevisionType.Visible = false;
                this.ucFAIDate.Visible = false; 
                this.ucDateStart.Visible = false;
                this.ucExpiryDate.Visible = false;
                this.ddlRevisionStatus.Visible = false;
                
                //Show View Controls
                this.txtRevision.Visible = true;
                this.txtWaferPartNumber.Visible = true;
                this.txtFAIDate.Visible = true; 
                this.txtStartDate.Visible = true;
                this.txtExpiryDate.Visible = true;
                this.txtRevisionStatus.Visible = true;
                this.txtRelatedFile.Visible = true;

            }//end if - VIEW

            if (EditView ==FORM_ON.Edit)
            {
                
               
                //Reset the Read Only
                this.txtRevision.ReadOnly = false; 
                this.txtPartNumber.ReadOnly = false;
                this.cbFAI.Enabled = true; 
                this.txtDescription.ReadOnly = false;

                //Hide View Controls                
                this.txtWaferPartNumber.Visible = false;
                this.txtFAIDate.Visible = false; 
                this.txtStartDate.Visible = false;
                this.txtExpiryDate.Visible = false;
                this.txtRevisionStatus.Visible = false;
                this.txtRelatedFile.Visible = false;               

                //Show Edit Controls               
                //this.ddlRevisionType.Visible = true;
                this.ucFAIDate.Visible = true;  
                this.ucDateStart.Visible = true;
                this.ucExpiryDate.Visible = true;
                this.ddlRevisionStatus.Visible = true;               
               
                //Initialize from View Controls
                this.ucFAIDate.SelectedDate = this.txtFAIDate.Text;
                this.ucDateStart.SelectedDate = this.txtStartDate.Text;
                this.ucExpiryDate.SelectedDate = this.txtExpiryDate.Text;

                ListItem liSelectedItem =null;               
                    
                //liSelectedItem =this.ddlRevisionType.Items.FindByText(this.txtWaferPartNumber.Text.Trim());
                //this.ddlRevisionType.SelectedIndex =this.ddlRevisionType.Items.IndexOf(liSelectedItem);                    
                           
                liSelectedItem = this.ddlRevisionStatus.Items.FindByText(this.txtRevisionStatus.Text.Trim());
                this.ddlRevisionStatus.SelectedIndex =this.ddlRevisionStatus.Items.IndexOf(liSelectedItem);                

            } //end if                                  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }   

}