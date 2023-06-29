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
using System.Drawing;
using System.Collections.Generic;
using System.IO;

public partial class DocumentManagement_AttachFiles : System.Web.UI.Page
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
        this.lblfUploadStatus.Text = null;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            //Get Document Order ID
            if (Request.QueryString["DOCID"] != null)
            {
                _DOCID = Request.QueryString["DOCID"];
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);

                if (Request.QueryString["FID"] != null)
                {
                    int _fileID = Convert.ToInt32(Request.QueryString["FID"]);
                    this.hdnFileID.Value = _fileID.ToString();

                    this.hlnkFileSecurity.NavigateUrl = "~/Common/FileSecurity.aspx?SID=" + _SID + "&RefID=" + _fileID.ToString();
                    this.hlnkFileSecurity.Target = "_blank";

                    if (GetRecord(_fileID) > 0)
                    {
                        SetForm(FORM_ON.View);
                        this.btnAddEditSave.Text = "Edit File";
                        this.btnCancel.Visible = true;
                        this.hlnkFileSecurity.Visible = true;
                    }
                }
            }

            this.GetAttachedFiles(_DOCID);
            this.hlnkReturnLink.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + _DOCID;
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }
    }

    /// <summary>
    /// Cancel
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        if (this.btnAddEditSave.Text == "Edit File")
        {
            InitializeFormFields();
            this.btnAddEditSave.Text = "Add File";
            this.btnCancel.Visible = false;
            this.hlnkFileSecurity.Visible = false;
            SetForm(FORM_ON.View);
        }

        if (this.btnAddEditSave.Text == "Upload")
        {
            InitializeFormFields();
            this.btnAddEditSave.Text = "Add File";
            this.btnCancel.Visible = false;
            this.hlnkFileSecurity.Visible = false;
            SetForm(FORM_ON.View);
        }

        if (this.btnAddEditSave.Text == "Save")
        {
            this.btnAddEditSave.Text = "Edit File";
            GetRecord(Convert.ToInt32(this.hdnFileID.Value));
            SetForm(FORM_ON.View);
        }

        this.GetAttachedFiles(_DOCID);
    }

    /// <summary>
    /// Upload File
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAddEditSave_Click(object sender, EventArgs e)
    {
        if (this.btnAddEditSave.Text == "Add File")
        {
            InitializeFormFields();
            this.btnAddEditSave.Text = "Upload";
            this.btnCancel.Visible = true;
            this.hlnkFileSecurity.Visible = false;
            SetForm(FORM_ON.Edit);
        }
        else if (this.btnAddEditSave.Text == "Edit File")
        {
            this.btnAddEditSave.Text = "Save";
            SetForm(FORM_ON.Edit);
            this.txtFileLocation.Visible = true;
        }
        else if (this.btnAddEditSave.Text == "Upload" || this.btnAddEditSave.Text == "Save")
        {
            String _refType = "DFILE";
            String _refID = _DOCID;

            try
            {
                Int32 _fileID = 0;
                if (!String.IsNullOrEmpty(this.hdnFileID.Value))
                {
                    _fileID = Convert.ToInt32(this.hdnFileID.Value);
                }

                //Get File Path and Name
                String _fPath = null;
                String _fName = null;
                String _fLocation = null;
                String _fLink = null;
                if (this.ctrlFileUpload.PostedFile != null)
                {
                    if (!String.IsNullOrEmpty(this.ctrlFileUpload.PostedFile.FileName))
                    {
                        _fPath = this.ctrlFileUpload.PostedFile.FileName;
                        _fName = this.ctrlFileUpload.FileName;
                    }
                }

                if (String.IsNullOrEmpty(_fName) && !String.IsNullOrEmpty(this.txtFileLocation.Text))
                {
                    _fPath = this.txtFileLocation.Text;
                    Int32 _fPathLastIndex = _fPath.LastIndexOf("\\") - 1;
                    _fPathLastIndex += 2; //Add Length of the Search Character
                    _fName = _fPath.Remove(0, _fPathLastIndex);
                }

                if (String.IsNullOrEmpty(_fName) || String.IsNullOrEmpty(_fPath))
                {
                    throw new Exception("The [File Location]/[File Name] could not be located. The record will not be saved.");
                }

                if (Utils.IsRequiredField("DocFiles", "FileName") && String.IsNullOrEmpty(_fName))
                {
                    throw new Exception("A [File Name] could not be located or created. The record will not be saved.");
                }

                _fLocation = _fPath;
                _fLocation = _fLocation.Replace(_fName, "");
                _fLocation = _fLocation.Replace("'", "''");

                if (Utils.IsRequiredField("DocFiles", "FileLocation") && String.IsNullOrEmpty(_fLocation))
                {
                    throw new Exception("A [File Location] could not be located or created. The record will not be saved.");
                }

                //_fLink = Utils.GetFileLink(_fLocation);

                //Verify the File Existence
                if (!File.Exists(_fPath))
                {
                    if (Utils.IsRequiredField("DocFiles", "FileLocation"))
                    {
                        throw new Exception("The file " + _fName + " could not be located at " + _fLocation +
                                            ". The File Location is a required field and without this information the record " +
                                            "cannot be saved. Please try again !");
                    }
                }

                //Get other required parameters.
                String _fType = _fName.Substring(_fName.LastIndexOf('.'));
                _fType = _fType.Replace(".", "").ToUpper();
                if (Utils.IsRequiredField("DocFiles", "FileType") && String.IsNullOrEmpty(_fType))
                {
                    throw new Exception("A [File Type] could not be located or created. The record will not be saved.");
                }

                Boolean _WebView = false;
                if (this.cbAFWView.Checked)
                {
                    _WebView = true;
                }

                String _fileCreatedBy = null;
                if (this.ddlCreatedBy.SelectedItem.Text != "-NONE-")
                {
                    _fileCreatedBy = this.ddlCreatedBy.SelectedItem.Text;
                }
                else
                {
                    if (Utils.IsRequiredField("DocFiles", "FileCreatedBy"))
                    {
                        throw new Exception("The person [Created By] could not be located or created. The record will not be saved.");
                    }
                }

                DateTime _fileCreatedDate;
                if (!String.IsNullOrEmpty(this.ucDateCreatedBy.SelectedDate) &&
                    !String.IsNullOrEmpty(_fileCreatedBy) && _fileCreatedBy != "-NONE-")
                {
                    _fileCreatedDate = Convert.ToDateTime(this.ucDateCreatedBy.SelectedDate);
                }
                else
                {
                    if (Utils.IsRequiredField("DocFiles", "FileCreated"))
                    {
                        throw new Exception("A [Created Date] could not be located or created. The record will not be saved.");
                    }
                    else
                    {
                        _fileCreatedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                    }
                }

                String _fileStatus = null;
                if (this.ddlStatus.SelectedItem.Text != "-NONE-")
                {
                    _fileStatus = this.ddlStatus.SelectedItem.Value;
                }
                else
                {
                    if (Utils.IsRequiredField("DocFiles", "FileStatus"))
                    {
                        throw new Exception("A [Status] could not be located or created. The record will not be saved.");
                    }
                }

                String _fDesc = null;
                _fDesc = this.txtFileDescription.Text;
                if (Utils.IsRequiredField("DocFiles", "FileDesc") && String.IsNullOrEmpty(_fDesc))
                {
                    throw new Exception("A [Description] could not be located or created. The record will not be saved.");
                }

                String _printSize = null;
                if (this.ddlPrintSize.SelectedItem.Text != "-NONE-")
                {
                    _printSize = this.ddlPrintSize.SelectedItem.Value;
                }
                if (Utils.IsRequiredField("DocFiles", "PSize") && String.IsNullOrEmpty(_printSize))
                {
                    throw new Exception("A [Print Size] could not be located or created. The record will not be saved.");
                }

                String _printLoc = null;
                if (this.ddlPrintLocation.SelectedItem.Text != "-NONE-")
                {
                    _printLoc = this.ddlPrintLocation.SelectedItem.Value;
                }
                if (Utils.IsRequiredField("DocFiles", "PLoc") && String.IsNullOrEmpty(_printLoc))
                {
                    throw new Exception("A [Print Location] could not be located or created. The record will not be saved.");
                }

                //Get Upload Path from Configuration
                Int32 _rowCount = 0;
                String _fUploadPath = null;
                using (DataTable _tempPath = DataAccess.GetRecords(DataQueries.GetAttDefs(_refType, null)))
                {
                    _rowCount = _tempPath.Rows.Count;
                    if (!string.IsNullOrEmpty(_fPath) && String.IsNullOrEmpty(this.ctrlFileUpload.PostedFile.FileName))
                    {
                        _fUploadPath = _fPath;
                    }
                    else if (_rowCount > 0)
                    {
                        string attachNetworkPath = ConfigurationManager.AppSettings["AttachNetworkPath"];
                        _fUploadPath = attachNetworkPath + _tempPath.Rows[0]["Path"].ToString();
                        _fName = "D" +Utils.GetRandomNumber() + "_" + _fName;
                        _fUploadPath = _fUploadPath + _fName;
                    }
                    else
                    {
                        throw new Exception("The [Upload Path] could not be located. The record will not be saved.");
                    }
                }

                //Check for Existence in Destination
                if (File.Exists(_fUploadPath) && !this.cbOverwrite.Checked)
                {
                    throw new Exception("File already Exists !.");
                }

                //Upload
                String _StatusMsg = null;
                Int32 _Status = 0;
                if (!String.IsNullOrEmpty(_fUploadPath) && String.IsNullOrEmpty(this.ctrlFileUpload.PostedFile.FileName))
                {
                    _StatusMsg = "Success ! File " + _fName.ToUpper() + " has been uploaded ";
                }
                else if (!String.IsNullOrEmpty(_fUploadPath))
                {
                    this.ctrlFileUpload.SaveAs(_fUploadPath);
                    _StatusMsg = "Success ! File " + _fName.ToUpper() + " has been uploaded ";
                }
                else
                {
                    throw new Exception("The [Upload Path] could not be located. The record will not be saved.");
                }

                //Insert Record                
                if (this.btnAddEditSave.Text == "Upload")
                {
                    _fLocation = _fUploadPath;
                    _fLink = _fLocation;
                    _Status = DataAccess.ModifyRecords(
                                                DataQueries.InsertDocFiles(_DOCID, _fileID, _fName, _fileStatus, _fDesc, _fType,
                                                                           _fLocation, _fLink, _fileCreatedBy, _fileCreatedDate,
                                                                           _printSize, _printLoc, _WebView));
                    _StatusMsg += " and saved";
                }

                //Update Record
                if (this.btnAddEditSave.Text == "Save")
                {
                    _fLocation = _fUploadPath;
                    _fLink = _fLocation;
                    Int32 _FileID = Convert.ToInt32(this.hdnFileID.Value);
                    _Status = DataAccess.ModifyRecords(
                                                DataQueries.UpdateDocFiles(_DOCID, _fileID, _fName, _fileStatus, _fDesc, _fType,
                                                                           _fLocation, _fLink, _fileCreatedBy, _fileCreatedDate,
                                                                           _printSize, _printLoc, _WebView));
                    _StatusMsg += " and saved";
                }

                InitializeFormFields();
                this.lblfUploadStatus.Text = _StatusMsg;
                this.btnAddEditSave.Text = "Add File";
                this.btnCancel.Visible = false;
                this.hlnkFileSecurity.Visible = false;
                SetForm(FORM_ON.View);
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Failed ! " + ex.Message; //Log the messsage
            }
        }//if btn Text check

        this.GetAttachedFiles(_DOCID);
    }

    /// <summary>
    /// For New File Upload
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ctrlFileUpload_PreRender(object sender, EventArgs e)
    {
        if (this.ctrlFileUpload.PostedFile != null)
        {
            if (!String.IsNullOrEmpty(this.ctrlFileUpload.PostedFile.FileName))
            {
                this.txtFileLocation.Text = this.ctrlFileUpload.PostedFile.FileName;
            }
        }
    }

    /// <summary>
    /// On Change - Created By
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlCreatedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateCreatedBy.Text = DateTime.Now.ToString();
    }

    /// <summary>
    /// Get Record
    /// </summary>
    /// <param name="AttachID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 AttachID)
    {
        Int32 _rowCount = 0;
        try
        {
            using (DataTable _tempViewDocuments = DataAccess.GetRecords(DataQueries.GetViewDocFilesByID(AttachID)))
            {
                _rowCount = _tempViewDocuments.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtFileLocation.Text = _tempViewDocuments.Rows[0]["Location"].ToString();
                    //+ _tempViewDocuments.Rows[0]["File Name"].ToString();  

                    if (!String.IsNullOrEmpty(_tempViewDocuments.Rows[0]["View"].ToString()))
                    {
                        this.cbAFWView.Checked = Convert.ToBoolean(_tempViewDocuments.Rows[0]["View"].ToString());
                    }
                    this.txtStatus.Text = _tempViewDocuments.Rows[0]["Status"].ToString();
                    this.txtPrintSize.Text = _tempViewDocuments.Rows[0]["Print Size"].ToString();
                    this.txtPrintLocation.Text = _tempViewDocuments.Rows[0]["Print Location"].ToString();
                    this.txtFileDescription.Text = _tempViewDocuments.Rows[0]["Description"].ToString();
                    this.txtCreatedBy.Text = _tempViewDocuments.Rows[0]["Created By"].ToString();

                    String _DateCreatedBy = _tempViewDocuments.Rows[0]["Date Created"].ToString();
                    if (!String.IsNullOrEmpty(_DateCreatedBy) && Constants.DateTimeMinimum != _DateCreatedBy)
                    {
                        this.txtDateCreatedBy.Text = Convert.ToDateTime(_DateCreatedBy).ToShortDateString();
                    }
                }
            }//using
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Get List of Attached Files for the given Document
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private int GetAttachedFiles(String DOCID)
    {
        Int32 _rowCount = 0;

        try
        {
            this.gvFileResults.AutoGenerateSelectButton = true;
            this.gvFileResults.EnableViewState = false;
            this.gvFileResults.Controls.Clear();

            using (DataTable _tempAttachFiles = DataAccess.GetRecords(DataQueries.GetViewDocFilesByID(DOCID)))
            {
                _rowCount = _tempAttachFiles.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvFileResults.DataSource = _tempAttachFiles;
                    this.gvFileResults.DataBind();
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
    /// Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvFileResults_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        if (gvFileResults.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;
            Int32 _fileID = Convert.ToInt32(gvFileResults.Rows[_selectedRowIndex].Cells[2].Text);
            this.hdnFileID.Value = _fileID.ToString();

            this.hlnkFileSecurity.NavigateUrl = "~/Common/FileSecurity.aspx?SID=" + _SID + "&RefID=" + _fileID.ToString();
            this.hlnkFileSecurity.Target = "_blank";

            if (GetRecord(_fileID) > 0)
            {
                SetForm(FORM_ON.View);
                this.btnAddEditSave.Text = "Edit File";
                this.btnCancel.Visible = true;
                this.hlnkFileSecurity.Visible = true;
            }

            GetAttachedFiles(_DOCID);
        }
    }

    /// <summary>
    /// Row Data Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvFileResults_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
        Int32 _colSelectIndex = 0;
        Int32 _colIDIndex = 1;
        Int32 _colFIDIndex = 2;

        //QuickFix
        Int32 _colFLinkIndex = 8;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;
            e.Row.Cells[_colFIDIndex].Visible = false;

            //QuickFix 
            e.Row.Cells[_colFLinkIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;
            e.Row.Cells[_colFIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvAttachedFiles = (DataRowView)e.Row.DataItem;
            Int32 _colFNameIndex = drvAttachedFiles.DataView.Table.Columns["File Name"].Ordinal + 1;
            Int32 _colStatusIndex = drvAttachedFiles.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colFDescriptionIndex = drvAttachedFiles.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colFTypeIndex = drvAttachedFiles.DataView.Table.Columns["Type"].Ordinal + 1;
            Int32 _colFLocationIndex = drvAttachedFiles.DataView.Table.Columns["Location"].Ordinal + 1;
            _colFLinkIndex = drvAttachedFiles.DataView.Table.Columns["Link"].Ordinal + 1;
            Int32 _colFCreatedByIndex = drvAttachedFiles.DataView.Table.Columns["Created By"].Ordinal + 1;
            Int32 _colFCreatedDateIndex = drvAttachedFiles.DataView.Table.Columns["Date Created"].Ordinal + 1;

            ////Set Link  
            //String _fileLink = e.Row.Cells[_colFLinkIndex].Text;
            ////_fileLink = "../App_Themes/aspnet-life-cycles-events.pdf"; //for testing                      
            //String _strMessage = Utils.GetDocumentRestrictionText(_DOCID, Constants.DocReferenceType);
            ////Utils.GetMachineConfigurationReturnValue("ERMSDir","BROWSER","JG"); //Not Required
            //if (!String.IsNullOrEmpty(_strMessage))
            //{
            //    e.Row.Cells[_colFTypeIndex].Attributes.Add("OnClick", "Javascript:alert('" + _strMessage + "')");
            //}
            //e.Row.Cells[_colFTypeIndex].Text = "<a href='" +
            //                                     _fileLink +
            //                                    "' target='_blank'>" +
            //                                    e.Row.Cells[_colFTypeIndex].Text +
            //                                    "</a>";

            //Set Link  
            String _fileLink = e.Row.Cells[_colFLocationIndex].Text;
            String param = "DocumentPreview.aspx?file=" + _fileLink;
            String _strMessage = Utils.GetDocumentRestrictionText(_DOCID, Constants.DocReferenceType);
            //if (!String.IsNullOrEmpty(_strMessage))
            //{
            //    e.Row.Cells[_colFTypeIndex].Attributes.Add("OnClick", "Javascript:alert('" + _strMessage + "')");
            //}
            //e.Row.Cells[_colFTypeIndex].Text = "<a href='" +
            //                                     _fileLink +
            //                                    "' target='_blank'>" +
            //                                    e.Row.Cells[_colFTypeIndex].Text +
            //                                    "</a>";

            if (string.IsNullOrEmpty(_fileLink) || e.Row.Cells[_colFLocationIndex].Text == "&nbsp;")
            {
                e.Row.Cells[_colFTypeIndex].Text = e.Row.Cells[_colFTypeIndex].Text;
            }
            else
            {
                e.Row.Cells[_colFTypeIndex].Text = "<a href='" +
                                                     param +
                                                    "' target='_blank'>" +
                                                    e.Row.Cells[_colFTypeIndex].Text +
                                                    "</a>";

            }

            e.Row.Cells[_colFLinkIndex].Visible = false;

            //Align    
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFNameIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFLocationIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFLinkIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFCreatedByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colFCreatedDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFLocationIndex].Text = e.Row.Cells[_colFLocationIndex].Text.Replace(@"\", @" \"); //Quick Fix
            //e.Row.Cells[_colFLinkIndex].Text = e.Row.Cells[_colFLinkIndex].Text.Replace("/", @" \");
        }
    }

    /// <summary>
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            //Reset            
            this.txtStatus.Text = null;
            this.txtPrintSize.Text = null;
            this.txtPrintLocation.Text = null;
            this.txtFileLocation.Text = null;
            this.txtCreatedBy.Text = null;
            this.txtDateCreatedBy.Text = null;
            this.ucDateCreatedBy.SelectedDate = null;

            this.cbAFWView.Checked = false;
            this.cbAFWView.Text = "Web View";
            this.cbOverwrite.Checked = false;
            this.cbOverwrite.Text = "Overwrite";

            this.txtFileDescription.Text = null;
            this.txtFileDescription.TextMode = TextBoxMode.MultiLine;
            this.txtFileDescription.Height = 50;

            DataTable _tempStatus = new DataTable();
            _tempStatus.Columns.Add("Code", Type.GetType("System.String"));
            _tempStatus.Columns.Add("Description", Type.GetType("System.String"));
            _tempStatus.Rows.Add("-NONE-", "-NONE-");
            _tempStatus.Merge(DataAccess.GetRecords(DataQueries.GetQDocStatus()), true);
            this.ddlStatus.DataSource = _tempStatus;
            this.ddlStatus.DataTextField = "Description";
            this.ddlStatus.DataValueField = "Code";
            this.ddlStatus.DataBind();

            DataTable _tempPrintSize = new DataTable();
            _tempPrintSize.Columns.Add("Code", Type.GetType("System.String"));
            _tempPrintSize.Columns.Add("Description", Type.GetType("System.String"));
            _tempPrintSize.Rows.Add("-NONE-", "-NONE-");
            _tempPrintSize.Merge(DataAccess.GetRecords(DataQueries.GetQPrintSize()), true);
            this.ddlPrintSize.DataSource = _tempPrintSize;
            this.ddlPrintSize.DataTextField = "Description";
            this.ddlPrintSize.DataValueField = "Code";
            this.ddlPrintSize.DataBind();

            DataTable _tempPrintLocation = new DataTable();
            _tempPrintLocation.Columns.Add("Code", Type.GetType("System.String"));
            _tempPrintLocation.Columns.Add("Description", Type.GetType("System.String"));
            _tempPrintLocation.Rows.Add("-NONE-", "-NONE-");
            _tempPrintLocation.Merge(DataAccess.GetRecords(DataQueries.GetQPrintLoc()), true);
            this.ddlPrintLocation.DataSource = _tempPrintLocation;
            this.ddlPrintLocation.DataTextField = "Description";
            this.ddlPrintLocation.DataValueField = "Code";
            this.ddlPrintLocation.DataBind();

            DataTable _tempAppBy = new DataTable();
            _tempAppBy.Columns.Add("User ID", Type.GetType("System.String"));
            _tempAppBy.Columns.Add("User Name", Type.GetType("System.String"));
            _tempAppBy.Rows.Add("-NONE-", "-NONE-");
            _tempAppBy.Merge(DataAccess.GetRecords(DataQueries.GetQUserInfo()), true);
            this.ddlCreatedBy.DataSource = _tempAppBy;
            this.ddlCreatedBy.DataTextField = "User Name";
            this.ddlCreatedBy.DataValueField = "User ID";
            this.ddlCreatedBy.DataBind();

            this.gvFileResults.EnableViewState = false;
            this.gvFileResults.Controls.Clear();

            this.ctrlFileUpload.Focus();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Set Form on View or Edit
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                //Set Read Only    
                this.cbAFWView.Enabled = false;
                this.cbOverwrite.Enabled = false;
                this.txtPrintSize.ReadOnly = true;
                this.txtPrintLocation.ReadOnly = true;
                this.txtFileDescription.ReadOnly = true;
                this.txtFileLocation.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtCreatedBy.ReadOnly = true;
                this.txtDateCreatedBy.ReadOnly = true;

                //Hide Edit Controls
                this.ddlPrintSize.Visible = false;
                this.ddlPrintLocation.Visible = false;
                this.ctrlFileUpload.Visible = false;
                this.ddlStatus.Visible = false;
                this.ddlCreatedBy.Visible = false;
                this.ucDateCreatedBy.Visible = false;

                //Show View Controls
                this.txtPrintSize.Visible = true;
                this.txtPrintLocation.Visible = true;
                this.txtFileLocation.Visible = true;
                this.txtStatus.Visible = true;
                this.txtCreatedBy.Visible = true;
                this.txtDateCreatedBy.Visible = true;

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                //Set Read Only    
                this.cbAFWView.Enabled = true;
                this.cbOverwrite.Enabled = true;
                this.txtFileDescription.ReadOnly = false;
                this.txtFileLocation.ReadOnly = true;

                //Hide View Controls
                this.txtPrintSize.Visible = false;
                this.txtPrintLocation.Visible = false;
                this.txtStatus.Visible = false;
                this.txtCreatedBy.Visible = false;
                this.txtDateCreatedBy.Visible = false;

                //Show Edit Controls
                this.ddlPrintSize.Visible = true;
                this.ddlPrintLocation.Visible = true;
                this.ctrlFileUpload.Visible = true;
                this.ddlStatus.Visible = true;
                this.ddlCreatedBy.Visible = true;
                this.ucDateCreatedBy.Visible = true;

                //Initialize from View Controls   
                this.ucDateCreatedBy.SelectedDate = this.txtDateCreatedBy.Text;

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlStatus.Items.FindByText(this.txtStatus.Text.Trim());
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlPrintSize.Items.FindByText(this.txtPrintSize.Text.Trim());
                this.ddlPrintSize.SelectedIndex = this.ddlPrintSize.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlPrintLocation.Items.FindByText(this.txtPrintLocation.Text.Trim());
                this.ddlPrintLocation.SelectedIndex = this.ddlPrintLocation.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlCreatedBy.Items.FindByText(this.txtCreatedBy.Text.Trim());
                this.ddlCreatedBy.SelectedIndex = this.ddlCreatedBy.Items.IndexOf(liSelectedItem);
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

}
