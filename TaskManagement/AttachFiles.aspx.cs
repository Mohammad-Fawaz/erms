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

public partial class TaskManagement_AttachFiles : System.Web.UI.Page
{    
    public String _SID;
    public String _SessionUser;
    public Int32 _TID;   
   
    protected void Page_Load(object sender, EventArgs e)
    { 
        this.lblStatus.Text = null;
        this.lblfUploadStatus.Text = null;
        
        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            //Get Task Order ID
            if (Request.QueryString["TID"] != null)
            {
                _TID = Convert.ToInt32(Request.QueryString["TID"]);
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);              
            }

            this.GetAttachedFiles(_TID); 
            this.hlnkReturnLink.NavigateUrl = "~/TaskManagement/TaskInformation.aspx?SID=" + _SID + "&TID=" + _TID;
            this.hlnkWFTaskReturnLink.NavigateUrl = "~/WorkFlowManagement/WFTaskInformationReview.aspx?SID=" + _SID + "&TID=" + _TID;   
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

        this.GetAttachedFiles(_TID); 
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
            String _refType = Constants.TaskFileReferenceType;  //"DFILE";           
            String _refID = _TID.ToString();

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

                //if (Utils.IsRequiredField("AttRefs", "FileName") && String.IsNullOrEmpty(_fName))
                //{
                //    throw new Exception("A [File Name] could not be located or created. The record will not be saved.");
                //} 
             
                _fLocation = _fPath;
                _fLocation = _fLocation.Replace(_fName, "");
                _fLocation = _fLocation.Replace("'", "''");
                _fLink = Utils.GetFileLink(_fLocation);

                //Verify the File Existence
                if (!File.Exists(_fPath))
                {
                    if (Utils.IsRequiredField("AttRefs", "AttFLoc"))
                    {
                        throw new Exception("The file " + _fName + " could not be located at " + _fLocation +
                                            ". The File Location is a required field and without this information the record " +
                                            "cannot be saved. Please try again !");
                    }
                }

                //Get other required parameters.
                String _fType = _fName.Substring(_fName.LastIndexOf('.'));
                Boolean _WebView = false;
                if (this.cbAFWView.Checked)
                {
                    _WebView = true;
                }      
                                
                String _fDesc = null;
                _fDesc = this.txtFileDescription.Text;

                String _PrintSize = null;
                if (this.ddlPrintSize.SelectedItem.Text != "-NONE-")
                {
                    _PrintSize = this.ddlPrintSize.SelectedItem.Value;
                }

                String _PrintLoc = null;
                if (this.ddlPrintLocation.SelectedItem.Text != "-NONE-")
                {
                    _PrintLoc = this.ddlPrintLocation.SelectedItem.Value;
                }

                String _UploadedBy = _SessionUser;
                DateTime _UploadedOn = DateTime.Now;
                     
