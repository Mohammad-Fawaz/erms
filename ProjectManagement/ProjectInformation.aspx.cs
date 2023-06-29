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
using System.Globalization;

/// <summary>
/// Project Information Class
/// </summary>
public partial class ProjectManagement_ProjectInformation : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    private Boolean _IsEditAllow = true;
    public Boolean IsEditAllow
    {
        get { return _IsEditAllow; }
        set { _IsEditAllow = value; }
    }

    /// <summary>
    /// Page Load Event
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        this.lblStatus.Text = null;
        String ProjectID = null;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            //Get Project ID            
            if (Request.QueryString["PID"] != null)
            {
                ProjectID = Request.QueryString["PID"];
            }

            SetLinkURLs(ProjectID);

            if (!IsPostBack)
            {
                CheckFields();
                CheckDropdownVisible();
                CheckdropsdownView();
                EnabledDropsDown();
                InitializeFormFields();
                SetForm(FORM_ON.View);

                if (!String.IsNullOrEmpty(ProjectID))
                {
                    if (GetRecord(ProjectID) > 0)
                    {
                        this.btnFind.AlternateText = "Find New Project";
                        //this.btnNewEditSave.Text = "Edit";
                        this.btnEdit.Text = "Edit";
                        this.btnNew.Visible = false;
                        this.btnEdit.Visible = IsEditAllow;// true;
                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;

                        GetWFTasks(Constants.ProjectReferenceType, ProjectID);
                    }
                    else // if No Records found
                    {
                        //this.txtPID.CssClass = "CtrlShortValueEdit";
                        this.txtPID.ReadOnly = false;
                        this.txtPID.Focus();
                    }
                }
                else //if DocID is null
                {
                    //this.txtPID.CssClass = "CtrlShortValueEdit";
                    this.txtPID.ReadOnly = false;
                    this.txtPID.Focus();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }
    }

    /// <summary>
    /// Set Links
    /// </summary>
    /// <param name="PID"></param>
    private void SetLinkURLs(String PID)
    {
        hlnkWFTasks.NavigateUrl = "~/WorkFlowManagement/WFAssignment.aspx?SID=" + _SID + "&RFTP=PROJ&RFID=" + PID;
        hlnkPrintableFormate.NavigateUrl = "../Legacy/secweb/pnt_chgreq.asp?SID=" + _SID + "&Listing=Project&Item=" + PID;
    }

    /// <summary>
    /// Show or Hide List
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnListToggle_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnListToggle.Text == "Hide List")
            {
                this.gvReferenceType.Visible = false;
                this.btnListToggle.Text = "Show List";
            }
            else
            {
                SelectRefTypeList();
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// Select the Type
    /// </summary>
    private void SelectRefTypeList()
    {
        String _ListQuery = null;

        _ListQuery = DataQueries.GetViewProjectsList(Utils.IsAdmin(_SID), Convert.ToInt32(Session["UserID"]));
        if (!String.IsNullOrEmpty(_ListQuery))
        {
            Int32 _rowCount = GetReferenceTypeList(_ListQuery);
            if (_rowCount > 0)
            {
                this.gvReferenceType.Visible = true;
                this.btnListToggle.Text = "Hide List";
            }
            else
            {
                this.lblStatus.Text = "No Records Found!";
                this.gvReferenceType.Visible = false;
                this.btnListToggle.Text = "Show List";
            }
        }
        else
        {
            this.lblStatus.Text = "Not Configured Yet !";
            this.gvReferenceType.Visible = false;
            this.btnListToggle.Text = "Show List";
        }
    }
    public void CheckFields()
    {
        this.btnEdit.Visible = false;
        this.btnNew.Visible = false;
        IsEditAllow = false;

        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        divAssignTo.Visible = true;
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAssignedFormFieldsData(4, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["Controlid"].ToString();
                if (txtDocIDs == "divtxtPID") { divtxtPID.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divtxtStatus") { divtxtStatus.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divtxtStatus") { divtxtStatus.Visible = true; } //else { divRevision.Visible = false; }
                if (txtDocIDs == "divtxtProject") { divtxtProject.Visible = true; } //else { divExpires.Visible = false; }

                if (txtDocIDs == "divtxtCustomer") { divtxtCustomer.Visible = true; }
                if (txtDocIDs == "divtxtContact") { divtxtContact.Visible = true; }
                if (txtDocIDs == "divtxtPlanDateStart") { divtxtPlanDateStart.Visible = true; }
                if (txtDocIDs == "divtxtProject") { divtxtProject.Visible = true; }
                if (txtDocIDs == "divtxtPlanDateEnd") { divtxtPlanDateEnd.Visible = true; }
                if (txtDocIDs == "divtxtPlanHours") { divtxtPlanHours.Visible = true; }
                if (txtDocIDs == "divtxtPlanCost") { divtxtPlanCost.Visible = true; }
                if (txtDocIDs == "divtxtPlanTotalCost") { divtxtPlanTotalCost.Visible = true; }
                if (txtDocIDs == "divtxtActualDateStart") { divtxtActualDateStart.Visible = true; }
                if (txtDocIDs == "divtxtActualDateEnd") { divtxtActualDateEnd.Visible = true; }
                //
                if (txtDocIDs == "divtxtActualHours") { divtxtActualHours.Visible = true; }
                if (txtDocIDs == "divtxtActualCost") { divtxtActualCost.Visible = true; }
                if (txtDocIDs == "divtxtActualTotalCost") { divtxtActualTotalCost.Visible = true; }
                if (txtDocIDs == "divtxtActualDateEnd") { divtxtActualDateEnd.Visible = true; }


                if (txtDocIDs == "divtxtPlanDateStart") { divtxtPlanDateStart.Visible = true; }
                if (txtDocIDs == "divtxtPlanDateEnd") { divtxtPlanDateEnd.Visible = true; }
                if (txtDocIDs == "divtxtPlanHours") { divtxtPlanHours.Visible = true; }
                if (txtDocIDs == "divtxtPlanCost") { divtxtPlanCost.Visible = true; }
                if (txtDocIDs == "divtxtActualDateStart") { divtxtActualDateStart.Visible = true; }
                if (txtDocIDs == "divtxtActualDateEnd") { divtxtActualDateEnd.Visible = true; }
                if (txtDocIDs == "divtxtActualHours") { divtxtActualHours.Visible = true; }
                if (txtDocIDs == "btnListToggle") { btnListToggle.Visible = true; }

                if (txtDocIDs == "btnNew") { btnNew.Visible = true; }
                if (txtDocIDs == "btnEdit") { IsEditAllow = true; }

            }

        }

    }
    public void CheckDropdownVisible()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowDropdowns(RoleId, 4)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["MasterID"].ToString();
                if (txtDocIDs == "divhlnkWFTasks") { divhlnkWFTasks.Visible = true; }// else { divtxtDocID.Visible = false; }

            }
        }

    }
    public void CheckdropsdownView()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.visibleDropDown(RoleId, 4)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; }// else { divtxtDocID.Visible = false; }
            }

        }
    }
    public void EnabledDropsDown()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.EnabledDropDown(RoleId, 4)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Enabled = true; }// else { divtxtDocID.Visible = false; }
            }

        }

    }
    /// <summary>
    /// Get Reference Type List
    /// </summary>
    /// <param name="QueryText"></param>
    /// <returns></returns>
    private Int32 GetReferenceTypeList(String QueryText)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvReferenceType.CssClass = "GridViewStyleView";
            //this.gvReferenceType.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvReferenceType.RowStyle.CssClass = "GridViewStyleView";
            //this.gvReferenceType.FooterStyle.CssClass = "GridViewStyleView";
            this.gvReferenceType.AutoGenerateSelectButton = true;
            this.gvReferenceType.EnableViewState = false;
            this.gvReferenceType.Controls.Clear();

            using (DataTable _tempList = DataAccess.GetRecords(QueryText))
            {
                _rowCount = _tempList.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvReferenceType.DataSource = _tempList;
                    this.gvReferenceType.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "GetReferenceTypeList :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Reference Type - Pagination
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvReferenceType_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            SelectRefTypeList();
            this.gvReferenceType.PageIndex = e.NewPageIndex;
            this.gvReferenceType.DataBind();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Reference Type - Selection Index Changed
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvReferenceType_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;

            SelectRefTypeList();

            if (gvReferenceType.Rows.Count < 1)
            {
                e.Cancel = true;
            }
            else
            {
                String ProjectID = gvReferenceType.Rows[_selectedRowIndex].Cells[1].Text;
                SetLinkURLs(ProjectID);

                //Project Record
                if (GetRecord(ProjectID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnFind.AlternateText = "Find New Project";
                    //this.btnNewEditSave.Text = "Edit";
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = IsEditAllow;//true;

                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;

                    GetWFTasks(Constants.ProjectReferenceType, ProjectID);
                }
                else
                {
                    InitializeFormFields();

                    SetForm(FORM_ON.View);
                    //this.txtPID.CssClass = "CtrlShortValueEdit";
                    this.txtPID.ReadOnly = false;
                    this.txtPID.Focus();

                    lblStatus.Text = "A Project " + ProjectID + " could not be located or created.";
                }

                this.gvReferenceType.Visible = false;
                this.btnListToggle.Text = "Show List";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Reference Type - Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvReferenceType_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colSelectIndex = 0;

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            //Get Column Indexes
            DataRowView drvRefTypeList = (DataRowView)e.Row.DataItem;
            Int32 _colIDIndex = drvRefTypeList.DataView.Table.Columns["ID"].Ordinal + 1;
            Int32 _colDescriptionIndex = drvRefTypeList.DataView.Table.Columns["Description"].Ordinal + 1;
            Int32 _colTypeIndex = drvRefTypeList.DataView.Table.Columns["Type"].Ordinal + 1;
            Int32 _colStatusIndex = drvRefTypeList.DataView.Table.Columns["Status"].Ordinal + 1;
            Int32 _colInfoIndex = drvRefTypeList.DataView.Table.Columns["Info"].Ordinal + 1;

            //Align
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDescriptionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStatusIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colInfoIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }

    /// <summary>
    /// Cancel Project
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            //Cancel On Selecting a New Project ID 
            if (this.btnFind.AlternateText == "Find" && this.btnNew.Text == "Save")
            {
                InitializeFormFields();

                SetForm(FORM_ON.View);
                //this.txtPID.CssClass = "CtrlShortValueEdit";
                this.txtPID.ReadOnly = false;
                this.txtPID.Focus();

                this.btnNew.Text = "New Project";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.Visible = true;
            }

            if (btnEdit.Text == "Edit")
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);
                //this.txtPID.CssClass = "CtrlShortValueEdit";
                this.txtPID.ReadOnly = false;
                this.txtPID.Focus();

                this.btnNew.Text = "New Project";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.Visible = true;
            }

            //Cancel on Edited Existing Project before Saving
            if (this.btnFind.AlternateText == "Find New Project"
                && (this.btnNew.Text == "Save" || this.btnEdit.Text == "Update"))
            {
                String ProjectID = this.txtPID.Text;

                if (GetRecord(ProjectID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = IsEditAllow;//true;

                    this.btnCancel.Visible = true;
                    this.btnDelete.Visible = true;

                    GetWFTasks(Constants.ProjectReferenceType, ProjectID);
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage       
        }
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
            String ProjectID = this.txtPID.Text;
            SetLinkURLs(ProjectID);

            //Find Project
            if (this.btnFind.AlternateText == "Find")
            {
                //Project Record
                if (GetRecord(ProjectID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnFind.AlternateText = "Find New Project";
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = IsEditAllow;//;

                    this.btnCancel.Visible = true;
                    this.btnDelete.Visible = true;

                    GetWFTasks(Constants.ProjectReferenceType, ProjectID);
                }
                else
                {
                    InitializeFormFields();

                    SetForm(FORM_ON.View);
                    //this.txtPID.CssClass = "CtrlShortValueEdit";
                    this.txtPID.ReadOnly = false;
                    this.txtPID.Focus();

                    lblStatus.Text = "A Project " + ProjectID + " could not be located or created.";
                }
            }
            else if (this.btnFind.AlternateText == "Find New Project")
            {
                InitializeFormFields();

                SetForm(FORM_ON.View);
                //this.txtPID.CssClass = "CtrlShortValueEdit";
                this.txtPID.ReadOnly = false;
                this.txtPID.Focus();

                this.btnFind.AlternateText = "Find";
                this.btnNew.Text = "New Project";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.PostBackUrl = "ProjectInformation.aspx?SID=" + _SID + "&PID=0";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// New / Edit / Save
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    //protected void btnNewEditSave_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        if (this.btnNewEditSave.Text == "New Project")
    //        {
    //            InitializeFormFields();
    //            SetForm(FORM_ON.Edit);
    //            GetVendorContacts();

    //            this.btnNewEditSave.Text = "Save";
    //            this.btnCancel.Visible = true;
    //            this.btnDelete.Visible = false;
    //            this.btnFind.Visible = false;
    //        }
    //        else if (this.btnNewEditSave.Text == "Edit")
    //        {
    //            SetForm(FORM_ON.Edit);
    //            GetVendorContacts();

    //            this.btnNewEditSave.Text = "Update";
    //            this.btnCancel.Visible = true;
    //            this.btnDelete.Visible = false;
    //        }
    //        else if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update")
    //        {
    //            String ProjectID = this.txtPID.Text;
    //            if (String.IsNullOrEmpty(ProjectID))
    //            {
    //                throw new Exception("You must include a [Project Number].");
    //            }

    //            String ProjectName = this.txtProject.Text;
    //            if (String.IsNullOrEmpty(ProjectName))
    //            {
    //                throw new Exception("You must include a [Project Name].");
    //            }

    //            String ProjectStatus = null;
    //            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
    //            {
    //                ProjectStatus = this.ddlStatus.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                throw new Exception("A [Status] could not be located or created. The record will not be saved.");
    //            }

    //            String VendorCustCode = null;
    //            if (this.ddlCustomer.SelectedItem.Text != "-NONE-")
    //            {
    //                VendorCustCode = this.ddlCustomer.SelectedItem.Value;
    //            }

    //            String ProjectLocation = this.txtProjectLoc.Text;

    //            Int32 VendorContactID = 0;
    //            if (this.ddlContact.SelectedItem.Text != "-NONE-")
    //            {
    //                VendorContactID = Convert.ToInt32(this.ddlContact.SelectedItem.Value);
    //            }

    //            DateTime PlannedStartDate;
    //            if (!String.IsNullOrEmpty(this.ucPlanDateStart.SelectedDate))
    //            {
    //                PlannedStartDate = Convert.ToDateTime(this.ucPlanDateStart.SelectedDate);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Projects", "PlannedStart"))
    //                {
    //                    throw new Exception("A [Planned Start Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    PlannedStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            DateTime PlannedEndDate;
    //            if (!String.IsNullOrEmpty(this.ucPlanDateEnd.SelectedDate))
    //            {
    //                PlannedEndDate = Convert.ToDateTime(this.ucPlanDateEnd.SelectedDate);
    //                //   PlannedEndDate = DateTime.ParseExact(this.ucPlanDateEnd.SelectedDate, "mm/dd/yyyy", CultureInfo.InvariantCulture);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Projects", "PlannedFinish"))
    //                {
    //                    throw new Exception("A [Planned Finish Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    PlannedEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            Single PlannedHours = 0.0f;
    //            if (!String.IsNullOrEmpty(this.txtPlanHours.Text))
    //            {
    //                PlannedHours = Convert.ToSingle(this.txtPlanHours.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Projects", "EstHours"))
    //                {
    //                    throw new Exception("The [Estimated Hours] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            Decimal PlannedCost = Convert.ToDecimal(0.0);
    //            if (!String.IsNullOrEmpty(this.txtPlanCost.Text))
    //            {
    //                PlannedCost = Convert.ToDecimal(this.txtPlanCost.Text.Replace("$", ""));
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Projects", "EstCost"))
    //                {
    //                    throw new Exception("The [Estimated Cost] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime ActualStartDate;
    //            if (!String.IsNullOrEmpty(this.txtActualDateStart.Text))
    //            {
    //                ActualStartDate = Convert.ToDateTime(this.txtActualDateStart.Text);
    //            }
    //            else
    //            {
    //                ActualStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //            }

    //            DateTime ActualEndDate;
    //            if (!String.IsNullOrEmpty(this.txtActualDateEnd.Text))
    //            {
    //                ActualEndDate = Convert.ToDateTime(this.txtActualDateEnd.Text);
    //            }
    //            else
    //            {
    //                ActualEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //            }

    //            Single ActualHours = 0.0f;
    //            if (!String.IsNullOrEmpty(this.txtActualHours.Text))
    //            {
    //                ActualHours = Convert.ToSingle(this.txtActualHours.Text);
    //            }

    //            Decimal ActualCost = Convert.ToDecimal(0.0);
    //            if (!String.IsNullOrEmpty(this.txtActualCost.Text))
    //            {
    //                ActualCost = Convert.ToDecimal(this.txtActualCost.Text.Replace("$", ""));
    //            }

    //            String LastModifiedBy = _SessionUser;
    //            DateTime LastModifiedDate = DateTime.Now;

    //            if (this.btnNewEditSave.Text == "Update")
    //            {
    //                DataAccess.ModifyRecords(DataQueries.UpdateProjXRef(ProjectID, ProjectName, ProjectStatus,
    //                                                                     PlannedStartDate, PlannedEndDate, PlannedHours, PlannedCost,
    //                                                                     ActualStartDate, ActualEndDate, ActualHours, ActualCost,
    //                                                                     VendorCustCode, VendorContactID, ProjectLocation));
    //            }


    //            if (this.btnNewEditSave.Text == "Save")
    //            {
    //                DataAccess.ModifyRecords(DataQueries.InsertProjXRef(ProjectID, ProjectName, ProjectStatus,
    //                                                                     PlannedStartDate, PlannedEndDate, PlannedHours, PlannedCost,
    //                                                                     ActualStartDate, ActualEndDate, ActualHours, ActualCost,
    //                                                                     VendorCustCode, VendorContactID, ProjectLocation));
    //            }

    //            GetRecord(ProjectID);
    //            SetLinkURLs(ProjectID);
    //            SetForm(FORM_ON.View);
    //            this.btnFind.AlternateText = "Find New Project";
    //            this.btnNewEditSave.Text = "Edit";
    //            this.btnCancel.Visible = false;
    //            this.btnDelete.Visible = true;
    //            this.btnFind.Visible = true;
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        lblStatus.Text = ex.Message; //Log the messsage    
    //    }
    //}

    /// <summary>
    /// Vendor Contacts
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlCustomer_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetVendorContacts();
    }

    /// <summary>
    /// Get Vendor Contacts
    /// </summary>
    private void GetVendorContacts()
    {
        String VendorID = this.ddlCustomer.SelectedItem.Value.ToString();

        //this.ddlContact.CssClass = "CtrlMediumValueEdit";
        this.txtContact.Visible = false;
        this.ddlContact.Visible = true;

        DataTable _tempContact = new DataTable();
        _tempContact.Columns.Add("ID", Type.GetType("System.Int32"));
        _tempContact.Columns.Add("Description", Type.GetType("System.String"));
        _tempContact.Rows.Add(0, "-NONE-");
        _tempContact.Merge(DataAccess.GetRecords(DataQueries.GetVCContactsByVendorID(VendorID)), true);
        this.ddlContact.DataSource = _tempContact;
        this.ddlContact.DataTextField = "Description";
        this.ddlContact.DataValueField = "ID";
        this.ddlContact.DataBind();

        ListItem liSelectedItem = this.ddlContact.Items.FindByText(this.txtContact.Text.Trim());
        this.ddlContact.SelectedIndex = this.ddlContact.Items.IndexOf(liSelectedItem);
    }


    /// <summary>
    /// Get Vendor Contacts
    /// </summary>
    private void GetUsers()
    {
        DataTable _tempContact = new DataTable();
        _tempContact.Columns.Add("ID", Type.GetType("System.Int32"));
        _tempContact.Columns.Add("UserName", Type.GetType("System.String"));
        _tempContact.Rows.Add(0, "-NONE-");

        _tempContact.Merge(DataAccess.GetRecords(DataQueries.GetUsersForProjects()), true);

        this.ddlAssignTo.DataSource = _tempContact;
        this.ddlAssignTo.DataTextField = "UserName";
        this.ddlAssignTo.DataValueField = "ID";
        this.ddlAssignTo.DataBind();

        ListItem liSelectedItem = this.ddlContact.Items.FindByText(this.txtContact.Text.Trim());
        this.ddlAssignTo.SelectedIndex = this.ddlContact.Items.IndexOf(liSelectedItem);
    }


    /// <summary>
    /// Delete Project
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            String _ProjectCode = this.txtPID.Text;

            Boolean _DeleteRecordsPref = false;
            String _DeletePreference = this.Request.Form["hdnDeleteUserPref"];
            if (!String.IsNullOrEmpty(_DeletePreference))
            {
                _DeleteRecordsPref = Convert.ToBoolean(_DeletePreference);
            }

            if (_DeleteRecordsPref)
            {
                DataAccess.ModifyRecords(DataQueries.DeleteProjXRefByID(_ProjectCode));

                InitializeFormFields();

                SetForm(FORM_ON.View);
                //this.txtPID.CssClass = "CtrlShortValueEdit";
                this.txtPID.ReadOnly = false;
                this.txtPID.Focus();

                this.btnFind.AlternateText = "Find";
                this.btnNew.Text = "New Project";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.PostBackUrl = "ProjectInformation.aspx?SID=" + _SID + "&PID=0";

                this.lblStatus.Text = "Success ! Project " + _ProjectCode + " and its associations are removed ";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }


    }

    /// <summary>
    /// Get Record Values
    /// </summary>
    /// <param name="PID"></param>
    /// <returns></returns>
    private Int32 GetRecord(String PID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewProjects = DataAccess.GetRecords(DataQueries.GetViewProjectbyID(PID)))
            {
                _rowCount = _tempViewProjects.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtPID.Text = _tempViewProjects.Rows[0]["ID"].ToString();
                    this.txtProject.Text = _tempViewProjects.Rows[0]["Project Name"].ToString();
                    this.txtStatus.Text = _tempViewProjects.Rows[0]["Status"].ToString();

                    this.txtCustomer.Text = _tempViewProjects.Rows[0]["Vendor Name"].ToString();
                    this.txtContact.Text = _tempViewProjects.Rows[0]["Vendor Contact Name"].ToString();

                    this.txtProjectLoc.Text = _tempViewProjects.Rows[0]["ProjectFile Path"].ToString();

                    String _PlannedStartDate = _tempViewProjects.Rows[0]["Planned Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlannedStartDate) && Constants.DateTimeMinimum != _PlannedStartDate)
                    {
                        this.txtPlanDateStart.Text = Convert.ToDateTime(_PlannedStartDate).ToShortDateString();
                    }

                    String _PlanDateEnd = _tempViewProjects.Rows[0]["Planned End Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlanDateEnd) && Constants.DateTimeMinimum != _PlanDateEnd)
                    {
                        this.txtPlanDateEnd.Text = Convert.ToDateTime(_PlanDateEnd).ToShortDateString();
                    }

                    this.txtPlanHours.Text = _tempViewProjects.Rows[0]["Planned Hours"].ToString();

                    String _PlanCost = _tempViewProjects.Rows[0]["Planned Cost"].ToString();
                    if (!String.IsNullOrEmpty(_PlanCost))
                    {
                        this.txtPlanCost.Text = Convert.ToDecimal(_PlanCost).ToString();//.ToString("c");
                    }

                    this.txtPlanTotalCost.Text = null;

                    String _ActualDateStart = _tempViewProjects.Rows[0]["Actual Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualDateStart) && Constants.DateTimeMinimum != _ActualDateStart)
                    {
                        this.txtActualDateStart.Text = Convert.ToDateTime(_ActualDateStart).ToShortDateString();
                    }

                    String _ActualDateEnd = _tempViewProjects.Rows[0]["Actual End Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualDateEnd) && Constants.DateTimeMinimum != _ActualDateEnd)
                    {
                        this.txtActualDateEnd.Text = Convert.ToDateTime(_ActualDateEnd).ToShortDateString();
                    }

                    this.txtActualHours.Text = _tempViewProjects.Rows[0]["Actual Hours"].ToString();

                    String _ActualCost = _tempViewProjects.Rows[0]["Actual Cost"].ToString();
                    if (!String.IsNullOrEmpty(_ActualCost))
                    {
                        this.txtActualCost.Text = Convert.ToDecimal(_ActualCost).ToString();//.ToString("c");
                    }

                    this.txtActualTotalCost.Text = null;
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }

        return _rowCount;
    }

    /// <summary>
    /// Get WF Tasks
    /// </summary>
    /// <param name="HeaderReferenceType"></param>
    /// <param name="HeaderReferenceID"></param>
    /// <returns></returns>
    private Int32 GetWFTasks(String HeaderReferenceType, String HeaderReferenceID)
    {
        Int32 _rowCount = 0;

        try
        {
            //Set Grid
            //this.gvWFTasks.CssClass = "GridViewStyleView";
            //this.gvWFTasks.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvWFTasks.RowStyle.CssClass = "GridViewStyleView";
            this.gvWFTasks.AutoGenerateDeleteButton = true;
            this.gvWFTasks.AutoGenerateSelectButton = true;
            this.gvWFTasks.EnableViewState = false;
            this.gvWFTasks.Controls.Clear();

            using (DataTable _tempWFTasks = DataAccess.GetRecords(DataQueries.GetViewWFTasksReference(HeaderReferenceID, HeaderReferenceType)))
            {
                _rowCount = _tempWFTasks.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvWFTasks.DataSource = _tempWFTasks;
                    this.gvWFTasks.DataBind();
                    this.lblWFTasks.Text = null;
                }
                else
                {
                    this.lblWFTasks.Text = "Currently there are no tasks assigned for the selected reference item.";
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
    /// WF Tasks  Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        String _RefID = this.txtPID.Text;
        String _RefTypeCode = Constants.ProjectReferenceType;

        GetWFTasks(_RefTypeCode, _RefID);

        if (gvWFTasks.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _TaskID = Convert.ToInt32(gvWFTasks.Rows[e.RowIndex].Cells[3].Text);

            DataAccess.ModifyRecords(DataQueries.DeleteTasksByID(_TaskID));
            DataAccess.ModifyRecords(DataQueries.DeleteWFlowTasksByID(_TaskID));

            lblStatus.Text = "Success ! Task " + _TaskID + " was deleted.";
        }

        GetWFTasks(_RefTypeCode, _RefID);
    }

    /// <summary>
    /// WF Tasks Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        String _RefID = this.txtPID.Text;
        String _RefTypeCode = Constants.ProjectReferenceType;

        GetWFTasks(_RefTypeCode, _RefID);
        String _TaskID = gvWFTasks.Rows[e.NewSelectedIndex].Cells[1].Text;

        Server.Transfer("~/WorkFlowManagement/WFTaskInformation.aspx?SID=" + _SID + "&RFTP=" + _RefTypeCode
                                                + "&RFID=" + _RefID + "&TID=" + _TaskID);
    }

    /// <summary>
    /// WF Tasks Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _colSelectIndex = 0;
        Int32 _colTemplateTaskIndex = 1;
        Int32 _colTemplateIndex = 2;
        Int32 _colTaskIndex = 3;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colTemplateTaskIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;
            e.Row.Cells[_colTaskIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colTemplateTaskIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;
            e.Row.Cells[_colTaskIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvWFTasks = (DataRowView)e.Row.DataItem;

            Int32 _colStepIndex = drvWFTasks.DataView.Table.Columns["Step"].Ordinal + 1;
            Int32 _colANameIndex = drvWFTasks.DataView.Table.Columns["Action Name"].Ordinal + 1;
            Int32 _colNStepIndex = drvWFTasks.DataView.Table.Columns["Next Step"].Ordinal + 1;
            Int32 _colAssnToIndex = drvWFTasks.DataView.Table.Columns["Assigned To"].Ordinal + 1;
            Int32 _colBStepIndex = drvWFTasks.DataView.Table.Columns["Back Step"].Ordinal + 1;
            Int32 _colATypeIndex = drvWFTasks.DataView.Table.Columns["Action Type"].Ordinal + 1;
            Int32 _colTStatusIndex = drvWFTasks.DataView.Table.Columns["Task Status"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colANameIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colNStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colAssnToIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colBStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colATypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colTStatusIndex].HorizontalAlign = HorizontalAlign.Left;
        }
    }

    /// <summary>
    /// Initialize Form 
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            this.lblStatus.Text = null;
            this.btnListToggle.Text = "Show List";

            this.txtPID.Text = null;
            this.txtStatus.Text = null;
            this.txtProject.Text = null;
            this.txtCustomer.Text = null;
            this.txtContact.Text = null;
            this.txtProjectLoc.Text = null;

            this.txtPlanDateStart.Text = DateTime.Now.ToShortDateString();
            this.txtPlanDateEnd.Text = DateTime.Now.AddMonths(1).ToShortDateString();
            this.txtPlanHours.Text = "0.0";
            this.txtPlanCost.Text = "0.0";
            this.txtPlanTotalCost.Text = null;

            this.txtActualDateStart.Text = null;
            this.txtActualDateEnd.Text = null;
            this.txtActualHours.Text = "0.0";
            this.txtActualCost.Text = "0.0";
            this.txtActualTotalCost.Text = null;

            this.ucPlanDateStart.SelectedDate = null;
            this.ucPlanDateEnd.SelectedDate = null;
            this.ucActualDateStart.SelectedDate = null;
            this.ucActualDateEnd.SelectedDate = null;

            DataTable _tempStatus = new DataTable();
            _tempStatus.Columns.Add("Code", Type.GetType("System.String"));
            _tempStatus.Columns.Add("Description", Type.GetType("System.String"));
            _tempStatus.Rows.Add("-NONE-", "-NONE-");
            _tempStatus.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("ProjStatus")), true);
            this.ddlStatus.DataSource = _tempStatus;
            this.ddlStatus.DataTextField = "Description";
            this.ddlStatus.DataValueField = "Code";
            this.ddlStatus.DataBind();

            DataTable _tempCustomer = new DataTable();
            _tempCustomer.Columns.Add("Code", Type.GetType("System.String"));
            _tempCustomer.Columns.Add("Description", Type.GetType("System.String"));
            _tempCustomer.Rows.Add("-NONE-", "-NONE-");
            _tempCustomer.Merge(DataAccess.GetRecords(DataQueries.GetVendCustXRef()), true);
            this.ddlCustomer.DataSource = _tempCustomer;
            this.ddlCustomer.DataTextField = "Description";
            this.ddlCustomer.DataValueField = "Code";
            this.ddlCustomer.DataBind();

            this.ddlCustomer.AutoPostBack = true;

            //Register Script for Delete Button
            this.btnDelete.OnClientClick = "GetProjectDeleteUserConf()";


        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Set Page to Edit / View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
                //Apply View Style                
                //this.txtPID.CssClass = "CtrlShortValueView";
                //this.txtStatus.CssClass = "CtrlMediumValueView";                
                //this.txtProject.CssClass = "CtrlWideValueView";
                //this.txtCustomer.CssClass = "CtrlMediumValueView";
                //this.txtContact.CssClass = "CtrlMediumValueView";
                //this.txtProjectLoc.CssClass = "CtrlWideValueView";

                //this.txtPlanDateStart.CssClass = "CtrlShortValueView";
                //this.txtPlanDateEnd.CssClass = "CtrlShortValueView";
                //this.txtPlanHours.CssClass = "CtrlShortValueViewCenter";                
                //this.txtPlanCost.CssClass = "CtrlShortValueViewRight";
                //this.txtPlanTotalCost.CssClass = "CtrlShortValueViewRight";

                //this.txtActualDateStart.CssClass = "CtrlShortValueView";
                //this.txtActualDateEnd.CssClass = "CtrlShortValueView";
                //this.txtActualHours.CssClass = "CtrlShortValueViewCenter";                
                //this.txtActualCost.CssClass = "CtrlShortValueViewRight";
                //this.txtActualTotalCost.CssClass = "CtrlShortValueViewRight";

                //Set Read Only      
                this.txtPID.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.ddlAssignTo.Enabled = false;
                this.txtCustomer.ReadOnly = true;
                this.txtContact.ReadOnly = true;
                this.txtProjectLoc.ReadOnly = true;

                this.txtPlanDateStart.ReadOnly = true;
                this.txtPlanDateEnd.ReadOnly = true;
                this.txtPlanHours.ReadOnly = true;
                this.txtPlanCost.ReadOnly = true;
                this.txtPlanTotalCost.ReadOnly = true;

                this.txtActualDateStart.ReadOnly = true;
                this.txtActualDateEnd.ReadOnly = true;
                this.txtActualHours.ReadOnly = true;
                this.txtActualCost.ReadOnly = true;
                this.txtActualTotalCost.ReadOnly = true;

                //Hide Edit Controls    
                this.ddlStatus.Visible = false;
                this.ddlCustomer.Visible = false;
                this.ddlContact.Visible = false;
                this.ctrlUploadProjectLoc.Visible = false;
                this.ucPlanDateStart.Visible = false;
                this.ucPlanDateEnd.Visible = false;
                this.ucActualDateStart.Visible = false;
                this.ucActualDateEnd.Visible = false;

                //Show View Controls
                this.txtStatus.Visible = true;
                this.txtCustomer.Visible = true;
                this.txtCustomer.Visible = true;
                this.txtContact.Visible = true;
                this.txtProjectLoc.Visible = true;
                this.txtPlanDateStart.Visible = true;
                this.txtPlanDateEnd.Visible = true;
                this.txtActualDateStart.Visible = true;
                this.txtActualDateEnd.Visible = true;
                this.ddlAssignTo.Visible = true;
            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                //Apply Edit Style
                //this.txtPID.CssClass = "CtrlShortValueEdit";
                //this.ddlStatus.CssClass = "CtrlMediumValueEdit";
                //this.txtProject.CssClass = "CtrlWideValueEdit";
                //this.ddlCustomer.CssClass = "CtrlMediumValueEdit";                
                //this.ctrlUploadProjectLoc.CssClass = "CtrlWideValueEdit";

                //this.ucPlanDateStart.CssClass = "CtrlShortValueEdit";
                //this.ucPlanDateEnd.CssClass = "CtrlShortValueEdit";
                //this.txtPlanHours.CssClass = "CtrlShortValueEdit";
                //this.txtPlanCost.CssClass = "CtrlShortValueEdit";

                //this.ucActualDateStart.CssClass = "CtrlShortValueEdit";
                //this.ucActualDateEnd.CssClass = "CtrlShortValueEdit";
                //this.txtActualHours.CssClass = "CtrlShortValueEdit";
                //this.txtActualCost.CssClass = "CtrlShortValueEdit";

                //Reset the Read Only  
                this.txtPID.ReadOnly = false;
                this.txtProject.ReadOnly = false;
                this.ddlAssignTo.Enabled = true;
                this.txtPlanHours.ReadOnly = false;
                this.txtPlanCost.ReadOnly = false;
                this.txtActualHours.ReadOnly = false;
                this.txtActualCost.ReadOnly = false;

                //Hide View Controls
                this.txtStatus.Visible = false;
                this.txtCustomer.Visible = false;
                this.txtProjectLoc.Visible = false;
                this.txtPlanDateStart.Visible = false;
                this.txtPlanDateEnd.Visible = false;
                this.txtActualDateStart.Visible = false;
                this.txtActualDateEnd.Visible = false;

                //Show Edit Controls
                this.ddlStatus.Visible = true;
                this.ddlCustomer.Visible = true;
                this.ctrlUploadProjectLoc.Visible = true;
                this.ucPlanDateStart.Visible = true;
                this.ucPlanDateEnd.Visible = true;
                this.ucActualDateStart.Visible = true;
                this.ucActualDateEnd.Visible = true;

                //Initialize from View Controls                  
                this.ucPlanDateStart.SelectedDate = this.txtPlanDateStart.Text;
                this.ucPlanDateEnd.SelectedDate = this.txtPlanDateEnd.Text;
                this.ucActualDateStart.SelectedDate = this.txtActualDateStart.Text;
                this.ucActualDateEnd.SelectedDate = this.txtActualDateEnd.Text;

                ListItem liSelectedItem = null;
                String _SelectedText = null;

                _SelectedText = this.txtStatus.Text.Trim();
                if (String.IsNullOrEmpty(_SelectedText))
                {
                    _SelectedText = "PLANNING";
                }
                liSelectedItem = this.ddlStatus.Items.FindByText(_SelectedText);
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                _SelectedText = this.txtCustomer.Text.Trim();
                liSelectedItem = this.ddlCustomer.Items.FindByText(_SelectedText);
                this.ddlCustomer.SelectedIndex = this.ddlCustomer.Items.IndexOf(liSelectedItem);

            } //end if - EDIT
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }


    protected void btnNew_Click(object sender, EventArgs e)
    {
        if (this.btnNew.Text == "New Project")
        {
            InitializeFormFields();
            SetForm(FORM_ON.Edit);
            GetVendorContacts();
            GetUsers();
            this.btnNew.Text = "Save";
            this.btnCancel.Visible = true;
            this.btnDelete.Visible = false;
            this.btnFind.Visible = false;
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
            GetVendorContacts();
            GetUsers();

            this.btnEdit.Text = "Update";
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
        try
        {
            if (action == "Save" || action == "Update")
            {
                String ProjectID = this.txtPID.Text;
                if (String.IsNullOrEmpty(ProjectID))
                {
                    throw new Exception("You must include a [Project Number].");
                }

                String ProjectName = this.txtProject.Text;
                if (String.IsNullOrEmpty(ProjectName))
                {
                    throw new Exception("You must include a [Project Name].");
                }

                String ProjectStatus = null;
                if (this.ddlStatus.SelectedItem.Text != "-NONE-")
                {
                    ProjectStatus = this.ddlStatus.SelectedItem.Value;
                }
                else
                {
                    throw new Exception("A [Status] could not be located or created. The record will not be saved.");
                }

                String VendorCustCode = null;
                if (this.ddlCustomer.SelectedItem.Text != "-NONE-")
                {
                    VendorCustCode = this.ddlCustomer.SelectedItem.Value;
                }

                String ProjectLocation = this.txtProjectLoc.Text;

                Int32 VendorContactID = 0;
                if (this.ddlContact.SelectedItem.Text != "-NONE-")
                {
                    VendorContactID = Convert.ToInt32(this.ddlContact.SelectedItem.Value);
                }

                DateTime PlannedStartDate;
                if (!String.IsNullOrEmpty(this.ucPlanDateStart.SelectedDate))
                {
                    PlannedStartDate = Convert.ToDateTime(this.ucPlanDateStart.SelectedDate);
                }
                else
                {
                    if (Utils.IsRequiredField("Projects", "PlannedStart"))
                    {
                        throw new Exception("A [Planned Start Date] could not be located or created. The record will not be saved.");
                    }
                    else
                    {
                        PlannedStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                    }
                }

                DateTime PlannedEndDate;
                if (!String.IsNullOrEmpty(this.ucPlanDateEnd.SelectedDate))
                {
                    PlannedEndDate = Convert.ToDateTime(this.ucPlanDateEnd.SelectedDate);
                    //   PlannedEndDate = DateTime.ParseExact(this.ucPlanDateEnd.SelectedDate, "mm/dd/yyyy", CultureInfo.InvariantCulture);
                }
                else
                {
                    if (Utils.IsRequiredField("Projects", "PlannedFinish"))
                    {
                        throw new Exception("A [Planned Finish Date] could not be located or created. The record will not be saved.");
                    }
                    else
                    {
                        PlannedEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                    }
                }

                Single PlannedHours = 0.0f;
                if (!String.IsNullOrEmpty(this.txtPlanHours.Text))
                {
                    PlannedHours = Convert.ToSingle(this.txtPlanHours.Text);
                }
                else
                {
                    if (Utils.IsRequiredField("Projects", "EstHours"))
                    {
                        throw new Exception("The [Estimated Hours] could not be located or created. The record will not be saved.");
                    }
                }

                Decimal PlannedCost = Convert.ToDecimal(0.0);
                if (!String.IsNullOrEmpty(this.txtPlanCost.Text))
                {
                    PlannedCost = Convert.ToDecimal(this.txtPlanCost.Text.Replace("$", ""));
                }
                else
                {
                    if (Utils.IsRequiredField("Projects", "EstCost"))
                    {
                        throw new Exception("The [Estimated Cost] could not be located or created. The record will not be saved.");
                    }
                }

                DateTime ActualStartDate;
                if (!String.IsNullOrEmpty(this.txtActualDateStart.Text))
                {
                    ActualStartDate = Convert.ToDateTime(this.txtActualDateStart.Text);
                }
                else
                {
                    ActualStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }

                DateTime ActualEndDate;
                if (!String.IsNullOrEmpty(this.txtActualDateEnd.Text))
                {
                    ActualEndDate = Convert.ToDateTime(this.txtActualDateEnd.Text);
                }
                else
                {
                    ActualEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }

                Single ActualHours = 0.0f;
                if (!String.IsNullOrEmpty(this.txtActualHours.Text))
                {
                    ActualHours = Convert.ToSingle(this.txtActualHours.Text);
                }

                Decimal ActualCost = Convert.ToDecimal(0.0);
                if (!String.IsNullOrEmpty(this.txtActualCost.Text))
                {
                    ActualCost = Convert.ToDecimal(this.txtActualCost.Text.Replace("$", ""));
                }

                String LastModifiedBy = _SessionUser;
                DateTime LastModifiedDate = DateTime.Now;
                int AssignTo = 0;
                if (ddlAssignTo.SelectedIndex > 0)
                    AssignTo = Convert.ToInt32(ddlAssignTo.SelectedValue);
                if (action == "Update")
                {
                    DataAccess.ModifyRecords(DataQueries.UpdateProjXRef(ProjectID, ProjectName, ProjectStatus,
                                                                         PlannedStartDate, PlannedEndDate, PlannedHours, PlannedCost,
                                                                         ActualStartDate, ActualEndDate, ActualHours, ActualCost,
                                                                         VendorCustCode, VendorContactID, ProjectLocation, AssignTo));
                }


                if (action == "Save")
                {
                    DataAccess.ModifyRecords(DataQueries.InsertProjXRef(ProjectID, ProjectName, ProjectStatus,
                                                                         PlannedStartDate, PlannedEndDate, PlannedHours, PlannedCost,
                                                                         ActualStartDate, ActualEndDate, ActualHours, ActualCost,
                                                                         VendorCustCode, VendorContactID, ProjectLocation, AssignTo));
                }

                GetRecord(ProjectID);
                SetLinkURLs(ProjectID);
                SetForm(FORM_ON.View);
                this.btnFind.AlternateText = "Find New Project";
                //this.btnNewEditSave.Text = "Edit";
                btnEdit.Text = "Edit";
                this.btnNew.Visible = false;
                this.btnEdit.Visible = IsEditAllow;//true;
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = true;
                this.btnFind.Visible = true;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
}
