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
public partial class WFManagement_WFAction : System.Web.UI.Page
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
        Int32 WFActionID = 0;  
  
        try
        {
            _SessionUser = this.Master.UserName;
            _SID = this.Master.SID; 

            //Get Action ID
            String QSWFActionID = Request.QueryString["AID"];
            if (!String.IsNullOrEmpty(QSWFActionID))
            {
                WFActionID = Convert.ToInt32(QSWFActionID);
            }

            if (!IsPostBack)
            {               
                InitializeFormFields();                
                SetForm(FORM_ON.View);
                CheckFields();
                if (GetRecord(WFActionID) > 0)
                {   
                    this.btnFind.AlternateText = "Find New Action";
                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                }
                else
                {
                    this.ddlAction.Visible = true;                    
                    this.txtAction.Visible = false;
                    this.ddlAction.Focus();                    
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

        using (DataTable _PagesGrid = DataAccess.GetRecords(DataQueries.ShowFromActionsData(18, RoleId)))
        {
            DataTable dt = _PagesGrid;
            foreach (DataRow row in dt.Rows)
            {

                string txtDocIDs = row["ControlId"].ToString();
                if (txtDocIDs == "divAction") { divAction.Visible = true; }// else { divtxtDocID.Visible = false; }
                if (txtDocIDs == "divActionType") { divActionType.Visible = true; } //else { divStatus.Visible = false; }
                if (txtDocIDs == "divActionDescription") { divActionDescription.Visible = true; } //else { divRevision.Visible = false; }
                if (txtDocIDs == "divRefControl") { divRefControl.Visible = true; } //else { divExpires.Visible = false; }
                if (txtDocIDs == "divUpdateCRef") { divUpdateCRef.Visible = true; }
                if (txtDocIDs == "divAllowAddCRef") { divAllowAddCRef.Visible = true; }
                if (txtDocIDs == "divAssignerType") { divAssignerType.Visible = true; }
                if (txtDocIDs == "divAssignedBy") { divAssignedBy.Visible = true; }
                if (txtDocIDs == "divAssigneType") { divAssigneType.Visible = true; }
                if (txtDocIDs == "divAssignedTo") { divAssignedTo.Visible = true; }
                if (txtDocIDs == "divNotifyByEmail") { divNotifyByEmail.Visible = true; }
                if (txtDocIDs == "divChargeAmount") { divChargeAmount.Visible = true; }
                if (txtDocIDs == "divStandardTask") { divStandardTask.Visible = true; }
                if (txtDocIDs == "divDurationDays") { divDurationDays.Visible = true; }
                if (txtDocIDs == "divPlanHours") { divPlanHours.Visible = true; }
                if (txtDocIDs == "divPlanMinutes") { divPlanMinutes.Visible = true; }
                if (txtDocIDs == "divPlanCost") { divPlanCost.Visible = true; }

                //For Buttons
                if (txtDocIDs == "btnFind") { btnFind.Visible = true; }
                if (txtDocIDs == "btnNewEditSave") { btnNewEditSave.Visible = true; }
                if (txtDocIDs == "btnCancel") { btnCancel.Visible = true; }
                if (txtDocIDs == "btnDelete") { btnDelete.Visible = true; }

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
            Int32 _ActionID = 0;
            if (!String.IsNullOrEmpty(this.ddlAction.SelectedItem.Value))
            {
                _ActionID = Convert.ToInt32(this.ddlAction.SelectedItem.Value);
            }

            //Cancel On Edited Existing Template before Save
            if (this.btnFind.AlternateText == "Find New Action" &&
                (this.btnNewEditSave.Text == "Save" || this.btnNewEditSave.Text == "Update"))
            {
                GetRecord(_ActionID);                
                SetForm(FORM_ON.View);
                this.btnNewEditSave.Text = "Edit";
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = true;
            }

            //Cancel On New Action Creation before Save
            if (this.btnFind.AlternateText =="Find" && this.btnNewEditSave.Text =="Save")
            {                
                InitializeFormFields();                
                
                SetForm(FORM_ON.View);
                this.ddlAction.Visible = true;                
                this.txtAction.Visible = false;
                this.ddlAction.Focus();
                
                this.btnNewEditSave.Text ="New Action";
                this.btnCancel.Visible =false;
                this.btnDelete.Visible = false;
                this.btnFind.Visible =true; 
            }
        }        
        catch(Exception ex)
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
            Int32 _ActionID = 0;
            if (this.ddlAction.SelectedItem.Text != "-NONE-")
            {
                _ActionID = Convert.ToInt32(this.ddlAction.SelectedItem.Value);                
            }

            if (this.btnFind.AlternateText =="Find")
            {               
                if(GetRecord(_ActionID) > 0)
                {   
                    SetForm(FORM_ON.View);
                    this.btnFind.AlternateText = "Find New Action";
                    this.btnNewEditSave.Text = "Edit";
                    this.btnCancel.Visible = false;
                    this.btnDelete.Visible = true;
                }
                else
                {                   
                   InitializeFormFields();
                                      
                   SetForm(FORM_ON.View);
                   this.ddlAction.Visible = true;                   
                   this.txtAction.Visible = false;
                   this.ddlAction.Focus();

                   lblStatus.Text = "An action could not be located or created.";
                }

                 
            }
            else if (this.btnFind.AlternateText == "Find New Action")
            {                
                InitializeFormFields();
                                
                SetForm(FORM_ON.View);

                this.ddlAction.Visible = true;                
                this.txtAction.Visible = false;
                this.ddlAction.Focus();                     

                this.btnFind.AlternateText ="Find";
                this.btnNewEditSave.Text ="New Action";                               
                this.btnCancel.Visible = false;
                this.btnDelete.Visible = false;
                this.btnNewEditSave.Visible = true;  
                this.btnFind.PostBackUrl = "WFAction.aspx?SID=" + _SID + "&AID=0"; 
            }
        }       
        catch(Exception ex)
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
            if (this.btnNewEditSave.Text == "New Action")
            {                
                InitializeFormFields();
                InitializeNewFormFields();
                SetForm(FORM_ON.Edit);
                SetNewForm();
            }
            else if (this.btnNewEditSave.Text == "Edit")
            {                
                SetForm(FORM_ON.Edit);
                this.btnNewEditSave.Text = "Update";
                this.btnCancel.Visible = true;
                this.btnDelete.Visible = false;
            }
            else if (this.btnNewEditSave.Text =="Save" || this.btnNewEditSave.Text == "Update")
            {
                SaveAction(this.btnNewEditSave.Text);                
            }
        }        
        catch(Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }        
    }
    
    /// <summary>
    /// Save Action
    /// </summary>
    /// <param name="Action"></param>
    private void SaveAction(String Action)
    {        
        Int32 _ActionID = 0;        
        String _ActionTypeCode = null;
        String _AssignByCode = null;        
        String _AssignToCode = null;
        String _StdTaskCode = null;

        String _ActionName = this.txtAction.Text;
        if (String.IsNullOrEmpty(_ActionName))
        {
            //if (Utils.IsRequiredField("WFs", "WFClass"))
            //{
            throw new Exception("An [Action] could not be located or created. The record will not be saved.");
            //}
        }
      
        if (Action == "Update")
        {            
            if (!String.IsNullOrEmpty(this.hdnActionID.Value))
            {
                _ActionID = Convert.ToInt32(this.hdnActionID.Value);
            }            
            _ActionTypeCode = this.hdnActionTypeCode.Value;                        
            _AssignByCode = this.hdnAssignerType.Value;            
            _AssignToCode = this.hdnAssignerType.Value;
            _StdTaskCode = this.hdnStdTaskCode.Value;
        }

        if (Action == "Save")        
        {            
            if (this.ddlActionType.SelectedItem.Text != "-NONE-")
            {
                _ActionTypeCode = this.ddlActionType.SelectedItem.Value;
            }

            if (this.ddlAssignerType.SelectedItem.Text != "-NONE-")
            {
                _AssignByCode = this.ddlAssignerType.SelectedItem.Value;
            }

            if (this.ddlAssigneeType.SelectedItem.Text != "-NONE-")
            {
                _AssignToCode = this.ddlAssigneeType.SelectedItem.Value;
            }

            if (this.ddlStandardTask.SelectedItem.Text != "-NONE-")
            {
                _StdTaskCode = this.ddlStandardTask.SelectedItem.Value;
            }
        }

        if (String.IsNullOrEmpty(_StdTaskCode))
        {
            throw new Exception("A [Standard Task] could not be located or created. The record will not be saved.");
        }
        
        String _Description = this.txtActionDescription.Text;                

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

        String _ChargeCode = this.txtChargeAccount.Text;

        Single _Duration = 0.0f;
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
        
        Int32 _Hours = 0;
        if (!String.IsNullOrEmpty(this.txtPlanHours.Text))
        {
            _Hours = Convert.ToInt32(this.txtPlanHours.Text);
        }
      
        Int32 _Minutes = 0;
        if (!String.IsNullOrEmpty(this.txtPlanMinutes.Text))
        {
            _Minutes = Convert.ToInt32(this.txtPlanMinutes.Text);
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

        String IsEmailRequired;
        if (this.cbNotifyByEmail.Checked)
        {
            IsEmailRequired = "-1";
        }
        else
        {
            IsEmailRequired = "0";
        }

        
        //Update
        if (Action == "Update")
        {
            DataAccess.ModifyRecords(DataQueries.UpdateWFlowActions(_ActionName, _ActionTypeCode, _Description, _StdTaskCode, _ChargeCode,
                                                                    _Duration, _Hours, _Minutes, _PlannedCost, _AssignByCode, _AssignByID,
                                                                    _AssignToCode, _AssignToID, _RefControlCode, _ReferenceParams, IsEmailRequired,
                                                                    _ActionID));

        }

        //Save
        if (Action == "Save")
        {
            DataAccess.ModifyRecords(DataQueries.InsertWFlowActions(_ActionName, _ActionTypeCode, _Description, _StdTaskCode, _ChargeCode,
                                                                    _Duration, _Hours, _Minutes, _PlannedCost, _AssignByCode, _AssignByID,
                                                                    _AssignToCode, _AssignToID, _RefControlCode, _ReferenceParams,
                                                                    IsEmailRequired));

            //Get the ID               
            using (DataTable _tempNewID = DataAccess.GetRecords(DataQueries.GetWFlowActionsMaxID()))
            {
                _ActionID = Convert.ToInt32(_tempNewID.Rows[0]["MaxID"].ToString());
            }
        }
               
        GetRecord(_ActionID);
                
        SetForm(FORM_ON.View);
        this.btnFind.AlternateText = "Find New Action";        
        this.btnNewEditSave.Text = "Edit";
        this.btnCancel.Visible = false;
        this.btnDelete.Visible = true;         
        this.btnNewEditSave.Visible = true;         
        this.btnFind.Visible = true; 
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
            Int32 _ActionID = Convert.ToInt32(this.hdnActionID.Value);
            String _ActionName = this.txtAction.Text;
  
            DataAccess.ModifyRecords(DataQueries.DeleteWFlowActionsByID(_ActionID));
            
            InitializeFormFields();
            SetForm(FORM_ON.View);

            this.ddlAction.Visible = true;            
            this.txtAction.Visible = false;
            this.ddlAction.Focus();

            this.btnFind.AlternateText = "Find";
            this.btnNewEditSave.Text = "New Action";
            this.btnCancel.Visible = false;
            this.btnDelete.Visible = false;
            this.btnNewEditSave.Visible = true;
            this.lblStatus.Text = "Success ! Action " + _ActionName + " was deleted ";
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage     
        }
    }

    /// <summary>
    /// Assigner Type Changed
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlAssignerType_SelectedIndexChanged(object sender, EventArgs e)
    {
        String _AssignByType = this.ddlAssignerType.SelectedItem.Value;
        if (!String.IsNullOrEmpty(_AssignByType))
        {
            this.ddlAssignedBy.DataSource = Utils.GetAssignTypeList(_AssignByType);
            this.ddlAssignedBy.DataTextField = "Description";
            this.ddlAssignedBy.DataValueField = "ID";
            this.ddlAssignedBy.DataBind();
        }    
    }

    /// <summary>
    /// Assignee Type Changed
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlAssigneeType_SelectedIndexChanged(object sender, EventArgs e)
    {
        String _AssignToType = this.ddlAssigneeType.SelectedItem.Value;
        if (!String.IsNullOrEmpty(_AssignToType))
        {
            this.ddlAssignedTo.DataSource = Utils.GetAssignTypeList(_AssignToType);
            this.ddlAssignedTo.DataTextField = "Description";
            this.ddlAssignedTo.DataValueField = "ID";
            this.ddlAssignedTo.DataBind();
        }    
    }

    /// <summary>
    /// Standard Task Selection 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlStandardTask_SelectedIndexChanged(object sender, EventArgs e)
    {
        Int32 _rowCount = 0;        
        String _TaskCode = this.ddlStandardTask.SelectedItem.Value;

        using (DataTable _tempTaskDetail = DataAccess.GetRecords(DataQueries.GetStdTasksByID(_TaskCode)))
        {
            _rowCount = _tempTaskDetail.Rows.Count;

            if (_rowCount > 0)
            {
                this.txtPlanDuration.Text = "0";
                this.txtPlanDuration.Text = _tempTaskDetail.Rows[0]["Duration"].ToString();

                String PlanHours = null;
                this.txtPlanHours.Text = "0";
                this.txtPlanMinutes.Text = "0";
                PlanHours = _tempTaskDetail.Rows[0]["Hours"].ToString();               
                if (!String.IsNullOrEmpty(PlanHours))
                {
                    Char[] _Separator = new Char[] { '.' };
                    String[] arrHours = PlanHours.Split(_Separator);

                    this.txtPlanHours.Text = arrHours[0];
                    if (arrHours.Length > 1)
                    {
                        this.txtPlanMinutes.Text = Convert.ToString(Convert.ToInt32(arrHours[1]) * 6);
                    }
                }                
            }
        }        
    }
    
    /// <summary>
    /// Get Record on ActionID
    /// </summary>
    /// <param name="ActionID"></param>
    /// <returns></returns>
    private Int32 GetRecord(Int32 ActionID)
    {
        Int32 _rowCount = 0;

        try
        {
            using (DataTable _tempViewWFs = DataAccess.GetRecords(DataQueries.GetViewWFActions(ActionID)))
            {
                _rowCount = _tempViewWFs.Rows.Count;

                if (_rowCount > 0)
                {
                    this.hdnActionID.Value = ActionID.ToString();
                    this.txtAction.Text = _tempViewWFs.Rows[0]["WFAction Name"].ToString();                    
                    this.txtActionType.Text = _tempViewWFs.Rows[0]["WFAction Type Name"].ToString();
                    this.hdnActionTypeCode.Value = _tempViewWFs.Rows[0]["WFAction Type Code"].ToString();
                    this.txtActionDescription.Text = _tempViewWFs.Rows[0]["Description"].ToString();

                    this.txtAssignerType.Text = _tempViewWFs.Rows[0]["Assign By Type"].ToString();
                    String _AssignByCode = _tempViewWFs.Rows[0]["Assign By Code"].ToString();
                    Int32 _AssignByID = 0;
                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["Assign By ID"].ToString()))
                    {
                        _AssignByID = Convert.ToInt32(_tempViewWFs.Rows[0]["Assign By ID"].ToString());
                    }
                    this.hdnAssignerType.Value = _AssignByCode;
                                       
                    if (!String.IsNullOrEmpty(_AssignByCode))
                    {
                        this.ddlAssignedBy.DataSource = Utils.GetAssignTypeList(_AssignByCode);
                        this.ddlAssignedBy.DataTextField = "Description";
                        this.ddlAssignedBy.DataValueField = "ID";
                        this.ddlAssignedBy.DataBind();
                    }
                    this.txtAssignedBy.Text = Utils.GetAssignTypeName(_AssignByCode, _AssignByID);

                    this.txtAssigneeType.Text = _tempViewWFs.Rows[0]["Assign To Type"].ToString();
                    String _AssignToCode = _tempViewWFs.Rows[0]["Assign To Code"].ToString();
                    Int32 _AssignToID = 0;
                    if (!String.IsNullOrEmpty(_tempViewWFs.Rows[0]["Assign To ID"].ToString()))
                    {
                        _AssignToID = Convert.ToInt32(_tempViewWFs.Rows[0]["Assign To ID"].ToString());
                    }                    
                    this.hdnAssigneeType.Value = _AssignToCode;
                       
                    if (!String.IsNullOrEmpty(_AssignToCode))
                    {
                        this.ddlAssignedTo.DataSource = Utils.GetAssignTypeList(_AssignToCode);
                        this.ddlAssignedTo.DataTextField = "Description";
                        this.ddlAssignedTo.DataValueField = "ID";
                        this.ddlAssignedTo.DataBind();
                    }
                    this.txtAssignedTo.Text = Utils.GetAssignTypeName(_AssignToCode, _AssignToID);
                    
                    this.txtRefControl.Text = _tempViewWFs.Rows[0]["Control Reference Description"].ToString();
                    String _ControlRefCode = _tempViewWFs.Rows[0]["Control Reference Code"].ToString();                                       
                    
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
    /// Initialize Action Form
    /// </summary>
    private void InitializeFormFields()
    {
        try
        {
            this.lblStatus.Text = null;
                        
            this.txtAction.Text = null;
            this.txtActionType.Text = null;
          
            this.txtActionDescription.Text = null;
            this.txtActionDescription.TextMode = TextBoxMode.MultiLine;
            this.txtActionDescription.Height = 50;

            this.txtAssignerType.Text = null;
            this.txtAssignedBy.Text = null;
            this.txtAssigneeType.Text = null;
            this.txtAssignedTo.Text = null;
            this.cbNotifyByEmail.Checked = false;
            this.cbNotifyByEmail.Text = "Notify by Email"; 
            this.txtRefControl.Text = null;
            
            this.cbAllowAddCRef.Checked = false;
            this.cbAllowAddCRef.Text = "Allow Edit of Ref."; 
            this.cbUpdateCRef.Checked = false;
            this.cbUpdateCRef.Text = "Update Ref. Status"; 
  
            this.txtChargeAccount.Text = null;
            this.txtStandardTask.Text = null;

            this.txtPlanDuration.Text = null;
            this.txtPlanHours.Text = null;
            this.txtPlanMinutes.Text = null;
            this.txtPlanCost.Text = null;                
           
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
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }
    }
    
    /// <summary>
    /// Initialize New Form
    /// </summary>
    private void InitializeNewFormFields()
    {        
        this.hdnAssignerType.Value = null;
        this.hdnAssigneeType.Value = null;
        this.hdnActionTypeCode.Value = null;
        this.hdnStdTaskCode.Value = null; 

        using (DataTable _tempActionType = new DataTable())
        {
            _tempActionType.Columns.Add("Code", Type.GetType("System.String"));
            _tempActionType.Columns.Add("Description", Type.GetType("System.String"));
            _tempActionType.Rows.Add("-NONE-", "-NONE-");
            _tempActionType.Merge(DataAccess.GetRecords(DataQueries.GetStdOptionsByType("WFActType")), true);
            this.ddlActionType.DataSource = _tempActionType;
            this.ddlActionType.DataTextField = "Description";
            this.ddlActionType.DataValueField = "Code";
            this.ddlActionType.DataBind();
        }

        this.ddlAssignerType.AutoPostBack = true;  
        using (DataTable _tempAssignerType = new DataTable())
        {
            _tempAssignerType.Columns.Add("Code", Type.GetType("System.String"));
            _tempAssignerType.Columns.Add("Description", Type.GetType("System.String"));
            _tempAssignerType.Rows.Add("-NONE-", "-NONE-");
            _tempAssignerType.Merge(DataAccess.GetRecords(DataQueries.GetViewWFGroupType()), true);
            this.ddlAssignerType.DataSource = _tempAssignerType;
            this.ddlAssignerType.DataTextField = "Description";
            this.ddlAssignerType.DataValueField = "Code";
            this.ddlAssignerType.DataBind();
        }

        this.ddlAssigneeType.AutoPostBack = true;  
        using (DataTable _tempAssigneeType = new DataTable())
        {
            _tempAssigneeType.Columns.Add("Code", Type.GetType("System.String"));
            _tempAssigneeType.Columns.Add("Description", Type.GetType("System.String"));
            _tempAssigneeType.Rows.Add("-NONE-", "-NONE-");
            _tempAssigneeType.Merge(DataAccess.GetRecords(DataQueries.GetViewWFGroupType()), true);
            this.ddlAssigneeType.DataSource = _tempAssigneeType;
            this.ddlAssigneeType.DataTextField = "Description";
            this.ddlAssigneeType.DataValueField = "Code";
            this.ddlAssigneeType.DataBind();
        }

        this.ddlStandardTask.AutoPostBack = true; 
        using (DataTable _tempStandardTask = new DataTable())
        {
            _tempStandardTask.Columns.Add("Code", Type.GetType("System.String"));
            _tempStandardTask.Columns.Add("Description", Type.GetType("System.String"));
            _tempStandardTask.Rows.Add("-NONE-", "-NONE-");
            _tempStandardTask.Merge(DataAccess.GetRecords(DataQueries.GetStdTasks()), true);
            this.ddlStandardTask.DataSource = _tempStandardTask;
            this.ddlStandardTask.DataTextField = "Description";
            this.ddlStandardTask.DataValueField = "Code";
            this.ddlStandardTask.DataBind();
        }
    }
         
    /// <summary>
    /// Set Form to Edit or View
    /// </summary>
    /// <param name="EditView"></param>
    private void SetForm(FORM_ON EditView)
    {
        try
        {
            if (EditView == FORM_ON.View)
            {               

                //Set Read Only        
                this.txtAction.ReadOnly =true;
                this.txtActionType.ReadOnly =true;            
                this.txtActionDescription.ReadOnly = true;

                this.txtAssignerType.ReadOnly = true;
                this.txtAssignedBy.ReadOnly = true;
                this.txtAssigneeType.ReadOnly = true;
                this.txtAssignedTo.ReadOnly = true;
                this.cbNotifyByEmail.Enabled = false; 

                this.txtRefControl.ReadOnly =true;
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
                this.ddlAssignedBy.Visible = false;
                this.ddlAssignedTo.Visible = false;
                this.ddlRefControl.Visible = false;
                this.ddlAssignerType.Visible = false;
                this.ddlAssigneeType.Visible = false;
                this.ddlActionType.Visible = false;
                this.ddlStandardTask.Visible = false;  
                                
                //Show View Controls                
                this.txtAction.Visible = true;
                this.txtAssignedBy.Visible = true;
                this.txtAssignedTo.Visible = true;
                this.txtRefControl.Visible = true;
                this.txtAssignerType.Visible = true;
                this.txtAssigneeType.Visible = true;
                this.txtActionType.Visible = true;
                this.txtStandardTask.Visible = true; 
 
            }//end if - VIEW

            if (EditView ==FORM_ON.Edit)
            {
                
                //Reset the Read Only      
                this.txtAction.ReadOnly = false;
                this.txtActionDescription.ReadOnly = false;

                this.cbNotifyByEmail.Enabled = true; 
                this.cbAllowAddCRef.Enabled = true;
                this.cbUpdateCRef.Enabled = true;                
                this.txtChargeAccount.ReadOnly = false;                
                this.txtPlanDuration.ReadOnly = false;
                this.txtPlanHours.ReadOnly = false;
                this.txtPlanMinutes.ReadOnly = false;
                this.txtPlanCost.ReadOnly = false;
                                
                //Hide View Controls    
                this.txtAssignedBy.Visible = false;                
                this.txtAssignedTo.Visible = false;              
                this.txtRefControl.Visible = false;

                //Show Edit Controls    
                this.ddlAssignedBy.Visible = true;
                this.ddlAssignedTo.Visible = true;
                this.ddlRefControl.Visible = true;

                //Initialize from View Controls                
                ListItem liSelectedItem = null;   

                liSelectedItem = this.ddlRefControl.Items.FindByText(this.txtRefControl.Text.Trim());
                this.ddlRefControl.SelectedIndex = this.ddlRefControl.Items.IndexOf(liSelectedItem);

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

            } //end if - EDIT  
        }
        catch (Exception ex)
        {
            lblStatus.Text = ex.Message; //Log the messsage    
        }       
    }

    /// <summary>
    /// Set New Form
    /// </summary>
    private void SetNewForm()
    {
        //Show New Form Controls
        this.txtAction.Visible = true;
        this.ddlActionType.Visible = true;
        this.ddlAssignerType.Visible = true;
        this.ddlAssigneeType.Visible = true;
        this.ddlStandardTask.Visible = true;

        //Hide View Controls
        this.ddlAction.Visible = false;
        this.txtActionType.Visible = false;        
        this.txtAssignerType.Visible = false;
        this.txtAssigneeType.Visible = false;
        this.txtStandardTask.Visible = false;
        
        this.btnNewEditSave.Text = "Save";
        this.btnCancel.Visible = true;
        this.btnFind.Visible = false;
    }
   
}
                