                //Get Upload Path from Configuration
                Int32 _rowCount = 0;
                String _fUploadPath = null;
                using (DataTable _tempPath = DataAccess.GetRecords(DataQueries.GetAttDefs(_refType, null)))
                {
                    _rowCount = _tempPath.Rows.Count;
                    if (_rowCount > 0)
                    {
                        _fUploadPath = _tempPath.Rows[0]["Path"].ToString();
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
                if (!String.IsNullOrEmpty(_fUploadPath))
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
                     _Status = DataAccess.ModifyRecords(
                                                DataQueries.InsertAttRefsFile(Constants.TaskFileReferenceType, _refID, _fName, _fType,
                                                                              _fLocation, _fLink, _fDesc,
                                                                              _PrintSize, _PrintLoc, _WebView,
                                                                              _UploadedOn, _UploadedBy));
                     _StatusMsg += " and saved";
                }

                //Update Record
                if (this.btnAddEditSave.Text == "Save")
                {
                     
                    Int32 _FileID = Convert.ToInt32(this.hdnFileID.Value);
                    _Status = DataAccess.ModifyRecords(
                                                DataQueries.UpdateAttRefsFile(Constants.TaskFileReferenceType, _refID, _fName, _fType,
                                                                              _fLocation, _fLink, _fDesc,
                                                                              _PrintSize, _PrintLoc, _WebView,
                                                                              _UploadedOn, _UploadedBy, _FileID));
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

        this.GetAttachedFiles(_TID);
    }

    /// <summary>
    /// File Upload Pre Render
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
    /// Get Record
    /// </summary>
    /// <param name="AttachID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 AttachID)
    {
        Int32 _rowCount = 0;
        try
        {
            using (DataTable _tempViewTasks = DataAccess.GetRecords(DataQueries.GetViewAttachByID(AttachID)))
            {
                _rowCount = _tempViewTasks.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtFileLocation.Text = _tempViewTasks.Rows[0]["Location"].ToString(); 
                                                //+ _tempViewTasks.Rows[0]["File Name"].ToString();  
                    
                    if (!String.IsNullOrEmpty(_tempViewTasks.Rows[0]["View"].ToString()))
                    {
                        this.cbAFWView.Checked = Convert.ToBoolean(_tempViewTasks.Rows[0]["View"].ToString());
                    }
                    this.txtPrintSize.Text = _tempViewTasks.Rows[0]["Print Size"].ToString();
                    this.txtPrintLocation.Text = _tempViewTasks.Rows[0]["Print Location"].ToString();
                    this.txtFileDescription.Text = _tempViewTasks.Rows[0]["File Description"].ToString();
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
    /// Get List of Attached Files for the given TaskOrder
    /// </summary>
    /// <param name="TID"></param>
    /// <returns></returns>
    private int GetAttachedFiles(int TID)
    {        
        Int32 _rowCount = 0;
        
        try
        {            
            this.gvFileResults.AutoGenerateSelectButton = true; 
            this.gvFileResults.EnableViewState = false;
            this.gvFileResults.Controls.Clear();

            using (DataTable _tempAttachFiles = DataAccess.GetRecords(DataQueries.GetViewAttachByTypeAndID(Constants.TaskFileReferenceType, TID)))
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
            Int32 _fileID = Convert.ToInt32(gvFileResults.Rows[_selectedRowIndex].Cells[1].Text);
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

            GetAttachedFiles(_TID);
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

        //QuickFix
        Int32 _colFLinkIndex = 6;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //QuickFix 
            e.Row.Cells[_colFLinkIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;
                    
            //Get Column Indexes
            DataRowView drvAttachedFiles = (DataRowView)e.Row.DataItem;            
            _colIDIndex = drvAttachedFiles.DataView.Table.Columns["ID"].Ordinal + 1;
            Int32 _colFNameIndex = drvAttachedFiles.DataView.Table.Columns["File Name"].Ordinal + 1;
            Int32 _colFDescriptionIndex = drvAttachedFiles.DataView.Table.Columns["File Description"].Ordinal + 1;
            Int32 _colFTypeIndex = drvAttachedFiles.DataView.Table.Columns["File Type"].Ordinal + 1;
            Int32 _colFLocationIndex = drvAttachedFiles.DataView.Table.Columns["Location"].Ordinal + 1;
            _colFLinkIndex = drvAttachedFiles.DataView.Table.Columns["HyperLink"].Ordinal + 1;
            Int32 _colFPszeIndex = drvAttachedFiles.DataView.Table.Columns["Print Size"].Ordinal + 1;
            Int32 _colPLocationIndex = drvAttachedFiles.DataView.Table.Columns["Print Location"].Ordinal + 1;
            Int32 _colWebViewIndex = drvAttachedFiles.DataView.Table.Columns["View"].Ordinal + 1;
            
            //Set Link  
            String _fileLink = e.Row.Cells[_colFLinkIndex].Text;
            //_fileLink = "../App_Themes/aspnet-life-cycles-events.pdf"; //for testing                      
            String _strMessage = Utils.GetDocumentRestrictionText(_TID.ToString(), Constants.TaskReferenceType);
            //Utils.GetMachineConfigurationReturnValue("ERMSDir","BROWSER","JG"); //Not Required
            if (!String.IsNullOrEmpty(_strMessage))
            {
                e.Row.Cells[_colFTypeIndex].Attributes.Add("OnClick", "Javascript:alert('" + _strMessage + "')");
            }
            e.Row.Cells[_colFTypeIndex].Text = "<a href='" +
                                                 _fileLink +
                                                "' target='_blank'>" +
                                                e.Row.Cells[_colFTypeIndex].Text +
                                                "</a>";
            
            e.Row.Cells[_colFLinkIndex].Visible = false;

            //Align    
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colFNameIndex].HorizontalAlign = HorizontalAlign.Left; 
            e.Row.Cells[_colFDescriptionIndex].HorizontalAlign = HorizontalAlign.Left; 
            e.Row.Cells[_colFTypeIndex].HorizontalAlign = HorizontalAlign.Left; 
            e.Row.Cells[_colFLocationIndex].HorizontalAlign = HorizontalAlign.Left; 
            e.Row.Cells[_colFLinkIndex].HorizontalAlign = HorizontalAlign.Left; 
            e.Row.Cells[_colFPszeIndex].HorizontalAlign = HorizontalAlign.Left; 
            e.Row.Cells[_colPLocationIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colWebViewIndex].HorizontalAlign = HorizontalAlign.Left;

            //Quick Fix
            e.Row.Cells[_colFLocationIndex].Text = e.Row.Cells[_colFLocationIndex].Text.Replace(@"\", @" \");
            
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
            this.txtPrintSize.Text = null;            
            this.txtPrintLocation.Text = null;
            this.txtFileLocation.Text = null;
            this.cbAFWView.Checked = false;
            this.cbOverwrite.Checked = false;
             
            this.cbAFWView.Text = "Web View";
            this.cbOverwrite.Text = "Overwrite";
            this.txtFileDescription.Text = null;
            this.txtFileDescription.TextMode = TextBoxMode.MultiLine;
            this.txtFileDescription.Height = 50;
 
            DataTable _tempPrintSize = new DataTable();
            _tempPrintSize.Columns.Add("Code", Type.GetType("System.String"));
            _tempPrintSize.Columns.Add("Description", Type.GetType("System.String"));
            _tempPrintSize.Rows.Add("-NONE-", "-NONE-");
            _tempPrintSize.Merge(DataAccess.GetRecords(DataQueries.GetQPrintSize()), true);
            this.ddlPrintSize.DataSource = _tempPrintSize;
            this.ddlPrintSize.DataTextField = "Description";
            this.ddlPrintSize.DataValueField = "Code";
            this.ddlPrintSize.DataBind();

             DataTable _tempPrintLocation  = new DataTable();
            _tempPrintLocation .Columns.Add("Code", Type.GetType("System.String"));
            _tempPrintLocation .Columns.Add("Description", Type.GetType("System.String"));
            _tempPrintLocation .Rows.Add("-NONE-", "-NONE-");
            _tempPrintLocation.Merge(DataAccess.GetRecords(DataQueries.GetQPrintLoc()), true);
            this.ddlPrintLocation.DataSource = _tempPrintLocation;
            this.ddlPrintLocation .DataTextField = "Description";
            this.ddlPrintLocation .DataValueField = "Code";
            this.ddlPrintLocation .DataBind();

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

                //Hide Edit Controls
                this.ddlPrintSize.Visible = false;
                this.ddlPrintLocation.Visible = false;
                this.ctrlFileUpload.Visible = false; 

                //Show View Controls
                this.txtPrintSize.Visible = true;
                this.txtPrintLocation.Visible = true;
                this.txtFileLocation.Visible= true;  
                
            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
              
                //Set Read Only    
                this.cbAFWView.Enabled = true;
                this.cbOverwrite.Enabled = true;
                this.txtFileDescription.ReadOnly = false;

                //Hide View Controls
                this.txtPrintSize.Visible = false;
                this.txtPrintLocation.Visible = false;
               
                //Show Edit Controls
                this.ddlPrintSize.Visible = true;
                this.ddlPrintLocation.Visible = true;
                this.ctrlFileUpload.Visible = true; 

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlPrintSize.Items.FindByText(this.txtPrintSize.Text.Trim());
                this.ddlPrintSize.SelectedIndex = this.ddlPrintSize.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlPrintLocation.Items.FindByText(this.txtPrintLocation.Text.Trim());
                this.ddlPrintLocation.SelectedIndex = this.ddlPrintLocation.Items.IndexOf(liSelectedItem);
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }        
    }    
}
