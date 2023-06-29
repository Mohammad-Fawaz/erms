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
using System.Net.Mail;

/// <summary>
/// WF Task Class
/// </summary>
public partial class WFManagement_TaskInformationReview : System.Web.UI.Page
{
    public String _SID;
    public String _SessionUser;
    public Int32 _SessionUserID;
        
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
            _SID = this.Master.SID; 
            _SessionUser = this.Master.UserName;
            _SessionUserID = this.Master.EmpID; 
            
            //Get TaskID          
            String _RefTypeCode = Request.QueryString["RFTP"];
            String _RefID = Request.QueryString["RFID"];           
            String _HeaderWFTaskID = Request.QueryString["TID"];
            
            SetLinkURLs(_RefTypeCode, _RefID, _HeaderWFTaskID);
           
            if (!IsPostBack)
            {               
                InitializeFormStepFields();             
                SetFormStep(FORM_ON.View);

                Int32 _WFTaskID = 0;
                if (!String.IsNullOrEmpty(_HeaderWFTaskID))
                {
                    _WFTaskID = Convert.ToInt32(_HeaderWFTaskID);
                    GetRecordWFTask(_WFTaskID);

                    switch(this.hdnWFTaskTypeCode.Value.ToUpper())
                    {
                        case "APPR":
                            this.btnApprove.Visible = true;
                            this.btnDeny.Visible = true;
                            this.btnCancel.Visible = true;
                            this.pnlProcessTask.Visible = false;
                            break;
                        case "TASK":                                                 
                            this.btnCancel.Visible = true;
                            this.btnDeny.Visible = true;
                            this.btnUpdateProgress.Visible = true; 
                            this.pnlProcessTask.Visible = true;      
                            break;
                        case "REVW":                        
                            this.btnReview.Visible = true;
                            this.btnCancel.Visible = true;
                            this.pnlProcessTask.Visible = false;
                            break;
                        default:
                            Server.Transfer("WFTaskInformation.aspx?SID=" + _SID + "&RFTP=" + _RefTypeCode
                                                + "&RFID=" + _RefID + "&TID=" + _WFTaskID); 
                            break;
                    }                    
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
    /// <param name="RefType"></param>
    /// <param name="RefID"></param>
    private void SetLinkURLs(String RefType, String RefID, String _HeaderWFTaskID)
    {
        switch (RefType)
        {
            case Constants.ChangeReferenceType:
                hlnkReferenceItem.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.DocReferenceType:
                hlnkReferenceItem.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + RefID;
                break;
            case Constants.TaskReferenceType:
                hlnkReferenceItem.NavigateUrl = "~/TaskManagement/TaskInformation.aspx?SID=" + _SID + "&TID=" + RefID;
                break;
            case Constants.MaterialDispReferenceType:
                //hlnkReferenceItem.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.NonConformanceReferenceType:
                //hlnkReferenceItem.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.CorrectiveActionReferenceType:
                //hlnkReferenceItem.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.ProjectReferenceType:
                hlnkReferenceItem.NavigateUrl = "~/ProjectManagement/ProjectInformation.aspx?SID=" + _SID + "&PID=" + RefID;
                break;
        }
               
        this.hlnkAttachFiles.NavigateUrl = "~/TaskManagement/AttachFiles.aspx?SID=" + _SID + "&TID=" + _HeaderWFTaskID;
        this.hlnkNotes.NavigateUrl = "~/TaskManagement/AddNotes.aspx?SID=" + _SID + "&TID=" + _HeaderWFTaskID;
        this.hlnkToDo.NavigateUrl = "~/Actions/ToDo.aspx?SID=" + _SID;
    }
    
    /// <summary>
    /// Cancel Template
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        try
        {
            Server.Transfer("~/Actions/ToDo.aspx?SID=" + _SID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage       
        }
    }
    
    #region NOT USED - MAY BE IN FUTURE

    /// <summary>
    /// Update WorkFlow
    /// </summary>
    /// <param name="Action"></param>
    private void UpdateWorkflow(String Action)
    {
        //DateTime _CurrentDate = DateTime.Now;

        ////Template ID
        //Int32 _WFTemplateID = 0;
        //if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
        //{
        //    _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);
        //}
        //if (_WFTemplateID == 0)
        //{
        //    throw new Exception("A [Template ID] could not be located or created. The record will not be saved.");
        //}

        ////Header Reference Control Code
        //String _HeaderControlRefCode = this.hdnHeaderRefTypeCode.Value;
        //if (String.IsNullOrEmpty(_HeaderControlRefCode))
        //{
        //    throw new Exception("A [Reference Type] could not be located or created. The record will not be saved.");
        //}

        ////Header Reference ID
        //String _HeaderControlRefID = this.txtHeaderRefID.Text;
        //if (String.IsNullOrEmpty(_HeaderControlRefID))
        //{
        //    throw new Exception("A [Reference ID] could not be located or created. The record will not be saved.");
        //}

        //Int32 _WFTaskID = 0;



        ////WF Task ID
        //if (!String.IsNullOrEmpty(this.hdnWFTaskID.Value))
        //{
        //    _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);
        //}
        //if (_WFTaskID == 0)
        //{
        //    throw new Exception("A [Workflow Task ID] could not be located or created. The record will not be saved.");
        //}


        //String _RefControlID = this.txtRefControlID.Text;

        ////Step Number   
        //Int32 _StepNumber = 0;
        //if (!String.IsNullOrEmpty(this.txtStepNumber.Text))
        //{
        //    _StepNumber = Convert.ToInt32(this.txtStepNumber.Text);
        //}

        //Priority
        //String _Priority = null;
        //if (this.ddlPriority.SelectedItem.Text != "-NONE-")
        //{
        //    _Priority = this.ddlPriority.SelectedItem.Value;
        //}

        ////Project
        //String _Project = null;
        //if (this.ddlProject.SelectedItem.Text != "-NONE-")
        //{
        //    _Project = this.ddlProject.SelectedItem.Value;
        //}

        ////Description
        //String _TaskDescription = this.txtTaskDescription.Text;

        //String _StepDescription = this.txtStepDescription.Text;
        //DateTime _MinDate = Convert.ToDateTime(Constants.DateTimeMinimum);

        ////Update
        //if (Action == "Update")
        //{

            //Update Tasks
            //DataAccess.ModifyRecords(DataQueries.UpdateTasks(_ChargeCode,_TaskStatusCode,_TaskDescription,_Project,
            //                                                 _StdTaskCode, _HeaderControlRefCode,_HeaderControlRefID,
            //                                                 _Priority,_AssignByID, _AssignToID, _CurrentDate, _StepDescription,
            //                                                 _PlannedStartDate, _PlannedEndDate, _PlannedHours, _PlannedCost,
            //                                                 _OverrunEndDate, _OverrunHours, _OverrunCost, _ActualStartDate,
            //                                                 _ActualEndDate, _ActualHours, _ActualCost,_PercentComplete, _TaskID));    

            //Update Workflow Tasks
            //DataAccess.ModifyRecords(DataQueries.UpdateWFlowTasks(_WFTemplateID, _WFTemplateItemID, _HeaderControlRefCode,
            //                                                      _HeaderControlRefID, _TaskID, _StepActionTypeCode,
            //                                                      _StepNumber.ToString(), _NextStepNumber.ToString(), _NextStatusCode,
            //                                                      _BackStepNumber.ToString(), _BackStatusCode, _AssignByCode, _AssignByID,
            //                                                      _AssignToCode, _AssignToID, _RefControlCode, _RefControlID,
            //                                                      _ReferenceParams, _AdjPlannedStartDate, _AdjPlannedEndDate,
            //                                                      _AdjOverrunEndDate, _AdjActualStartDate, _AdjActualEndDate,
            //                                                      _WFTaskID));

            //Update the Reference Item Status.
            //if(_TaskStatusCode == "CLS")
            //{
            //    Utils.UpdateReferenceItemStatus(_HeaderControlRefCode, _HeaderControlRefID,
            //                                    _NextStatusCode, _SessionUser, _CurrentDate);
            //}            
       // }

        //SetFormHeader(FORM_ON.View);
        //SetFormStep(FORM_ON.View);

        //WF Template Header
        //if (GetRecord(_HeaderControlRefCode, _HeaderControlRefID) > 0)
        //{
        //    //WF Task
        //    GetRecordWFTask(_WFTaskID);
        //}

        //this.btnCancel.Visible = false;
    }
    
    #endregion
    
    /// <summary>
    /// On Progress Update
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnUpdateProgress_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);
            SaveProgress();       

            if (this.cbCompleted.Checked)
            {
                UpdateStatus();               
            }
            
            GetRecordWFTask(_WFTaskID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Save Progess
    /// </summary>
    private void SaveProgress()
    {
        try
        {            
            Int32 _TaskID = Convert.ToInt32(this.txtTaskID.Text);

            DateTime OverrunEndDate;
            if (!String.IsNullOrEmpty(this.ucOverrunDateEndProgress.SelectedDate))
            {
                OverrunEndDate = Convert.ToDateTime(this.ucOverrunDateEndProgress.SelectedDate);
            }
            else
            {
                OverrunEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            }

            Single OverrunHours = 0.0f;
            if (!String.IsNullOrEmpty(this.txtOverrunHoursProgress.Text))
            {
                OverrunHours = Convert.ToSingle(this.txtOverrunHoursProgress.Text);
            }

            Decimal OverrunCost = Convert.ToDecimal(0.0);
            if (!String.IsNullOrEmpty(this.txtOverrunCostProgress.Text))
            {
                OverrunCost = Convert.ToDecimal(this.txtOverrunCostProgress.Text.Replace("$", ""));
            }

            DateTime ActualStartDate;
            if (!String.IsNullOrEmpty(this.txtActualDateStartProgress.Text))
            {
                ActualStartDate = Convert.ToDateTime(this.txtActualDateStartProgress.Text);
            }
            else
            {
                ActualStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            }

            DateTime ActualEndDate;
            if (!String.IsNullOrEmpty(this.txtActualDateEndProgress.Text))
            {
                ActualEndDate = Convert.ToDateTime(this.txtActualDateEndProgress.Text);
            }
            else
            {
                ActualEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            }

            Single ActualHours = 0.0f;
            if (!String.IsNullOrEmpty(this.txtActualHoursProgress.Text))
            {
                ActualHours = Convert.ToSingle(this.txtActualHoursProgress.Text);
            }

            Decimal ActualCost = Convert.ToDecimal(0.0);
            if (!String.IsNullOrEmpty(this.txtActualCostProgress.Text))
            {
                ActualCost = Convert.ToDecimal(this.txtActualCostProgress.Text.Replace("$", ""));
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

            DataAccess.ModifyRecords(DataQueries.UpdateTasks(OverrunEndDate, OverrunHours, OverrunCost, 
                                                             ActualStartDate, ActualEndDate, ActualHours, 
                                                             ActualCost, PercentComplete, _TaskID));            
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
    
    /// <summary>
    /// Update Status and Send Email
    /// </summary>
    private void UpdateStatus()
    {
        Int32 _rowCount = 0;

        Int32 _TaskID = Convert.ToInt32(this.txtTaskID.Text);        
        Int32 _ParallelTaskID = 0;

        String _RefID = this.txtRefControlID.Text;
        String _RefTypeCode = this.hdnRefControlTypeCode.Value;
        String _TaskStatusCode = "CLS";
        String _NextStatusCode = this.hdnNextStepStatusCode.Value;        
        String _NextTaskStatusCode = "OPEN";
        String _ParallelTaskStatusCode = null;        
        
        String _CurrentStepID = this.txtStepNumber.Text;
        String _ParallelStepID;
      
        String _NextStepID = this.hdnNextStepNumber.Value;        
        Boolean IsParallelOpen = false;
             
        //Update Current Task Status
        _rowCount = DataAccess.ModifyRecords(DataQueries.UpdateTasksStatus(_TaskID, _TaskStatusCode));

        // Get Next Task and Set Staus to Open 
        // (unless a parallel task is still open) 
        if (_CurrentStepID.IndexOf(".") > 0) //if Parallel Task
        {
            //Check for Open Parallel Step ( upto x.10)
            for (int i = 1; i <= 10; i++)
            {
                _ParallelStepID = Math.Floor(Convert.ToDecimal(_CurrentStepID)).ToString();
                _ParallelStepID = _ParallelStepID.Trim() + '.' + i.ToString();

                //Get Parallel Task ID
                _rowCount = 0;
                using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFTasks(_RefID, _RefTypeCode, _ParallelStepID)))
                {
                    _rowCount = _tempViewWFs.Rows.Count;

                    if (_rowCount > 0)
                    {
                        _ParallelTaskID = Convert.ToInt32(_tempViewWFs.Rows[0]["Task ID"].ToString());
                    }
                }

                //Parallel Step. Get Status of Parallel Task  
                if (_ParallelTaskID > 0)
                {
                    _rowCount = 0;
                    using (DataTable _tempTasks = DataAccess.GetRecords(DataQueries.GetTasksStatus(_ParallelTaskID)))
                    {
                        _rowCount = _tempTasks.Rows.Count;
                        if (_rowCount > 0)
                        {
                            _ParallelTaskStatusCode = _tempTasks.Rows[0]["Task Status"].ToString();
                            if (_ParallelTaskStatusCode.ToUpper() == _NextTaskStatusCode.ToUpper())
                            {
                                IsParallelOpen = true;
                                break;
                            }
                        }
                    }
                }
            } //Parallel Task Check          
        }         

        //All Parallel Tasks are Closed. 
        if (!IsParallelOpen)
        {
            //Update NextTask Status to Open
            UpdateTaskStatus(_RefID, _RefTypeCode, _NextStepID, _NextTaskStatusCode);                        
        }

        //Update Control Refrernce Status
        _rowCount = Utils.UpdateReferenceItemStatus(_RefTypeCode, _RefID, _NextStatusCode,
                                                    _SessionUser, DateTime.Now);        
    }
    
    /// <summary>
    /// Update Parallel/Individual Task
    /// </summary>
    /// <param name="RefID"></param>
    /// <param name="RefTypeCode"></param>
    /// <param name="StepID"></param>
    /// <param name="StatusCode"></param>
    private void UpdateTaskStatus(String RefID, String RefTypeCode, String StepID, 
                                  String StatusCode)
    {
        Int32 _AssignToID = 0;
        Int32 _TaskID = 0;        
        String ParallelStepID = null;
        Boolean IsEmailRequired = false;

        //Is Parallel Step
        if (StepID.IndexOf(".") > 0)
        {
            //Open all Parallel Steps ( upto x.10)
            for (int k = 1; k <= 10; k++)
            {
                ParallelStepID = Math.Floor(Convert.ToDecimal(StepID)).ToString();
                ParallelStepID = ParallelStepID.Trim() + '.' + k.ToString();

                //Get Task ID
                Int32 _rowCount = 0;
                using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFTasks(RefID, RefTypeCode, ParallelStepID)))
                {
                    _rowCount = _tempViewWFs.Rows.Count;
                    if (_rowCount > 0)
                    {
                        //Get Record Values
                        _TaskID = Convert.ToInt32(_tempViewWFs.Rows[0]["Task ID"].ToString());
                        if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["IseMailRequired"].ToString()))
                        {
                            IsEmailRequired = Convert.ToBoolean(_tempViewWFs.Rows[0]["IseMailRequired"].ToString());
                        }
                        _AssignToID = Convert.ToInt32(_tempViewWFs.Rows[0]["WFTask Assgn To Type ID"].ToString());

                        _rowCount = DataAccess.ModifyRecords(DataQueries.UpdateTasksStatus(_TaskID, StatusCode));

                        //Send Mail
                        if (IsEmailRequired)
                        {
                            NotifyAssignedTo(_AssignToID, _TaskID);
                        }                    
                    }
                }
            } //loop 
        }//Parallel Task
        else
        {   
            Int32 _rowCount = 0;
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFTasks(RefID, RefTypeCode, StepID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;
                if (_rowCount > 0)
                {
                    //Get Record Values
                    _TaskID = Convert.ToInt32(_tempViewWFs.Rows[0]["Task ID"].ToString());
                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["IseMailRequired"].ToString()))
                    {
                        IsEmailRequired = Convert.ToBoolean(_tempViewWFs.Rows[0]["IseMailRequired"].ToString());
                    }
                    _AssignToID = Convert.ToInt32(_tempViewWFs.Rows[0]["WFTask Assgn To Type ID"].ToString());
                    _rowCount = DataAccess.ModifyRecords(DataQueries.UpdateTasksStatus(_TaskID, StatusCode));

                    //Send Mail
                    if (IsEmailRequired)
                    {
                        NotifyAssignedTo(_AssignToID, _TaskID);
                    }                   
                }
            }
        } // Individual Task    
    }
    
    /// <summary>
    /// Notification to Assigned To
    /// </summary>
    /// <param name="AssignToID"></param>
    /// <param name="TaskID"></param>
    private void NotifyAssignedTo(Int32 AssignToID, Int32 TaskID)
    {     
        String _emailTo = null;
        using (DataTable _tempUser = DataAccess.GetRecords(DataQueries.GetUserXRefEmail(AssignToID)))
        {
            _emailTo = _tempUser.Rows[0]["eMail"].ToString();
        }

        if (!String.IsNullOrEmpty(_emailTo))
        {
            String _eMailFrom = "Admin@Support.com";
            String _eMailSubjectLine = "Task " + TaskID.ToString() + " Opened";
            String _eMailBody = "Task " + TaskID.ToString() + " Opened";

            //Send Email (if required by next step parameter) 
                //_emailTo = "rk_1972@hotmail.com";
                //_eMailFrom = "rk_1972@hotmail.com";
            Utils.SendEmail(_eMailFrom, _emailTo, _eMailSubjectLine, _eMailBody);
            this.lblStatus.Text = "eMail(s) Sent";
        }
    }
    
    /// <summary>
    /// On Denial
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDeny_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _rowCount = 0;            
            Int32 _TaskID = Convert.ToInt32(this.txtTaskID.Text);
            Int32 _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);
            String _CurrentStepID = this.txtStepNumber.Text;           
            String _BackStepID = this.hdnBackStepNumber.Value;

            String _TaskStatusCode = "HOLD";
            String _BackTaskStatusCode = "OPEN";
            String _BackStatusCode = this.hdnBackStepStatusCode.Value;
            
            String _RefID = this.txtRefControlID.Text;
            String _RefTypeCode = this.hdnRefControlTypeCode.Value;      
 
            //Update Task Status
            UpdateTaskStatus(_RefID, _RefTypeCode, _CurrentStepID, _TaskStatusCode);

            //Update Back Step Status
            UpdateTaskStatus(_RefID, _RefTypeCode, _BackStepID, _BackTaskStatusCode);

            //Update Control Refrernce Status
            _rowCount = Utils.UpdateReferenceItemStatus(_RefTypeCode, _RefID, _BackStatusCode,
                                                        _SessionUser, DateTime.Now);
            GetRecordWFTask(_WFTaskID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }   

    /// <summary>
    /// On Approval
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnApproved_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);

            UpdateStatus();            
            GetRecordWFTask(_WFTaskID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }  
    }

    /// <summary>
    /// On Review Complete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnReview_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);

            UpdateStatus();
            GetRecordWFTask(_WFTaskID);
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }   
    
    /// <summary>
    /// Get WF Step Record
    /// </summary>
    /// <param name="ActionID"></param>
    /// <returns></returns>
    private Int32 GetRecordWFTask(Int32 WFTaskID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFTasks(WFTaskID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {                   
                    this.hdnWFTaskID.Value = WFTaskID.ToString();
                    this.txtRefControlID.Text = _tempViewWFs.Rows[0]["WFTask Control Ref ID"].ToString();
                    this.hdnRefControlTypeCode.Value = _tempViewWFs.Rows[0]["WFTask Control Ref Type"].ToString();
                    this.txtStepNumber.Text = _tempViewWFs.Rows[0]["Step ID"].ToString(); 
                                        
                    this.txtTaskID.Text =  _tempViewWFs.Rows[0]["Task ID"].ToString();
                    this.txtTaskStatus.Text = _tempViewWFs.Rows[0]["Task Status Description"].ToString();
                    this.txtPriority.Text = _tempViewWFs.Rows[0]["Priority Description"].ToString();
                    this.txtProject.Text = _tempViewWFs.Rows[0]["Project Description"].ToString();
                    this.txtTaskDescription.Text = _tempViewWFs.Rows[0]["Task Description"].ToString();                   
                    this.txtStepDescription.Text = _tempViewWFs.Rows[0]["Task Assignment Description"].ToString();                        
                    this.hdnWFTaskTypeCode.Value = _tempViewWFs.Rows[0]["WF Task Type Code"].ToString();

                    this.hdnNextStepNumber.Value = _tempViewWFs.Rows[0]["Next Step ID"].ToString();
                    this.hdnNextStepStatusCode.Value = _tempViewWFs.Rows[0]["Next Step Status"].ToString();
                    this.hdnBackStepNumber.Value = _tempViewWFs.Rows[0]["Back Step ID"].ToString();
                    this.hdnBackStepStatusCode.Value = _tempViewWFs.Rows[0]["Back Step Status"].ToString();
                    
                    String _PlannedStartDate = _tempViewWFs.Rows[0]["Planned Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlannedStartDate) && Constants.DateTimeMinimum != _PlannedStartDate)
                    {
                        this.txtPlanDateStart.Text = Convert.ToDateTime(_PlannedStartDate).ToShortDateString();
                    }

                    String _PlanDateEnd = _tempViewWFs.Rows[0]["Planned End Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlanDateEnd) && Constants.DateTimeMinimum != _PlanDateEnd)
                    {
                        this.txtPlanDateEnd.Text = Convert.ToDateTime(_PlanDateEnd).ToShortDateString();
                    }

                    this.txtPlanHours.Text = _tempViewWFs.Rows[0]["Planned Hours"].ToString();

                    String _PlanCost = _tempViewWFs.Rows[0]["Planned Cost"].ToString();
                    if (!String.IsNullOrEmpty(_PlanCost))
                    {
                        this.txtPlanCost.Text = Convert.ToDecimal(_PlanCost).ToString("c");
                    }

                    String _OverrunDateEnd = _tempViewWFs.Rows[0]["Overrun End Date"].ToString();
                    if (!String.IsNullOrEmpty(_OverrunDateEnd) && Constants.DateTimeMinimum != _OverrunDateEnd)
                    {
                        this.txtOverrunDateEnd.Text = Convert.ToDateTime(_OverrunDateEnd).ToShortDateString();
                        this.ucOverrunDateEndProgress.SelectedDate = Convert.ToDateTime(_OverrunDateEnd).ToShortDateString();
                    }

                    this.txtOverrunHours.Text = _tempViewWFs.Rows[0]["Overrun Hours"].ToString();
                    this.txtOverrunHoursProgress.Text = _tempViewWFs.Rows[0]["Overrun Hours"].ToString();

                    String _OverrunCost = _tempViewWFs.Rows[0]["Overrun Cost"].ToString();
                    if (!String.IsNullOrEmpty(_OverrunCost))
                    {
                        this.txtOverrunCost.Text = Convert.ToDecimal(_OverrunCost).ToString("c");
                        this.txtOverrunCostProgress.Text = Convert.ToDecimal(_OverrunCost).ToString("c");
                    }

                    String _ActualDateStart = _tempViewWFs.Rows[0]["Actual Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualDateStart) && Constants.DateTimeMinimum != _ActualDateStart)
                    {
                        this.txtActualDateStart.Text = Convert.ToDateTime(_ActualDateStart).ToShortDateString();
                        this.ucActualDateStartProgress.SelectedDate = Convert.ToDateTime(_ActualDateStart).ToShortDateString();
                    }

                    String _ActualDateEnd = _tempViewWFs.Rows[0]["Actual End Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualDateEnd) && Constants.DateTimeMinimum != _ActualDateEnd)
                    {
                        this.txtActualDateEnd.Text = Convert.ToDateTime(_ActualDateEnd).ToShortDateString();
                        this.ucActualDateEndProgress.SelectedDate = Convert.ToDateTime(_ActualDateEnd).ToShortDateString();
                    }

                    this.txtActualHours.Text = _tempViewWFs.Rows[0]["Actual Hours"].ToString();
                    this.txtActualHoursProgress.Text = _tempViewWFs.Rows[0]["Actual Hours"].ToString();

                    String _ActualCost = _tempViewWFs.Rows[0]["Actual Cost"].ToString();
                    if (!String.IsNullOrEmpty(_ActualCost))
                    {
                        this.txtActualCost.Text = Convert.ToDecimal(_ActualCost).ToString("c");
                        this.txtActualCostProgress.Text = Convert.ToDecimal(_ActualCost).ToString("c");
                    }                                      

                    this.txtPercent.Text = _tempViewWFs.Rows[0]["Percentage"].ToString();
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
    /// Initialize Step Form
    /// </summary>
    private void InitializeFormStepFields()
    {
        try
        {
            this.lblStatus.Text = null;

            this.txtTaskID.Text = null;
            this.txtTaskStatus.Text = null; 
            this.txtRefControlID.Text = null;
            this.txtStepNumber.Text = null; 
                    
            this.txtPriority.Text = null;
            this.txtProject.Text = null;
            this.txtTaskDescription.Text = null;
            this.txtTaskDescription.TextMode = TextBoxMode.MultiLine;
            this.txtTaskDescription.Height = 50;
         
            this.txtStepDescription.Text = null;
            this.txtStepDescription.TextMode = TextBoxMode.MultiLine;
            this.txtStepDescription.Height = 50;

            this.txtPercent.Text = null;
            this.txtPercent.Width = Unit.Percentage(10.00);
            this.cbCompleted.Text = "Completed";
            this.lblPercent.Text = "% Completed"; 

            this.txtPlanDateStart.Text = null;
            this.txtPlanDateEnd.Text = null;
            this.txtPlanHours.Text = null;          
            this.txtPlanCost.Text = null;

            this.txtOverrunDateEnd.Text = null;
            this.txtOverrunHours.Text = null;            
            this.txtOverrunCost.Text = null;

            this.txtActualDateStart.Text = null;
            this.txtActualDateEnd.Text = null;
            this.txtActualHours.Text = null;           
            this.txtActualCost.Text = null;

            this.txtOverrunDateEndProgress.Text = null;
            this.txtOverrunHoursProgress.Text = null;
            this.txtOverrunCostProgress.Text = null;

            this.txtActualDateStartProgress.Text = null;
            this.txtActualDateEndProgress.Text = null;
            this.txtActualHoursProgress.Text = null;
            this.txtActualCostProgress.Text = null;

            this.ucActualDateStartProgress.SelectedDate = null;
            this.ucActualDateEndProgress.SelectedDate = null;
            this.ucOverrunDateEndProgress.SelectedDate = null;
            
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
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
            
    /// <summary>
    /// Set Step Form to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetFormStep(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
               
                
                //Set Read Only
                this.txtTaskID.ReadOnly = true;
                this.txtTaskStatus.ReadOnly = true; 
                this.txtRefControlID.ReadOnly = true;
                this.txtStepNumber.ReadOnly = true;
                this.txtPriority.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.txtTaskDescription.ReadOnly = true;             
                this.txtStepDescription.ReadOnly = true;

                this.txtPlanDateStart.ReadOnly = true;
                this.txtPlanDateEnd.ReadOnly = true;
                this.txtPlanHours.ReadOnly = true;
                this.txtPlanCost.ReadOnly = true;

                this.txtOverrunDateEnd.ReadOnly = true;
                this.txtOverrunHours.ReadOnly = true;
                this.txtOverrunCost.ReadOnly = true;

                this.txtActualDateStart.ReadOnly = true;
                this.txtActualDateEnd.ReadOnly = true;
                this.txtActualHours.ReadOnly = true;
                this.txtActualCost.ReadOnly = true;                           

                //Hide Edit Controls    
                this.ddlPriority.Visible = false;
                this.ddlProject.Visible = false;

                //Hide View Controls
                this.txtActualDateStartProgress.Visible = false;
                this.txtActualDateEndProgress.Visible = false;
                this.txtOverrunDateEndProgress.Visible = false;
                                               
                //Show View Controls       
                this.txtPriority.Visible = true;
                this.txtProject.Visible = true;

                //Show Edit Controls
                this.ucActualDateStartProgress.Visible = true;
                this.ucActualDateEndProgress.Visible = true;
                this.ucOverrunDateEndProgress.Visible = true;

            }//end if - VIEW

            #region NOT_USED_NOW
            if (EditView ==FORM_ON.Edit)
            {
                
                              
                //Reset the Read Only
                this.txtTaskID.ReadOnly = false;
                this.txtTaskStatus.ReadOnly = false; 
                this.txtRefControlID.ReadOnly = false;
                this.txtStepNumber.ReadOnly = false;               
                this.txtTaskDescription.ReadOnly = false;
                this.txtStepDescription.ReadOnly = false;
                                                
                //Hide View Controls 
                this.txtPriority.Visible = false;
                this.txtProject.Visible = false;               

                //Show Edit Controls     
                this.ddlPriority.Visible = true;
                this.ddlProject.Visible = true;                                             
                
                //Initialize from View Controls 
                ListItem liSelectedItem = null;
                liSelectedItem = this.ddlPriority.Items.FindByText(this.txtPriority.Text.Trim());
                this.ddlPriority.SelectedIndex = this.ddlPriority.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlProject.Items.FindByText(this.txtProject.Text.Trim());
                this.ddlProject.SelectedIndex = this.ddlProject.Items.IndexOf(liSelectedItem);

            } //end if - EDIT  
            #endregion
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }    

}
                