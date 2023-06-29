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
using System.Threading.Tasks;
using System.IO;

/// <summary>
/// WF Assignment Class
/// </summary>
public partial class WFManagement_WFAssignment : System.Web.UI.Page
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
        String _RefType = null;
        String _RefID = null;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            //Get Reference Control Type and ID
            _RefType = Request.QueryString["RFTP"];
            _RefID = Request.QueryString["RFID"];

            SetLinkURLs(_RefType, _RefID);

            hlnkViewAssignment.NavigateUrl = "../Legacy/secweb/ret_selitem.asp?SID=" + _SID + "&Listing=WF&Item=" + _RefID;
            hlnkPrintableFormate.NavigateUrl = "../Legacy/secweb/pnt_selitem.asp?SID=" + _SID + "&Listing=WF&Item=" + _RefID;
            hlnkPrintableAssignmentForm.NavigateUrl = "../Legacy/secweb/pnt_chgreq.asp?SID=" + _SID + "&Listing=WF&Item=" + _RefID;
            hlnkPrintableWaiver.NavigateUrl = "../Legacy/secweb/pnt_dev.asp?SID=" + _SID + "&Listing=WF&Item=" + _RefID;

            if (!IsPostBack)
            {
                InitializeFormHeaderFields();
                InitializeGrids();
                SetFormHeader(FORM_ON.View);

                if (_RefType != null && _RefID != null)
                {

                    if (Utils.GetControlRefRecordCount(_RefType, _RefID) > 0)
                    {
                        GetWFTasks(_RefType, _RefID);
                        this.btnFind.Text = "Find New Reference Item";

                        this.ddlTemplateName.Visible = true;

                        this.txtTemplateName.Visible = false;
                        this.ddlTemplateName.Focus();
                    }
                    else
                    {
                        this.ddlRefControlHeader.Visible = true;

                        this.txtRefControlHeader.Visible = false;
                        this.ddlRefControlHeader.Focus();

                        this.txtRefControlID.ReadOnly = false;


                        lblStatus.Text = "A Reference Item could not be located or created.";
                    }
                }
                else
                {
                    this.ddlRefControlHeader.Visible = true;

                    this.txtRefControlHeader.Visible = false;
                    this.ddlRefControlHeader.Focus();

                    this.txtRefControlID.ReadOnly = false;

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
            String _RefType = this.ddlRefControlHeader.SelectedItem.Value;
            String _RefID = this.txtRefControlID.Text;

            if (this.btnFind.Text == "Find")
            {
                if (_RefType != null && _RefID != null)
                {
                    if (Utils.GetControlRefRecordCount(_RefType, _RefID) > 0)
                    {
                        GetWFTasks(_RefType, _RefID);
                        SetFormHeader(FORM_ON.View);
                        this.btnFind.Text = "Find New Reference Item";

                        this.ddlTemplateName.Visible = true;

                        this.txtTemplateName.Visible = false;
                        this.ddlTemplateName.Focus();
                    }
                    else
                    {
                        InitializeFormHeaderFields();
                        InitializeGrids();
                        SetFormHeader(FORM_ON.View);

                        this.ddlRefControlHeader.Visible = true;

                        this.txtRefControlHeader.Visible = false;
                        this.ddlRefControlHeader.Focus();

                        this.txtRefControlID.ReadOnly = false;


                        lblStatus.Text = "A Reference Item could not be located or created.";
                    }
                }
            }
            else if (this.btnFind.Text == "Find New Reference Item")
            {
                InitializeFormHeaderFields();
                InitializeGrids();
                SetFormHeader(FORM_ON.View);

                this.ddlRefControlHeader.Visible = true;

                this.txtRefControlHeader.Visible = false;
                this.ddlRefControlHeader.Focus();

                this.txtRefControlID.ReadOnly = false;


                this.btnFind.Text = "Find";
                this.btnAssign.Visible = false;

                this.btnFind.PostBackUrl = "WFAssignment.aspx?SID=" + _SID;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Select a Template
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlTemplateName_SelectedIndexChanged(object sender, EventArgs e)
    {
        String _RefType = this.ddlRefControlHeader.SelectedItem.Value;
        String _RefID = this.txtRefControlID.Text;
        SetFormHeader(FORM_ON.Edit);

        Int32 _WFTemplateID = 0;
        if (this.ddlTemplateName.SelectedItem.Text != "-NONE-")
        {
            _WFTemplateID = Convert.ToInt32(this.ddlTemplateName.SelectedItem.Value);
        }

        //WF Template
        this.btnAssign.Visible = false;
        if (GetRecord(_WFTemplateID) > 0)
        {
            if (GetWFSteps(_WFTemplateID) > 0)
            {
                this.btnAssign.Visible = true;
            }
        }

        GetWFTasks(_RefType, _RefID);
    }

    /// <summary>
    /// New / Edit / Save
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAssign_Click(object sender, EventArgs e)
    {
        try
        {

            DateTime _CurrentDate = DateTime.Now;
            Int32 _SessionUserID = this.Master.EmpID;
            DateTime _MinDate = Convert.ToDateTime(Constants.DateTimeMinimum);

            String _TaskCostType = "W";
            String _RefStatus = "ACTIVE";

            String _RefID = this.txtRefControlID.Text;
            if (String.IsNullOrEmpty(_RefID))
            {
                throw new Exception("A [Reference ID] could not be located or created. The record will not be assigned.");
            }

            String _RefTypeCode = this.ddlRefControlHeader.SelectedItem.Value;
            if (String.IsNullOrEmpty(_RefTypeCode))
            {
                throw new Exception("A [Reference Type] could not be located or created. The record will not be assigned.");
            }

            Int32 _WFTemplateID = 0;
            if (this.ddlTemplateName.SelectedItem.Text != "-NONE-")
            {
                _WFTemplateID = Convert.ToInt32(this.ddlTemplateName.SelectedItem.Value);
            }

            if (_WFTemplateID == 0)
            {
                throw new Exception("A [Template] could not be located or created. The record will not be assigned.");
            }

            String _TaskStatus = "OPEN";
            String _IsWFActive = "-1";
            String _IsWFTaskActive = "-1";

            //using (DataTable _tempList = DataAccess.GetRecords(DataQueries.GetWFlowTasksIDByReference(_RefStatus,_RefTypeCode,_RefID)))
            //{
            //    Int32 _rowCount = _tempList.Rows.Count;
            //    if (_rowCount > 0)
            //    {
            //      _TaskStatus = "HOLD";  
            //      _IsWFTaskActive = "0";
            //    }
            //}               

            //Get Template Steps          
            using (DataTable _tempWFTemplate = DataAccess.GetRecords(DataQueries.GetViewWFTItemsByTemplateID(_WFTemplateID)))
            {
                Int32 _rowCount = _tempWFTemplate.Rows.Count;

                if (_rowCount > 0)
                {
                    //Loop Thru & Add each step as Task and Workflow Task 
                    DateTime _StepStartDate;
                    DateTime _StepCompleteDate = _MinDate;
                    for (Int32 i = 0; i < _rowCount; i++)
                    {
                        Int32 _WFTemplateItemID = 0;
                        if (!String.IsNullOrEmpty(_tempWFTemplate.Rows[i]["WFItem ID"].ToString()))
                        {
                            _WFTemplateItemID = Convert.ToInt32(_tempWFTemplate.Rows[i]["WFItem ID"].ToString());
                        }

                        //Get Step                         
                        using (DataTable _tempWFSteps = DataAccess.GetRecords(DataQueries.GetViewWFTItemsByItemID(_WFTemplateItemID)))
                        {
                            String _WFActionName = _tempWFSteps.Rows[0]["WFAction Name"].ToString();
                            String _WFActionTypeCode = _tempWFSteps.Rows[0]["WFAction Type Code"].ToString();
                            String _WFActionTypeName = _tempWFSteps.Rows[0]["WFAction Type Name"].ToString();
                            String _WFStepID = _tempWFSteps.Rows[0]["Step"].ToString();
                            String _WFNextStep = _tempWFSteps.Rows[0]["Next Step"].ToString();
                            String _WFNextStepStatus = _tempWFSteps.Rows[0]["Next Step Status"].ToString();
                            String _WFBackStep = _tempWFSteps.Rows[0]["Back Step"].ToString();
                            String _WFBackStepStatus = _tempWFSteps.Rows[0]["Back Step Status"].ToString();
                            String _WFStepDescription = _tempWFSteps.Rows[0]["Description"].ToString();
                            String _WFStandardTaskCode = _tempWFSteps.Rows[0]["Standard Task Code"].ToString();
                            String _TaskDescription = _tempWFSteps.Rows[0]["Task Description"].ToString();

                            //Priority
                            String _TaskPriority = "OPEN";
                            if (this.ddlPriority.SelectedItem.Text != "-NONE-")
                            {
                                _TaskPriority = this.ddlPriority.SelectedItem.Value;
                            }

                            //Project
                            String _TaskProjectCode = null;
                            if (this.ddlProject.SelectedItem.Text != "-NONE-")
                            {
                                _TaskProjectCode = this.ddlProject.SelectedItem.Value;
                            }

                            String _ChargeAccountCode = null;
                            if (String.IsNullOrEmpty(this.txtChargeAccount.Text))
                            {
                                _ChargeAccountCode = _tempWFSteps.Rows[0]["Charge Account"].ToString();
                            }
                            else
                            {
                                _ChargeAccountCode = this.txtChargeAccount.Text;
                            }

                            Single _Duration = 0.0f;
                            if (!String.IsNullOrEmpty(_tempWFSteps.Rows[0]["Duration"].ToString()))
                            {
                                _Duration = Convert.ToSingle(_tempWFSteps.Rows[0]["Duration"].ToString());
                            }

                            Single _Hours = 0.0f;
                            if (!String.IsNullOrEmpty(_tempWFSteps.Rows[0]["Hours"].ToString()))
                            {
                                _Hours = Convert.ToSingle(_tempWFSteps.Rows[0]["Hours"].ToString());
                            }

                            Int32 _Minutes = 0;
                            if (!String.IsNullOrEmpty(_tempWFSteps.Rows[0]["Minutes"].ToString()))
                            {
                                _Minutes = Convert.ToInt32(_tempWFSteps.Rows[0]["Minutes"].ToString());
                            }

                            Decimal _Cost = Convert.ToDecimal(0.0);
                            if (!String.IsNullOrEmpty(_tempWFSteps.Rows[0]["Cost"].ToString()))
                            {
                                _Cost = Convert.ToDecimal(_tempWFSteps.Rows[0]["Cost"].ToString());
                            }

                            String _ControlRefID = _RefID;
                            String _ControlRefCode = _RefTypeCode; //_tempWFSteps.Rows[0]["Control Reference Code"].ToString();
                            String _ControlRefDescription = this.txtRefControlHeader.Text; //_tempWFSteps.Rows[0]["Control Reference Description"].ToString();
                            String _Parameters = _tempWFSteps.Rows[0]["WA Parameter"].ToString();

                            String _AssignByCode = _tempWFSteps.Rows[0]["Assign By Code"].ToString();
                            String _AssignByType = _tempWFSteps.Rows[0]["Assign By Type"].ToString();

                            Int32 _AssignByID = 0;
                            if (!String.IsNullOrEmpty(_tempWFSteps.Rows[0]["Assign By ID"].ToString()))
                            {
                                _AssignByID = Convert.ToInt32(_tempWFSteps.Rows[0]["Assign By ID"].ToString());
                                _AssignByID = Utils.GetAssignTypeFirstMemberID(_AssignByCode, _AssignByID);
                            }

                            String _AssignToCode = _tempWFSteps.Rows[0]["Assign To Code"].ToString();
                            String _AssignToType = _tempWFSteps.Rows[0]["Assign To Type"].ToString();

                            Int32 _AssignToID = 0;
                            if (!String.IsNullOrEmpty(_tempWFSteps.Rows[0]["Assign To ID"].ToString()))
                            {
                                _AssignToID = Convert.ToInt32(_tempWFSteps.Rows[0]["Assign To ID"].ToString());
                            }

                            String IsEmailRequired = "0";
                            if (!String.IsNullOrEmpty(_tempWFSteps.Rows[0]["IseMailRequired"].ToString()))
                            {
                                if (Convert.ToBoolean(_tempWFSteps.Rows[0]["IseMailRequired"].ToString()))
                                {
                                    // Email functionality
                                    string emailLink = "http://ermsapp.com/WorkFlowManagement/WFTaskInformationReview.aspx?RFTP=" + _ControlRefCode + "&RFID=" + _ControlRefID + "&TID=" + _WFTemplateID;

                                    var tempPath = Server.MapPath("~/WorkflowEmailTemplate/WorkflowEmailTemplate.html");
                                    string emailText = File.ReadAllText(tempPath, Encoding.UTF8);

                                    emailText = emailText.Replace("{{WORKFLOWLINK}}", emailLink);

                                    string _emailTo = string.Empty;
                                    String _eMailFrom = "";
                                    String _eMailSubjectLine = "ERMS Workflow Action " + _ControlRefDescription;
                                    String _eMailBody = emailText;

                                    IsEmailRequired = "-1";
                                    using (DataTable _tempUser = DataAccess.GetRecords(DataQueries.GetUserXRefEmail(_AssignToID)))
                                    {
                                        _emailTo = _tempUser.Rows[0]["eMail"].ToString();
                                    }


                                    Utils.SendEmail(_eMailFrom, _emailTo, _eMailSubjectLine, _eMailBody);
                                }
                                else
                                {
                                    IsEmailRequired = "0";
                                }
                            }

                            _Hours = _Hours + _Minutes / 60;

                            if (Convert.ToInt32(_WFStepID) == 1)
                            {
                                _StepStartDate = _CurrentDate;
                            }
                            else
                            {
                                _StepStartDate = _StepCompleteDate;
                            }
                            _StepCompleteDate = _StepStartDate.AddDays(_Duration);

                            //Loop for Each Group Member if any
                            using (DataTable _tempAssignTo = Utils.GetAssignTypeGroupMemberList(_AssignToCode, _AssignToID))
                            {
                                Int32 _rowMemberCount = _tempAssignTo.Rows.Count;
                                String _AssignToWorkGroup = null;
                                if (_rowMemberCount > 0)
                                {
                                    Int32 _MemberCount = 0;
                                    for (Int32 k = 0; k < _rowMemberCount; k++)
                                    {
                                        Int32 _MemberID = 0;
                                        _AssignToWorkGroup = null;
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

                                        DataAccess.ModifyRecords(DataQueries.InsertTasks(_ChargeAccountCode, _TaskStatus, _WFActionName,
                                                                                         _TaskProjectCode, _WFStandardTaskCode, _TaskCostType,
                                                                                         _RefTypeCode, _RefID, 0, _TaskPriority, _AssignByID,
                                                                                         _AssignToID, _CurrentDate, _AssignToWorkGroup,
                                                                                         _WFStepDescription, _StepStartDate, _StepCompleteDate,
                                                                                         _Hours, _Duration, _Cost, _MinDate, 0.0f,
                                                                                         0, _MinDate, _MinDate, 0.0f, 0, 0.0f, "0"));

                                        //Get Max TaskID
                                        Int32 _TaskID = Utils.GetTasksNewID() - 1;

                                        DataAccess.ModifyRecords(DataQueries.InsertWFlowTasks(_WFTemplateID, _WFTemplateItemID, _RefTypeCode,
                                                                                              _RefID, _TaskID, _IsWFActive, _IsWFTaskActive,
                                                                                              _RefStatus, _CurrentDate, _SessionUserID, _WFActionTypeCode,
                                                                                              _WFStepID, _WFNextStep, _WFNextStepStatus, _WFBackStep,
                                                                                              _WFBackStepStatus, _AssignByCode, _AssignByID,
                                                                                              _AssignToCode, _AssignToID, _MemberID, _ControlRefCode,
                                                                                              _ControlRefID, _Parameters, "0", _MinDate, _MinDate,
                                                                                              _MinDate, _MinDate, _MinDate, IsEmailRequired));
                                    }
                                }
                                else
                                {

                                    DataAccess.ModifyRecords(DataQueries.InsertTasks(_ChargeAccountCode, _TaskStatus, _WFActionName,
                                                                                      _TaskProjectCode, _WFStandardTaskCode, _TaskCostType,
                                                                                      _RefTypeCode, _RefID, 0, _TaskPriority, _AssignByID,
                                                                                      _AssignToID, _CurrentDate, _AssignToWorkGroup,
                                                                                      _WFStepDescription, _StepStartDate, _StepCompleteDate,
                                                                                      _Hours, _Duration, _Cost, _MinDate, 0.0f,
                                                                                      0, _MinDate, _MinDate, 0.0f, 0, 0.0f, "0"));

                                    //Get Max TaskID
                                    Int32 _TaskID = Utils.GetTasksNewID() - 1;

                                    DataAccess.ModifyRecords(DataQueries.InsertWFlowTasks(_WFTemplateID, _WFTemplateItemID, _RefTypeCode,
                                                                                          _RefID, _TaskID, _IsWFActive, _IsWFTaskActive,
                                                                                          _RefStatus, _CurrentDate, _SessionUserID, _WFActionTypeCode,
                                                                                          _WFStepID, _WFNextStep, _WFNextStepStatus, _WFBackStep,
                                                                                          _WFBackStepStatus, _AssignByCode, _AssignByID,
                                                                                          _AssignToCode, _AssignToID, 0, _ControlRefCode,
                                                                                           _ControlRefID, _Parameters, "0", _MinDate, _MinDate,
                                                                                          _MinDate, _MinDate, _MinDate, IsEmailRequired));
                                }

                            } // -- AssignTo Data Table                          
                        }// -- Steps Data Table

                        _TaskStatus = "HOLD";

                    } // -- Template Step Record Loop 

                } // -- if steps found                
            } // -- Template Steps

            GetWFTasks(_RefTypeCode, _RefID);
            SetFormHeader(FORM_ON.View);
            this.btnFind.Text = "Find New Reference Item";
            this.btnAssign.Visible = false;

            this.txtTemplateType.Text = null;
            this.txtDescription.Text = null;

            this.ddlTemplateName.SelectedIndex = 0;
            this.ddlTemplateName.Visible = true;
            this.txtTemplateName.Visible = false;
            this.ddlTemplateName.Focus();

            lblStatus.Text = "Success ! Selected template steps are added as tasks.";
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Get Record Values
    /// </summary>
    /// <param name="WFTemplateID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 WFTemplateID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFTempByID(WFTemplateID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtTemplateName.Text = _tempViewWFs.Rows[0]["Name"].ToString();
                    this.txtTemplateType.Text = _tempViewWFs.Rows[0]["Type"].ToString();
                    this.txtDescription.Text = _tempViewWFs.Rows[0]["Description"].ToString();
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
    /// Get WorkFlow Steps
    /// </summary>
    /// <param name="WFTemplateID"></param>
    /// <returns></returns>
    private Int32 GetWFSteps(Int32 WFTemplateID)
    {
        Int32 _rowCount = 0;

        try
        {

            this.gvWFSteps.EnableViewState = false;
            this.gvWFSteps.Controls.Clear();

            using (DataTable _tempWFSteps = DataAccess.GetRecords(DataQueries.GetViewWFTItemsByTemplateID(WFTemplateID)))
            {
                _rowCount = _tempWFSteps.Rows.Count;

                if (_rowCount > 0)
                {
                    this.gvWFSteps.DataSource = _tempWFSteps;
                    this.gvWFSteps.DataBind();
                    this.lblWFSteps.Text = null;
                }
                else
                {
                    this.lblWFSteps.Text = "Please add steps to the selected workflow.";
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
    /// WorkFlow Steps Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFSteps_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colTemplateIDIndex = 0;
        Int32 _colTemplateIndex = 1;

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[_colTemplateIDIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[_colTemplateIDIndex].Visible = false;
            e.Row.Cells[_colTemplateIndex].Visible = false;

            //Get Column Indexes
            DataRowView drvADocs = (DataRowView)e.Row.DataItem;
            Int32 _colStepIndex = drvADocs.DataView.Table.Columns["Step"].Ordinal;
            Int32 _colActionIndex = drvADocs.DataView.Table.Columns["Action Name"].Ordinal;
            Int32 _colNStepIndex = drvADocs.DataView.Table.Columns["Next Step"].Ordinal;
            Int32 _colBStepIndex = drvADocs.DataView.Table.Columns["Back Step"].Ordinal;
            Int32 _colActionTypeIndex = drvADocs.DataView.Table.Columns["Action Type"].Ordinal;

            //Align
            e.Row.Cells[_colStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colActionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colNStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colBStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colActionTypeIndex].HorizontalAlign = HorizontalAlign.Left;
        }
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
            //Set Record
            ListItem liSelectedItem = null;
            liSelectedItem = this.ddlRefControlHeader.Items.FindByValue(HeaderReferenceType);
            this.ddlRefControlHeader.SelectedIndex = this.ddlRefControlHeader.Items.IndexOf(liSelectedItem);

            this.txtRefControlHeader.Text = this.ddlRefControlHeader.SelectedItem.Text;
            this.txtRefControlID.Text = HeaderReferenceID;

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
        String _RefID = this.txtRefControlID.Text;
        String _RefTypeCode = this.ddlRefControlHeader.SelectedItem.Value;

        GetWFTasks(_RefTypeCode, _RefID);

        if (gvWFTasks.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _TaskID = Convert.ToInt32(gvWFTasks.Rows[e.RowIndex].Cells[5].Text);

            DataAccess.ModifyRecords(DataQueries.DeleteTasksByID(_TaskID));
            DataAccess.ModifyRecords(DataQueries.DeleteWFlowTasksByID(_TaskID));

            lblStatus.Text = "Success ! Task " + _TaskID + " was deleted.";
        }

        GetWFTasks(_RefTypeCode, _RefID);
    }

    /// <summary>
    /// Header Control Referenec Tasks - Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFTasks_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        String _RefID = this.txtRefControlID.Text;
        String _RefTypeCode = this.ddlRefControlHeader.SelectedItem.Value;

        GetWFTasks(_RefTypeCode, _RefID);
        String _TaskID = gvWFTasks.Rows[e.NewSelectedIndex].Cells[1].Text;

        Server.Transfer("WFTaskInformation.aspx?SID=" + _SID + "&RFTP=" + _RefTypeCode
                                                + "&RFID=" + _RefID + "&TID=" + _TaskID);
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
            Int32 _colStepIndex = drvWFTasks.DataView.Table.Columns["Step"].Ordinal + 1;
            Int32 _colStepStausIndex = drvWFTasks.DataView.Table.Columns["Step Status"].Ordinal + 1;
            Int32 _colTaskIDIndex = drvWFTasks.DataView.Table.Columns["Task ID"].Ordinal + 1;
            Int32 _colTaskDescIndex = drvWFTasks.DataView.Table.Columns["Task Description"].Ordinal + 1;
            Int32 _colTaskStatusIndex = drvWFTasks.DataView.Table.Columns["Task Status"].Ordinal + 1;
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
            e.Row.Cells[_colStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStepStausIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colTaskIDIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colTaskDescIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colTaskStatusIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colStartDateIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colEndDateIndex].HorizontalAlign = HorizontalAlign.Center;
        }
    }

    /// <summary>
    /// Initialize Header Form
    /// </summary>
    private void InitializeFormHeaderFields()
    {
        this.lblWFSteps.Text = "Please select a template to view the tasks associated with it.";
        this.lblWFTasks.Text = "Please provide the reference details to view current tasks.";

        this.txtRefControlHeader.Text = null;
        this.txtRefControlID.Text = null;
        this.txtTemplateName.Text = null;
        this.txtTemplateType.Text = null;
        this.txtDescription.Text = null;
        this.txtDescription.TextMode = TextBoxMode.MultiLine;
        this.txtDescription.Height = 50;

        this.txtPriority.Text = null;
        this.txtProject.Text = null;
        this.txtChargeAccount.Text = null;

        this.ddlTemplateName.AutoPostBack = true;
        using (DataTable _tempTemplateName = new DataTable())
        {
            _tempTemplateName.Columns.Add("ID", Type.GetType("System.Int32"));
            _tempTemplateName.Columns.Add("Description", Type.GetType("System.String"));
            _tempTemplateName.Rows.Add(0, "-NONE-");
            _tempTemplateName.Merge(DataAccess.GetRecords(DataQueries.GetViewWFTemp()), true);
            this.ddlTemplateName.DataSource = _tempTemplateName;
            this.ddlTemplateName.DataTextField = "Description";
            this.ddlTemplateName.DataValueField = "ID";
            this.ddlTemplateName.DataBind();
        }

        using (DataTable _tempTemplateType = new DataTable())
        {
            _tempTemplateType.Columns.Add("Code", Type.GetType("System.String"));
            _tempTemplateType.Columns.Add("Description", Type.GetType("System.String"));
            _tempTemplateType.Rows.Add("-NONE-", "-NONE-");
            _tempTemplateType.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("WFTempType")), true);
            this.ddlTemplateType.DataSource = _tempTemplateType;
            this.ddlTemplateType.DataTextField = "Description";
            this.ddlTemplateType.DataValueField = "Code";
            this.ddlTemplateType.DataBind();
        }

        using (DataTable _tempRefControlHeader = new DataTable())
        {
            _tempRefControlHeader.Columns.Add("Code", Type.GetType("System.String"));
            _tempRefControlHeader.Columns.Add("Description", Type.GetType("System.String"));
            _tempRefControlHeader.Rows.Add("-NONE-", "-NONE-");
            _tempRefControlHeader.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("TaskRefType")), true);
            this.ddlRefControlHeader.DataSource = _tempRefControlHeader;
            this.ddlRefControlHeader.DataTextField = "Description";
            this.ddlRefControlHeader.DataValueField = "Code";
            this.ddlRefControlHeader.DataBind();
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
    }

    /// <summary>
    /// Initialize Grid Views
    /// </summary>
    private void InitializeGrids()
    {
        try
        {
            this.gvWFSteps.EnableViewState = false;
            this.gvWFSteps.Controls.Clear();

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
                this.txtRefControlHeader.ReadOnly = true;
                this.txtRefControlID.ReadOnly = true;
                this.txtTemplateName.ReadOnly = true;
                this.txtTemplateType.ReadOnly = true;
                this.txtDescription.ReadOnly = true;
                this.txtPriority.ReadOnly = true;
                this.txtProject.ReadOnly = true;
                this.txtChargeAccount.ReadOnly = true;

                //Hide Edit Controls 
                this.ddlRefControlHeader.Visible = false;
                this.ddlTemplateName.Visible = false;
                this.ddlTemplateType.Visible = false;
                this.ddlPriority.Visible = false;
                this.ddlProject.Visible = false;

                //Show View Controls
                this.txtRefControlHeader.Visible = true;
                this.txtTemplateName.Visible = true;
                this.txtTemplateType.Visible = true;
                this.txtPriority.Visible = true;
                this.txtProject.Visible = true;

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {



                //Set Read Only 
                this.txtChargeAccount.ReadOnly = false;

                //Hide View Controls                
                this.txtPriority.Visible = false;
                this.txtProject.Visible = false;

                //Show Edit Controls
                this.ddlPriority.Visible = true;
                this.ddlProject.Visible = true;

            } //end if - EDIT  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

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
            case Constants.ProjectReferenceType:
                hlnkGoBack.NavigateUrl = "~/ProjectManagement/ProjectInformation.aspx?SID=" + _SID + "&PID=" + RefID;
                break;
        }
    }
}
