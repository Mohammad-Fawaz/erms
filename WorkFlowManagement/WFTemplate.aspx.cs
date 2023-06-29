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
/// WF Order Class
/// </summary>
public partial class WFManagement_WFTemplate : System.Web.UI.Page
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
        Int32 WFTemplateID = 0;

        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID;

            //Get WF Template ID
            String QSWFTemplateID = Request.QueryString["WFID"];
            if (!String.IsNullOrEmpty(QSWFTemplateID))
            {
                WFTemplateID = Convert.ToInt32(QSWFTemplateID);
            }

            if (!IsPostBack)
            {
                InitializeFormHeaderFields();
                InitializeFormStepFields();
                SetFormHeader(FORM_ON.View);
                SetFormStep(FORM_ON.View);
                CheckFields();

                if (WFTemplateID > 0)
                {
                    //WF Template Header
                    if (GetRecord(WFTemplateID) > 0)
                    {
                        this.btnFind.AlternateText = "Find New WorkFlow";
                        this.btnNewEditSave.Text = "Edit";
                        this.btnCancel.Visible = false;
                        this.btnDelete.Visible = true;
                        this.btnAddSaveStep.Visible = true;

                        //WF Template Step
                        if (GetWFSteps(WFTemplateID) > 0)
                        {
                            Int32 _WFStepID = Convert.ToInt32(this.hdnWFStepID.Value);
                            GetRecordWFItem(_WFStepID);
                        }
                    }
                    else
                    {
                        this.ddlTemplateName.Visible = true;
                        this.txtTemplateName.Visible = false;
                        this.ddlTemplateName.Focus();
                    }
                }
                else
                {
                    this.ddlTemplateName.Visible = true;
                    this.txtTemplateName.Visible = false;
                    this.ddlTemplateName.Focus();
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

        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowFromTemplatesData(19, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {
                string txtDocIDs = row["ControlId"].ToString();
                if (txtDocIDs == "divTemplateName") { divTemplateName.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divTemplateType") { divTemplateType.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divDescription") { divDescription.Visible = true; } //else { divRevision.Visible = false; }
                if (txtDocIDs == "divAction") { divAction.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divActionType") { divActionType.Visible = true; }
                if (txtDocIDs == "divStepNumber") { divStepNumber.Visible = true; }
                if (txtDocIDs == "divRevision") { divRevision.Visible = true; }
                if (txtDocIDs == "divUpdateCRef") { divUpdateCRef.Visible = true; }
                if (txtDocIDs == "divAllowAddCRef") { divAllowAddCRef.Visible = true; }
                if (txtDocIDs == "divBackStep") { divBackStep.Visible = true; }
                if (txtDocIDs == "divBackStatus") { divBackStatus.Visible = true; }
                if (txtDocIDs == "divNextStep") { divNextStep.Visible = true; }
                if (txtDocIDs == "divNextStatus") { divNextStatus.Visible = true; }
                if (txtDocIDs == "divStepDescription") { divStepDescription.Visible = true; }
                if (txtDocIDs == "divAssignerType") { divAssignerType.Visible = true; }
                if (txtDocIDs == "divAssignedBy") { divAssignedBy.Visible = true; }
                if (txtDocIDs == "divAssigneeType") { divAssigneeType.Visible = true; }
                if (txtDocIDs == "divAssignedTo") { divAssignedTo.Visible = true; }
                if (txtDocIDs == "divNotifyByEmail") { divNotifyByEmail.Visible = true; }
                if (txtDocIDs == "divChargeAmount") { divChargeAmount.Visible = true; }
                if (txtDocIDs == "divStandardTask") { divStandardTask.Visible = true; }
                if (txtDocIDs == "divPlanDuration") { divPlanDuration.Visible = true; }
                if (txtDocIDs == "divPlanHours") { divPlanHours.Visible = true; }
                if (txtDocIDs == "divPlanMinutes") { divPlanMinutes.Visible = true; }
                if (txtDocIDs == "divPlanCost") { divPlanCost.Visible = true; }
                //For Buttons
                if (txtDocIDs == "btnFind") { btnFind.Visible = true; }
                if (txtDocIDs == "btnNewEditSave") { btnNewEditSave.Visible = true; }
                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }
                if (txtDocIDs == "btnAddSaveStep") { btnAddSaveStep.Visible = true; }

            }

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
            Int32 _WFTemplateID = 0;
            if (!String.IsNullOrEmpty(this.ddlTemplateName.SelectedItem.Value))
            {
                _WFTemplateID = Convert.ToInt32(this.ddlTemplateName.SelectedItem.Value);
            }

            //Cancel On Edited Existing Template before Save
            if (this.btnFind.AlternateText == "Find New WorkFlow" &&
                (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update"))
            {
                if (_WFTemplateID > 0)
                {
                    //WF Header
                    GetRecord(_WFTemplateID);

                    //WF Step
                    if (GetWFSteps(_WFTemplateID) > 0)
                    {
                        Int32 _WFStepID = Convert.ToInt32(this.hdnWFStepID.Value);
                        GetRecordWFItem(_WFStepID);
                    }

                    SetFormHeader(FORM_ON.View);
                    SetFormStep(FORM_ON.View);
                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                    this.btnAddSaveStep.Visible = true;
                }
            }

            //Cancel On New Workflow Creation before Save
            if (this.btnFind.AlternateText == "Find" && this.btnNewEditSave.Text == "Save")
            {
                InitializeFormHeaderFields();
                InitializeFormStepFields();
                InitializeGrids();

                SetFormHeader(FORM_ON.View);
                SetFormStep(FORM_ON.View);
                this.ddlTemplateName.Visible = true;
                this.txtTemplateName.Visible = false;
                this.ddlTemplateName.Focus();

                this.btnNewEditSave.Text = "New WorkFlow";
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnAddSaveStep.Visible = false;
                this.btnFind.Visible = true;
            }


            //Cancel On Edited Existing Template before Adding New Step
            if (this.btnFind.AlternateText == "Find New WorkFlow" && this.btnAddSaveStep.Text == "Save Step")
            {
                if (_WFTemplateID > 0)
                {
                    //WF Header
                    GetRecord(_WFTemplateID);

                    //WF Step
                    if (GetWFSteps(_WFTemplateID) > 0)
                    {
                        Int32 _WFStepID = Convert.ToInt32(this.hdnWFStepID.Value);
                        GetRecordWFItem(_WFStepID);
                    }




                    SetFormHeader(FORM_ON.View);
                    SetFormStep(FORM_ON.View);

                    this.btnNewEditSave.Text = "Edit";
                    this.btnAddSaveStep.Text = "Add Step";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                    this.btnNewEditSave.Visible = true;
                    this.btnAddSaveStep.Visible = true;
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
            Int32 _WFTemplateID = 0;
            if (this.ddlTemplateName.SelectedItem.Text != "-NONE-")
            {
                _WFTemplateID = Convert.ToInt32(this.ddlTemplateName.SelectedItem.Value);
            }

            if (this.btnFind.AlternateText == "Find")
            {
                //WF Header
                if (GetRecord(_WFTemplateID) > 0)
                {
                    SetFormHeader(FORM_ON.View);
                    SetFormStep(FORM_ON.View);
                    //WF Step
                    if (GetWFSteps(_WFTemplateID) > 0)
                    {
                        Int32 _WFStepID = Convert.ToInt32(this.hdnWFStepID.Value);
                        GetRecordWFItem(_WFStepID);
                    }

                    this.btnFind.AlternateText = "Find New WorkFlow";
                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                    this.btnAddSaveStep.Visible = true;



                }
                else
                {
                    InitializeFormHeaderFields();
                    InitializeFormStepFields();
                    InitializeGrids();

                    SetFormHeader(FORM_ON.View);
                    SetFormStep(FORM_ON.View);

                    this.ddlTemplateName.Visible = true;
                    this.txtTemplateName.Visible = false;
                    this.ddlTemplateName.Focus();

                    lblStatus.Text = "A workflow could not be located or created.";
                }
            }
            else if (this.btnFind.AlternateText == "Find New WorkFlow")
            {
                InitializeFormHeaderFields();
                InitializeFormStepFields();
                InitializeGrids();

                SetFormHeader(FORM_ON.View);
                SetFormStep(FORM_ON.View);

                this.ddlTemplateName.Visible = true;
                this.txtTemplateName.Visible = false;
                this.ddlTemplateName.Focus();

                this.btnFind.AlternateText = "Find";
                this.btnNewEditSave.Text = "New WorkFlow";
                this.btnAddSaveStep.Text = "Add Step";

                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnAddSaveStep.Visible = false;
                this.btnNewEditSave.Visible = true;
                this.btnFind.PostBackUrl = "WFTemplate.aspx?SID=" + _SID + "&WFID=0";
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
            if (this.btnNewEditSave.Text == "New WorkFlow")
            {
                InitializeFormHeaderFields();
                InitializeFormStepFields();
                SetFormHeader(FORM_ON.Edit);
                SetFormStep(FORM_ON.Edit);

                this.txtAction.Visible = false;
                this.ddlAction.Visible = true;

                this.btnNewEditSave.Text = "Save";
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
                this.btnAddSaveStep.Visible = false;
                this.btnFind.Visible = false;

                this.lblWFSteps.Text = null;
                this.hdnStepMaxNumber.Value = null;
            }
            else if (this.btnNewEditSave.Text == "Edit")
            {
                SetFormHeader(FORM_ON.Edit);
                SetFormStep(FORM_ON.Edit);

                this.btnNewEditSave.Text = "Update";
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
                this.btnAddSaveStep.Visible = false;
            }
            else if (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update")
            {
                SaveWorkFlow(this.btnNewEditSave.Text);
            }
        }
        catch (Exception ex)
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
        Int32 _WFTemplateID = 0;
        if (Action == "Update" || Action == "Save Step")
        {
            if (!String.IsNullOrEmpty(this.hdnWFTemplateID.Value))
            {
                _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);
            }
            if (_WFTemplateID == 0)
            {
                throw new Exception("A [Template ID] could not be located or created. The record will not be saved.");
            }
        }

        String _WFTemplateTypeCode = null;
        if (Action == "Save Step")
        {
            _WFTemplateTypeCode = this.hdnWFTemplateTypeCode.Value;
        }
        else
        {
            _WFTemplateTypeCode = this.ddlTemplateType.SelectedItem.Value;
        }

        if (String.IsNullOrEmpty(_WFTemplateTypeCode) && this.ddlTemplateType.SelectedItem.Text == "-NONE-")
        {
            //if (Utils.IsRequiredField("WFs", "ChStatus"))
            //{
            throw new Exception("A [Template Type] could not be located or created. The record will not be saved.");
            //}
        }

        String _WFTemplateName = this.txtTemplateName.Text;
        if (String.IsNullOrEmpty(_WFTemplateName))
        {
            throw new Exception("A [Template Name] could not be located or created. The record will not be saved.");
        }

        String _TemplateDescription = null;
        if (!String.IsNullOrEmpty(this.txtDescription.Text))
        {
            _TemplateDescription = this.txtDescription.Text;
        }
        else
        {
            //if (Utils.IsRequiredField("WFs", "WFDesc"))
            //{
            // throw new Exception("A [Description] could not be located or created. The record will not be saved.");
            //}
        }

        /*** STEP FORM VALUES ***/

        Int32 _WFStepID = 0;
        String _StepActionName = null;

        if (Action == "Update")
        {
            _StepActionName = this.txtAction.Text;
            if (!String.IsNullOrEmpty(this.hdnWFStepID.Value))
            {
                _WFStepID = Convert.ToInt32(this.hdnWFStepID.Value);
            }
        }
        else
        {
            if (this.ddlAction.SelectedItem.Text != "-NONE-")
            {
                _StepActionName = this.ddlAction.SelectedItem.Text;
                _StepActionName = _StepActionName.Remove(0, _StepActionName.IndexOf("-") + 1).Trim();
            }
        }

        //if (String.IsNullOrEmpty(_StepActionName))
        //{
        //    //if (Utils.IsRequiredField("WFs", "WFClass"))
        //    //{
        //    throw new Exception("An [Action] could not be located or created. The record will not be saved.");
        //    //}
        //}

        String _StepActionTypeCode = null;
        Int32 _StepNumber = 0;
        String _RefControlCode = null;
        String _ReferenceParams = null;
        Int32 _BackStepNumber = 0;
        String _BackStatusCode = null;
        Int32 _NextStepNumber = 0;
        String _NextStatusCode = null;
        String _StepDescription = null;
        String _AssignByCode = null;
        Int32 _AssignByID = 0;
        String _AssignToCode = null;
        Int32 _AssignToID = 0;
        String _ChargeCode = null;
        String _StdTaskCode = null;
        Single _Duration = 0.0f;
        Int32 _Hours = 0;
        Int32 _Minutes = 0;
        Decimal _PlannedCost = Convert.ToDecimal(0.0);
        String IsEmailRequired = "0";

        if (!String.IsNullOrEmpty(_StepActionName))
        {
            //Action Type
            _StepActionTypeCode = this.hdnActionTypeCode.Value;

            //Step Number                    
            if (!String.IsNullOrEmpty(this.txtStepNumber.Text))
            {
                _StepNumber = Convert.ToInt32(this.txtStepNumber.Text);
            }

            //Reference Control Code                    
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

            //Reference Parameters
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
            //if (!String.IsNullOrEmpty(this.txtBackStep.Text))
            //{
            //    _BackStepNumber = Convert.ToInt32(this.txtBackStep.Text);
            //}
            if (this.ddlBackStep.SelectedItem.Text != "-NONE-")
            {
                _BackStepNumber = Convert.ToInt32(this.ddlBackStep.SelectedValue);
            }

            //Back Step Status
            if (this.ddlBackStatus.SelectedItem.Text != "-NONE-")
            {
                _BackStatusCode = this.ddlBackStatus.SelectedItem.Value;
            }
            else
            {
                //if (Utils.IsRequiredField("WFs", "ProjNum"))
                //{
                //throw new Exception("A [Back Status] could not be located or created. The record will not be saved.");
                //}
            }

            //Next Step Number
            //if (!String.IsNullOrEmpty(this.txtNextStep.Text))
            //{
            //    _NextStepNumber = Convert.ToInt32(this.txtNextStep.Text);
            //}
            if (!String.IsNullOrEmpty(this.ddlNextStep.SelectedValue))
            {
                _NextStepNumber = Convert.ToInt32(this.ddlNextStep.SelectedValue);
            }

            //Next Step Status                    
            if (this.ddlNextStatus.SelectedItem.Text != "-NONE-")
            {
                _NextStatusCode = this.ddlNextStatus.SelectedItem.Value;
            }
            else
            {
                //if (Utils.IsRequiredField("WFs", "ProjNum"))
                //{
                //throw new Exception("A [Next Status] could not be located or created. The record will not be saved.");
                //}
            }

            _StepDescription = this.txtStepDescription.Text;
            _AssignByCode = this.hdnAssignerType.Value;
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

            _AssignToCode = this.hdnAssigneeType.Value;
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

            if (this.cbNotifyByEmail.Checked)
            {
                IsEmailRequired = "-1";
            }
            else
            {
                IsEmailRequired = "0";
            }

            _ChargeCode = this.txtChargeAccount.Text;
            _StdTaskCode = this.hdnStdTaskCode.Value;

            if (!String.IsNullOrEmpty(this.txtPlanDuration.Text))
            {
                _Duration = Convert.ToSingle(this.txtPlanDuration.Text);
            }
            else
            {
                //if (Utils.IsRequiredField("Projects", "EstHours"))
                //{
                //    throw new Exception("The [Estimated Hours] could not be located or created. The record will not be saved.");
                //}
            }

            if (!String.IsNullOrEmpty(this.txtPlanHours.Text))
            {
                _Hours = Convert.ToInt32(this.txtPlanHours.Text);
            }

            if (!String.IsNullOrEmpty(this.txtPlanMinutes.Text))
            {
                _Minutes = Convert.ToInt32(this.txtPlanMinutes.Text);
            }

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
        }

        //Update
        if (Action == "Update")
        {
            //Update Header
            DataAccess.ModifyRecords(DataQueries.UpdateWFlowTemplate(_WFTemplateID, _WFTemplateName, _WFTemplateTypeCode, _TemplateDescription));

            if (!String.IsNullOrEmpty(_StepActionName))
            {
                //Update Step
                DataAccess.ModifyRecords(DataQueries.UpdateWFlowTempItems(_WFTemplateID, _StepActionName, _StepActionTypeCode, _StepNumber,
                                                                          _NextStepNumber, _NextStatusCode, _BackStepNumber, _BackStatusCode,
                                                                          _StepDescription, _StdTaskCode, _ChargeCode, _Duration, _Hours,
                                                                          _Minutes, _PlannedCost, _AssignByCode, _AssignByID, _AssignToCode,
                                                                          _AssignToID, _RefControlCode, _ReferenceParams, IsEmailRequired,
                                                                          _WFStepID));
            }
        }

        //Save
        if (Action == "Save" || Action == "Save Step")
        {

            if (Action == "Save")
            {
                //Insert Header
                DataAccess.ModifyRecords(DataQueries.InsertWFlowTemplate(_WFTemplateName, _WFTemplateTypeCode, _TemplateDescription));

                //Get the ID               
                using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetWFlowTemplateMaxID()))
                {
                    _WFTemplateID = Convert.ToInt32(_tempNewID.Rows[0]["MaxID"].ToString());
                }
            }


            if (!String.IsNullOrEmpty(_StepActionName))
            {
                //Insert Step
                DataAccess.ModifyRecords(DataQueries.InsertWFlowTempItems(_WFTemplateID, _StepActionName, _StepActionTypeCode, _StepNumber,
                                                                          _NextStepNumber, _NextStatusCode, _BackStepNumber, _BackStatusCode,
                                                                          _StepDescription, _StdTaskCode, _ChargeCode, _Duration, _Hours,
                                                                          _Minutes, _PlannedCost, _AssignByCode, _AssignByID, _AssignToCode,
                                                                          _AssignToID, _RefControlCode, _ReferenceParams, IsEmailRequired));

                //Get the ID               
                using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetWFlowTempItemsMaxID()))
                {
                    _WFStepID = Convert.ToInt32(_tempNewID.Rows[0]["MaxID"].ToString());
                }
            }
        }

        //WF Header
        GetRecord(_WFTemplateID);

        //WF Step
        if (GetWFSteps(_WFTemplateID) > 0)
        {
            GetRecordWFItem(_WFStepID);
        }



        SetFormHeader(FORM_ON.View);
        SetFormStep(FORM_ON.View);

        this.btnFind.AlternateText = "Find New WorkFlow";
        this.btnAddSaveStep.Text = "Add Step";
        this.btnNewEditSave.Text = "Edit";
        this.btnCancel.Visible = false;
        this.btnDelete.Visible = true;
        this.btnNewEditSave.Visible = true;
        this.btnAddSaveStep.Visible = true;
        this.btnFind.Visible = true;
    }

    /// <summary>
    /// Add a New Step to the existing workflow
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAddSaveStep_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.btnAddSaveStep.Text == "Save Step")
            {
                SaveWorkFlow(this.btnAddSaveStep.Text);
            }
            else
            {
                InitializeFormStepFields();
                SetFormStep(FORM_ON.Edit);

                this.txtAction.Visible = false;
                this.ddlAction.Visible = true;

                this.btnAddSaveStep.Text = "Save Step";
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
                this.btnNewEditSave.Visible = false;
                this.lblWFSteps.Text = null;
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

    /// <summary>
    /// Delete WF Template and Associated Records
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            Int32 _WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);
            String _WFTemplateName = this.txtTemplateName.Text;

            Boolean _DeleteRecordsPref = false;
            String _DeletePreference = this.Request.Form["hdnDeleteUserPref"];
            if (!String.IsNullOrEmpty(_DeletePreference))
            {
                _DeleteRecordsPref = Convert.ToBoolean(_DeletePreference);
            }

            if (_DeleteRecordsPref)
            {
                DataAccess.ModifyRecords(DataQueries.DeleteWFlowTempItemsByTemplateID(_WFTemplateID));
                DataAccess.ModifyRecords(DataQueries.DeleteWFlowTemplateByID(_WFTemplateID));

                InitializeFormHeaderFields();
                InitializeFormStepFields();
                InitializeGrids();

                SetFormHeader(FORM_ON.View);
                SetFormStep(FORM_ON.View);

                this.ddlTemplateName.Visible = true;
                this.txtTemplateName.Visible = false;
                this.ddlTemplateName.Focus();

                this.btnNewEditSave.Text = "New WorkFlow";
                this.btnFind.AlternateText = "Find";
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnAddSaveStep.Visible = false;
                this.btnFind.Visible = true;

                this.lblStatus.Text = "Success ! WorkFlow " + _WFTemplateName + " and its associated steps are deleted ";
            }
            else
            {
                GetWFSteps(_WFTemplateID);
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// Action Selected
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlAction_SelectedIndexChanged(object sender, EventArgs e)
    {
        Int32 _WFActionID = 0;
        if (this.ddlAction.SelectedItem.Text != "-NONE-")
        {
            _WFActionID = Convert.ToInt32(this.ddlAction.SelectedItem.Value);
            GetRecordAction(_WFActionID);
        }
    }

    /// <summary>
    /// On Reference Control Selection pull BackStatus and NextStatus List
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlRefControl_SelectedIndexChanged(object sender, EventArgs e)
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
                    this.hdnWFTemplateTypeCode.Value = _tempViewWFs.Rows[0]["Type Code"].ToString();
                    this.txtDescription.Text = _tempViewWFs.Rows[0]["Description"].ToString();
                    this.hdnWFTemplateID.Value = WFTemplateID.ToString();
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
    /// Get Step Record on ActionID
    /// </summary>
    /// <param name="ActionID"></param>
    /// <returns></returns>
    private Int32 GetRecordAction(Int32 ActionID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFActions(ActionID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.txtAction.Text = _tempViewWFs.Rows[0]["WFAction Name"].ToString();
                    this.txtActionType.Text = _tempViewWFs.Rows[0]["WFAction Type Name"].ToString();
                    this.hdnActionTypeCode.Value = _tempViewWFs.Rows[0]["WFAction Type Code"].ToString();

                    if (String.IsNullOrEmpty(this.hdnStepMaxNumber.Value))
                    {
                        this.txtStepNumber.Text = "1";
                    }
                    else
                    {
                        this.txtStepNumber.Text = Convert.ToString(Convert.ToInt32(this.hdnStepMaxNumber.Value) + 1);
                    }

                    this.txtStepDescription.Text = _tempViewWFs.Rows[0]["Description"].ToString();

                    this.txtAssignerType.Text = _tempViewWFs.Rows[0]["Assign By Type"].ToString();
                    String _AssignByCode = _tempViewWFs.Rows[0]["Assign By Code"].ToString();
                    this.hdnAssignerType.Value = _AssignByCode;

                    if (!String.IsNullOrEmpty(_AssignByCode))
                    {
                        this.ddlAssignedBy.DataSource = Utils.GetAssignTypeList(_AssignByCode);
                        this.ddlAssignedBy.DataTextField = "Description";
                        this.ddlAssignedBy.DataValueField = "ID";
                        this.ddlAssignedBy.DataBind();
                    }

                    String _AssignBy = _tempViewWFs.Rows[0]["Assign By ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignBy))
                    {
                        this.ddlAssignedBy.SelectedValue = _AssignBy;
                    }

                    this.txtAssigneeType.Text = _tempViewWFs.Rows[0]["Assign To Type"].ToString();
                    String _AssignToCode = _tempViewWFs.Rows[0]["Assign To Code"].ToString();
                    this.hdnAssigneeType.Value = _AssignToCode;

                    if (!String.IsNullOrEmpty(_AssignToCode))
                    {
                        this.ddlAssignedTo.DataSource = Utils.GetAssignTypeList(_AssignToCode);
                        this.ddlAssignedTo.DataTextField = "Description";
                        this.ddlAssignedTo.DataValueField = "ID";
                        this.ddlAssignedTo.DataBind();
                    }

                    String _AssignTo = _tempViewWFs.Rows[0]["Assign To ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignTo))
                    {
                        this.ddlAssignedTo.SelectedValue = _AssignTo;
                    }

                    this.txtRefControl.Text = _tempViewWFs.Rows[0]["Control Reference Description"].ToString();

                    String _ControlRefCode = _tempViewWFs.Rows[0]["Control Reference Code"].ToString();
                    this.hdnControlReferenceCode.Value = _ControlRefCode;

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

                    this.txtChargeAccount.Text = _tempViewWFs.Rows[0]["Charge Account"].ToString();
                    this.txtStandardTask.Text = _tempViewWFs.Rows[0]["Task Description"].ToString();
                    this.hdnStdTaskCode.Value = _tempViewWFs.Rows[0]["Standard Task Code"].ToString();

                    this.txtPlanDuration.Text = _tempViewWFs.Rows[0]["Duration"].ToString();
                    this.txtPlanHours.Text = _tempViewWFs.Rows[0]["Hours"].ToString();
                    this.txtPlanMinutes.Text = _tempViewWFs.Rows[0]["Minutes"].ToString();

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
    /// Get WF Step Record
    /// </summary>
    /// <param name="ActionID"></param>
    /// <returns></returns>
    private Int32 GetRecordWFItem(Int32 WFStepID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFTItemsByItemID(WFStepID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.hdnWFStepID.Value = WFStepID.ToString();
                    this.txtAction.Text = _tempViewWFs.Rows[0]["WFAction Name"].ToString();
                    this.txtActionType.Text = _tempViewWFs.Rows[0]["WFAction Type Name"].ToString();
                    this.hdnActionTypeCode.Value = _tempViewWFs.Rows[0]["WFAction Type Code"].ToString();
                    this.txtStepNumber.Text = _tempViewWFs.Rows[0]["Step"].ToString();

                    //this.txtBackStep.Text = _tempViewWFs.Rows[0]["Back Step"].ToString();
                    if (Convert.ToInt32(_tempViewWFs.Rows[0]["Back Step"]) > 0)
                    {
                        this.ddlBackStep.SelectedValue = _tempViewWFs.Rows[0]["Back Step"].ToString();
                    }

                    //this.txtNextStep.Text = _tempViewWFs.Rows[0]["Next Step"].ToString();
                    if (Convert.ToInt32(_tempViewWFs.Rows[0]["Next Step"]) > 0)
                    {
                        this.ddlNextStep.SelectedValue = _tempViewWFs.Rows[0]["Next Step"].ToString();
                    }



                    this.txtStepDescription.Text = _tempViewWFs.Rows[0]["Description"].ToString();

                    this.txtAssignerType.Text = _tempViewWFs.Rows[0]["Assign By Type"].ToString();
                    String _AssignByCode = _tempViewWFs.Rows[0]["Assign By Code"].ToString();
                    this.hdnAssignerType.Value = _AssignByCode;

                    String _AssignBy = _tempViewWFs.Rows[0]["Assign By ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignBy))
                    {
                        Int32 _AssignByID = Convert.ToInt32(_AssignBy);
                        this.txtAssignedBy.Text = Utils.GetAssignTypeName(_AssignByCode, _AssignByID);
                    }

                    this.txtAssigneeType.Text = _tempViewWFs.Rows[0]["Assign To Type"].ToString();
                    String _AssignToCode = _tempViewWFs.Rows[0]["Assign To Code"].ToString();
                    this.hdnAssigneeType.Value = _AssignToCode;

                    String _AssignTo = _tempViewWFs.Rows[0]["Assign To ID"].ToString();
                    if (!String.IsNullOrEmpty(_AssignTo))
                    {
                        Int32 _AssignToID = Convert.ToInt32(_AssignTo);
                        this.txtAssignedTo.Text = Utils.GetAssignTypeName(_AssignToCode, _AssignToID);
                    }

                    this.txtRefControl.Text = _tempViewWFs.Rows[0]["Control Reference Description"].ToString();

                    String _ControlRefCode = _tempViewWFs.Rows[0]["Control Reference Code"].ToString();
                    this.hdnControlReferenceCode.Value = _ControlRefCode;

                    String _NextStatusCode = _tempViewWFs.Rows[0]["Next Step Status"].ToString();
                    String _BackStatusCode = _tempViewWFs.Rows[0]["Back Step Status"].ToString();

                    this.txtNextStatus.Text = Utils.GetControlRefDescription(_ControlRefCode, _NextStatusCode, null);
                    this.txtBackStatus.Text = Utils.GetControlRefDescription(_ControlRefCode, _BackStatusCode, null);


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

                    this.txtChargeAccount.Text = _tempViewWFs.Rows[0]["Charge Account"].ToString();
                    this.txtStandardTask.Text = _tempViewWFs.Rows[0]["Task Description"].ToString();
                    this.hdnStdTaskCode.Value = _tempViewWFs.Rows[0]["Standard Task Code"].ToString();

                    this.txtPlanDuration.Text = _tempViewWFs.Rows[0]["Duration"].ToString();
                    this.txtPlanHours.Text = _tempViewWFs.Rows[0]["Hours"].ToString();
                    this.txtPlanMinutes.Text = _tempViewWFs.Rows[0]["Minutes"].ToString();

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
    /// Get WorkFlow Steps
    /// </summary>
    /// <param name="WFTemplateID"></param>
    /// <returns></returns>
    private Int32 GetWFSteps(Int32 WFTemplateID)
    {
        Int32 _rowCount = 0;

        try
        {
            this.gvWFSteps.AutoGenerateDeleteButton = true;
            this.gvWFSteps.AutoGenerateSelectButton = true;
            this.gvWFSteps.EnableViewState = false;
            this.gvWFSteps.Controls.Clear();

            using (DataTable _tempWFSteps = DataAccess.GetRecords(DataQueries.GetViewWFTItemsByTemplateID(WFTemplateID)))
            {
                _rowCount = _tempWFSteps.Rows.Count;

                if (_rowCount > 0)
                {
                    this.lblWFSteps.Text = null;
                    this.gvWFSteps.DataSource = _tempWFSteps;
                    this.gvWFSteps.DataBind();
                    this.hdnWFStepID.Value = this.gvWFSteps.Rows[0].Cells[1].Text;
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
    /// WorkFlow Steps Row Delete
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFSteps_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Int32 WFTemplateID = Convert.ToInt32(this.hdnWFTemplateID.Value);
        Int32 _WFStepID = 0;

        GetWFSteps(WFTemplateID);

        if (gvWFSteps.Rows.Count < 1)
        {
            e.Cancel = true;
        }
        else
        {
            _WFStepID = Convert.ToInt32(gvWFSteps.Rows[e.RowIndex].Cells[1].Text);
            DataAccess.ModifyRecords(DataQueries.DeleteWFlowTempItemsByID(_WFStepID));
        }

        if (GetWFSteps(WFTemplateID) > 0)
        {
            _WFStepID = Convert.ToInt32(this.hdnWFStepID.Value);
            GetRecordWFItem(_WFStepID);
        }
    }

    /// <summary>
    /// WorkFlow Steps Row Select
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFSteps_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        Int32 _colTemplateIDIndex = 1;
        Int32 _selectedRowIndex = e.NewSelectedIndex;

        Int32 _WFTemplateID = 0;
        if (this.ddlTemplateName.SelectedItem.Text != "-NONE-")
        {
            _WFTemplateID = Convert.ToInt32(this.ddlTemplateName.SelectedItem.Value);
        }

        GetWFSteps(_WFTemplateID);

        if (gvWFSteps.Rows.Count <= 1)
        {
            e.Cancel = true;
        }
        else
        {
            Int32 _WFStepID = Convert.ToInt32(gvWFSteps.Rows[_selectedRowIndex].Cells[_colTemplateIDIndex].Text);

            if (GetRecordWFItem(_WFStepID) > 0)
            {
                SetFormHeader(FORM_ON.View);
                SetFormStep(FORM_ON.View);
            }
        }
    }

    /// <summary>
    /// WorkFlow Steps Row Bound
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvWFSteps_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        Int32 _colDeleteIndex = 0;
        Int32 _colSelectIndex = 0;
        Int32 _colTemplateIDIndex = 1;
        Int32 _colTemplateIndex = 2;

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
            Int32 _colStepIndex = drvADocs.DataView.Table.Columns["Step"].Ordinal + 1;
            Int32 _colActionIndex = drvADocs.DataView.Table.Columns["Action Name"].Ordinal + 1;
            Int32 _colNStepIndex = drvADocs.DataView.Table.Columns["Next Step"].Ordinal + 1;
            Int32 _colBStepIndex = drvADocs.DataView.Table.Columns["Back Step"].Ordinal + 1;
            Int32 _colActionTypeIndex = drvADocs.DataView.Table.Columns["Action Type"].Ordinal + 1;

            //Delete Button
            using (LinkButton lbDelete = (LinkButton)e.Row.Cells[_colDeleteIndex].Controls[0])
            {
                lbDelete.Text = "<img height=15 width=15 border=0 src=../App_Themes/delete.gif />";
            }

            //Align
            e.Row.Cells[_colDeleteIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colSelectIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colActionIndex].HorizontalAlign = HorizontalAlign.Left;
            e.Row.Cells[_colNStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colBStepIndex].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[_colActionTypeIndex].HorizontalAlign = HorizontalAlign.Left;

            //Get Max Step Number
            this.hdnStepMaxNumber.Value = e.Row.Cells[_colStepIndex].Text;
        }
    }

    /// <summary>
    /// Initialize Header Form
    /// </summary>
    private void InitializeFormHeaderFields()
    {
        this.txtTemplateName.Text = null;
        this.txtTemplateType.Text = null;
        this.txtDescription.Text = null;
        this.txtDescription.TextMode = TextBoxMode.MultiLine;
        this.txtDescription.Height = 50;

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
    }

    /// <summary>
    /// Initialize Step Form
    /// </summary>
    private void InitializeFormStepFields()
    {
        try
        {
            this.lblStatus.Text = null;
            this.lblWFSteps.Text = "Please select a workflow to view the steps associated with it.";

            this.txtAction.Text = null;
            this.txtActionType.Text = null;
            this.txtStepNumber.Text = null;
            //this.txtBackStep.Text = null;
            this.txtBackStatus.Text = null;
            //this.txtNextStep.Text = null;
            this.txtNextStatus.Text = null;
            this.txtStepDescription.Text = null;
            this.txtStepDescription.TextMode = TextBoxMode.MultiLine;
            this.txtStepDescription.Height = 50;

            this.txtAssignerType.Text = null;
            this.txtAssignedBy.Text = null;
            this.txtAssigneeType.Text = null;
            this.txtAssignedTo.Text = null;
            this.txtRefControl.Text = null;
            this.cbNotifyByEmail.Checked = false;
            this.cbNotifyByEmail.Text = "Notify by Email";

            this.cbAllowAddCRef.Checked = false;
            this.cbAllowAddCRef.Text = "Allow Edit of Ref";
            this.cbUpdateCRef.Checked = false;
            this.cbUpdateCRef.Text = "Update Ref. Status";

            this.txtChargeAccount.Text = null;
            this.txtStandardTask.Text = null;

            this.txtPlanDuration.Text = null;
            this.txtPlanHours.Text = null;
            this.txtPlanMinutes.Text = null;
            this.txtPlanCost.Text = null;

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

            //Register Script for Delete Button
            this.btnDelete.OnClientClick = "GetWFDeleteUserConf()";
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
            this.gvWFSteps.EnableViewState = false;
            this.gvWFSteps.Controls.Clear();
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
                this.txtDescription.ReadOnly = true;

                //Hide Edit Controls 
                this.ddlTemplateName.Visible = false;
                this.ddlTemplateType.Visible = false;

                //Show View Controls                
                this.txtTemplateName.Visible = true;
                this.txtTemplateType.Visible = true;

            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {

                //Reset the Read Only
                this.txtTemplateName.ReadOnly = false;
                this.txtDescription.ReadOnly = false;

                //Hide View Controls      
                this.ddlTemplateName.Visible = false;
                this.txtTemplateType.Visible = false;

                //Show Edit Controls
                this.txtTemplateName.Visible = true;
                this.ddlTemplateType.Visible = true;

                //Initialize from View Controls                
                ListItem liSelectedItem = null;

                liSelectedItem = this.ddlTemplateType.Items.FindByText(this.txtTemplateType.Text.Trim());
                this.ddlTemplateType.SelectedIndex = this.ddlTemplateType.Items.IndexOf(liSelectedItem);

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
                this.txtAction.ReadOnly = true;
                this.txtActionType.ReadOnly = true;
                this.txtStepNumber.ReadOnly = true;

                //this.txtBackStep.ReadOnly = true;
                this.ddlBackStep.Enabled = false;

                this.txtBackStatus.ReadOnly = true;

                //this.txtNextStep.ReadOnly = true;
                this.ddlNextStep.Enabled = false;

                this.txtNextStatus.ReadOnly = true;
                this.txtStepDescription.ReadOnly = true;

                this.txtAssignerType.ReadOnly = true;
                this.txtAssignedBy.ReadOnly = true;
                this.txtAssigneeType.ReadOnly = true;
                this.txtAssignedTo.ReadOnly = true;
                this.cbNotifyByEmail.Enabled = false;

                this.txtRefControl.ReadOnly = true;
                this.cbAllowAddCRef.Enabled = false;
                this.cbUpdateCRef.Enabled = false;
                this.txtChargeAccount.ReadOnly = true;
                this.txtStandardTask.ReadOnly = true;

                this.txtPlanDuration.ReadOnly = true;
                this.txtPlanHours.ReadOnly = true;
                this.txtPlanMinutes.ReadOnly = true;
                this.txtPlanCost.ReadOnly = true;

                //Hide Edit Controls 
                this.ddlAction.Visible = false;
                this.ddlBackStatus.Visible = false;
                this.ddlNextStatus.Visible = false;
                this.ddlAssignedBy.Visible = false;
                this.ddlAssignedTo.Visible = false;
                this.ddlRefControl.Visible = false;

                //Show View Controls                
                this.txtAction.Visible = true;
                this.txtBackStatus.Visible = true;
                this.txtNextStatus.Visible = true;
                this.txtAssignedBy.Visible = true;
                this.txtAssignedTo.Visible = true;
                this.txtRefControl.Visible = true;

                if (!string.IsNullOrEmpty(hdnWFTemplateID.Value))
                {
                    int WFTemplateID = Convert.ToInt32(hdnWFTemplateID.Value);

                    using (DataTable _tempWFSteps = new DataTable())
                    {
                        _tempWFSteps.Columns.Add("Step", Type.GetType("System.String"));
                        _tempWFSteps.Columns.Add("ActionName", Type.GetType("System.String"));
                        _tempWFSteps.Rows.Add("0", "-NONE-");
                        _tempWFSteps.Merge(DataAccess.GetRecords(DataQueries.GetViewWFTItemsByTemplateIDForAction(WFTemplateID)), true);

                        this.ddlBackStep.DataSource = _tempWFSteps;
                        this.ddlBackStep.DataTextField = "ActionName";
                        this.ddlBackStep.DataValueField = "Step";
                        this.ddlBackStep.DataBind();

                        this.ddlNextStep.DataSource = _tempWFSteps;
                        this.ddlNextStep.DataTextField = "ActionName";
                        this.ddlNextStep.DataValueField = "Step";
                        this.ddlNextStep.DataBind();
                    }
                }
                else
                {
                    using (DataTable _tempWFSteps = new DataTable())
                    {

                        _tempWFSteps.Columns.Add("Step", Type.GetType("System.String"));
                        _tempWFSteps.Columns.Add("ActionName", Type.GetType("System.String"));
                        _tempWFSteps.Rows.Add("0", "-NONE-");

                        this.ddlBackStep.DataSource = _tempWFSteps;
                        this.ddlBackStep.DataTextField = "ActionName";
                        this.ddlBackStep.DataValueField = "Step";
                        this.ddlBackStep.DataBind();

                        this.ddlNextStep.DataSource = _tempWFSteps;
                        this.ddlNextStep.DataTextField = "ActionName";
                        this.ddlNextStep.DataValueField = "Step";
                        this.ddlNextStep.DataBind();
                    }

                }
            }//end if - VIEW

            if (EditView == FORM_ON.Edit)
            {
                //Reset the Read Only
                this.txtStepNumber.ReadOnly = false;

                //this.txtBackStep.ReadOnly = false;
                this.ddlBackStep.Enabled = true;

                //this.txtNextStep.ReadOnly = false;
                this.ddlNextStep.Enabled = true;

                this.txtStepDescription.ReadOnly = false;
                this.cbNotifyByEmail.Enabled = true;

                this.cbAllowAddCRef.Enabled = true;
                this.cbUpdateCRef.Enabled = true;
                this.txtChargeAccount.ReadOnly = false;
                this.txtPlanDuration.ReadOnly = false;
                this.txtPlanHours.ReadOnly = false;
                this.txtPlanMinutes.ReadOnly = false;
                this.txtPlanCost.ReadOnly = false;

                //Hide View Controls      
                this.txtBackStatus.Visible = false;
                this.txtNextStatus.Visible = false;
                this.txtAssignedBy.Visible = false;
                this.txtAssignedTo.Visible = false;
                this.txtRefControl.Visible = false;

                //Show Edit Controls                                                                  
                this.ddlBackStatus.Visible = true;
                this.ddlNextStatus.Visible = true;
                this.ddlAssignedBy.Visible = true;
                this.ddlAssignedTo.Visible = true;
                this.ddlRefControl.Visible = true;

                //Initialize from View Controls                
                ListItem liSelectedItem = null;

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
                    this.ddlAssignedBy.DataSource = Utils.GetAssignTypeList(_AssignByType);
                    this.ddlAssignedBy.DataTextField = "Description";
                    this.ddlAssignedBy.DataValueField = "ID";
                    this.ddlAssignedBy.DataBind();
                }
                else
                {
                    this.ddlAssignedBy.Items.Add(new ListItem("-NONE-", "0"));
                }

                liSelectedItem = this.ddlAssignedBy.Items.FindByText(this.txtAssignedBy.Text.Trim());
                this.ddlAssignedBy.SelectedIndex = this.ddlAssignedBy.Items.IndexOf(liSelectedItem);

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

                //Back Next Step
                //if (!string.IsNullOrEmpty(hdnWFTemplateID.Value))
                //{
                //    int WFTemplateID = Convert.ToInt32(hdnWFTemplateID.Value);

                //    using (DataTable _tempWFSteps = new DataTable())
                //    {
                //        _tempWFSteps.Columns.Add("Step", Type.GetType("System.String"));
                //        _tempWFSteps.Columns.Add("ActionName", Type.GetType("System.String"));
                //        _tempWFSteps.Rows.Add("0", "-NONE-");
                //        _tempWFSteps.Merge(DataAccess.GetRecords(DataQueries.GetViewWFTItemsByTemplateIDForAction(WFTemplateID)), true);

                //        this.ddlBackStep.DataSource = _tempWFSteps;
                //        this.ddlBackStep.DataTextField = "ActionName";
                //        this.ddlBackStep.DataValueField = "Step";
                //        this.ddlBackStep.DataBind();

                //        this.ddlNextStep.DataSource = _tempWFSteps;
                //        this.ddlNextStep.DataTextField = "ActionName";
                //        this.ddlNextStep.DataValueField = "Step";
                //        this.ddlNextStep.DataBind();
                //    }
                //}
                //else
                //{
                //    using (DataTable _tempWFSteps = new DataTable())
                //    {

                //        _tempWFSteps.Columns.Add("Step", Type.GetType("System.String"));
                //        _tempWFSteps.Columns.Add("ActionName", Type.GetType("System.String"));
                //        _tempWFSteps.Rows.Add("0", "-NONE-");

                //        this.ddlBackStep.DataSource = _tempWFSteps;
                //        this.ddlBackStep.DataTextField = "ActionName";
                //        this.ddlBackStep.DataValueField = "Step";
                //        this.ddlBackStep.DataBind();

                //        this.ddlNextStep.DataSource = _tempWFSteps;
                //        this.ddlNextStep.DataTextField = "ActionName";
                //        this.ddlNextStep.DataValueField = "Step";
                //        this.ddlNextStep.DataBind();
                //    }

                //}


            } //end if - EDIT  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }

}
