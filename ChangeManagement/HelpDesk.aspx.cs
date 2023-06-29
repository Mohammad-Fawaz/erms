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
using System.IO;

/// <summary>
/// Change Order Class
/// </summary>
public partial class HelpDesk : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    private Boolean _IsEditAllow = true;
    public static string currentPageName = "";

    public Boolean IsEditAllow
    {
        get { return _IsEditAllow; }
        set { _IsEditAllow = value; }
    }

    /// <summary>
    /// Page Load
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblStatus.Text = null;
        Int32 ChangeID = 0;
        currentPageName = Path.GetFileName(Request.Url.AbsolutePath);
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
                SetForm(FORM_ON.View);
                if (ChangeID > 0)
                {
                    //Change Record
                    if (GetRecord(ChangeID) > 0)
                    {
                        this.txtRequest.Text = Convert.ToString(ChangeID);
                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;
                        SetLinkURLs(ChangeID);
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
        this.btnEdit.Visible = false;
        this.btnNew.Visible = false;
        IsEditAllow = false;

        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAssignedFormFieldsData(3, RoleId)))
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
                //if (txtDocIDs == "btnNewEditSaves")
                //{
                //    //btnNewEditSaves.Visible = true;
                //    btnNew.Visible = true;
                //    //btnEdit.Visible = true;
                //}
                if (txtDocIDs == "btnNew") { btnNew.Visible = true; }
                if (txtDocIDs == "btnEdit") { IsEditAllow = true; }

                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }


            }

        }

    }
    public void CheckDropdownVisible()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowDropdowns(RoleId, 3)))
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
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.visibleDropDown(RoleId, 3)))
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
    private void SetLinkURLs(Int32 ChangeID)
    {
        hlnkAttachFiles.NavigateUrl = "~/ChangeManagement/AttachFiles.aspx?SID=" + _SID + "&COID=" + ChangeID + "&IsChangeModule=false";
        hlnkNotes.NavigateUrl = "~/ChangeManagement/AddNotes.aspx?SID=" + _SID + "&COID=" + ChangeID;
        //hlnkChangeImpact.NavigateUrl = "~/ChangeManagement/ChangeImpact.aspx?SID=" + _SID + "&COID=" + ChangeID;
        //hlnkMaterialDisposition.NavigateUrl = "~/ChangeManagement/AddDispositions.aspx?SID=" + _SID + "&COID=" + ChangeID;
        hlnkWFTasks.NavigateUrl = "~/WorkFlowManagement/WFAssignment.aspx?SID=" + _SID + "&RFTP=CO&RFID=" + ChangeID;
        hlnkWFCustom.NavigateUrl = "~/Common/Custom.aspx?SID=" + _SID + "&COID=" + ChangeID;
    }
    public void EnabledDropsDown()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.EnabledDropDown(RoleId, 3)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Enabled = true; hfd_gvAttachedFiles.Value = "1"; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Enabled = true; hfd_gvNotes.Value = "1"; } //else { divStatus.Visible = false; }

                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Enabled = true; hfd_gvWFTasks.Value = "1"; }
                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Enabled = true; hfd_gvAttachedFiles.Value = "1"; }
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
        Int32 ChangeID = 0;
        String _ChangeID = this.txtRequest.Text;
        if (!String.IsNullOrEmpty(_ChangeID))
        {
            ChangeID = Convert.ToInt32(_ChangeID);
        }
        if (ChangeID > 0)
        {
            this.txtRequest.Text = null;
            SetLinkURLs(ChangeID);
            SetForm(FORM_ON.View);
        }
        else
        {

        }
        ClearRecord();
        //btnNewEditSaves.Text = "New Request";
        btnNew.Text = "New Request";

        btnNew.Visible = true;
        btnEdit.Visible = false;
        txtRequest.ReadOnly = false;
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
                SetForm(FORM_ON.View);
                GetRecord(ChangeID);
                SetLinkURLs(ChangeID);
                //btnNewEditSaves.Text = "Edit";
                btnNew.Text = "Edit";
                btnNew.Visible = false;
                btnEdit.Visible = IsEditAllow;//  true;
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
                    this.txtProject.Text = _tempViewChanges.Rows[0]["Project"].ToString();

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
    //protected void btnNewEditSave_Click(object sender, EventArgs e)
    //{
    //    if (ucDateStart.Text == "")
    //    {
    //        ucDateStart.Text = "1/01/2000 12:00:00 AM";
    //        txtDueDate.Text = "1/01/2000 12:00:00 AM";
    //    }
    //    DateTime Startdate = Convert.ToDateTime(this.ucDateStart.Text);
    //    if (this.btnNewEditSaves.Text == "Edit")
    //    {
    //        SetForm(FORM_ON.Edit);
    //        this.btnNewEditSaves.Text = "Update";
    //        this.btnCancel.Visible = true;
    //        this.btnDelete.Visible = false;
    //    }
    //    else if (btnNewEditSaves.Text == "Save")
    //    {
    //        DateTime DueDate;
    //        if (this.txtDueDate.Text != "")
    //        {
    //            //DueDate = DateTime.ParseExact(this.txtDueDate.Text, "MM-dd-yyyy", CultureInfo.InvariantCulture);
    //            DueDate = Convert.ToDateTime(this.txtDueDate.Text);
    //        }
    //        else
    //        {
    //            DueDate = DateTime.Now;
    //        }

    //        DataAccess.ModifyRecords(DataQueries.Insert_HelpDesk(Convert.ToInt32(txtRequest.Text.Trim()), ddlStatus.SelectedItem.Text, ddlRequestType.SelectedItem.Text, ddlPriority.SelectedItem.Text, ddlRequestedBy.SelectedItem.Text,
    //        Convert.ToDateTime(ucDateStart.Text), ddldepartment.SelectedItem.Text, ddlSupervisor.SelectedItem.Text, DueDate, ddlProject.SelectedItem.Text, txtDescription.Text.Trim()));
    //        lblStatus.Text = "Succesfully Save";
    //        lblStatus.ForeColor = System.Drawing.Color.Green;
    //        //btnNewEditSaves.Text = "New Request";
    //        btnNewEditSaves.Text = "Edit";
    //    }
    //    else if (btnNewEditSaves.Text == "Update")
    //    {
    //        if (txtRequest.Text.Trim() != "")
    //        {
    //            DateTime DueDate;
    //            if (this.txtDueDate.Text != "")
    //                DueDate = Convert.ToDateTime(this.txtDueDate.Text);
    //            else
    //                DueDate = DateTime.Now;

    //            DataAccess.ModifyRecords(DataQueries.UpdateChangesRequestHelpdesk(Convert.ToInt32(txtRequest.Text.Trim()), ddlStatus.SelectedItem.Text, ddlRequestType.SelectedItem.Text, ddlPriority.SelectedItem.Text, ddlRequestedBy.SelectedItem.Text,
    //            Convert.ToDateTime(ucDateStart.Text), ddldepartment.SelectedItem.Text, ddlSupervisor.SelectedItem.Text, DueDate, ddlProject.SelectedItem.Text, txtDescription.Text.Trim()));
    //            btnNewEditSaves.Text = "New Request";
    //            lblStatus.Text = "Succesfully Update";
    //            lblStatus.ForeColor = System.Drawing.Color.Green;
    //            SetForm(FORM_ON.View);
    //            btnNewEditSaves.Text = "Edit";
    //        }
    //        else
    //        {
    //            lblStatus.Text = "Enter Request No";
    //            lblStatus.ForeColor = System.Drawing.Color.Red;
    //        }
    //    }
    //    else if (btnNewEditSaves.Text == "New Request")
    //    {
    //        using (DataTable _tempViewChanges = DataAccess.GetRecords(DataQueries.getmaxHelpdeskid()))
    //        {
    //            Int32 _rowCount = _tempViewChanges.Rows.Count;
    //            SetForm(FORM_ON.Edit);
    //            if (_rowCount > 0)
    //            {
    //                this.txtRequest.Text = _tempViewChanges.Rows[0]["Maxid"].ToString();

    //                txtDueDate.Text = DateTime.Now.ToString();
    //                ddlStatus.Items.FindByValue("REQ").Selected = true;
    //                txtRequest.ReadOnly = true;
    //                divhlnkWFCustom.Visible = false;
    //                divhlnkWFTasks.Visible = false;
    //            }
    //        }

    //        btnNewEditSaves.Text = "Save";
    //        BindGridview();

    //        ClearRecord();
    //        this.ucDateStart.Text = DateTime.Now.ToString("MM-dd-yyyy");

    //    }
    //}

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
    //protected void AppSecProfile_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    BindGridview();
    //}
    public void BindGridview()
    {

        var recordTable = DataAccess.GetRecords(DataQueries.GetTemplateByRequestId(currentPageName));
        if (recordTable.Rows.Count > 0)
        {
            var data = recordTable.Rows[0];
            this.txtDescription.Text = data.Field<string>("TemplateData");
        }

        //Int32 _rowCount = 0;
        //Int32 Id = Convert.ToInt32(ddlRequestType.SelectedValue);
        //try
        //{
        //    using (DataTable _tempViewChanges = DataAccess.GetRecords(DataQueries.GetHelpDeskTemplate(Id)))
        //    {
        //        _rowCount = _tempViewChanges.Rows.Count;

        //        if (_rowCount > 0)
        //        {
        //            this.txtDescription.Text = _tempViewChanges.Rows[0]["Template"].ToString();

        //        }
        //    }
        //}
        //catch (Exception ex)
        //{
        //    lblStatus.Text = ex.Message; //Log the messsage    
        //}

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

                    this.ucDateStart.Text = DateTime.Now.ToString("yyyy-MM-dd");

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
            using (DataTable _tempPriority = new DataTable())
            {
                _tempPriority.Columns.Add("Code", Type.GetType("System.String"));
                _tempPriority.Columns.Add("Description", Type.GetType("System.String"));
                _tempPriority.Rows.Add("-NONE-", "-NONE-");
                _tempPriority.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("HDPriority")), true);
                this.ddlPriority.DataSource = _tempPriority;
                this.ddlPriority.DataTextField = "Description";
                this.ddlPriority.DataValueField = "Code";
                this.ddlPriority.DataBind();
            }
            using (DataTable _tempPriority = new DataTable())
            {
                _tempPriority.Columns.Add("Code", Type.GetType("System.String"));
                _tempPriority.Columns.Add("Description", Type.GetType("System.String"));
                _tempPriority.Rows.Add("-NONE-", "-NONE-");
                _tempPriority.Merge(DataAccess.GetRecords(DataQueries.DepartmentList()), true);
                this.ddldepartment.DataSource = _tempPriority;
                this.ddldepartment.DataTextField = "Description";
                this.ddldepartment.DataValueField = "Code";
                this.ddldepartment.DataBind();
            }

            using (DataTable _tempPriority = new DataTable())
            {
                _tempPriority.Columns.Add("Code", Type.GetType("System.String"));
                _tempPriority.Columns.Add("Description", Type.GetType("System.String"));
                _tempPriority.Rows.Add("-NONE-", "-NONE-");
                _tempPriority.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("HDStatus")), true);
                this.ddlStatus.DataSource = _tempPriority;
                this.ddlStatus.DataTextField = "Description";
                this.ddlStatus.DataValueField = "Code";
                this.ddlStatus.DataBind();
            }
            using (DataTable _tempProject = new DataTable())
            {
                _tempProject.Columns.Add("ID", Type.GetType("System.String"));
                _tempProject.Columns.Add("Description", Type.GetType("System.String"));
                _tempProject.Rows.Add("-NONE-", "-NONE-");
                _tempProject.Merge(DataAccess.GetRecords(DataQueries.GetQProjectByStatus("ACT", "PLN")), true);
                this.ddlProject.DataSource = _tempProject;
                this.ddlProject.DataTextField = "Description";
                this.ddlProject.DataValueField = "ID";
                this.ddlProject.DataBind();


            }
            using (DataTable _tempUserInfo = new DataTable())
            {
                _tempUserInfo.Columns.Add("User ID", Type.GetType("System.String"));
                _tempUserInfo.Columns.Add("User Name", Type.GetType("System.String"));
                _tempUserInfo.Rows.Add("-NONE-", "-NONE-");
                _tempUserInfo.Merge(DataAccess.GetRecords(DataQueries.GetQUserInfo()), true);

                this.ddlRequestedBy.DataSource = _tempUserInfo;
                this.ddlRequestedBy.DataTextField = "User Name";
                this.ddlRequestedBy.DataValueField = "User ID";
                this.ddlRequestedBy.DataBind();

                this.ddlSupervisor.DataSource = _tempUserInfo;
                this.ddlSupervisor.DataTextField = "User Name";
                this.ddlSupervisor.DataValueField = "User ID";
                this.ddlSupervisor.DataBind();


            }
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
    protected void ddlCompany_SelectedIndexChanged(object sender, EventArgs e)
    {

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

    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                this.txtPriority.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.txtRequestBy.ReadOnly = true;
                this.txtSupervisor.ReadOnly = true;
                this.txtboxDepartment.ReadOnly = true;
                this.txtRequestType.ReadOnly = true;
                this.ucDateStart.ReadOnly = true;
                this.txtDueDate.ReadOnly = true;
                this.ddlRequestType.Enabled = false;
                this.txtPriority.Visible = true;
                this.txtStatus.Visible = true;
                this.txtProject.Visible = true;
                this.txtRequestBy.Visible = true;
                this.txtSupervisor.Visible = true;
                this.txtboxDepartment.Visible = true;
                this.ddlPriority.Visible = false;
                this.ddlStatus.Visible = false;
                this.ddlProject.Visible = false;
                this.ddlRequestedBy.Visible = false;
                this.ddlSupervisor.Visible = false;
                this.ddldepartment.Visible = false;
            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                this.txtPriority.ReadOnly = false;
                this.txtStatus.ReadOnly = false;
                this.txtProject.ReadOnly = false;
                this.txtRequestBy.ReadOnly = false;
                this.txtSupervisor.ReadOnly = false;
                this.txtboxDepartment.ReadOnly = false;
                this.txtRequestType.ReadOnly = false;
                this.ucDateStart.ReadOnly = false;
                this.txtDueDate.ReadOnly = false;
                this.ddlRequestType.Enabled = true;


                this.txtPriority.Visible = false;
                this.txtStatus.Visible = false;
                this.txtProject.Visible = false;
                this.txtRequestBy.Visible = false;
                this.txtSupervisor.Visible = false;
                this.txtboxDepartment.Visible = false;
                this.ddlPriority.Visible = true;
                this.ddlStatus.Visible = true;
                this.ddlProject.Visible = true;
                this.ddlRequestedBy.Visible = true;
                this.ddlSupervisor.Visible = true;
                this.ddldepartment.Visible = true;

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlStatus.Items.FindByText(this.txtStatus.Text.Trim());
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlProject.Items.FindByText(this.txtProject.Text.Trim());
                this.ddlProject.SelectedIndex = this.ddlProject.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlRequestedBy.Items.FindByText(this.txtRequestBy.Text.Trim());
                this.ddlRequestedBy.SelectedIndex = this.ddlRequestedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlPriority.Items.FindByText(this.txtPriority.Text.Trim());
                this.ddlPriority.SelectedIndex = this.ddlPriority.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddldepartment.Items.FindByText(this.txtboxDepartment.Text.Trim());
                this.ddldepartment.SelectedIndex = this.ddldepartment.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlSupervisor.Items.FindByText(this.txtSupervisor.Text.Trim());
                this.ddlSupervisor.SelectedIndex = this.ddlSupervisor.Items.IndexOf(liSelectedItem);

            } //end if - EDIT                      

        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        if (this.btnNew.Text == "New Request")
        {
            using (DataTable _tempViewChanges = DataAccess.GetRecords(DataQueries.getmaxHelpdeskid()))
            {
                Int32 _rowCount = _tempViewChanges.Rows.Count;
                SetForm(FORM_ON.Edit);
                if (_rowCount > 0)
                {
                    this.txtRequest.Text = _tempViewChanges.Rows[0]["Maxid"].ToString();

                    txtDueDate.Text = DateTime.Now.ToString();
                    ddlStatus.Items.FindByValue("REQ").Selected = true;
                    txtRequest.ReadOnly = true;
                    divhlnkWFCustom.Visible = false;
                    divhlnkWFTasks.Visible = false;
                }
            }

            btnNew.Text = "Save";
            btnNew.Visible = true;
            btnEdit.Visible = false;

            ClearRecord();
            BindGridview();

            this.ucDateStart.Text = DateTime.Now.ToString("MM-dd-yyyy");
        }
        else if (this.btnNew.Text == "Save")
        {
            SaveUpdateRecords("Save");
        }
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        if (this.btnEdit.Text == "Edit")
        {
            SetForm(FORM_ON.Edit);
            btnEdit.Text = "Update";
            btnNew.Visible = false;
            btnEdit.Visible = IsEditAllow;// true;
            this.btnCancel.Visible = true;
            this.btnDelete.Visible = false;
        }
        else if (this.btnEdit.Text == "Update")
        {
            SaveUpdateRecords("Update");
        }

    }
    protected void SaveUpdateRecords(string action)
    {
        if (ucDateStart.Text == "")
        {
            ucDateStart.Text = "1/01/2000 12:00:00 AM";
            txtDueDate.Text = "1/01/2000 12:00:00 AM";
        }
        DateTime Startdate = Convert.ToDateTime(this.ucDateStart.Text);
        if (action == "Save")
        {
            DateTime DueDate;
            if (this.txtDueDate.Text != "")
                DueDate = Convert.ToDateTime(this.txtDueDate.Text);
            else
                DueDate = DateTime.Now;

            DataAccess.ModifyRecords(DataQueries.Insert_HelpDesk(Convert.ToInt32(txtRequest.Text.Trim()), ddlStatus.SelectedItem.Text, ddlRequestType.SelectedItem.Text, ddlPriority.SelectedItem.Text, ddlRequestedBy.SelectedItem.Text,
            Convert.ToDateTime(ucDateStart.Text), ddldepartment.SelectedItem.Text, ddlSupervisor.SelectedItem.Text, DueDate, ddlProject.SelectedItem.Text, txtDescription.Text.Trim()));
            lblStatus.Text = "Succesfully Save";
            lblStatus.ForeColor = System.Drawing.Color.Green;
            ////btnNewEditSaves.Text = "New Request";
            btnEdit.Text = "Edit";
            btnNew.Visible = false;
            btnEdit.Visible = IsEditAllow;//true;
        }
        else if (action == "Update")
        {
            if (txtRequest.Text.Trim() != "")
            {
                DateTime DueDate;
                if (this.txtDueDate.Text != "")
                    DueDate = Convert.ToDateTime(this.txtDueDate.Text);
                else
                    DueDate = DateTime.Now;

                DataAccess.ModifyRecords(DataQueries.UpdateChangesRequestHelpdesk(Convert.ToInt32(txtRequest.Text.Trim()), ddlStatus.SelectedItem.Text, ddlRequestType.SelectedItem.Text, ddlPriority.SelectedItem.Text, ddlRequestedBy.SelectedItem.Text,
                Convert.ToDateTime(ucDateStart.Text), ddldepartment.SelectedItem.Text, ddlSupervisor.SelectedItem.Text, DueDate, ddlProject.SelectedItem.Text, txtDescription.Text.Trim()));
                btnNew.Text = "New Request";
                btnNew.Visible = true;
                btnEdit.Visible = false;

                lblStatus.Text = "Succesfully Update";
                lblStatus.ForeColor = System.Drawing.Color.Green;
                SetForm(FORM_ON.View);
            }
            else
            {
                lblStatus.Text = "Enter Request No";
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }
    }
}
