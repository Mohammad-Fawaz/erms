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
using System.Text;
using System.Drawing;
using System.Globalization;
using System.Collections.Generic;

/// <summary>
/// Change Order Class
/// </summary>
public partial class HelpDesk : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
        
    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblStatus.Text = null;
        Int32 ChangeID = 0;  
  
        try
        {
           
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;
            CheckFields();
            CheckDropdownVisible();
            CheckdropsdownView();
            EnabledDropsDown();
            //Get Change Order ID
            String QSChangeID = Request.QueryString["COID"];
            if (!String.IsNullOrEmpty(QSChangeID))
            {
                ChangeID = Convert.ToInt32(QSChangeID);
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                CheckFields();
                if (ChangeID > 0)
                {
                    //Change Record
                    if (GetRecord(ChangeID) > 0)
                    {
                    
                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;

                       
                    }
                    else
                    {
                        
                       
                    }
                }
                else
                {
                    //this.txtChangeID.CssClass = "CtrlShortValueEdit";
                  
                }
            }            
        }        
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }      
    }
    public void CheckFields()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
       
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAssignedFormFieldsData(31, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["Controlid"].ToString();
                if (txtDocIDs == "divRequest") { divRequest.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divtxtStatus") { divtxtStatus.Visible = true; } //else { divStatus.Visible = false; }
                /* if (txtDocIDs == "divtxtStartDate") { divtxtEndDate.Visible = true; }*/ //else { divRevision.Visible = false; }
                if (txtDocIDs == "divRequestType") { divRequestType.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divPriority") { divPriority.Visible = true; }
                if (txtDocIDs == "divtxtRequestBy") { divtxtRequestBy.Visible = true; }
                if (txtDocIDs == "divucDateStart") { divucDateStart.Visible = true; }
                if (txtDocIDs == "divDepartment") { divDepartment.Visible = true; }
                if (txtDocIDs == "divSupervisor") { divSupervisor.Visible = true; }
                if (txtDocIDs == "divtxtDueDate") { divtxtDueDate.Visible = true; }
                //
                if (txtDocIDs == "divProject") { divProject.Visible = true; }
                if (txtDocIDs == "divtxtDescription") { divtxtDescription.Visible = true; }
                //For Buttons
                if (txtDocIDs == "btnFinds") { btnFinds.Visible = true; }
                if (txtDocIDs == "btnNewEditSaves") { btnNewEditSaves.Visible = true; }
                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }


            }

        }

    }
    public void CheckDropdownVisible()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowDropdowns(RoleId, 31)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {
                int a = 0;
                string txtDocIDs = row["MasterID"].ToString();
                if (txtDocIDs == "divhlnkNotes") { divhlnkNotes.Visible = true; a = 0; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divhlnkAttachFiles") { divhlnkAttachFiles.Visible = true; a = 0; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divhlnkWFTasks") { divhlnkWFTasks.Visible = true; a = 0; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "divhlnkWFCustom") { divhlnkWFCustom.Visible = true; a = 0; } //else { divExpires.Visible = false; }
            
               
            }
        }

    }
    public void CheckdropsdownView()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.visibleDropDown(RoleId, 31)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; }






            }

        }
    }

    public void EnabledDropsDown()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.EnabledDropDown(RoleId, 31)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; }






            }

        }

    }
    /// <summary>
    /// Set all Navigation URLs
    /// </summary>
 
    
    /// <summary>
    /// Cancel Order
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearRecord();
        btnNewEditSaves.Text = "New Request";
        CheckFields();
        CheckDropdownVisible();
        CheckdropsdownView();
        EnabledDropsDown();
    }
    public void ClearRecord()
    {
        this.txtStatus.Text = "";
        this.txtRequestType.Text = "";
        this.txtPriority.Text = "";
        this.txtRequestBy.Text = "";
        this.txtboxDepartment.Text = "";
        this.txtSupervisor.Text = "";
        this.txtDueDate.Text = "";
        this.txtProject.Text = "";
        ucDateStart.Text = "";
        this.txtDescription.Text = "";
    }
    /// <summary>
    /// Find Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnFind_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 ChangeID = 0;
            String _ChangeID = this.txtRequest.Text.Trim();
            if (!String.IsNullOrEmpty(_ChangeID))
            {
                ChangeID = Convert.ToInt32(_ChangeID);
            }
            if (GetRecord(ChangeID) > 0)
            {
                GetRecord(ChangeID);
                btnNewEditSaves.Text = "Update";
                btnDelete.Visible = true;
            }
            else
            {
                lblStatus.Text = "No Record Found";
                ClearRecord();
                btnDelete.Visible = false;
            }


            }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    private Int32 GetRecord(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewChanges = DataAccess.GetRecords(DataQueries.GetViewChangesByIDsHelpdesk(COID)))
            {
                _rowCount = _tempViewChanges.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtStatus.Text = _tempViewChanges.Rows[0]["Status"].ToString();
                    ddlRequestType.SelectedItem.Text = _tempViewChanges.Rows[0]["RequestType"].ToString();
                    this.txtPriority.Text = _tempViewChanges.Rows[0]["Priority"].ToString();
                    this.txtRequestBy.Text = _tempViewChanges.Rows[0]["RequestBy"].ToString();

                    String _StartDate = _tempViewChanges.Rows[0]["RequestDate"].ToString();
                    if (!String.IsNullOrEmpty(_StartDate) && Constants.DateTimeMinimum != _StartDate)
                    {
                       // this.txtRequestDate.Text = Convert.ToDateTime(_StartDate).ToShortDateString();
                        ucDateStart.Text = Convert.ToDateTime(_StartDate).ToString("yyyy-MM-dd");
                    }

                        

                        this.txtboxDepartment.Text = _tempViewChanges.Rows[0]["Department"].ToString();
                    this.txtSupervisor.Text = _tempViewChanges.Rows[0]["Supervisor"].ToString();
                  //  this.txtDueDate.Text = _tempViewChanges.Rows[0]["DueDate"].ToString();
                    String _EndDate = _tempViewChanges.Rows[0]["DueDate"].ToString();
                    if (!String.IsNullOrEmpty(_EndDate) && Constants.DateTimeMinimum != _EndDate)
                    {
                        this.txtDueDate.Text = Convert.ToDateTime(_EndDate).ToString("yyyy-MM-dd");
                    }
                    this.txtProject.Text = _tempViewChanges.Rows[0]["Project"].ToString();

                    this.txtDescription.Text = _tempViewChanges.Rows[0]["Description"].ToString();
            
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
    /// New / Edit / Save
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnNewEditSave_Click(object sender, EventArgs e)
    {
        if(ucDateStart.Text=="")
        {
            ucDateStart.Text = "1/01/2000 12:00:00 AM";
            txtDueDate.Text= "1/01/2000 12:00:00 AM";
        }
        DateTime Startdate = Convert.ToDateTime(ucDateStart.Text);
        DateTime DueDate = Convert.ToDateTime(txtDueDate.Text);
       
        if (btnNewEditSaves.Text== "Save")
        { 
        DataAccess.ModifyRecords(DataQueries.Insert_HelpDesk(Convert.ToInt32(txtRequest.Text.Trim()), txtStatus.Text.Trim(), ddlRequestType.SelectedItem.Text, txtPriority.Text.Trim(), txtRequestBy.Text.Trim(),
            Convert.ToDateTime(ucDateStart.Text), txtboxDepartment.Text.Trim(), txtSupervisor.Text.Trim(), Convert.ToDateTime(txtDueDate.Text), txtProject.Text.Trim(), txtDescription.Text.Trim()));
            lblStatus.Text = "Succesfully Save";
            lblStatus.ForeColor = System.Drawing.Color.Green;
            btnNewEditSaves.Text = "New Request";
        }
        if (btnNewEditSaves.Text == "Update")
        {
            if(txtRequest.Text.Trim()!="")
            { 
            DataAccess.ModifyRecords(DataQueries.UpdateChangesRequestHelpdesk(Convert.ToInt32(txtRequest.Text.Trim()), txtStatus.Text.Trim(), ddlRequestType.SelectedItem.Text, txtPriority.Text.Trim(), txtRequestBy.Text.Trim(),
                Convert.ToDateTime(ucDateStart.Text), txtboxDepartment.Text.Trim(), txtSupervisor.Text.Trim(), Convert.ToDateTime(txtDueDate.Text), txtProject.Text.Trim(), txtDescription.Text.Trim()));
               btnNewEditSaves.Text = "New Request";
                lblStatus.Text = "Succesfully Update";
                lblStatus.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblStatus.Text = "Enter Request No";
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }
        if (btnNewEditSaves.Text == "New Request")
        {
            using (DataTable _tempViewChanges = DataAccess.GetRecords(DataQueries.getmaxHelpdeskid()))
            {
                Int32 _rowCount = _tempViewChanges.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtRequest.Text = _tempViewChanges.Rows[0]["Maxid"].ToString();
                    ucDateStart.Text = DateTime.Now.ToString();
                    txtDueDate.Text = DateTime.Now.ToString();
                    divhlnkWFCustom.Visible = false;
                    divhlnkWFTasks.Visible = false;
                }
            }
                    btnNewEditSaves.Text = "Save";
            
            ClearRecord();
        }
    }

    /// <summary>
    /// Delete Change Order and Associated Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        if (!String.IsNullOrEmpty(txtRequest.Text.Trim()))
        {
            DataAccess.ModifyRecords(DataQueries.DeleteRequestHelpDESK(txtRequest.Text.Trim()));
            lblStatus.Text = "Succesfully Delete";
            lblStatus.ForeColor = System.Drawing.Color.Red;
        }
        }

    /// <summary>
    /// On Change of Approved By 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlApprovedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }

    /// <summary>
    /// On Change of Assigned To
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlAssignedTo_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }

    /// <summary>
    /// On Change of Completed By
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlCompletedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }

    /// <summary>
    /// On Change of Released BY
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlReleasedBy_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }
    
    /// <summary>
    /// Get Record Values
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetRecords(Int32 COID)
    {
        Int32 _rowCount = 0;
              
        try
        {
            using (DataTable _tempViewChanges = DataAccess.GetRecords(DataQueries.GetViewChangesByID(COID)))
            {
                _rowCount = _tempViewChanges.Rows.Count;

                if (_rowCount > 0)
                {
                    //this.txtChangeID.Text = _tempViewChanges.Rows[0]["Change ID"].ToString();
                    //this.txtStatus.Text = _tempViewChanges.Rows[0]["Change Status"].ToString();
                    //this.txtChangeClass.Text = _tempViewChanges.Rows[0]["Change Class"].ToString();
                    //this.txtChangeType.Text = _tempViewChanges.Rows[0]["Change Type"].ToString();

                    String _StartDate = _tempViewChanges.Rows[0]["Start Date"].ToString();
                    //if (!String.IsNullOrEmpty(_StartDate) && Constants.DateTimeMinimum != _StartDate)
                    //{
                    //    this.txtStartDate.Text = Convert.ToDateTime(_StartDate).ToShortDateString();
                    //}

                    //String _EndDate = _tempViewChanges.Rows[0]["End Date"].ToString();
                    //if (!String.IsNullOrEmpty(_EndDate) && Constants.DateTimeMinimum != _EndDate)
                    //{
                    //    this.txtEndDate.Text = Convert.ToDateTime(_EndDate).ToShortDateString();
                    //}


                 //   this.txtJustification.Text = _tempViewChanges.Rows[0]["Justification"].ToString();
                 ////   this.txtProject.Text = _tempViewChanges.Rows[0]["Project"].ToString();
                 //   this.txtDescription.Text = _tempViewChanges.Rows[0]["Change Description"].ToString();



                    String _DateRequestedBy = _tempViewChanges.Rows[0]["Change Requested Date"].ToString();
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
            //this.gvAssociatedDocs.CssClass = "GridViewStyleView";
            //this.gvAssociatedDocs.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvAssociatedDocs.RowStyle.CssClass = "GridViewStyleView";

        }

        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }      

         return _rowCount;      
    }
    
  

    /// <summary>
    /// Get Notes
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
   
  

    /// <summary>
    /// Get Change Impact
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    

    /// <summary>
    /// Material Disposition Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
   
    
    /// <summary>
    /// Initialize Page
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
           

         

         

           

           

          

            //using (DataTable _tempUserInfo = new DataTable())
            //{
            //    _tempUserInfo.Columns.Add("User ID", Type.GetType("System.String"));
            //    _tempUserInfo.Columns.Add("User Name", Type.GetType("System.String"));
            //    _tempUserInfo.Rows.Add("-NONE-", "-NONE-");
            //    _tempUserInfo.Merge(DataAccess.GetRecords(DataQueries.GetQUserInfo()), true);

            //    this.ddlRequestedBy.DataSource = _tempUserInfo;
            //    this.ddlRequestedBy.DataTextField = "User Name";
            //    this.ddlRequestedBy.DataValueField = "User ID";
            //    this.ddlRequestedBy.DataBind();

            //    this.ddlApprovedBy.DataSource = _tempUserInfo;
            //    this.ddlApprovedBy.DataTextField = "User Name";
            //    this.ddlApprovedBy.DataValueField = "User ID";
            //    this.ddlApprovedBy.DataBind();

            //    this.ddlAssignedTo.DataSource = _tempUserInfo;
            //    this.ddlAssignedTo.DataTextField = "User Name";
            //    this.ddlAssignedTo.DataValueField = "User ID";
            //    this.ddlAssignedTo.DataBind();

            //    this.ddlCompletedBy.DataSource = _tempUserInfo;
            //    this.ddlCompletedBy.DataTextField = "User Name";
            //    this.ddlCompletedBy.DataValueField = "User ID";
            //    this.ddlCompletedBy.DataBind();

            //    this.ddlReleasedBy.DataSource = _tempUserInfo;
            //    this.ddlReleasedBy.DataTextField = "User Name";
            //    this.ddlReleasedBy.DataValueField = "User ID";
            //    this.ddlReleasedBy.DataBind();
            //}
                        
            //Register Script for Delete Button
            this.btnDelete.OnClientClick = "GetChangeDeleteUserConf()";
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Initialize Grid Views
    /// </summary>
    private void InitializeGrids()
    {
        try
        {
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);  
        } 
    }

    /// <summary>
    /// Set Page to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void GetGrids(Int32 COID)
    {
        GetAssociatedDocs(COID);
        //GetAttachedFiles(COID);
        GetAddedNotes(COID);
        //GetChangeImpact(COID);
        //GetMaterialDispositionInfo(COID);
        //GetWFTasks(Constants.ChangeReferenceType, COID.ToString());
        //GetCustomFieldsInfo(COID.ToString());

    }

    private Int32 GetAddedNotes(Int32 COID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvNotes.CssClass = "GridViewStyleView";
            //this.gvNotes.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvNotes.RowStyle.CssClass = "GridViewStyleView";
            this.gvNotes.AutoGenerateDeleteButton = true;
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

    protected void gvNotes_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }

    protected void gvNotes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }

    protected void gvWFTasks_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }

    protected void gvWFTasks_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }

    protected void gvWFTasks_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {

    }

    protected void gvAttachedFiles_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
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

            //QuickFix 
            //Int32 _colFLinkIndex = drvAttachedFiles.DataView.Table.Columns["HyperLink"].Ordinal + 1;


            Int32 _colFPszeIndex = drvAttachedFiles.DataView.Table.Columns["Print Size"].Ordinal + 1;
            Int32 _colPLocationIndex = drvAttachedFiles.DataView.Table.Columns["Print Location"].Ordinal + 1;
            Int32 _colWebViewIndex = drvAttachedFiles.DataView.Table.Columns["View"].Ordinal + 1;

            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Align    
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
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
            e.Row.Cells[_colFLinkIndex].Visible = false;
        }
    }

    protected void gvAttachedFiles_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 ChangeID = 0;
        String _ChangeID = this.txtRequest.Text;
        if (!String.IsNullOrEmpty(_ChangeID))
        {
            ChangeID = Convert.ToInt32(_ChangeID);
        }
        //GetAttachedFiles(ChangeID);

        if (gvAttachedFiles.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 AttachID = Convert.ToInt32(gvAttachedFiles.Rows[e.RowIndex].Cells[1].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteAttRefsByID(AttachID));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! File was detached";
            }
        }

        GetGrids(ChangeID);
    }
}
