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
using System.Globalization;

public partial class DocumentManagement_AddParts : System.Web.UI.Page
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
        Int32 _PartID = 0;
        String _PartNumber = null;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID; 

            if (Request.QueryString["DOCID"] !=null)
            {
                _DOCID = Request.QueryString["DOCID"];
            }

            if (Request.QueryString["PID"] != null)
            {
                _PartID = Convert.ToInt32(Request.QueryString["PID"]);
            }
            _PartNumber = Request.QueryString["PNR"];

            if (!IsPostBack)
            {
                InitializeFormFields();               
                GetPart(_PartID, _PartNumber);               
            }

            GetAddPartsInfo(_DOCID);
            if (!String.IsNullOrEmpty(this.txtPartNumber.Text))
            {
                GetBOMLineItems(this.txtPartNumber.Text);
            }
            
            this.hlnkAssociatedDoc.Text = _DOCID;
            this.hlnkAdd.NavigateUrl = "~/BOM/BOMCreate.aspx?SID=" + _SID;
            this.hlnkAdd.Text = "Add";
            this.hlnkCopy.NavigateUrl = "~/BOM/BOMCopy.aspx?SID=" + _SID;
            this.hlnkCopy.Text = "Copy";
            this.hlnkEdit.NavigateUrl = "~/BOM/BOMModify.aspx?SID=" + _SID;
            this.hlnkEdit.Text = "Edit"; 
            this.hlnkAssociatedDoc.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + _DOCID;
            this.hlnkReturnLink.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + _DOCID;
            this.hlnkReturnLinkSearch.NavigateUrl = "../QSearch.aspx?SID=" + _SID; 
        }      
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
    
    #region Parts

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
                
                //Vendor
                this.btnNewEditSaveVendor.Visible = false;
                this.btnCancelVendor.Visible = false; 
                InitializeFormFieldsVendor();
                SetFormVendor(FORM_ON.View);   
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
                    this.txtRevisionType.Text = "CONSTANT";                    
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
                if (this.ddlRevisionType.SelectedItem.Text != "-NONE-")
                {
                    _revisionType = this.ddlRevisionType.SelectedItem.Value;
                }
                else
                {
                    if (Utils.IsRequiredField("PartsXRef", "RevType"))
                    {
                        throw new Exception("A [Revision Type] could not be located or created. The record will not be saved.");
                    }
                }

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
                    //_dateFAI = Convert.ToDateTime(this.ucFAIDate.SelectedDate);
                    //_dateFAI = DateTime.ParseExact(this.ucFAIDate.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
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
                    //_startDate = DateTime.ParseExact(this.ucDateStart.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
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
                    //_endDate = DateTime.ParseExact(this.ucExpiryDate.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
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

                String _lifeCycleStatus = null;
                if (this.ddlLifecycleStatus.SelectedItem.Text != "-NONE-")
                {
                    _lifeCycleStatus = this.ddlLifecycleStatus.SelectedItem.Value;
                }
                else
                {
                    if (Utils.IsRequiredField("PartsXRef", "LifecycleStatus"))
                    {
                        throw new Exception("A [LifeCycle Status] could not be located or created. The record will not be saved.");
                    }
                }

                Decimal _cost = Convert.ToDecimal(0.0);
                if (!String.IsNullOrEmpty(this.txtCost.Text))
                {
                    _cost = Convert.ToDecimal(this.txtCost.Text.Replace("₹", ""));
                }
                else
                {
                    if (Utils.IsRequiredField("PartsXRef", "Cost"))
                    {
                        throw new Exception("The [Cost] could not be located or created. The record will not be saved.");
                    }
                }

                
                Int32 _StatusID = 0;
                if (this.btnNewEditSave.Text == "Save")
                {
                    _StatusID = DataAccess.ModifyRecords(DataQueries.InsertPartsXRef(_partNumber, _DOCID, _fileID, _partDescription,
                                                                                    _revisionType, _currentRevision, _revisionStatus,
                                                                                    _startDate, _endDate, _cbFAIRequired, _dateFAI, 
                                                                                    _cost, _lifeCycleStatus));
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
                    _StatusID = DataAccess.ModifyRecords(DataQueries.UpdatePartsXRef(_partNumber, _DOCID, _fileID, _partDescription,
                                                                                    _revisionType, _currentRevision, _revisionStatus,
                                                                                    _startDate, _endDate, _cbFAIRequired, _dateFAI, _partID,
                                                                                    _cost, _lifeCycleStatus));             
                }                
 
                InitializeFormFields();
                this.btnNewEditSave.Text = "Add Item";
                this.btnCancel.Visible = false;                
                SetForm(FORM_ON.View);

                //Vendor
                this.btnNewEditSaveVendor.Visible = false;
                this.btnCancelVendor.Visible = false;
                InitializeFormFieldsVendor();
                SetFormVendor(FORM_ON.View);
                
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
                    this.txtRevisionType.Text = _tempMaterial.Rows[0]["Revision Type"].ToString();
                    this.txtRevisionStatus.Text = _tempMaterial.Rows[0]["Status"].ToString();

                    String _fileName = _tempMaterial.Rows[0]["File Name"].ToString();
                    String _fileLocation = _tempMaterial.Rows[0]["File Location"].ToString();
                    String _fileLink = _tempMaterial.Rows[0]["File Link"].ToString();
                    
                    if(!String.IsNullOrEmpty(_fileName) && !String.IsNullOrEmpty(_fileLocation))
                    {
                        //this.txtRelatedFile.Text = _fileLocation + _fileName; 
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
                    this.txtLifecycleStatus.Text = _tempMaterial.Rows[0]["LifeCycleStatus"].ToString();

                    String _Cost = _tempMaterial.Rows[0]["Cost"].ToString();
                    if (String.IsNullOrEmpty(_Cost))
                    {
                        _Cost = "0";
                    }    
                    this.txtCost.Text = Convert.ToDecimal(_Cost).ToString("c");					
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
            this.hdnPartID.Value = gvAddPartsInfo.Rows[_selectedRowIndex].Cells[1].Text;
            Int32 _PartID = Convert.ToInt32(this.hdnPartID.Value);
            String _PartNumber = gvAddPartsInfo.Rows[_selectedRowIndex].Cells[2].Text;
            GetPart(_PartID, _PartNumber);  
        }
        GetAddPartsInfo(_DOCID);      
    }


    /// <summary>
    /// 
    /// </summary>
    /// <param name="PartID"></param>
    private void GetPart(Int32 PartID, String PartNumber)
    {
        SetForm(FORM_ON.View);
        SetFormVendor(FORM_ON.View);        
        InitializeFormFieldsVendor();
        if (GetRecord(PartID) > 0)
        {  
            this.btnNewEditSave.Text = "Edit";
            this.btnCancel.Visible = true;

            //Vendor            
            GetVendorPartNumbers(PartNumber);            
            this.btnNewEditSaveVendor.Visible = true;
            this.btnCancelVendor.Visible = false;
            this.btnNewEditSaveVendor.Text = "Add Vendor";
           
            //BOM
            GetBOMLineItems(PartNumber);
        }
    }
    
    /// <summary>
    /// Material Disposition Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAddPartsInfo_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colSelectIndex = 0;
        Int32 _ctrlSelectIndex = 0;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {          
            //Get Column Indexes
            DataRowView drvAParts = (DataRowView)e.Row.DataItem;
            Int32 _colPartIDIndex = drvAParts.DataView.Table.Columns["Part ID"].Ordinal + 1;
            Int32 _colPNumberIndex = drvAParts.DataView.Table.Columns["Part Number"].Ordinal + 1;
            Int32 _colCRevIndex = drvAParts.DataView.Table.Columns["Current Revision"].Ordinal + 1;
            Int32 _colDescriptionIndex = drvAParts.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colStatusIndex = drvAParts.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colRTypeIndex = drvAParts.DataView.Table.Columns["Revision Type"].Ordinal + 1;
            Int32 _colEffDateIndex = drvAParts.DataView.Table.Columns["Effective Date"].Ordinal + 1;
            Int32 _colFAIIndex = drvAParts.DataView.Table.Columns["FAI"].Ordinal + 1;
            Int32 _colFAIDateIndex = drvAParts.DataView.Table.Columns["FAI Date"].Ordinal + 1;

            //Select Button
            using (LinkButton lbSelect = (LinkButton)e.Row.Cells[_colSelectIndex].Controls[_ctrlSelectIndex])
            {
                lbSelect.Text = "<img height=15 width=15 border=0 src=../App_Themes/find.gif />";
            }

            //Format     
            e.Row.Cells[_colEffDateIndex].Text = DateTime.Parse(e.Row.Cells[_colEffDateIndex].Text).ToShortDateString();
            e.Row.Cells[_colFAIDateIndex].Text = DateTime.Parse(e.Row.Cells[_colFAIDateIndex].Text).ToShortDateString();

            //Align
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colPartIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colPNumberIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCRevIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colRTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colEffDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFAIIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFAIDateIndex].HorizontalAlign = HorizontalAlign.Center;
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

            using (DataTable _tempMDInfo = DataAccess.GetRecords(DataQueries.GetViewParts(DOCID)))
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
                this.txtRevision.ReadOnly = true;
                this.txtRevisionType.ReadOnly = true;
                this.cbFAI.Enabled = false;
                this.txtFAIDate.ReadOnly = true;
                this.txtStartDate.ReadOnly = true;
                this.txtExpiryDate.ReadOnly = true;
                this.txtRevisionStatus.ReadOnly = true;
                //this.txtRelatedFile.ReadOnly = true;
                this.txtDescription.ReadOnly = true;
                this.txtCost.ReadOnly = true;
                this.txtLifecycleStatus.ReadOnly = true;

                //Hide Edit Controls                
                this.ddlRevisionType.Visible = false;
                this.ucFAIDate.Visible = false;
                this.ucDateStart.Visible = false;
                this.ucExpiryDate.Visible = false;
                this.ddlRevisionStatus.Visible = false;
                this.ddlLifecycleStatus.Visible = false;

                //Show View Controls
                this.txtRevision.Visible = true;
                this.txtRevisionType.Visible = true;
                this.txtFAIDate.Visible = true;
                this.txtStartDate.Visible = true;
                this.txtExpiryDate.Visible = true;
                this.txtRevisionStatus.Visible = true;
                //this.txtRelatedFile.Visible = true;
                this.txtLifecycleStatus.Visible = true;

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                ListItem liSelectedItem = null;

               

                //Reset the Read Only
                this.txtRevision.ReadOnly = false;
                this.txtPartNumber.ReadOnly = false;
                this.cbFAI.Enabled = true;
                this.txtDescription.ReadOnly = false;
                this.txtCost.ReadOnly = false;

                //Hide View Controls                
                this.txtRevisionType.Visible = false;
                this.txtFAIDate.Visible = false;
                this.txtStartDate.Visible = false;
                this.txtExpiryDate.Visible = false;
                this.txtRevisionStatus.Visible = false;
                //this.txtRelatedFile.Visible = false;  
                this.txtLifecycleStatus.Visible = false;

                //Show Edit Controls               
                this.ddlRevisionType.Visible = true;
                this.ucFAIDate.Visible = true;
                this.ucDateStart.Visible = true;
                this.ucExpiryDate.Visible = true;
                this.ddlRevisionStatus.Visible = true;
                this.ddlLifecycleStatus.Visible = true;

                //Initialize from View Controls
                this.ucFAIDate.SelectedDate = this.txtFAIDate.Text;
                this.ucDateStart.SelectedDate = this.txtStartDate.Text;
                this.ucExpiryDate.SelectedDate = this.txtExpiryDate.Text;

                liSelectedItem = this.ddlRevisionType.Items.FindByText(this.txtRevisionType.Text.Trim());
                this.ddlRevisionType.SelectedIndex = this.ddlRevisionType.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlRevisionStatus.Items.FindByText(this.txtRevisionStatus.Text.Trim());
                this.ddlRevisionStatus.SelectedIndex = this.ddlRevisionStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlLifecycleStatus.Items.FindByText(this.txtLifecycleStatus.Text.Trim());
                this.ddlLifecycleStatus.SelectedIndex = this.ddlLifecycleStatus.Items.IndexOf(liSelectedItem);

            } //end if - EDIT                                  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
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
            //this.txtRelatedFile.Text = null;            
            this.txtRevision.Text = null;
            this.txtRevisionType.Text = null;
            this.txtExpiryDate.Text = null;
            this.txtRevisionStatus.Text = null;
            this.txtStartDate.Text = null;

            this.cbFAI.Checked = false;
            this.cbFAI.Text = "(check if required)";
            this.txtDescription.Text = null;
            this.txtDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDescription.Height = 50;
            this.txtLifecycleStatus.Text = null;
            this.txtCost.Text = null;

            using (DataTable _tempLifecycleStatus = new DataTable())
            {
                _tempLifecycleStatus.Columns.Add("Code", Type.GetType("System.String"));
                _tempLifecycleStatus.Columns.Add("Description", Type.GetType("System.String"));
                _tempLifecycleStatus.Rows.Add("-NONE-", "-NONE-");
                _tempLifecycleStatus.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("LifeCycleStatus")), true);
                this.ddlLifecycleStatus.DataSource = _tempLifecycleStatus;
                this.ddlLifecycleStatus.DataTextField = "Description";
                this.ddlLifecycleStatus.DataValueField = "Code";
                this.ddlLifecycleStatus.DataBind();
            }

            //Revision Type
            using (DataTable _tempRevisionType = new DataTable())
            {
                _tempRevisionType.Columns.Add("Code", Type.GetType("System.String"));
                _tempRevisionType.Columns.Add("Description", Type.GetType("System.String"));
                _tempRevisionType.Rows.Add("-NONE-", "-NONE-");
                _tempRevisionType.Merge(DataAccess.GetRecords(DataQueries.GetQRevType()), true);
                this.ddlRevisionType.DataSource = _tempRevisionType;
                this.ddlRevisionType.DataTextField = "Description";
                this.ddlRevisionType.DataValueField = "Code";
                this.ddlRevisionType.DataBind();
            }

            //Revision Status
            using (DataTable _tempRevisionStatus = new DataTable())
            {
                _tempRevisionStatus.Columns.Add("Code", Type.GetType("System.String"));
                _tempRevisionStatus.Columns.Add("Description", Type.GetType("System.String"));
                _tempRevisionStatus.Rows.Add("-NONE-", "-NONE-");
                _tempRevisionStatus.Merge(DataAccess.GetRecords(DataQueries.GetQRevStatus()), true);
                this.ddlRevisionStatus.DataSource = _tempRevisionStatus;
                this.ddlRevisionStatus.DataTextField = "Description";
                this.ddlRevisionStatus.DataValueField = "Code";
                this.ddlRevisionStatus.DataBind();
            }

            this.gvAddPartsInfo.EnableViewState = false;
            this.gvAddPartsInfo.Controls.Clear();

            this.gvBOMLineItems.EnableViewState = false;
            this.gvBOMLineItems.Controls.Clear();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    #endregion
    
    /// <summary>
    /// Get BOM Line Items
    /// </summary>
    /// <param name="PartID"></param>
    /// <returns></returns>
    private Int32 GetBOMLineItems(String PartID)
    {
        Int32 _rowCount = 0;

        try
        {
            
            //this.gvBOMLineItems.AutoGenerateSelectButton = true;
            this.gvBOMLineItems.EnableViewState = false;
            this.gvBOMLineItems.Controls.Clear();

            using (DataTable _tempBOMItems = DataAccess.GetRecords(DataQueries.GetBOMByPartID(PartID, this.txtRevision.Text)))
            {
                _rowCount = _tempBOMItems.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvBOMLineItems.DataSource = _tempBOMItems;
                    this.gvBOMLineItems.DataBind();
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
    /// BOM Line Items DataBound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvBOMLineItems_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Int32 _colSelectIndex = 0;
        Int32 _colBOMHeaderIDIndex = 0;
        Int32 _colBOMItemIDIndex = 1;
        e.Row.Cells[_colBOMHeaderIDIndex].Visible = false;
        e.Row.Cells[_colBOMItemIDIndex].Visible = false;  

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Get Column Indexes
            DataRowView drvBOMLineItems = (DataRowView)e.Row.DataItem;            
            Int32 _colSeqNoIndex = drvBOMLineItems.DataView.Table.Columns["Seq No"].Ordinal; // + 1;
            Int32 _colBOMItemNoIndex = drvBOMLineItems.DataView.Table.Columns["Item No"].Ordinal; // + 1;
            Int32 _colQtyIndex = drvBOMLineItems.DataView.Table.Columns["Qty"].Ordinal; // + 1;
            Int32 _colUOMIndex = drvBOMLineItems.DataView.Table.Columns["UOM"].Ordinal; // + 1;
            Int32 _colDescIndex = drvBOMLineItems.DataView.Table.Columns["Description"].Ordinal; // + 1;
            Int32 _colRevisionIndex = drvBOMLineItems.DataView.Table.Columns["Rev"].Ordinal; // + 1;
            Int32 _colStatusIndex = drvBOMLineItems.DataView.Table.Columns["Status"].Ordinal; // + 1;
            Int32 _colRefDesignatorIndex = drvBOMLineItems.DataView.Table.Columns["Ref Designator"].Ordinal; // + 1;                      

            //Align
            e.Row.Cells[_colSeqNoIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colBOMItemNoIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colQtyIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colUOMIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colDescIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colRevisionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colRefDesignatorIndex].HorizontalAlign = HorizontalAlign.Center;
            
            switch (this.txtRevisionStatus.Text.ToUpper())
            {
                case "DRAFT":
                    e.Row.ForeColor  = Color.Red;
                    break;
                case "PENDING":

                    if (e.Row.Cells[_colStatusIndex].Text == "ADD" ||
                        e.Row.Cells[_colStatusIndex].Text == "RNEW")
                    {
                        e.Row.ForeColor = Color.Red;
                    }

                    if (e.Row.Cells[_colStatusIndex].Text == "DEL" ||
                        e.Row.Cells[_colStatusIndex].Text == "ROLD")
                    {
                        e.Row.Font.Strikeout = true;
                    }
                    break;
                default:
                    if (e.Row.Cells[_colStatusIndex].Text == "DEL" ||
                        e.Row.Cells[_colStatusIndex].Text == "ROLD")
                    {
                        e.Row.Visible = false;
                    }                    
                    break;
            }
        }
    }      
    
    #region Vendor   

    protected void btnNewEditSaveVendor_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnNewEditSaveVendor.Text == "Add Vendor")
            {
                SetFormVendor(FORM_ON.Edit);
                this.btnNewEditSaveVendor.Text = "Save";
                this.btnCancelVendor.Visible = true;
            }             
            else if (this.btnNewEditSaveVendor.Text == "Edit")
            {                
                SetFormVendor(FORM_ON.Edit); 
                this.btnNewEditSaveVendor.Text ="Update";
                this.btnCancelVendor.Visible =true;  
            }
            else if (this.btnNewEditSaveVendor.Text == "Save" || this.btnNewEditSaveVendor.Text == "Update")
            {
                if (String.IsNullOrEmpty(this.txtPartNumber.Text))
                {
                    throw new Exception("A referencing [Part Number] could not be located. The record will not be saved.");
                }

                String _partNumber = this.txtPartNumber.Text;                 
                String _VendorPartNumber = this.txtVendorPartNumber.Text;
                if (String.IsNullOrEmpty(_VendorPartNumber))
                {
                    //if (Utils.IsRequiredField("PartsXRef", "PartNo"))
                    //{
                        throw new Exception("A [Vendor Part Number] could not be located or created. The record will not be saved.");
                    //}
                }
                
                String _VendorID = null;
                if (this.ddlVendorName.SelectedItem.Text != "-NONE-")
                {
                    _VendorID = this.ddlVendorName.SelectedItem.Value;
                }
                else
                {
                    //if (Utils.IsRequiredField("PartsXRef", "RevType"))
                    //{
                        throw new Exception("A [Vendor Name] could not be located or created. The record will not be saved.");
                    //}
                }

                String _Description = this.txtVendorDescription.Text;
                String _DataSheetLink = this.txtDataSheet.Text; 

                Int32 _StatusID = 0;
                if (this.btnNewEditSaveVendor.Text == "Save")
                {
                    _StatusID = DataAccess.ModifyRecords(
                                        DataQueries.InsertVendorPartXRef(_partNumber, _VendorPartNumber,
                                                                         _VendorID, _Description, _DataSheetLink));
                    if (_StatusID > 0) 
                        lblStatus.Text = "New Vendor Part Number Added !";
                }

                if (this.btnNewEditSaveVendor.Text == "Update")
                {
                    Int32 _ID = Convert.ToInt32(this.ddlVendorPartNumber.SelectedItem.Value);  
                    _StatusID = DataAccess.ModifyRecords(
                                        DataQueries.UpdateVendorPartXRef(_partNumber, _VendorPartNumber,
                                                                         _VendorID, _Description, _DataSheetLink, _ID));
                    if (_StatusID > 0)
                       lblStatus.Text = " Vendor Part Number " + _VendorPartNumber + " was updated !";
                }

                if (_StatusID > 0)
                {                    
                    InitializeFormFieldsVendor();
                    GetVendorPartNumbers(this.txtPartNumber.Text);
                    SetFormVendor(FORM_ON.View);
                    this.btnNewEditSaveVendor.Text = "Add Vendor";
                    this.btnCancelVendor.Visible = false;
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }
    
    /// <summary>
    /// Cancel Vendor
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancelVendor_Click(object sender, EventArgs e)
    {
        try
        {
            InitializeFormFieldsVendor();
            GetVendorPartNumbers(this.txtPartNumber.Text);
            SetFormVendor(FORM_ON.View);
            this.btnNewEditSaveVendor.Text = "Add Vendor";
            this.btnCancelVendor.Visible = false;
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }

    /// <summary>
    /// Vendor Selection Changed
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlVendorName_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            String _VendorID = ddlVendorName.SelectedItem.Value;
            GetVendorContact(_VendorID); 
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage 
        }
    }
    
    private void GetVendorContact(String VendorID)
    {
        Int32 _rowCount = 0;
        using (DataTable _tempVendorContacts = DataAccess.GetRecords(DataQueries.GetVCContactsByVendorID(VendorID)))
        {
            _rowCount = _tempVendorContacts.Rows.Count;
            if (_rowCount > 0)
            {
                this.hdnVendorID.Value = VendorID;
                this.txtVendorContactName.Text = _tempVendorContacts.Rows[0]["Description"].ToString();
                this.txtVendorContactPhone.Text = _tempVendorContacts.Rows[0]["Phone"].ToString();
                this.txtVendorContactEmail.Text = _tempVendorContacts.Rows[0]["Email"].ToString();
            }
        }
    }

    /// <summary>
    /// On Selecting Vendor PartNumber Change
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlVendorPartNumber_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Int32 _ID = Convert.ToInt32(ddlVendorPartNumber.SelectedItem.Value);
            GetVendorByID(_ID);         
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage 
        }
    }

    private void GetVendorByID(Int32 ID)
    {
        Int32 _rowCount = 0;
        using (DataTable _tempRecord = DataAccess.GetRecords(DataQueries.GetVendorPartXRefByID(ID)))
        {
            _rowCount = _tempRecord.Rows.Count;
            if (_rowCount > 0)
            {
                this.txtVendorPartNumber.Text = _tempRecord.Rows[0]["VendorPartNumber"].ToString();
                this.txtVendorName.Text = _tempRecord.Rows[0]["Vendor Name"].ToString();
                this.txtVendorContactName.Text = _tempRecord.Rows[0]["Vendor Contact Name"].ToString();
                this.txtVendorContactEmail.Text = _tempRecord.Rows[0]["Email"].ToString();
                this.txtVendorContactPhone.Text = _tempRecord.Rows[0]["Phone"].ToString();
                this.txtVendorDescription.Text = _tempRecord.Rows[0]["Description"].ToString();
                this.hlnkDataSheet.Text = _tempRecord.Rows[0]["DataSheetLink"].ToString();
                this.hlnkDataSheet.NavigateUrl = _tempRecord.Rows[0]["DataSheetLink"].ToString();
                this.hlnkDataSheet.Target = "_blank";

                SetFormVendor(FORM_ON.View);
                this.btnNewEditSaveVendor.Text = "Edit";
                this.btnCancelVendor.Visible = true;
            }
        }    
    }


    /// <summary>
    /// Get Vendor Part Numbers
    /// </summary>
    /// <param name="PartNumber"></param>
    private void GetVendorPartNumbers(String PartNumber)
    {
        // Vendor Part Numbers
        this.ddlVendorPartNumber.AutoPostBack = true;
        using (DataTable _tempVendorPartNumber = new DataTable())
        {
            _tempVendorPartNumber.Columns.Add("ID", Type.GetType("System.Int32"));
            _tempVendorPartNumber.Columns.Add("Description", Type.GetType("System.String"));
            _tempVendorPartNumber.Rows.Add(0, "-NONE-");
            _tempVendorPartNumber.Merge(DataAccess.GetRecords(DataQueries.GetVendorPartXRefByPartNumber(PartNumber)), true);
            this.ddlVendorPartNumber.DataSource = _tempVendorPartNumber;
            this.ddlVendorPartNumber.DataTextField = "Description";
            this.ddlVendorPartNumber.DataValueField = "ID";
            this.ddlVendorPartNumber.DataBind();
        }
    }
    
    /// <summary>
    /// Set Vendor Form
    /// </summary>
    /// <param name="EditView"></param>
    private void SetFormVendor(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {                
               
                //Set Read Only                
                this.txtVendorName.ReadOnly = true;
                this.txtVendorContactName.ReadOnly = true;
                this.txtVendorContactPhone.ReadOnly = true;
                this.txtVendorContactEmail.ReadOnly = true;
                this.txtVendorDescription.ReadOnly = true;               

                //Hide Edit Controls 
                this.ddlVendorName.Visible = false;
                this.txtVendorPartNumber.Visible = false;
                this.txtDataSheet.Visible = false;  

                //Show View Controls               
                this.txtVendorName.Visible = true;
                this.ddlVendorPartNumber.Visible = true;
                this.hlnkDataSheet.Visible = true;    
            
            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                ListItem liSelectedItem = null;
                               
               
                //Reset the Read Only
                this.txtVendorPartNumber.ReadOnly = false;                             
                this.txtVendorDescription.ReadOnly = false;
                                                
                //Hide View Controls
                this.txtVendorName.Visible = false;
                this.ddlVendorPartNumber.Visible = false;
                this.hlnkDataSheet.Visible = false;
 
                //Show Edit Controls
                this.ddlVendorName.Visible = true;
                this.txtVendorPartNumber.Visible = true;
                this.txtDataSheet.Visible = true;  

                //Initialize from View Controls
                liSelectedItem = this.ddlVendorName.Items.FindByText(this.txtVendorName.Text.Trim());
                this.ddlVendorName.SelectedIndex = this.ddlVendorName.Items.IndexOf(liSelectedItem);                              

            } //end if - EDIT                                  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Initialize Page
    /// </summary>
    private void InitializeFormFieldsVendor()
    {
        try
        {
            this.txtVendorPartNumber.Text = null; 
            this.txtVendorName.Text = null;           
            this.txtVendorContactName.Text = null;
            this.txtVendorContactPhone.Text = null;
            this.txtVendorContactEmail.Text = null; 
            this.txtVendorDescription.Text = null;

            this.txtDataSheet.Text = null;
            this.hlnkDataSheet.Text = null;
            this.hlnkDataSheet.NavigateUrl = null; 
            
            // Vendor Name
            this.ddlVendorName.AutoPostBack = true; 
            using (DataTable _tempVendorName = new DataTable())
            {
                _tempVendorName.Columns.Add("Code", Type.GetType("System.String"));
                _tempVendorName.Columns.Add("Description", Type.GetType("System.String"));
                _tempVendorName.Rows.Add("-NONE-", "-NONE-");
                _tempVendorName.Merge(DataAccess.GetRecords(DataQueries.GetVendCustXRefByRefType("PO")), true);
                this.ddlVendorName.DataSource = _tempVendorName;
                this.ddlVendorName.DataTextField = "Description";
                this.ddlVendorName.DataValueField = "Code";
                this.ddlVendorName.DataBind();
            }

            this.ddlVendorPartNumber.Items.Clear();  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    #endregion    
}