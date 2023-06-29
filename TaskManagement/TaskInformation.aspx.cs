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
/// Task Information Class
/// </summary>
public partial class TaskManagement_TaskInformation : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    public Int32 _EmployeeID;
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
        Int32 TaskID = 0;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;
            _EmployeeID = this.Master.EmpID;
            CheckFields();
            CheckDropdownVisible();
            CheckdropsdownView();
            EnabledDropsDown();
            //Get Task ID
            String QSTaskID = Request.QueryString["TID"];
            if (!String.IsNullOrEmpty(QSTaskID))
            {
                TaskID = Convert.ToInt32(QSTaskID);
            }

            if (!IsPostBack)
            {
                InitializeFormFields();
                SetForm(FORM_ON.View);

                if (TaskID > 0)
                {
                    //Task Record
                    if (GetRecord(TaskID) > 0)
                    {
                        this.btnFind.AlternateText = "Find New Task";
                        //this.btnNewEditSave.Text = "Edit";
                        this.btnEdit.Text = "Edit";
                        this.btnNew.Visible = true;
                        this.btnEdit.Visible = false;
                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;

                        GetGrids(TaskID);
                        SetLinkURLs(TaskID);
                    }
                    else
                    {
                        this.txtTID.ReadOnly = false;
                        this.txtTID.Focus();
                    }
                }
                else
                {

                    this.txtTID.ReadOnly = false;
                    this.txtTID.Focus();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }
    }

    /// <summary>
    /// Set all Navigation URLs
    /// </summary>
    private void SetLinkURLs(Int32 TaskID)
    {
        hlnkAttachFiles.NavigateUrl = "~/TaskManagement/AttachFiles.aspx?SID=" + _SID + "&TID=" + TaskID;
        hlnkNotes.NavigateUrl = "~/TaskManagement/AddNotes.aspx?SID=" + _SID + "&TID=" + TaskID;
        hlnkWFTasks.NavigateUrl = "~/WorkFlowManagement/WFAssignment.aspx?SID=" + _SID + "&RFTP=TASK&RFID=" + TaskID;
        hlnkWFCustom.NavigateUrl = "~/Common/Custom.aspx?SID=" + _SID + "&TID=" + TaskID;
    }
    public void CheckFields()
    {
        this.btnEdit.Visible = false;
        this.btnNew.Visible = false;
        IsEditAllow = false;

        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);

        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.GetAssignedFormFieldsData(5, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["Controlid"].ToString();
                if (txtDocIDs == "divtxtTID") { divtxtTID.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divtxtStatus") { divtxtStatus.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divtxtChargeAccount") { divtxtChargeAccount.Visible = true; } //else { divRevision.Visible = false; }
                if (txtDocIDs == "divtxtCostType") { divtxtCostType.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divtxtRefType") { divtxtRefType.Visible = true; }
                if (txtDocIDs == "divtxtRefID") { divtxtRefID.Visible = true; }
                if (txtDocIDs == "divtxtTaskType") { divtxtTaskType.Visible = true; }
                if (txtDocIDs == "divtxtProject") { divtxtProject.Visible = true; }
                if (txtDocIDs == "divtxtDescription") { divtxtDescription.Visible = true; }
                if (txtDocIDs == "divtxtAssignedBy") { divtxtAssignedBy.Visible = true; }
                if (txtDocIDs == "divtxtPriority") { divtxtPriority.Visible = true; }
                if (txtDocIDs == "divtxtAssignedTo") { divtxtAssignedTo.Visible = true; }
                if (txtDocIDs == "divtxtDateAssignedTo") { divtxtDateAssignedTo.Visible = true; }
                if (txtDocIDs == "divtxtAssignedWG") { divtxtAssignedWG.Visible = true; }

                if (txtDocIDs == "divtxtAssignedTo") { divtxtAssignment.Visible = true; }
                if (txtDocIDs == "divtxtPlanDateStart") { divtxtPlanDateStart.Visible = true; }
                if (txtDocIDs == "divtxtPlanDateEnd") { divtxtPlanDateEnd.Visible = true; }
                if (txtDocIDs == "divtxtPlanHours") { divtxtPlanHours.Visible = true; }

                if (txtDocIDs == "divtxtPlanDurationDays") { divtxtPlanDurationDays.Visible = true; }
                if (txtDocIDs == "divtxtPlanCost") { divtxtPlanCost.Visible = true; }
                if (txtDocIDs == "divtxtOverrunDateEnd") { divtxtOverrunDateEnd.Visible = true; }

                if (txtDocIDs == "divtxtOverrunHours") { divtxtOverrunHours.Visible = true; }
                //
                if (txtDocIDs == "divtxtOverrunDurationDays") { divtxtOverrunDurationDays.Visible = true; }
                if (txtDocIDs == "divtxtOverrunCost") { divtxtOverrunCost.Visible = true; }
                if (txtDocIDs == "divtxtActualDateStart") { divtxtActualDateStart.Visible = true; }
                if (txtDocIDs == "divtxtActualDateEnd") { divtxtActualDateEnd.Visible = true; }
                if (txtDocIDs == "divtxtActualHours") { divtxtActualHours.Visible = true; }
                if (txtDocIDs == "divtxtActualDurationDays") { divtxtActualDurationDays.Visible = true; }
                if (txtDocIDs == "divtxtActualCosts") { divtxtActualCosts.Visible = true; }
                //
                if (txtDocIDs == "divtxtVarianceHours") { divtxtVarianceHours.Visible = true; }
                if (txtDocIDs == "divtxtVarianceDurationDays") { divtxtVarianceDurationDays.Visible = true; }
                if (txtDocIDs == "divtxtVarianceCost") { divtxtVarianceCost.Visible = true; }
                if (txtDocIDs == "divtxtPercent") { divtxtPercent.Visible = true; }

                //For Buttons
                if (txtDocIDs == "btnFind") { btnFind.Visible = true; }
                //if (txtDocIDs == "btnNewEditSave") { 
                //    btnNew.Visible = true; 
                //}
                if (txtDocIDs == "btnNew") { btnNew.Visible = true; }
                if (txtDocIDs == "btnEdit") { IsEditAllow = true; }

                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }
                if (txtDocIDs == "btnTaskToggle") { btnTaskToggle.Visible = true; }

            }

        }

    }
    public void CheckDropdownVisible()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowDropdowns(RoleId, 5)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {
                string txtDocIDs = row["MasterID"].ToString();
                if (txtDocIDs == "divhlnkAttachFiles") { divhlnkAttachFiles.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divhlnkNotes") { divhlnkNotes.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divhlnkWFTasks") { divhlnkWFTasks.Visible = true; } //else { divRevision.Visible = false; }
                if (txtDocIDs == "divhlnkWFCustom") { divhlnkWFCustom.Visible = true; } //else { divExpires.Visible = false; }
            }

        }

    }
    public void CheckdropsdownView()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.visibleDropDown(RoleId, 5)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; } //else { divExpires.Visible = false; }







            }

        }

    }
    public void EnabledDropsDown()
    {
        Int32 RoleId = Convert.ToInt32(Session["_ProfileId"]);
        //DataTable _tempLogin = DataAccess.GetRecords(DataQueries.GetAppPagesList())
        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.EnabledDropDown(RoleId, 5)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ChildID"].ToString();
                if (txtDocIDs == "hlnkAttachFiles") { hlnkAttachFiles.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "hlnkNotes") { hlnkNotes.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "hlnkWFTasks") { hlnkWFTasks.Visible = true; } //else { divRevision.Visible = false; }

                if (txtDocIDs == "hlnkWFCustom") { hlnkWFCustom.Visible = true; } //else { divExpires.Visible = false; }
            }

        }

    }
    /// <summary>
    /// Cancel Task
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 TaskID = 0;
            String _TaskID = this.txtTID.Text;
            if (!String.IsNullOrEmpty(_TaskID))
            {
                TaskID = Convert.ToInt32(_TaskID);
            }

            //Cancel On Selecting a New Task ID 
            if (this.btnFind.AlternateText == "Find" && this.btnNew.Text == "Save")
            {
                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);

                this.txtTID.ReadOnly = false;
                this.txtTID.Focus();

                this.btnNew.Text = "New Task";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.Visible = true;
            }

            //Cancel on Edited Existing Task before Saving
            if (this.btnFind.AlternateText == "Find New Task" &&
                (this.btnNew.Text == "Save" || this.btnEdit.Text == "Update"))
            {
                if (TaskID > 0)
                {
                    GetRecord(TaskID);
                    GetGrids(TaskID);
                    SetLinkURLs(TaskID);

                    SetForm(FORM_ON.View);
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = IsEditAllow;//true;
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                    this.gvReferenceType.Visible = false;
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
            Int32 TaskID = 0;
            String _TaskID = this.txtTID.Text;
            if (!String.IsNullOrEmpty(_TaskID))
            {
                TaskID = Convert.ToInt32(_TaskID);
            }

            //Find Task
            if (this.btnFind.AlternateText == "Find")
            {
                //Task Record
                if (GetRecord(TaskID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnFind.AlternateText = "Find New Task";
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = IsEditAllow;//true;
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;

                    GetGrids(TaskID);
                    SetLinkURLs(TaskID);
                }
                else
                {
                    InitializeFormFields();
                    InitializeGrids();

                    SetForm(FORM_ON.View);

                    this.txtTID.ReadOnly = false;
                    this.txtTID.Focus();

                    lblStatus.Text = "A Task " + TaskID + " could not be located or created.";
                }
            }
            else if (this.btnFind.AlternateText == "Find New Task")
            {
                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);

                this.txtTID.ReadOnly = false;
                this.txtTID.Focus();

                this.btnFind.AlternateText = "Find";
                this.btnNew.Text = "New Task";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.PostBackUrl = "TaskInformation.aspx?SID=" + _SID + "&TID=0";
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
    //        if (this.btnNew.Text == "New Task")
    //        {
    //            InitializeFormFields();
    //            this.txtTID.Text = Utils.GetTasksNewID().ToString();

    //            SetForm(FORM_ON.Edit);
    //            this.txtTID.ReadOnly = false;

    //            this.btnNew.Text = "Save";
    //            this.btnCancel.Visible = true;
    //            this.btnDelete.Visible = false;
    //            this.btnFind.Visible = false;
    //        }
    //        else if (this.btnEdit.Text == "Edit")
    //        {
    //            SetForm(FORM_ON.Edit);
    //            this.btnEdit.Text = "Update";
    //            this.btnCancel.Visible = true;
    //            this.btnDelete.Visible = false;
    //        }
    //        else if (this.btnNew.Text == "Save" || this.btnEdit.Text == "Update")
    //        {
    //            Int32 TaskID = 0;
    //            String _TaskID = this.txtTID.Text;
    //            if (!String.IsNullOrEmpty(_TaskID))
    //            {
    //                TaskID = Convert.ToInt32(_TaskID);
    //            }

    //            if (TaskID == 0)
    //            {
    //                throw new Exception("An [ID] could not be located or created. The record will not be saved.");
    //            }

    //            //String ChargeAccount = null;
    //            //if (this.ddlChargeAccount.SelectedItem.Text != "-NONE-")
    //            //{
    //            //    ChargeAccount = this.ddlChargeAccount.SelectedItem.Value;
    //            //}

    //            String ChargeAccount = null;
    //            if (!String.IsNullOrEmpty(this.txtChargeAccount.Text))
    //            {
    //                ChargeAccount = this.txtChargeAccount.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "ChargeAcct"))
    //                {
    //                    throw new Exception("A [Charge Acct] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String TaskStatus = null;
    //            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
    //            {
    //                TaskStatus = this.ddlStatus.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "TaskStatus"))
    //                {
    //                    throw new Exception("A [Status] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String Description = null;
    //            if (!String.IsNullOrEmpty(this.txtDescription.Text))
    //            {
    //                Description = this.txtDescription.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "TaskDesc"))
    //                {
    //                    throw new Exception("A [Description] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String ProjectID = null;
    //            if (this.ddlProject.SelectedItem.Text != "-NONE-")
    //            {
    //                ProjectID = this.ddlProject.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "ProjNum"))
    //                {
    //                    throw new Exception("A [Project] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String TaskType = null;
    //            if (this.ddlTaskType.SelectedItem.Text != "-NONE-")
    //            {
    //                TaskType = this.ddlTaskType.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "StdTaskID"))
    //                {
    //                    throw new Exception("A [Task Type] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String CostType = null;
    //            if (this.ddlCostType.SelectedItem.Text != "-NONE-")
    //            {
    //                CostType = this.ddlCostType.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "TaskCostType"))
    //                {
    //                    throw new Exception("A [Cost Type] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String RefType = null;
    //            if (this.ddlRefType.SelectedItem.Text != "-NONE-")
    //            {
    //                RefType = this.ddlRefType.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "RefType"))
    //                {
    //                    throw new Exception("A [Reference Type] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String RefID = null;
    //            if (!String.IsNullOrEmpty(this.txtRefID.Text))
    //            {
    //                RefID = this.txtRefID.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "RefNum"))
    //                {
    //                    throw new Exception("A [Reference Number] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            Int32 ParentTask = 0;
    //            if (this.ddlRefType.SelectedItem.Text == Constants.TaskReferenceType && !String.IsNullOrEmpty(this.txtRefID.Text))
    //            {
    //                ParentTask = Convert.ToInt32(this.txtRefID.Text);
    //            }

    //            String TaskPriority = null;
    //            if (this.ddlPriority.SelectedItem.Text != "-NONE-")
    //            {
    //                TaskPriority = this.ddlPriority.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "TaskPriority"))
    //                {
    //                    throw new Exception("A [Priority] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            Int32 AssignBy = 0;
    //            if (this.ddlAssignedBy.SelectedItem.Text != "-NONE-")
    //            {
    //                AssignBy = Convert.ToInt32(this.ddlAssignedBy.SelectedItem.Value);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "AssignBy"))
    //                {
    //                    throw new Exception("The person [Assigned By] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            Int32 AssignTo = 0;
    //            if (this.ddlAssignedTo.SelectedItem.Text != "-NONE-")
    //            {
    //                AssignTo = Convert.ToInt32(this.ddlAssignedTo.SelectedItem.Value);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "AssignTo"))
    //                {
    //                    throw new Exception("The person [Assigned To] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime TaskAssignedDate;
    //            if (!String.IsNullOrEmpty(this.ucDateAssignedTo.SelectedDate) && AssignTo > 0)
    //            {
    //                TaskAssignedDate = Convert.ToDateTime(this.ucDateAssignedTo.SelectedDate);
    //            }
    //            else
    //            {
    //                TaskAssignedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //            }

    //            String AssignedWG = null;
    //            if (this.ddlAssignedWG.SelectedItem.Text != "-NONE-")
    //            {
    //                AssignedWG = this.ddlAssignedWG.SelectedItem.Value;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "AssignWkgrp"))
    //                {
    //                    throw new Exception("The [Assigned Workgroup] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String TaskDetail = null;
    //            if (!String.IsNullOrEmpty(this.txtAssignment.Text))
    //            {
    //                TaskDetail = this.txtAssignment.Text;
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "TaskDetail"))
    //                {
    //                    throw new Exception("An [Assignment] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime PlannedStartDate;
    //            if (!String.IsNullOrEmpty(this.ucPlanDateStart.SelectedDate))
    //            {
    //                PlannedStartDate = Convert.ToDateTime(this.ucPlanDateStart.SelectedDate);
    //                //PlannedStartDate = DateTime.ParseExact(this.ucPlanDateStart.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "PlannedStart"))
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
    //                // PlannedEndDate = DateTime.ParseExact(this.ucPlanDateEnd.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "PlannedFinish"))
    //                {
    //                    throw new Exception("A [Planned Finish Date] could not be located or created. The record will not be saved.");
    //                }
    //                else
    //                {
    //                    PlannedEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //                }
    //            }

    //            if ((DateTime.Compare(PlannedEndDate, PlannedStartDate) < 0) || (DateTime.Compare(PlannedEndDate, DateTime.Today) < 0))
    //            {
    //                throw new Exception("A [Planned Finish Date] cannot be earlier than [Planned Start Date] Or Today. The record will not be saved.");
    //            }

    //            Single PlannedHours = 0.0f;
    //            if (!String.IsNullOrEmpty(this.txtPlanHours.Text))
    //            {
    //                PlannedHours = Convert.ToSingle(this.txtPlanHours.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "EstHours"))
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
    //                if (Utils.IsRequiredField("Tasks", "EstCost"))
    //                {
    //                    throw new Exception("The [Estimated Cost] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            DateTime OverrunEndDate;
    //            if (!String.IsNullOrEmpty(this.ucOverrunDateEnd.SelectedDate))
    //            {
    //                OverrunEndDate = Convert.ToDateTime(this.ucOverrunDateEnd.SelectedDate);
    //                //OverrunEndDate = DateTime.ParseExact(this.ucOverrunDateEnd.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
    //            }
    //            else
    //            {
    //                OverrunEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //            }

    //            Single OverrunHours = 0.0f;
    //            if (!String.IsNullOrEmpty(this.txtOverrunHours.Text))
    //            {
    //                OverrunHours = Convert.ToSingle(this.txtOverrunHours.Text);
    //            }

    //            Decimal OverrunCost = Convert.ToDecimal(0.0);
    //            if (!String.IsNullOrEmpty(this.txtOverrunCost.Text))
    //            {
    //                OverrunCost = Convert.ToDecimal(this.txtOverrunCost.Text.Replace("$", ""));
    //            }

    //            DateTime ActualStartDate;
    //            if (!String.IsNullOrEmpty(this.txtActualDateStart.Text))
    //            {
    //                ActualStartDate = Convert.ToDateTime(this.txtActualDateStart.Text);
    //                // ActualStartDate = DateTime.ParseExact(this.txtActualDateStart.Text, "MM-dd-yyyy", CultureInfo.InvariantCulture);
    //            }
    //            else
    //            {
    //                ActualStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
    //            }

    //            DateTime ActualEndDate;
    //            if (!String.IsNullOrEmpty(this.txtActualDateEnd.Text))
    //            {
    //                ActualEndDate = Convert.ToDateTime(this.txtActualDateEnd.Text);
    //                // ActualEndDate = DateTime.ParseExact(this.txtActualDateEnd.Text, "MM-dd-yyyy", CultureInfo.InvariantCulture);
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

    //            Single PercentComplete = 0.0f;
    //            if (!String.IsNullOrEmpty(this.txtPercent.Text))
    //            {
    //                PercentComplete = Convert.ToSingle(this.txtPercent.Text);
    //            }
    //            else
    //            {
    //                if (Utils.IsRequiredField("Tasks", "PcntComplete"))
    //                {
    //                    throw new Exception("The [Percent Complete] could not be located or created. The record will not be saved.");
    //                }
    //            }

    //            String IsScheduled;
    //            if (this.cbSchedule.Checked)
    //            {
    //                IsScheduled = "-1";
    //            }
    //            else
    //            {
    //                IsScheduled = "0";
    //            }

    //            String LastModifiedBy = _SessionUser;
    //            DateTime LastModifiedDate = DateTime.Now;

    //            // start of my 6/1/2020 test 

    //            if (this.btnNewEditSave.Text == "Update")
    //            {
    //                //DataAccess.ModifyRecords(DataQueries.UpdateTasks(ChargeAccount, TaskStatus, Description,
    //                //                                                 ProjectID, TaskType, CostType, RefType,
    //                //                                                 RefID, ParentTask, TaskPriority, AssignBy,
    //                //                                                 AssignTo, TaskAssignedDate, AssignedWG, TaskDetail,
    //                //                                                 PlannedStartDate, PlannedEndDate, PlannedHours, PlannedCost,
    //                //                                                 OverrunEndDate, OverrunHours, OverrunCost, ActualStartDate,
    //                //                                                 ActualEndDate, ActualHours, ActualCost, PercentComplete,
    //                //                                                 IsScheduled, TaskID));
    //                DataAccess.ModifyRecords(DataQueries.UpdateIntoTasks(ParentTask, TaskStatus, TaskPriority, CostType, TaskAssignedDate, PercentComplete,
    //                                                               ChargeAccount, RefType, RefID, ProjectID, TaskType, Description, TaskDetail,
    //                                                               PlannedStartDate, PlannedEndDate, PlannedHours, 0, PlannedCost,
    //                                                               OverrunHours, OverrunEndDate, OverrunCost, ActualStartDate,
    //                                                               ActualEndDate, ActualHours, ActualCost, AssignBy, AssignTo, AssignedWG, IsScheduled, TaskID));
    //            }


    //            if (this.btnNewEditSave.Text == "Save")
    //            {
    //                //    DataAccess.ModifyRecords(DataQueries.InsertTasks(0, TaskStatus, Description,
    //                //                                                     ProjectID, TaskType, CostType, RefType,
    //                //                                                     RefID, ParentTask, TaskPriority, AssignBy,
    //                //                                                     AssignTo, TaskAssignedDate, AssignedWG, TaskDetail,
    //                //                                                     PlannedStartDate, PlannedEndDate, PlannedHours, 0, PlannedCost,
    //                //                                                     OverrunEndDate, OverrunHours, OverrunCost, ActualStartDate,
    //                //                                                     ActualEndDate, ActualHours, ActualCost, PercentComplete,
    //                //                                                     IsScheduled));

    //                DataAccess.ModifyRecords(DataQueries.InsertIntoTasks(ParentTask, TaskStatus, TaskPriority, CostType, TaskAssignedDate, PercentComplete,
    //                                                                ChargeAccount, RefType, RefID, ProjectID, TaskType, Description, TaskDetail,
    //                                                                PlannedStartDate, PlannedEndDate, PlannedHours, 0, PlannedCost,
    //                                                                OverrunHours, OverrunEndDate, OverrunCost, ActualStartDate,
    //                                                                ActualEndDate, ActualHours, ActualCost, AssignBy, AssignTo, AssignedWG, IsScheduled));
    //            }

    //            // end of my 6/1/2020 test tmc

    //            GetRecord(TaskID);
    //            GetGrids(TaskID);
    //            SetLinkURLs(TaskID);

    //            SetForm(FORM_ON.View);
    //            this.btnFind.AlternateText = "Find New Task";
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
    /// Delete Task and its Associated Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 TaskID = 0;
            String _TaskID = this.txtTID.Text;
            if (!String.IsNullOrEmpty(_TaskID))
            {
                TaskID = Convert.ToInt32(_TaskID);
            }

            Boolean _DeleteRecordsPref = false;
            String _DeletePreference = this.Request.Form["hdnDeleteUserPref"];
            if (!String.IsNullOrEmpty(_DeletePreference))
            {
                _DeleteRecordsPref = Convert.ToBoolean(_DeletePreference);
            }

            if (_DeleteRecordsPref)
            {
                DataAccess.ModifyRecords(DataQueries.DeleteAttRefsByID(Constants.TaskFileReferenceType, TaskID.ToString()));
                DataAccess.ModifyRecords(DataQueries.DeleteNotesByRefIDType(TaskID.ToString(), Constants.TaskReferenceType));
                DataAccess.ModifyRecords(DataQueries.DeleteTasksByID(TaskID));

                InitializeFormFields();
                InitializeGrids();

                SetForm(FORM_ON.View);

                this.txtTID.ReadOnly = false;
                this.txtTID.Focus();

                this.btnFind.AlternateText = "Find";
                this.btnNew.Text = "New Task";
                this.btnNew.Visible = true;
                this.btnEdit.Visible = false;
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnFind.PostBackUrl = "TaskInformation.aspx?SID=" + _SID + "&TID=0";

                this.lblStatus.Text = "Success ! Task " + TaskID + " and its associated records are deleted ";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
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
    /// Show or Hide Tasks
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnTaskToggle_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnTaskToggle.Text == "Hide Tasks")
            {
                this.gvTaskList.Visible = false;
                this.btnTaskToggle.Text = "Show Tasks";
            }
            else
            {
                GetTasksList();
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// Auto PostBack 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlRefType_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            //SelectRefTypeList();
            //this.txtRefID.CssClass = "CtrlShortValueEdit";
            this.txtRefID.ReadOnly = false;
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// Select the Type
    /// </summary>
    private void GetTasksList()
    {
        String _ListQuery = DataQueries.GetViewTasksListOpenByUser(_EmployeeID, Utils.IsAdmin(_SID));

        if (!String.IsNullOrEmpty(_ListQuery))
        {
            Int32 _rowCount = GetGridviewTasksList(_ListQuery);
            if (_rowCount > 0)
            {
                this.gvTaskList.Visible = true;
                this.btnTaskToggle.Text = "Hide Tasks";
            }
            else
            {
                this.lblStatus.Text = "No Records Found!";
                this.gvTaskList.Visible = false;
                this.btnTaskToggle.Text = "Show Tasks";
            }
        }
        else
        {
            this.lblStatus.Text = "Not Configured Yet !";
            this.gvTaskList.Visible = false;
            this.btnTaskToggle.Text = "Show Tasks";
        }
    }

    /// <summary>
    /// Get Task List
    /// </summary>
    /// <param name="QueryText"></param>
    /// <returns></returns>
    private Int32 GetGridviewTasksList(String QueryText)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvTaskList.CssClass = "GridViewStyleView";
            //this.gvTaskList.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvTaskList.RowStyle.CssClass = "GridViewStyleView";
            //this.gvTaskList.FooterStyle.CssClass = "GridViewStyleView";
            this.gvTaskList.AutoGenerateSelectButton = true;
            this.gvTaskList.EnableViewState = false;
            this.gvTaskList.Controls.Clear();

            using (DataTable _tempList = DataAccess.GetRecords(QueryText))
            {
                _rowCount = _tempList.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvTaskList.DataSource = _tempList;
                    this.gvTaskList.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "GetGridviewTasksList :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Tasks List - Pagination
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvTaskList_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            GetTasksList();
            this.gvTaskList.PageIndex = e.NewPageIndex;
            this.gvTaskList.DataBind();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Tasks List - Selection Index Changed
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvTaskList_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        try
        {
            Int32 _selectedRowIndex = e.NewSelectedIndex;
            GetTasksList();

            if (gvTaskList.Rows.Count < 1)
            {
                e.Cancel = true;
            }
            else
            {
                //Task Record
                Int32 TaskID = Convert.ToInt32(gvTaskList.Rows[_selectedRowIndex].Cells[1].Text);
                if (GetRecord(TaskID) > 0)
                {
                    SetForm(FORM_ON.View);
                    this.btnFind.AlternateText = "Find New Task";
                    this.btnEdit.Text = "Edit";
                    this.btnNew.Visible = false;
                    this.btnEdit.Visible = IsEditAllow;//true;
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;

                    GetGrids(TaskID);
                    SetLinkURLs(TaskID);
                }

                this.gvTaskList.Visible = false;
                this.btnTaskToggle.Text = "Show Tasks";
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage
        }
    }

    /// <summary>
    /// Tasks List - Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvTaskList_RowDataBound(object sender, GridViewRowEventArgs e)
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
    /// Select the Type
    /// </summary>
    private void SelectRefTypeList()
    {
        String _ListQuery = null;
        String _SelectedRefType = null;
        if (this.ddlRefType.SelectedItem.Text != "-NONE-")
        {
            _SelectedRefType = this.ddlRefType.SelectedItem.Value;
            this.txtRefType.Text = this.ddlRefType.SelectedItem.Text;
        }

        switch (_SelectedRefType)
        {
            case Constants.CorrectiveActionReferenceType:
                //-- Yet to Implement ---
                break;
            case Constants.ChangeReferenceType:
                _ListQuery = DataQueries.GetViewChangesList();
                break;
            case Constants.DocReferenceType:
                _ListQuery = DataQueries.GetViewDocsList();
                break;
            case Constants.MaterialDispReferenceType:
                _ListQuery = DataQueries.GetViewMatDispList();
                break;
            case Constants.NonConformanceReferenceType:
                //-- Yet to Implement ---
                break;
            case Constants.ProjectReferenceType:
                _ListQuery = DataQueries.GetViewProjectsList(Utils.IsAdmin(_SID), Convert.ToInt32(_SID));
                break;
            case Constants.TaskReferenceType:
                _ListQuery = DataQueries.GetViewTasksList();
                break;
            default:
                //-- Yet to Implement ---
                break;
        }

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
                this.txtRefID.Text = gvReferenceType.Rows[_selectedRowIndex].Cells[1].Text;
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
    /// On Change - Assigned To
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlAssignedTo_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtDateAssignedTo.Text = DateTime.Now.ToString("MM-dd-yyyy");

    }

    /// <summary>
    /// Get Record Values
    /// </summary>
    /// <param name="TID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 TID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewTasks = DataAccess.GetRecords(DataQueries.GetViewTasksByID(TID)))
            {
                _rowCount = _tempViewTasks.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtTID.Text = _tempViewTasks.Rows[0]["Task ID"].ToString();
                    this.txtStatus.Text = _tempViewTasks.Rows[0]["Task Status Desc"].ToString();
                    this.txtTaskType.Text = _tempViewTasks.Rows[0]["Std Task Desc"].ToString();
                    this.txtChargeAccount.Text = _tempViewTasks.Rows[0]["Charge Account"].ToString();
                    this.txtCostType.Text = _tempViewTasks.Rows[0]["Cost Type Desc"].ToString();
                    this.txtRefType.Text = _tempViewTasks.Rows[0]["Ref Type Desc"].ToString();
                    this.txtRefID.Text = _tempViewTasks.Rows[0]["Ref ID"].ToString();
                    this.txtProject.Text = _tempViewTasks.Rows[0]["Project Desc"].ToString();
                    this.txtDescription.Text = _tempViewTasks.Rows[0]["Task Desc"].ToString();

                    this.txtAssignedBy.Text = _tempViewTasks.Rows[0]["Assigned By"].ToString();
                    this.txtPriority.Text = _tempViewTasks.Rows[0]["Priority"].ToString();
                    this.txtAssignedTo.Text = _tempViewTasks.Rows[0]["Assigned To"].ToString();

                    String _DateAssignedTo = _tempViewTasks.Rows[0]["Assigned Date"].ToString();
                    if (!String.IsNullOrEmpty(_DateAssignedTo) && Constants.DateTimeMinimum != _DateAssignedTo)
                    {
                        this.txtDateAssignedTo.Text = Convert.ToDateTime(_DateAssignedTo).ToShortDateString();
                    }

                    String _AssignedWGCode = _tempViewTasks.Rows[0]["Assigned WG"].ToString();
                    if (!String.IsNullOrEmpty(_AssignedWGCode))
                    {
                        var codeValue = this.ddlAssignedWG.Items.FindByValue(_AssignedWGCode);
                        if (codeValue != null)
                            this.txtAssignedWG.Text = codeValue.Text;
                    }

                    this.txtAssignment.Text = _tempViewTasks.Rows[0]["Task Detail"].ToString();
                    this.txtPercent.Text = _tempViewTasks.Rows[0]["Percent Complete"].ToString();

                    String _PlannedStartDate = _tempViewTasks.Rows[0]["Planned Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlannedStartDate) && Constants.DateTimeMinimum != _PlannedStartDate)
                    {
                        this.txtPlanDateStart.Text = Convert.ToDateTime(_PlannedStartDate).ToShortDateString();
                    }

                    String _PlanDateEnd = _tempViewTasks.Rows[0]["Planned End Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlanDateEnd) && Constants.DateTimeMinimum != _PlanDateEnd)
                    {
                        this.txtPlanDateEnd.Text = Convert.ToDateTime(_PlanDateEnd).ToShortDateString();
                    }

                    if (!String.IsNullOrEmpty(_tempViewTasks.Rows[0]["Planned Hours"].ToString()))
                    {
                        this.txtPlanHours.Text = _tempViewTasks.Rows[0]["Planned Hours"].ToString();
                    }
                    else
                    {
                        this.txtPlanHours.Text = "0";
                    }

                    if (!String.IsNullOrEmpty(this.txtPlanDateStart.Text) && !String.IsNullOrEmpty(this.txtPlanDateEnd.Text))
                    {
                        TimeSpan _Difference = Convert.ToDateTime(this.txtPlanDateEnd.Text).Subtract(Convert.ToDateTime(this.txtPlanDateStart.Text));
                        this.txtPlanDurationDays.Text = _Difference.Days.ToString();
                    }
                    else
                    {
                        this.txtPlanDurationDays.Text = "0";
                    }

                    String _PlanCost = _tempViewTasks.Rows[0]["Planned Cost"].ToString();
                    if (!String.IsNullOrEmpty(_PlanCost))
                    {
                        this.txtPlanCost.Text = Convert.ToDecimal(_PlanCost).ToString();
                    }
                    else
                    {
                        _PlanCost = "0";
                        this.txtPlanCost.Text = Convert.ToDecimal(_PlanCost).ToString();
                    }

                    String _OverrunDateEnd = _tempViewTasks.Rows[0]["Overrun End Date"].ToString();
                    if (!String.IsNullOrEmpty(_OverrunDateEnd) && Constants.DateTimeMinimum != _OverrunDateEnd)
                    {
                        this.txtOverrunDateEnd.Text = Convert.ToDateTime(_OverrunDateEnd).ToShortDateString();
                    }

                    this.txtOverrunHours.Text = _tempViewTasks.Rows[0]["Overrun Hours"].ToString();

                    if (!String.IsNullOrEmpty(this.txtPlanDateStart.Text) && !String.IsNullOrEmpty(this.txtOverrunDateEnd.Text))
                    {
                        TimeSpan _Difference = Convert.ToDateTime(this.txtOverrunDateEnd.Text).Subtract(Convert.ToDateTime(this.txtPlanDateStart.Text));
                        this.txtOverrunDurationDays.Text = _Difference.Days.ToString();
                    }
                    else
                    {
                        this.txtOverrunDurationDays.Text = "0";
                    }

                    String _OverrunCost = _tempViewTasks.Rows[0]["Overrun Cost"].ToString();
                    if (!String.IsNullOrEmpty(_OverrunCost))
                    {
                        this.txtOverrunCost.Text = Convert.ToDecimal(_OverrunCost).ToString();
                    }

                    String _ActualDateStart = _tempViewTasks.Rows[0]["Actual Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualDateStart) && Constants.DateTimeMinimum != _ActualDateStart)
                    {
                        this.txtActualDateStart.Text = Convert.ToDateTime(_ActualDateStart).ToShortDateString();
                    }

                    String _ActualDateEnd = _tempViewTasks.Rows[0]["Actual End Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualDateEnd) && Constants.DateTimeMinimum != _ActualDateEnd)
                    {
                        this.txtActualDateEnd.Text = Convert.ToDateTime(_ActualDateEnd).ToShortDateString();
                    }

                    if (!String.IsNullOrEmpty(_tempViewTasks.Rows[0]["Actual Hours"].ToString()))
                    {
                        this.txtActualHours.Text = _tempViewTasks.Rows[0]["Actual Hours"].ToString();
                    }
                    else
                    {
                        this.txtActualHours.Text = "0";
                    }

                    if (!String.IsNullOrEmpty(this.txtActualDateStart.Text) && !String.IsNullOrEmpty(this.txtActualDateEnd.Text))
                    {
                        TimeSpan _Difference = Convert.ToDateTime(this.txtActualDateEnd.Text).Subtract(Convert.ToDateTime(this.txtActualDateStart.Text));
                        this.txtActualDurationDays.Text = _Difference.Days.ToString();
                    }
                    else
                    {
                        this.txtActualDurationDays.Text = "0";
                    }

                    String _ActualCost = _tempViewTasks.Rows[0]["Actual Cost"].ToString();
                    if (!String.IsNullOrEmpty(_ActualCost))
                    {
                        this.txtActualCost.Text = Convert.ToDecimal(_ActualCost).ToString();
                    }
                    else
                    {
                        _ActualCost = "0";
                        this.txtActualCost.Text = Convert.ToDecimal(_ActualCost).ToString();
                    }

                    Decimal VHours = Convert.ToDecimal(this.txtPlanHours.Text) - Convert.ToDecimal(this.txtActualHours.Text);
                    this.txtVarianceHours.Text = VHours.ToString();

                    Int32 VDays = Convert.ToInt32(this.txtPlanDurationDays.Text) - Convert.ToInt32(this.txtActualDurationDays.Text);
                    this.txtVarianceDurationDays.Text = VDays.ToString();

                    Decimal VCost = Convert.ToDecimal(_PlanCost) - Convert.ToDecimal(_ActualCost);
                    this.txtVarianceCost.Text = VCost.ToString();

                    if (!String.IsNullOrEmpty(_tempViewTasks.Rows[0]["Schedule Visible"].ToString()))
                    {
                        this.cbSchedule.Checked = Convert.ToBoolean(_tempViewTasks.Rows[0]["Schedule Visible"].ToString());
                    }
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
    /// Get Attached Files
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetAttachedFiles(Int32 TID)
    {
        Int32 _rowCount = 0;

        try
        {
            //this.gvAttachedFiles.CssClass = "GridViewStyleView";
            //this.gvAttachedFiles.HeaderStyle.CssClass = "GridViewStyleView";
            //this.gvAttachedFiles.RowStyle.CssClass = "GridViewStyleView";
            this.gvAttachedFiles.AllowPaging = false;
            this.gvAttachedFiles.AutoGenerateDeleteButton = true;
            this.gvAttachedFiles.EnableViewState = false;
            this.gvAttachedFiles.Controls.Clear();

            using (DataTable _tempAttachFiles = DataAccess.GetRecords(DataQueries.GetViewAttachByTypeAndID(Constants.TaskFileReferenceType, TID)))
            {
                _rowCount = _tempAttachFiles.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvAttachedFiles.DataSource = _tempAttachFiles;
                    this.gvAttachedFiles.DataBind();
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
    /// Files Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAttachedFiles_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 TaskID = 0;
        String _TaskID = this.txtTID.Text;
        if (!String.IsNullOrEmpty(_TaskID))
        {
            TaskID = Convert.ToInt32(_TaskID);
        }

        GetAttachedFiles(TaskID);

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

        GetGrids(TaskID);
    }

    /// <summary>
    /// Files Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvAttachedFiles_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
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

            LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0];
            lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";

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

    /// <summary>
    /// Get Notes
    /// </summary>
    /// <param name="TID"></param>
    /// <returns></returns>
    private Int32 GetAddedNotes(Int32 TID)
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

            using (DataTable _tempAddedNotes = DataAccess.GetRecords(DataQueries.GetViewNotesByTypeAndID(Constants.TaskReferenceType, TID.ToString())))
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
            lblStatus.Text = "GetAddedNotes :" + ex.Message; //Log the messsage    
        }

        return _rowCount;
    }

    /// <summary>
    /// Notes Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNotes_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 TaskID = 0;
        String _TaskID = this.txtTID.Text;
        if (!String.IsNullOrEmpty(_TaskID))
        {
            TaskID = Convert.ToInt32(_TaskID);
        }

        GetAddedNotes(TaskID);

        if (gvNotes.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _NoteID = Convert.ToInt32(gvNotes.Rows[e.RowIndex].Cells[1].Text);
            Int32 _StatusCheck = DataAccess.ModifyRecords(DataQueries.DeleteNotesByIDType(_NoteID, Constants.TaskReferenceType));
            if (_StatusCheck > 0)
            {
                this.lblStatus.Text = "Success ! Note was removed";
            }
        }

        GetGrids(TaskID);
    }

    /// <summary>
    /// Notes Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvNotes_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //Hide ID Column
        Int32 _colDeleteIndex = 0;
        Int32 _colIDIndex = 1;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colIDIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colIDIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvNotes = (DataRowView)e.Row.DataItem;
            _colIDIndex = drvNotes.DataView.Table.Columns["Note ID"].Ordinal + 1;
            Int32 _colDateIndex = drvNotes.DataView.Table.Columns["Date"].Ordinal + 1;
            Int32 _colTypeIndex = drvNotes.DataView.Table.Columns["Type"].Ordinal + 1;
            Int32 _colCreatedByIndex = drvNotes.DataView.Table.Columns["Created By"].Ordinal + 1;
            Int32 _colSubjectIndex = drvNotes.DataView.Table.Columns["Subject"].Ordinal + 1;

            //Delete Button
            LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0];
            lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";

            //Format            
            e.Row.Cells[_colDateIndex].Text = DateTime.Parse(e.Row.Cells[_colDateIndex].Text).ToShortDateString();

            //Align    
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colTypeIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colCreatedByIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colSubjectIndex].HorizontalAlign = HorizontalAlign.Left;
        }
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
        String _RefID = this.txtTID.Text;
        String _RefTypeCode = Constants.TaskReferenceType;

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
        String _RefID = this.txtTID.Text;
        String _RefTypeCode = Constants.TaskReferenceType;

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
    /// Get Task Related Grids
    /// </summary>
    /// <param name="TID"></param>
    private void GetGrids(Int32 TID)
    {
        GetAddedNotes(TID);
        GetAttachedFiles(TID);
        GetWFTasks(Constants.TaskReferenceType, TID.ToString());
        GetCustomFieldsInfo(TID.ToString());
    }

    /// <summary>
    /// Initialize Form 
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            this.lblStatus.Text = null;

            this.txtTID.Text = null;
            this.txtStatus.Text = null;
            this.txtTaskType.Text = null;
            this.txtChargeAccount.Text = null;
            this.txtCostType.Text = null;
            this.txtRefType.Text = null;
            this.txtRefID.Text = null;
            this.btnListToggle.Text = "Show List";
            this.btnTaskToggle.Text = "Show Tasks";
            this.txtProject.Text = null;
            this.txtDescription.Text = null;
            this.txtDescription.TextMode = TextBoxMode.MultiLine;
            this.txtDescription.Height = 50;

            this.txtAssignedBy.Text = null;
            this.txtAssignedTo.Text = null;
            this.txtPriority.Text = null;
            this.txtDateAssignedTo.Text = DateTime.Now.ToShortDateString();
            this.ucPlanDateStart.SelectedDate = DateTime.Now.ToShortDateString();
            this.txtAssignedWG.Text = null;
            this.txtAssignment.Text = null;
            this.txtAssignment.TextMode = TextBoxMode.MultiLine;
            this.txtAssignment.Height = 50;

            this.txtPercent.Text = null;
            this.txtPercent.Width = Unit.Percentage(100.00);


            this.txtPlanDateStart.Text = null;
            this.txtPlanDateEnd.Text = null;
            this.txtPlanHours.Text = null;
            this.txtPlanDurationDays.Text = null;
            this.txtPlanCost.Text = null;

            this.txtOverrunDateEnd.Text = null;
            this.txtOverrunHours.Text = null;
            this.txtOverrunDurationDays.Text = null;
            this.txtOverrunCost.Text = null;

            this.txtActualDateStart.Text = null;
            this.txtActualDateEnd.Text = null;
            this.txtActualHours.Text = null;
            this.txtActualDurationDays.Text = null;
            this.txtActualCost.Text = null;

            this.txtVarianceHours.Text = null;
            this.txtVarianceDurationDays.Text = null;
            this.txtVarianceCost.Text = null;

            this.ucPlanDateStart.SelectedDate = null;
            this.ucPlanDateEnd.SelectedDate = null;
            this.ucOverrunDateEnd.SelectedDate = null;

            using (DataTable _tempStatus = new DataTable())
            {
                _tempStatus.Columns.Add("Code", Type.GetType("System.String"));
                _tempStatus.Columns.Add("Description", Type.GetType("System.String"));
                _tempStatus.Rows.Add("-NONE-", "-NONE-");
                _tempStatus.Merge(DataAccess.GetRecords(DataQueries.GetQTaskStatus()), true);
                this.ddlStatus.DataSource = _tempStatus;
                this.ddlStatus.DataTextField = "Description";
                this.ddlStatus.DataValueField = "Code";
                this.ddlStatus.DataBind();
            }

            //using (DataTable _tempChargeAccount = new DataTable())
            //{
            //    _tempChargeAccount.Columns.Add("Code", Type.GetType("System.String"));
            //    _tempChargeAccount.Columns.Add("Description", Type.GetType("System.String"));
            //    _tempChargeAccount.Rows.Add("-NONE-", "-NONE-");
            //    //edit 6/1/2020 tmc    _tempChargeAccount.Merge(DataAccess.GetRecords(DataQueries.GetTasksChargeAcct()), true);
            //    //_tempChargeAccount.Merge(DataAccess.GetRecords(DataQueries.GetTasksChargeAcct()), true);
            //    this.ddlChargeAccount.DataSource = _tempChargeAccount;
            //    this.ddlChargeAccount.DataTextField = "Description";
            //    this.ddlChargeAccount.DataValueField = "Description";
            //    this.ddlChargeAccount.DataBind();
            //}

            this.ddlRefType.AutoPostBack = true;
            using (DataTable _tempRefType = new DataTable())
            {
                _tempRefType.Columns.Add("Code", Type.GetType("System.String"));
                _tempRefType.Columns.Add("Description", Type.GetType("System.String"));
                _tempRefType.Rows.Add("-NONE-", "-NONE-");
                _tempRefType.Merge(DataAccess.GetRecords(DataQueries.GetQTaskRefType()), true);
                this.ddlRefType.DataSource = _tempRefType;
                this.ddlRefType.DataTextField = "Description";
                this.ddlRefType.DataValueField = "Code";
                this.ddlRefType.DataBind();
            }

            using (DataTable _tempPriority = new DataTable())
            {
                _tempPriority.Columns.Add("Code", Type.GetType("System.String"));
                _tempPriority.Columns.Add("Description", Type.GetType("System.String"));
                _tempPriority.Rows.Add("-NONE-", "-NONE-");
                _tempPriority.Merge(DataAccess.GetRecords(DataQueries.GetQTaskPriority()), true);
                this.ddlPriority.DataSource = _tempPriority;
                this.ddlPriority.DataTextField = "Description";
                this.ddlPriority.DataValueField = "Code";
                this.ddlPriority.DataBind();
            }

            using (DataTable _tempProject = new DataTable())
            {
                _tempProject.Columns.Add("ID", Type.GetType("System.String"));
                _tempProject.Columns.Add("Description", Type.GetType("System.String"));
                _tempProject.Rows.Add("-NONE-", "-NONE-");
                _tempProject.Merge(DataAccess.GetRecords(DataQueries.GetQProject()), true);
                this.ddlProject.DataSource = _tempProject;
                this.ddlProject.DataTextField = "Description";
                this.ddlProject.DataValueField = "ID";
                this.ddlProject.DataBind();
            }

            using (DataTable _tempTaskType = new DataTable())
            {
                _tempTaskType.Columns.Add("Code", Type.GetType("System.String"));
                _tempTaskType.Columns.Add("Description", Type.GetType("System.String"));
                _tempTaskType.Rows.Add("-NONE-", "-NONE-");
                _tempTaskType.Merge(DataAccess.GetRecords(DataQueries.GetStdTasks()), true);
                this.ddlTaskType.DataSource = _tempTaskType;
                this.ddlTaskType.DataTextField = "Description";
                this.ddlTaskType.DataValueField = "Code";
                this.ddlTaskType.DataBind();
            }

            using (DataTable _tempCostType = new DataTable())
            {
                _tempCostType.Columns.Add("Code", Type.GetType("System.String"));
                _tempCostType.Columns.Add("Description", Type.GetType("System.String"));
                _tempCostType.Rows.Add("-NONE-", "-NONE-");
                _tempCostType.Merge(DataAccess.GetRecords(DataQueries.GetQTaskCostType()), true);
                this.ddlCostType.DataSource = _tempCostType;
                this.ddlCostType.DataTextField = "Description";
                this.ddlCostType.DataValueField = "Code";
                this.ddlCostType.DataBind();
            }

            using (DataTable _tempAssignedBy = new DataTable())
            {
                _tempAssignedBy.Columns.Add("Employee ID", Type.GetType("System.Int32"));
                _tempAssignedBy.Columns.Add("User Name", Type.GetType("System.String"));
                _tempAssignedBy.Rows.Add(0, "-NONE-");
                _tempAssignedBy.Merge(DataAccess.GetRecords(DataQueries.GetQUserInfoEmpID()), true);

                this.ddlAssignedBy.DataSource = _tempAssignedBy;
                this.ddlAssignedBy.DataTextField = "User Name";
                this.ddlAssignedBy.DataValueField = "Employee ID";
                this.ddlAssignedBy.DataBind();

                this.ddlAssignedTo.AutoPostBack = true;
                this.ddlAssignedTo.DataSource = _tempAssignedBy;
                this.ddlAssignedTo.DataTextField = "User Name";
                this.ddlAssignedTo.DataValueField = "Employee ID";
                this.ddlAssignedTo.DataBind();
            }

            using (DataTable _tempAssignedWG = new DataTable())
            {
                _tempAssignedWG.Columns.Add("Code", Type.GetType("System.String"));
                _tempAssignedWG.Columns.Add("Description", Type.GetType("System.String"));
                _tempAssignedWG.Rows.Add("-NONE-", "-NONE-");
                _tempAssignedWG.Merge(DataAccess.GetRecords(DataQueries.GetQWorkGroups()), true);
                this.ddlAssignedWG.DataSource = _tempAssignedWG;
                this.ddlAssignedWG.DataTextField = "Description";
                this.ddlAssignedWG.DataValueField = "Code";
                this.ddlAssignedWG.DataBind();
            }

            //Register Script for Delete Button
            this.btnDelete.OnClientClick = "GetTaskDeleteUserConf()";
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Initialize Grid Views
    /// </summary>
    private void InitializeGrids()
    {
        try
        {
            this.gvAttachedFiles.EnableViewState = false;
            this.gvAttachedFiles.Controls.Clear();

            this.gvNotes.EnableViewState = false;
            this.gvNotes.Controls.Clear();

            this.gvReferenceType.EnableViewState = false;
            this.gvReferenceType.Controls.Clear();
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
                //this.txtStatus.CssClass = "CtrlMediumValueView";
                //this.txtTaskType.CssClass = "CtrlWideValueView";
                //this.txtChargeAccount.CssClass = "CtrlMediumValueView";
                //this.txtCostType.CssClass = "CtrlMediumValueView";
                //this.txtRefType.CssClass = "CtrlMediumValueView";
                //this.txtRefID.CssClass = "CtrlShortValueView"; 
                //this.txtProject.CssClass = "CtrlWideValueView";
                //this.txtDescription.CssClass = "CtrlWideValueView";

                //this.txtAssignedBy.CssClass = "CtrlMediumValueView";
                //this.txtPriority.CssClass = "CtrlShortValueView";
                //this.txtAssignedTo.CssClass = "CtrlMediumValueView";
                //this.txtDateAssignedTo.CssClass = "CtrlShortValueView";
                //this.txtAssignedWG.CssClass = "CtrlWideValueView";
                //this.txtAssignment.CssClass = "CtrlWideValueView";

                //this.txtPercent.CssClass = "CtrlShortValueView";

                //this.txtPlanDateStart.CssClass = "CtrlShortValueView";
                //this.txtPlanDateEnd.CssClass = "CtrlShortValueView";
                //this.txtPlanHours.CssClass = "CtrlShortValueViewCenter";
                //this.txtPlanDurationDays.CssClass = "CtrlShortValueViewCenter";
                //this.txtPlanCost.CssClass = "CtrlShortValueViewRight";

                //this.txtOverrunDateEnd.CssClass = "CtrlShortValueView";
                //this.txtOverrunHours.CssClass = "CtrlShortValueViewCenter";
                //this.txtOverrunDurationDays.CssClass = "CtrlShortValueViewCenter";
                //this.txtOverrunCost.CssClass = "CtrlShortValueViewRight";

                //this.txtActualDateStart.CssClass = "CtrlShortValueView";
                //this.txtActualDateEnd.CssClass = "CtrlShortValueView";
                //this.txtActualHours.CssClass = "CtrlShortValueViewCenter";
                //this.txtActualDurationDays.CssClass = "CtrlShortValueViewCenter";
                //this.txtActualCost.CssClass = "CtrlShortValueViewRight";

                //this.txtVarianceHours.CssClass = "CtrlShortValueViewCenter";
                //this.txtVarianceDurationDays.CssClass = "CtrlShortValueViewCenter";
                //this.txtVarianceCost.CssClass = "CtrlShortValueViewRight";

                //Set Read Only      
                this.txtTID.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtTaskType.ReadOnly = true;
                //this.txtChargeAccount.ReadOnly = true;
                this.txtCostType.ReadOnly = true;
                this.txtRefType.ReadOnly = true;
                this.txtRefID.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.txtDescription.ReadOnly = true;

                this.txtAssignedBy.ReadOnly = true;
                this.txtPriority.ReadOnly = true;
                this.txtAssignedTo.ReadOnly = true;
                this.txtDateAssignedTo.ReadOnly = true;
                this.txtAssignedWG.ReadOnly = true;
                this.txtAssignment.ReadOnly = true;

                this.txtPercent.ReadOnly = true;

                this.txtPlanDateStart.ReadOnly = true;
                this.txtPlanDateEnd.ReadOnly = true;
                this.txtPlanHours.ReadOnly = true;
                this.txtPlanDurationDays.ReadOnly = true;
                this.txtPlanCost.ReadOnly = true;

                this.txtOverrunDateEnd.ReadOnly = true;
                this.txtOverrunHours.ReadOnly = true;
                this.txtOverrunDurationDays.ReadOnly = true;
                this.txtOverrunCost.ReadOnly = true;

                this.txtActualDateStart.ReadOnly = true;
                this.txtActualDateEnd.ReadOnly = true;
                this.txtActualHours.ReadOnly = true;
                this.txtActualDurationDays.ReadOnly = true;
                this.txtActualCost.ReadOnly = true;

                this.txtVarianceHours.ReadOnly = true;
                this.txtVarianceDurationDays.ReadOnly = true;
                this.txtVarianceCost.ReadOnly = true;

                this.cbSchedule.Enabled = false;

                //Hide Edit Controls    
                this.ddlStatus.Visible = false;
                this.ddlTaskType.Visible = false;
                //this.ddlChargeAccount.Visible = false;
                this.ddlCostType.Visible = false;
                this.ddlRefType.Visible = false;
                this.ddlProject.Visible = false;

                this.ddlAssignedBy.Visible = false;
                this.ddlPriority.Visible = false;
                this.ddlAssignedTo.Visible = false;
                this.ddlAssignedWG.Visible = false;

                this.ucDateAssignedTo.Visible = false;
                this.ucPlanDateStart.Visible = false;
                this.ucPlanDateEnd.Visible = false;
                this.ucOverrunDateEnd.Visible = false;

                this.btnListToggle.Enabled = false;

                //Show View Controls
                this.txtStatus.Visible = true;
                this.txtTaskType.Visible = true;
                this.txtChargeAccount.Visible = true;
                this.txtCostType.Visible = true;
                this.txtRefType.Visible = true;
                this.txtProject.Visible = true;

                this.txtAssignedBy.Visible = true;
                this.txtPriority.Visible = true;
                this.txtAssignedTo.Visible = true;
                this.txtAssignedWG.Visible = true;
                this.txtDateAssignedTo.Visible = true;

                this.txtPlanDateStart.Visible = true;
                this.txtPlanDateEnd.Visible = true;
                this.txtOverrunDateEnd.Visible = true;


            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                //Apply Edit Style

                //this.ddlStatus.CssClass = "CtrlMediumValueEdit";
                //this.ddlTaskType.CssClass = "CtrlWideValueEdit";
                //this.ddlChargeAccount.CssClass = "CtrlMediumValueEdit";
                //this.ddlCostType.CssClass = "CtrlMediumValueEdit";
                //this.ddlRefType.CssClass = "CtrlMediumValueEdit";
                //this.ddlProject.CssClass = "CtrlWideValueEdit";
                //this.txtDescription.CssClass = "CtrlWideValueEdit";

                //this.ddlAssignedBy.CssClass = "CtrlMediumValueEdit";
                //this.ddlPriority.CssClass = "CtrlShortValueEdit";            
                //this.ddlAssignedTo.CssClass = "CtrlMediumValueEdit"; 
                //this.ddlAssignedWG.CssClass = "CtrlWideValueEdit";
                //this.txtAssignment.CssClass = "CtrlWideValueEdit";
                //this.ucDateAssignedTo.CssClass = "CtrlShortValueEdit";

                //this.txtPercent.CssClass = "CtrlShortValueEdit";

                //this.ucPlanDateStart.CssClass = "CtrlShortValueEdit";
                //this.ucPlanDateEnd.CssClass = "CtrlShortValueEdit";
                //this.txtPlanHours.CssClass = "CtrlShortValueEdit";
                //this.txtPlanCost.CssClass = "CtrlShortValueEdit";
                //this.ucOverrunDateEnd.CssClass = "CtrlShortValueEdit";
                //this.txtOverrunHours.CssClass = "CtrlShortValueEdit";
                //this.txtOverrunCost.CssClass = "CtrlShortValueEdit";

                // CHECK Configuration whether Editing allowed for actuals 
                String _AllowEditing = null;
                Boolean _IsEditAllowed = false;

                //_AllowEditing = Utils.GetSystemConfigurationReturnValue("ERMSProg", "ETAEDITACTUALS");
                if (!String.IsNullOrEmpty(_AllowEditing))
                {
                    if (_AllowEditing == "Y")
                    {
                        _IsEditAllowed = true;
                    }
                }

                if (_IsEditAllowed)
                {
                    //this.txtActualDateStart.CssClass = "CtrlShortValueEdit";
                    //this.txtActualDateEnd.CssClass = "CtrlShortValueEdit";
                    //this.txtActualHours.CssClass = "CtrlShortValueEdit";
                    //this.txtActualCost.CssClass = "CtrlShortValueEdit";
                }

                //Reset the Read Only  
                this.txtTID.ReadOnly = false;
                this.txtDescription.ReadOnly = false;
                this.txtAssignment.ReadOnly = false;

                this.txtPercent.ReadOnly = false;
                this.txtPlanHours.ReadOnly = false;
                this.txtPlanCost.ReadOnly = false;
                this.txtOverrunHours.ReadOnly = false;
                this.txtOverrunCost.ReadOnly = false;

                if (_IsEditAllowed)
                {
                    this.txtActualDateStart.ReadOnly = false;
                    this.txtActualDateEnd.ReadOnly = false;
                    this.txtActualHours.ReadOnly = false;
                    this.txtActualCost.ReadOnly = false;
                }

                this.cbSchedule.Enabled = true;

                //Hide View Controls
                this.txtStatus.Visible = false;
                this.txtTaskType.Visible = false;
                //this.txtChargeAccount.Visible = false;
                this.txtCostType.Visible = false;
                this.txtRefType.Visible = false;
                this.txtProject.Visible = false;

                this.txtAssignedBy.Visible = false;
                this.txtPriority.Visible = false;
                this.txtAssignedTo.Visible = false;
                this.txtAssignedWG.Visible = false;
                this.txtDateAssignedTo.Visible = false;

                this.txtPlanDateStart.Visible = false;
                this.txtPlanDateEnd.Visible = false;
                this.txtOverrunDateEnd.Visible = false;

                //Show Edit Controls
                this.ddlStatus.Visible = true;
                this.ddlTaskType.Visible = true;
                //this.ddlChargeAccount.Visible = true;
                this.ddlCostType.Visible = true;
                this.ddlRefType.Visible = true;
                this.ddlProject.Visible = true;

                this.ddlAssignedBy.Visible = true;
                this.ddlPriority.Visible = true;
                this.ddlAssignedTo.Visible = true;
                this.ddlAssignedWG.Visible = true;
                this.ucDateAssignedTo.Visible = true;

                this.ucPlanDateStart.Visible = true;
                this.ucPlanDateEnd.Visible = true;
                this.ucOverrunDateEnd.Visible = true;

                this.btnListToggle.Enabled = true;

                //Initialize from View Controls       
                this.ucDateAssignedTo.SelectedDate = this.txtDateAssignedTo.Text;
                this.ucPlanDateStart.SelectedDate = this.txtPlanDateStart.Text;
                this.ucPlanDateEnd.SelectedDate = this.txtPlanDateEnd.Text;
                this.ucOverrunDateEnd.SelectedDate = this.txtOverrunDateEnd.Text;

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlStatus.Items.FindByText(this.txtStatus.Text.Trim());
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlTaskType.Items.FindByText(this.txtTaskType.Text.Trim());
                this.ddlTaskType.SelectedIndex = this.ddlTaskType.Items.IndexOf(liSelectedItem);

                //liSelectedItem = this.ddlChargeAccount.Items.FindByText(this.txtChargeAccount.Text.Trim());
                //this.ddlChargeAccount.SelectedIndex = this.ddlChargeAccount.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlCostType.Items.FindByText(this.txtCostType.Text.Trim());
                this.ddlCostType.SelectedIndex = this.ddlCostType.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlRefType.Items.FindByText(this.txtRefType.Text.Trim());
                this.ddlRefType.SelectedIndex = this.ddlRefType.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlProject.Items.FindByText(this.txtProject.Text.Trim());
                this.ddlProject.SelectedIndex = this.ddlProject.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlAssignedBy.Items.FindByText(this.txtAssignedBy.Text.Trim());
                this.ddlAssignedBy.SelectedIndex = this.ddlAssignedBy.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlPriority.Items.FindByText(this.txtPriority.Text.Trim());
                this.ddlPriority.SelectedIndex = this.ddlPriority.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlAssignedTo.Items.FindByText(this.txtAssignedTo.Text.Trim());
                this.ddlAssignedTo.SelectedIndex = this.ddlAssignedTo.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlAssignedWG.Items.FindByText(this.txtAssignedWG.Text.Trim());
                this.ddlAssignedWG.SelectedIndex = this.ddlAssignedWG.Items.IndexOf(liSelectedItem);

            } //end if - EDIT
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
    }

    /// <summary>
    /// Get Custom Fields
    /// </summary>
    /// <param name="COID"></param>
    /// <returns></returns>
    private Int32 GetCustomFieldsInfo(String TID)
    {
        Int32 _rowCount = 0;
        String strHtml = "";
        String[] arrCustomLabels = new String[10];
        String strLabel = "";
        Int32 rowOrderCnt = 0;
        String strValue = "";

        try
        {
            using (DataTable _tempCustomLabels = DataAccess.GetRecords(DataQueries.GetCustomLabels("TM")))
            {
                for (Int32 i = 1; i <= 10; i++)
                {
                    strLabel = "UDFLbl" + i;

                    _rowCount = _tempCustomLabels.Rows.Count;

                    if (_rowCount > 0)
                    {
                        arrCustomLabels[i - 1] = _tempCustomLabels.Rows[0][strLabel].ToString();
                    }
                }
            }

            lblAssign.Text = "Assign Custom Fields Value";

            using (DataTable _tempCustomInfo = DataAccess.GetRecords(DataQueries.GetCustomValues(TID, "TASK")))
            {
                _rowCount = _tempCustomInfo.Rows.Count;

                if (_rowCount > 0)
                {
                    strHtml = "<table class=\"Table\" cellspacing=\"0\" cellpadding=\"2\" border=\"1\">";
                    for (Int32 i = 1; i <= 10; i++)
                    {
                        if (_tempCustomInfo.Rows[0]["UDF" + i].ToString() != null && _tempCustomInfo.Rows[0]["UDF" + i].ToString().Length > 0 &&
                            arrCustomLabels[i - 1] != null && arrCustomLabels[i - 1].Length > 0)
                        {

                            if (rowOrderCnt == 2)
                            {
                                strHtml = strHtml + "</tr>";
                                rowOrderCnt = 0;
                            }
                            if (rowOrderCnt == 0)
                            {
                                strHtml = strHtml + "<tr>";
                            }
                            rowOrderCnt = rowOrderCnt + 1;

                            if (i < 7)
                            {
                                strValue = _tempCustomInfo.Rows[0]["UDF" + i].ToString();
                            }
                            else
                            {
                                strValue = _tempCustomInfo.Rows[0]["UDF" + i] != null && _tempCustomInfo.Rows[0]["UDF" + i].ToString().Equals("True") ? "Applicable" : "Not Applicable";
                            }

                            strHtml = strHtml + "<td class=\"FieldHeaderNew\">";
                            strHtml = strHtml + arrCustomLabels[i - 1] + ":</td> <td colspan=\"2\" class=\"FieldContent\">";
                            strHtml = strHtml + strValue + "</td>";

                            lblAssign.Text = "Modify Custom Fields Value";
                        }

                    }
                    strHtml = strHtml + "</tr></table>";

                }


            }

            if (strHtml != null && strHtml.Length > 0)
            {
                CustomLiteral.Text = strHtml;
            }

        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }

        return _rowCount;
    }


    protected void btnNew_Click(object sender, EventArgs e)
    {
        if (this.btnNew.Text == "New Task")
        {
            InitializeFormFields();
            this.txtTID.Text = Utils.GetTasksNewID().ToString();

            SetForm(FORM_ON.Edit);
            this.txtTID.ReadOnly = false;

            this.btnNew.Text = "Save";
            this.btnNew.Visible = true;
            this.btnEdit.Visible = false;
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
            this.btnEdit.Text = "Update";
            this.btnNew.Visible = false;
            this.btnEdit.Visible = IsEditAllow;//true;
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
            Int32 TaskID = 0;
            String _TaskID = this.txtTID.Text;
            if (!String.IsNullOrEmpty(_TaskID))
            {
                TaskID = Convert.ToInt32(_TaskID);
            }

            if (TaskID == 0)
            {
                throw new Exception("An [ID] could not be located or created. The record will not be saved.");
            }

            //String ChargeAccount = null;
            //if (this.ddlChargeAccount.SelectedItem.Text != "-NONE-")
            //{
            //    ChargeAccount = this.ddlChargeAccount.SelectedItem.Value;
            //}

            String ChargeAccount = null;
            if (!String.IsNullOrEmpty(this.txtChargeAccount.Text))
            {
                ChargeAccount = this.txtChargeAccount.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "ChargeAcct"))
                {
                    throw new Exception("A [Charge Acct] could not be located or created. The record will not be saved.");
                }
            }

            String TaskStatus = null;
            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
            {
                TaskStatus = this.ddlStatus.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "TaskStatus"))
                {
                    throw new Exception("A [Status] could not be located or created. The record will not be saved.");
                }
            }

            String Description = null;
            if (!String.IsNullOrEmpty(this.txtDescription.Text))
            {
                Description = this.txtDescription.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "TaskDesc"))
                {
                    throw new Exception("A [Description] could not be located or created. The record will not be saved.");
                }
            }

            String ProjectID = null;
            if (this.ddlProject.SelectedItem.Text != "-NONE-")
            {
                ProjectID = this.ddlProject.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "ProjNum"))
                {
                    throw new Exception("A [Project] could not be located or created. The record will not be saved.");
                }
            }

            String TaskType = null;
            if (this.ddlTaskType.SelectedItem.Text != "-NONE-")
            {
                TaskType = this.ddlTaskType.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "StdTaskID"))
                {
                    throw new Exception("A [Task Type] could not be located or created. The record will not be saved.");
                }
            }

            String CostType = null;
            if (this.ddlCostType.SelectedItem.Text != "-NONE-")
            {
                CostType = this.ddlCostType.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "TaskCostType"))
                {
                    throw new Exception("A [Cost Type] could not be located or created. The record will not be saved.");
                }
            }

            String RefType = null;
            if (this.ddlRefType.SelectedItem.Text != "-NONE-")
            {
                RefType = this.ddlRefType.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "RefType"))
                {
                    throw new Exception("A [Reference Type] could not be located or created. The record will not be saved.");
                }
            }

            String RefID = null;
            if (!String.IsNullOrEmpty(this.txtRefID.Text))
            {
                RefID = this.txtRefID.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "RefNum"))
                {
                    throw new Exception("A [Reference Number] could not be located or created. The record will not be saved.");
                }
            }

            Int32 ParentTask = 0;
            if (this.ddlRefType.SelectedItem.Text == Constants.TaskReferenceType && !String.IsNullOrEmpty(this.txtRefID.Text))
            {
                ParentTask = Convert.ToInt32(this.txtRefID.Text);
            }

            String TaskPriority = null;
            if (this.ddlPriority.SelectedItem.Text != "-NONE-")
            {
                TaskPriority = this.ddlPriority.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "TaskPriority"))
                {
                    throw new Exception("A [Priority] could not be located or created. The record will not be saved.");
                }
            }

            Int32 AssignBy = 0;
            if (this.ddlAssignedBy.SelectedItem.Text != "-NONE-")
            {
                AssignBy = Convert.ToInt32(this.ddlAssignedBy.SelectedItem.Value);
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "AssignBy"))
                {
                    throw new Exception("The person [Assigned By] could not be located or created. The record will not be saved.");
                }
            }

            Int32 AssignTo = 0;
            if (this.ddlAssignedTo.SelectedItem.Text != "-NONE-")
            {
                AssignTo = Convert.ToInt32(this.ddlAssignedTo.SelectedItem.Value);
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "AssignTo"))
                {
                    throw new Exception("The person [Assigned To] could not be located or created. The record will not be saved.");
                }
            }

            DateTime TaskAssignedDate;
            if (!String.IsNullOrEmpty(this.ucDateAssignedTo.SelectedDate) && AssignTo > 0)
            {
                TaskAssignedDate = Convert.ToDateTime(this.ucDateAssignedTo.SelectedDate);
            }
            else
            {
                TaskAssignedDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            }

            String AssignedWG = null;
            if (this.ddlAssignedWG.SelectedItem.Text != "-NONE-")
            {
                AssignedWG = this.ddlAssignedWG.SelectedItem.Value;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "AssignWkgrp"))
                {
                    throw new Exception("The [Assigned Workgroup] could not be located or created. The record will not be saved.");
                }
            }

            String TaskDetail = null;
            if (!String.IsNullOrEmpty(this.txtAssignment.Text))
            {
                TaskDetail = this.txtAssignment.Text;
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "TaskDetail"))
                {
                    throw new Exception("An [Assignment] could not be located or created. The record will not be saved.");
                }
            }

            DateTime PlannedStartDate;
            if (!String.IsNullOrEmpty(this.ucPlanDateStart.SelectedDate))
            {
                PlannedStartDate = Convert.ToDateTime(this.ucPlanDateStart.SelectedDate);
                //PlannedStartDate = DateTime.ParseExact(this.ucPlanDateStart.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "PlannedStart"))
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
                // PlannedEndDate = DateTime.ParseExact(this.ucPlanDateEnd.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "PlannedFinish"))
                {
                    throw new Exception("A [Planned Finish Date] could not be located or created. The record will not be saved.");
                }
                else
                {
                    PlannedEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
                }
            }

            if ((DateTime.Compare(PlannedEndDate, PlannedStartDate) < 0) || (DateTime.Compare(PlannedEndDate, DateTime.Today) < 0))
            {
                throw new Exception("A [Planned Finish Date] cannot be earlier than [Planned Start Date] Or Today. The record will not be saved.");
            }

            Single PlannedHours = 0.0f;
            if (!String.IsNullOrEmpty(this.txtPlanHours.Text))
            {
                PlannedHours = Convert.ToSingle(this.txtPlanHours.Text);
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "EstHours"))
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
                if (Utils.IsRequiredField("Tasks", "EstCost"))
                {
                    throw new Exception("The [Estimated Cost] could not be located or created. The record will not be saved.");
                }
            }

            DateTime OverrunEndDate;
            if (!String.IsNullOrEmpty(this.ucOverrunDateEnd.SelectedDate))
            {
                OverrunEndDate = Convert.ToDateTime(this.ucOverrunDateEnd.SelectedDate);
                //OverrunEndDate = DateTime.ParseExact(this.ucOverrunDateEnd.SelectedDate, "MM-dd-yyyy", CultureInfo.InvariantCulture);
            }
            else
            {
                OverrunEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            }

            Single OverrunHours = 0.0f;
            if (!String.IsNullOrEmpty(this.txtOverrunHours.Text))
            {
                OverrunHours = Convert.ToSingle(this.txtOverrunHours.Text);
            }

            Decimal OverrunCost = Convert.ToDecimal(0.0);
            if (!String.IsNullOrEmpty(this.txtOverrunCost.Text))
            {
                OverrunCost = Convert.ToDecimal(this.txtOverrunCost.Text.Replace("$", ""));
            }

            DateTime ActualStartDate;
            if (!String.IsNullOrEmpty(this.txtActualDateStart.Text))
            {
                ActualStartDate = Convert.ToDateTime(this.txtActualDateStart.Text);
                // ActualStartDate = DateTime.ParseExact(this.txtActualDateStart.Text, "MM-dd-yyyy", CultureInfo.InvariantCulture);
            }
            else
            {
                ActualStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            }

            DateTime ActualEndDate;
            if (!String.IsNullOrEmpty(this.txtActualDateEnd.Text))
            {
                ActualEndDate = Convert.ToDateTime(this.txtActualDateEnd.Text);
                // ActualEndDate = DateTime.ParseExact(this.txtActualDateEnd.Text, "MM-dd-yyyy", CultureInfo.InvariantCulture);
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

            Single PercentComplete = 0.0f;
            if (!String.IsNullOrEmpty(this.txtPercent.Text))
            {
                PercentComplete = Convert.ToSingle(this.txtPercent.Text);
            }
            else
            {
                if (Utils.IsRequiredField("Tasks", "PcntComplete"))
                {
                    throw new Exception("The [Percent Complete] could not be located or created. The record will not be saved.");
                }
            }

            String IsScheduled;
            if (this.cbSchedule.Checked)
            {
                IsScheduled = "-1";
            }
            else
            {
                IsScheduled = "0";
            }

            String LastModifiedBy = _SessionUser;
            DateTime LastModifiedDate = DateTime.Now;

            // start of my 6/1/2020 test 

            if (action == "Update")
            {
                DataAccess.ModifyRecords(DataQueries.UpdateIntoTasks(ParentTask, TaskStatus, TaskPriority, CostType, TaskAssignedDate, PercentComplete,
                                                               ChargeAccount, RefType, RefID, ProjectID, TaskType, Description, TaskDetail,
                                                               PlannedStartDate, PlannedEndDate, PlannedHours, 0, PlannedCost,
                                                               OverrunHours, OverrunEndDate, OverrunCost, ActualStartDate,
                                                               ActualEndDate, ActualHours, ActualCost, AssignBy, AssignTo, AssignedWG, IsScheduled, TaskID));
            }


            if (action == "Save")
            {

                DataAccess.ModifyRecords(DataQueries.InsertIntoTasks(ParentTask, TaskStatus, TaskPriority, CostType, TaskAssignedDate, PercentComplete,
                                                                ChargeAccount, RefType, RefID, ProjectID, TaskType, Description, TaskDetail,
                                                                PlannedStartDate, PlannedEndDate, PlannedHours, 0, PlannedCost,
                                                                OverrunHours, OverrunEndDate, OverrunCost, ActualStartDate,
                                                                ActualEndDate, ActualHours, ActualCost, AssignBy, AssignTo, AssignedWG, IsScheduled));
            }

            // end of my 6/1/2020 test tmc

            GetRecord(TaskID);
            GetGrids(TaskID);
            SetLinkURLs(TaskID);

            SetForm(FORM_ON.View);
            this.btnFind.AlternateText = "Find New Task";
            this.btnEdit.Text = "Edit";
            this.btnNew.Visible = false;
            this.btnEdit.Visible = IsEditAllow;//true;
            this.btnCancel.Visible = false;
            this.btnDelete.Visible = true;
            this.btnFind.Visible = true;

        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
}
