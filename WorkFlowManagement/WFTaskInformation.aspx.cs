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
/// WF Task Class
/// </summary>
public partial class WFManagement_TaskInformation : System.Web.UI.Page
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
        String _HeaderRefType = null;
        String _HeaderRefID = null;
        String _HeaderWFTaskID = null;
        
        try
        {
            _SessionUser = this.Master.UserName;
            _SessionUserID = this.Master.EmpID; 
            _SID = this.Master.SID; 

            //Get References
            _HeaderRefType = Request.QueryString["RFTP"];
            _HeaderRefID = Request.QueryString["RFID"];
            _HeaderWFTaskID = Request.QueryString["TID"];

            SetLinkURLs(_HeaderRefType, _HeaderRefID);

            hlnkViewWorkflowTask.NavigateUrl = "../Legacy/secweb/ret_selitem.asp?SID=" + _SID + "&Listing=WF&Item=" + _HeaderWFTaskID;
            hlnkPrintableFormate.NavigateUrl = "../Legacy/secweb/pnt_selitem.asp?SID=" + _SID + "&Listing=WF&Item=" + _HeaderWFTaskID;
            hlnkPrintableWorkflowTaskForm.NavigateUrl = "../Legacy/secweb/pnt_chgreq.asp?SID=" + _SID + "&Listing=WF&Item=" + _HeaderWFTaskID;
            hlnkPrintableWaiver.NavigateUrl = "../Legacy/secweb/pnt_dev.asp?SID=" + _SID + "&Listing=WF&Item=" + _HeaderWFTaskID;

            if (!IsPostBack)
            {
                InitializeFormHeaderFields();
                InitializeFormStepFields();
                SetFormHeader(FORM_ON.View);
                SetFormStep(FORM_ON.View);

                //WF Template Header
                if (GetRecord(_HeaderRefType, _HeaderRefID) > 0)
                {
                    Int32 _WFTemplateID = 0;
                    if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
                    {
                        _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);

                        //WF Task
                        if (GetWFTasks(_HeaderRefType, _HeaderRefID) > 0)
                        {
                            Int32 _WFTaskID = 0;
                            if (!String.IsNullOrEmpty(_HeaderWFTaskID))
                            {
                                _WFTaskID = Convert.ToInt32(_HeaderWFTaskID);
                                GetRecordWFTask(_WFTaskID);
                            }
                        }
                    }
                                        
                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;                    
                    this.btnAddSaveTask.Visible = true;
                }
                else
                {
                    this.lblStatus.Text = "No Record Found. Please try again !"; 
                }
            }            
        }        
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage            
        }      
    }

    /// <summary>
    /// Set Go Back URL's
    /// </summary>
    /// <param name="RefType"></param>
    /// <param name="RefID"></param>
    private void SetLinkURLs(String RefType, String RefID)
    {
        switch (RefType)
        {
            case Constants.ChangeReferenceType:
                hlnkGoBack.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.DocReferenceType:
                hlnkGoBack.NavigateUrl = "~/DocumentManagement/DocInformation.aspx?SID=" + _SID + "&DOCID=" + RefID;
                break;
            case Constants.TaskReferenceType:
                hlnkGoBack.NavigateUrl = "~/TaskManagement/TaskInformation.aspx?SID=" + _SID + "&TID=" + RefID;
                break;
            case Constants.MaterialDispReferenceType:
                //hlnkGoBack.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.NonConformanceReferenceType:
                //hlnkGoBack.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.CorrectiveActionReferenceType:
                //hlnkGoBack.NavigateUrl = "~/ChangeManagement/ChangeOrders.aspx?SID=" + _SID + "&COID=" + RefID;
                break;
            case Constants.ProjectReferenceType:
                hlnkGoBack.NavigateUrl = "~/ProjectManagement/ProjectInformation.aspx?SID=" + _SID + "&PID=" + RefID;
                break;
        }

       
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
            String _HeaderRefType = this.hdnHeaderRefTypeCode.Value;
            String _HeaderRefID = this.txtHeaderRefID.Text;
            Int32 _WFTemplateID = 0;
            Int32 _WFTaskID = 0;



            //Cancel On Edited Existing Template before Save
            if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update")
            {
                if (GetRecord(_HeaderRefType, _HeaderRefID) > 0)
                {
                    if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
                    {
                        _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);

                        //WF Tasks
                        if (GetWFTasks(_HeaderRefType, _HeaderRefID) > 0)
                        {
                            if (!String.IsNullOrEmpty(this.hdnWFTaskID.Value))
                            {
                                _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);
                                GetRecordWFTask(_WFTaskID);
                            }
                        }
                    }

                    SetFormHeader(FORM_ON.View);
                    SetFormStep(FORM_ON.View);
                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;                    
                    this.btnAddSaveTask.Visible = true;
                }
            }
            
            //Cancel On Edited Existing Template before Adding New Step
            if (this.btnAddSaveTask.Text == "Save Task")
            {
                if (GetRecord(_HeaderRefType, _HeaderRefID) > 0)
                {
                    if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
                    {
                        _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);

                        //WF Tasks
                        if (GetWFTasks(_HeaderRefType, _HeaderRefID) > 0)
                        {
                            if (!String.IsNullOrEmpty(this.hdnWFTaskID.Value))
                            {
                                _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);
                                GetRecordWFTask(_WFTaskID);
                            }
                        }
                    }

                    SetFormHeader(FORM_ON.View);
                    SetFormStep(FORM_ON.View);
                    this.btnNewEditSave.Text = "Edit";
                    this.btnAddSaveTask.Text = "Add Task";
                    this.btnCancel.Visible = false;                    
                    this.btnAddSaveTask.Visible = true;
                    this.btnNewEditSave.Visible = true;

                    this.lblTID.Text = "Task ID:";
                    this.lblTaskStatus.Text = "Status:";                     
                }
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
    protected void btnNewEditSave_Click(object sender, EventArgs e)
    { 
        try
        {
            if (this.btnNewEditSave.Text == "New WorkFlow Task")
            {
               //None
            }
            else if (this.btnNewEditSave.Text == "Edit")
            {
                SetFormHeader(FORM_ON.Edit);
                SetFormStep(FORM_ON.Edit); 

                this.btnNewEditSave.Text = "Update";
                this.btnCancel.Visible = true;                
                this.btnAddSaveTask.Visible = false; 
            }
            else if (this.btnNewEditSave.Text =="Save" || this.btnNewEditSave.Text == "Update")
            {
                SaveWorkFlow(this.btnNewEditSave.Text);                
            }
        }        
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }
    
    /// <summary>
    /// Save WorkFlow
    /// </summary>
    /// <param name="Action"></param>
    private void SaveWorkFlow(String Action)
    {
        DateTime _CurrentDate = DateTime.Now;   

        //Template ID
        Int32 _WFTemplateID = 0;
        if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
        {
            _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);
        }
        if (_WFTemplateID == 0)
        {
            throw new Exception("A [Template ID] could not be located or created. The record will not be saved.");
        }

        //TemplateItemID
        Int32 _WFTemplateItemID = 0;
        if (!String.IsNullOrEmpty(this.hdnWFTemplateItemID.Value))
        {
            _WFTemplateItemID = Convert.ToInt32(this.hdnWFTemplateItemID.Value);
        }

        //Header Reference Control Code
        String _HeaderControlRefCode = this.hdnHeaderRefTypeCode.Value;
        if (String.IsNullOrEmpty(_HeaderControlRefCode))
        {
            throw new Exception("A [Reference Type] could not be located or created. The record will not be saved.");
        }

        //Header Reference ID
        String _HeaderControlRefID = this.txtHeaderRefID.Text;
        if (String.IsNullOrEmpty(_HeaderControlRefID))
        {
            throw new Exception("A [Reference ID] could not be located or created. The record will not be saved.");
        }

        Int32 _WFTaskID = 0;
        Int32 _TaskID = 0;
            
        String _TaskStatusCode = "HOLD";
        DateTime _AdjPlannedStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
        DateTime _AdjPlannedEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);

        DateTime _OverrunEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
        Single _OverrunHours = 0.0f;
        Decimal _OverrunCost = Convert.ToDecimal(0.0);
        DateTime _AdjOverrunEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);

        DateTime _ActualStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
        DateTime _ActualEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
        Single _ActualHours = 0.0f;
        Decimal _ActualCost = Convert.ToDecimal(0.0);
        DateTime _AdjActualStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
        DateTime _AdjActualEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);   
        
        Single _PercentComplete = 0.0f;

        if (Action == "Update")
        {
            //Task ID   
            if (!String.IsNullOrEmpty(this.txtTID.Text))
            {
                _TaskID = Convert.ToInt32(this.txtTID.Text);
            }
            
            //WF Task ID
            if (!String.IsNullOrEmpty(this.hdnWFTaskID.Value))
            {
                _WFTaskID = Convert.ToInt32(this.hdnWFTaskID.Value);
            }
            if (_WFTaskID == 0)
            {
                throw new Exception("A [Workflow Task ID] could not be located or created. The record will not be saved.");
            }

            if (this.ddlStatus.SelectedItem.Text != "-NONE-")
            {
                _TaskStatusCode = this.ddlStatus.SelectedItem.Value;
            }
                        
            if (!String.IsNullOrEmpty(this.ucAdjPlanDateStart.SelectedDate))
            {
                _AdjPlannedStartDate = Convert.ToDateTime(this.ucAdjPlanDateStart.SelectedDate);
            }
                     
            if (!String.IsNullOrEmpty(this.ucAdjPlanDateEnd.SelectedDate))
            {
                _AdjPlannedEndDate = Convert.ToDateTime(this.ucAdjPlanDateEnd.SelectedDate);
            }

            if (!String.IsNullOrEmpty(this.ucOverrunDateEnd.SelectedDate))
            {
                _OverrunEndDate = Convert.ToDateTime(this.ucOverrunDateEnd.SelectedDate);
            }
            
            if (!String.IsNullOrEmpty(this.txtOverrunHours.Text))
            {
                _OverrunHours = Convert.ToSingle(this.txtOverrunHours.Text);
            }
            
            if (!String.IsNullOrEmpty(this.txtOverrunCost.Text))
            {
                _OverrunCost = Convert.ToDecimal(this.txtOverrunCost.Text.Replace("$", ""));
            }
            
            if (!String.IsNullOrEmpty(this.ucAdjOverrunDateEnd.SelectedDate))
            {
                _AdjOverrunEndDate = Convert.ToDateTime(this.ucAdjOverrunDateEnd.SelectedDate);
            }

            if (!String.IsNullOrEmpty(this.ucActualDateStart.SelectedDate))
            {
                _ActualStartDate = Convert.ToDateTime(this.ucActualDateStart.SelectedDate);
            }

            if (!String.IsNullOrEmpty(this.ucActualDateEnd.SelectedDate))
            {
                _ActualEndDate = Convert.ToDateTime(this.ucActualDateEnd.SelectedDate);
            }

            if (!String.IsNullOrEmpty(this.txtActualHours.Text))
            {
                _ActualHours = Convert.ToSingle(this.txtActualHours.Text);
            }

            if (!String.IsNullOrEmpty(this.txtActualCost.Text))
            {
                _ActualCost = Convert.ToDecimal(this.txtActualCost.Text.Replace("$", ""));
            }

            if (!String.IsNullOrEmpty(this.ucAdjActualDateStart.SelectedDate))
            {
                _AdjActualStartDate = Convert.ToDateTime(this.ucAdjActualDateStart.SelectedDate);
            }

            if (!String.IsNullOrEmpty(this.ucAdjActualDateEnd.SelectedDate))
            {
                _AdjActualEndDate = Convert.ToDateTime(this.ucAdjActualDateEnd.SelectedDate);
            }
            
            if (!String.IsNullOrEmpty(this.txtPercent.Text))
            {
                _PercentComplete = Convert.ToSingle(this.txtPercent.Text);
            }            
        }

        //Priority
        String _Priority = null;
        if (this.ddlPriority.SelectedItem.Text != "-NONE-")
        {
            _Priority = this.ddlPriority.SelectedItem.Value;
        }

        //Project
        String _Project = null;
        if (this.ddlProject.SelectedItem.Text != "-NONE-")
        {
            _Project = this.ddlProject.SelectedItem.Value;
        }

        //Description
        String _TaskDescription = this.txtTaskDescription.Text;
        String _StepNumber = this.txtStepNumber.Text;
        if (String.IsNullOrEmpty(_StepNumber))  
        {
            throw new Exception("The [Step Number] could not be located or created. The record will not be saved.");           
        }
        
        //Action Type
        String _StepActionTypeCode = this.hdnActionTypeCode.Value;
        
        //Reference Control Code   
        String _RefControlCode = null;
        if (this.ddlRefControl.SelectedItem.Text != "-NONE-")
        {
            _RefControlCode = this.ddlRefControl.SelectedItem.Value;
        }
        else
        {
            //if (Utils.IsRequiredField("WFs", "ProjNum"))
            //{
            throw new Exception("A [Reference Control] could not be located or created. The record will not be saved.");
            //}
        }

        String _RefControlID = this.txtRefControlID.Text;  

        //Reference Parameters
        String _ReferenceParams = null;

        Int32 _AllowUpdateReference = 0;
        if (this.cbAllowAddCRef.Checked)
        {
            _AllowUpdateReference = 1;
        }

        Int32 _AllowAddReference = 0;
        if (this.cbAllowAddCRef.Checked)
        {
            _AllowAddReference = 1;
        }

        _ReferenceParams = _AllowUpdateReference.ToString() + _AllowAddReference.ToString();

        //Back Step Number  
        String _BackStepNumber = this.txtBackStep.Text;
       
        //Back Step Status
        String _BackStatusCode = this.ddlBackStatus.SelectedItem.Text;
        if( _BackStatusCode!= "-NONE-")
        {
            _BackStatusCode = this.ddlBackStatus.SelectedItem.Value;
        }
        else
        {
            //if (Utils.IsRequiredField("WFs", "ProjNum"))
            //{
            throw new Exception("A [Back Status] could not be located or created. The record will not be saved.");
            //}
        }

        //Next Step Number
        String _NextStepNumber = this.txtNextStep.Text;

        //Next Step Status                    
        String _NextStatusCode = this.ddlNextStatus.SelectedItem.Text;
        if (_NextStatusCode != "-NONE-")
        {
            _NextStatusCode = this.ddlNextStatus.SelectedItem.Value;
        }
        else
        {
            //if (Utils.IsRequiredField("WFs", "ProjNum"))
            //{
           throw new Exception("A [Next Status] could not be located or created. The record will not be saved.");
            //}
        }

        String _AssignByCode = this.hdnAssignerType.Value;
        Int32 _AssignByID = 0;
        if (this.ddlAssignedBy.SelectedItem.Text != "-NONE-")
        {
            _AssignByID = Convert.ToInt32(this.ddlAssignedBy.SelectedItem.Value);
        }
        else
        {
            //if (Utils.IsRequiredField("WFs", "ProjNum"))
            //{
            throw new Exception("The person [Assigned By] could not be located or created. The record will not be saved.");
            //}
        }

        String _AssignToCode = this.hdnAssigneeType.Value;
        Int32 _AssignToID = 0;
        if (this.ddlAssignedTo.SelectedItem.Text != "-NONE-")
        {
            _AssignToID = Convert.ToInt32(this.ddlAssignedTo.SelectedItem.Value);
        }
        else
        {
            //if (Utils.IsRequiredField("WFs", "ProjNum"))
            //{
            throw new Exception("The person [Assigned To] could not be located or created. The record will not be saved.");
            //}
        }

        String _StepDescription = this.txtStepDescription.Text;
        String _ChargeCode = this.txtChargeAccount.Text;
        String _StdTaskCode = this.hdnStdTaskCode.Value;

        DateTime _PlannedStartDate;
        if (!String.IsNullOrEmpty(this.ucPlanDateStart.SelectedDate))
        {
            _PlannedStartDate = Convert.ToDateTime(this.ucPlanDateStart.SelectedDate);
        }
        else
        {
            //if (Utils.IsRequiredField("Tasks", "PlannedStart"))
            //{
            //    throw new Exception("A [Planned Start Date] could not be located or created. The record will not be saved.");
            //}
            //else
            //{
            _PlannedStartDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            //}
        }

        DateTime _PlannedEndDate;
        if (!String.IsNullOrEmpty(this.ucPlanDateEnd.SelectedDate))
        {
            _PlannedEndDate = Convert.ToDateTime(this.ucPlanDateEnd.SelectedDate);
        }
        else
        {
            //if (Utils.IsRequiredField("Tasks", "PlannedFinish"))
            //{
            //    throw new Exception("A [Planned Finish Date] could not be located or created. The record will not be saved.");
            //}
            //else
            //{
            _PlannedEndDate = Convert.ToDateTime(Constants.DateTimeMinimum);
            //}
        }

        Single _PlannedHours = 0.0f;
        if (!String.IsNullOrEmpty(this.txtPlanHours.Text))
        {
            _PlannedHours = Convert.ToSingle(this.txtPlanHours.Text);
        }
        else
        {
            //if (Utils.IsRequiredField("Projects", "EstHours"))
            //{
            //    throw new Exception("The [Estimated Hours] could not be located or created. The record will not be saved.");
            //}
        }

        Decimal _PlannedCost = Convert.ToDecimal(0.0);
        if (!String.IsNullOrEmpty(this.txtPlanCost.Text))
        {
            _PlannedCost = Convert.ToDecimal(this.txtPlanCost.Text.Replace("$", ""));
        }
        else
        {
            //if (Utils.IsRequiredField("Projects", "EstCost"))
            //{
            //    throw new Exception("The [Estimated Cost] could not be located or created. The record will not be saved.");
            //}
        }

        String IsEmailRequired = "0";
        if (this.cbNotifyByEmail.Checked)
        {
            IsEmailRequired = "-1";
        }
        else
        {
            IsEmailRequired = "0";
        }

        DateTime _MinDate = Convert.ToDateTime(Constants.DateTimeMinimum);

        //Update
        if (Action == "Update")
        {

            //Update Tasks
            DataAccess.ModifyRecords(DataQueries.UpdateTasks(_ChargeCode, _TaskStatusCode, _TaskDescription, _Project,
                                                             _StdTaskCode, _HeaderControlRefCode, _HeaderControlRefID,
                                                             _Priority, _AssignByID, _AssignToID, _CurrentDate, _StepDescription,
                                                             _PlannedStartDate, _PlannedEndDate, _PlannedHours, _PlannedCost,
                                                             _OverrunEndDate, _OverrunHours, _OverrunCost, _ActualStartDate,
                                                             _ActualEndDate, _ActualHours, _ActualCost, _PercentComplete, _TaskID));

            //Update Workflow Tasks
            DataAccess.ModifyRecords(DataQueries.UpdateWFlowTasks(_WFTemplateID, _WFTemplateItemID, _HeaderControlRefCode,
                                                                  _HeaderControlRefID, _TaskID, _StepActionTypeCode,
                                                                  _StepNumber, _NextStepNumber, _NextStatusCode,
                                                                  _BackStepNumber, _BackStatusCode, _AssignByCode, _AssignByID,
                                                                  _AssignToCode, _AssignToID, _RefControlCode, _RefControlID,
                                                                  _ReferenceParams, _AdjPlannedStartDate, _AdjPlannedEndDate,
                                                                  _AdjOverrunEndDate, _AdjActualStartDate, _AdjActualEndDate,IsEmailRequired,
                                                                  _WFTaskID));

            //Update the Reference Item Status.
            if(_TaskStatusCode == "CLS")
            {
                Utils.UpdateReferenceItemStatus(_HeaderControlRefCode, _HeaderControlRefID,
                                                _NextStatusCode, _SessionUser, _CurrentDate);
            }            
        }

        //Save
        if (Action == "Save Task")
        {
            //Loop for Each Group Member if any
            using (DataTable _tempAssignTo = Utils.GetAssignTypeGroupMemberList(_AssignToCode, _AssignToID))
            {
                Int32 _rowMemberCount = _tempAssignTo.Rows.Count;
                String _AssignToWorkGroup = null;
                if (_rowMemberCount > 0)
                {
                    Int32 _MemberCount = 0;

                    Int32 _SubStep = 0;
                    if (_StepNumber.IndexOf(".") > 0)
                    {
                        _SubStep = Convert.ToInt32(_StepNumber.Substring(_StepNumber.IndexOf(".") + 1));   
                    }
                    else
                    {                        
                        _SubStep = 1;
                    }

                    for (Int32 k = 0; k < _rowMemberCount; k++)
                    {
                        Int32 _MemberID = 0;
                        _AssignToWorkGroup = null;

                        _StepNumber = Math.Floor(Convert.ToDecimal(_StepNumber)) + "." + _SubStep;

                        if (!String.IsNullOrEmpty(_tempAssignTo.Rows[k]["ID"].ToString()))
                        {
                            _MemberID = Convert.ToInt32(_tempAssignTo.Rows[k]["ID"].ToString());
                            using (DataTable _tempWGrp = DataAccess.GetRecords(DataQueries.GetAssigneeWkgrpByID(_MemberID)))
                            {
                                _MemberCount = _tempWGrp.Rows.Count;
                                if (_MemberCount > 0)
                                {
                                    _AssignToWorkGroup = _tempWGrp.Rows[0]["WorkGroup ID"].ToString();
                                }
                            }                            
                        }

                        DataAccess.ModifyRecords(DataQueries.InsertTasks(_ChargeCode, _TaskStatusCode, _TaskDescription, _Project,
                                                                         _StdTaskCode, null, _HeaderControlRefCode, _HeaderControlRefID,
                                                                         0, _Priority, _AssignByID, _AssignToID, _CurrentDate, _AssignToWorkGroup,
                                                                         _StepDescription, _PlannedStartDate, _PlannedEndDate, _PlannedHours,
                                                                         0.0f, _PlannedCost, _OverrunEndDate, _OverrunHours, _OverrunCost,
                                                                         _ActualStartDate, _ActualEndDate, _ActualHours, _ActualCost,
                                                                         _PercentComplete, "0"));
                        //Get Max TaskID
                        _TaskID = Utils.GetTasksNewID() - 1;

                        

                        DataAccess.ModifyRecords(DataQueries.InsertWFlowTasks(_WFTemplateID, _WFTemplateItemID, _HeaderControlRefCode,
                                                                      _HeaderControlRefID, _TaskID, "-1", "-1",
                                                                      "ACTIVE", _CurrentDate, _SessionUserID, _StepActionTypeCode,
                                                                      _StepNumber, _NextStepNumber, _NextStatusCode,
                                                                      _BackStepNumber, _BackStatusCode,
                                                                      _AssignByCode, _AssignByID, _AssignToCode, _AssignToID,
                                                                      _MemberID, _RefControlCode, _RefControlID,
                                                                      _ReferenceParams, "-1", _MinDate, _MinDate,
                                                                      _MinDate, _MinDate, _MinDate, IsEmailRequired));
                        _SubStep += 1;
                    }
                }
                else
                {
                    DataAccess.ModifyRecords(DataQueries.InsertTasks(_ChargeCode, _TaskStatusCode, _TaskDescription, _Project,
                                                                       _StdTaskCode, null, _HeaderControlRefCode, _HeaderControlRefID,
                                                                       0, _Priority, _AssignByID, _AssignToID, _CurrentDate, _AssignToWorkGroup,
                                                                       _StepDescription, _PlannedStartDate, _PlannedEndDate, _PlannedHours,
                                                                       0.0f, _PlannedCost, _OverrunEndDate, _OverrunHours, _OverrunCost,
                                                                       _ActualStartDate, _ActualEndDate, _ActualHours, _ActualCost,
                                                                       _PercentComplete, "0"));

                    //Get Max TaskID
                    _TaskID = Utils.GetTasksNewID() - 1;
                    
                    DataAccess.ModifyRecords(DataQueries.InsertWFlowTasks(_WFTemplateID, _WFTemplateItemID, _HeaderControlRefCode,
                                                                     _HeaderControlRefID, _TaskID, "-1", "-1",
                                                                     "ACTIVE", _CurrentDate, _SessionUserID, _StepActionTypeCode,
                                                                     _StepNumber, _NextStepNumber, _NextStatusCode,
                                                                     _BackStepNumber, _BackStatusCode,
                                                                     _AssignByCode, _AssignByID, _AssignToCode, _AssignToID,
                                                                     0, _RefControlCode, _RefControlID,
                                                                     _ReferenceParams, "-1", _MinDate, _MinDate,
                                                                     _MinDate, _MinDate, _MinDate, IsEmailRequired));
                }

            } // -- AssignTo Data Table


            //Get the ID               
            using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetWFlowTasksMaxID(_WFTemplateID)))
            {
                _WFTaskID = Convert.ToInt32(_tempNewID.Rows[0]["MaxID"].ToString());
            }
        }
        
        SetFormHeader(FORM_ON.View);
        SetFormStep(FORM_ON.View);

        //WF Template Header
        if (GetRecord(_HeaderControlRefCode, _HeaderControlRefID) > 0)
        {
            //WF Task
            if (GetWFTasks(_HeaderControlRefCode, _HeaderControlRefID) > 0)
            {
                GetRecordWFTask(_WFTaskID);
            }
        }
        
        this.btnAddSaveTask.Text = "Add Task";
        this.btnNewEditSave.Text = "Edit";
        this.btnCancel.Visible = false;
        this.btnNewEditSave.Visible = true;
        this.btnAddSaveTask.Visible = true;

        this.lblTID.Text = "Task ID:";
        this.lblTaskStatus.Text = "Status:";
        this.txtTID.Visible = true;
    }
    
    /// <summary>
    /// Add a New Step to the existing workflow
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAddSaveTask_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnAddSaveTask.Text == "Save Task")
            {
                SaveWorkFlow(this.btnAddSaveTask.Text);
            }
            else
            {
                InitializeFormStepFields();
                SetFormStep(FORM_ON.Edit);

                //Hide 
                this.txtTID.Visible = false;
                this.ddlStatus.Visible = false;

                this.ucAdjPlanDateStart.Visible = false;
                this.ucAdjPlanDateEnd.Visible = false;                 
                this.ucOverrunDateEnd.Visible = false;
                this.txtOverrunHours.Visible = false;
                this.txtOverrunCost.Visible = false;                
                this.ucAdjOverrunDateEnd.Visible = false;
                this.ucActualDateStart.Visible = false;
                this.ucActualDateEnd.Visible = false;
                this.txtActualHours.Visible = false;
                this.txtActualCost.Visible = false;
                this.ucAdjActualDateStart.Visible = false;
                this.ucAdjActualDateEnd.Visible = false;

                this.txtPercent.Visible = false;
                this.lblPercent.Visible = false;

                //Intialize
                this.lblTID.Text = "Select Action:";
                this.lblTaskStatus.Text = "<sup>or</sup> Select Item:";

                Int32 _TemplateID = 0;
                if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
                {
                    _TemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value); 
                }

                this.ddlTemplateStep.AutoPostBack = true;
                using (DataTable _tempTemplateStep = new DataTable())
                {
                    _tempTemplateStep.Columns.Add("ID", Type.GetType("System.Int32"));
                    _tempTemplateStep.Columns.Add("Description", Type.GetType("System.String"));
                    _tempTemplateStep.Rows.Add(0, "-NONE-");
                    _tempTemplateStep.Merge(DataAccess.GetRecords(DataQueries.GetViewWFTItemsListByTemplateID(_TemplateID)), true);
                    this.ddlTemplateStep.DataSource = _tempTemplateStep;
                    this.ddlTemplateStep.DataTextField = "Description";
                    this.ddlTemplateStep.DataValueField = "ID";
                    this.ddlTemplateStep.DataBind();
                }

                //Show
                this.ddlAction.Visible = true;
                this.ddlTemplateStep.Visible = true;

                this.btnAddSaveTask.Text = "Save Task";
                this.btnCancel.Visible = true;
                
                this.btnNewEditSave.Visible = false;
                this.lblWFTasks.Text = null;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }  
    }
            
    /// <summary>
    /// On Reference Control Selection pull BackStatus and NextStatus List
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlRefControl_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            SetBackNextStatus();
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }  
    }

    /// <summary>
    /// Set Dropdown list for Next & Back Status
    /// </summary>
    private void SetBackNextStatus()
    {
        try
        {
            String _ControlRefCode = null;
            if (this.ddlRefControl.SelectedItem.Text != "-NONE-")
            {
                _ControlRefCode = this.ddlRefControl.SelectedItem.Value;
                this.hdnControlReferenceCode.Value = _ControlRefCode;

                if (!String.IsNullOrEmpty(_ControlRefCode))
                {
                    this.ddlBackStatus.DataSource = Utils.GetControlRefStatusList(_ControlRefCode);
                    this.ddlBackStatus.DataTextField = "Description";
                    this.ddlBackStatus.DataValueField = "Code";
                    this.ddlBackStatus.DataBind();

                    this.ddlNextStatus.DataSource = Utils.GetControlRefStatusList(_ControlRefCode);
                    this.ddlNextStatus.DataTextField = "Description";
                    this.ddlNextStatus.DataValueField = "Code";
                    this.ddlNextStatus.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }  
    }

    /// <summary>
    /// On Select of Action 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlAction_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Int32 _WFActionID = 0;
            if (this.ddlAction.SelectedItem.Text != "-NONE-")
            {
                _WFActionID = Convert.ToInt32(this.ddlAction.SelectedItem.Value);
                GetRecordAction(_WFActionID);
            }

            this.ddlTemplateStep.SelectedIndex = 0; 
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }  
    }

    /// <summary>
    /// Get Action Details
    /// </summary>
    /// <param name="ActionID"></param>
    /// <returns></returns>
    private Int32 GetRecordAction(Int32 ActionID)
    {
        Int32 _rowCount = 0;
        ListItem liSelectedItem = null;

        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFActions(ActionID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {                    
                    this.txtActionType.Text = _tempViewWFs.Rows[0]["WFAction Type Name"].ToString();
                    this.hdnActionTypeCode.Value = _tempViewWFs.Rows[0]["WFAction Type Code"].ToString();
                    this.txtStepDescription.Text = _tempViewWFs.Rows[0]["Description"].ToString();
                                        
                    //Assign By
                    this.txtAssignerType.Text = _tempViewWFs.Rows[0]["Assign By Type"].ToString();
                    String _AssignByCode = _tempViewWFs.Rows[0]["Assign By Code"].ToString();
                    this.hdnAssignerType.Value = _AssignByCode;

                    String _AssignBy = _tempViewWFs.Rows[0]["Assign By ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignBy))
                    {
                        Int32 _AssignByID = Convert.ToInt32(_AssignBy);
                        this.txtAssignedBy.Text = Utils.GetAssignTypeName(_AssignByCode, _AssignByID);
                    }

                    String _AssignByType = this.hdnAssignerType.Value;
                    if (!String.IsNullOrEmpty(_AssignByType))
                    {
                        this.ddlAssignedBy.DataSource = Utils.GetAssignTypeList(_AssignByType);
                        this.ddlAssignedBy.DataTextField = "Description";
                        this.ddlAssignedBy.DataValueField = "ID";
                        this.ddlAssignedBy.DataBind();
                    }

                    liSelectedItem = this.ddlAssignedBy.Items.FindByText(this.txtAssignedBy.Text.Trim());
                    this.ddlAssignedBy.SelectedIndex = this.ddlAssignedBy.Items.IndexOf(liSelectedItem);

                    //Assign To
                    this.txtAssigneeType.Text = _tempViewWFs.Rows[0]["Assign To Type"].ToString();
                    String _AssignToCode = _tempViewWFs.Rows[0]["Assign To Code"].ToString();
                    this.hdnAssigneeType.Value = _AssignToCode;

                    String _AssignTo = _tempViewWFs.Rows[0]["Assign To ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignTo))
                    {
                        Int32 _AssignToID = Convert.ToInt32(_AssignTo);
                        this.txtAssignedTo.Text = Utils.GetAssignTypeName(_AssignToCode, _AssignToID);
                    }

                    String _AssignToType = this.hdnAssigneeType.Value;
                    if (!String.IsNullOrEmpty(_AssignToType))
                    {
                        this.ddlAssignedTo.DataSource = Utils.GetAssignTypeList(_AssignToType);
                        this.ddlAssignedTo.DataTextField = "Description";
                        this.ddlAssignedTo.DataValueField = "ID";
                        this.ddlAssignedTo.DataBind();
                    }

                    liSelectedItem = this.ddlAssignedTo.Items.FindByText(this.txtAssignedTo.Text.Trim());
                    this.ddlAssignedTo.SelectedIndex = this.ddlAssignedTo.Items.IndexOf(liSelectedItem);

                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["IseMailRequired"].ToString()))
                    {
                        this.cbNotifyByEmail.Checked = Convert.ToBoolean(_tempViewWFs.Rows[0]["IseMailRequired"].ToString());
                    }

                    //Ref Control
                    this.txtRefControl.Text = _tempViewWFs.Rows[0]["Control Reference Description"].ToString();
                    String _ControlRefCode = _tempViewWFs.Rows[0]["Control Reference Code"].ToString();                    
                    this.hdnControlReferenceCode.Value = _ControlRefCode;

                    liSelectedItem = this.ddlRefControl.Items.FindByText(this.txtRefControl.Text.Trim());
                    this.ddlRefControl.SelectedIndex = this.ddlRefControl.Items.IndexOf(liSelectedItem);

                    SetBackNextStatus();

                    String _Parameters = _tempViewWFs.Rows[0]["WA Parameter"].ToString();
                    if ((_Parameters != "00") && !String.IsNullOrEmpty(_Parameters))
                    {
                        Char[] ParamFlag = _Parameters.ToCharArray();
                        if (Convert.ToInt16(ParamFlag[0].ToString()) == 1)
                        {
                            this.cbUpdateCRef.Checked = true;
                        }

                        if (Convert.ToInt16(ParamFlag[1].ToString()) == 1)
                        {
                            this.cbAllowAddCRef.Checked = true;
                        }
                    }
                    else 
                    {
                        this.cbUpdateCRef.Checked = false;
                        this.cbAllowAddCRef.Checked = false;
                    }

                    this.txtChargeAccount.Text = _tempViewWFs.Rows[0]["Charge Account"].ToString();
                    this.txtStandardTask.Text = _tempViewWFs.Rows[0]["Task Description"].ToString();
                    this.hdnStdTaskCode.Value = _tempViewWFs.Rows[0]["Standard Task Code"].ToString();
                                     
                    this.txtPlanHours.Text = _tempViewWFs.Rows[0]["Hours"].ToString();                    
                    String _PlanCost = _tempViewWFs.Rows[0]["Cost"].ToString();
                    if (!String.IsNullOrEmpty(_PlanCost))
                    {
                        this.txtPlanCost.Text = Convert.ToDecimal(_PlanCost).ToString("c");
                    }

                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["IseMailRequired"].ToString()))
                    {
                        this.cbNotifyByEmail.Checked = Convert.ToBoolean(_tempViewWFs.Rows[0]["IseMailRequired"].ToString());
                    }
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
    /// On Select of Template Item
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>   
    protected void ddlTemplateStep_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Int32 _WFStepID = 0;
            if (this.ddlTemplateStep.SelectedItem.Text != "-NONE-")
            {
                _WFStepID = Convert.ToInt32(this.ddlTemplateStep.SelectedItem.Value);
                GetRecordWFItem(_WFStepID);
            }

            this.ddlAction.SelectedIndex = 0;
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }  
    }
    
    /// <summary>
    /// Get Record Template Item
    /// </summary>
    /// <param name="WFStepID"></param>
    /// <returns></returns>
    private Int32 GetRecordWFItem(Int32 WFStepID)
    {
        Int32 _rowCount = 0;
        ListItem liSelectedItem = null;

        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFTItemsByItemID(WFStepID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.hdnWFTemplateItemID.Value = WFStepID.ToString(); 
                    this.txtActionType.Text = _tempViewWFs.Rows[0]["WFAction Type Name"].ToString();
                    this.hdnActionTypeCode.Value = _tempViewWFs.Rows[0]["WFAction Type Code"].ToString();
                    this.txtStepNumber.Text = _tempViewWFs.Rows[0]["Step"].ToString();

                    this.txtBackStep.Text = _tempViewWFs.Rows[0]["Back Step"].ToString();
                    this.txtNextStep.Text = _tempViewWFs.Rows[0]["Next Step"].ToString();
                    this.txtStepDescription.Text = _tempViewWFs.Rows[0]["Description"].ToString();
                    
                    //Assign By
                    this.txtAssignerType.Text = _tempViewWFs.Rows[0]["Assign By Type"].ToString();
                    String _AssignByCode = _tempViewWFs.Rows[0]["Assign By Code"].ToString();
                    this.hdnAssignerType.Value = _AssignByCode;

                    String _AssignBy = _tempViewWFs.Rows[0]["Assign By ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignBy))
                    {
                        Int32 _AssignByID = Convert.ToInt32(_AssignBy);
                        this.txtAssignedBy.Text = Utils.GetAssignTypeName(_AssignByCode, _AssignByID);
                    }

                    String _AssignByType = this.hdnAssignerType.Value;
                    if (!String.IsNullOrEmpty(_AssignByType))
                    {
                        this.ddlAssignedBy.DataSource = Utils.GetAssignTypeList(_AssignByType);
                        this.ddlAssignedBy.DataTextField = "Description";
                        this.ddlAssignedBy.DataValueField = "ID";
                        this.ddlAssignedBy.DataBind();
                    }

                    liSelectedItem = this.ddlAssignedBy.Items.FindByText(this.txtAssignedBy.Text.Trim());
                    this.ddlAssignedBy.SelectedIndex = this.ddlAssignedBy.Items.IndexOf(liSelectedItem);

                    //Assign To
                    this.txtAssigneeType.Text = _tempViewWFs.Rows[0]["Assign To Type"].ToString();
                    String _AssignToCode = _tempViewWFs.Rows[0]["Assign To Code"].ToString();
                    this.hdnAssigneeType.Value = _AssignToCode;

                    String _AssignTo = _tempViewWFs.Rows[0]["Assign To ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignTo))
                    {
                        Int32 _AssignToID = Convert.ToInt32(_AssignTo);
                        this.txtAssignedTo.Text = Utils.GetAssignTypeName(_AssignToCode, _AssignToID);
                    }
                    
                    String _AssignToType = this.hdnAssigneeType.Value;
                    if (!String.IsNullOrEmpty(_AssignToType))
                    {
                        this.ddlAssignedTo.DataSource = Utils.GetAssignTypeList(_AssignToType);
                        this.ddlAssignedTo.DataTextField = "Description";
                        this.ddlAssignedTo.DataValueField = "ID";
                        this.ddlAssignedTo.DataBind();
                    }

                    liSelectedItem = this.ddlAssignedTo.Items.FindByText(this.txtAssignedTo.Text.Trim());
                    this.ddlAssignedTo.SelectedIndex = this.ddlAssignedTo.Items.IndexOf(liSelectedItem);

                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["IseMailRequired"].ToString()))
                    {
                        this.cbNotifyByEmail.Checked = Convert.ToBoolean(_tempViewWFs.Rows[0]["IseMailRequired"].ToString());
                    }

                    //Ref Control
                    this.txtRefControl.Text = _tempViewWFs.Rows[0]["Control Reference Description"].ToString();

                    String _ControlRefCode = _tempViewWFs.Rows[0]["Control Reference Code"].ToString();
                    this.hdnControlReferenceCode.Value = _ControlRefCode;
                    
                    liSelectedItem = this.ddlRefControl.Items.FindByText(this.txtRefControl.Text.Trim());
                    this.ddlRefControl.SelectedIndex = this.ddlRefControl.Items.IndexOf(liSelectedItem);

                    SetBackNextStatus();

                    String _NextStatusCode = _tempViewWFs.Rows[0]["Next Step Status"].ToString();
                    String _BackStatusCode = _tempViewWFs.Rows[0]["Back Step Status"].ToString();

                    this.txtNextStatus.Text = Utils.GetControlRefDescription(_ControlRefCode, _NextStatusCode, null);
                    this.txtBackStatus.Text = Utils.GetControlRefDescription(_ControlRefCode, _BackStatusCode, null);

                    liSelectedItem = this.ddlBackStatus.Items.FindByText(this.txtBackStatus.Text.Trim());
                    this.ddlBackStatus.SelectedIndex = this.ddlBackStatus.Items.IndexOf(liSelectedItem);

                    liSelectedItem = this.ddlNextStatus.Items.FindByText(this.txtNextStatus.Text.Trim());
                    this.ddlNextStatus.SelectedIndex = this.ddlNextStatus.Items.IndexOf(liSelectedItem);

                    String _Parameters = _tempViewWFs.Rows[0]["WA Parameter"].ToString();
                    if ((_Parameters != "00") && !String.IsNullOrEmpty(_Parameters))
                    {
                        Char[] ParamFlag = _Parameters.ToCharArray();
                        if (Convert.ToInt16(ParamFlag[0].ToString()) == 1)
                        {
                            this.cbUpdateCRef.Checked = true;
                        }

                        if (Convert.ToInt16(ParamFlag[1].ToString()) == 1)
                        {
                            this.cbAllowAddCRef.Checked = true;
                        }
                    }
                    else
                    {
                        this.cbAllowAddCRef.Checked = false;
                        this.cbUpdateCRef.Checked = false;
                    }

                    this.txtChargeAccount.Text = _tempViewWFs.Rows[0]["Charge Account"].ToString();
                    this.txtStandardTask.Text = _tempViewWFs.Rows[0]["Task Description"].ToString();
                    this.hdnStdTaskCode.Value = _tempViewWFs.Rows[0]["Standard Task Code"].ToString();
                                      
                    this.txtPlanHours.Text = _tempViewWFs.Rows[0]["Hours"].ToString();

                    String _PlanCost = _tempViewWFs.Rows[0]["Cost"].ToString();
                    if (!String.IsNullOrEmpty(_PlanCost))
                    {
                        this.txtPlanCost.Text = Convert.ToDecimal(_PlanCost).ToString("c");
                    }
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
    /// Get Record Values
    /// </summary>
    /// <param name="WFTemplateID"></param>
    /// <returns></returns>
    private Int32 GetRecord(String RefType, String RefID)
    {
        Int32 _rowCount = 0;
              
        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFInfo(RefType,RefID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtTemplateName.Text = _tempViewWFs.Rows[0]["Template Name"].ToString();
                    this.txtTemplateType.Text = _tempViewWFs.Rows[0]["Template Type"].ToString();
                    this.txtHeaderRefType.Text = _tempViewWFs.Rows[0]["Reference Type"].ToString();
                    this.txtHeaderRefID.Text = _tempViewWFs.Rows[0]["Reference Number"].ToString();
                    this.txtCreatedOn.Text = _tempViewWFs.Rows[0]["Created On"].ToString(); 
                    
                    Int32 _TemplateID = 0;
                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["Template ID"].ToString()))
                    {
                        _TemplateID = Convert.ToInt32(_tempViewWFs.Rows[0]["Template ID"].ToString());
                    }
                    this.hdnWFTemplateID.Value = _tempViewWFs.Rows[0]["Template ID"].ToString();                    
                    this.txtStepCount.Text = Utils.GetWFTemplateStepCount(_TemplateID).ToString();
                    this.txtTaskCount.Text = Utils.GetWFTaskCount(_TemplateID).ToString();
                    this.hdnHeaderRefTypeCode.Value = RefType;                    
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
                    this.txtTID.Text = _tempViewWFs.Rows[0]["Task ID"].ToString();
                    this.hdnWFTaskID.Value = WFTaskID.ToString();
                    this.txtStatus.Text = _tempViewWFs.Rows[0]["Task Status Description"].ToString();

                    this.txtPriority.Text = _tempViewWFs.Rows[0]["Priority Description"].ToString();
                    this.txtProject.Text = _tempViewWFs.Rows[0]["Project Description"].ToString();
                    this.txtTaskDescription.Text = _tempViewWFs.Rows[0]["Task Description"].ToString();
                    
                    this.txtActionType.Text = _tempViewWFs.Rows[0]["WF Task Type Description"].ToString();
                    this.hdnActionTypeCode.Value = _tempViewWFs.Rows[0]["WF Task Type Code"].ToString();
                                        
                    this.txtRefControlID.Text = _tempViewWFs.Rows[0]["WFTask Control Ref ID"].ToString();
                    String _ControlRefCode = _tempViewWFs.Rows[0]["WFTask Control Ref Type"].ToString();
                    this.hdnControlReferenceCode.Value = _ControlRefCode;
                    this.txtRefControl.Text = Utils.GetControlRefDescription(_ControlRefCode,_ControlRefCode,"TaskRefType");
                    
                    String _Parameters = _tempViewWFs.Rows[0]["WFTask Parameters"].ToString();
                    if ((_Parameters != "00") && !String.IsNullOrEmpty(_Parameters))
                    {
                        Char[] ParamFlag = _Parameters.ToCharArray();
                        if (Convert.ToInt16(ParamFlag[0].ToString()) == 1)
                        {
                            this.cbUpdateCRef.Checked = true;
                        }

                        if (Convert.ToInt16(ParamFlag[1].ToString()) == 1)
                        {
                            this.cbAllowAddCRef.Checked = true;
                        }
                    }
                    
                    this.txtStepNumber.Text = _tempViewWFs.Rows[0]["Step ID"].ToString();                    
                    this.txtBackStep.Text = _tempViewWFs.Rows[0]["Back Step ID"].ToString();
                    this.txtNextStep.Text = _tempViewWFs.Rows[0]["Next Step ID"].ToString();
                    this.txtStepDescription.Text = _tempViewWFs.Rows[0]["Task Assignment Description"].ToString();  
                    
                    String _NextStatusCode = _tempViewWFs.Rows[0]["Next Step Status"].ToString();
                    String _BackStatusCode = _tempViewWFs.Rows[0]["Back Step Status"].ToString();

                    this.txtNextStatus.Text = Utils.GetControlRefDescription(_ControlRefCode, _NextStatusCode,null);
                    this.txtBackStatus.Text = Utils.GetControlRefDescription(_ControlRefCode, _BackStatusCode,null);

                    Int32 _GrpMemberID = 0;
                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["Group Member ID"].ToString()))
                    {
                        _GrpMemberID = Convert.ToInt32(_tempViewWFs.Rows[0]["Group Member ID"].ToString());
                    }

                    this.txtAssignerType.Text = _tempViewWFs.Rows[0]["WFTask Assign By Type Description"].ToString();
                    String _AssignByCode = _tempViewWFs.Rows[0]["WFTask Assign By Type Code"].ToString();
                    this.hdnAssignerType.Value = _AssignByCode;
                  
                    String _AssignBy = _tempViewWFs.Rows[0]["WFTask Assgn By Type ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignBy))
                    {
                        Int32 _AssignByID = Convert.ToInt32(_AssignBy);
                        this.txtAssignedBy.Text = Utils.GetAssignTypeMemberName(_AssignByCode, _AssignByID, _GrpMemberID);
                        this.hdnAssignedByID.Value = _AssignByID.ToString();
                    }
                                                           
                    this.txtAssigneeType.Text = _tempViewWFs.Rows[0]["WFTask Assign To Type Description"].ToString();
                    String _AssignToCode = _tempViewWFs.Rows[0]["WFTask Assign To Type Code"].ToString();
                    this.hdnAssigneeType.Value = _AssignToCode;

                    String _AssignTo = _tempViewWFs.Rows[0]["WFTask Assgn To Type ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignTo))
                    {
                        Int32 _AssignToID = Convert.ToInt32(_AssignTo);
                        this.txtAssignedTo.Text = Utils.GetAssignTypeMemberName(_AssignToCode, _AssignToID, _GrpMemberID);
                        this.hdnAssignedToID.Value = _AssignToID.ToString(); 
                    }
                    
                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["IseMailRequired"].ToString()))
                    {
                        this.cbNotifyByEmail.Checked = Convert.ToBoolean(_tempViewWFs.Rows[0]["IseMailRequired"].ToString());
                    }

                    this.txtChargeAccount.Text =   _tempViewWFs.Rows[0]["Charge Account"].ToString();
                    this.txtStandardTask.Text = _tempViewWFs.Rows[0]["Standard Task Description"].ToString();
                    this.hdnStdTaskCode.Value = _tempViewWFs.Rows[0]["Standard Task ID"].ToString();

                    Boolean IsTaskSchduled = false;
                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["IsWFTaskScheduled"].ToString()))
                    {
                        IsTaskSchduled = Convert.ToBoolean(_tempViewWFs.Rows[0]["IsWFTaskScheduled"].ToString());
                    }

                    String _PlannedStartDate = _tempViewWFs.Rows[0]["Planned Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlannedStartDate) && _PlannedStartDate != Constants.DateTimeMinimum.ToString())
                    {
                        this.txtPlanDateStart.Text = Convert.ToDateTime(_PlannedStartDate).ToShortDateString();
                    }

                    String _PlannedEndDate = _tempViewWFs.Rows[0]["Planned End Date"].ToString();
                    if (!String.IsNullOrEmpty(_PlannedEndDate) && _PlannedEndDate != Constants.DateTimeMinimum.ToString())
                    {
                        this.txtPlanDateEnd.Text = Convert.ToDateTime(_PlannedEndDate).ToShortDateString();
                    }

                    this.txtPlanHours.Text = _tempViewWFs.Rows[0]["Planned Hours"].ToString();                    
                    String _PlanCost = _tempViewWFs.Rows[0]["Planned Cost"].ToString();
                    if (!String.IsNullOrEmpty(_PlanCost))
                    {
                        this.txtPlanCost.Text = Convert.ToDecimal(_PlanCost).ToString("c");                        
                    }

                    if (IsTaskSchduled)
                    {
                        String _WFTaskPlannedStartDate = _tempViewWFs.Rows[0]["WFTask Planned Start Date"].ToString();
                        if (!String.IsNullOrEmpty(_WFTaskPlannedStartDate) && _WFTaskPlannedStartDate != Constants.DateTimeMinimum.ToString())
                        {
                            this.txtAdjActualDateStart.Text = Convert.ToDateTime(_WFTaskPlannedStartDate).ToShortDateString();
                        }

                        String _WFTaskPlannedEndDate = _tempViewWFs.Rows[0]["WFTask Planned End Date"].ToString();
                        if (!String.IsNullOrEmpty(_WFTaskPlannedEndDate) && _WFTaskPlannedEndDate != Constants.DateTimeMinimum.ToString())
                        {
                            this.txtAdjActualDateEnd.Text = Convert.ToDateTime(_WFTaskPlannedEndDate).ToShortDateString();
                        }                     
                    }

                    String _OverrunEndDate = _tempViewWFs.Rows[0]["Overrun End Date"].ToString();
                    if (!String.IsNullOrEmpty(_OverrunEndDate) && _OverrunEndDate != Constants.DateTimeMinimum.ToString())
                    {
                        this.txtOverrunDateEnd.Text = Convert.ToDateTime(_OverrunEndDate).ToShortDateString();
                    }                                        

                    this.txtOverrunHours.Text = _tempViewWFs.Rows[0]["Overrun Hours"].ToString();
                    String _OverrunCost = _tempViewWFs.Rows[0]["Overrun Cost"].ToString();
                    if (!String.IsNullOrEmpty(_OverrunCost))
                    {
                        this.txtOverrunCost.Text = Convert.ToDecimal(_OverrunCost).ToString("c");
                    }

                    if (IsTaskSchduled)
                    {
                        String _WFTaskOverrunEndDate = _tempViewWFs.Rows[0]["WFTask Overrun End Date"].ToString();
                        if (!String.IsNullOrEmpty(_WFTaskOverrunEndDate) && _WFTaskOverrunEndDate != Constants.DateTimeMinimum.ToString())
                        {
                            this.txtAdjOverrunDateEnd.Text = Convert.ToDateTime(_WFTaskOverrunEndDate).ToShortDateString();
                        }
                    }

                    String _ActualStartDate = _tempViewWFs.Rows[0]["Actual Start Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualStartDate) && _ActualStartDate != Constants.DateTimeMinimum.ToString())
                    {
                        this.txtActualDateStart.Text = Convert.ToDateTime(_ActualStartDate).ToShortDateString();
                    }

                    String _ActualEndDate = _tempViewWFs.Rows[0]["Actual End Date"].ToString();
                    if (!String.IsNullOrEmpty(_ActualEndDate) && _ActualEndDate != Constants.DateTimeMinimum.ToString())
                    {
                        this.txtActualDateEnd.Text = Convert.ToDateTime(_ActualEndDate).ToShortDateString();
                    }  
                   
                    this.txtActualHours.Text = _tempViewWFs.Rows[0]["Actual Hours"].ToString();


                    String _ActualCost = _tempViewWFs.Rows[0]["Actual Cost"].ToString();
                    if (!String.IsNullOrEmpty(_ActualCost))
                    {
                        this.txtActualCost.Text = Convert.ToDecimal(_ActualCost).ToString("c");
                    }

                    if (IsTaskSchduled)
                    {
                        String _WFTaskActualStartDate = _tempViewWFs.Rows[0]["WFTask Actual Start Date"].ToString();
                        if (!String.IsNullOrEmpty(_WFTaskActualStartDate) && _WFTaskActualStartDate != Constants.DateTimeMinimum.ToString())
                        {
                            this.txtAdjActualDateStart.Text = Convert.ToDateTime(_WFTaskActualStartDate).ToShortDateString();
                        }

                        String _WFTaskActualEndDate = _tempViewWFs.Rows[0]["WFTask Actual End Date"].ToString();
                        if (!String.IsNullOrEmpty(_WFTaskActualEndDate) && _WFTaskActualEndDate != Constants.DateTimeMinimum.ToString())
                        {
                            this.txtAdjActualDateEnd.Text = Convert.ToDateTime(_WFTaskActualEndDate).ToShortDateString();
                        }
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
    /// Get Header Control Referenec Tasks
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
            
            this.gvWFTasks.AutoGenerateDeleteButton = true;
            this.gvWFTasks.AutoGenerateSelectButton = true;
            this.gvWFTasks.EnableViewState = false;
            this.gvWFTasks.Controls.Clear();

            using (DataTable _tempWFTasks = DataAccess.GetRecords(DataQueries.GetViewWFTasks(HeaderReferenceID, HeaderReferenceType)))
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
    /// Header Control Referenec Tasks - Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        String _HeaderRefType = this.hdnHeaderRefTypeCode.Value;
        String _HeaderRefID = this.txtHeaderRefID.Text;
        Int32 _TaskID = 0;

        GetWFTasks(_HeaderRefType, _HeaderRefID);

        if (gvWFTasks.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            _TaskID = Convert.ToInt32(gvWFTasks.Rows[e.RowIndex].Cells[5].Text);

            DataAccess.ModifyRecords(DataQueries.DeleteTasksByID(_TaskID));
            DataAccess.ModifyRecords(DataQueries.DeleteWFlowTasksByID(_TaskID));

            GetRecord(_HeaderRefType, _HeaderRefID);
            GetWFTasks(_HeaderRefType, _HeaderRefID);
            if (gvWFTasks.Rows.Count > 0)
            {
                Int32 _WFTaskID = Convert.ToInt32(gvWFTasks.Rows[0].Cells[1].Text);
                GetRecordWFTask(_WFTaskID);
            }
            else 
            {
                InitializeFormStepFields(); 
            }

            lblStatus.Text = "Success ! Task " + _TaskID + " was deleted.";
        }
    }

    /// <summary>
    /// Header Control Referenec Tasks - Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        String _HeaderRefType = this.hdnHeaderRefTypeCode.Value;
        String _HeaderRefID = this.txtHeaderRefID.Text;
        Int32 _WFTemplateID = 0;

        GetWFTasks(_HeaderRefType, _HeaderRefID);

        Int32 _WFTaskID = 0;
        String _WFlowTaskID = gvWFTasks.Rows[e.NewSelectedIndex].Cells[1].Text;
                
        if (GetRecord(_HeaderRefType, _HeaderRefID) > 0)
        {
            if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
            {
                _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);

                //WF Tasks
                if (GetWFTasks(_HeaderRefType, _HeaderRefID) > 0)
                {
                    if (!String.IsNullOrEmpty(_WFlowTaskID))
                    {
                        _WFTaskID = Convert.ToInt32(_WFlowTaskID);
                        GetRecordWFTask(_WFTaskID);
                    }
                }
            }

            SetFormHeader(FORM_ON.View);
            SetFormStep(FORM_ON.View);
            this.btnNewEditSave.Text = "Edit";
            this.btnCancel.Visible = false;
            this.btnAddSaveTask.Visible = true;
        }

        GetWFTasks(_HeaderRefType, _HeaderRefID);
    }

    /// <summary>
    /// Header Control Referenec Tasks - Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _colSelectIndex = 0;
        Int32 _colTemplateTaskIndex = 1;
        Int32 _colTemplateIndex = 2;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colTemplateTaskIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colTemplateTaskIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvWFTasks = (DataRowView)e.Row.DataItem;
            Int32 _colTaskIDIndex = drvWFTasks.DataView.Table.Columns["Task ID"].Ordinal + 1;
            Int32 _colTaskDescIndex = drvWFTasks.DataView.Table.Columns["Task Description"].Ordinal + 1;
            Int32 _colTaskStatusIndex = drvWFTasks.DataView.Table.Columns["Task Status"].Ordinal + 1;
            Int32 _colStepIndex = drvWFTasks.DataView.Table.Columns["Step"].Ordinal + 1;
            Int32 _colStepStausIndex = drvWFTasks.DataView.Table.Columns["Step Status"].Ordinal + 1;
            Int32 _colStartDateIndex = drvWFTasks.DataView.Table.Columns["Start Date"].Ordinal + 1;
            Int32 _colEndDateIndex = drvWFTasks.DataView.Table.Columns["End Date"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Format
            String _SDate = e.Row.Cells[_colStartDateIndex].Text;
            if (!String.IsNullOrEmpty(_SDate))
            {
                e.Row.Cells[_colStartDateIndex].Text = Convert.ToDateTime(_SDate).ToShortDateString();
            }

            String _EDate = e.Row.Cells[_colEndDateIndex].Text;
            if (!String.IsNullOrEmpty(_EDate))
            {
                e.Row.Cells[_colEndDateIndex].Text = Convert.ToDateTime(_EDate).ToShortDateString();
            }

            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colTaskIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colTaskDescIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colTaskStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStepStausIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStartDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colEndDateIndex].HorizontalAlign = HorizontalAlign.Center;
        }
    }
        
    /// <summary>
    /// Initialize Header Form
    /// </summary>
    private void InitializeFormHeaderFields()
    {
        this.txtTemplateName.Text = null;
        this.txtTemplateType.Text = null;
        
        this.txtHeaderRefType.Text = null;
        this.txtHeaderRefID.Text = null;
        this.txtStepCount.Text = null;
        this.txtTaskCount.Text = null; 
        this.txtCreatedOn.Text = null;
    }
    
    /// <summary>
    /// Initialize Step Form
    /// </summary>
    private void InitializeFormStepFields()
    {
        try
        {
            this.lblStatus.Text = null;

            this.lblTID.Text = "Task ID:";
            this.lblTaskStatus.Text = "Status:";
            this.lblPercent.Text = "% Complete"; 

            this.txtTID.Text = null;
            this.txtStatus.Text = null;            
            this.txtPriority.Text = null;
            this.txtProject.Text = null;
            this.txtTaskDescription.Text = null;
            this.txtTaskDescription.TextMode = TextBoxMode.MultiLine;
            this.txtTaskDescription.Height = 50;

            this.txtStepNumber.Text = null;            
            this.txtActionType.Text = null;
            this.txtRefControl.Text = null;
            this.txtRefControlID.Text = null;
            this.cbAllowAddCRef.Checked = false;
            this.cbAllowAddCRef.Text = "Allow Edit of Ref";
            this.cbUpdateCRef.Checked = false;
            this.cbUpdateCRef.Text = "Update Ref. Status";

            this.txtBackStep.Text = null;
            this.txtBackStatus.Text = null;
            this.txtNextStep.Text = null;
            this.txtNextStatus.Text = null;
            this.txtStepDescription.Text = null;
            this.txtStepDescription.TextMode = TextBoxMode.MultiLine;
            this.txtStepDescription.Height = 50;

            this.txtAssignerType.Text = null;
            this.txtAssignedBy.Text = null;
            this.txtAssigneeType.Text = null;
            this.txtAssignedTo.Text = null;
            this.cbNotifyByEmail.Checked = false;
            this.cbNotifyByEmail.Text = "Notify by Email"; 
            this.txtChargeAccount.Text = null;
            this.txtStandardTask.Text = null;

            this.txtPercent.Text = null;
            //this.txtPercent.Width = Unit.Percentage(10.00);

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

            this.ucPlanDateStart.SelectedDate = null;
            this.ucPlanDateEnd.SelectedDate = null;
            this.ucOverrunDateEnd.SelectedDate = null;
            this.ucActualDateStart.SelectedDate = null;
            this.ucActualDateEnd.SelectedDate = null; 
             
            this.ddlRefControl.AutoPostBack = true;
            using (DataTable _tempRefControl = new DataTable())
            {
                _tempRefControl.Columns.Add("Code", Type.GetType("System.String"));
                _tempRefControl.Columns.Add("Description", Type.GetType("System.String"));
                _tempRefControl.Rows.Add("-NONE-", "-NONE-");
                _tempRefControl.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("TaskRefType")), true);
                this.ddlRefControl.DataSource = _tempRefControl;
                this.ddlRefControl.DataTextField = "Description";
                this.ddlRefControl.DataValueField = "Code";
                this.ddlRefControl.DataBind();
            }

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

            this.ddlAction.AutoPostBack = true;
            using (DataTable _tempAction = new DataTable())
            {
                _tempAction.Columns.Add("ID", Type.GetType("System.Int32"));
                _tempAction.Columns.Add("Description", Type.GetType("System.String"));
                _tempAction.Rows.Add(0, "-NONE-");
                _tempAction.Merge(DataAccess.GetRecords(DataQueries.GetViewWFActions()), true);
                this.ddlAction.DataSource = _tempAction;
                this.ddlAction.DataTextField = "Description";
                this.ddlAction.DataValueField = "ID";
                this.ddlAction.DataBind();
            }            
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
            this.gvWFTasks.EnableViewState = false;
            this.gvWFTasks.Controls.Clear();
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);  
        } 
    }

    /// <summary>
    /// Set Header Form to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetFormHeader(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {
               
                
                //Set Read Only        
                this.txtTemplateName.ReadOnly = true;
                this.txtTemplateType.ReadOnly = true;
                
                this.txtHeaderRefType.ReadOnly = true;
                this.txtHeaderRefID.ReadOnly = true;
                this.txtStepCount.ReadOnly = true;
                this.txtTaskCount.ReadOnly = true;
                this.txtCreatedOn.ReadOnly = true;

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                
            } //end if - EDIT  
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
                this.txtTID.ReadOnly = true;
                this.txtStatus.ReadOnly = true;
                this.txtPriority.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.txtTaskDescription.ReadOnly = true;

                this.txtActionType.ReadOnly =true;
                this.txtStepNumber.ReadOnly = true;
                this.txtRefControl.ReadOnly = true;
                this.txtRefControlID.ReadOnly = true;
                this.cbAllowAddCRef.Enabled = false;
                this.cbUpdateCRef.Enabled = false;
                this.txtBackStep.ReadOnly = true;                
                this.txtBackStatus.ReadOnly =true;
                this.txtNextStep.ReadOnly = true;                 
                this.txtNextStatus.ReadOnly =true;
                this.txtStepDescription.ReadOnly = true;

                this.txtAssignerType.ReadOnly = true;
                this.txtAssignedBy.ReadOnly = true;
                this.txtAssigneeType.ReadOnly = true;
                this.txtAssignedTo.ReadOnly = true;
                this.txtChargeAccount.ReadOnly = true;
                this.txtStandardTask.ReadOnly = true;
                this.cbNotifyByEmail.Enabled = false; 

                this.txtPercent.ReadOnly = true;

                this.txtPlanDateStart.ReadOnly = true;
                this.txtPlanDateEnd.ReadOnly = true;
                this.txtPlanHours.ReadOnly = true;
                this.txtPlanCost.ReadOnly = true;

                this.txtAdjPlanDateStart.ReadOnly = true;
                this.txtAdjPlanDateEnd.ReadOnly = true;

                this.txtOverrunDateEnd.ReadOnly = true;
                this.txtOverrunHours.ReadOnly = true;
                this.txtOverrunCost.ReadOnly = true;
                
                this.txtAdjOverrunDateEnd.ReadOnly = true;

                this.txtActualDateStart.ReadOnly = true;
                this.txtActualDateEnd.ReadOnly = true;
                this.txtActualHours.ReadOnly = true;
                this.txtActualCost.ReadOnly = true;

                this.txtAdjActualDateStart.ReadOnly = true;
                this.txtAdjActualDateEnd.ReadOnly = true;

                //Hide Edit Controls    
                this.ddlAction.Visible = false;
                this.ddlTemplateStep.Visible = false;
                this.ddlStatus.Visible = false;
                this.ddlPriority.Visible = false;
                this.ddlProject.Visible = false;
                                
                this.ddlBackStatus.Visible =false;
                this.ddlNextStatus.Visible =false;
                this.ddlAssignedBy.Visible = false;
                this.ddlAssignedTo.Visible = false;
                this.ddlRefControl.Visible = false;

                this.ucPlanDateStart.Visible = false;
                this.ucPlanDateEnd.Visible = false;
                this.ucOverrunDateEnd.Visible = false;
                this.ucActualDateStart.Visible = false;
                this.ucActualDateEnd.Visible = false;

                this.ucAdjPlanDateStart.Visible = false;
                this.ucAdjPlanDateEnd.Visible = false;
                this.ucAdjOverrunDateEnd.Visible = false;
                this.ucAdjActualDateStart.Visible = false;
                this.ucAdjActualDateEnd.Visible = false;
                
                //Show View Controls   
                this.txtTID.Visible = true;
                this.txtStatus.Visible = true;
                this.txtPriority.Visible = true;
                this.txtProject.Visible = true;

                this.txtBackStatus.Visible = true;
                this.txtNextStatus.Visible = true;
                this.txtAssignedBy.Visible = true;
                this.txtAssignedTo.Visible = true;
                this.txtRefControl.Visible = true;
             
                this.txtPlanDateStart.Visible = true;
                this.txtPlanDateEnd.Visible = true;
                this.txtOverrunDateEnd.Visible = true;
                this.txtActualDateStart.Visible = true;
                this.txtActualDateEnd.Visible = true;

                this.txtAdjPlanDateStart.Visible = true;
                this.txtAdjPlanDateEnd.Visible = true;
                this.txtAdjOverrunDateEnd.Visible = true;
                this.txtAdjActualDateStart.Visible = true;
                this.txtAdjActualDateEnd.Visible = true;

                this.txtPlanHours.Visible = true;
                this.txtPlanCost.Visible = true;
                this.txtOverrunHours.Visible = true;
                this.txtOverrunCost.Visible = true;
                this.txtActualHours.Visible = true;
                this.txtActualCost.Visible = true;
                
                this.txtPercent.Visible = true;
                this.lblPercent.Visible = true;

            }//end if - VIEW

            if (EditView ==FORM_ON.Edit)
            {
              

                //// CHECK Configuration whether Editing allowed for actuals 
                //String _AllowEditing = null;
                //Boolean _IsEditAllowed = false;

                //_AllowEditing = Utils.GetSystemConfigurationReturnValue("ERMSProg", "ETAEDITACTUALS");
                //if (!String.IsNullOrEmpty(_AllowEditing))
                //{
                //    _IsEditAllowed = Convert.ToBoolean(_AllowEditing);
                //}

                //if (_IsEditAllowed)
                //{
                //    
              
                //}
                                
                //Reset the Read Only
                this.txtTID.ReadOnly = true;
                this.txtTaskDescription.ReadOnly = false;

                this.txtStepNumber.ReadOnly = false;
                this.txtBackStep.ReadOnly = false;
                this.txtNextStep.ReadOnly = false;
                this.txtStepDescription.ReadOnly = false;

                this.txtRefControlID.ReadOnly = false;
                this.cbAllowAddCRef.Enabled = true;
                this.cbUpdateCRef.Enabled = true;                
                this.txtChargeAccount.ReadOnly = false;
                
                this.txtPercent.ReadOnly = false;
                this.txtPlanHours.ReadOnly = false;
                this.txtPlanCost.ReadOnly = false;
                this.txtOverrunHours.ReadOnly = false;
                this.txtOverrunCost.ReadOnly = false;

                //if (_IsEditAllowed)
                //{
                this.txtActualHours.ReadOnly = false;
                this.txtActualCost.ReadOnly = false;
                //}
                                                
                //Hide View Controls 
                this.txtStatus.Visible = false;
                this.txtPriority.Visible = false;
                this.txtProject.Visible = false;

                this.txtBackStatus.Visible = false;
                this.txtNextStatus.Visible = false;
                this.txtAssignedBy.Visible = false;                
                this.txtAssignedTo.Visible = false;              
                this.txtRefControl.Visible = false;
                this.cbNotifyByEmail.Enabled = true; 

                this.txtPlanDateStart.Visible = false;
                this.txtPlanDateEnd.Visible = false;
                this.txtOverrunDateEnd.Visible = false;
                this.txtActualDateStart.Visible = false;
                this.txtActualDateEnd.Visible = false;

                this.txtAdjPlanDateStart.Visible = false;
                this.txtAdjPlanDateEnd.Visible = false;
                this.txtAdjOverrunDateEnd.Visible = false;
                this.txtAdjActualDateStart.Visible = false;
                this.txtAdjActualDateEnd.Visible = false; 

                //Show Edit Controls     
                this.txtTID.Visible = true;
                this.ddlStatus.Visible = true;
                this.ddlAction.Visible = false;
                this.ddlTemplateStep.Visible = false;
                this.ddlPriority.Visible = true;
                this.ddlProject.Visible = true;
                                             
                this.ddlBackStatus.Visible = true;
                this.ddlNextStatus.Visible = true;
                this.ddlAssignedBy.Visible = true;
                this.ddlAssignedTo.Visible = true;
                this.ddlRefControl.Visible = true;                

                this.ucPlanDateStart.Visible = true;
                this.ucPlanDateEnd.Visible = true;
                this.ucOverrunDateEnd.Visible = true;
                this.ucActualDateStart.Visible = true;
                this.ucActualDateEnd.Visible = true;

                this.ucAdjPlanDateStart.Visible = true;
                this.ucAdjPlanDateEnd.Visible = true;
                this.ucAdjOverrunDateEnd.Visible = true;
                this.ucAdjActualDateStart.Visible = true;
                this.ucAdjActualDateEnd.Visible = true;

                this.txtPlanHours.Visible = true;
                this.txtPlanCost.Visible = true;
                this.txtOverrunHours.Visible = true;
                this.txtOverrunCost.Visible = true;
                this.txtActualHours.Visible = true;
                this.txtActualCost.Visible = true;

                this.txtPercent.Visible = true;
                this.lblPercent.Visible = true;
               
                //Initialize from View Controls    
                this.ucPlanDateStart.SelectedDate = this.txtPlanDateStart.Text;
                this.ucPlanDateEnd.SelectedDate = this.txtPlanDateEnd.Text;
                this.ucOverrunDateEnd.SelectedDate = this.txtOverrunDateEnd.Text;
                this.ucActualDateStart.SelectedDate = this.txtActualDateStart.Text;
                this.ucActualDateEnd.SelectedDate = this.txtActualDateEnd.Text;

                this.ucAdjPlanDateStart.SelectedDate = this.txtAdjPlanDateStart.Text;
                this.ucAdjPlanDateEnd.SelectedDate = this.txtAdjPlanDateEnd.Text;
                this.ucAdjOverrunDateEnd.SelectedDate = this.txtAdjOverrunDateEnd.Text;
                this.ucAdjActualDateStart.SelectedDate = this.txtAdjActualDateStart.Text;
                this.ucAdjActualDateEnd.SelectedDate = this.txtAdjActualDateEnd.Text; 

                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlStatus.Items.FindByText(this.txtStatus.Text.Trim());
                this.ddlStatus.SelectedIndex = this.ddlStatus.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlPriority.Items.FindByText(this.txtPriority.Text.Trim());
                this.ddlPriority.SelectedIndex = this.ddlPriority.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlProject.Items.FindByText(this.txtProject.Text.Trim());
                this.ddlProject.SelectedIndex = this.ddlProject.Items.IndexOf(liSelectedItem);

                liSelectedItem = this.ddlRefControl.Items.FindByText(this.txtRefControl.Text.Trim());
                this.ddlRefControl.SelectedIndex = this.ddlRefControl.Items.IndexOf(liSelectedItem);
                
                String _RefType = this.hdnControlReferenceCode.Value;
                if (!String.IsNullOrEmpty(_RefType))
                {
                    this.ddlBackStatus.DataSource = Utils.GetControlRefStatusList(_RefType);
                    this.ddlBackStatus.DataTextField = "Description";
                    this.ddlBackStatus.DataValueField = "Code";
                    this.ddlBackStatus.DataBind();

                    this.ddlNextStatus.DataSource = Utils.GetControlRefStatusList(_RefType);
                    this.ddlNextStatus.DataTextField = "Description";
                    this.ddlNextStatus.DataValueField = "Code";
                    this.ddlNextStatus.DataBind();                    
                }
                
                liSelectedItem = this.ddlBackStatus.Items.FindByText(this.txtBackStatus.Text.Trim());
                this.ddlBackStatus.SelectedIndex = this.ddlBackStatus.Items.IndexOf(liSelectedItem);
                
                liSelectedItem = this.ddlNextStatus.Items.FindByText(this.txtNextStatus.Text.Trim());
                this.ddlNextStatus.SelectedIndex = this.ddlNextStatus.Items.IndexOf(liSelectedItem);

                String _AssignByType = this.hdnAssignerType.Value;
                if (!String.IsNullOrEmpty(_AssignByType))
                {
                    Int32 _AssignByID = Convert.ToInt32(this.hdnAssignedByID.Value);  
                    this.ddlAssignedBy.DataSource = Utils.GetAssignTypeMemberList(_AssignByType, _AssignByID);
                    this.ddlAssignedBy.DataTextField = "Description";
                    this.ddlAssignedBy.DataValueField = "ID";
                    this.ddlAssignedBy.DataBind();                  
                }

                liSelectedItem = this.ddlAssignedBy.Items.FindByText(this.txtAssignedBy.Text.Trim());
                this.ddlAssignedBy.SelectedIndex = this.ddlAssignedBy.Items.IndexOf(liSelectedItem);

                String _AssignToType = this.hdnAssigneeType.Value;
                if (!String.IsNullOrEmpty(_AssignToType))
                {
                    Int32 _AssignToID = Convert.ToInt32(this.hdnAssignedToID.Value);
                    this.ddlAssignedTo.DataSource = Utils.GetAssignTypeMemberList(_AssignToType, _AssignToID);
                    this.ddlAssignedTo.DataTextField = "Description";
                    this.ddlAssignedTo.DataValueField = "ID";
                    this.ddlAssignedTo.DataBind();                    
                }

                liSelectedItem = this.ddlAssignedTo.Items.FindByText(this.txtAssignedTo.Text.Trim());
                this.ddlAssignedTo.SelectedIndex = this.ddlAssignedTo.Items.IndexOf(liSelectedItem);

            } //end if - EDIT  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }    

}
                